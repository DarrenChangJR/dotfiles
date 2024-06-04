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
    nameservers = [ "1.1.1.1" "1.0.0.1" ];
    hostName = "nixos";
    networkmanager = {
      enable = true;
      dns = "none";
    };
  };

  services = {
    automatic-timezoned.enable = true;
    pipewire = {
      enable = true;
      audio.enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [ fcitx5-rime fcitx5-hangul ];
  };

  fonts = {
    enableDefaultPackages = true;
    fontDir.enable = true;
    packages = with pkgs; [
      noto-fonts
      noto-fonts-extra
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ];
  };

  hardware.bluetooth.enable = true;

  specialisation = { 
    nvidia.configuration = { 
      services.xserver.videoDrivers = [ "nvidia" ];
      hardware.nvidia = {
        modesetting.enable = true;
        nvidiaSettings = true;
        package = config.boot.kernelPackages.nvidiaPackages.stable;
        prime = {
          offload = {
            enable = true;
            enableOffloadCmd = true;
          };
          nvidiaBusId = "PCI:1:0:1";
          amdgpuBusId = "PCI:1:0:0";
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
      kitty
      google-chrome
      vscode
      playerctl
      hyprpaper
      hyprlock
      mpv-unwrapped
      qbittorrent
      zoom-us
      discord
      jq
      lf
      ffmpegthumbnailer
      file
      grim
      slurp
      wl-clipboard
    ];
  };

  programs = {
    hyprland.enable = true;
    light.enable = true;
    waybar.enable = true;
    nix-ld.enable = true;
    steam.enable = true;
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
    firefox = {
      enable = true;
      package = pkgs.firefox-esr;
      languagePacks = [ "en-US" ];
      policies = {
        DisableTelemetry = true;
        DisableFirefoxStudies = true;
        EnableTrackingProtection = {
          Value= true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
          Exceptions = [];
        };
        FirefoxHome = {
          Search = false;
          TopSites = false;
          SponsoredTopSites = false;
          Highlights = false;
          Pocket = false;
          SponsoredPocket = false;
          Snippets = false;
          Locked = false;
        };
        DNSOverHTTPS.Enabled = true;
        DisablePocket = true;
        DisableFirefoxAccounts = true;
        DisableFirefoxScreenshots = true;
        NoDefaultBookmarks = true;
        OverrideFirstRunPage = "";
        OverridePostUpdatePage = "";
        DontCheckDefaultBrowser = true;
        DisplayBookmarksToolbar = "newtab";
        DisplayMenuBar = "never";
        SearchBar = "unified";
        SearchEngines = {
          Add = [
            {
              Name = "Google Dark";
              URLTemplate = "https://www.google.com/search?client=firefox-b-d&hl=en&safe=off&q={searchTerms}";
              IconURL = "https://www.google.com/favicon.ico";
            }
          ];
          Default = "Google Dark";
          PreventInstalls = true;
          Remove = [ "Google" "Bing" "DuckDuckGo" "Wikipedia (en)" ];
        };
        ExtensionSettings = {
          "*".installation_mode = "blocked";
          # Spirited Away Theme
          "{49aa8e5f-f9d6-4556-a881-010b048e8636}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/spirited-away-animated/latest.xpi";
            installation_mode = "force_installed";
            default_area = "menupanel";
          };
          # uBlock Origin:
          "uBlock0@raymondhill.net" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
            installation_mode = "force_installed";
            default_area = "menupanel";
          };
          # Privacy Badger:
          "jid1-MnnxcxisBPnSXQ@jetpack" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/privacy-badger17/latest.xpi";
            installation_mode = "force_installed";
            default_area = "menupanel";
          };
          # Video Speed Controller:
          "{7be2ba16-0f1e-4d93-9ebc-5164397477a9}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/videospeed/latest.xpi";
            installation_mode = "force_installed";
            default_area = "menupanel";
          };
        };
        Preferences = { 
          "browser.contentblocking.category" = { Value = "strict"; Status = "locked"; };
          "extensions.pocket.enabled" = false;
          "extensions.screenshots.disabled" = true;
          "browser.topsites.contile.enabled" = false;
          "browser.formfill.enable" = false;
          "browser.search.suggest.enabled" = false;
          "browser.search.suggest.enabled.private" = false;
          "browser.urlbar.suggest.searches" = false;
          "browser.urlbar.showSearchSuggestionsFirst" = false;
          "browser.newtabpage.activity-stream.default.sites" = "";
          "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
          "browser.newtabpage.activity-stream.feeds.snippets" = false;
          "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
          "browser.newtabpage.activity-stream.section.highlights.includeBookmarks" = false;
          "browser.newtabpage.activity-stream.section.highlights.includeDownloads" = false;
          "browser.newtabpage.activity-stream.section.highlights.includeVisited" = false;
          "browser.newtabpage.activity-stream.showSponsored" = false;
          "browser.newtabpage.activity-stream.system.showSponsored" = false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        };
      };
    };
  };

  system = {
    stateVersion = "23.11";
    copySystemConfiguration = true;
  };
}
