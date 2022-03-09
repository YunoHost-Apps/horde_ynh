# Horde pour YunoHost

[![Niveau d'intégration](https://dash.yunohost.org/integration/horde.svg)](https://dash.yunohost.org/appci/app/horde) ![](https://ci-apps.yunohost.org/ci/badges/horde.status.svg) ![](https://ci-apps.yunohost.org/ci/badges/horde.maintain.svg)  
[![Installer Horde avec YunoHost](https://install-app.yunohost.org/install-with-yunohost.svg)](https://install-app.yunohost.org/?app=horde)

*[Read this readme in english.](./README.md)*
*[Lire ce readme en français.](./README_fr.md)*

> *Ce package vous permet d'installer Horde rapidement et simplement sur un serveur YunoHost.
Si vous n'avez pas YunoHost, regardez [ici](https://yunohost.org/#/install) pour savoir comment l'installer et en profiter.*

## Vue d'ensemble

A groupware (webmail, adressbook, calendar) witch use PHP


**Version incluse :** 5.2.22~ynh4

**Démo :** http://demo.horde.org

## Captures d'écran

![](./doc/screenshots/screenshot01.png)

## Avertissements / informations importantes

### Customisation

#### Install others app.

The package provide some apps, but it's could be possible to install some others apps. The list of all availabe apps are listed here : https://www.horde.org/apps

Before any change it's recommended to make a backup :
```bash
# In case of multiple instance adapt "horde" by the horde instance
sudo yunohost backup create --verbose --ignore-system --apps horde
```

Install horde apps with pear :

```bash
# Get the horde final_path
# In case of multiple instance adapt "horde" by the horde instance
final_path=$(yunohost app setting horde final_path)

# Set the pear command to call to stay in the horde environnement (not in the global system environnement)
pear_cmd="$final_path/pear/pear -c $final_path/pear.conf"

# Update the pear channel
$pear_cmd channel-update pear.horde.org

# Install the app that you want
$pear_cmd install -a -B horde/APP_TO_INSTALL

# Set the final permission
# In case of multiple instance adapt "horde" by the horde instance
chown -R www-data:horde $final_path

```

After you need to update the horde database schema and the horde config. So go on the horde config pannel (in the settings wheel > Preferences > Administration > Configuration). Click on "Update all DB schemas" and then on "Update all configurations".

Now you should be able to use the new apps.

### ActiveSync

For calendar, task and addressbook activeSync has been configured but not yet tested.

### Troubleshotting

**Get Address is missing domain while to try to send an email.**

- You need to create an identity before send an email.
- To create this go in the settings wheel > Preferences > Global Preferences > Personal Information.
- Complete the form and save it.
- You might be able to sed an email now.

## Documentations et ressources

* Site officiel de l'app : https://www.horde.org
* Documentation officielle de l'admin : https://wiki.horde.org
* Dépôt de code officiel de l'app : https://github.com/horde
* Documentation YunoHost pour cette app : https://yunohost.org/app_horde
* Signaler un bug : https://github.com/YunoHost-Apps/horde_ynh/issues

## Informations pour les développeurs

Merci de faire vos pull request sur la [branche testing](https://github.com/YunoHost-Apps/horde_ynh/tree/testing).

Pour essayer la branche testing, procédez comme suit.
```
sudo yunohost app install https://github.com/YunoHost-Apps/horde_ynh/tree/testing --debug
ou
sudo yunohost app upgrade horde -u https://github.com/YunoHost-Apps/horde_ynh/tree/testing --debug
```

**Plus d'infos sur le packaging d'applications :** https://yunohost.org/packaging_apps