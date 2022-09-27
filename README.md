## Mpplus-Bliss - analyze song similarity and create smart MPD playlists

The `mpplus-bliss` project builds and packages `bliss-rs` and `blissify` for
a variety of Linux platforms. The native installation packages are customized
for integration with [MusicPlayerPlus](https://github.com/doctorfree/MusicPlayerPlus).

The `mpplus-bliss` package gets installed as part of the `MusicPlayerPlus`
initialization process. See the
[MusicPlayerPlus README](https://github.com/doctorfree/MusicPlayerPlus#readme)
for more information.

Many of the [Doctorfree projects](https://github.com/doctorfree) are designed
to integrate with each other including
[Asciiville](https://github.com/doctorfree/Asciiville#readme),
[MirrorCommand](https://github.com/doctorfree/MirrorCommand#readme),
[MusicPlayerPlus](https://github.com/doctorfree/MusicPlayerPlus#readme), and
[RoonCommandLine](https://github.com/doctorfree/RoonCommandLine#readme).

## Table of Contents

1. [Overview](#overview)
1. [Dependencies](#dependencies)
    1. [Installing ffmpeg on RPM based systems](installing-ffmpeg-on-rpm-based-systems)
1. [Requirements](#requirements)
1. [Installation](#installation)
1. [Removal](#removal)
1. [Quick start](#quick-start)
1. [Asking for help](#asking-for-help)
1. [Building bliss from source](#building-bliss-from-source)
1. [Contributing](#contributing)

## Overview

Blissify is a program used to make playlists of songs that sound alike from an
MPD track library, \u00e0 la Spotify radio. Under the hood, it is an MPD plugin
for bliss. Blissify needs first to analyze your music library, i.e. compute and
store a series of features from your songs, extracting the tempo, timbre,
loudness, etc. After that, it is ready to make playlists: play a song to start
from, run blissify playlist 30, and voil\u00e0! You have a playlist of 30 songs
that sound like your first track.

Documentation online: https://crates.io/crates/blissify

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

## Dependencies

* [fftw library](http://www.fftw.org/)
* [tag library](https://taglib.org/)
* [Eigen](http://eigen.tuxfamily.org/)
* [Gaia](https://github.com/MTG/gaia)
* [libavcodec/libavformat/libavutil/libswresample](http://ffmpeg.org/)
* [libsamplerate](http://www.mega-nerd.com/SRC/)
* [LibYAML](http://pyyaml.org/wiki/LibYAML)
* [Chromaprint](https://github.com/acoustid/chromaprint)

### Installing ffmpeg on RPM based systems

**[Note:]** The following installation procedure is only necessary on RPM
based systems like Fedora and CentOS when `mpplus-bliss` is being deployed
as a standalone package. When deployed in conjunction with MusicPlayerPlus
this procedure is automatically performed during initialization with `mppinit`.

Bliss depends on the `ffmpeg` libraries. On RPM based systems like Fedora
and CentOS the RPM Fusion repositories must be enabled and the appropriate
`ffmpeg` package installed. See
[RPM Fusion Configuration](https://rpmfusion.org/Configuration) to enable
RPM Fusion free and nonfree repositories. For example:

```
# On Fedora
sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
sudo dnf config-manager --set-enabled rpmfusion-free
sudo dnf config-manager --set-enabled rpmfusion-nonfree
sudo dnf update

# On CentOS Stream 8
sudo dnf install --nogpgcheck https://dl.fedoraproject.org/pub/epel/epel-release-latest-$(rpm -E %rhel).noarch.rpm
sudo dnf install --nogpgcheck https://mirrors.rpmfusion.org/free/el/rpmfusion-free-release-$(rpm -E %rhel).noarch.rpm https://mirrors.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-$(rpm -E %rhel).noarch.rpm
sudo dnf config-manager --enable powertools
sudo dnf config-manager --set-enabled rpmfusion-free-updates
sudo dnf config-manager --set-enabled rpmfusion-nonfree-updates
sudo dnf update
```

Once enabled, install `ffmpeg`:

```
# On Fedora
sudo dnf --allowerasing install compat-ffmpeg4

# On CentOS
sudo dnf --allowerasing install ffmpeg
```

On Debian and Arch based systems the `ffmpeg` libraries are automatically installed.

All other dependencies are automatically installed if not already present.

## Requirements

Mpplus-Bliss is compiled and packaged for installation on:

- Arch Linux (x86_64)
- CentOS Linux (x86_64)
- Fedora Linux (x86_64)
- Ubuntu Linux (amd64)

## Installation

Mpplus-Bliss v1.0.0 and later can be installed on Linux systems using
the Arch packaging format, the Debian packaging format, or the Red Hat
Package Manager (RPM).

### Supported platforms

Mpplus-Bliss has been tested successfully on the following platforms:

- **Arch Linux 2022.07.01**
    - `mpplus-bliss_<version>-<release>-x86_64.pkg.tar.zst`
- **Ubuntu Linux 20.04**
    - `mpplus-bliss_<version>-<release>.amd64.deb`
- **Fedora Linux 36**
    - `mpplus-bliss_<version>-<release>.x86_64.rpm`
- **CentOS Linux 8**
    - `mpplus-bliss_<version>-<release>.x86_64.rpm`

### Debian package installation

Many Linux distributions, most notably Ubuntu and its derivatives, use the
Debian packaging system.

To tell if a Linux system is Debian based it is usually sufficient to
check for the existence of the file `/etc/debian_version` and/or examine the
contents of the file `/etc/os-release`.

To install on a Debian based Linux system, download the latest Debian format
package from the
[mpplus-bliss Releases](https://github.com/doctorfree/mpplus-bliss/releases).

Install the mpplus-bliss package by executing the command

```console
sudo apt install ./mpplus-bliss_<version>-<release>.amd64.deb
```
or
```console
sudo dpkg -i ./mpplus-bliss_<version>-<release>.amd64.deb
```

**NOTE:** In some cases you may see a warning message when installing the
Debian package. The message:

Repository is broken: mpplus-bliss:amd64 (= <version-<release>) has no Size
information can safely be ignored. This is an issue with the Debian packaging
system and has no effect on the installation.

### RPM Package installation

Red Hat Linux, SUSE Linux, and their derivatives use the RPM packaging
format. RPM based Linux distributions include Fedora, AlmaLinux, CentOS,
openSUSE, OpenMandriva, Mandrake Linux, Red Hat Linux, and Oracle Linux.

To install on an RPM based Linux system, download the latest RPM format
package from the
[mpplus-bliss Releases](https://github.com/doctorfree/mpplus-bliss/releases).

Install the mpplus-bliss package by executing the command

```console
sudo yum localinstall ./mpplus-bliss_<version>-<release>.x86_64.rpm
```
or
```console
sudo rpm -i ./mpplus-bliss_<version>-<release>.x86_64.rpm
```

**[Note]** Bliss depends on the `ffmpeg` libraries. See the
[Dependencies](#dependencies) section above to install `ffmpeg`.

### Arch Package installation

Arch Linux, Manjaro, and other Arch Linux derivatives use the Pacman packaging
format. In addition to Arch Linux, Arch based Linux distributions include
ArchBang, Arch Linux, Artix Linux, ArchLabs, Asahi Linux, BlackArch,
Chakra Linux, EndeavourOS, Frugalware Linux, Garuda Linux,
Hyperbola GNU/Linux-libre, LinHES, Manjaro, Parabola GNU/Linux-libre,
SteamOS, and SystemRescue.

To install on an Arch based Linux system, download the latest Pacman format
package from the
[mpplus-bliss Releases](https://github.com/doctorfree/mpplus-bliss/releases).

Install the mpplus-bliss package by executing the command

```console
sudo pacman -U ./mpplus-bliss_<version>-<release>-x86_64.pkg.tar.zst
```

## Removal

On Debian based Linux systems where the mpplus-bliss package was installed
using the mpplus-bliss Debian format package, remove the mpplus-bliss
package by executing the command:

```console
    sudo apt remove mpplus-bliss
```
or
```console
    sudo dpkg -r mpplus-bliss
```

On RPM based Linux systems where the mpplus-bliss package was installed
using the mpplus-bliss RPM format package, remove the mpplus-bliss
package by executing the command:

```console
    sudo yum remove mpplus-bliss
```
or
```console
    sudo rpm -e mpplus-bliss
```

On Arch based Linux systems where the mpplus-bliss package was installed
using the mpplus-bliss Pacman format package, remove the mpplus-bliss
package by executing the command:

```console
    sudo pacman -Rs mpplus-bliss
```

The mpplus-bliss package can be removed by executing the "Uninstall"
script in the mpplus-bliss source directory:

```console
    git clone https://github.com/doctorfree/mpplus-bliss.git
    cd mpplus-bliss
    ./Uninstall
```

## Building bliss from source

Bliss can be compiled, packaged, and installed from the source code
repository. This should be done as a normal user with `sudo` privileges:

```
# Retrieve the source code from the repository
git clone https://github.com/doctorfree/mpplus-bliss.git
# Enter the mpplus-bliss source directory
cd mpplus-bliss
# Install the necessary build environment (not necessary on Arch Linux)
scripts/install-dev-env.sh
# Compile the mpplus-bliss components and create an installation package
./mkpkg
# Install mpplus-bliss and its dependencies
./Install
```

These steps are detailed below.

### Clone mpplus-bliss repository

```
git clone https://github.com/doctorfree/mpplus-bliss.git
cd mpplus-bliss
```

**[Note:]** The `mkpkg` script in the top level of the mpplus-bliss
repository can be used to build an installation package on all supported
platforms. After cloning, `cd mpplus-bliss` and `./mkpkg`. The resulting
installation package(s) will be found in `./releases/<version>/`.

### Install build dependencies

mpplus-bliss components have build dependencies on the following:

* libtool
* automake
* build-blissls
* [fftw library](http://www.fftw.org/)
* [tag library](https://taglib.org/)
* [Eigen](http://eigen.tuxfamily.org/)
* [Gaia](https://github.com/MTG/gaia)
* [libavcodec/libavformat/libavutil/libswresample](http://ffmpeg.org/)
* [libsamplerate](http://www.mega-nerd.com/SRC/)
* [LibYAML](http://pyyaml.org/wiki/LibYAML)
* [Chromaprint](https://github.com/acoustid/chromaprint)

Install build dependencies via:

```
scripts/install-dev-env.sh
```

**[Note:]** The mpplus-bliss `PKGBUILD` on Arch Linux defines build
dependencies and these will be automatically installed when performing
a `makepkg` build. It is not necessary to pre-install these packages.

### Install packaging dependencies

mpplus-bliss components have packaging dependencies on the following:

On Debian based systems like Ubuntu Linux, install packaging dependencies via:

```
sudo apt install dpkg
```

On RPM based systems like Fedora Linux, install packaging dependencies via:

```
sudo dnf install rpm-build rpm-devel rpmlint rpmdevtools
```

### Build and package mpplus-bliss

To build and package mpplus-bliss, execute the command:

```
./mkpkg
```

On Debian based systems like Ubuntu Linux, the `mkpkg` scripts executes
`scripts/mkdeb.sh`.

On RPM based systems like Fedora Linux, the `mkpkg` scripts executes
`scripts/mkrpm.sh`.

On PKGBUILD based systems like Arch Linux, the `mkpkg` scripts executes
`scripts/mkaur.sh`.

### Install mpplus-bliss from source build

After successfully building and packaging mpplus-bliss with either
`./mkpkg`, install the mpplus-bliss package with the command:

```
./Install
```

## Contributing

There are a variety of ways to contribute to the mpplus-bliss project.
All forms of contribution are appreciated and valuable. Also, it's fun to
collaborate. Here are a few ways to contribute to the further improvement
and evolution of mpplus-bliss:

### Testing and Issue Reporting

mpplus-bliss is fairly complex with many components, features, options,
configurations, and use cases. Although currently only supported on
Linux platforms, there are a plethora of Linux platforms on which
mpplus-bliss can be deployed. Testing all of the above is time consuming
and tedious. If you have a Linux platform on which you can install
mpplus-bliss and you have the time and will to put it through its paces,
then issue reports on problems you encounter would greatly help improve the
robustness and quality of mpplus-bliss. Open issue reports at
[https://github.com/doctorfree/mpplus-bliss/issues](https://github.com/doctorfree/mpplus-bliss/issues)

### Sponsor mpplus-bliss

mpplus-bliss is completely free and open source software. All of the
mpplus-bliss components are freely licensed and may be copied, modified,
and redistributed freely. Nobody gets paid, nobody is making any money,
it's a project fully motivated by curiousity and love of music. However,
it does take some money to procure development and testing resources.
Right now mpplus-bliss needs a multi-boot test platform to extend support
to a wider variety of Linux platforms and potentially Mac OS X.

If you have the means and you would like to sponsor mpplus-bliss development,
testing, platform support, and continued improvement then your monetary
support could play a very critical role. A little bit goes a long way
in mpplus-bliss. For example, a bootable USB SSD device could serve as a 
means of porting and testing support for additional platforms. Or, a
decent cup of coffee could be the difference between a bug filled
release and a glorious musical adventure.

Sponsor the mpplus-bliss project at
[https://github.com/sponsors/doctorfree](https://github.com/sponsors/doctorfree)

### Contribute to Development

If you have programming skills and find the management and ease-of-use of
digital music libraries to be an interesting area, you can contribute to
mpplus-bliss development through the standard Github "fork, clone,
pull request" process. There are many guides to contributing to Github hosted
open source projects on the Internet. A good one is available at
[https://www.dataschool.io/how-to-contribute-on-github/](https://www.dataschool.io/how-to-contribute-on-github/). Another short succinct guide is at
[https://gist.github.com/MarcDiethelm/7303312](https://gist.github.com/MarcDiethelm/7303312).

Once you have forked and cloned the mpplus-bliss repository, it's time to
setup a development environment. Although many of the mpplus-bliss commands
are Bash shell scripts, there are also applicatons written in C and C++ along
with documentation in Markdown format, configuration files in a variety of
formats, examples, screenshots, video demos, build scripts, packaging, and more.

To compile `mpplus-bliss` from source, run the commands:

```
./build bliss-analyze
./build blissify
```

On Debian (e.g. Ubuntu), PKGBUILD (e.g. Arch) and RPM (e.g. Fedora) based
systems the mpplus-bliss installation package can be created with the
`mkpkg` scripts. The `mkpkg` script determines which platform it is on
and executes the appropriate build and packaging script in the `scripts/`
directory. These scripts invoke the build scripts for each of the projects
included with mpplus-bliss, populate a distribution tree, and call the
respective packaging utilities. Packages are saved in the
`./releases/<version>/` folder. Once a package has been created
it can be installed with the `Install` script.

It's not necessary to have C/C++ expertise to contribute to mpplus-bliss
development. Many of the mpplus-bliss commands are Bash scripts and require
no compilaton. Script commands reside in the `bin` and `share/scripts`
directories. To modify a shell script, install mpplus-bliss and edit the
`bin/<script>` or `share/scripts/<script.sh>` you wish to improve.
After making your changes simply copy the revised script to `/usr/bin`
or `/usr/share/mpplus-bliss/scripts` and test your changes.

Feel free to email me at github@ronrecord.com with questions or comments.

