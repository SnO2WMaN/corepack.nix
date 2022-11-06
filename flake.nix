{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = {
    self,
    nixpkgs,
    flake-utils,
    ...
  } @ inputs:
    {
      overlays.default = import ./overlay.nix;
    }
    // (
      flake-utils.lib.eachDefaultSystem (
        system: let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [
              self.overlays.default
            ];
          };
        in {
          mkCorepack = {
            nodejs ? (pkgs: pkgs.nodejs),
            pm ? "pnpm",
          }: (
            pkgs.mkCorepack {
              inherit pm;
              nodejs = nodejs pkgs;
            }
          );
        }
      )
    );
}
