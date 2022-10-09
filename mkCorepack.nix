{
  pkgs,
  stdenv,
}: {
  pm ? "pnpm",
  nodejs ? pkgs.nodejs,
}:
stdenv.mkDerivation {
  pname = "corepack";
  version = "${nodejs.version}-${pm}";
  buildInputs = [nodejs];
  phases = ["installPhase"];
  installPhase = ''
    mkdir -p $out/bin
    corepack enable ${pm} --install-directory=$out/bin
  '';
}
