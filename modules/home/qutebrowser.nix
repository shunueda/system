{
  flake.homeModules.qutebrowser =
    { ... }:
    {
      programs.qutebrowser = {
        enable = true;
        enableDefaultBindings = false;
        searchEngines = {
          DEFAULT = "https://duckduckgo.com/?q={}";
        };
        keyBindings = {
          normal = {
            "<Alt-x>" = "set-cmd-text :";
            "<Ctrl-s>" = "set-cmd-text /";
            "<Ctrl-r>" = "set-cmd-text ?";
            "<Space>" = "hint";
            "<Escape>" = "clear-keychain ;; search ;; fullscreen --leave";
            "<Ctrl-g>" = "clear-keychain ;; search ;; fullscreen --leave";
            "<Ctrl-n>" = "scroll down";
            "<Ctrl-p>" = "scroll up";
            "<Ctrl-v>" = "scroll-page 0 0.5";
            "<Alt-v>" = "scroll-page 0 -0.5";
            "n" = "tab-next";
            "p" = "tab-prev";
            "k" = "tab-close";
            "<Alt-1>" = "tab-focus 1";
            "<Alt-2>" = "tab-focus 2";
            "<Alt-3>" = "tab-focus 3";
            "<Alt-4>" = "tab-focus 4";
            "<Alt-9>" = "tab-focus -1";
            "<Ctrl-x>b" = "set-cmd-text -s :buffer";
            "<Ctrl-x><Ctrl-f>" = "set-cmd-text -s :open -t";
            "yy" = "yank";
          };
          command = {
            "<Ctrl-a>" = "rl-beginning-of-line";
            "<Ctrl-e>" = "rl-end-of-line";
            "<Ctrl-k>" = "rl-kill-line";
            "<Ctrl-y>" = "rl-yank";
            "<Ctrl-n>" = "completion-item-focus next";
            "<Ctrl-p>" = "completion-item-focus prev";
            "<Ctrl-g>" = "mode-leave";
            "<Return>" = "command-accept";
          };
          insert = {
            "<Ctrl-g>" = "mode-leave";
            "<Ctrl-e>" = "edit-text";
          };
        };
        settings = {
          colors =
            let
              # One Dark / Base16 Palette
              bg_default = "#282c34";
              bg_lighter = "#353b45";
              bg_selection = "#3e4451";
              fg_disabled = "#565c64";
              fg_default = "#abb2bf";
              bg_lightest = "#c8ccd4";
              fg_error = "#e06c75";
              bg_hint = "#e5c07b";
              fg_matched_text = "#98c379";
              bg_passthrough_mode = "#56b6c2";
              bg_insert_mode = "#61afef";
              bg_warning = "#c678dd";
            in
            {
              completion = {
                fg = fg_default;
                odd.bg = bg_lighter;
                even.bg = bg_default;
                category = {
                  fg = bg_hint;
                  bg = bg_default;
                  border.top = bg_default;
                  border.bottom = bg_default;
                };
                item.selected = {
                  fg = fg_default;
                  bg = bg_selection;
                  border.top = bg_selection;
                  border.bottom = bg_selection;
                  match.fg = fg_matched_text;
                };
                match.fg = fg_matched_text;
                scrollbar = {
                  fg = fg_default;
                  bg = bg_default;
                };
              };
              contextmenu = {
                menu = {
                  bg = bg_default;
                  fg = fg_default;
                };
                selected = {
                  bg = bg_selection;
                  fg = fg_default;
                };
                disabled = {
                  bg = bg_lighter;
                  fg = fg_disabled;
                };
              };
              downloads = {
                bar.bg = bg_default;
                start = {
                  fg = bg_default;
                  bg = bg_insert_mode;
                };
                stop = {
                  fg = bg_default;
                  bg = bg_passthrough_mode;
                };
                error.fg = fg_error;
              };
              hints = {
                fg = bg_default;
                bg = bg_hint;
                match.fg = fg_default;
              };
              keyhint = {
                fg = fg_default;
                suffix.fg = fg_default;
                bg = bg_default;
              };
              messages = {
                error = {
                  fg = bg_default;
                  bg = fg_error;
                  border = fg_error;
                };
                warning = {
                  fg = bg_default;
                  bg = bg_warning;
                  border = bg_warning;
                };
                info = {
                  fg = fg_default;
                  bg = bg_default;
                  border = bg_default;
                };
              };
              prompts = {
                fg = fg_default;
                bg = bg_default;
                border = bg_default;
                selected.bg = bg_selection;
              };
              statusbar = {
                normal = {
                  fg = fg_matched_text;
                  bg = bg_default;
                };
                insert = {
                  fg = bg_default;
                  bg = bg_insert_mode;
                };
                passthrough = {
                  fg = bg_default;
                  bg = bg_passthrough_mode;
                };
                private = {
                  fg = bg_default;
                  bg = bg_lighter;
                };
                command = {
                  fg = fg_default;
                  bg = bg_default;
                };
                caret = {
                  fg = bg_default;
                  bg = bg_warning;
                  selection = {
                    fg = bg_default;
                    bg = bg_insert_mode;
                  };
                };
                progress.bg = bg_insert_mode;
                url = {
                  fg = fg_default;
                  error.fg = fg_error;
                  hover.fg = fg_default;
                  success = {
                    http.fg = bg_passthrough_mode;
                    https.fg = fg_matched_text;
                  };
                  warn.fg = bg_warning;
                };
              };
              tabs = {
                bar.bg = bg_default;
                indicator = {
                  start = bg_insert_mode;
                  stop = bg_passthrough_mode;
                  error = fg_error;
                };
                odd = {
                  fg = fg_default;
                  bg = bg_lighter;
                };
                even = {
                  fg = fg_default;
                  bg = bg_default;
                };
                selected = {
                  odd = {
                    fg = fg_default;
                    bg = bg_selection;
                  };
                  even = {
                    fg = fg_default;
                    bg = bg_selection;
                  };
                };
                pinned = {
                  odd = {
                    fg = bg_lightest;
                    bg = fg_matched_text;
                  };
                  even = {
                    fg = bg_lightest;
                    bg = bg_passthrough_mode;
                  };
                  selected = {
                    odd = {
                      fg = fg_default;
                      bg = bg_selection;
                    };
                    even = {
                      fg = fg_default;
                      bg = bg_selection;
                    };
                  };
                };
              };
            };
        };
      };
    };
}
