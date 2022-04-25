{
  description = "C++";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system}; in
      rec {
        packages = flake-utils.lib.flattenTree rec {
          header = pkgs.llvmPackages_13.stdenv.mkDerivation {
            src = ./src/headers/all.h;
            name = "learn-cpp-header";
            dontUnpack = true;
            buildPhase = ''
              clang++ -std=c++20 -Wall --pedantic-errors -x c++-header -o all.h.gch $src
            '';
            installPhase = ''
              mkdir -p $out/include
              cp $src $out/include/all.h
              cp all.h.gch $out/include
            '';
          };
          hello = pkgs.llvmPackages_13.stdenv.mkDerivation {
            src = ./src/hello.cpp;
            name = "learn-cpp-hello";
            dontUnpack = true;
            buildPhase = ''
              clang++ -std=c++20 -Wall --pedantic-errors -include ${header}/include/all.h -o hello $src
            '';
            installPhase = ''
              mkdir -p $out/bin
              cp hello $out/bin
            '';

          };
        };
        apps.hello = flake-utils.lib.mkApp { drv = packages.hello; name = "hello"; };
        apps.default = apps.hello;
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            clang-tools
            llvmPackages_13.clang
          ];
        };
      }
    );
}
