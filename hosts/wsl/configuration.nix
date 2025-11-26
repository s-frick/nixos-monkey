{ config, pkgs, lib, inputs, pkgs-unstable, ... }:
{
  imports = [
    ./nvim
    ../../home/ranger
    <nixos-wsl/modules>

    inputs.mangowc.nixosModules.mango
    inputs.dankMaterialShell.nixosModules.greeter

    inputs.home-manager.nixosModules.home-manager
  ];

  wsl.enable = true;
  wsl.defaultUser = "nixos";

  environment.systemPackages = with pkgs; [
    cachix
    vim
    coreutils-full
    tree
    git
    lazygit
    pass
    gnupg

    gh
  ];
  # services.pcscd.enable = true;

  home-manager = {
    useGlobalPkgs = true; # teilt pkgs mit NixOS
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs pkgs-unstable; };
    users.sebi = { ... }: {
      imports = [
        inputs.mangowc.hmModules.mango
        inputs.dankMaterialShell.homeModules.dankMaterialShell.default

        ../../modules/hm/zsh.nix
        ../../modules/hm/tmux.nix
      ];

      programs.quickshell.enable = true;
      programs.git = {
        enable = true;
        userName = "Sebastian Frick";
        userEmail = "s.frick@reply.de";

        extraConfig.credential.helper = "store";
      };
    };
  };
}

