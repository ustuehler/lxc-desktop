# Control Bluetooth device functionality
class lxc_desktop::bluetooth($enable = true)
{
  validate_bool($enable)

  file { '/etc/udev/rules.d/99-bluetooth.rules':
    ensure => $enable ? { true => absent, false => present },
    source => 'puppet:///modules/lxc_desktop/udev/rules.d/99-bluetooth.rules',
    mode   => '0644',
  }
}
