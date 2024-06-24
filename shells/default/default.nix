{pkgs, inputs, ...}:
pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    treefmt

    alejandra
    python310Packages.mdformat
    shfmt
    inputs.nixos-anywhere.packages.${pkgs.system}.nixos-anywhere
  ];
}
