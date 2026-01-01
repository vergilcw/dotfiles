if status is-interactive
    # enable vi mode in command editor
    fish_vi_key_bindings

    set -gx EDITOR vi
    set -gx VISUAL vi
    set -gx PAGER less

    set -gx GPG_TTY (tty)
    set -gx LANG "en_US.UTF-8"

    # dotfiles/run.sh uses ~/.local/bin as the default bin directory
    if not grep -q "ID=nixos" /etc/os-release 2>/dev/null
        set -l BIN "$HOME/.local/bin"
        if not contains $BIN $PATH
            echo "$BIN not found in PATH. Adding it..."
            set -gx PATH $BIN $PATH
        end
    end

    # check whether gh exists and gh copilot is installed
    if command -v gh > /dev/null; and gh extension list | grep -q "github/gh-copilot"
        echo "gh copilot aliases ghce and ghcs available"
        alias '??' 'gh copilot suggest -t shell'
        alias 'git?' 'gh copilot suggest -t git'
        alias 'explain' 'gh copilot explain'
        alias 'gh?' 'gh copilot suggest -t gh'
        # gh copilot alias -- fish returns the alias commands, we need to source them
        gh copilot alias -- fish | source
    end

    # Check for Copilot CLI and add ghc alias
    if command -v copilot > /dev/null
        echo "Copilot CLI alias ghc available"
        function ghc
            copilot -p (string join " " $argv) --allow-all-tools --model gpt-5-mini
        end
    end

    # Git prompt settings
    set -g __fish_git_prompt_showuntrackedfiles yes
    set -g __fish_git_prompt_showcolorhints yes
    set -g __fish_git_prompt_showdirtystate yes

    # Custom prompt to match bashrc: user@host:workdir git_status $ 
    function fish_prompt
        set_color normal
        echo -n (whoami)@(hostname):(prompt_pwd)
        fish_git_prompt
        echo -n '$ '
    end
end
