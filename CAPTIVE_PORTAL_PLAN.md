# Captive portal rework (temporary plan)

Remove this file once the work is done. It lives on the `captive-portal-plan` branch only.

## Problem

- `rcS` starts every `S??*` script. A service runs when its config file exists. This is the rule for all services.
- `S44hostapd` breaks the rule. With `CAPTIVE_PORTAL_ENABLED=true`, it only starts the daemon when the unit is not configured or when the button is held.
- `S45dnsmasq` follows the rule but ignores the portal. When qToggleOS ships `/etc/dnsmasq.conf`, dnsmasq always runs on `ap0`, even when no AP is up.
- The portal reuses the plain-service configs (`hostapd.conf`, `dnsmasq.conf`). So "config present" can't mean "always run".

Seen on garden-hub (qToggleOS): the unit is configured and hostapd is not running. dnsmasq still runs, and `ap0` has `192.168.27.1` with no traffic.

### Side effect in qToggleOS today

qtoggleserver's slave discovery starts its own hostapd and dnsmasq on a free `apX` interface (`qtoggleserver/system/ap/__init__.py`). It refuses to start if any `hostapd` or `dnsmasq` process runs on the host. It runs with `pid: host`, so it sees host processes. The always-on dnsmasq makes discovery fail with "The dnsmasq daemon is already running". This plan fixes that too.

## Goal

- `S44hostapd` and `S45dnsmasq` are plain services. They run only when a config file is found, like every other service.
- The captive portal is its own script. It builds its own hostapd and dnsmasq configs in `/var/run/captive-portal/`, only while the portal is up.
- The fix goes into thingos first. qToggleOS then merges it and only sets options.

## Decisions

- Fix in thingos, then merge into qToggleOS.
- Portal settings come from new variables in `captive-portal.conf`. There are no template files.
- New `S44captiveportal` script. All portal code leaves `S44hostapd`.
- No migration. Existing `/data/etc/hostapd.conf` and `/data/etc/dnsmasq.conf` become plain always-on services.
- The portal and the plain services don't run together. If a plain `hostapd.conf` or `dnsmasq.conf` is found, the portal logs a warning and doesn't start. Reason: two dnsmasq instances clash on ports 53 and 67, and two hostapd instances clash on the same interface.

## thingos changes

### 1. `board/common/overlay/etc/captive-portal.conf`

Add the new variables, with generic defaults. Keep `CAPTIVE_PORTAL_ENABLED=false`.

```
CAPTIVE_PORTAL_IFACE=${OS_AP}
CAPTIVE_PORTAL_SSID=${OS_PREFIX}-${BOARD_SN}
CAPTIVE_PORTAL_PSK=
CAPTIVE_PORTAL_IP=192.168.27.1
CAPTIVE_PORTAL_DHCP_RANGE=192.168.27.50,192.168.27.150,24h
```

- An empty `CAPTIVE_PORTAL_PSK` means an open AP. Otherwise use WPA2-PSK. hostapd needs 8 to 63 characters. If the length is wrong, `start_portal` logs an error and refuses to start (see step 3).
- `OS_PREFIX` comes from `/etc/version` (`thing` in thingos, `qtos` in qToggleOS). `OS_AP` comes from `os_conf`. `BOARD_SN` comes from `base`. All three are set by `base`.
- The variables expand when the file is sourced. So `S44captiveportal` must source `base` before `captive-portal.conf`. `S41netwatch` sources it before `base`, so the new variables are empty there. That's harmless, because it only reads `CAPTIVE_PORTAL_ENABLED` and `CAPTIVE_PORTAL_CONFIGURED_CMD`. `CAPTIVE_PORTAL_START_INPUT=${OS_FACTORY_RESET_INPUT}` already works the same way.
- Other hostapd settings stay hard-coded in the script with today's qToggleOS values: `channel=1`, `driver=nl80211`, `hw_mode=g`, `ieee80211n=1`, `ieee80211ac=1`. Add variables later if needed.

### 2. AP interface helper in `board/common/overlay/etc/init.d/base`

