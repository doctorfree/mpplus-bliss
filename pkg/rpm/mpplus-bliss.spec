Name: mpplus-bliss
Version:    %{_version}
Release:    %{_release}%{?dist}
BuildArch:  x86_64
AutoReqProv: no
Requires: sqlite
URL:        https://github.com/doctorfree/mpplus-bliss
Vendor:     Doctorwhen's Bodacious Laboratory
Packager:   ronaldrecord@gmail.com
License     : GPLv3
Summary     : Analyze MPD library and make playlists of songs that sound alike

%global __os_install_post %{nil}

%description
Blissify is a program used to make playlists of songs that sound alike from an
MPD track library, \u00e0 la Spotify radio. Under the hood, it is an MPD plugin
for bliss. Blissify needs first to analyze your music library, i.e. compute and
store a series of features from your songs, extracting the tempo, timbre,
loudness, etc. After that, it is ready to make playlists: play a song to start
from, run blissify playlist 30, and voil\u00e0! You have a playlist of 30 songs
that sound like your first track.

%prep

%build

%install
cp -a %{_sourcedir}/usr %{buildroot}/usr

%pre

%post

%preun

%files
/usr
%exclude %dir /usr/share/man/man1
%exclude %dir /usr/share/man
%exclude %dir /usr/share/doc
%exclude %dir /usr/share
%exclude %dir /usr/bin

%changelog
