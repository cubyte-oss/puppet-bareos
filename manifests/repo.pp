
class bareos::repo (
    $version = 'latest',
    $pin     = undef,
) {

    include bareos::global
            
    if $version == 'nightly' {
        $repo_path = 'experimental/nightly'
        $repo_key  = '82834CF002D89BA55C1ED0AA42DA24A6DFEF9127'
    } else {
        $repo_path = "release/${version}"
        $repo_key  = '0143857D9CE8C2D182FE2631F93C028C093BFBA2'
    }
    
    $bareos_repo_host = 'download.bareos.org'
    $bareos_repo_base = "http://${bareos_repo_host}/bareos"

    if $bareos::global::repo_manage {
    
        case $::osfamily {
            'Debian': {
                $os       = $facts['os']['distro']['id']
                $os_major = $facts['os']['distro']['release']['major']

                if versioncmp($os_major, '10') < 0 {
                    $ver = "${os_major}.0"
                } else {
                    $ver = $os_major
                }

                $location = "${bareos_repo_base}/${repo_path}/${os}_${ver}"
                $key_location = "${location}/Release.key"

                apt::source {$bareos::global::repo_name:
                    location   => $location,
                    release    => '',
                    repos      => '/',
                    key        => {
                        id     => $repo_key,
                        source => $key_location,
                    },
                    pin        =>  $pin,
                    include    => {
                        deb    => true,
                        src    => false,
                    },
                }

                $require = Apt::Source[$bareos::global::repo_name]
            }
        }
        
    } else {
        $require = undef
    }

}
