# LXC host
class lxc_desktop::host(
  $purge_unmanaged_hooks = false,
  $kill_bluetooth        = false,
  $ufw_enable            = false,
  $ufw_allow_in          = [],
  $ufw_allow_out         = [],
  $ufw_reject_out        = false)
{
  validate_bool($purge_unmanaged_hooks)
  validate_bool($kill_bluetooth)
  validate_bool($ufw_enable)
  validate_array($ufw_allow_in)
  validate_array($ufw_allow_out)
  validate_bool($ufw_reject_out)

  package { 'lxc':
    ensure => present,
  }

  File {
    owner   => 'root',
    group   => 'root',
    require => Package['lxc'],
  }

  file { '/etc/lxc/desktop.conf':
    ensure  => file,
    source  => 'puppet:///modules/lxc_desktop/desktop.conf',
    mode    => '0644',
  }

  file { '/etc/lxc/hooks':
    ensure  => directory,
    source  => 'puppet:///modules/lxc_desktop/hooks',
    recurse => true,
    purge   => $purge,
    mode    => '0755',
  }

  class { '::lxc_desktop::bluetooth':
    enable => !$kill_bluetooth,
  }

  class { '::lxc_desktop::ufw':
    enable     => $ufw_enable,
    allow_in   => $ufw_allow_in,
    allow_out  => $ufw_allow_out,
    reject_out => $ufw_reject_out,
  }
}
