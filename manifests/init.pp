# Install the Plex server.
class plex (
  $app_version        = '1.0.3.2461-35f0caa',
  $manage_firewall_v4 = true,
  $manage_firewall_v6 = true,
  ) {

  Exec {
    path => ['/sbin', '/bin', '/usr/sbin', '/usr/bin'],
  }
  

  # Download & Install (Ubuntu/Debian)
  if ($::operatingsystem == 'Ubuntu' or $::operatingsystem == 'Debian') {

    # Select the appropiate download URL for this distribution and architecture
    # Note that Debian technically isn't supported, so we just use the Ubuntu package
    $download_url = "https://downloads.plex.tv/plex-media-server/${app_version}/plexmediaserver_${app_version}_${::architecture}.deb"

    # Download and install the software.
    exec { 'plex_download':
      creates   => "/tmp/plexmediaserver-${app_version}.deb",
      command   => "wget -nv ${download_url} -O /tmp/plexmediaserver-${app_version}.deb",
      unless    => "dpkg -s plexmediaserver | grep -q \"Version: ${app_version}\"", # Download new version if not already installed.
      logoutput => true,
      notify    => Exec['plex_install'],
    }

    exec { 'plex_install':
      # Ideally we'd use "apt-get install package.deb" but this only become
      # available in apt 1.1 and later. Hence we do a bit of a hack, which is
      # to install the deb and then fix the deps with apt-get -y -f install.
      # TODO: When Ubuntu 16.04 is out, check if we can migrate to the better approach
      command     => "bash -c 'dpkg -i /tmp/plexmediaserver-${app_version}.deb; apt-get -y -f install'",
      require     => Exec['plex_download'],
      logoutput   => true,
      refreshonly => true,
    }
  }


  # Download & Install (Fedora/CentOS)
  if ($::operatingsystem == 'Fedora' or $::operatingsystem == 'CentOS') {
    $download_url = "https://downloads.plex.tv/plex-media-server/${app_version}/plexmediaserver-${app_version}.${::architecture}.rpm"

    # TODO: Implement
    fail('Fedora/CentOS support not yet implemented')
  }

  if ($download_url == "") {
    # If we didn't get set, we aren't supported.
    fail('plex does not support this platform')
  }


  # Ensure the daemon is running and configured to launch at boot
  service { 'plexmediaserver':
    ensure    => 'running',
    enable    => true,
    require   => Exec['plex_install'],
  }

  
  if ($manage_firewall_v4) {
    firewall { '100 V4 Permit Plex Web UI':
      provider => 'iptables',
      proto    => 'tcp',
      dport    => '32400',
      action   => 'accept',
    }

    firewall { '100 V4 Permit Plex DLNA Server TCP':
      provider => 'iptables',
      proto    => 'tcp',
      dport    => '32469',
      action   => 'accept',
    }

    firewall { '100 V4 Permit Plex DLNA Server UDP':
      provider => 'iptables',
      proto    => 'udp',
      dport    => '1900',
      action   => 'accept',
    }

    firewall { '100 V4 Permit Plex Home Theatre via Companion':
      provider => 'iptables',
      proto    => 'tcp',
      dport    => '3005',
      action   => 'accept',
    }

    firewall { '100 V4 Permit Plex Bonjour Avahi discovery':
      provider => 'iptables',
      proto    => 'udp',
      dport    => '5353',
      action   => 'accept',
    }

    firewall { '100 V4 Permit Plex via Roku Companion':
      provider => 'iptables',
      proto    => 'tcp',
      dport    => '8324',
      action   => 'accept',
    }

    firewall { '100 V4 Permit Plex for GDM network discovery':
      provider => 'iptables',
      proto    => 'udp',
      dport    => '32410-32414',
      action   => 'accept',
    }
  }

  if ($manage_firewall_v6) {
    firewall { '100 V6 Permit Plex Web UI':
      provider => 'ip6tables',
      proto    => 'tcp',
      dport    => '32400',
      action   => 'accept',
    }

    firewall { '100 V6 Permit Plex DLNA Server TCP':
      provider => 'ip6tables',
      proto    => 'tcp',
      dport    => '32469',
      action   => 'accept',
    }

    firewall { '100 V6 Permit Plex DLNA Server UDP':
      provider => 'ip6tables',
      proto    => 'udp',
      dport    => '1900',
      action   => 'accept',
    }

    firewall { '100 V6 Permit Plex Home Theatre via Companion':
      provider => 'ip6tables',
      proto    => 'tcp',
      dport    => '3005',
      action   => 'accept',
    }

    firewall { '100 V6 Permit Plex Bonjour Avahi discovery':
      provider => 'ip6tables',
      proto    => 'udp',
      dport    => '5353',
      action   => 'accept',
    }

    firewall { '100 V6 Permit Plex via Roku Companion':
      provider => 'ip6tables',
      proto    => 'tcp',
      dport    => '8324',
      action   => 'accept',
    }

    firewall { '100 V6 Permit Plex for GDM network discovery':
      provider => 'ip6tables',
      proto    => 'udp',
      dport    => '32410-32414',
      action   => 'accept',
    }
  }
}
# vi:smartindent:tabstop=2:shiftwidth=2:expandtab:
