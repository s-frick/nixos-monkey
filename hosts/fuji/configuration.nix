{ config, pkgs, lib, inputs, pkgs-unstable, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../common

    ../../modules/mango.nix

    inputs.home-manager.nixosModules.home-manager
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;


  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-wlr pkgs.xdg-desktop-portal-gtk ];
    xdgOpenUsePortal = true;
    wlr.enable = true;
    wlr.settings = {
      screencast = {
        output_name = "HDMI-A-1";
        max_fps = 30;
        exec_before = "disable_notifications.sh";
        exec_after = "enable_notifications.sh";
        chooser_type = "simple";
        chooser_cmd = "${pkgs.slurp}/bin/slurp -f %o -or";
      };
    };

    config = {
      common = { "org.freedesktop.impl.portal.ScreenCast" = [ "wlr" ]; };
    };
  };

  # Define a user account. Set a password with ‘passwd’.
  users.users.sebi = {
    isNormalUser = true;
    description = "sebastian";
    extraGroups = [ "networkmanager" "wheel" "audio" "video" ];
    # packages = with pkgs; [
    # ];
    shell = pkgs.zsh;
  };


  fonts = {
    enableDefaultPackages = true;

    packages = with pkgs; [ nerd-fonts.jetbrains-mono nerd-fonts.fira-code ];
  };

  programs.mango.enable = true;
  programs.zsh.enable = true;
  programs.dconf.enable = true;

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    adwaita-qt
    adwaita-icon-theme
    quickshell
    foot
    sox
    wlr-randr
    pipewire
    wireplumber
    xdg-desktop-portal
    xdg-desktop-portal-gtk
    xdg-desktop-portal-wlr
    grim
    slurp

    coreutils-full
    gnumake
    tree
    git
    lazygit
    tmux
    vim
    wget
    kitty
    brave

    # Audio/video
    pavucontrol
    playerctl
    obs-studio

    gimp3
  ];

  programs.obs-studio = {
    enable = true;
    enableVirtualCamera = true;
    plugins = with pkgs; [ 
      obs-studio-plugins.wlrobs
      obs-studio-plugins.droidcam-obs
    ];
  };
  nixpkgs.overlays =
    [ (final: prev: { quickshell = pkgs-unstable.quickshell; }) ];


  home-manager = {
    useGlobalPkgs = true; # teilt pkgs mit NixOS
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs pkgs-unstable; };
    users.sebi = { ... }: {
      imports = [
        inputs.mangowc.hmModules.mango
        inputs.dankMaterialShell.homeModules.dankMaterialShell.default
      ];
      home.username = "sebi";
      home.homeDirectory = "/home/sebi";
      home.stateVersion = "25.05";


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
    };
  };
}
