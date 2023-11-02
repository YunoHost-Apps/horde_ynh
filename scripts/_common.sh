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
    ynh_backup_if_checksum_is_different --file "$install_dir/horde/config/conf.php"
    ynh_backup_if_checksum_is_different --file "$install_dir/horde/imp/config/conf.php"
    ynh_backup_if_checksum_is_different --file "$install_dir/horde/config/registry.local.php"
    ynh_backup_if_checksum_is_different --file "$install_dir/horde/gollem/config/backends.local.php"
    ynh_backup_if_checksum_is_different --file "$install_dir/horde/ingo/config/backends.local.php"

    #cp ../conf/horde_conf.php "$install_dir/horde/config/conf.php"
    #ynh_replace_string --match_string __DOMAIN__ --replace_string "$domain" --target_file "$install_dir/horde/config/conf.php"
    #ynh_replace_string --match_string __PATH__ --replace_string "$path" --target_file "$install_dir/horde/config/conf.php"
    #ynh_replace_string --match_string __INSTALL_DIR__ --replace_string "$install_dir" --target_file "$install_dir/horde/config/conf.php"
    #ynh_replace_string --match_string __DB_NAME__ --replace_string "$db_name" --target_file "$install_dir/horde/config/conf.php"
    #ynh_replace_string --match_string __DB_USER__ --replace_string "$db_user" --target_file "$install_dir/horde/config/conf.php"
    #ynh_replace_string --match_string __DB_PWD__ --replace_string "$db_pwd" --target_file "$install_dir/horde/config/conf.php"
    #ynh_replace_string --match_string __ADMIN__ --replace_string "$admin" --target_file "$install_dir/horde/config/conf.php"
    #ynh_replace_string --match_string __SECRET_KEY__ --replace_string "$secret_key" --target_file "$install_dir/horde/config/conf.php"
    
    ynh_add_config --template="horde_conf.php" --destination="$install_dir/horde/config/conf.php"

    ynh_add_config --template="/horde_imp_conf.php" --destination="$install_dir/horde/imp/config/conf.php"
    #cp ../conf/horde_imp_conf.php "$install_dir/horde/imp/config/conf.php"
    
    ynh_add_config --template="horde_registry.php" --destination="$install_dir/horde/config/registry.local.php"
    #cp ../conf/horde_registry.php "$install_dir/horde/config/registry.local.php"
    #ynh_replace_string --match_string __PATH__ --replace_string "$path" --target_file "$install_dir/horde/config/registry.local.php"

    ynh_add_config --template="gollem_backends.php" --destination="$install_dir/horde/gollem/config/backends.local.php"
    #cp ../conf/gollem_backends.php "$install_dir/horde/gollem/config/backends.local.php"
    #ynh_replace_string --match_string __DATA_DIR__ --replace_string "$data_dir" --target_file "$install_dir/horde/gollem/config/backends.local.php"

    ynh_add_config --template="ingo_backends.php" --destination="$install_dir/horde/ingo/config/backends.local.php"
    #cp ../conf/ingo_backends.php "$install_dir/horde/ingo/config/backends.local.php"

    ynh_store_file_checksum --file "$install_dir/horde/config/conf.php"
    ynh_store_file_checksum --file "$install_dir/horde/imp/config/conf.php"
    ynh_store_file_checksum --file "$install_dir/horde/config/registry.local.php"
    ynh_store_file_checksum --file "$install_dir/horde/gollem/config/backends.local.php"
    ynh_store_file_checksum --file "$install_dir/horde/ingo/config/backends.local.php"
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
