#
# $Id: ec4fe4d77fdbd8fbcfd9483bf8219f4e7053aa0a $
#
# Author: Rich O'Hare  <ohare2@llnl.gov>
#
# System security certification scripts
#
%define Name diskscan
%define Version 1.0

Name: %{Name}
Version: %{Version}
Release: 3%{?dist}
Source: diskscan-1.0-3.tgz
License: GPLv2
Group: Applications/System
URL: https://corbin.llnl.gov/
BuildArch: noarch
Vendor: Rich O'Hare
Packager: Rich O'Hare <ohare2@llnl.gov>
Provides: diskscan.sh
Requires: lshw
Summary: Tool for maintaining disk drive inventory
%define _unpackaged_files_terminate_build 0

%description
Diskscan is a tool for detecting and tracking disk drives.

%prep
%setup -q -n %{Name}

%build
exit 0

%install
#rm -rf %RPM_BUILD_ROOT/*
make install
exit 0

%clean
#rm -fR %RPM_BUILD_ROOT/*
exit 0

%files
%defattr(644, root, root, 755)
%attr(740, root, root) /usr/local/sbin/diskscan.sh
%config(noreplace) %attr(744, root, root) /etc/cron.daily/diskscan.cron
/usr/share/doc/%{Name}-%{Version}/readme
/usr/share/doc/%{Name}-%{Version}/changelog
