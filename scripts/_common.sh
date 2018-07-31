#!/bin/bash

#=================================================
# SET ALL CONSTANTS
#=================================================

app=$YNH_APP_INSTANCE_NAME
final_path="/var/www/$app"
gollem_data_dir="/home/yunohost.app/$app"

#=================================================
# DEFINE ALL COMMON FONCTIONS
#=================================================

install_dependance() {
    ynh_install_app_dependencies php-pear expect 'php5-imagick|php-imagick' 'php5-tidy|php-tidy'
}

patch_app() {
    local old_dir=$(pwd)
    (cd "$final_path/horde" && patch -p1 < $YNH_CWD/../sources/sso_auth.patch) || echo "Unable to apply patches"
    cd $old_dir
}

config_horde() {
    ynh_backup_if_checksum_is_different "$final_path/horde/config/conf.php"
    ynh_backup_if_checksum_is_different "$final_path/horde/imp/config/conf.php"
    ynh_backup_if_checksum_is_different "$final_path/horde/config/registry.local.php"
    ynh_backup_if_checksum_is_different "$final_path/horde/gollem/config/backends.local.php"
    ynh_backup_if_checksum_is_different "$final_path/horde/ingo/config/backends.local.php"

    cp ../conf/horde_conf.php "$final_path/horde/config/conf.php"
    ynh_replace_string "__DOMAIN__" "$domain" "$final_path/horde/config/conf.php"
    ynh_replace_string "__PATH__" "$path_url" "$final_path/horde/config/conf.php"
    ynh_replace_string "__FINAL_PATH__" "$final_path" "$final_path/horde/config/conf.php"
    ynh_replace_string "__DB_NAME__" "$db_name" "$final_path/horde/config/conf.php"
    ynh_replace_string "__DB_USER__" "$db_user" "$final_path/horde/config/conf.php"
    ynh_replace_string "__DB_PASSWORD__" "$db_pwd" "$final_path/horde/config/conf.php"
    ynh_replace_string "__ADMIN_USER__" "$admin" "$final_path/horde/config/conf.php"
    ynh_replace_string "__SECRET_KEY__" "$secret_key" "$final_path/horde/config/conf.php"
    
    cp ../conf/horde_imp_conf.php "$final_path/horde/imp/config/conf.php"
    
    cp ../conf/horde_registry.php "$final_path/horde/config/registry.local.php"
    ynh_replace_string "__PATH__" "$path_url" "$final_path/horde/config/registry.local.php"

    cp ../conf/gollem_backends.php "$final_path/horde/gollem/config/backends.local.php"
    ynh_replace_string "__GOLLEM_DATA_DIR__" "$gollem_data_dir" "$final_path/horde/gollem/config/backends.local.php"

    cp ../conf/ingo_backends.php "$final_path/horde/ingo/config/backends.local.php"

    ynh_store_file_checksum "$final_path/horde/config/conf.php"
    ynh_store_file_checksum "$final_path/horde/imp/config/conf.php"
    ynh_store_file_checksum "$final_path/horde/config/registry.local.php"
    ynh_store_file_checksum "$final_path/horde/gollem/config/backends.local.php"
    ynh_store_file_checksum "$final_path/horde/ingo/config/backends.local.php"
}

config_nginx() {
    ynh_add_nginx_config
    [[ $service_autodiscovery ]] && add_nginx_autodiscovery
    ynh_store_file_checksum "/etc/nginx/conf.d/$domain.d/$app.conf"
}

add_nginx_autodiscovery() {
    nginx_domain_path=/etc/nginx/conf.d/$domain.d/*
    nginx_config_path="/etc/nginx/conf.d/$domain.d/$app.conf"
    grep "/Microsoft-Server-ActiveSync" $nginx_domain_path || echo "location /Microsoft-Server-ActiveSync {
    return 301 https://\$server_name$path_url/rpc.php;
    }
    " >> "$nginx_config_path"

    grep "/autodiscover/autodiscover.xml" $nginx_domain_path || echo "location /autodiscover/autodiscover.xml {
    return 301 https://\$server_name$path_url/rpc.php;
    }
    " >> "$nginx_config_path"

    grep "/Autodiscover/Autodiscover.xml" $nginx_domain_path || echo "location /Autodiscover/Autodiscover.xml {
    return 301 https://\$server_name$path_url/rpc.php;
    }
    " >> "$nginx_config_path"

    grep "/.well-known/caldav" $nginx_domain_path || echo "location /.well-known/caldav {
    return 301 https://\$server_name$path_url/rpc.php;
    }
    " >> "$nginx_config_path"

    grep "/.well-known/carddav" $nginx_domain_path || echo "location /.well-known/carddav {
    return 301 https://\$server_name$path_url/rpc.php;
    }
    " >> "$nginx_config_path"
}

set_permission() {
    chown -R www-data:$app $final_path
    chown -R www-data:$app $gollem_data_dir
    chmod u=rwX,g=rwX,o= -R $final_path
    chmod u=rwX,g=rwX,o= -R $gollem_data_dir
}