{ config, lib, pkgs, ... }:

with lib;

let
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_OPTIMUS=NVIDIA_only
    exec -a "$0" "$@"
  '';
in
{
  # Configure the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl.enable = true;
  hardware.nvidia.modesetting.enable = true;
  programs.sway.enable = true;

  services.xserver.exportConfiguration = true;

  # Configure display & desktop manager
  services.xserver.displayManager.sddm.enable = true; 
  services.xserver.desktopManager.plasma5.enable = true;
  programs.dconf.enable = true;

  hardware.nvidia.prime = {
    offload.enable = true;
    #sync.enable = true;
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };

  environment.systemPackages = with pkgs; [
    nvidia-offload
  ];
}
