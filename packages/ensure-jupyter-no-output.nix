{
  coreutils,
  findutils,
  nbstripout,
  writeShellApplication,
}:

writeShellApplication {
  name = "ensure-jupyter-no-output";
  runtimeInputs = [
    coreutils
    findutils
    nbstripout
  ];
  text = ''
    git_args=("ls-files")
    staged_only=false
    while getopts "s" opt; do
      case "$opt" in
      s)
        staged_only=true
        git_args=("diff" "--staged" "--name-only")
        ;;
      *)
        echo "unrecognized flag"
        ;;
      esac
    done

    failures="''$(mktemp)"
    trap 'rm -f "''$failures"' EXIT

    git "''${git_args[@]}" | (grep .ipynb || true) | (xargs -rd "\n" nbstripout --verify || true) | tee /dev/stderr > "''$failures"

    if [[ -s "''$failures" ]]; then
      if ''$staged_only; then
        echo "just checked staged files."
      fi
      echo "the above notebook files have output which must be removed with e.g. nbstripout."
      exit 1
    fi
  '';
}
