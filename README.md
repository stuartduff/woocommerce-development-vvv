# WooCommerce Development VVV

WooCommerce Development VVV is an [auto-sitesetup](https://github.com/Varying-Vagrant-Vagrants/VVV/wiki/Auto-site-Setup) designed to be used with [Varying Vagrant Vagrants](https://github.com/Varying-Vagrant-Vagrants/VVV) for developing or testing [WooCommerce](https://woocommerce.com) focused plugins and themes.

Supports VVV 2.0 and above only.

## Installing:

If you do not have an existing `vvv-custom.yml` file added to you Vagrant setup then you can copy the example `vvv-custom.yml` which can be found in the `/config-yml/` folder into the root directory of your Vagrant install.

If you are already using an existing [vvv-custom.yml](https://varyingvagrantvagrants.org/docs/en-US/vvv-config/) file for your VVV installation simply add the code below to your existing [vvv-custom.yml](https://varyingvagrantvagrants.org/docs/en-US/vvv-config/) file instead of copying the quickstart file over to your install.

```
# The woocommerce-develop configuration is useful for contributing to WooCommerce.
# Read more on custom sites https://varyingvagrantvagrants.org/docs/en-US/vvv-config/
wooocommerce-develop:
  repo: https://github.com/stuartduff/woocommerce-development-vvv.git
  hosts:
    - local.woocommerce.test
```

If your Vagrant is running, from the Vagrant directory run `vagrant halt` followed by `vagrant up --provision`.

Now you can sit back and relax as provisioning may take a while to complete.

Once provisioning has completed you can visit the defined host name to see your newly installed site.

## WordPress Login Details

Admin URL: http://{host name}/wp-admin/ </br>
Username: `admin` </br>
Password: `password`

## phpMyAdmin Login Details

phpMyAdmin URL: [vvv.dev/database-admin/](http://vvv.dev/database-admin/) </br>
Username: `root` </br>
Password: `root`

## Important Step!
Once logged into the admin section of the site for the first time you will see a message at the top of the site requesting that you run the WooCommerce Setup Wizard.

Do this immediately as it sets up various important WooCommerce functionality including the cart and checkout pages etc and is required to complete the installation.

This is all the manual configuration thats required for a basic install!

## Installed theme
The default theme that is installed and setup on the VVV is the free [Storefront](https://woocommerce.com/storefront/) theme for WooCommerce.

During installation two pages are created titled Blog and Homepage, homepage has a page template activated on it which displays the custom Storefront homepage layout.

The Homepage is then set as the Frontpage of the WordPress install with the Blog page being as the posts page from **WordPress > Settings > Reading >
Front page displays**

## Custom Menu
A custom menu titled **Primary Menu** is created and added to the `primary-menu` area within the Storefront theme.

You can use this to add some more custom menu items should you require those.

## Installed Plugins
You can see which plugins are installed and activated from looking at the `vvv-init.sh` file and these may change on occasion hence I'm not going to list them here.

## Demo Content
The site has the official WordPress theme review [theme unit test data](https://codex.wordpress.org/Theme_Unit_Test) installed for blog posts etc. For WooCommerce the official product [dummy data](https://github.com/woocommerce/woocommerce/blob/master/dummy-data/dummy-data.xml) is installed.

## Changelog

**2.0.0 - 18/03/17**
* Updated to function with VVV v2.0 and above.

**1.0.0 - 13/10/16**
* Initial Release - first version VVV released.
