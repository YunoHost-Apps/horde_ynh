Horde for yunohost
==================

[![Integration level](https://dash.yunohost.org/integration/horde.svg)](https://ci-apps.yunohost.org/jenkins/job/horde%20%28Community%29/lastBuild/consoleFull)  
[![Install horde with YunoHost](https://install-app.yunohost.org/install-with-yunohost.png)](https://install-app.yunohost.org/?app=horde)

> *This package allow you to install horde quickly and simply on a YunoHost server.  
If you don't have YunoHost, please see [here](https://yunohost.org/#/install) to know how to install and enjoy it.*

Overview
--------

A groupware (webmail, adressbook, calendar) witch use PHP

**Shipped version:** 5.2.22

Screenshots
-----------

![](https://www.horde.org/images/slides/h5slider.png)

Demo
----

* [Official demo](http://demo.horde.org/)

Documentation
-------------

 * Official documentation: https://wiki.horde.org/
 * YunoHost documentation: There no other documentations, feel free to contribute.

YunoHost specific features
--------------------------

### Multi-users support

This app support the SSO and LDAP.

### Supported architectures

* x86-64b - [![Build Status](https://ci-apps.yunohost.org/jenkins/job/horde%20(Community)/badge/icon)](https://ci-apps.yunohost.org/jenkins/job/horde%20(Community)/)
* ARMv8-A - [![Build Status](https://ci-apps-arm.yunohost.org/jenkins/job/horde%20(Community)%20(%7EARM%7E)/badge/icon)](https://ci-apps-arm.yunohost.org/jenkins/job/horde%20(Community)%20(%7EARM%7E)/)
* Jessie x86-64b - [![Build Status](https://ci-stretch.nohost.me/jenkins/job/horde%20(Community)/badge/icon)](https://ci-stretch.nohost.me/jenkins/job/horde%20(Community)/)

<!--Limitations
-----------

* Any known limitations.-->

Additional informations
-----------------------

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

Links
-----

 * Report a bug: https://github.com/YunoHost-Apps/horde_ynh/issues
 * App website: https://www.horde.org/
 * YunoHost website: https://yunohost.org/

---

Install
-------

From command line:

`sudo yunohost app install -l horde https://github.com/YunoHost-Apps/horde_ynh`

Upgrade
-------

From command line:

`sudo yunohost app upgrade horde -u https://github.com/YunoHost-Apps/horde_ynh`

Developers infos
----------------

To try the testing branch, please proceed like that.
```
sudo yunohost app install https://github.com/YunoHost-Apps/horde_ynh/tree/testing --debug
or
sudo yunohost app upgrade horde -u https://github.com/YunoHost-Apps/horde_ynh/tree/testing --debug
```

License
-------

Horde is published under the GPL-2.0, LGPL-2.1, BSD-2-Clause, ASL, OSI certified
All information about the licence for each part is available here : http://pear.horde.org/

TODO
----

- [ ] Service auto-discovery test
- [ ] Improve doc
- [ ] Improve https://vm-yh-2.lan/horde/test.php to have all optional dependence installed