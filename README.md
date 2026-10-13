# BambaMagicKeep

Haxe/OpenFL port of the Flash game *Bamba Magic Keep*, built with [lime](https://lime.openfl.org/). Targets Windows, macOS, HashLink, and Nintendo Switch (via the [lime-nx](https://github.com/Slushi-Github/lime-nx) fork).

## Build

Install Haxe + the libs listed under `<haxelib>` in `project.xml` (`openfl`, `actuate`, `swf`, `format`, `haxeui-core`, `haxeui-openfl`), then:

```sh
haxelib run lime build windows -release   # or macos, hl, switch
haxelib run lime test windows             # build + run
```

Output lands under `Export/<target>/bin/`.

## Windows installer

See `installer/BambaMagicKeep.iss` — builds a single-file setup `.exe` with Inno Setup 6:

```powershell
iscc installer\BambaMagicKeep.iss
```

## Layout

- `Source/` — Haxe source (entry point `BambaMain`)
- `Assets/` — fonts, JSON/XML data, converted SWF art under `game_assets/`
- `project.xml` — lime build config; see inline comments for per-asset notes
- `tools/` — asset conversion helpers (fog extraction, font family rename, upscaling)
