#!/bin/sh
#supports_backup in PINN

set -ex

if [ -z "$part1" ] || [ -z "$part2" ]; then
  printf "Error: missing environment variable part1 or part2\n" 1>&2
  exit 1
fi

mkdir -p /tmp/1 /tmp/2

mount "$part1" /tmp/1
mount "$part2" /tmp/2

sed /tmp/1/cmdline.txt -i -e "s|root=[^ ]*|root=${part2}|"
sed /tmp/2/etc/fstab -i -e "s|^[^#].* / |${part2}  / |"
sed /tmp/2/etc/fstab -i -e "s|^[^#].* /boot |${part1}  /boot |"

if [ -z $restore ]; then
    #No need to resize the ext4 partition if using NOOBS
    sed /tmp/1/cmdline.txt -i -e "s|init=/usr/lib/raspi-config/init_resize.sh||"
fi

umount /tmp/1
umount /tmp/2
