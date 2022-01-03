#!/bin/sh
#supports_backup in PINN

# This is just the default partition_setup.sh from Raspbian Full
# Adapt as appropriate

set -ex

# shellcheck disable=SC2154
if [ -z "$part1" ] || [ -z "$part2" ]; then
  printf "Error: missing environment variable part1 or part2\n" 1>&2cd
  exit 1
fi

mkdir -p /tmp/1 /tmp/2

mount "$part1" /tmp/1
mount "$part2" /tmp/2

sed /tmp/1/cmdline.txt -i -e "s|root=[^ ]*|root=${part2}|"
sed /tmp/2/etc/fstab -i -e "s|^[^#].*\s/\s|${part2}  / |"
sed /tmp/2/etc/fstab -i -e "s|^[^#].*\s/boot/firmware\s|${part1}  /boot/firmware |"

cp /tmp/1/config.txt /tmp/1/config.bak
awk '1;/^\[all\]/ {print "kernel=vmlinuz\ninitramfs initrd.img followkernel"}' /tmp/1/config.bak >/tmp/1/config.txt

# shellcheck disable=SC2154
if [ -z "$restore" ]; then
  if [ -f /mnt/ssh ]; then
    cp /mnt/ssh /tmp/1/
  fi

  if [ -f /mnt/ssh.txt ]; then
    cp /mnt/ssh.txt /tmp/1/
  fi

  if [ -f /settings/wpa_supplicant.conf ]; then
    cp /settings/wpa_supplicant.conf /tmp/1/
  fi

fi

umount /tmp/1
umount /tmp/2
