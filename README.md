# halostatue/fish-vendor-completions

Many modern pieces of software include completions code available through the
command line (such as `atuin gen-completions --shell <SHELL>`), and _most_ of
them will print them so that they can be piped to `source`. Over time, I have
captured a number of these completion commands as part of my `config.fish`
script, but having a community-maintained version of these is better.

The configuration scripts in this repository will run the completion generation
command in one of two ways, depending on whether the variable
`$halostatue_fish_vendor_completions_save` is set or not:

1. If not set (the default), the output of the completion generation command is
   piped to `source` (e.g., `atuin gen-completions --shell fish | source`).

2. If set, the `mtime` on the binary and the shell file are compared (using
   `test binary -nt completion`) and the completion file is written to
   `$XDG_DATA_HOME/fish/vendor_completions.d/<binary>.fish`.

Either action will only be taken _if_ fish is running interactively and the
command and any prerequisites (such as `register-python-argcomplete` for several
Python programs‡) are present in `$PATH` at the time of execution. They will
also only be taken only if the command is newer than any completion file that
may be found in the _vendor_ directories `$fish_complete_path`. That way, if you
have `fd` installed from MacPorts or Homebrew and `vendor_completions.d/fd.fish`
exists and is not older than `fd`, a new version will not be saved or sourced.

I personally prefer the default method, since I no longer have to worry about
whether there are completions for programs I have uninstalled. The option exists
because the use of `vendor_completions.d` allows for lazy completion loading.

> The initial implementation here is an all-or-nothing approach. It _may_ be
> possible to make `$halostatue_fish_vendor_completions_save` contain a list of
> completions that should be saved, or use a separate variable for that. This
> would allow for staged conversion.

‡ The example provided is somewhat incomplete. There is a bit more work done if
there are Python programs as `register-python-argcomplete` might actually be
called `register-python-argcomplete3.11` by a package manager (MacPorts, in this
case).

## Installation

Install with [Fisher][fisher] (recommended):

```fish
fisher install halostatue/fish-vendor-completions@v1.x
```

<details>
<summary>Not using a package manager?</summary>

---

Copy `functions/*.fish` to your fish configuration directory preserving the
directory structure.

</details>

### System Requirements

- [fish][] 3.0+

## Licence

[MIT](LICENCE.md)

[fisher]: https://github.com/jorgebucaran/fisher
[fish]: https://github.com/fish-shell/fish-shell
