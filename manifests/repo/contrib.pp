
class bareos::repo::contrib {

    include bareos::global

    if $bareos::global::repo_manage {

        case $::osfamily {
            'Debian': {

                $location     = "${bareos_repo_base}/${repo_path}/${::operatingsystem}_${::operatingsystemmajrelease}.0"

                apt::source {$bareos::global::contrib_repo_name:
                    location => $location,
                    release  => '',
                    repos    => '/',
                    key      => '0143857D9CE8C2D182FE2631F93C028C093BFBA2',
                    include  => {
                        deb  => true,
                        src  => false,
                    },
                }
                
                $require = Apt::Source[$bareos::global::contrib_repo_name]
            }
        }
        
    }

}
