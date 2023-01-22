{ config, lib, pkgs, ... }:

with lib;

{
  # Newest Kernel version: Currently broken!
  #boot.kernelPackages = pkgs.linuxPackages_latest;

  #boot.kernelPackages =  pkgs.linuxPackages_6_0;

  boot.kernelPackages = let 
        pinnedNixPkgs = import (pkgs.fetchFromGitHub {
            owner = "nixos";
            repo = "nixpkgs";
            rev = "35955e360c6851e9a53fed945a9e98cfea5d67be";
            hash = "sha256-M4ml2ECaO7UBKsMhtw3ZOMFE/4y51W84xoFlmsb2sHw=";
        }){};
        myKernel = pinnedNixPkgs.linux_5_19;
        in pkgs.recurseIntoAttrs (pinnedNixPkgs.linuxPackagesFor myKernel);

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [
    "video=eDP-1-1:2560x1600@165" # Patch for 165hz display
    "intel_iommu=on"              # Hardware virtualisation
  ];

  services.xserver.displayManager.sessionCommands = ''
    xrandr --newmode "2560x1600_165.00" 1047.00 2560 2800 3080 3600  1600 1603 1609 1763 -hsync +vsync
    xrandr --addmode eDP-1-1 "2560x1600_165.00"
    xrandr --output eDP-1-1 --mode 2560x1600 --rate 165
  '';

  # Fix a bug in the intel driver that will crash nvidia sync mode
  # https://gitlab.freedesktop.org/xorg/driver/xf86-video-intel/-/issues/208#note_1414290
  #services.xserver.deviceSection = ''
  #        Option "PageFlip" "false"
  #'';

  boot.kernelPatches = [
    {
      name = "Async-Page-Flip-Bug";
      patch = ./f3e30f9f96438489ff59619fdcbada1a31e09f8c.patch;
    }
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?
}
