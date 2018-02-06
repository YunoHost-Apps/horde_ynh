Horde for yunohost
========================

*https://www.horde.org/

[![Integration level](https://dash.yunohost.org/integration/horde.svg)](https://ci-apps.yunohost.org/jenkins/job/horde%20%28Community%29/lastBuild/consoleFull) 

[![Install Horde with YunoHost](https://install-app.yunohost.org/install-with-yunohost.png)](https://install-app.yunohost.org/?app=horde)

Install
-------

From command line:

`sudo yunohost app install -l horde https://github.com/YunoHost-Apps/horde_ynh`

Upgrade
-------

From command line:

`sudo yunohost app upgrade -u https://github.com/YunoHost-Apps/horde_ynh`

Issue
-----

Any issue is welcome here : https://github.com/YunoHost-Apps/horde_ynh/issues

ActiveSync
----------

For calendar, task and addressbook activeSync has been configured but not yet tested.


Troubleshotting
---------------

**Get Address is missing domain while to try to send an email.**

- You need to create an identity before send an email.
- To create this go in the settings wheel > Preferences > Global Preferences > Personal Information.
- Complete the form and save it.
- You might be able to sed an email now.

License
-------

Horde is published under the GPL-2.0, LGPL-2.1, BSD-2-Clause, ASL, OSI certified
All information about the licence for each part is available here : http://pear.horde.org/

TODO
----

- [ ] Service auto-discovery test
- [ ] Improve doc
- [ ] Improve https://vm-yh-2.lan/horde/test.php to have all optional dependence installed