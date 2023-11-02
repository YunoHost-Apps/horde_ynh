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
- You might be able to send an email now.
