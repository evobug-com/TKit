<div align="center">

<img src="Assets/Icon512x512.png" alt="TKit Logo" width="200"/>

# TKit - Twitch Toolkit

**Automatically update your Twitch category based on what you're doing**

[![Latest Release](https://img.shields.io/github/v/release/evobug-com/TKit?label=Stable&color=brightgreen&style=flat-square)](https://github.com/evobug-com/TKit/releases/latest)
[![Latest Pre-release](https://img.shields.io/github/v/release/evobug-com/TKit?include_prereleases&label=Pre-release&color=orange&style=flat-square)](https://github.com/evobug-com/TKit/releases)
[![Downloads](https://img.shields.io/github/downloads/evobug-com/TKit/total?style=flat-square&color=blue)](https://github.com/evobug-com/TKit/releases)
[![License](https://img.shields.io/github/license/evobug-com/TKit?style=flat-square)](LICENSE)

</div>

---

## 📋 Overview

TKit is a Windows desktop application that **automatically switches your Twitch stream category** based on your active window. Stop manually updating your category every time you switch games or applications - let TKit handle it for you.

**Perfect for streamers who:**
- 🎮 Switch between multiple games during streams
- 🎨 Alternate between gaming and creative work (coding, art, music)
- 😅 Forget to update categories when switching
- 📈 Want better discoverability with accurate categories

## ✨ Features

- **🔄 Automatic Category Switching** - Real-time window monitoring with instant category updates
- **🗺️ Smart Process Mapping** - Pre-seeded with popular games, searchable Twitch category database
- **⚡ Global Hotkeys** - Quick manual category updates without leaving your game
- **🌍 Multi-language Support** - 10 languages: English, Czech, Polish, Spanish, French, German, Portuguese, Japanese, Korean, Chinese
- **🔔 Desktop Notifications** - Optional alerts when categories change
- **⚙️ Configurable Behavior** - Scan intervals, debounce delays, fallback actions
- **📊 Update History** - Track all category changes with timestamps
- **🪟 System Tray Integration** - Runs quietly in the background

## 📥 Installation

### Download

<table>
<tr>
<td width="50%">

**MSIX Package** (Recommended)
- ⚡ Fast installation (no UAC prompts)
- 🔒 Runs in secure sandbox
- ✅ Automatic updates

[**→ Download MSIX**](https://github.com/evobug-com/TKit/releases/latest/download/TKit.msix)

</td>
<td width="50%">

**EXE Installer** (Traditional)
- 📦 Portable installation
- 🔧 Custom install location
- ✅ Automatic updates

[**→ Download EXE**](https://github.com/evobug-com/TKit/releases/latest/download/TKit-Setup.exe)

</td>
</tr>
</table>

<details>
<summary><b>Pre-release Channels</b></summary>

Want to test new features before they're stable?

| Channel | Description | Access |
|---------|-------------|--------|
| **Dev** | Bleeding edge, updated frequently | [Browse Dev Releases →](https://github.com/evobug-com/TKit/releases?q=prerelease%3Atrue+tag%3A*-dev.*) |
| **Beta** | Feature testing, relatively stable | [Browse Beta Releases →](https://github.com/evobug-com/TKit/releases?q=prerelease%3Atrue+tag%3A*-beta.*) |
| **RC** | Release candidates, final testing | [Browse RC Releases →](https://github.com/evobug-com/TKit/releases?q=prerelease%3Atrue+tag%3A*-rc.*) |

</details>

<details>
<summary><b>Which installer should I choose?</b></summary>

**Choose MSIX if:**
- You want the fastest installation experience
- You prefer automatic security and sandboxing
- You're on Windows 10 (1809) or later

**Choose EXE if:**
- You need a custom installation directory
- You want portable installation
- You're on an older Windows version

Both installers provide automatic updates through TKit.

</details>

### Requirements

- Windows 10 (version 1809) or later
- Twitch account with streaming privileges

## 🚀 Quick Start

1. **Download & Install** - Choose your installer from above
2. **Launch TKit** - Find it in Start Menu or Desktop
3. **Connect Twitch** - Click "Connect with Twitch" and authorize
4. **Add Mappings** - Map your games/apps to Twitch categories
5. **Start Monitoring** - Click "Start" on the Auto Switcher page

That's it! TKit will now automatically update your category as you switch windows.

## 📖 Usage Guide

### Category Mappings

Map your applications to Twitch categories:

1. Go to **Category Mappings** page
2. Click **Add Mapping**
3. Enter the process name (e.g., `League of Legends.exe`)
4. Search and select the Twitch category
5. Save and enable the mapping

💡 **Tip**: TKit comes pre-seeded with popular games!

### Auto Switcher

Control automatic category switching:

- **Start/Stop Monitoring** - Toggle automatic switching
- **Manual Update** - Force update to current window's category
- **View History** - See all category changes with timestamps

### Settings

TKit is fully configurable with options for scan intervals, debounce delays, fallback behavior, notifications, hotkeys, and update channels. Access settings from the main window or system tray.

## 🛠️ For Developers

Interested in contributing or building from source?

- **[Developer Guide](DEVELOPERS.md)** - Architecture, tech stack, building from source
- **[Contributing Guidelines](CONTRIBUTING.md)** - How to contribute
- **[Release Guide](RELEASE_GUIDE.md)** - For maintainers creating releases

## 🗺️ Roadmap

- [ ] Multi-platform support (macOS, Linux)
- [ ] Auto-update stream title and tags
- [ ] Time-based category scheduling
- [ ] Advanced mapping rules (window title, regex)
- [ ] Cloud sync for mappings
- [ ] Integration with other platforms (YouTube, Kick)

## ⚠️ Known Limitations

- Windows-only (platform-specific process detection)
- Requires browser OAuth flow for Twitch authentication
- Mappings stored locally (no cloud sync yet)

## 🤝 Support

Need help?

- 🐛 [Report issues](https://github.com/evobug-com/TKit/issues)
- 💬 [Browse existing issues](https://github.com/evobug-com/TKit/issues)
- 📝 Check logs (stored in app directory)

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Credits

Built with Flutter and inspired by the need for better stream automation tools.

Special thanks to the Twitch developer community for API documentation and support.

---

**Note**: TKit is not affiliated with or endorsed by Twitch Interactive, Inc.
