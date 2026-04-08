{
  description = "Build for my static site.";
  inputs = {
    self.submodules = true;
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    flake-utils.url = "github:numtide/flake-utils";
    progress-bar = {
      url = "github:jesseylin/progress-bar";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    flake-utils,
    progress-bar,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.default = with pkgs;
        callPackage ./site.nix {
          inherit self;
          progress-bar = progress-bar.packages.${system}.default;
        };
      devShells.default = with pkgs; mkShell {packages = [hugo];};
    });
}
