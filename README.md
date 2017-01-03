# PHP Docker Image

Dockerfile for creating PHP image with necessary extensions and handy tools

## What's inside?

* PHP 7.0 official Debian based image : [Read more](https://github.com/docker-library/php/blob/master/7.0/fpm/Dockerfile)
* All locales generated & Locales set to utf8
* Extensions: 
  * Apcu
  * Bcmath
  * Blackfire
  * Gd
  * Imagick
  * Intl 
  * Mysqlnd
  * Opcache
  * Pdo Mysql 
  * Redis
  * Sockets
  * Zip 
* Extensions can be enabled or disabled with environment variables
* Composer
* PhpUnit

## Extensions Environment Variables
* `EXT_APCU` : "on"
* `EXT_BCMATH` : "off"
* `EXT_BLACKFIRE` : "off"
* `EXT_GD` : "off"
* `EXT_IMAGICK` : "off"
* `EXT_INTL` : "off"
* `EXT_OPCACHE` : "on"
* `EXT_PDO_MYSQL` : "off"
* `EXT_MYSQL` : "off"
* `EXT_REDIS` : "off"
* `EXT_SOCKETS` : "off"
* `EXT_ZIP` : "off"

## Environment Variables
* `PHP_POST_MAX_SIZE` : "64m"
* `PHP_UPLOAD_MAX_FILESIZE` : "64m"
* `FPM_PM` : "dynamic"
* `FPM_PM_MAX_CHILDREN` : "5"
* `FPM_PM_START_SERVERS` : "2"
* `FPM_PM_MIN_SPARE_SERVERS` : "1"
* `FPM_PM_MAX_SPARE_SERVERS` : "3"
* `FPM_PM_PROCESS_IDLE_TIMEOUT` : "10s"
* `FPM_PM_MAX_REQUESTS` : "0"
* `FPM_STATUS_PATH` : "/fpm-status"
* `FPM_PING_PATH` : "/fpm-ping"
* `FPM_PING_RESPONSE` : "pong"