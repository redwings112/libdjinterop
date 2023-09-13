{ lib, buildPackages, fetchurl, stdenv, ... }:

let
  git-clang-format = buildPackages.fetchurl {
    name = "git-clang-format";
    version = "2019-06-21";
    src = fetchurl {
      url = "https://raw.githubusercontent.com/llvm-mirror/clang/e8c2d2746b1e718b607b78a830534fd3a981d250/tools/clang-format/git-clang-format";
      sha256 = "sha256:1wp7zw2jgpgnv9cr648nlk6gs26yadvs14qnll3vnay1y0n79nd7";
      executable = true;
    };
    nativeBuildInputs = [
      buildPackages.makeWrapper
    ];
    buildInputs = [
      buildPackages.clang-tools
      buildPackages.python3
    ];
    unpackPhase = ":";
    installPhase = ''
      mkdir -p $out/opt $out/bin
      cp $src $out/opt/git-clang-format
      buildPackages.makeWrapper $out/opt/git-clang-format $out/bin/git-clang-format \
        --add-flags --binary \
        --add-flags ${buildPackages.clang-tools}/bin/clang-format
    '';
  };
in
{
  myapp = import ./pkgs/myapp;
  git-clang-format = git-clang-format;
}
