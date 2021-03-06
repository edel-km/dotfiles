# flake.nix		
# 
# Author:		Manuel Kostelecky <contact.me@kostelecky.at>
# URL:			https://github.com/kostelem/dotfiles
# License:		MIT

{

  description = "An ambitious config for an ambitious project.";

  inputs = 
    {
      # Core dependencies.
      nixpkgs.url = "nixpkgs/nixos-unstable";				# primary nixpkgs
      nixpkgs-unstable.url = "nixpkgs/nixpkgs-unstable";		# for packages on the edge
      home-manager.url = "github:rycee/home-manager/master";
      home-manager.inputs.nixpkgs.follows = "nixpkgs";
    };

  outputs = { self, nixpkgs, nixpkgs-unstable, ... }@inputs: { 
    nixosConfigurations.bifroest = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = 
        [ (import ./hosts/bifroest/configuration.nix) ];
      specialArgs = { inherit inputs; };
    };
    nixosConfigurations.darwin-vm = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      modules =
        [ (import ./hosts/darwin-vm/configuration.nix) ];
	specialArgs = { inherit inputs; };
    };
  };
}
