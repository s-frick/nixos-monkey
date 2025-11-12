{ pkgs, ... }:

{
#  programs.hyprland = {
#    enable = true;
#    xwayland.enable = true;
#  };


  programs.hyprland.enable = true; 
  programs.hyprland.xwayland.enable = true; 


  services.displayManager = {
    sddm.enable = true;
    sddm.wayland.enable = true;
    defaultSession = "hyprland";
    sddm.theme = "chili";          # Verzeichnisname des Themes
  };

  environment.systemPackages = with pkgs; [
    sddm-chili-theme               # ← richtiges Paket in 25.05
    bibata-cursors
  ];

  # (Optional) Cursor im Greeter
  services.displayManager.sddm.settings.Theme.CursorTheme = "Bibata-Modern-Ice";

  home-manager.backupFileExtension = "hm-bak";
  home-manager.users.sebi = { pkgs, ... }: {

    xdg.configFile."hypr/hyprland.conf".text = ''
    monitor=,preferred,auto,auto
    
    # Set programs that you use
    $terminal = kitty
    $fileManager = dolphin
    $menu = wofi --show drun
    
    
    #################
    ### AUTOSTART ###
    #################
    
    # Autostart necessary processes (like notifications daemons, status bars, etc.)
    # Or execute your favorite apps at launch like this:
    
    # exec-once = $terminal
    # exec-once = nm-applet &
    # exec-once = waybar & hyprpaper & firefox
    exec-once = waybar & hyprpaper & $terminal &
    # exec-once = hyprpaper & $terminal &
    
    env = XCURSOR_SIZE,24
    env = HYPRCURSOR_SIZE,24
    
    # https://wiki.hyprland.org/Configuring/Variables/#general
    general {
        gaps_in = 4
        gaps_out = 12
    
        border_size = 1
    
        # https://wiki.hyprland.org/Configuring/Variables/#variable-types for info about colors
        col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
        col.inactive_border = rgba(595959aa)
    
        # Set to true enable resizing windows by clicking and dragging on borders and gaps
        resize_on_border = false
    
        # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
        allow_tearing = false
    
        layout = dwindle
    }
    
    # https://wiki.hyprland.org/Configuring/Variables/#decoration
    decoration {
        rounding = 4
        rounding_power = 2
    
        # Change transparency of focused and unfocused windows
        active_opacity = 0.94
        inactive_opacity = 0.8
    
        shadow {
            enabled = true
            range = 4
            render_power = 3
            color = rgba(1a1a1aee)
        }
    
        # https://wiki.hyprland.org/Configuring/Variables/#blur
        blur {
            enabled = true
            size = 3
            passes = 1
    
            vibrancy = 0.1696
        }
    }
    
    # https://wiki.hyprland.org/Configuring/Variables/#animations
    animations {
        enabled = yes, please :)
    
        # Default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more
    
        bezier = easeOutQuint,0.23,1,0.32,1
        bezier = easeInOutCubic,0.65,0.05,0.36,1
        bezier = linear,0,0,1,1
        bezier = almostLinear,0.5,0.5,0.75,1.0
        bezier = quick,0.15,0,0.1,1
    
        animation = global, 1, 10, default
        animation = border, 1, 5.39, easeOutQuint
        animation = windows, 1, 4.79, easeOutQuint
        animation = windowsIn, 1, 4.1, easeOutQuint, popin 87%
        animation = windowsOut, 1, 1.49, linear, popin 87%
        animation = fadeIn, 1, 1.73, almostLinear
        animation = fadeOut, 1, 1.46, almostLinear
        animation = fade, 1, 3.03, quick
        animation = layers, 1, 3.81, easeOutQuint
        animation = layersIn, 1, 4, easeOutQuint, fade
        animation = layersOut, 1, 1.5, linear, fade
        animation = fadeLayersIn, 1, 1.79, almostLinear
        animation = fadeLayersOut, 1, 1.39, almostLinear
        animation = workspaces, 1, 1.94, almostLinear, fade
        animation = workspacesIn, 1, 1.21, almostLinear, fade
        animation = workspacesOut, 1, 1.94, almostLinear, fade
    }
    
    # Ref https://wiki.hyprland.org/Configuring/Workspace-Rules/
    # "Smart gaps" / "No gaps when only"
    # uncomment all if you wish to use that.
    # workspace = w[tv1], gapsout:0, gapsin:0
    # workspace = f[1], gapsout:0, gapsin:0
    # windowrule = bordersize 0, floating:0, onworkspace:w[tv1]
    # windowrule = rounding 0, floating:0, onworkspace:w[tv1]
    # windowrule = bordersize 0, floating:0, onworkspace:f[1]
    # windowrule = rounding 0, floating:0, onworkspace:f[1]
    
    # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
    dwindle {
        pseudotile = true # Master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
        preserve_split = true # You probably want this
    }
    
    # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
    master {
        new_status = master
    }
    
    # https://wiki.hyprland.org/Configuring/Variables/#misc
    misc {
        force_default_wallpaper = -1 # Set to 0 or 1 to disable the anime mascot wallpapers
        disable_hyprland_logo = false # If true disables the random hyprland logo / anime girl background. :(
    }
    
    
    #############
    ### INPUT ###
    #############
    
    # https://wiki.hyprland.org/Configuring/Variables/#input
    input {
        kb_layout = us
        kb_variant =
        kb_model =
        kb_options =
        kb_rules =
    
        follow_mouse = 1
    
        sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
    
        touchpad {
            natural_scroll = false
        }
    }
    
    # https://wiki.hyprland.org/Configuring/Variables/#gestures
    gestures {
        workspace_swipe = false
    }
    
    # Example per-device config
    # See https://wiki.hyprland.org/Configuring/Keywords/#per-device-input-configs for more
    device {
        name = epic-mouse-v1
        sensitivity = -0.5
    }
    
    
    ###################
    ### KEYBINDINGS ###
    ###################
    
    # See https://wiki.hyprland.org/Configuring/Keywords/
    $mainMod = SUPER # Sets "Windows" key as main modifier
    
    # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
    bind = $mainMod, T, exec, $terminal
    bind = $mainMod, ENTER, exec, $terminal
    bind = $mainMod SHIFT, Q, killactive,
    bind = $mainMod SHIFT, E, exit,
    bind = $mainMod, E, exec, $fileManager
    bind = $mainMod, V, togglefloating,
    bind = $mainMod, D, exec, $menu
    bind = $mainMod, P, pseudo, # dwindle
    bind = $mainMod, J, togglesplit, # dwindle
    
    # Move focus with mainMod + arrow keys
    bind = $mainMod, H, movefocus, l
    bind = $mainMod, L, movefocus, r
    bind = $mainMod, K, movefocus, u
    bind = $mainMod, J, movefocus, d
    
    # Switch workspaces with mainMod + [0-9]
    bind = $mainMod, 1, workspace, 1
    bind = $mainMod, 2, workspace, 2
    bind = $mainMod, 3, workspace, 3
    bind = $mainMod, 4, workspace, 4
    bind = $mainMod, 5, workspace, 5
    bind = $mainMod, 6, workspace, 6
    bind = $mainMod, 7, workspace, 7
    bind = $mainMod, 8, workspace, 8
    bind = $mainMod, 9, workspace, 9
    bind = $mainMod, 0, workspace, 10
    
    # Move active window to a workspace with mainMod + SHIFT + [0-9]
    bind = $mainMod SHIFT, 1, movetoworkspace, 1
    bind = $mainMod SHIFT, 2, movetoworkspace, 2
    bind = $mainMod SHIFT, 3, movetoworkspace, 3
    bind = $mainMod SHIFT, 4, movetoworkspace, 4
    bind = $mainMod SHIFT, 5, movetoworkspace, 5
    bind = $mainMod SHIFT, 6, movetoworkspace, 6
    bind = $mainMod SHIFT, 7, movetoworkspace, 7
    bind = $mainMod SHIFT, 8, movetoworkspace, 8
    bind = $mainMod SHIFT, 9, movetoworkspace, 9
    bind = $mainMod SHIFT, 0, movetoworkspace, 10
    
    # Example special workspace (scratchpad)
    bind = $mainMod, S, togglespecialworkspace, magic
    bind = $mainMod SHIFT, S, movetoworkspace, special:magic
    
    # Scroll through existing workspaces with mainMod + scroll
    bind = $mainMod, mouse_down, workspace, e+1
    bind = $mainMod, mouse_up, workspace, e-1
    
    # Move/resize windows with mainMod + LMB/RMB and dragging
    bindm = $mainMod, mouse:272, movewindow
    bindm = $mainMod, mouse:273, resizewindow
    
    # Laptop multimedia keys for volume and LCD brightness
    bindel = ,XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+
    bindel = ,XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
    bindel = ,XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
    bindel = ,XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
    bindel = ,XF86MonBrightnessUp, exec, brightnessctl -e4 -n2 set 5%+
    bindel = ,XF86MonBrightnessDown, exec, brightnessctl -e4 -n2 set 5%-
    
    # Requires playerctl
    bindl = , XF86AudioNext, exec, playerctl next
    bindl = , XF86AudioPause, exec, playerctl play-pause
    bindl = , XF86AudioPlay, exec, playerctl play-pause
    bindl = , XF86AudioPrev, exec, playerctl previous
    
    ##############################
    ### WINDOWS AND WORKSPACES ###
    ##############################
    
    # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more
    # See https://wiki.hyprland.org/Configuring/Workspace-Rules/ for workspace rules
    
    # Example windowrule
    # windowrule = float,class:^(kitty)$,title:^(kitty)$
    
    # Ignore maximize requests from apps. You'll probably like this.
    windowrule = suppressevent maximize, class:.*
    
    # Fix some dragging issues with XWayland
    windowrule = nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0
    '';
    home.stateVersion = "25.05"; 

    programs.waybar = {
      enable = true;
      package = pkgs.waybar;
      systemd.enable = false;
  
      # Hyprland-Module nutzen:
      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          height = 15;
  
          modules-left   = [ "hyprland/workspaces" "hyprland/window" ];
          modules-center = [ "clock" ];
          modules-right  = [ "pulseaudio" "network" "battery" "tray" ];
  
          clock = {
            format = "{:%H:%M}";
            tooltip-format = "{:%A, %d.%m.%Y}";
          };
  
          pulseaudio = { format = "{volume}% "; on-click = "pavucontrol"; };
  
          network = {
            format-wifi = "  {essid} {signalStrength}%";
            format-ethernet = "  {ipaddr}";
            format-disconnected = "  offline";
            tooltip = true;
          };
  
          battery = {
            format = "{capacity}% {icon}";
            format-icons = [ "" "" "" "" "" ];
            states = { warning = 20; critical = 10; };
          };
  
          tray = { spacing = 6; icon-size = 14; };  # <- icon-size hinzufügen, spacing etwas runter
        };
      };

    style = ''
      /* globale Mindesthöhe killen */
      * { min-height: 0; }
      
      /* Waybar-Hülle ohne eigene Mindesthöhe */
      window#waybar { border: none; box-shadow: none; }
      
      /* Workspaces-Buttons klein halten (GTK-Themes setzen oft 36px) */
      #workspaces button {
        min-height: 0;
        padding: 0 6px;
        margin: 0 3px;
      }
      
      /* Module kompakt */
      #clock, #battery, #pulseaudio, #network, #tray { padding: 0 6px; }
      window#waybar { background: rgba(20,20,24,.0); color: #e6e6e6; } 
      #workspaces button.focused { background: #444; } 
      #clock,#battery,#pulseaudio,#network,#tray { padding: 0 10px; } 
      #battery.warning { color: #ffcc00; } 
      #battery.critical { color: #ff5555; } 
      window#waybar { border: none; }


      * { font-family: "JetBrainsMono Nerd Font","FiraCode Nerd Font",monospace; font-size: 8pt; }
      window#waybar {
        border: none;
      }
      #network       { background: rgba(20,20,74,.0); color: #e6e6e6; }   /* grünlich für WLAN/LAN */
      #pulseaudio    { background: rgba(20,20,74,.0); color: #e6e6e6; }   /* bläulich für Audio */
      #battery       { background: rgba(20,20,74,.0); color: #e6e6e6; }   /* amber für Akku */
      #tray          { background: rgba(20,20,74,.0); color: #e6e6e6; }   /* helles Blau für Tray */
      .modules-center {
        background: rgba(20,20,74,.7);
        border-bottom-left-radius: 36px;
        border-bottom-right-radius: 36px;
	border-right: 1px solid rgba(51, 204, 255, 0.93);
	border-left: 1px solid rgba(51, 204, 255, 0.93);
	border-bottom: 1px solid rgba(51, 204, 255, 0.93);
        border-top: none;
	padding: 2px 16px 4px;
      }
      .modules-right {
        background: rgba(20,20,74,.7);
        border-bottom-left-radius: 36px;
	border-left: 1px solid rgba(51, 204, 255, 0.93);
	border-bottom: 1px solid rgba(51, 204, 255, 0.93);
        border-right: none;
        border-top: none;
        padding: 2px 16px 4px;
      }
      .modules-left {
        background: rgba(20,20,74,.7);
        border-bottom-right-radius: 36px;
	border-right: 1px solid rgba(51, 204, 255, 0.93);
	border-bottom: 1px solid rgba(51, 204, 255, 0.93);
        border-left: none;
        border-top: none;
        padding: 2px 16px 4px;
      }
    '';
  };
  };
}
