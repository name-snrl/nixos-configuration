pkgs: with pkgs;
{
  beep = writeShellScriptBin "beep" ''
    ${pipewire}/bin/pw-cat -p ${sound-theme-freedesktop}/share/sounds/freedesktop/stereo/complete.oga
  '';

  dict = writeShellScriptBin "dict" ''
    rows=15

    # if last arg is a number, use it as arg for grep
    if [[ ''${!#} =~ ^[0-9]+$ ]]; then
        rows=''${!#}
        set -- "''${@:1:$#-1}"
    fi

    ${dict}/bin/dict "$@" | grep -m 1 -A $rows "1\."
  '';

  sf = writeShellScriptBin "sf" ''
    service="https://0x0.st"

    script_name="$(basename "$0")"
    [[ ! $* && -t 0 ]] && {
        cat <<-EOF
    	Usage: $script_name path/to/file.txt
    	       echo hello | $script_name
    	EOF
        exit
    }

    load () {
        if [[ ! -t 0 ]]; then
            ${curl}/bin/curl -F file=@- "$service"
            if [[ $* ]]; then
                echo "------------------------------"
                echo "The data from stdin were loaded"
            fi
        elif [[ -f $* ]]; then
            ${curl}/bin/curl -F file=@"$*" "$service"
        elif [[ ! -f $* ]]; then
            echo "$script_name: Argument is not a regular file" >&2
            exit 1
        else
            echo "$script_name: Unexpected error" >&2
            exit 1
        fi
    }

    result="$(load "$*")"
    echo "------------------------------"
    echo "$result"

    [[ $result =~ ^"$service"/[[:alnum:]_+-]{4} ]] && {
        echo "------------------------------"
        ${wl-clipboard}/bin/wl-copy "$result" && echo "copied: Successfully!"
    }
  '';
}
