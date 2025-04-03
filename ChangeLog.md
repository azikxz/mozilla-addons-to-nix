# Revision history for Mozilla Add-ons to Nix

## Version 0.13.0 (2025-08-20)

* Handle 404 errors similar to 401 errors. That is, log it and skip
  the add-on.

* Support adding known vulnerabilities to the add-on specification.
  The content should be a list of strings, which is passed on
  unchanged to the `meta.knownVulnerabilities` package field.

## Version 0.12.0 (2024-04-19)

* Enable a little bit of concurrency when fetching add-on information.
  To avoid hammering the servers too much, we limit the number of
  concurrent fetches to two.

## Version 0.11.0 (2024-01-19)

* Handle 401 Unauthorized errors from the Mozilla add-on API. This
  error occurs quite often and typically means that the add-on has
  been removed or made private. When this happens we simply log the
  fact and omit the add-on from the output.

* Update dependencies and build files.

## Version 0.10.0 (2023-08-21)

* Write the add-on permissions to the package meta data. This is
  intended to allow asserting that the package won't introduce
  unexpected permissions.

## Version 0.9.0 (2022-07-30)

* Rename project to "Mozilla Add-ons to Nix" and executable to
  `mozilla-addons-to-nix`.

* Switch to a fully Nix Flake development setup, use `nix develop` to
  enter a suitable development environment. The old `default.nix` and
  `shell.nix` files have been removed.

* Move project to sourcehut. The old GitLab location has been
  archived.

## Version 0.8.1 (2021-08-09)

* Bump relude version lower bound, from 0.4 to 1.0.

* Bump hnix version lower bound, from 0.5 to 0.13.

* Add flake.nix file.
