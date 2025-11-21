{ config, pkgs, pkgs-unstable, ... }:
{

  home.username = "sebi";
  home.homeDirectory = "/home/sebi";
  home.stateVersion = "25.05";

  # alles dark per default
  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    iconTheme = {
      name = "Adwaita";
      package = pkgs.gnome-themes-extra;
    };
  };

  qt = {
    enable = true;
    platformTheme = "gtk";
    style.name = "Adwaita-Dark";
  };


  programs.quickshell = {
    enable = true;
    # package = pkgs-unstable.quickshell;
    # activeConfig brauchst du i.d.R. nicht setzen,
    # DMS legt configs/activeConfig selbst passend an.
  };

  programs.dankMaterialShell = {
    enable = true;
    #quickshell.package = pkgs-unstable.quickshell;
    systemd = {
      enable = true;             # Systemd service for auto-start
      restartIfChanged = true;   # Auto-restart dms.service when dankMaterialShell changes
    };
    
    # Core features
    enableSystemMonitoring = true;     # System monitoring widgets (dgop)
    enableClipboard = true;            # Clipboard history manager
    enableVPN = true;                  # VPN management widget
    enableBrightnessControl = true;    # Backlight/brightness controls
    enableColorPicker = true;          # Color picker tool
    enableDynamicTheming = true;       # Wallpaper-based theming (matugen)
    enableAudioWavelength = true;      # Audio visualizer (cava)
    enableCalendarEvents = true;       # Calendar integration (khal)
    enableSystemSound = true;          # System sound effects
  };

  programs.zsh = {
    enable = true;

    # optional: als Login-Shell setzen
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ll = "ls -la";
      gs = "git status";
      gp = "git pull";
      lg = "lazygit";
      vim = "nvim";
      rebuild = "sudo nixos-rebuild switch --flake /home/sebi/git/configs/nixos-monkey#fuji";
    };

    # optional: zusätzliche RC-Dateien / Einstellungen
    initContent = ''
      # hier kannst du alles reinschreiben, was sonst in .zshrc stehen würde
      source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
      export EDITOR="nvim"
      bindkey -v
    '';
  };

  programs.tmux = {
    enable = true;
    # clock24 = true;
    # mouse = true;
    historyLimit = 100000;
    baseIndex = 1;
    # keyMode = "vi";
    terminal = "tmux-256color";

    plugins = with pkgs.tmuxPlugins; [ 
      nord
      yank
    ];

    extraConfig = ''
      set -ga terminal-overrides ",*:RGB"

      bind-key -T copy-mode-vi 'v' send -X begin-selection
      bind-key -T copy-mode-vi 'y' send -X copy-selection-and-cancel
      set -g focus-events on
      unbind C-b
      set-option -g prefix C-Space
      bind-key C-Space send-prefix
      # switch panes using Alt-arrow without prefix
      bind -n C-h select-pane -L
      bind -n C-l select-pane -R
      bind -n C-k select-pane -U
      bind -n C-j select-pane -D

      # resizing mit Alt/Meta + hjkl
      bind -n M-h resize-pane -L 10
      bind -n M-l resize-pane -R 10
      bind -n M-k resize-pane -U 10
      bind -n M-j resize-pane -D 10

      # don't rename windows automatically
      set-option -g allow-rename off
    '';
  };

  programs.starship.enable = true;

  programs.waybar = {
    enable = false;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        exclusive = true;
        passthrough = false;
        #gtk-layer-shell = true;
        ipc = false;
        # "reload_style_on_change" = true;
        height = 50;
        margin = "0";
        modules-left = [
            "dwl/tags"
            "dwl/window"
            "wlr/taskbar"
        ];
        modules-center = [
            "mpris"
        ];
        modules-right = [
            "clock"
            "battery"
            "pulseaudio"
            "custom/notification"
            "tray"
            "custom/power"
        ];
        #  Modules configuration
        "dwl/tags" = {
            num-tags = 9;
            hide-vacant = true;
            expand = false;
            disable-click = true;
            tag-labels = [
            ];
        
        };
        "dwl/window" = {
            format = "{app_id} | {title}";
            max-length = 50;
            rewrite = {
                " \\| " = "";
            };
        };
        "wlr/taskbar" = {
           format = "{icon}";
            icon-size = 22;
            all-outputs = false;
            tooltip-format = "{title}";
            markup = true;
            on-click = "activate";
            on-click-right = "close";
            ignore-list = ["Rofi" "wofi"];
        };
        tray = {
            icon-size = 21;
            spacing = 10;
        };
        mpris = {
            format = "{player_icon} {artist} - {title}";
            format-paused = "{status_icon} <i>{artist} - {title}</i>";
            player-icons = {
                vivaldi-stable = "▶";
                spotify = "";
                default = "";
            };
            status-icons = {
                paused = "";
            };
            max-length = 80;
            #  "ignored-players" = ["firefox"]
        };
        "custom/music" = {
            format = "  {}";
            escape = true;
            interval = 5;
            tooltip = false;
            exec = "playerctl metadata --format='{{ titles }}'";
            on-click = "playerctl play-pause";
            max-length = 50;
        };
        clock = {
            #  "timezone" = "America/New_York";
            tooltip-format = "<big>{ =%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
            format-alt = "󰥔 { =%d/%m/%Y}";
            format = "󰥔 { =%H =%M}";
        };
        battery = {
            states = {
                #  "good" = 95;
                warning = 30;
                critical = 15;
            };
            format = "{icon} {capacity}%";
              tooltip = false;
              menu = "on-click";
            menu-file = "~/.config/maomao/waybar/battery_menu.xml";
            menu-actions = {
             performance = "powerprofilesctl set performance";
             balanced = "powerprofilesctl set balanced";
             powersaver = "powerprofilesctl set power-saver";
            }; 
    
            #  "format-alt" = "{icon}";
            #  "format-charging" = "";
            #  "format-plugged" = "";
            format-icons = ["󰂎" "󰁻" "󰁽" "󰁿" "󰂁" "󰁹"];
        };
        pulseaudio = {
            disable-scroll = true;
            format = "{icon} {volume}%";
            format-muted = "";
            format-icons = {
                default = ["" "" ""];
            };
            on-click = "pavucontrol";
        };
        "custom/notification" = {
            format = "{icon} {text}";
            tooltip = false;
            format-icons = {
                notification = "󱅫";
                none = "";
                dnd-notification = "";
                dnd-none = "󰂛";
                inhibited-notification = "";
                inhibited-none = "";
                dnd-inhibited-notification = "";
                dnd-inhibited-none = "";
            };
            return-type = "json";
            exec-if = "which swaync-client";
            exec = "swaync-client -swb";
            on-click = "swaync-client -t -sw";
            on-click-right = "swaync-client -d -sw";
            escape = true;
        };
        "custom/power" = {
          format  = "⏻";
          tooltip = false;
          on-click = "wlogout";
        };
      };
    };
    style = ''
      * {
        /* `otf-font-awesome` and SpaceMono Nerd Font are required to be installed for icons */
        font-family: "Fira Sans Semibold", FontAwesome, Roboto, Helvetica, Arial, sans-serif;
        font-size: 15px;
        transition: background-color .3s ease-out;
      }
      
      window#waybar {
          background: rgba(26, 27, 38, 0.75);
          color: #c0caf5;
          font-family: 
              SpaceMono Nerd Font,
              feather;
          transition: background-color .5s;
      }
      
      .modules-left,
      .modules-center,
      .modules-right
      {
          background: rgba(0, 0, 8, .7);
          margin: 5px 10px;
          padding: 0 5px;
          border-radius: 15px;
      }
      .modules-left {
          padding: 0;
      }
      .modules-center {
          padding: 0 10px;
      }
      
      #clock,
      #battery,
      #cpu,
      #memory,
      #disk,
      #temperature,
      #backlight,
      #network,
      #pulseaudio,
      #wireplumber,
      #custom-media,
      #tray,
      #mode,
      #idle_inhibitor,
      #scratchpad,
      #power-profiles-daemon,
      #language,
      #mpd {
          padding: 0 10px;
          border-radius: 15px;
      }
      
      #clock:hover,
      #battery:hover,
      #cpu:hover,
      #memory:hover,
      #disk:hover,
      #temperature:hover,
      #backlight:hover,
      #network:hover,
      #pulseaudio:hover,
      #wireplumber:hover,
      #custom-media:hover,
      #tray:hover,
      #mode:hover,
      #idle_inhibitor:hover,
      #scratchpad:hover,
      #power-profiles-daemon:hover,
      #language:hover,
      #mpd:hover {
          background: rgba(26, 27, 38, 0.9);
      }
      
      
      #workspaces button {
        background: transparent;
        font-family:
          SpaceMono Nerd Font,
          feather;
        font-weight: 900;
        font-size: 13pt;
        color: #c0caf5;
        border:none;
        border-radius: 15px;
      }
      
      #workspaces button.active {
          background: #13131d; 
      }
      
      #workspaces button:hover {
        background: #11111b;
        color: #cdd6f4;
        box-shadow: none;
      }
      
      #custom-arch {
          margin-left: 5px;
          padding: 0 10px;
          font-size: 25px;
          transition: color .5s;
      }
      #custom-arch:hover {
          color: #1793d1;
      }
    '';
  };
}

