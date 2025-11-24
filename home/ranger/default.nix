{ pkgs, lib, config, ... }:
{
    home.packages = lib.mkAfter (with pkgs; [
      ranger
    ]);

    xdg.configFile."ranger/rc.conf".text = ''
      set preview_images true
      set preview_images_method kitty
    '';
}
