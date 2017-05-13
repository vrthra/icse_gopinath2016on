#!/usr/bin/env nix-shell
#! nix-shell --pure --run "env i_fcolor=red zsh" .

let
  sysPkg = import <nixpkgs> { };
  pinnedPkg = sysPkg.fetchFromGitHub {
    owner = "NixOS";
    repo = "nixpkgs";
    rev = "17.03";
    sha256 = "1fw9ryrz1qzbaxnjqqf91yxk1pb9hgci0z0pzw53f675almmv9q2";
  };
  pkgs = import pinnedPkg {};
  python_shim = with pkgs; stdenv.mkDerivation rec {
    name = "pythonShim";
    propagatedBuildInputs = [ python3 ];
    phases = [ "installPhase" ];
    installPhase = "install -D ${python3}/bin/python3 $out/bin/python";
  };
in with pkgs; stdenv.mkDerivation rec {

  name = "env";

  env = buildEnv {
    inherit name;
    paths = buildInputs;
  };

  builder = builtins.toFile "builder.sh" "source $stdenv/setup; ln -s $env $out";

  buildInputs = [
    perl ruby curl gitFull vim less python_shim ag moreutils rsync
    (rWrapper.override {
     packages = with rPackages;
      [ ggplot2 xtable dplyr scales reshape2 mgcv knitr ezknitr tidyr broom ];
     })
  (texlive.combine {
   inherit (texlive)
      scheme-small latexmk eepic cleveref forloop nag overpic enumitem datetime
      algorithms algorithmicx cm-super relsize framed placeins boxedminipage comment
      blindtext collection-fontsrecommended footmisc subfigure preprint
      IEEEtran fmtcount;
   })
   ghostscript
  ];

  shellHook = ''
    export PS1="\[\e[33m\]|\[\e[m\] "
    export R_LIBS=~/.R/library/
    TERM=xterm
  '';
}
