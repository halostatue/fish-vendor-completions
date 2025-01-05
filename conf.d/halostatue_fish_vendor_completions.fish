# @halostatue/fish-vendor-completions/conf.d/halostatue_fish_vendor_completions.fish:v1.0.2

status is-interactive
or return 0

set --global _halostatue_fvc_completions

if set --query halostatue_fish_vendor_completions_save
    if test -n "$XDG_DATA_HOME"
        set _halostatue_fvc_completions $XDG_DATA_HOME/fish/vendor_completions.d
    else
        set _halostatue_fvc_completions ~/.local/share/fish/vendor_completions.d
    end

    test -d $_halostatue_fvc_completions
    or return
end

set _halostatue_fvc_python_bin

if command --query python
    set _halostatue_fvc_python_bin (
        python -c "import os; import sys; print(os.path.realpath(sys.executable))" |
          path dirname
    )
end

function _halostatue_fvc_newer
    set --function fullcmd $argv[1]
    set --erase argv[1]
    set --function name (basename $fullcmd).fish

    if ! set --query argv[1]
        set argv (string match --all --entire 'vendor_completions.d' $fish_complete_path)/$name
    end

    for arg in $argv
        test $fullcmd -nt $arg || return 1
    end

    return 0
end

function _halostatue_fvc_python
    test -n "$_halostatue_fvc_python_bin"
    or return

    set --function fullcmd (command --search $argv[1])
    or return

    set --function pybin (python -c "import os; import sys; print(os.path.realpath(sys.executable))")
    set pybin

    if _halostatue_fvc_newer $fullcmd
        if set --query halostatue_fish_vendor_completions_save
            set --function completion $_halostatue_fvc_completions/$argv[1].fish

            $_halostatue_fvc_python_bin/register-python-argcomplete \
                --shell fish $argv[1] >$completion
        else
            $_halostatue_fvc_python_bin/register-python-argcomplete \
                --shell fish $argv[1] | source
        end
    end
end

function _halostatue_fvc
    set --function fullcmd (command --search $argv[1])
    or return

    set --function cmd $argv[1]
    set --erase argv[1]

    if _halostatue_fvc_newer $fullcmd
        if set --query halostatue_fish_vendor_completions_save
            set --function completion $_halostatue_fvc_completions/$cmd.fish

            switch $cmd
                case atuin
                    $cmd $argv --out-dir $_halostatue_fvc_completions
                case hof
                    $cmd $argv | string replace --regex '(alias _="hof")' '#$1' >$completion
                case '*'
                    $cmd $argv >$completion
            end
        else
            switch $cmd
                case hof
                    $cmd $argv | string replace --regex '(alias _="hof")' '#$1'
                case '*'
                    $cmd $argv
            end | source
        end
    end
end

_halostatue_fvc atuin gen-completions --shell fish
_halostatue_fvc chezmoi completion fish
_halostatue_fvc fd --gen-completions fish
_halostatue_fvc fnm completions --shell fish
_halostatue_fvc git-absorb --gen-completions fish
_halostatue_fvc gix generate-completions --shell fish
_halostatue_fvc hof completion fish
_halostatue_fvc just --completions fish
_halostatue_fvc op completion fish
_halostatue_fvc orbctl completion fish
_halostatue_fvc procs --gen-completion-out fish
_halostatue_fvc prqlc shell-completion fish
_halostatue_fvc rtx completion fish
_halostatue_fvc starship completions fish
_halostatue_fvc wezterm shell-completion --shell fish

_halostatue_fvc_python pipx

functions --erase _halostatue_fvc _halostatue_fvc_python
set --erase _halostatue_fvc_completions _halostatue_fvc_python_bin
