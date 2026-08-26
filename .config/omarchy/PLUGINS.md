# Omarchy Quickshell plugins

Not tracked in this repo (each is its own upstream git clone — nesting them
here would mean vendoring their full history or fussing with submodules for
no real benefit). Reinstall on a new machine with:

```sh
mkdir -p ~/.config/omarchy/plugins
cd ~/.config/omarchy/plugins
git clone https://github.com/mtolhuys/omarchy-theme-manager.git io.github.mtolhuys.theme-manager
git clone https://github.com/ilyaZar/omarchy-syncthing.git io.github.ilyazar.syncthing
git clone https://github.com/cempack/ProtonPassPlugin.git io.github.cempack.proton-pass
git clone https://github.com/jkoestinger/omarchy-vpn.git jkoestinger.vpn
git clone https://github.com/stappmus/Omarchy-Spotify.git quickshell.spotify
git clone https://github.com/stappmus/omarchy-activity-monitor.git stappmus.activity-monitor
git clone https://github.com/mshareef-git/omavibes.git io.github.mshareef-git.omavibes
```

Bar placement/config for these lives in `shell.json`, which is intentionally
*not* tracked (it carries live session state — Spotify auth/search history,
scroll positions, etc.). So after cloning, placement doesn't come back
automatically — see the `omarchy bar move`/`omarchy bar put` commands in
SETUP.md step 11.

Commit pinned per plugin in case a later upstream version misbehaves —
`git checkout <sha>` after cloning if needed. Refreshed 2026-08-26 (originally
recorded 2026-08-15 at initial install; update this table whenever you
deliberately pull a plugin forward, since it's otherwise easy to leave stale):

| plugin id | repo | commit |
|---|---|---|
| io.github.mtolhuys.theme-manager | mtolhuys/omarchy-theme-manager | `116eab89a89a5b2b7c5ed333b1baacf4f9f00ac2` |
| io.github.ilyazar.syncthing | ilyaZar/omarchy-syncthing | `9454b414c771f68d210c5c245585bda9d0415840` |
| io.github.cempack.proton-pass | cempack/ProtonPassPlugin | `b55d9ffbd9716aa5253b112f273086152b534324` |
| jkoestinger.vpn | jkoestinger/omarchy-vpn | `c94454d857f28a6421212ecc121317f7171db5a4` |
| quickshell.spotify | stappmus/Omarchy-Spotify | `7b31c59b943ab4fce2546de238c432febb0938b1` |
| stappmus.activity-monitor | stappmus/omarchy-activity-monitor | `0d42706355ab1ec922b2820a1bbf4a8314820f57` |
| io.github.mshareef-git.omavibes | mshareef-git/omavibes | `79ad1155d6606c85fd3828825961c321decc4f4a` |