- Move `configure_ifaces` from `S44hostapd` into `base` as `create_ap_ifaces`. Today it sets `rfkill unblock`, waits up to 5s for `wlan*`, and adds `apN` for each `wlanN`.
- It must be safe to call twice. `iw ... interface add` already fails quietly when the interface exists.
- It waits up to 5s for a `wlan*` interface. A build that ships hostapd but has no Wi-Fi hardware gets a 5s boot delay. qToggleOS already has this delay today.
- New for thingos: builds that ship hostapd now get `ap0` even with no AP config. No thingos defconfig enables hostapd, so this only affects custom builds. qToggleOS already creates `ap0` on every board that ships hostapd (nanopir1 and all Raspberry Pi boards). radxacm3 and rockpi4b ship neither hostapd nor dnsmasq, and nothing changes for them.
- Callers:
  - `S44captiveportal start`, right after the `hostapd` binary check and before the `CAPTIVE_PORTAL_ENABLED` check. So `ap0` exists on every boot of a build that ships hostapd, with the portal on or off, as today in qToggleOS. Builds without hostapd don't get an `ap0`. qToggleOS needs it for slave discovery: `qs-ap-interface` looks for `apX` interfaces.
  - `S44hostapd start`, for plain AP mode.

### 3. New `board/common/overlay/etc/init.d/S44captiveportal`

- The order is `S44captiveportal`, `S44hostapd`, `S44shownetinfo`, `S45dnsmasq`. The portal runs after `S35wifi` and `S40network`, as it does today.
- `start` runs these steps in order:
  1. Exit if the `hostapd` binary is missing.
  2. Call `create_ap_ifaces`.
  3. Exit if `CAPTIVE_PORTAL_ENABLED` is not `true`.
  4. Exit if the `dnsmasq` binary is missing.
  5. Exit with a warning if `select_conf` finds a plain `hostapd.conf` or `dnsmasq.conf`.
- Move these from `S44hostapd`:
  - `watch_input`, `watch_button`, `get_button_value`, `read_input`
  - the `CAPTIVE_PORTAL_CONFIGURED_CMD` check and the "timeout mode" or "always-on mode" output
  - the timeout logic (`after_captive_portal_timeout`, `CAPTIVE_PORTAL_TIMEOUT_REBOOT`)
  - `S35wifi stop` and `panic inhibit`
