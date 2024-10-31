cd /tmp
git clone https://gitlab.archlinux.org/archlinux/packaging/packages/rxvt-unicode.git
cd rxvt-unicode
makepkg -s --nobuild --skipint
curl -o /tmp/fix.diff https://github.com/exg/rxvt-unicode/commit/417b540d6dba67d440e3617bc2cf6d7cea1ed968.diff
cd src/rxvt-unicode-9.31/
patch --dry-run -p1  < /tmp/fix.diff
patch -p1  < /tmp/fix.diff
cd ../../
makepkg -i --noextract
cd
rm -rf /tmp/fix.diff /tmp/rxvt-unicode
