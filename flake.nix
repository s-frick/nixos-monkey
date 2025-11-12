{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Optional, if you intend to follow nvf's obsidian-nvim input
    # you must also add it as a flake input.
    # obsidian-nvim.url = "github:epwalsh/obsidian.nvim";

    # Required, nvf works best and only directly supports flakes
    nvf = {
      url = "github:NotAShelf/nvf";
      # You can override the input nixpkgs to follow your system's
      # instance of nixpkgs. This is safe to do as nvf does not depend
      # on a binary cache.
      inputs.nixpkgs.follows = "nixpkgs";
      # Optionally, you can also override individual plugins
      # for example:
      # inputs.obsidian-nvim.follows = "obsidian-nvim"; # <- this will use the obsidian-nvim from your inputs
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nvf,
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
            imports = [ inputs.nvf.homeManagerModules.default ./home/sebi.nix ];
          };
        }
      ];
    };
  };
}
