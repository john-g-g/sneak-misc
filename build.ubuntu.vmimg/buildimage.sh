#!/bin/bash

R="saucy"           # release
MR="./roottemp"     # mounted root
RI="./raw.img"      # raw image
VGN="vmvg0"         # volume group name
DSIZE="8G"          # disk size

DATE="$(date +%Y%m%d)"
LOOPDEV="/dev/loop5"
LDBASE="$(basename $LOOPDEV)"
ROOTPW="7c493cc530734f4c11e00bcecadb7b73"

function detect_local_mirror () {
    AL="$(avahi-browse -p -t -r _ubuntumirror._tcp | grep '^=' | head -1)"
    UM=""
    if [ -n "$AL" ]; then
        NAME="$(echo \"$AL\" | cut -d\; -f 8)"
        PORT="$(echo \"$AL\" | cut -d\; -f 9)"
        UM="http://${NAME}:${PORT}/ubuntu/"
    fi
    if [ -z "$UM" ]; then
        echo "http://archive.ubuntu.com/ubuntu/"
    else 
        echo "$UM"
    fi
}

UM="$(detect_local_mirror)"

set -e
dd if=/dev/zero of=$RI bs=1 count=0 seek=$DSIZE
parted -s $RI mklabel msdos
parted -a optimal $RI mkpart primary 0% 200MiB
parted -a optimal $RI mkpart primary 200MiB 100%
parted $RI set 1 boot on
losetup $LOOPDEV $RI
kpartx -av $LOOPDEV
mkfs.ext4 -L BOOT /dev/mapper/${LDBASE}p1
tune2fs -c -1 /dev/mapper/${LDBASE}p1
pvcreate /dev/mapper/${LDBASE}p2
vgcreate $VGN /dev/mapper/${LDBASE}p2
lvcreate -l 100%FREE -n root $VGN
mkfs.ext4 -L ROOT /dev/$VGN/root
mkdir -p $MR
mount /dev/$VGN/root $MR
mkdir $MR/boot
mount /dev/mapper/${LDBASE}p1 $MR/boot

# install base:
debootstrap --arch amd64 $R $MR $UM

# temporary config for install:
RPS="main restricted multiverse universe"
echo "deb $UM $R $RPS" > $MR/etc/apt/sources.list
for P in updates backports security ; do
    echo "deb $UM $R-$P $RPS" >> $MR/etc/apt/sources.list
done

cp /etc/resolv.conf $MR/etc/resolv.conf

cat > $MR/etc/environment <<EOF
PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
LANGUAGE="en_US:en"
LANG="en_US.UTF-8"
ROOT_IMAGE_BUILD_DATE="$DATE"
EOF

chroot $MR locale-gen en_US.UTF-8
chroot $MR dpkg-reconfigure locales

echo 'cd /dev && MAKEDEV generic 2>/dev/null' | chroot $MR 

BUUID="$(blkid -s UUID -o value /dev/mapper/${LDBASE}p1)"
RUUID="$(blkid -s UUID -o value /dev/${VGN}/root)"

# this has to come before packages:
cat > $MR/etc/fstab <<EOF
proc                    /proc proc defaults                  0  0
/dev/mapper/$VGN-root   /     ext4 noatime,errors=remount-ro 0  1
UUID=$BUUID             /boot ext4 noatime                   0  2
EOF

cat > $MR/etc/network/interfaces <<EOF
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet dhcp
EOF
HOSTNAME="${R}64-$DATE"
echo "$HOSTNAME" > $MR/etc/hostname

cat > $MR/etc/hosts <<EOF
127.0.0.1 localhost
127.0.1.1 $HOSTNAME
::1     localhost ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
ff02::3 ip6-allhosts
EOF

#### install and update packages

mount --bind /proc $MR/proc
mount --bind /dev $MR/dev
mount --bind /sys $MR/sys

chroot $MR <<EOF
export DEBIAN_FRONTEND=noninteractive
export RUNLEVEL=1 apt-get -y update

PACKAGES="
    linux-image-server
    lvm2
    acpid
    avahi-utils
"
apt-get -y install \$PACKAGES
EOF

echo "GRUB_CMDLINE_LINUX_DEFAULT=\"text serial=tty0 console=ttyS0\"" \
    >> $MR/etc/default/grub
echo "GRUB_SERIAL_COMMAND=\"serial --unit=0 --speed=9600 --stop=1\"" \
    >> $MR/etc/default/grub
echo "GRUB_TERMINAL=\"serial\"" >> $MR/etc/default/grub
echo "GRUB_GFXPAYLOAD=\"text\"" >> $MR/etc/default/grub

chroot $MR /bin/bash -c "echo \"root:$ROOTPW\" | chpasswd"

chroot $MR update-grub 2> /dev/null
chroot $MR grub-mkconfig -o /boot/grub/grub.cfg 2> /dev/null
cat > $MR/boot/grub/device.map <<EOF
(hd0)   ${LOOPDEV}
EOF
chroot $MR grub-install ${LOOPDEV} 2> /dev/null

# get rid of device.map after grub is installed...
rm $MR/boot/grub/device.map

chroot $MR update-initramfs -d -k all
# for some stupid reason, -k all doesn't work after removing:
KERN="$(cd $MR/boot && ls vmlinuz*)"
VER="${KERN#vmlinuz-}"
chroot $MR update-initramfs -c -k $VER

cat > $MR/etc/init/ttyS0.conf <<EOF
# ttyS0 - getty
# run a getty on the serial console
start on stopped rc or RUNLEVEL=[12345]
stop on runlevel [!12345]
respawn
exec /sbin/getty -L 115200 ttyS0 vt102
EOF

# update all packages on the system
chroot $MR /bin/bash -c \
    "DEBIAN_FRONTEND=noninteractive RUNLEVEL=1 apt-get -y upgrade"

#####################################################
### Local Modifications
#####################################################

# install ssh key
mkdir -p $MR/root/.ssh
cp /root/.ssh/authorized_keys $MR/root/.ssh/

# clean apt cache
rm $MR/var/cache/apt/archives/*.deb

# set dist apt source:
RPS="main restricted multiverse universe"
MURL="mirror://mirrors.ubuntu.com/mirrors.txt"
echo "deb $MURL $R $RPS" > $MR/etc/apt/sources.list
for P in updates backports security ; do
    echo "deb $MURL $R-$P $RPS" >> $MR/etc/apt/sources.list
done

# clear issue
echo "clear > /etc/issue" | chroot $MR

# run firstboot on boot if exists
echo "if test -x /firstboot.sh ; then /firstboot.sh ; fi" \
    >> $MR/etc/rc.local

# write firstboot file
cat > $MR/firstboot.sh <<EOF
#!/bin/bash
apt-get update
apt-get -y install openssh-server
rm /firstboot.sh
EOF
chmod +x $MR/firstboot.sh

#####################################################
### Clean Up and Write Image
#####################################################

echo "******************************************************"
echo "*** Almost done.  Cleaning up..."
echo "******************************************************"

set +e
while grep roottemp /proc/mounts ; do
    for MP in $(cat /proc/mounts | grep roottemp | awk '{print $2}') ; do
        umount -l $MP
    done
    sleep 1
done
set -e

rmdir $MR
vgchange -a n $VGN
kpartx -dv $LOOPDEV
losetup -d $LOOPDEV

qemu-img convert -f raw -O qcow2 $RI ${R}64.qcow2 && rm $RI
sync
echo "******************************************************"
echo "*** Image generation completed successfully."
echo "*** output: ${R}64.qcow2"
echo "******************************************************"