- `start_portal`:
  1. If any `hostapd` or `dnsmasq` runs (for example qtoggleserver's discovery AP), log it and don't start. qtoggleserver uses the same check.
  2. Write `/var/run/captive-portal/hostapd.conf` and `/var/run/captive-portal/dnsmasq.conf` from the variables, with a heredoc. No `eval` is needed. The dnsmasq config gets:
     - `interface=${CAPTIVE_PORTAL_IFACE}`
     - `dhcp-range=${CAPTIVE_PORTAL_DHCP_RANGE}`
     - `dhcp-leasefile=/var/run/captive-portal/dnsmasq.leases`
     - `address=/#/${CAPTIVE_PORTAL_IP}`
  3. Stop `S35wifi` and run `panic inhibit`, as today.
  4. Turn off power save on the interface, as today. Start hostapd in the background, write its pid to `/var/run/captive-portal/hostapd.pid`, and log to `/var/log/hostapd.log`.
  5. After `sleep 1`, set `CAPTIVE_PORTAL_IP/24` on the interface. Today `assign_iface_ip` does this, because hostapd resets the IP.
  6. Start dnsmasq with `-C`, `-x /var/run/captive-portal/dnsmasq.pid` and `--log-facility=/var/log/dnsmasq.log`.
  7. Write the flag file `/var/run/captive-portal/running`.
- `stop_portal`:
  1. Kill hostapd and dnsmasq by their pid files. Never use `killall`, which would also kill qtoggleserver's discovery AP.
  2. Flush the interface IP and remove the runtime files and the flag.
  3. Don't start `S35wifi` again. This keeps today's behavior. See "Follow-ups" below.
  4. Leave `panic inhibit` alone. `panic` has no "uninhibit" command, and the inhibit ends by itself after 1h.
- `start_portal` refuses to start when another hostapd or dnsmasq runs, or when the PSK is invalid. It then returns an error. The caller must then skip the timeout. Otherwise `after_captive_portal_timeout` finds no lease and reboots a unit that never had a portal.
- `running` (used by the button watcher): check the flag file or the pid files, not `killall -0 hostapd`. Otherwise holding the button during slave discovery would "stop" qtoggleserver's AP.
- Timeout sleeper: write its pid to `/var/run/captive-portal/timeout.pid`. `stop_portal` kills it. Today the sleeper outlives a button stop. When it fires later, it finds no client and reboots the unit. Worse, if the button starts a new portal in the meantime, the old sleeper can reboot the unit in the middle of the new session.
- `after_captive_portal_timeout`: do nothing if the portal isn't running anymore. Otherwise a client connected if the lease file isn't empty. The lease file is new for each portal start, so old sessions can't count. This replaces today's `tail -n 9 dnsmasq.log | grep DHCPREQUEST`.
- `stop` skips the `start` checks, because the pid files tell it what to stop. It calls `stop_portal`, then kills the background watchers. Match on the script name, like `S41netwatch` does.
- The log files keep today's names, so `Logs.md` doesn't need new names. The portal and the plain services never run together, so they don't write to the same log at once.

### 4. `board/common/overlay/etc/init.d/S44hostapd`

- Becomes a plain service: `select_conf`, the placeholder `eval`, `create_ap_ifaces`, the power-save tweaks, start, stop.
- Remove all portal code and the `CP_CONF` source.
- Keep `assign_iface_ip`, reading the plain `/var/run/dnsmasq.conf`. In plain mode, `S45dnsmasq` sets the `ap0` IP right after `S44hostapd` starts hostapd in the background. hostapd may then reset the IP. `assign_iface_ip` sets it again after 1s. Removing it could leave a plain AP without an IP. There is a race already today: if `/var/run/dnsmasq.conf` isn't written yet after 1s, `assign_iface_ip` does nothing. This plan doesn't change that.
- Write a pid file at start. `stop` kills by pid. Today's `ps | grep hostapd | xargs kill` would also kill qtoggleserver's discovery hostapd.

### 5. `board/common/overlay/etc/init.d/S45dnsmasq`

- Becomes a plain service: `select_conf`, the placeholder `eval`, start, stop.
- Remove the `CP_CONF` source and the `address=/#/` line.
- Keep the `ifconfig ${iface} ${ip}` step. Plain AP setups (user `hostapd.conf` plus `dnsmasq.conf`) rely on it to get an IP on `ap0`, so removing it would break them.
- Write a pid file (`-x`). `stop` kills by pid, not with `killall`.

### 6. `board/common/overlay/sbin/toemmc`

- Keep `dnsmasq.conf` and `hostapd.conf` in `NET_CONFIG_FILES`. They are still valid plain-service configs.
- Add `captive-portal.conf`. The loop copies from `/data/etc/` only when the file isn't empty, so it is safe.

### 7. Unchanged, but check after the change

- `S40network` and `S41netwatch` only read `CAPTIVE_PORTAL_ENABLED` and `CAPTIVE_PORTAL_CONFIGURED_CMD`. No change needed.
- `rcK` stops scripts in reverse order: `S45dnsmasq`, `S44shownetinfo`, `S44hostapd`, `S44captiveportal`. No problem.
- `cleanup.sh:25` removes the sample `/etc/hostapd.conf` that the hostapd package installs. `cleanup.sh:215` removes the package's `S80dnsmasq`. Keep both. `cleanup.sh:25` matters more now. Without it, the sample would count as a plain `hostapd.conf`, which would start a plain AP and turn off the portal. `cleanup.sh` runs as a target-finalize hook, before the overlay is copied, so it never removes overlay files. The dnsmasq package installs no `/etc/dnsmasq.conf`.
- `/var/run` links to `/tmp` (`postscript.sh`), so the runtime folder is in RAM and gone after a reboot.

### 8. Wiki (`/home/ccrisan/Projects/thingos.wiki`)

#### `captive-portal.conf.md`

- "File Location And Role":
  - Rewrite the intro. The portal no longer uses `hostapd.conf` or `dnsmasq.conf`. It builds its own hostapd and dnsmasq configs from this file and runs both daemons only while the portal is up.
  - Keep the three bullets: it starts at boot only if the unit is not configured, it stops after a timeout, and DNS queries are redirected to the unit.
  - Add: the `hostapd` and `dnsmasq` packages must still be enabled in the build.
  - Fix the search order wording. All three files are sourced, and later ones override earlier ones. Today the page reads as if only the first match is used.
- "File Format": the file is sourced by `S44captiveportal` (plus `S40network` and `S41netwatch`), not by the `hostapd` and `dnsmasq` init scripts.
- "Available Variables": add `CAPTIVE_PORTAL_IFACE`, `CAPTIVE_PORTAL_SSID`, `CAPTIVE_PORTAL_PSK`, `CAPTIVE_PORTAL_IP` and `CAPTIVE_PORTAL_DHCP_RANGE`, with their defaults. Say that an empty PSK means an open AP, and that a PSK must be 8 to 63 characters. Say that `${var}` placeholders from [[os.conf]] and `base` work (`OS_AP`, `OS_PREFIX`, `BOARD_SN`).
- Fix `CAPTIVE_PORTAL_TIMEOUT`: say a client counts as connected once it gets a DHCP lease.
- Add a short section on runtime files: `/var/run/captive-portal/` holds the configs, pid files, the lease file and the `running` flag. Other scripts check the flag to see if the portal is up.
- Add a note: the portal won't start if a plain [[hostapd.conf]] or [[dnsmasq.conf]] is present. Use one or the other.
- Add a short example: portal on, unit counts as configured when there is a default route, and a 120s timeout.

#### `hostapd.conf.md`

- "File Location And Role": say the file always starts hostapd as a plain AP. The captive portal does not use it, and won't start while this file is present.
- Change "See also [[captive-portal.conf]]" to a sentence: for an AP that only runs while the unit is not configured, use [[captive-portal.conf]] and don't create this file.
- "Example": the text says network name `myssid`, but the example uses `${OS_PREFIX}-${BOARD_SN}`. Make them match.
- Add: the `${OS_AP}` interface is created at boot from `${OS_WLAN}`, and needs a [[dnsmasq.conf]] (or a static IP) to give it an IP.

#### `dnsmasq.conf.md`

- "File Location And Role": say the file always starts dnsmasq. The captive portal does not use it, and won't start while this file is present.
- Change "See also [[captive-portal.conf]]" the same way as on the hostapd page.
- "Example": the text says the `wlan0` interface, but the example uses `${OS_AP}`. Make them match.
- Add: the init script gives the `interface=` interface the `.1` address of the `dhcp-range` subnet. This happens today but isn't documented.
- Fix the typo: `` `HOSTNAME, `` is missing its closing backtick.

#### `Batteries-Included.md`

- "WiFi Access Point":
  - It links to `S33hostapd`, which doesn't exist. Change it to `S44hostapd`.
  - Drop "and monitors". The script does not monitor the daemon.
  - Add one line on the captive portal, with links to `S44captiveportal` and [[captive-portal.conf]].
- "DHCP Server": add one line that the captive portal runs its own dnsmasq, and link [[captive-portal.conf]].

#### No change needed

- `Logs.md`: the log file names don't change. Adding `hostapd.log` and `dnsmasq.log` to "Common Log Files" is optional.
- `_Sidebar.md`: the three pages are already listed.
- `os.conf.md`: `OS_AP` is described correctly.
- `Init-Scripts.md`: `no_S44captiveportal` works with the general `/data/etc/no_<script>` rule.
- `Configuration-Files.md`: the `/var/run` rule fits the new runtime files.

## qToggleOS changes (after the merge)

- Remove `board/common/overlay/etc/hostapd.conf` and `board/common/overlay/etc/dnsmasq.conf`.
- Set the portal variables in qToggleOS's `captive-portal.conf`, using today's values. Keep the existing ones (`ENABLED`, `TIMEOUT`, and so on).
  - `CAPTIVE_PORTAL_IFACE=${OS_AP}`
  - `CAPTIVE_PORTAL_SSID=${OS_PREFIX}-${BOARD_SN}` (gives `qtos-<serial>`, as today)
  - `CAPTIVE_PORTAL_PSK=12345678`
  - `CAPTIVE_PORTAL_IP=192.168.27.1`
  - `CAPTIVE_PORTAL_DHCP_RANGE=192.168.27.50,192.168.27.150,24h`
- `usr/libexec/qtoggleserver/qs-setup-mode`: check for the flag file, not `killall -0 hostapd`.
  - It runs inside the qtoggleserver container, with the host root at `/host`.
  - `/var/run` is an absolute link to `/tmp`, so inside the container `/host/var/run` points to the container's own `/tmp`. Checked on garden-hub.
  - So use `chroot /host /bin/bash -c 'test -f /var/run/captive-portal/running'`. `qs-wifi` already uses `chroot /host /bin/bash -c` the same way. I checked on garden-hub that `chroot` works from the container. Checking `/host/tmp/captive-portal/running` also works, but it hard-codes where the `/var/run` link points.
  - This also stops slave discovery from showing as setup mode, which happens today because any hostapd counts.
- `board/nanopir1/overlay/etc/init.d/S41netled`: check `/var/run/captive-portal/running` in `is_hostapd_running` (rename it to `is_captive_portal_running`). It runs on the host, so the normal path works.
- `qs-ap-interface`: no change. It needs `ap0` at boot, which `create_ap_ifaces` still provides.
- Release notes:
  - Existing `/data/etc/hostapd.conf` and `/data/etc/dnsmasq.conf` now run as always-on services, and they turn off the captive portal.
  - Move portal settings to `/data/etc/captive-portal.conf`.

## Testing

On a qToggleOS unit (e.g. garden-hub), after the merge:

1. Configured unit, no button press: neither hostapd nor dnsmasq runs. `ap0` exists and has no IP.
2. No default route at boot: the portal starts. A phone gets a DHCP address, and DNS resolves to `CAPTIVE_PORTAL_IP`. `qs-setup-mode` reports setup mode.
3. No client within `CAPTIVE_PORTAL_TIMEOUT`: the unit reboots. With `CAPTIVE_PORTAL_TIMEOUT_REBOOT=false`, the portal stops. Wi-Fi stays off until reboot, as today.
4. A client connects within the timeout: the portal stays up.
5. Button held for `CAPTIVE_PORTAL_START_HOLD_SECONDS`: the portal starts. Hold it again: the portal stops. Both daemons, the IP and the runtime files are gone.
6. Slave discovery on a configured unit: qtoggleserver starts its AP on `ap0` without the "already running" error. `qs-setup-mode` does not report setup mode. Holding the button meanwhile doesn't kill qtoggleserver's hostapd and doesn't start a portal.
7. The portal refuses to start (for example during discovery): no timeout is scheduled, and the unit doesn't reboot.
8. `/data/etc/hostapd.conf` and `/data/etc/dnsmasq.conf` present: both run as plain services at boot, `ap0` keeps its IP after hostapd is up, and the portal logs a warning and stays off.
9. `S44captiveportal stop` and `restart` leave no processes behind (watchers, sleeper, daemons).
10. nanopir1: the net LED blinks only while the portal is up.
11. Button stop before the timeout: the unit doesn't reboot when the old timeout would have fired. Button start again: the new session isn't cut short by the old timeout.
12. PSK shorter than 8 characters: the portal logs an error, doesn't start, and the unit doesn't reboot.

On a thingos build with `BR2_PACKAGE_HOSTAPD=y` and `BR2_PACKAGE_DNSMASQ=y` added (no thingos defconfig enables them):

13. No AP configs, portal off: `ap0` is created, and Wi-Fi as a station still works.
14. User `hostapd.conf` and `dnsmasq.conf`, portal off: the plain AP works and clients get an address.

## Follow-ups (not part of this change)

- Wi-Fi after the portal stops. `start_portal` stops `S35wifi`, and nothing starts it again. After a button stop, or a timeout with `CAPTIVE_PORTAL_TIMEOUT_REBOOT=false`, the unit has no Wi-Fi until reboot. This is today's behavior. A fix needs more than `S35wifi start`:
  - `S35wifi start` blocks until it connects, for up to `LINK_WATCH_TIMEOUT`.
  - It only starts `wpa_supplicant`. The `dhclient` for `wlan0` comes from `S40network`.
  - It must not run from `S44captiveportal stop` at shutdown. `rcK` runs that before `S35wifi stop`.
  - Its link watcher may call `panic action` while `panic inhibit` is still on.
- `panic` has no "uninhibit" command. The inhibit ends by itself after 1h.
