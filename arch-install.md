Arch Linux Installation (LVM+LUKS)
===

> WARNING! ONLY FOR MY PERSONAL USE, DON'T USE IT !!

```bash
# Create new partitions
# WARNING! This will removed your device irrevocably!
make create-new-partitions
```

```bash
# Install new Arch Linux
# WARNING! This will overwrite root,boot,efi partitions irrevocably!
make install-new-arch
```

```bash
# Configure Arch Linux
make configure-arch
```

```bash
# Configure user
make chroot
make add-new-user
make configure-user
```
