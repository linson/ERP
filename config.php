<?php

$service = 'dev';
//$service = 'backyard';

$server_ip  = $_SERVER['SERVER_ADDR'];
$server_url = 'http://' . $server_ip . '/';
$server_path = '/var/www/html/' . $service . '/';

// HTTP
define('HTTP_SERVER2',$server_url);
define('HTTP_SERVER', $server_url . $service . '/' );
define('HTTP_CATALOG',$server_url . $service . '/');
define('HTTP_IMAGE',  $server_url . $service . '/image/');

// HTTPS
define('HTTPS_SERVER',$server_url . $service . '/');
define('HTTPS_IMAGE', $server_url . $service . '/image/');

/* todo. better to use defined VAR
echo phpinfo();
echo $_SERVER["DOCUMENT_ROOT"];
*/

// DIR
define('DIR_APPLICATION', $server_path);
define('DIR_SYSTEM', $server_path . 'system/');
define('DIR_DATABASE', $server_path . 'system/database/');
define('DIR_LANGUAGE', $server_path . 'language/');
define('DIR_TEMPLATE', $server_path . 'view/template/');
define('DIR_CONFIG',   $server_path . 'system/config/');
define('DIR_IMAGE', $server_path . 'image/');
define('DIR_CACHE', $server_path . 'system/cache/');
define('DIR_DOWNLOAD', $server_path . 'download/');
define('DIR_LOGS', $server_path . 'system/logs/');
define('DIR_CATALOG', $server_path . 'catalog/');

// DB
define('DB_DRIVER', 'mysql');
define('DB_HOSTNAME', 'localhost');
define('DB_USERNAME', 'dev');
define('DB_PASSWORD', '1111');
define('DB_DATABASE', 'dev');
define('DB_PREFIX', '');

define('DATE_FORMAT','Y-m-d');
?>
