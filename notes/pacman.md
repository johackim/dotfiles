Cheat Sheet Pacman
===

Synchronize
---

`pacman -Sy`             # synchronize repository databases if neccessary
`pacman -Syy`            # force synchronization of repository databases
 
Search
---

`pacman -Ss <package>`   # search repository database for packages for xyz
`pacman -Ql <package>`   # show all files installed by the package xyz
`pacman -Qs <package>`   # Search paquets installed
`pacman -Qi <package>`   # View informations of package
`pacman -Qo /path`       # find the package which installed the file at /path
`pacman -Qe`             # List package
 
Install
---

`pacman -S xyz`          # install package xyz
`pacman -Sy xyz`         # synchronize repo and install xyz
`pacman -Syy xyz`        # really synchronize repo and install xyz

Remove
---
 
`pacman -R xyz`          # remove package xyz but keep its dependencies installed
`pacman -Rs xyz`         # remove package xyz and all its dependencies (if they are not required by any other package)
`pacman -Rsc xyz`        # remove package xyz, all its dependencies and packages that depend on the target package
 
Upgrade
---

`pacman -Syyu`           # Install all upgrades


By date
---

`expac --timefmt=%s '%l\t%n' | sort -n | tail -20` # List packages by date
