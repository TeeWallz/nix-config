# System configuration for my laptop
{ config, pkgs, system, inputs, ... }:

{
  imports = [
    inputs.hardware.nixosModules.common-cpu-amd
    inputs.hardware.nixosModules.common-gpu-amd
    inputs.hardware.nixosModules.common-pc-ssd

    ./hardware-configuration.nix
    ../common
    ../common/docker.nix
    ../common/misterio-greetd.nix
    ../common/pipewire.nix
    ../common/postgres.nix
    ../common/steam.nix

    ./wireguard.nix
  ];

  boot = {
    # Kernel
    kernelPackages = pkgs.linuxPackages_zen;
    # Plymouth (currently only starts at phase 2)
    plymouth = {
      enable = true;
    };
    loader = {
      timeout = 0;
      systemd-boot = {
        enable = true;
        consoleMode = "max";
        editor = false;
      };
      efi.canTouchEfiVariables = true;
    };
  };

  services.dbus.packages = [ pkgs.gcr ];

  powerManagement.powertop.enable = true;
  programs = {
    light.enable = true;
    gamemode.enable = true;
    adb.enable = true;
    dconf.enable = true;
    kdeconnect.enable = true;
  };

  xdg.portal = {
    enable = true;
    gtkUsePortal = true;
    wlr.enable = true;
  };
}
