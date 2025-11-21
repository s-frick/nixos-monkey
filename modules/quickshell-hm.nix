{ lib, config, pkgs-unstable, ... }:

let
  defaultPkg = pkgs-unstable.quickshell;
in
{
  options.programs.quickshell = {
    enable = lib.mkEnableOption "quickshell";
    package = lib.mkOption {
      type = lib.types.package;
      default = defaultPkg;
      defaultText = "pkgs-unstable.quickshell";
      description = "Quickshell package to install (defaults to unstable).";
    };
  };

  config = lib.mkIf config.programs.quickshell.enable {
    home.packages = [ config.programs.quickshell.package ];
  };
}
