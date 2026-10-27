# X2Go Client Portable

Portable builds of [X2Go Client](https://wiki.x2go.org/) for Windows and Linux (AppImage).

## Changes

- **Windows**: The `x2goclient.exe` binary is patched to launch in portable mode by default. Configurations and SSH data are kept locally in `.x2goclient/` and `.x2go/` without touching the Windows Registry. Legacy bitmap fonts (`100dpi`, `75dpi`, `Speedo`, `Type1`) are removed in release archives to reduce size.
- **Linux**: Standalone AppImage packages.

## Downloads

Pre-built archives are available on the [Releases](../../releases) page:

- `x2goclient-portable-windows-4.1.2.2.7z` (25.6 MB)
- `x2goclient-portable-windows-4.1.2.2.zip` (31.7 MB)
- `x2goclient-4.1.2.2-aarch64.AppImage` (36.7 MB)

## Server Setup (Linux)

Install `x2goserver` on the remote host to enable connections:

### Ubuntu
```bash
sudo add-apt-repository -y ppa:x2go/stable
sudo apt update
sudo apt install -y x2goserver x2goserver-xsession
```

### Debian
```bash
sudo apt update && sudo apt install -y wget gnupg lsb-release
wget -q -O- https://packages.x2go.org/pub.key | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/x2go.gpg
echo "deb http://packages.x2go.org/debian $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/x2go.list
sudo apt update
sudo apt install -y x2goserver x2goserver-xsession
```

### Raspberry Pi OS
```bash
sudo apt update && sudo apt install -y wget gnupg lsb-release
wget -q -O- https://packages.x2go.org/pub.key | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/x2go.gpg
echo "deb http://packages.x2go.org/raspbian $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/x2go.list
sudo apt update
sudo apt install -y x2goserver x2goserver-xsession
```

### Server Management Commands
- `x2golistsessions` — list active sessions
- `x2gosuspend-session <session_id>` — suspend session
- `x2goterminate-session <session_id>` — terminate session
- `x2gocleansessions` — clean up stale session database

## Client CLI Arguments

- `--session="<name>"` — connect directly to a saved session
- `--hide` — start minimized to system tray
- `--maximize` — start maximized
- `--clipboard=<both|client|server|none>` — clipboard mode
- `--close-disconnect` — close client on disconnect
- `--debug` — enable debug logging

## License

GNU General Public License v2.0 (GPL-2.0).  
Official project: https://wiki.x2go.org/
