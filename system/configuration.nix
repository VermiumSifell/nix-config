{ inputs, lib, config, pkgs, wallpaper, gtk-theme, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  hardware = {
    nvidia.prime = {
      sync.enable = true;

      nvidiaBusId = "PCI:1:0:0";
      amdgpuBusId = "PCI:5:0:0";
    };

    bluetooth.enable = true;

    opengl.enable = true;
    opengl.driSupport32Bit = true;
  };

  boot = {
    loader = {
      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
      };

      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/efi";
      };
    };
  };

  time.timeZone = "Europe/Stockholm";

  networking = {
    hostName = "AxelLaptop01";
    networkmanager.enable = true;
  };

  users.users = {
    vermium = {
      isNormalUser = true;
      extraGroups = [ "wheel" "docker" "networkmanager" ];
      shell = pkgs.zsh;
    };
  };

  virtualisation = {
    docker = {
      enable = true;
      storageDriver = "btrfs";
    };
  };

  security = {
    rtkit.enable = true;
  };

  # TODO: Refactor into modules
  services = {
    xserver = {
      enable = true;
      layout = "se";

      # Touchpad support
      libinput = {
        enable = true;
        touchpad.tapping = true;
      };

      videoDrivers = [ "nvidia" ];

      displayManager = {
        lightdm = {
          enable = true;
          background = wallpaper;
          greeters.gtk.theme = gtk-theme;
        };
        defaultSession = "none+i3";
      };
      windowManager = {
        i3.enable = true;
        awesome.enable = true;
      };
    };

    openssh = {
      enable = true;
      # Forbid root login through SSH.
      permitRootLogin = "no";
      # Use keys only. Remove if you want to SSH using password (not recommended)
      passwordAuthentication = false;
    };

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;
    };

    autorandr = { enable = true; };

    blueman = { enable = true; };

  };

  programs = {
    slock = {
      enable = true;
    };

    steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    };

    dconf = { enable = true; };
  };

  environment = {
    systemPackages = with pkgs; [
      dmenu
      libnotify
      slock
      playerctl
      rofi
      brightnessctl
      feh
      pulseaudio
      rofi-bluetooth
    ];
  };

  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    experimental-features = "nix-command flakes";
    auto-optimise-store = true;
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "22.05";
}
