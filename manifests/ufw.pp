# Control the "Uncomplicated Firewall" service
class lxc_desktop::ufw(
  $enable     = true,
  $reject_out = false)
{
  validate_bool($enable)
  validate_array($allow_in)
  validate_bool($reject_out)

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
