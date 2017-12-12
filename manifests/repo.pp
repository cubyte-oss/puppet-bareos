
class bareos::repo (
    $version = 'latest',
    $pin     = undef,
) {

    include bareos::global
            
    if $version == 'nightly' {
        $repo_path = 'experimental/nightly'
    } else {
        $repo_path = "release/${version}"
    }
    
    $bareos_repo_host = 'download.bareos.org'
    $bareos_repo_base = "http://${bareos_repo_host}/bareos"

    if $bareos::global::repo_manage {
    
        case $::osfamily {
            'Debian': {
            
                $os       = $facts['os']['distro']['id']
                $os_major = $facts['os']['distro']['release']['major']
                $location = "${bareos_repo_base}/${repo_path}/${os}_${os_major}.0"

                apt::source {$bareos::global::repo_name:
                    location => $location,
                    release  => '',
                    repos    => '/',
                    key      => '0143857D9CE8C2D182FE2631F93C028C093BFBA2',
                    pin      =>  $pin,
                    include  => {
                        deb  => true,
                        src  => false,
                    },
                }
                
                $require = Apt::Source[$bareos::global::repo_name]
            }
        }
        
    }

}
