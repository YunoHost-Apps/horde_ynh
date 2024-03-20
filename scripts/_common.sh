#!/bin/bash

#=================================================
# COMMON VARIABLES
#=================================================
# PHP APP SPECIFIC
#=================================================

#=================================================
# PERSONAL HELPERS
#=================================================

patch_app() {
    local old_dir=$(pwd)
    (cd "$install_dir/horde" && patch -p1 < $YNH_CWD/../sources/sso_auth.patch) || echo "Unable to apply patches"
    cd $old_dir
}

config_horde() {
    ynh_add_config --template="horde_conf.php" --destination="$install_dir/horde/config/conf.php"
    ynh_add_config --template="/horde_imp_conf.php" --destination="$install_dir/horde/imp/config/conf.php"
    ynh_add_config --template="horde_registry.php" --destination="$install_dir/horde/config/registry.local.php"
    ynh_add_config --template="gollem_backends.php" --destination="$install_dir/horde/gollem/config/backends.local.php"
    ynh_add_config --template="ingo_backends.php" --destination="$install_dir/horde/ingo/config/backends.local.php"
}

config_nginx() {
    ynh_add_nginx_config
    [[ $service_autodiscovery ]] && add_nginx_autodiscovery
    ynh_store_file_checksum --file "/etc/nginx/conf.d/$domain.d/$app.conf"
}

add_nginx_autodiscovery() {
    nginx_domain_path=/etc/nginx/conf.d/$domain.d/*
    nginx_config_path="/etc/nginx/conf.d/$domain.d/$app.conf"
    grep "/Microsoft-Server-ActiveSync" $nginx_domain_path || echo "location /Microsoft-Server-ActiveSync {
    return 301 https://\$server_name$path/rpc.php;
    }
    " >> "$nginx_config_path"

    grep "/autodiscover/autodiscover.xml" $nginx_domain_path || echo "location /autodiscover/autodiscover.xml {
    return 301 https://\$server_name$path/rpc.php;
    }
    " >> "$nginx_config_path"

    grep "/Autodiscover/Autodiscover.xml" $nginx_domain_path || echo "location /Autodiscover/Autodiscover.xml {
    return 301 https://\$server_name$path/rpc.php;
    }
    " >> "$nginx_config_path"

    grep "/.well-known/caldav" $nginx_domain_path || echo "location /.well-known/caldav {
    return 301 https://\$server_name$path/rpc.php;
    }
    " >> "$nginx_config_path"

    grep "/.well-known/carddav" $nginx_domain_path || echo "location /.well-known/carddav {
    return 301 https://\$server_name$path/rpc.php;
    }
    " >> "$nginx_config_path"
}

set_permission() {
    chown -R www-data:$app $install_dir
    chown -R www-data:$app $data_dir
    chmod u=rwX,g=rwX,o= -R $install_dir
    chmod u=rwX,g=rwX,o= -R $data_dir
}

#=================================================
# EXPERIMENTAL HELPERS
#=================================================

#=================================================
# FUTURE OFFICIAL HELPERS
#=================================================
