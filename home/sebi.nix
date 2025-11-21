{ config, pkgs, ... }:
{

  home.username = "sebi";
  home.homeDirectory = "/home/sebi";
  home.stateVersion = "25.05";

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
      rebuild = "sudo nixos-rebuild switch --flake ~/.config/nixos#fuji";
    };

    # optional: zusätzliche RC-Dateien / Einstellungen
    initContent = ''
      # hier kannst du alles reinschreiben, was sonst in .zshrc stehen würde
      source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
      export EDITOR="nvim"
      bindkey -v
    '';
  };

  programs.starship.enable = true;

  programs.waybar = {
    enable = true;
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

