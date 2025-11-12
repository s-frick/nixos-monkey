{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    nixosConfigurations.fuji = nixpkgs.lib.nixosSystem {
      system = system;
      specialArgs = {inherit inputs;};
      modules = [
        ./configuration.nix
        inputs.home-manager.nixosModules.default
        ./hyprland.nix

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true; # teilt pkgs mit NixOS
          home-manager.useUserPackages = true;
          #home-manager.users.sebi = import ./home/sebi.nix; # dein HM-User
	  home-manager.users.sebi = { pkgs, ... }: {
            imports = [ 
	      ./home/sebi.nix 
	      ./hosts/common/nvim
	    ];
          };
        }
      ];
    };
  };
}
