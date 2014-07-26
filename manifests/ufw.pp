# Control the "Uncomplicated Firewall" service
class lxc_desktop::ufw(
  $enable     = true,
  $allow_in   = [],
  $allow_out  = ['domain/udp', '8140/tcp'],
  $reject_out = false)
{
  validate_bool($enable)
  validate_array($allow_in)
  validate_bool($reject_out)

  package { 'ufw':
    ensure => present,
  }

  file { '/etc/rc.ufw':
    ensure  => $enable ? { true => present, false => absent },
    content => template('lxc_desktop/ufw/rc.ufw.erb'),
    mode    => '0755',
    owner   => 'root',
    group   => 'root',
    require => Package['ufw'],
    notify  => Service['ufw-enable'],
  }

  file { '/etc/init/ufw-enable.conf':
    ensure  => file,
    source  => 'puppet:///modules/lxc_desktop/ufw/init.conf',
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    require => Package['ufw'],
    before  => Service['ufw-enable'],
  }

  # The Puppet agent might lose the connection to the Puppet master
  # if $reject_out = true.
  service { 'ufw-enable':
    enable  => $enable,
    ensure  => $enable ? { true => running, false => stopped },
    require => Package['ufw'],
  }
}
