# Nix Flake for Node.js Corepack

## Usage

```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    devshell.url = "github:numtide/devshell";
    corepack.url = "github:SnO2WMaN/corepack-flake"; # 1
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    ...
  } @ inputs:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {
          inherit system;
          overlays = with inputs; [
            devshell.overlay
            corepack.overlays.default # 2
          ];
        };
      in {
        devShells.default = pkgs.devshell.mkShell {
          packages = with pkgs; [ 
            nodejs-16_x 
            (mkCorepack { nodejs = nodejs-16_x; pm = "pnpm"; })  # 3
          ];
        };
      }
    );
}
```

1. Import this flake.
2. Pass the overlay.
3. call `pkgs.mkCorepack` (You should set the same version Node.js)

### Options for `mkCallpack`

- `nodejs`
  - Using node.js package
  - default: `pkgs.nodejs`
- `pm`
  - Name of package manager
  - default: `pnpm`
  - choice
    - `pnpm`
    - `yarn`
