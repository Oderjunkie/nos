{ pkgs }: {
  deps = [
    pkgs.llvmPackages_13.llvm
    pkgs.gdb
    pkgs.neovim
    pkgs.qemu
    pkgs.gcc
    pkgs.nasm
    pkgs.bison
    pkgs.flex
    pkgs.gmp
    pkgs.libmpc
    pkgs.mpfr
    pkgs.texinfo4
    pkgs.clang
    pkgs.tinycc
  ];
}