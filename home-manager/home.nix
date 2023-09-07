# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ inputs, lib, config, pkgs, ... }: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = (_: true);
    };
  };

  # TODO: Set your username
  home = {
    username = "k0";
    homeDirectory = "/home/k0";
  };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  home.packages = with pkgs; [
    steam
    kitty
    vscodium
    discord
    gimp
    firefox-wayland
    ungoogled-chromium
    brave
    obsidian
    prismlauncher
    bitwarden
    emacs
    blender
    nerdfonts
    mpd
  ];
  
  wayland.windowManager.hyprland.extraConfig = ''
    $mod = SUPER
    
    monitor=eDP-1,1920x1080@60,0x0,1

    bind = $mod, F, exec, firefox
    bind = , Print, exec, grimblast copy area
    bind = $mod, Return, exec, kitty
    # workspaces
    binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
   

    ${builtins.concatStringsSep "\n" (builtins.genList (
        x: let
  	  ws = let
  	    c = (x + 1) / 10;
  	  in
  	    builtins.toString (x + 1 - (c* 10));
  	in ''
          bind = $mod, ${ws}, workspace, ${toString (x + 1)}
  	  bind = $mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}
  	''
      )
      10)}
  
      #...
    '';
  
  #wayland.windowManager.hyprland.enable = true; 
  wayland.windowManager.hyprland.enableNvidiaPatches = true;
  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git = {
    enable = true;  
    userName = "Andrew Newcomer";
    userEmail = "newcomerandrew@outlook.com";
  };
  programs.gh = {
    enable = true;
  };
  
  #wayland.windowManager.sway = {
  #  enable = true;
  #  extraSessionCommands = ''
  #    dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY
  #  '';
  #  config = rec {
  #    modifier = "Mod4";
  #    # Use kitty as default terminal
  #    terminal = "kitty"; 
  #    startup = [
  #      # Launch Firefox on start
  #      {command = "firefox";}
  #    ];
  #  };
  #};

 programs.waybar.enable = true;
  
  dconf.settings = {
  "org/virt-manager/virt-manager/connections" = {
    autoconnect = ["qemu:///system"];
    uris = ["qemu:///system"];
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
