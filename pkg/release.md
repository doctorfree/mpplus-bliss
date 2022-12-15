[Blissify](https://crates.io/crates/blissify) is an open source program used to
make playlists of songs that sound alike from an MPD track library, \u00e0 la
Spotify radio. Under the hood, it is an MPD plugin for bliss. Blissify needs
first to analyze your music library, i.e. compute and store a series of features
from your songs, extracting the tempo, timbre, loudness, etc. After that, it is
ready to make playlists: play a song to start from, run blissify playlist 30,
and voil\u00e0! You have a playlist of 30 songs that sound like your first track.

The `mpplus-bliss` project integrates `blissify` and `bliss-analyze` with the
[MusicPlayerPlus](https://github.com/doctorfree/MusicPlayerPlus) project as well
as providing these utilities in native installation packaged format for a
variety of Linux platforms.

## Installation

Download the [latest Debian, Arch, or RPM package format release](https://github.com/doctorfree/mpplus-bliss/releases) for your platform.

Install the package on Debian based systems by executing the command:

```bash
sudo apt install ./mpplus-bliss_1.0.1-1.amd64.deb
```

Install the package on Arch Linux based systems by executing the command:

```bash
sudo pacman -U ./mpplus-bliss_1.0.1-1-x86_64.pkg.tar.zst
```

Install the package on RPM based systems by executing one of the following commands.

On Fedora Linux:

```bash
sudo yum localinstall ./mpplus-bliss_1.0.1-1.fc36.x86_64.rpm
```

On CentOS Linux:

```bash
sudo yum localinstall ./mpplus-bliss_1.0.1-1.el8.x86_64.rpm
```

### PKGBUILD Installation

Mpplus-bliss can be built from sources using the Arch PKGBUILD files provided in `mpplus-bliss-pkgbuild-1.0.1-1.tar.gz`. This process can be performed on any `x86_64` architecture system running Arch Linux. An `x86_64` architecture precompiled package is supplied (see above). To rebuild this package from sources, extract `mpplus-bliss-pkgbuild-1.0.1-1.tar.gz` and use the `makepkg` command to download the sources, build the binaries, and create the installation package:

```
tar xzf mpplus-bliss-pkgbuild-1.0.1-1.tar.gz
cd mpplus-bliss
makepkg --force --log --cleanbuild --noconfirm --syncdeps
```

## Removal

Removal of the package on Debian based systems can be accomplished by issuing the command:

```bash
sudo apt remove mpplus-bliss
```

Removal of the package on RPM based systems can be accomplished by issuing the command:

```bash
sudo yum remove mpplus-bliss
```

Removal of the package on Arch Linux based systems can be accomplished by issuing the command:

```bash
sudo pacman -Rs mpplus-bliss
```

## Building mpplus-bliss from source

mpplus-bliss can be compiled, packaged, and installed from the source code repository. This should be done as a normal user with `sudo` privileges:

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

The `mkpkg` script detects the platform and creates an installable package in the package format native to that platform. After successfully building the mpplus-bliss components, the resulting installable package will be found in the `./releases/<version>/` directory.

## Changelog

Changes in version 1.0.1 release 1 include:

* Updated Blissify to latest version from upstream

Changes in version 1.0.0 release 1 include:

* Arch Linux build and packaging support
* CentOS Linux build and packaging support
* Fedora Linux build and packaging support
* Ubuntu Linux build and packaging support
* Integration with MusicPlayerPlus 

See [CHANGELOG.md](https://github.com/doctorfree/mpplus-bliss/blob/master/CHANGELOG.md) for a full list of changes in every mpplus-bliss release
