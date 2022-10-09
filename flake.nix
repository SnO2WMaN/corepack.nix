{
  outputs = {self} @ inputs: {
    overlays.default = import ./overlay.nix;
  };
}
