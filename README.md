# CKAN Mod Installer GitHub Action

GitHub action that uses CKAN to install mods for building other mods.

## Usage

Adding a step like this to your build workflow will create a fake game instance at `.game`, with the requested mods installed inside it:

```yml
jobs:
  Build:
    runs-on: ubuntu-latest
    steps:
      - name: Install mod dependencies
        uses: KSP-CKAN/CKAN-ModInstaller@main
        with:
          output path: .game
          game: KSP
          game versions: 1.12.5 1.10 1.11 1.12
          mods: ProceduralParts
```

See [action.yml](action.yml) for full documentation.
