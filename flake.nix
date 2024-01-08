{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShells.default = with pkgs;
          mkShell {
            name = "Default developpement shell";
            # LD_LIBRARY_PATH = "${lib.makeLibraryPath [ duckdb ]}";
            packages = [
              cocogitto
              nixpkgs-fmt
              nodePackages.markdownlint-cli
              pre-commit

              just
              bkt

              deno
              lcov

              duckdb
              xlsx2csv

              pup
              jq
              gnuplot

              imagemagick
            ];
            shellHook = ''
              export PROJ="stock-market"

              echo ""
              echo "⭐ Welcome to the $PROJ project ⭐"
              echo ""
              just
              echo ""
            '';
          };
      });
}
