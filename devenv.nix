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
  
  # Ensure lib/htmx.min.js exists, else, wget https://unpkg.com/htmx.org@2.0.4/dist/htmx.min.js
  scripts.checkDevDeps.exec = ''
    echo "Checking dev dependencies"
    if [ ! -f $DEVENV_ROOT/lib/htmx.min.js ]; then
      echo "Missing lib/htmx.min.js, downloading"
      wget https://unpkg.com/htmx.org@2.0.4/dist/htmx.min.js -O $DEVENV_ROOT/lib/htmx.min.js
    fi
  '';

  enterShell = ''
    echo "Entering shell"
    echo "Checking dev dependencies"
    
  '';

  # https://devenv.sh/tasks/
  tasks = {
    "devenv:enterShell".after = ["enterShell"];
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
