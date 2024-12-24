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
This is my NixOS config for both of my PCs and my home server, it uses flakes and is highly dependent on [flake-utils-plus](https://github.com/gytis-ivaskevicius/flake-utils-plus), [home-manager](https://github.com/nix-community/home-manager), and [devshell](https://github.com/numtide/devshell)

### Dirs
 - [hosts](/hosts) - this stores all machine specific information
 - [modules](/modules) - services, programs, flatpak, and container configuration
 - [home](/home) - all the home manager configs
 - [pkgs](/pkgs) - custom/patched packages pulled in as an overlay
 - [emacs](/home/emacs/) - Emacs config and scripts for for setting up doom emacs
### Hosts
 - **Roshar** - Desktop with a Nvidia GPU
 - **Mishim** - Laptop with AMD integrated graphics
 - **Salas** - Home server with some containers and native services
### Devshell
This essentially acts as a custom interface for this project, and a method for easy machine bootstrapping. Both commands run some extra formatting and linting after each rebuild. More info can be found in [devshell.toml](/devshell.toml).

## Installation Guide
I recommend you come up with your own config, this is tailored to my own needs and probably has some non-standard configs. You'll gain a deeper understanding of both nix and linux if you build your own config. It's also fun so thats a plus.

First you'll have to make a new host config, you can either copy one from this repo or use your own. `default.nix` is for any config unique to the current host (i.e. thermald for a laptop). Ensure that you use your own `hardware-config.nix` and `hardware-config.nix` is in the default.nix imports.

Once you've done that, add your new host in the `flake.nix` and run:
```bash
nix develop
rebuild
```
