{ config, lib, pkgs, modulesPath, hostname, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot = {
    initrd = {
      availableKernelModules =
        [ "usbhid" "xhci_pci" "ahci" "usb_storage" "sd_mod" ];
      luks.devices.${hostname}.device = "/dev/disk/by-label/${hostname}";
      postDeviceCommands = lib.mkBefore ''
        mkdir -p /mnt
        mount -o subvol=/ /dev/mapper/${hostname} /mnt

        echo "Cleaning subvolume"
        btrfs subvolume list -o /mnt/root | cut -f9 -d ' ' |
        while read subvolume; do
          btrfs subvolume delete "/mnt/$subvolume"
        done && btrfs subvolume delete /mnt/root

        echo "Restoring blank subvolume"
        btrfs subvolume snapshot /mnt/root-blank /mnt/root

        umount /mnt
      '';
    };
    kernelModules = [ "kvm-intel" ];
    supportedFilesystems = [ "btrfs" ];
  };

  fileSystems = {
    "/" = {
      device = "/dev/mapper/${hostname}";
      fsType = "btrfs";
      options = [ "subvol=root" "compress=zstd" ];
    };

    "/nix" = {
      device = "/dev/mapper/${hostname}";
      fsType = "btrfs";
      options = [ "subvol=nix" "noatime" "compress=zstd" ];
    };

    "/persist" = {
      device = "/dev/mapper/${hostname}";
      fsType = "btrfs";
      options = [ "subvol=persist" "compress=zstd" ];
      neededForBoot = true;
    };

    "/dotfiles" = {
      device = "/dev/mapper/${hostname}";
      fsType = "btrfs";
      options = [ "subvol=dotfiles" "compress=zstd" ];
    };

    "/swap" = {
      device = "/dev/mapper/${hostname}";
      fsType = "btrfs";
      options = [ "subvol=swap" "noatime" "compress=lzo" ];
    };

    "/boot" = {
      device = "/dev/disk/by-label/ESP";
      fsType = "vfat";
    };
  };

  swapDevices = [{
    device = "/swap/swapfile";
    size = 4096;
  }];
}
