if [[ -d ~/.local/profile.d ]]; then
    for FN in ~/.local/profile.d/*.sh ; do
        source $FN
    done
fi
