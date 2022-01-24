# flake.nix
# 
# Author:				Manuel Kostelecky <contact.me@kostelecky.at>
# URL:				https://github.com/v2km/dotfiles
# License:			MIT

{

  description = "NixOS - VM on Darwin";

  inputs =
    {
      # Core dependencies
      nixpkgs.url = "nixpkgs/nixos-unstable";
      nixpkgs-unstable.url = "nixpkgs/nixpkgs-unstable";
      home-manager.url = "github:rycee/home-manager/master";
      home-manager.inputs.nixpkgs.follows = "nixpkgs";
    };

  outputs = { self, nixpkgs, nixpkgs-unstable, ... }@inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      modules = 
        [ (import ./configuration.nix) ];
      specialArgs = { inherit inputs; };
    };
  };
}
