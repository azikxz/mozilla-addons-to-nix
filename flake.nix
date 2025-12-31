{
  description = "A tool to generate a Nix package set of Firefox add-ons.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      pre-commit-hooks,
      ...
    }:
    let
      lib = nixpkgs.lib;
      forAllSystems =
        f:
        lib.genAttrs lib.systems.flakeExposed (
          system:
          f rec {
            pkgs = nixpkgs.legacyPackages.${system};
            hpkgs = pkgs.haskell.packages.ghc98;

            pname = "mozilla-addons-to-nix";
            src = pkgs.nix-gitignore.gitignoreSource [ ] ./.;

            package = hpkgs.callCabal2nix pname src { };

            pre-commit-check = pre-commit-hooks.lib.${system}.run {
              inherit src;
              hooks = {
                cabal-fmt.enable = true;
                hlint.enable = true;
                nixfmt-rfc-style.enable = true;
                ormolu.enable = true;
              };
            };
          }
        );
    in
    {
      packages = forAllSystems (p: {
        default = p.package;
      });
    };
}
