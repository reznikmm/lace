# SPDX-FileCopyrightText: 2021 Max Reznik <reznikmm@gmail.com>
#
# SPDX-License-Identifier: MIT
#

%undefine _hardened_build
%define _gprdir %_GNAT_project_dir
%define rtl_version 0.1

Name:       lace
Version:    0.1.0
Release:    git%{?dist}
Summary:    Ada translator
Group:      Development/Libraries
License:    MIT
URL:        https://github.com/reznikmm/lace
### Direct download is not availeble
Source0:    lace.tar.gz
BuildRequires:   gcc-gnat
BuildRequires:   fedora-gnat-project-common >= 3
BuildRequires:   matreshka-devel
BuildRequires:   gprbuild

# gprbuild only available on these:
ExclusiveArch: %GPRbuild_arches

%description
Ada to LLVM translator as a library

%package devel

Group:      Development/Libraries
License:    MIT
Summary:    Devel package for the lace
Requires:       %{name}%{?_isa} = %{version}-%{release}
Requires:   fedora-gnat-project-common  >= 2

%description devel
Devel package for lace

%package run
Summary:    Run executable for lace
License:    MIT
Group:      System Environment/Libraries
Requires:       %{name}%{?_isa} = %{version}-%{release}

%description run
Ada translator

%prep 
%setup -q -n %{name}

%build
make  %{?_smp_mflags} GPRBUILD_FLAGS="%Gnatmake_optflags"

%install
rm -rf %{buildroot}
make install DESTDIR=%{buildroot} LIBDIR=%{_libdir} PREFIX=%{_prefix} GPRDIR=%{_gprdir} BINDIR=%{_bindir}

%check
make  %{?_smp_mflags} GPRBUILD_FLAGS="%Gnatmake_optflags" check

%post     -p /sbin/ldconfig
%postun   -p /sbin/ldconfig

%files
%doc LICENSES/*
%dir %{_libdir}/%{name}
%{_libdir}/%{name}/liblace.so.%{rtl_version}
%{_libdir}/liblace.so.%{rtl_version}
%{_libdir}/%{name}/liblace.so.0
%{_libdir}/liblace.so.0
%files devel
%doc README.md
%{_libdir}/%{name}/liblace.so
%{_libdir}/liblace.so
%{_libdir}/%{name}/*.ali
%{_includedir}/%{name}
%{_gprdir}/lace.gpr
%{_gprdir}/manifests/lace

%files run
%{_bindir}/lace-run
%{_gprdir}/manifests/lace_run

%changelog
* Sun Feb 28 2021 Maxim Reznik <reznikmm@gmail.com> - 0.1.0-git
- Initial package
