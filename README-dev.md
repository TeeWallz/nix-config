

```bash
nix-shell -p gitMinimal vim nano joe
sudo su
git clone https://github.com/TeeWallz/nix-config.git

export DISK='/dev/disk/by-id/ata-QEMU_HARDDISK_QM00003'
export INST_PARTSIZE_SWAP=4
./hosts/common/optional/zfs-optin-persistence-disks/zfs-optin-persistence.sh 

nixos-install --flake .#zamorak

```