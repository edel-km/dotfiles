# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, modulesPath, currentSystem, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      (modulesPath + "/profiles/qemu-guest.nix")
      ./hardware/parallels-unfree/parallels-guest.nix
    ];

  disabledModules = [
    "virtualisation/parallels-guest.nix"
  ];

  # Use the systemd-boot EFI boot loader.
  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;
  boot = {
    kernelPackages = pkgs.linuxPackages_5_15;
    loader = {
      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
        gfxmodeEfi = "1920x1080";
	gfxpayloadEfi = "keep";
      };
      efi.canTouchEfiVariables = true;
    };
  };

  # nix.extraOptions = ''experimental-features = nix-command flakes'';

  nixpkgs.config = {
    allowUnfree = true;
    allowUnsupportedSystem = true;
    allowBroken = true;
  };

  hardware.enableAllFirmware = true;
  hardware.video.hidpi.enable = true;
  hardware.parallels = {
    enable = true;
    package = (config.boot.kernelPackages.callPackage ./hardware/parallels-unfree/prl-tools.nix {});
  };

  services = {
    picom = {
      enable = true;
      settings = {
        blur =
	  {
	    method = "gaussian";
	    size = 10;
	    deviation = 5.0;
	  };
	};
      fade = true;
      activeOpacity = 0.8;
      inactiveOpacity = 0.5;
    };

    xserver = {
      enable = true;
      layout = "de";
      dpi = 220;

      desktopManager = {
        xterm.enable = false;
        wallpaper.mode = "scale";

      };

      displayManager = {
        defaultSession = "none+i3";
        lightdm.enable = true;

        # sessionCommands = ''
        #   ${pkgs.xlibs.xset}/bin/xset r rate 200 40
        # '' + # (if currentSystem == "aarch64-linux" then 
	# ''
        #   ${pkgs.xorg.xrandr}/bin/xrandr -s '2560x1600'
        # '' # else "")
	# ;
      }; 

      windowManager.i3 = {
        enable = true;
	package = pkgs.i3-gaps;
     };
    };
  };

  fonts = {
    fontDir.enable = true;

    fonts = [
      pkgs.fira-code
    ];
  };


  # Select internationalisation properties.
  i18n.defaultLocale = "de_AT.UTF-8";
    console = {
    font = "Lat2-Terminus16";
    keyMap = "de";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.km = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  };

  security.sudo.wheelNeedsPassword = false;

  environment.systemPackages = with pkgs; [
    # Editors
    vim
    neovim
    nano
    #CLI Tools
    neofetch
    htop
    # Terminals
    alacritty
    # Tools
    git
    wget
    pciutils
    emacs
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?

}

