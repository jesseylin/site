{
  description = "Build for my static site.";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    flake-utils.url = "github:numtide/flake-utils";

    # hugo theme submodule
    congo = {
      url = "github:jpanther/congo?rev=b4b6bf644b87326b5dfa2239c2751436890e06ea";
      flake = false;
    };

    # my progress-bar SPA
    progress-bar = {
      url = "github:jesseylin/progress-bar";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    flake-utils,
    congo,
    progress-bar,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {inherit system;};
      progress-bar-site = progress-bar.packages.${system}.default;
    in {
      packages.default = with pkgs;
        callPackage ./site.nix {
          inherit self;
          inherit congo;
          inherit progress-bar-site;
        };
      devShells.default = with pkgs; mkShell {packages = [hugo];};
    });
}
