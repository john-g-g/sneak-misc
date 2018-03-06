if [[ -d ~/.local/bashrc.d ]]; then
    for FN in ~/.local/bashrc.d/*.sh ; do
        source $FN
    done
fi
