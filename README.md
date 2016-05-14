# puppet-plex

## Overview

Installs the [Plex Media Server](https://plex.tv) for Linux.

## Configuration

Currently this module is limited to installed a specific version of the server:

    class { '::plex':
      app_version => '0.9.16.6.1993-5089475', # pin specific version
    }

If left unset, `app_version` will be updated semi-frequently to the latest
version offered by Plex. If this isn't something you'd like, please pin
the version either using the syntax above, or by using Hiera.

A firewall is configured automatically using the `puppetlabs/firewall` module,
you can disable this by setting `manage_firewall_v4` and `manage_firewall_v6`
to `true` or `false`.


## Requirements

One of the supported GNU/Linux distributions:
* Ubuntu
* Debian

PRs welcome for CentOS, Fedora, MacOS or FreeBSD.


## Limitations

Plex don't make the software available as a proper APT repo, so we can't
(easily) do things like check for the latest version - so we currently pin to
specific versions.

The downloads of their package come direct from their website, if they change
their download methodology or packaging approach, this could break in future.



## Contributions

All contributions are welcome via Pull Requests including documentation fixes
or compatibility fixes for supporting other distributions (or other operating
systems).


## License

This module is licensed under the Apache License, Version 2.0 (the "License").
See the `LICENSE` or http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
