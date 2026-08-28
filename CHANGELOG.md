# Changelog

All notable changes to the Patagonia Tools mod are documented here.
The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Fixed
- Restored the welding loadout on metal-panel repairs (car doors and trunk):
  they again require a welding mask, equip the blow torch in hand, and play the
  blow-torch welding animation and sound. Moving the repairs into the
  data-driven framework had dropped this. The welding mask now shows as a
  requirement in the tooltip and blocks the action when missing.

## [1.0.0]

### Added
- Mechanics-menu actions to repair engine quality using engine parts and to
  restore the trunk, glovebox, air conditioning and emergency lights.
- Create-vehicle-key action, removing the hotwire bridge when present.
- Blank car keys spawn in mechanic workshops, garages, gas stations and
  dealerships.

<!--
How to keep this file (see the pz-mods skill):
- Add every user-facing change under "## [Unreleased]" as you work, grouped in
  Added / Changed / Fixed / Removed / Deprecated / Security.
- On release, rename "[Unreleased]" to the new version and match `modversion`
  in `42/mod.info`. Bump: MAJOR = breaking, MINOR = feature, PATCH = fix.
-->
