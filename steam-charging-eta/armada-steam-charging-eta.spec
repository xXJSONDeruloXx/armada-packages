%global debug_package %{nil}
%global source_date_epoch_from_changelog 0

Name:           armada-steam-charging-eta
Version:        1
Release:        1%{?dist}.armada
Summary:        Publish UPower battery estimates to Steam vpower
License:        GPL-3.0-or-later
URL:            https://github.com/armada-os/armada-packages
Source0:        armada-steam-charging-eta
Source1:        armada-steam-charging-eta.service

BuildArch:      noarch
BuildRequires:  systemd-rpm-macros

Requires:       python3
Requires:       systemd

%description
Publishes UPower battery estimates through Steam's vpower file interface.

%prep

%build

%install
install -Dpm 0755 %{SOURCE0} %{buildroot}%{_libexecdir}/armada/%{name}
install -Dpm 0644 %{SOURCE1} %{buildroot}%{_userunitdir}/%{name}.service
install -d %{buildroot}%{_userunitdir}/default.target.wants
ln -s ../%{name}.service %{buildroot}%{_userunitdir}/default.target.wants/%{name}.service

%files
%{_libexecdir}/armada/%{name}
%{_userunitdir}/%{name}.service
%{_userunitdir}/default.target.wants/%{name}.service
