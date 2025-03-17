{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    supportedFilesystems = [ "ntfs" ];
  };

  networking = {
    firewall.checkReversePath = false;
    nameservers = [ "1.1.1.1" "1.0.0.1" ];
    hostName = "nixos";
    networkmanager = {
      enable = true;
      dns = "none";
    };
  };

  services = {
    automatic-timezoned.enable = true;
    gnome.gnome-keyring.enable = true;
    pipewire = {
      enable = true;
      audio.enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };

  virtualisation.vmware.host.enable = true;

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      addons = with pkgs; [
        fcitx5-rime
        fcitx5-hangul
      ];
      settings = {
        globalOptions = {
          "Hotkey" = { "EnumerateWithTriggerKeys" = true; };
          "Hotkey/EnumerateForwardKeys" = { "0" = "Super+space"; };
        };
        inputMethod = {
          "Groups/0" = {
            Name = "Default";
            "Default Layout" = "gb";
            DefaultIM = "keyboard-gb";
          };
          "Groups/0/Items/0".Name = "keyboard-gb";
          "Groups/0/Items/1".Name = "rime";
          "Groups/0/Items/2".Name = "hangul";
          GroupOrder."0" = "Default";
        };
      };
    };
  };

  fonts = {
    enableDefaultPackages = true;
    fontDir.enable = true;
    packages = with pkgs; [
      noto-fonts
      noto-fonts-extra
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      nerd-fonts.jetbrains-mono
    ];
  };

  hardware.bluetooth.enable = true;

  specialisation = { 
    nvidia.configuration = { 
      services.xserver.videoDrivers = [ "nvidia" ];
      hardware.nvidia = {
        open = true;
        modesetting.enable = true;
        nvidiaSettings = true;
        package = config.boot.kernelPackages.nvidiaPackages.stable;
        prime = {
          offload = {
            enable = true;
            enableOffloadCmd = true;
          };
          nvidiaBusId = "PCI:1:0:0";
          amdgpuBusId = "PCI:5:0:0";
        };
      };
    };
  };

  nixpkgs.config.allowUnfree = true;
  nix = {
    optimise.automatic = true;
    settings.auto-optimise-store = true;
  };

  users.users.darren = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "networkmanager" ];
  };

  environment = {
    variables = {
      ELECTRON_OZONE_PLATFORM_HINT = "wayland";
      GTK_IM_MODULE = "fcitx";
      QT_IM_MODULE = "fcitx";
      XMODIFIERS = "@im=fcitx";
      NIXOS_OZONE_WL = "1";
    };
    systemPackages = with pkgs; [
      # terminal utilities
      kitty
      playerctl
      jq
      lf
      ffmpegthumbnailer
      file
      grim
      slurp
      wl-clipboard
      wl-screenrec
      pandoc
      texliveSmall
      
      # hyprland utilities
      hyprpaper
      hyprlock
      
      # browsers
      google-chrome
      brave

      # editors
      vim
      vscode

      # misc GUI applications
      mpv-unwrapped
      qbittorrent
      zoom-us
      discord
    ];
  };

  programs = {
    hyprland.enable = true;
    light.enable = true;
    waybar.enable = true;
    nix-ld.enable = true;
    ssh.startAgent = true;
    bash.shellAliases = {
      blue = "bluetoothctl";
      google-chrome-stable = "google-chrome-stable --enable-features=UseOzonePlatform --ozone-platform=wayland --enable-wayland-ime";
    };
    git = {
      enable = true;
      config = {
        user = {
          name = "DarrenChangJR";
          email = "darrenchangjr01@gmail.com";
          username = "darrenchangjr";
        };
        init.defaultBranch = "main";
        core.editor = "code --wait --new-window";
      };
    };
  };

  system = {
    stateVersion = "23.11";
    copySystemConfiguration = true;
  };
}
