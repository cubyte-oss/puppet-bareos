
define bareos::director::fileset (
    $options         = {},
    $includes        = [],
    $include_options = {},
    $include_plugins = [],
    $excludes        = [],
    $exclude_options = {},
    $conf_includes   = [],
) {
    include bareos::director
    
    $fileset_name    = $title
    
    concat::fragment {"${bareos::director::filesets_conf}+${fileset_name}":
        target  => $bareos::director::filesets_conf,
        order   => "05_${fileset_name}",
        content => template('bareos/director/fileset.conf.erb'),
    }
}
