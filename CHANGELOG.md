# fish-vendor-completions Changelog

## 2.0.0 / YYYY-MM-DD

> NOTE: Until there is a release date set for this version, this should be
> considered in beta, but my tagging tooling in the `Justfile` can't handle
> pre-release tags (and I'm okay with that). It is likely that other things will
> be changing in this version.

- Removed `mise` setup into [halostatue/fish-mise][halostatue/fish-mise].

## 1.1.1 / 2025-01-15

- Modified `conf.d/halostatue_fish_vendor_completions.fish` to not exit early if
  non-interactive or refreshing, ensuring the definition of the uninstall
  function.

## 1.1.0 / 2025-01-06

- Substantial rewrite to be safer, including a new function
  (`halostatue_fish_vendor_completions`) to help manage the files.

## 1.0.2 / 2025-01-05

- Added version information to comment tags.
- Switched to long flags where possible.
- Switched to `set --function` instead of `set --local`.
- Updated documentation.
- Added tooling to the Justfile for easier release management.

## 1.0.1 / 2025-01-02

- Formatting and governance changes. `.x` tags will no longer be produced, but
  existing ones will be maintained.

## 1.0.0 / 2023-10-29

- Initial version

[halostatue/fish-mise]: https://github.com/halostatue/fish-mise
