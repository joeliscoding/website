{
  description = "joeliscod.ing";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils
  }:
  flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      packages.default = pkgs.stdenv.mkDerivation {
        pname = "joeliscoding-website";
        version = "0.0.1";
        src = ./.;

        nativeBuildInputs = [
          pkgs.nodejs
          pkgs.pnpm
          pkgs.pnpmConfigHook
        ];

        pnpmDeps = pkgs.fetchPnpmDeps {
          pname = "joeliscoding-website";
          version = "0.0.1";
          src = ./.;
          fetcherVersion = 4;
          hash = "sha256-9IhrqewW8d4PUGrV2CFpXAaQqwY5NAGKoN+PSxhe3fo=";
        };

        buildPhase = ''
          runHook preBuild
          pnpm run build
          runHook postInstall # (or runHook postBuild depending on your setup)
        '';

        installPhase = ''
          runHook preInstall
          cp -r dist $out
          runHook postInstall
        '';
      };
    }
  );
}
