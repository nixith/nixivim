# All the same options you make here will be automatically exported in a form available
# in home manager and in nixosModules, as well as from other flakes.
# each section is tagged with its relevant help section.

{
  description = "A Lua-natic's neovim flake, with extra cats! nixCats!";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixCats.url = "github:BirdeeHub/nixCats-nvim";
    coq = {
      url = "github:ms-jpq/coq_nvim";
      flake = false;
    };

    care-nvim = { url = "github:max397574/care.nvim"; };
    blink-cmp = { url = "github:Saghen/blink.cmp"; };
    plugins-care-cmp = {
      url = "github:max397574/care-cmp";
      flake = false;
    };
    plugins-lazydev = {
      url = "github:folke/lazydev.nvim";
      flake = false;
    };
    plugins-blink-compat = {
      url = "github:Saghen/blink.compat";
      flake = false;
    };
    # plugins-snacks-nvim = {
    #   url = "github:folke/snacks.nvim";
    #   flake = false;
    # };
    #2KAbhishek/termim.nvim
    # plugins-exercism-nvim = {
    #   url = "github:2KAbhishek/exercism.nvim";
    #   flake = false;
    # };
    plugins-termim-nvim = {
      url = "github:2KAbhishek/termim.nvim";
      flake = false;
    };

    # neovim-nightly-overlay = {
    #   url = "github:nix-community/neovim-nightly-overlay";
    # };

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
  outputs = { self, nixpkgs, nixCats, care-nvim, blink-cmp, coq, ... }@inputs:
    let
      inherit (nixCats) utils;
      luaPath = "${./.}";
      forEachSystem = utils.eachSystem nixpkgs.lib.platforms.all;
      # the following extra_pkg_config contains any values
      # which you want to pass to the config set of nixpkgs
      # import nixpkgs { config = extra_pkg_config; inherit system; }
      # will not apply to module imports
      # as that will have your system values
      extra_pkg_config = { allowUnfree = true; };
      # sometimes our overlays require a ${system} to access the overlay.
      # management of this variable is one of the harder parts of using flakes.

      # so I have done it here in an interesting way to keep it out of the way.

      # First, we will define just our overlays per system.
      # later we will pass them into the builder, and the resulting pkgs set
      # will get passed to the categoryDefinitions and packageDefinitions
      # which follow this section.

      # this allows you to use ${pkgs.system} whenever you want in those sections
      # without fear.
      inherit (forEachSystem (system:
        let
          # see :help nixCats.flake.outputs.overlays
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

        in { inherit dependencyOverlays; }))
        dependencyOverlays;
      # see :help nixCats.flake.outputs.categories
      # and
      # :help nixCats.flake.outputs.categoryDefinitions.scheme
      categoryDefinitions =
        { pkgs, settings, categories, name, ... }@packageDef:
        let
          # Self made function, add langauge-based dependencies easily
          mkLang = { lsp ? [ ], formatter ? [ ], linter ? [ ], debugger ? [ ]
            , other ? [ ] }:
            (other ++ pkgs.lib.optionals categories.lsp lsp
              ++ pkgs.lib.optionals categories.lint linter
              ++ pkgs.lib.optionals categories.debug debugger
              ++ pkgs.lib.optionals categories.format formatter);
        in {
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
              # runtime deps
              fd
              ripgrep
              fzf
              universal-ctags
              stdenv.cc.cc
              typos-lsp
              imagemagick
              exercism
            ];
            language = {
              idris = mkLang {
                lsp = with pkgs.idris2Packages; [ idris2Lsp ];
                other = with pkgs; [ idris2 ];
              };
              nix = mkLang {
                other = [ pkgs.nix-doc ];
                lsp = [ pkgs.nixd ];
                formatter = [ pkgs.nixfmt ];
              };
              lua = mkLang {
                lsp = [ pkgs.lua-language-server ];
                formatter = [ pkgs.stylua ];
                linter = [ pkgs.selene ];
              };
              c = mkLang {
                lsp = [ pkgs.llvmPackages_20.clang-tools ];
                debugger = [ pkgs.vscode-extensions.ms-vscode.cpptools ];
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
              rust = (mkLang {
                lsp = [ pkgs.rust-analyzer ];
                formatter = [ pkgs.rustfmt ];
                linter = [ pkgs.clippy ];
                other = with pkgs; [ graphviz-nox ];
              });
              julia = (mkLang {
                lsp = [ pkgs.julia ];
                #formatter = [ ]; # TODO: find formatter
                #linter = [ ]; # TODO: find linter
                #other = with pkgs; [ ];
              });
              java = mkLang {
                lsp = [ pkgs.jdt-language-server ];
                other = with pkgs; [ zulu ];
              };
            };
          };

          # This is for plugins that will load at startup without using packadd:
          startupPlugins =
            { # TODO: review every plugin, configure it, lazy load it or mark it as completed
              general = with pkgs.vimPlugins; [
                #pkgs.neovimPlugins.exercism-nvim
                mini-nvim
                # Needed to lazy load plugins
                lz-n
                iron-nvim
                jupytext-nvim
                conjure
                cmp-conjure
                baleia-nvim
                rtp-nvim
                lzn-auto-require
                project-nvim
                remote-nvim-nvim

                # Lazy loads itself

                # Otherwise want immediately

                nvim-treesitter.withAllGrammars

                # TODO: lazy load & categorize these
                otter-nvim
                grug-far-nvim
                nvim-autopairs # TODO: integrate with cares
                neoconf-nvim
                nvim-rip-substitute
                nvim-treesitter-textobjects # TODO: make bindings
                SchemaStore-nvim
                fzf-lua
                bufferline-nvim # TODO config
                flash-nvim
                image-nvim
                lualine-nvim
                nvim-notify
                # spellwarn-nvim # TODO add somehow - not in nixpkgs
                trouble-nvim
                which-key-nvim
                #typst-preview # TODO not in nixpkgs
                friendly-snippets
                gitsigns-nvim
                marks-nvim
                neogen
                neotest # TODO - other neotest plugins
                nvim-dap # TODO - other dap plugins
                nvim-dap-virtual-text
                nvim-dap-ui
                nvim-snippets
                nvim-ts-autotag
                rainbow-delimiters-nvim
                persisted-nvim

                #render-markdown-nvim
                #markview-nvim

              ];
              cmp = with pkgs.vimPlugins; [
                #  if using care
                #pkgs.neovimPlugins.care-cmp
                #inputs.care-nvim.packages.${pkgs.system}.care-nvim

                #   # (coq_nvim.overrideAttrs
                #   #   (finalAttrs: previousAttrs: { src = coq; }))
                #   # coq-artifacts
                #   # coq-thirdparty
                #   # cmp-buffer
                #   # cmp-cmdline
                #   # cmp-async-path
                #   # cmp-nvim-lsp-signature-help
                #   #cmp-nvim-lsp
                #   # nvim-cmp

                # If using blink
                blink-cmp.packages.${pkgs.system}.default
                pkgs.neovimPlugins.blink-compat
                pkgs.neovimPlugins.lazydev
              ];

              #TODO: move as much as possible of the below to optional plugins
              #++ (with pkgs.vimPlugins; [ cmp-nvim-lsp cmp-path ]);
              editor = with pkgs.vimPlugins; [
                comment-nvim
                nvim-autopairs
                indent-blankline-nvim
              ];
              ui = with pkgs.vimPlugins; [
                #TODO: Trouble
                helpview-nvim
                dressing-nvim
                flash-nvim
                which-key-nvim
                rose-pine
                noice-nvim
                catppuccin-nvim
                telescope-nvim
                toggleterm-nvim
                telescope-fzf-native-nvim
                nvim-web-devicons
                fidget-nvim
                plenary-nvim
                todo-comments-nvim
                trouble-nvim
                gitsigns-nvim
                which-key-nvim
                neo-tree-nvim
                nui-nvim

                snacks-nvim
              ];
              language = {
                #lua = with pkgs.vimPlugins; [ lazydev-nvim ];
                rust = with pkgs.vimPlugins; [ rustaceanvim crates-nvim ];
                markdown = with pkgs.vimPlugins; [
                  render-markdown-nvim
                  obsidian-nvim
                ];
                idris = with pkgs.vimPlugins; [ idris2-nvim ];
                typst = with pkgs.vimPlugins; [ typst-preview-nvim ];
                java = with pkgs.vimPlugins;
                  [
                    # nvim-java
                    # nvim-java-refactor
                    # nvim-java-test
                    # nvim-java-dap
                    # nvim-java-core
                  ];
                c = with pkgs.vimPlugins; [ clangd_extensions-nvim ];
              };

              lsp = with pkgs.vimPlugins; [ nvim-lspconfig ];

              lint = with pkgs.vimPlugins; [ nvim-lint ];
              format = with pkgs.vimPlugins; [ conform-nvim ];

              snippets = with pkgs.vimPlugins; [
                nvim-snippets
                friendly-snippets
              ];
            };

          # not loaded automatically at startup.
          # use with packadd and an autocommand in config to achieve lazy loading
          optionalPlugins = {
            general = with pkgs.vimPlugins;
              [
                # nixCats will filter out duplicate packages
                # so you can put dependencies with stuff even if they're
                # also somewhere else
              ];

          };

          # shared libraries to be added to LD_LIBRARY_PATH
          # variable available to nvim runtime
          sharedLibraries = {
            general = with pkgs; [ libgit2 libvterm-neovim ];
          };

          # environmentVariables:
          # this section is for environmentVariables that should be available
          # at RUN TIME for plugins. Will be available to path within neovim terminal
          environmentVariables = {
            typst = {
              WEBSOCAT_PATH = "${pkgs.websocat}";
              TINYMIST_PATH = "${pkgs.tinymist}";
            };
            test = { CATTESTVAR = "It worked!"; };
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
          extraPython3Packages = { test = (_: [ ]); };
          # populates $LUA_PATH and $LUA_CPATH
          extraLuaPackages = {
            test = [ (_: [ ]) ];
            images = [ (p: with p; [ magick ]) ];
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
        nvim = { pkgs, ... }: {
          # they contain a settings set defined above
          # see :help nixCats.flake.outputs.settings
          settings = {
            wrapRc = true;
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
            images = true;
            editor = true;
            lint = true;
            debug = false; # TODO: set up debugging
            format = true;
            lsp = true;
            cmp = true;
            customPlugins = true;
            test = true;
            ui = true;
            language = {
              nix = true;
              markdown = true;
              python = true;
              lua = true;
              rust = true;
              #julia = true;
              typst = true;
              #java = true;
              c = true;
              idris = true;
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
            cDebugPath =
              "${pkgs.vscode-extensions.ms-vscode.cpptools}/share/vscode/extensions/ms-vscode.cpptools/debugAdapters/bin/OpenDebugAD7";
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
    in forEachSystem (system:
      let
        nixCatsBuilder = utils.baseBuilder luaPath {
          inherit nixpkgs system dependencyOverlays extra_pkg_config;
        } categoryDefinitions packageDefinitions;
        defaultPackage = nixCatsBuilder defaultPackageName;
        # this is just for using utils such as pkgs.mkShell
        # The one used to build neovim is resolved inside the builder
        # and is passed to our categoryDefinitions and packageDefinitions
        pkgs = import nixpkgs { inherit system; };
      in {
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
            inputsFrom = [ ];
            shellHook = "";
          };
        };

      }) // {

        # these outputs will be NOT wrapped with ${system}

        # this will make an overlay out of each of the packageDefinitions defined above
        # and set the default overlay to the one named here.
        overlays = utils.makeOverlays luaPath {
          inherit nixpkgs dependencyOverlays extra_pkg_config;
        } categoryDefinitions packageDefinitions defaultPackageName;

        # we also export a nixos module to allow reconfiguration from configuration.nix
        nixosModules.default = utils.mkNixosModules {
          inherit defaultPackageName dependencyOverlays luaPath
            categoryDefinitions packageDefinitions extra_pkg_config nixpkgs;
        };
        # and the same for home manager
        homeModule = utils.mkHomeModules {
          inherit defaultPackageName dependencyOverlays luaPath
            categoryDefinitions packageDefinitions extra_pkg_config nixpkgs;
        };
        inherit utils;
        inherit (utils) templates;
      };

}
