Installation
===

```bash
fdisk /dev/sda (create 2 partitions : boot & one other)
mkfs.ext2 /dev/sda1
cryptsetup luksFormat -c aes-xts-plain64 -s 512 /dev/sdax
cryptsetup luksOpen /dev/sdax lvm
pvcreate /dev/mapper/lvm
vgcreate arch /dev/mapper/lvm
lvcreate -L 3G arch -n swap
lvcreate -L 50G arch -n root
lvcreate -l +100%FREE arch -n home
mkfs.ext4 /dev/mapper/arch-root
mkfs.ext4 /dev/mapper/arch-home
mkswap /dev/mapper/arch-swap
swapon /dev/mapper/arch-swap
mount /dev/mapper/arch-root /mnt
mkdir /mnt/{boot,home}
mount /dev/sda1 /mnt/boot
mount /dev/mapper/arch-home /mnt/home
wifi-menu
pacstrap /mnt base base-devel grub os-prober sudo vim git dialog
genfstab -p /mnt >> /mnt/etc/fstab
arch-chroot /mnt
echo "hostname" > /etc/hostname
echo "KEYMAP=fr-pc" > /etc/vconsole.conf # Keyboard FR
vim /etc/locale-gen && locale-gen && echo 'LANG="en_US.UTF-8"' > /etc/locale.conf # Locale system
ln -s /usr/share/zoneinfo/Europe/Paris /etc/localtime
On /etc/mkinitcpio.conf HOOKS="... keyboard keymap encrypt lvm2 ... filesystems ..."
/etc/default/grub (GRUB_CMDLINE_LINUX="cryptdevice=/dev/sda2:lvm")
mkinitcpio -p linux
grub-mkconfig -o /boot/grub/grub.cfg
grub-install --force /dev/sda
passwd root
useradd -m -g users -G wheel -s /bin/bash <nom utilisateur>
umount -R /mnt
reboot
```

Re-installation
---

```
cryptsetup luksOpen /dev/sda4 lvm
mkfs.ext4 /dev/mapper/arch-root
mkfs.vfat -F32 /dev/sdX1
mkfs.ext2 /dev/sdX2
swapon and mount all partitions
pacstrap /mnt base base-devel grub-efi-x86_64 efibootmgr sudo vim git
etc...
```
