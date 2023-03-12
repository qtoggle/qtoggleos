
import asyncio
import json
import re

from qtoggleserver.system import fwupdate
from qtoggleserver.utils import process


class FWUpdateCommandError(fwupdate.FWUpdateException):
    pass


class ThingOSDriver(fwupdate.BaseDriver):
    FWUPDATE_BIN = '/sbin/fwupdate'

    async def get_current_version(self):
        return await self._call_fwupdate(['current'])

    async def get_latest(self):
        versions = await self._call_fwupdate(['latest'])
        if not versions:
            return '', '', ''

        versions = versions.split()

        # version, date, url
        return versions[0], versions[2], versions[1]

    async def get_status(self):
        s = await self._call_fwupdate(['status'])

        if s == 'idle':
            status = fwupdate.STATUS_IDLE

        elif re.match('^downloading .*$', s):
            status = fwupdate.STATUS_DOWNLOADING

        elif re.match('^downloaded .*$', s):
            status = fwupdate.STATUS_EXTRACTING

        elif re.match('^extracting .*$', s):
            status = fwupdate.STATUS_EXTRACTING

        elif re.match('^extracted .*$', s):
            status = fwupdate.STATUS_FLASHING

        elif re.match('^flashing boot .*$', s):
            status = fwupdate.STATUS_FLASHING

        elif re.match('^boot flashed .*$', s):
            status = fwupdate.STATUS_RESTARTING

        elif re.match('^rebooting .*$', s):
            status = fwupdate.STATUS_RESTARTING

        else:
            status = fwupdate.STATUS_ERROR

        return status

    async def update_to_version(self, version):
        asyncio.create_task(self._call_fwupdate(['install', version]))
        await self._wait_idle()

    async def update_to_url(self, url):
        asyncio.create_task(self._call_fwupdate(['install', url]))
        await self._wait_idle()

    async def is_auto_update_enabled(self) -> bool:
        return await self._call_fwupdate(['auto']) == 'on'

    async def set_auto_update_enabled(self, enabled: bool) -> None:
        await self._call_fwupdate(['auto', ['off', 'on'][enabled])

    async def _call_fwupdate(self, args):
        args = [self.FWUPDATE_BIN] + args
        exit_code, output, error = await process.call_subprocess(args)

        if exit_code:
            raise FWUpdateCommandError(error.decode())

        return output.strip().decode()

    async def _wait_idle(self):
        # Wait 5 seconds for verification and download start
        await asyncio.sleep(2)
        
        # Wait at most another 3 seconds for status to become non-idle
        for _ in range(3):
            output = await self._call_fwupdate(['status'])
            if output.startswith('error:'):
                raise FWUpdateCommandError(output[6:].strip())

            if output != 'idle':
                break

            await asyncio.sleep(1)

        else:
            raise FWUpdateCommandError('timeout waiting for update to begin')
