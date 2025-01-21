# halostatue/fish-vendor-completions

> [!IMPORTANT]
>
> This is the final release of this plugin, because the more I use it, the more it feels like the wrong solution (the correct solution is to get the distribution mechanism to generate and install these files in `system/vendor_completions.d`).
>
> - Of the applications supported, only six applications (`gix`, `pipx`, `pnpm`, `procs`, `prqlc`, and `wezterm`) have no included completion scripts by MacPorts or Homebrew.
> - Of the applications supported, I no longer (or have never really) used `fnm`, `gix`, `hof`, `orbctl`, `pipx`, `starship`, and `wezterm`.
>
> For the most part, it is easier for me to open a PR to MacPorts to add the completion scripts than it is to maintain this script. So I'll be uninstalling it at the same time as I am publishing this and archiving it.


[![Version[version]](https://github.com/halostatue/fish-vendor-completions/releases)

Frequently, modern software includes subcommands to generate shell completion
scripts (such as `chezmoi completion fish`). Many of these will print them to
standard output so that they can be piped to `source` on Fish. Over time,
I have captured a number of these completion commands as part of my
`config.fish` script, but having a community-maintained version of these is
better.

## Setup (`conf.d`)

The configuration script in this repository will try to run the fish
completion generation commands for a number of programs on interactive shell
startup.

1. If a program is not present in `$PATH`, nothing happens.
2. If `$halostatue_fish_vendor_completions_save` is not `1`, the completion
   will be piped to `source` (`atuin gen-completion --shell fish | source`).
3. If `$halostatue_fish_vendor_completions_save` is `1`, the completion may
   be saved for lazy loading.

### Lazy Loading

Fish searches for completions to load lazily in the following paths (the
default value of `$fish_complete_path`).

- End-user personal completions (`$XDG_CONFIG_HOME/fish/completions`)
- System completions (`/etc/fish/completions` or
  `$fish_prefix/etc/fish/completions`)
- End-user vendor completions (`$XDG_DATA_HOME/fish/vendor_completions.d`)
- System vendor completions (`$fish_prefix/share/fish/vendor_completions.d`)
- Fish provided completions (`$fish_prefix/share/fish/completions`)
- Automatically generated man completions
  (`$XDG_DATA_HOME/fish/generated_completions`)

The `conf.d` script will compare the `mtime` for each program executable and
the completion files in any `vendor_completions.d` to see if the program is
newer than the completion file (`test program -nt completion`). If it is,
the file will be written to `$halostatue_fish_vendor_completions_d`, which
defaults to `$XDG_DATA_HOME/fish/vendor_completions.d`.

> `$fish_prefix` is relative to where `fish` is installed. For most Linux
> distributions, `$fish_prefix` would be `/usr`. On macOS, where MacPorts or
> Homebrew will typically be used to install `fish`, this would be one of
> `/opt/local`, `/opt/homebrew`, or `/usr/local`.
>
> `$XDG_CONFIG_HOME` falls back to `~/.config` and `$XDG_DATA_HOME` falls back
> to `~/.local/share` if unset.

#### Completion Path Maintenance

If lazy loading is used, it is recommended that you periodically clean the
completion path. This can be done automatically by setting the universal
variable `halostatue_fish_vendor_completions_d_clean` to any value, which will
be unset at the completion of the script.

This will remove any potentially managed completion script before update.

This can also be managed with `halostatue_fish_vendor_completions refresh`
or `halostatue_fish_vendor_completions clean`.

#### Custom Completion Path

A custom location for completions can be specified by setting
`halostatue_fish_vendor_completions_d` as a universal variable. If this is
done, it is your responsibility to ensure that `$fish_complete_path` contains
this path in the appropriate location.

## Supported Programs

- atuin
- chezmoi
- fd
- fnm
- git-absorb
- gix
- hof
- just
- mise
- op
- orbctl
- procs
- prqlc
- starship
- uv
- wezterm

## Installation

Install with [Fisher][fisher]:

```fish
fisher install halostatue/fish-vendor-completions@v1
```

### System Requirements

- [fish][fish] 3.4+

## Licence

[MIT](LICENCE.md)

[fisher]: https://github.com/jorgebucaran/fisher
[fish]: https://github.com/fish-shell/fish-shell
[version]: https://img.shields.io/github/tag/halostatue/fish-vendor-completions.svg?label=Version
