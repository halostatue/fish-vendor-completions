# @halostatue/fish-vendor-completions/conf.d/halostatue_fish_vendor_completions.fish:v2.0.0-beta.1



if status is-interactive || test "$halostatue_fish_vendor_completions_refresh" = 1
    set --local _hfvc_tag (random)(random)
    set --local _hfvc_save 0
    set --query halostatue_fish_vendor_completions_save
    and set _hfvc_save $halostatue_fish_vendor_completions_save

    function _hfvc{$_hfvc_tag}_init --inherit-variable _hfvc_save
        test "$_hfvc_save" = 1
        or return 0

        if set --query --universal halostatue_fish_vendor_completions_d
            test -z $halostatue_fish_vendor_completions_d
            and return 1

            mkdir -p $halostatue_fish_vendor_completions_d
        else
            set --function vc_d $HOME/.local/share/fish/vendor_completions.d

            if ! test -z $XDG_DATA_HOME
                set vc_d $XDG_DATA_HOME/fish/vendor_completions.d
            end

            set --global halostatue_fish_vendor_completions_d $vc_d
        end

        # Ensure that $halostatue_fish_vendor_completions_d exists.
        mkdir -p $halostatue_fish_vendor_completions_d
    end

    if ! _hfvc{$_hfvc_tag}_init
        functions --erase (functions --all | string match --regex --entire _hfvc{$_hfvc_tag})
        return 0
    end

    function _hfvc{$_hfvc_tag}_newer
        set --function full $argv[1]
        set --function name (path basename $full).fish
        set --erase argv[1]

        for arg in (path filter --type file --perm read $argv/$name)
            test $full -nt $arg || return 1
        end

        test $full -nt $halostatue_fish_vendor_completions_d/$name
    end

    function _hfvc{$_hfvc_tag} --inherit-variable _hfvc_tag --inherit-variable _hfvc_save
        argparse --ignore-unknown --min-args 1 p/python -- $argv
        or return 1

        set --function _hfvc_newer _hfvc{$_hfvc_tag}_newer

        set --function cmd $argv[1]
        set --append halostatue_fish_vendor_completions_list $cmd

        set --query --universal halostatue_fish_vendor_completions_d_clean
        and test -f $halostatue_fish_vendor_completions_d/$cmd.fish
        and command rm -f $halostatue_fish_vendor_completions_d/$cmd.fish

        # If the command cannot be found, we are done here.
        set --function fullcmd (command --search $cmd)
        or return 1

        set --erase argv[1]

        set --function vendor_completions (
            string match --all --entire vendor_completions.d $fish_complete_path
        )

        set --function output $halostatue_fish_vendor_completions_d/$cmd.fish

        if set --query _flag_python
            command --query python
            or return 1

            set --function py (
                python -c "import os; import sys; print(os.path.realpath(sys.executable))" |
                    path dirname
            )

            test -z $py
            and return 1

            test -x $py/register-python-argcomplete
            or return 1

            if test "$_hfvc_save" != 1
                $py/register-python-argcomplete --shell fish $cmd | source
            else if $_hfvc_newer $fullcmd $vendor_completions
                $py/register-python-argcomplete --shell fish $cmd >$output
            end
        else if test "$_hfvc_save" != 1
            # Some commands require special overrides, so switch on `$cmd`.
            switch $cmd
                case '*'
                    $cmd $argv
            end | source
        else if $_hfvc_newer $fullcmd $vendor_completions
            # Some commands require special overrides, so switch on `$cmd`.
            switch $cmd
                case atuin
                    $cmd $argv --out-dir $halostatue_fish_vendor_completions_d
                case '*'
                    $cmd $argv >$output
            end
        end
    end

    set --global halostatue_fish_vendor_completions_list

    _hfvc{$_hfvc_tag} atuin gen-completions --shell fish
    _hfvc{$_hfvc_tag} chezmoi completion fish
    _hfvc{$_hfvc_tag} fd --gen-completions fish
    _hfvc{$_hfvc_tag} fnm completions --shell fish
    _hfvc{$_hfvc_tag} git-absorb --gen-completions fish
    _hfvc{$_hfvc_tag} gix generate-completions --shell fish
    _hfvc{$_hfvc_tag} hof completion fish
    _hfvc{$_hfvc_tag} just --completions fish
    _hfvc{$_hfvc_tag} op completion fish
    _hfvc{$_hfvc_tag} orbctl completion fish
    _hfvc{$_hfvc_tag} pipx --python
    _hfvc{$_hfvc_tag} pnpm completion fish
    _hfvc{$_hfvc_tag} procs --gen-completion-out fish
    _hfvc{$_hfvc_tag} prqlc shell-completion fish
    _hfvc{$_hfvc_tag} starship completions fish
    _hfvc{$_hfvc_tag} uv generate-shell-completion fish
    _hfvc{$_hfvc_tag} wezterm shell-completion --shell fish

    set --erase --universal halostatue_fish_vendor_completions_d_clean

    functions --erase (functions --all | string match --regex --entire _hfvc{$_hfvc_tag})
end

function _halostatue_fish_vendor_completions -e halostatue_fish_vendor_completions_uninstall
    set --query --universal halostatue_fish_vendor_completions_d_clean
    and set --erase --universal halostatue_fish_vendor_completions_d_clean
end
