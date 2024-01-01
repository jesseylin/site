{
  description = "Build for my static site.";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = inputs@{ self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in {
        packages = pkgs.callPackage ./site.nix { inherit self; };
        devShells.default = pkgs.mkShell { packages = [ pkgs.hugo ]; };
      });
}
