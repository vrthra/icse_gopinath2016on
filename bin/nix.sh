nix-instantiate ./etc/shell.nix --indirect --add-root $PWD/etc/shell.drv
nix-shell --pure $PWD/etc/shell.drv
