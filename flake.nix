{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable = { url = "github:NixOS/nixpkgs/nixos-unstable"; };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mangowc = {
      url = "github:DreamMaoMao/mangowc";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dgop = {
      url = "github:AvengeMedia/dgop";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    dankMaterialShell = {
      url = "github:AvengeMedia/DankMaterialShell";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      inputs.dgop.follows = "dgop";
    };

  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, mangowc
    , dankMaterialShell, dgop, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
    in {
      nixosConfigurations.fuji = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs pkgs-unstable; };
        system = system;
        modules = [
          ./configuration.nix
          inputs.mangowc.nixosModules.mango
          inputs.dankMaterialShell.nixosModules.greeter

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true; # teilt pkgs mit NixOS
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs pkgs-unstable; };
            home-manager.users.sebi = { ... }: {
              imports = [
                ./modules/mango.nix
                # ./modules/quickshell-hm.nix
                ./home/sebi.nix
                ./home/ranger
                ./hosts/common/nvim
                inputs.mangowc.hmModules.mango
                inputs.dankMaterialShell.homeModules.dankMaterialShell.default
              ];
              programs.quickshell.enable = true;
            };
          }
        ];
      };
    };
}
