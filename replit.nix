{ pkgs }: {
  deps = [
    pkgs.llvmPackages_13.llvm
    pkgs.qemu
    pkgs.clang
  ];
}