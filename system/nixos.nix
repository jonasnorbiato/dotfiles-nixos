{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [./hardware.nix];

  boot.kernelPackages = pkgs.linuxPackages_5_10;
  boot.loader = {
    efi = {
      efiSysMountPoint = "/boot";
    };

    grub = {
      enable = true;
      version = 2;
      device = "nodev";
      useOSProber = true;
      efiSupport = true;
      efiInstallAsRemovable = true;
    };
  };

  fonts = {
    fontconfig = {
      enable = true;
    };

    fonts = with pkgs; [
      hack-font
      material-icons

      (nerdfonts.override {fonts = ["NerdFontsSymbolsOnly" "Hack" "JetBrainsMono"];})
    ];
  };

  hardware = {
    opengl.enable = true;

    nvidia.prime = {
      sync.enable = true;

      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
    nvidia.modesetting.enable = true;
  };

  networking = {
    firewall.enable = false;

    hostName = "ainz-ooal-gown";
    networkmanager.enable = true;
  };

  specialisation = {
    external-display.configuration = {
      system.nixos.tags = ["external-display"];
      hardware.nvidia.prime.offload.enable = lib.mkForce false;
      hardware.nvidia.powerManagement.enable = lib.mkForce false;
    };
  };

  sound.enable = true;

  time.timeZone = "America/Sao_Paulo";

  users = {
    users.kesse = {
      extraGroups = ["audio" "docker" "wheel" "networkmanager"];

      home = "/home/kesse";
      isNormalUser = true;
      shell = pkgs.fish;
    };
  };

  services = {
    xserver = {
      enable = true;
      layout = "br";

      dpi = 96;
      libinput.enable = true;

      videoDrivers = ["nvidia"];

      windowManager = {
        awesome = {
          enable = true;
        };
      };

      displayManager = {
        lightdm.enable = true;
        # defaultSession = "AwesomeXsession";
        # session = [
        #   {
        #     manage = "desktop";
        #     name = "AwesomeXsession";
        #     start = "$HOME/.Xsession";
        #   }
        # ];
      };
    };

    openssh.enable = true;

    dbus.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    autorandr = {
      enable = true;
    };
  };

  system.stateVersion = "22.11"; # Did you read the comment?

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs.nm-applet.enable = true;
  programs.dconf.enable = true;

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    curl
  ];
}
