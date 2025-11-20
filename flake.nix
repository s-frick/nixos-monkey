{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mangowc = {
      url = "github:DreamMaoMao/mangowc";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    mangowc,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    nixosConfigurations.fuji = nixpkgs.lib.nixosSystem {
      system = system;
      modules = [
        ./configuration.nix
	      inputs.mangowc.nixosModules.mango
        inputs.home-manager.nixosModules.default

        home-manager.nixosModules.home-manager
        {
	        home-manager.useGlobalPkgs = true; # teilt pkgs mit NixOS
	        home-manager.useUserPackages = true;
	        home-manager.users.sebi = { pkgs, ... }: {
	          imports = [ 
              ./modules/mango.nix
	            ./home/sebi.nix 
	            ./hosts/common/nvim
              inputs.mangowc.hmModules.mango
	          ];
          };
        }
      ];
    };
  };
}
