{
  description = "A tool to generate a Nix package set of Firefox add-ons.";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs = {
        flake-utils.follows = "flake-utils";
        nixpkgs.follows = "nixpkgs";
      };
    };
  };

  outputs = { self, flake-utils, nixpkgs, pre-commit-hooks }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        hpkgs = pkgs.haskell.packages.ghc94;

        name = "mozilla-addons-to-nix";
        src = pkgs.nix-gitignore.gitignoreSource [ ] ./.;

        package = hpkgs.callCabal2nix name src { };

        pre-commit-check = pre-commit-hooks.lib.${system}.run {
          inherit src;
          hooks = {
            cabal-fmt.enable = true;
            hlint.enable = true;
            nixfmt.enable = true;
            ormolu.enable = true;
          };
        };
      in {
        packages.default = package;

        checks = { inherit package pre-commit-check; };

        devShells.default = hpkgs.shellFor {
          packages = ps: [ package ];
          nativeBuildInputs = with hpkgs; [
            cabal-install
            haskell-language-server
          ];
          shellHook = pre-commit-check.shellHook;
        };
      });
}
