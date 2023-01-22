{ config, lib, pkgs, ... }:

with lib;

{
  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = false;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    package = pkgs.pipewire.overrideAttrs ({ patches ? [], ... }: {
      patches = [ ./pulseaudio.patch ] ++ patches;
    });
  };

  environment.systemPackages = with pkgs; [
    alsa-utils
    pipewire
    #kmix
  ];
}

# WORKAROUND FOR BROKEN BASS VOLUMES
# https://forum.manjaro.org/t/sound-is-on-maximum-and-mixer-doesnt-change-the-sound-level-in-kde-or-gnome-asus-notebook/59154/16
# 
# After around 10 hours of searching and trying I have no complete solution but the current workaround is to go to KDE System Settings - Custom Shortcuts and add shortcuts to Volume Up keys and Volume Down as the commands:
#
# amixer -c 0 set PCM 5%+  # Volume Up
# amixer -c 0 set PCM 5%-  # Volume Down
#
# where -c 0 means the number of sound card. To find the number with guarantee try to brute force alsamixer -c <number> that has PCM mixer you need and the alsamixer changes are affect the volume.
#
# After the setting custom shortcuts you should start playing music then open alsamixer -c <your number> then press Volume keys and you should see the volume changes in alsamixer and hearing the sound volume changes.
#
# And to showing the KMix animation and play sound add triggering the KMix to the shortcut command:
#
# amixer -c 0 set PCM 5%+ && qdbus org.kde.kmix /kmix/KMixWindow/actions/increase_volume trigger  # Volume Up
# amixer -c 0 set PCM 5%- && qdbus org.kde.kmix /kmix/KMixWindow/actions/decrease_volume trigger  # Volume Down
