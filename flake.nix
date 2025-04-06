# All the same options you make here will be automatically exported in a form available
# in home manager and in nixosModules, as well as from other flakes.
# each section is tagged with its relevant help section.

{
  description = "A Lua-natic's neovim flake, with extra cats! nixCats!";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixCats.url = "github:BirdeeHub/nixCats-nvim";

    blink-cmp = {
      url = "github:Saghen/blink.cmp";
    };
    plugins-nvim-dap-view = {
      url = "github:igorlfs/nvim-dap-view";
      flake = false;
    };

    # see :help nixCats.flake.inputs
    # If you want your plugin to be loaded by the standard overlay,
    # i.e. if it wasnt on nixpkgs, but doesnt have an extra build step.
    # Then you should name it "plugins-something"
    # If you wish to define a custom build step not handled by nixpkgs,
    # then you should name it in a different format, and deal with that in the
    # overlay defined for custom builds in the overlays directory.
    # for specific tags, branches and commits, see:
    # https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-flake.html#examples

  };

  # see :help nixCats.flake.outputs
  outputs =
    {
      self,
      nixpkgs,
      nixCats,
      blink-cmp,
      ...
    }@inputs:
    let
      inherit (nixCats) utils;
      luaPath = "${./.}";
      forEachSystem = utils.eachSystem nixpkgs.lib.platforms.all;
      # the following extra_pkg_config contains any values
      # which you want to pass to the config set of nixpkgs
      # import nixpkgs { config = extra_pkg_config; inherit system; }
      # will not apply to module imports
      # as that will have your system values
      extra_pkg_config = {
        allowUnfree = true;
      };
      # sometimes our overlays require a ${system} to access the overlay.
      # management of this variable is one of the harder parts of using flakes.

      # so I have done it here in an interesting way to keep it out of the way.

      # First, we will define just our overlays per system.
      # later we will pass them into the builder, and the resulting pkgs set
      # will get passed to the categoryDefinitions and packageDefinitions
      # which follow this section.

      # this allows you to use ${pkgs.system} whenever you want in those sections
      # without fear.
      # inherit (forEachSystem (system:
      #   let
      #     # see :help nixCats.flake.outputs.overlays
      dependencyOverlays = # (import ./overlays inputs) ++
        [
          # This overlay grabs all the inputs named in the format
          # `plugins-<pluginName>`
          # Once we add this overlay to our nixpkgs, we are able to
          # use `pkgs.neovimPlugins`,  which is a set of our plugins.
          (utils.standardPluginOverlay inputs)
          # add any flake overlays here.
        ];
      # these overlays will be wrapped with ${system}
      # and we will call the same utils.eachSystem function
      # later on to access them.
      #

      # in { inherit dependencyOverlays; }))
      # dependencyOverlays;
      # see :help nixCats.flake.outputs.categories
      # and
      # :help nixCats.flake.outputs.categoryDefinitions.scheme
      categoryDefinitions =
        {
          pkgs,
          settings,
          categories,
          name,
          ...
        }@packageDef:
        let
          # Self made function, add langauge-based dependencies easily
          mkLang =
            {
              lsp ? [ ],
              formatter ? [ ],
              linter ? [ ],
              debugger ? [ ],
              other ? [ ],
            }:
            (other ++ lsp ++ linter ++ debugger ++ formatter);
        in
        {
          # to define and use a new category, simply add a new list to a set here,
          # and later, you will include categoryname = true; in the set you
          # provide when you build the package using this builder function.
          # see :help nixCats.flake.outputs.packageDefinitions for info on that section.

          # propagatedBuildInputs:
          # this section is for dependencies that should be available
          # at BUILD TIME for plugins. WILL NOT be available to PATH
          # However, they WILL be available to the shell
          # and neovim path when using nix develop
          # propagatedBuildInputs = { general = with pkgs; [ ]; };

          # lspsAndRuntimeDeps:
          # this section is for dependencies that should be available
          # at RUN TIME for plugins. Will be available to PATH within neovim terminal
          # this includes LSPs
          lspsAndRuntimeDeps = {
            general = with pkgs; [
              fd
              ripgrep
              sqlite
              fzf
              universal-ctags
              stdenv.cc.cc
              typos-lsp
              imagemagick
            ];
            language = {
              nix = mkLang {
                other = [ pkgs.nix-doc ];
                lsp = [ pkgs.nixd ];
                formatter = [ pkgs.nixfmt-rfc-style ];
              };
              lua = mkLang {
                lsp = [ pkgs.lua-language-server ];
                formatter = [ pkgs.stylua ];
                linter = [ pkgs.selene ];
              };
              c = mkLang {
                lsp = [ pkgs.llvmPackages_20.clang-tools ];
                debugger = [ pkgs.gdb ];
              };
              typst = mkLang {
                lsp = [ pkgs.tinymist ];
                formatter = [ pkgs.typstfmt ];
                other = [ pkgs.websocat ];
              };
              json = mkLang {
                lsp = [ pkgs.nodePackages.vscode-json-languageserver ];
                formatter = [ pkgs.jq ];
              };
              python = mkLang {
                lsp = with pkgs; [ basedpyright ];
                formatter = with pkgs; [ ruff ];
                other = [ pkgs.python3.pkgs.jupytext ];
              };
              rust = (
                mkLang {
                  lsp = [ pkgs.rust-analyzer ];
                  formatter = [ pkgs.rustfmt ];
                  linter = [ pkgs.clippy ];
                  other = with pkgs; [ graphviz-nox ];
                }
              );
              java = mkLang {
                lsp = [ pkgs.jdt-language-server ];
                other = with pkgs; [
                  zulu
                  vscode-extensions.vscjava.vscode-java-debug
                  vscode-extensions.vscjava.vscode-java-test
                ];
              };
            };
          };

          # This is for plugins that will load at startup without using packadd:
          startupPlugins = {
            general = with pkgs.vimPlugins; [
              lz-n
              lzn-auto-require

              friendly-snippets # think this is needed for runtime path? Might be able to move later
            ];
          };

          # not loaded automatically at startup.
          # use with packadd and an autocommand in config to achieve lazy loading
          optionalPlugins = {
            general = with pkgs.vimPlugins; [
              #pkgs.neovimPlugins.exercism-nvim
              # Needed to lazy load plugins
              #TODO: lzn spec these
              mini-nvim
              otter-nvim
              nvim-treesitter.withAllGrammars
              grug-far-nvim
              neoconf-nvim
              nvim-treesitter-textobjects # TODO: make bindings
              SchemaStore-nvim
              fzf-lua
              lualine-nvim
              overseer-nvim
              todo-comments-nvim

              flash-nvim
              nvim-notify
              which-key-nvim
              nvim-snippets
              project-nvim

              gitsigns-nvim
              neogen
              neotest # TODO - other neotest plugins
              FixCursorHold-nvim
              nvim-dap # TODO - other dap plugins
              nvim-dap-virtual-text
              nvim-dap-ui
              nvim-dap-lldb
              (pkgs.neovimPlugins.nvim-dap-view)
              #nvim-ts-autotag - replace with mini
              #rainbow-delimiters-nvim
              persisted-nvim
              helpview-nvim
              tmux-nvim

              snacks-nvim

              nvim-lint
              conform-nvim

              #render-markdown-nvim
              markview-nvim

              blink-cmp.packages.${pkgs.system}.default
              # blink-compat
              lazydev-nvim

              everforest
            ];

            language = {
              #lua = with pkgs.vimPlugins; [ lazydev-nvim ];
              rust = with pkgs.vimPlugins; [
                rustaceanvim
                crates-nvim
              ];
              markdown = with pkgs.vimPlugins; [
                markview-nvim
                obsidian-nvim
              ];
              typst = with pkgs.vimPlugins; [ typst-preview-nvim ];
              java = with pkgs.vimPlugins; [ nvim-jdtls ];
              c = with pkgs.vimPlugins; [ clangd_extensions-nvim ];
            };

          };

          # shared libraries to be added to LD_LIBRARY_PATH
          # variable available to nvim runtime
          sharedLibraries = {
            general = with pkgs; [
              libgit2
              libvterm-neovim
            ];
          };

          # environmentVariables:
          # this section is for environmentVariables that should be available
          # at RUN TIME for plugins. Will be available to path within neovim terminal
          environmentVariables = {
            typst = {
              WEBSOCAT_PATH = "${pkgs.websocat}";
              TINYMIST_PATH = "${pkgs.tinymist}";
            };
            test = {
              CATTESTVAR = "It worked!";
            };
          };

          # If you know what these are, you can provide custom ones by category here.
          # If you dont, check this link out:
          # https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/setup-hooks/make-wrapper.sh
          # extraWrapperArgs = {
          #   test = [ ''--set CATTESTVAR2 "It worked again!"'' ];
          # };

          # lists of the functions you would have passed to
          # python.withPackages or lua.withPackages

          # get the path to this python environment
          # in your lua config via
          # vim.g.python3_host_prog
          # or run from nvim terminal via :!<packagename>-python3
          extraPython3Packages = {
            test = (_: [ ]);
          };
          # populates $LUA_PATH and $LUA_CPATH
          extraLuaPackages = {
            general = [ (p: with p; [ magick ]) ];
          };
        };

      # And then build a package with specific categories from above here:
      # All categories you wish to include must be marked true,
      # but false may be omitted.
      # This entire set is also passed to nixCats for querying within the lua.

      # see :help nixCats.flake.outputs.packageDefinitions
      packageDefinitions = {
        # These are the names of your packages
        # you can include as many as you wish.
        nvim =
          { pkgs, ... }:
          rec {
            # they contain a settings set defined above
            # see :help nixCats.flake.outputs.settings
            settings = {
              wrapRc = true;
              suffix-path = true;
              suffix-LD = true;
              # neovim-unwrapped =
              #   inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;
              # IMPORTANT:
              # your alias may not conflict with your other packages.
              aliases = [ "vim" ];
              # neovim-unwrapped = inputs.neovim-nightly-overlay.packages.${pkgs.system}.neovim;
              disablePythonSafePath = true;
            };
            # and a set of categories that you want
            # (and other information to pass to lua)
            categories = {
              general = true;
              customPlugins = true;
              language = {
                nix = true;
                markdown = true;
                python = true;
                lua = true;
                rust = true;
                #julia = true;
                typst = true;
                java = true;
                c = true;
                idris = true;
              };

              LLDB_PATH =
                pkgs.lib.mkIf (categories.language.c || categories.language.rust)
                  "${pkgs.vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb/adapter/codelldb";

              javaEnv = pkgs.lib.mkIf (categories.language.java) {
                JDK = "${pkgs.zulu}/bin/java";
                JDT_PATH = "${pkgs.jdt-language-server}/share/java/jdtls/";
                JAVA_DBG = "${pkgs.vscode-extensions.vscjava.vscode-java-debug}/share/vscode/extensions/vscjava.vscode-java-debug/server/";
                JAVA_TEST = "${pkgs.vscode-extensions.vscjava.vscode-java-test}/share/vscode/extensions/vscjava.vscode-java-test/server/";

              };
              colorScheme = {

                base00 = "#2b3339";
                base01 = "#323c41";
                base02 = "#503946";
                base03 = "#868d80";
                base04 = "#d3c6aa";
                base05 = "#d3c6aa";
                base06 = "#e9e8d2";
                base07 = "#fff9e8";
                base08 = "#7fbbb3";
                base09 = "#d699b6";
                base0A = "#83c092";
                base0B = "#dbbc7f";
                base0C = "#e69875";
                base0D = "#a7c080";
                base0E = "#e67e80";
                base0F = "#d699b6";

              };
              cDebugPath = "${pkgs.vscode-extensions.ms-vscode.cpptools}/share/vscode/extensions/ms-vscode.cpptools/debugAdapters/bin/OpenDebugAD7";
              gdbPath = pkgs.lib.getExe pkgs.gdb;
              example = {
                youCan = "add more than just booleans";
                toThisSet = [
                  "and the contents of this categories set"
                  "will be accessible to your lua with"
                  "nixCats('path.to.value')"
                  "see :help nixCats"
                ];
              };
            };
          };
      };
      # In this section, the main thing you will need to do is change the default package name
      # to the name of the packageDefinitions entry you wish to use as the default.
      defaultPackageName = "nvim";

      # see :help nixCats.flake.outputs.exports
    in
    forEachSystem (
      system:
      let
        nixCatsBuilder = utils.baseBuilder luaPath {
          inherit
            nixpkgs
            system
            dependencyOverlays
            extra_pkg_config
            ;
        } categoryDefinitions packageDefinitions;
        defaultPackage = nixCatsBuilder defaultPackageName;
        # this is just for using utils such as pkgs.mkShell
        # The one used to build neovim is resolved inside the builder
        # and is passed to our categoryDefinitions and packageDefinitions
        pkgs = import nixpkgs { inherit system; };
      in
      {
        # these outputs will be wrapped with ${system} by utils.eachSystem

        # this will make a package out of each of the packageDefinitions defined above
        # and set the default package to the one passed in here.
        packages = utils.mkAllWithDefault defaultPackage;

        # choose your package for devShell
        # and add whatever else you want in it.
        devShells = {
          default = pkgs.mkShell {
            name = defaultPackageName;
            packages = [ defaultPackage ];
            inputsFrom = [ defaultPackage ];
          };
        };

      }
    )
    // {

      # these outputs will be NOT wrapped with ${system}

      # this will make an overlay out of each of the packageDefinitions defined above
      # and set the default overlay to the one named here.
      overlays = utils.makeOverlays luaPath {
        inherit nixpkgs dependencyOverlays extra_pkg_config;
      } categoryDefinitions packageDefinitions defaultPackageName;

      # we also export a nixos module to allow reconfiguration from configuration.nix
      nixosModules.default = utils.mkNixosModules {
        inherit
          defaultPackageName
          dependencyOverlays
          luaPath
          categoryDefinitions
          packageDefinitions
          extra_pkg_config
          nixpkgs
          ;
      };
      # and the same for home manager
      homeModule = utils.mkHomeModules {
        inherit
          defaultPackageName
          dependencyOverlays
          luaPath
          categoryDefinitions
          packageDefinitions
          extra_pkg_config
          nixpkgs
          ;
      };
      inherit utils;
      inherit (utils) templates;
    };

}
