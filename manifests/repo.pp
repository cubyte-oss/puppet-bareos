
class bareos::repo (
    $version        = 'latest',
    $pin            = undef,
    $distro         = $facts['os']['name'],
    $distro_version = $facts['os']['distro']['release']['major'],
) {

    include bareos::global
    
    $bareos_repo_host = 'download.bareos.org'
    $bareos_repo_base = "http://${bareos_repo_host}/bareos"

    case $distro {
        'Debian': {
            if versioncmp($distro_version, '8') < 0 {
                fail("Unsupported Debian version: ${distro}")
            } elsif versioncmp($distro_version, '10') < 0 {
                $ver = "${distro_version}.0"
            } else {
                $ver = $distro_version
            }

            if $version == 'nightly' {
                $repo_path = 'experimental/nightly'
                $repo_key  = '82834CF002D89BA55C1ED0AA42DA24A6DFEF9127'
                $unsigned  = false
            } else {
                $repo_path = "release/${version}"
                case $version {
                    /(latest|18.2)/: {
                        $repo_key = 'A0CFE15F71F798574AB363DD118283D9A7862CEE'
                        $unsigned = false
                    }
                    '17.2': {
                        $repo_key = '0143857D9CE8C2D182FE2631F93C028C093BFBA2'
                        $unsigned = true
                    }
                    default: {
                        fail("unsupported bareos version ${version}")
                    }
                }
            }

            $location = "${bareos_repo_base}/${repo_path}/${distro}_${ver}"
            $key_location = "${location}/Release.key"

            if $bareos::global::repo_manage {
                apt::source {$bareos::global::repo_name:
                    location       => $location,
                    release        => '',
                    repos          => '/',
                    key            => {
                        id     => $repo_key,
                        source => $key_location,
                    },
                    pin            => $pin,
                    include        => {
                        deb => true,
                        src => false,
                    },
                    allow_unsigned => $unsigned,
                }

                $require = Apt::Source[$bareos::global::repo_name]
            } else {
                $require = undef
            }
        }
        default: {
            fail("Unsupported OS: ${distro}")
        }
    }
}
