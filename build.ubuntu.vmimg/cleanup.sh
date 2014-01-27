#!/bin/bash
MR="./mr"
L="/dev/loop5"
losetup -d /dev/loop6
umount $MR/sys
umount $MR/proc
umount $MR/dev
umount $MR/boot
umount $MR
vgchange -a n vmvg0
kpartx -dv $L
losetup -d $L
rm -rf mr raw.img
