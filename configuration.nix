{ pkgs, pkgs-unstable, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  nixpkgs.overlays =
    [ (final: prev: { quickshell = pkgs-unstable.quickshell; }) ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nix = { settings = { experimental-features = [ "nix-command" "flakes" ]; }; };
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  time.timeZone = "Europe/Berlin";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  environment.variables = {
    XDG_CURRENT_DESKTOP = "wlroots";
    XDG_SESSION_DESKTOP = "wlroots";
    GTK_THEME = "Adwaita-dark";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

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

  # services.greetd = {
  #   enable = true;
  #   settings = {
  #     default_session = {
  #       command = "${pkgs.mangowc}/bin/mango";
  #       user = "sebi";
  #     };
  #   };
  # };

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
  programs.zsh.enable = true;

  # Define a user account. Set a password with ‘passwd’.
  users.users.sebi = {
    isNormalUser = true;
    description = "sebastian";
    extraGroups = [ "networkmanager" "wheel" "audio" "video" ];
    # packages = with pkgs; [
    # ];
    shell = pkgs.zsh;
  };

  nixpkgs.config.allowUnfree = true;

  fonts = {
    enableDefaultPackages = true;

    packages = with pkgs; [ nerd-fonts.jetbrains-mono nerd-fonts.fira-code ];
  };

  programs.mango.enable = true;

  environment.systemPackages = with pkgs; [
    adwaita-qt
    quickshell
    # mango
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
  ];

  system.stateVersion = "25.05";
}
