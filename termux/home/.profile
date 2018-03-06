export PS1="pixelbook:\w\\$ "
if [[ "$HOME" != "/home" ]]; then
    exec termux-chroot
fi
