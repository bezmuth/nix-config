<div>
  <img src=".github/logo.png" height="100" align="left" style="padding-right:15px;"/>
  <div>
    <h3>nix-config</h3>
      <img src="https://img.shields.io/github/stars/bezmuth/nix-config?color=FFEC27&labelColor=161616&style=for-the-badge">
          <img src="https://img.shields.io/github/license/bezmuth/nix-config?color=00E436&labelColor=161616&style=for-the-badge">
      <br/>
      <img src="https://img.shields.io/github/repo-size/bezmuth/nix-config?color=FFA300&labelColor=161616&style=for-the-badge">
    <img src="https://img.shields.io/badge/created_in-my_basement-black?color=29ADFF&labelColor=161616&style=for-the-badge"">
  </div>
</div>

<p></p>

## Overview  
This is my NixOS config for both of my PCs and my home server. It uses flakes and is highly dependent on [flake-utils-plus](https://github.com/gytis-ivaskevicius/flake-utils-plus), [home-manager](https://github.com/nix-community/home-manager), and [devshell](https://github.com/numtide/devshell).

### Dirs  
- [hosts](/hosts) - Stores all machine-specific information.  
- [modules](/modules) - Services, programs, Flatpak, and container configuration.  
- [home](/home) - All the Home Manager configs.  
- [pkgs](/pkgs) - Custom/patched packages pulled in as an overlay.  
- [emacs](/home/emacs/) - Emacs config and scripts for setting up Doom Emacs.  

### Hosts  
- **Roshar** - Desktop with an Nvidia GPU.  
- **Mishim** - Laptop with AMD integrated graphics.  
- **Salas** - Home server with some containers and native services.  

### Devshell  
This essentially acts as a custom interface for this project and a method for easy machine bootstrapping. Both commands run extra formatting and linting after each rebuild. More info can be found in [devshell.toml](/devshell.toml).

## Installation Guide  
I recommend you create your own config, as this one is tailored to my needs and may include non-standard configurations. You'll gain a deeper understanding of both Nix and Linux if you build your own config. It's also fun, so that's a plus!

First, you'll need to create a new host config. You can either copy one from this repo or use your own. `default.nix` is for any config unique to the current host (e.g., thermald for a laptop). Ensure that you use your own `hardware-config.nix`, and that `hardware-config.nix` is imported in `default.nix`.

Once you've done that, add your new host to the `flake.nix` and run:
```bash
nix develop
rebuild
