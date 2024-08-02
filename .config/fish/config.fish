if status is-interactive
    function fish_greeting
    end
end

# Starship theme
starship init fish | source

# Zoxide + FZF
zoxide init fish | source
fzf --fish | source

# Set-up icons for files/folders in terminal using eza
alias ls 'eza -a --icons'
alias ll 'eza -alh --icons'
alias lt 'eza -a --tree --level=1 --icons'

# Copy contents of a file to clipboard
function fcopy
    bat $argv[1] | wl-copy
end

# cp rm mv abbr
abbr cp "cp -vi"
abbr mv "mv -vi"
abbr rm "rm -vi"

# Command typo helper
function fk
    thefuck $history[1] | source
end

# Global extraction command
function ex
    if test -f $argv[1]
        switch $argv[1]
            case '*.tar.bz2'
                tar xjf $argv[1]
            case '*.tar.gz'
                tar xzf $argv[1]
            case '*.bz2'
                bunzip2 $argv[1]
            case '*.rar'
                unrar x $argv[1]
            case '*.gz'
                gunzip $argv[1]
            case '*.tar'
                tar xf $argv[1]
            case '*.tbz2'
                tar xjf $argv[1]
            case '*.tgz'
                tar xzf $argv[1]
            case '*.zip'
                unzip $argv[1]
            case '*.Z'
                uncompress $argv[1]
            case '*.7z'
                7z x $argv[1]
            case '*.deb'
                ar x $argv[1]
            case '*.tar.xz'
                tar xf $argv[1]
            case '*'
                echo "'$argv[1]' cannot be extracted via ex()"
        end
    else
        echo "'$argv[1]' is not a valid file"
    end
end

# yazi shell wrapper
function yy
	set tmp (mktemp -t "yazi-cwd.XXXXXX")
	yazi $argv --cwd-file="$tmp"
	if set cwd (cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
		cd -- "$cwd"
	end
	rm -f -- "$tmp"
end

set -gx EDITOR micro

fish_add_path /home/careb0t/.spicetify
