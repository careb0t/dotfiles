# Omarchy Quickshell plugins

Not tracked in this repo (each is its own upstream git clone — nesting them
here would mean vendoring their full history or fussing with submodules for
no real benefit). Reinstall on a new machine with:

```sh
mkdir -p ~/.config/omarchy/plugins
cd ~/.config/omarchy/plugins
git clone https://github.com/ilyaZar/omarchy-syncthing.git io.github.ilyazar.syncthing
git clone https://github.com/cempack/ProtonPassPlugin.git io.github.cempack.proton-pass
git clone https://github.com/jkoestinger/omarchy-vpn.git jkoestinger.vpn
git clone https://github.com/stappmus/Omarchy-Spotify.git quickshell.spotify
git clone https://github.com/stappmus/omarchy-activity-monitor.git stappmus.activity-monitor
```

Bar placement/config for these lives in `shell.json` (tracked, see
`../omarchy/shell.json`), so once cloned the bar picks them back up as-is.

Installed as of 2026-08-15 (commit pinned per plugin in case a later upstream
version misbehaves — `git checkout <sha>` after cloning if needed):

| plugin id | repo | commit |
|---|---|---|
| io.github.ilyazar.syncthing | ilyaZar/omarchy-syncthing | `aac0700c1b845759a05fca591a6c178cccd207ba` |
| io.github.cempack.proton-pass | cempack/ProtonPassPlugin | `8f6cf2a68b6d80ffaace7041492c609197e05191` |
| jkoestinger.vpn | jkoestinger/omarchy-vpn | `1b97b9e5384d0b5f5abbec4f5978f7fe8dd4d3db` |
| quickshell.spotify | stappmus/Omarchy-Spotify | `4e75fd6eaf52eddd4b8d6506e842f320cfcdde8d` |
| stappmus.activity-monitor | stappmus/omarchy-activity-monitor | `dc36c57b9cb046adbd2177c428d3b6863c188880` |
