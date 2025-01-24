{ pkgs, lib, config, inputs, ... }:

{
  # https://devenv.sh/basics/
  env.GREET = "devenv";

  # HUGO Based on https://gohugo.io/getting-started/quick-start/
  # HTMX Based on https://htmx.org/docs/
  # https://devenv.sh/packages/
  packages = [
    pkgs.git
    pkgs.hugo
  ];

  # https://devenv.sh/languages/
  # languages.rust.enable = true;

  # https://devenv.sh/processes/
  # processes.cargo-watch.exec = "cargo-watch";
  processes = {
    hugo = {
      exec = "hugo serve --config $DEVENV_ROOT/src/hugo.toml";
    };
  };

  # https://devenv.sh/services/
  # services.postgres.enable = true;

  # https://devenv.sh/scripts/
  scripts.version.exec = ''
    echo "direnv: $(direnv version)"
    echo "devenv: $(devenv version)"
    echo "nix: $(nix --version)"
    echo "git: $(git --version)"
    echo "hugo: $(hugo version)"
  '';

  scripts.serve.exec = ''
    hugo serve --config $DEVENV_ROOT/src/hugo.toml
  '';
  scripts.build.exec = ''
    echo "Not yet implemented"
  '';
  
  enterShell = ''
    echo "Entering shell"
  '';

  # https://devenv.sh/tasks/
  tasks = {
    "bash:checkDevDeps" = {
      exec = ''
        echo "Checking dev dependencies"
        if [ ! -f $DEVENV_ROOT/lib/htmx.min.js ]; then
          echo "Missing lib/htmx.min.js, downloading"
          wget https://unpkg.com/htmx.org@2.0.4/dist/htmx.min.js -O $DEVENV_ROOT/lib/htmx.min.js
        else
          echo "lib/htmx.min.js exists"
        fi
        echo "Checking sha256 checksums"
        sha256sum --check lib/checksum
        if [ $? -ne 0 ]; then
          echo "Checksums do not match"
          exit 1
        else
          echo "Checksums match"
        fi
        echo "Checking dev dependencies done"
        exit 0
      '';
      after = ["devenv:enterShell"];
    };
  };

# https://devenv.sh/tests/
  enterTest = ''
    echo "Running tests"
    git --version | grep --color=auto "${pkgs.git.version}"
    '';

# https://devenv.sh/pre-commit-hooks/
# pre-commit.hooks.shellcheck.enable = true;

# See full reference at https://devenv.sh/reference/options/
}
