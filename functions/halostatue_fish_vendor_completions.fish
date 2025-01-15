# @halostatue/fish-vendor-completions/functions/halostatue_fish_vendor_completions.fish:v1.1.1

function halostatue_fish_vendor_completions --description 'Manage generated fish completions'
    argparse h/help -- $argv
    or return 1

    if set --query _flag_help || ! set --query argv[1]
        echo 'usage: halostatue_fish_vendor_completions subcommand [args...]
       halostatue_fish_vendor_completions -h|--help

Manage vendor completions.

Subcommand
  status                       Shows the current save status
  save        on | off         Enables or disables vendor completion saving
  clean                        Cleans saved vendor completions.
  refresh                      Forces a vendor completion refresh.
'
        return 0
    end

    switch $argv[1]
        case status
            if set --query --universal halostatue_fish_vendor_completions_save
                echo 'Vendor completion saving enabled.'
            else
                echo 'Vendor completion saving disabled.'
            end

        case save
            switch $argv[2]
                case on
                    set --universal halostatue_fish_vendor_completions_save 1
                    echo 'Vendor completion saving enabled.'
                case off
                    set --erase --universal halostatue_fish_vendor_completions_save
                    echo 'Vendor completion saving disabled.'
                case '*'
                    echo >&2 "Unknown save option '$argv[2]'"
            end

        case clean
            for completion in $halostatue_fish_vendor_completions_list
                test -f $halostatue_fish_vendor_completions_d/$completion.fish
                and command rm -f $halostatue_fish_vendor_completions_d/$completion.fish
            end

            echo 'Cleaned.'
        case refresh
            set --local name halostatue_fish_vendor_completions.fish

            set --local candidates \
                $__fish_config_dir/conf.d/$name \
                $__fish_sysconf_dir/conf.d/$name \
                $__fish_vendor_confdirs/$name

            set candidates (path filter --type file --perm read  $candidates)

            test (count $candidates) -lt 1
            and return 0

            set --local conf $candidates[1]
            set --universal halostatue_fish_vendor_completions_d_clean 1
            set --global halostatue_fish_vendor_completions_refresh 1
            source $conf
            set --erase halostatue_fish_vendor_completions_refresh 1

            echo 'Refreshed.'
    end
end
