echo "\nSetting Up WooCommerce Development Enviroment\n"

# If we delete htdocs, let's just start over.
if [ ! -d "htdocs" ]
then

  echo "Creating directory htdocs for WooCommerce Development...\n"
  mkdir htdocs
  cd htdocs

  # **
  # Database
  # **

  # Create the database over again.
  echo "(Re-)Creating database 'woocommerce_development'...\n"
  mysql -u root --password=root -e "DROP DATABASE IF EXISTS \`woocommerce_development\`"
  mysql -u root --password=root -e "CREATE DATABASE IF NOT EXISTS \`woocommerce_development\`"
  mysql -u root --password=root -e "GRANT ALL PRIVILEGES ON \`woocommerce_development\`.* TO wp@localhost IDENTIFIED BY 'wp';"

  # **
  # WordPress
  # **

  # Download WordPress
  echo "Downloading WordPress in htdocs...\n"
  wp core download --locale=en_US --allow-root

  # Install WordPress.
  echo "Creating wp-config in htdocs...\n"
  wp core config --dbname='woocommerce_development' --dbuser=wp --dbpass=wp --dbhost='localhost' --dbprefix=wp_ --locale=en_US --allow-root --extra-php <<PHP
define( 'WP_DEBUG', true );
define( 'WP_DEBUG_DISPLAY', false );
define( 'WP_DEBUG_LOG', true );
define( 'SCRIPT_DEBUG', true );
define( 'JETPACK_DEV_DEBUG', true );
PHP

  # Install into DB
  echo 'Installing WordPress...\n'
  wp core install --url=local.woocommerce.dev --title='WooCommerce' --admin_user=admin --admin_password=password --admin_email=changme@changeme.com --allow-root

  # Update Blog Description option
  echo 'Updating tagline...\n'
  wp option update blogdescription 'WooCommerce Development VVV' --allow-root

  # **
  # Your themes
  # **
  echo 'Installing themes...\n'
  wp theme install storefront --activate --allow-root

  # Delete unrequired themes
  echo "Deleting unrequired default themes..."
  wp theme delete twentyfifteen  --allow-root
  wp theme delete twentyfourteen --allow-root

  # **
  # # Create pages
  # **
  echo "Creating pages for the Storefront theme..."
  wp post create --post_type=page --post_title='Homepage' --post_status=publish --post_author=1 --allow-root
  wp post create --post_type=page --post_title='Blog' --post_status=publish --post_author=1 --allow-root

  # **
  # # Set homepage template for the storefront theme to the page post meta
  # **
  echo "Setting Storefront homepage template meta..."
  wp post meta set 3 _wp_page_template template-homepage.php --allow-root

  # **
  # # Enable a page to display as the frontpage of the site.
  # # Set the homepage as the frontpage of the site.
  # # Set the Blog page as the posts page for the site.
  # **
  echo "Setting Storefront pages as the WordPress Frontpage and Posts Page..."
  wp option update show_on_front page --allow-root
  wp option update page_on_front 3 --allow-root
  wp option update page_for_posts 4 --allow-root

  # **
  # # Create Menus
  # **
  echo "Create Custom WordPress Primary Menu..."
  wp menu create 'Primary Menu' --allow-root

  echo "Assign primary menu to the storefront themes primary location..."
  wp menu location assign primary-menu primary --allow-root

  echo "Adding basic menu items to the Primary Menu..."
  wp menu item add-custom primary-menu Home http://local.woocommerce.dev/ --allow-root
  wp menu item add-post primary-menu 4 --title='Blog' --allow-root

  # **
  # # Plugins
  # **

  echo 'Installing plugins...\n'
  wp plugin install woocommerce --activate --allow-root
  wp plugin install wordpress-importer --activate --allow-root
  wp plugin install homepage-control --activate --allow-root
  wp plugin install customizer-reset-by-wpzoom --activate --allow-root
  wp plugin install user-switching  --activate --allow-root
  wp plugin install regenerate-thumbnails  --activate --allow-root
  wp plugin install wp-mail-logging  --allow-root
  wp plugin install wp-crontrol  --activate --allow-root
  wp plugin install loco-translate  --allow-root
  wp plugin install query-monitor --allow-root
  wp plugin install jetpack --activate --allow-root
  wp plugin install developer --activate --allow-root
  wp plugin install debug-bar  --activate --allow-root
  wp plugin install debug-bar-console  --activate --allow-root
  wp plugin install debug-bar-cron  --activate --allow-root
  wp plugin install debug-bar-extender  --activate --allow-root
  wp plugin install rewrite-rules-inspector  --activate --allow-root
  wp plugin install log-deprecated-notices   --allow-root
  wp plugin install log-viewer --allow-root
  wp plugin install wordpress-beta-tester --allow-root

  # Delete unrequired default plugins
  echo "Deleting unrequired default plugins..."
  wp plugin delete hello   --allow-root
  wp plugin delete akismet --allow-root

  # Add Github hosted plugins.
  echo 'Installing public remote Git repo software installs...\n'
  git clone --recursive https://github.com/mattyza/matty-theme-quickswitch.git        wp-content/plugins/matty-theme-quickswitch
  wp plugin activate matty-theme-quickswitch --allow-root

  git clone --recursive https://github.com/woocommerce/woocommerce-beta-tester.git    wp-content/plugins/woocommerce-beta-tester

  # **
  # Unit Data
  # **

  # Import the WordPress unit data.
  echo 'Installing unit test data...\n'
  curl -O https://wpcom-themes.svn.automattic.com/demo/theme-unit-test-data.xml
  wp import theme-unit-test-data.xml --authors=create --allow-root
  rm theme-unit-test-data.xml

  # Import the WooCommerce unit data.
  echo 'Installing WooCommerce dummy product data...\n'
  curl -O https://raw.githubusercontent.com/woocommerce/woocommerce/master/dummy-data/dummy-data.xml
  wp import dummy-data.xml --authors=create --allow-root
  rm dummy-data.xml

  # Replace any urls from the WordPress unit data
  echo 'Adjusting urls in database...\n'
  wp search-replace 'wpthemetestdata.wordpress.com' 'local.woocommerce.dev' --skip-columns=guid --allow-root

  # Update the sites permalink structure
  echo 'Update permalink structure...\n'
  wp option update permalink_structure '/%postname%/' --allow-root
  wp rewrite flush --allow-root

  cd ..

else

  cd htdocs/

  # Updates
  if $(wp core is-installed --allow-root); then

    # Update WordPress.
    echo "Updating WordPress for WooCommerce Development VVV...\n"
    wp core update --allow-root
    wp core update-db --allow-root

    # Update Plugins
    echo "Updating plugins for WooCommerce Development VVV...\n"
    wp plugin update --all --allow-root

    # **
    # Your themes
    # **
    echo "Updating themes for WooCommerce Development VVV...\n"
    wp theme update --all --allow-root

  fi

  cd ..

fi