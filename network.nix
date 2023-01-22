{ config, lib, pkgs, ... }:

with lib;

{
  
  networking = {
    hostName = "nameofyourlaptop";
    #networking.wireless.enable = true;  # Not compatible with Zephyrus | Enables wireless support via wpa_supplicant.
    networkmanager.enable = true;
    nameservers = [  "51.158.108.203" "94.16.114.254" "2a03:4000:28:365::1" ]; # https://servers.opennicproject.org/
    # If using dhcpcd:
    dhcpcd.extraConfig = "nohook resolv.conf";
    # If using NetworkManager:
    networkmanager.dns = "none";
  };

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.eno2.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Add OpenVPN connections if you want
  services.openvpn.servers = {
#    Amsterdam = { config = '' config /home/username/OpenVPN/Amsterdam.conf ''; };
#    Frankfurt = { config = '' config /home/username/OpenVPN/Frankfurt.conf ''; };
#    Istanbul  = { config = '' config /home/username/OpenVPN/Istanbul.conf ''; };
  };
}
