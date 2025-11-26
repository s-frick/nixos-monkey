{ config, pkgs, lib, inputs, pkgs-unstable, ... }:
{
  imports = [
    ./nvim
    ../../modules/mango.nix
    ../../home/sebi.nix
    ../../home/ranger

    inputs.mangowc.nixosModules.mango
    inputs.dankMaterialShell.nixosModules.greeter

    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    useGlobalPkgs = true; # teilt pkgs mit NixOS
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs pkgs-unstable; };
    users.sebi = { ... }: {
      imports = [
        inputs.mangowc.hmModules.mango
        inputs.dankMaterialShell.homeModules.dankMaterialShell.default
      ];

      programs.quickshell.enable = true;
    };
  };
}
