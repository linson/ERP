<?php
// HTTP
define('HTTP_SERVER2', 'http://168.93.73.186/');
define('HTTP_SERVER', 'http://168.93.73.186/dev/');
define('HTTP_CATALOG', 'http://168.93.73.186/dev/');
define('HTTP_IMAGE', 'http://168.93.73.186/dev/image/');

// HTTPS
define('HTTPS_SERVER', 'http://168.93.73.186/dev/');
define('HTTPS_IMAGE', 'http://168.93.73.186/dev/image/');

/* todo. better to use defined VAR
echo phpinfo();
echo $_SERVER["DOCUMENT_ROOT"];
*/

// DIR
define('DIR_APPLICATION', '/var/www/html/dev/');
define('DIR_SYSTEM','/var/www/html/dev/system/');
define('DIR_DATABASE','/var/www/html/dev/system/database/');
define('DIR_LANGUAGE', '/var/www/html/dev/language/');
define('DIR_TEMPLATE', '/var/www/html/dev/view/template/');
define('DIR_CONFIG', '/var/www/html/dev/system/config/');
define('DIR_IMAGE', '/var/www/html/dev/image/');
define('DIR_CACHE', '/var/www/html/dev/system/cache/');
define('DIR_DOWNLOAD', '/var/www/html/dev/download/');
define('DIR_LOGS', '/var/www/html/dev/system/logs/');
define('DIR_CATALOG', '/var/www/html/dev/catalog/');

// DB
define('DB_DRIVER', 'mysql');
define('DB_HOSTNAME', 'localhost');
define('DB_USERNAME', 'dev');
define('DB_PASSWORD', '1111');
define('DB_DATABASE', 'dev');
define('DB_PREFIX', '');

define('DATE_FORMAT','Y-m-d');
?>