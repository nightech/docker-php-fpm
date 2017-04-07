#!/usr/bin/env bash

set -e

# Extensions
declare -A ENV_EXT=()
declare -A ENV_EXT_STATUS=()

ENV_EXT[EXT_APCU]="docker-php-ext-apcu"
ENV_EXT_STATUS[EXT_APCU]=${EXT_APCU:-"on"}

ENV_EXT[EXT_BCMATH]="docker-php-ext-bcmath"
ENV_EXT_STATUS[EXT_BCMATH]=${EXT_BCMATH:-"off"}

ENV_EXT[EXT_BLACKFIRE]="blackfire"
ENV_EXT_STATUS[EXT_BLACKFIRE]=${EXT_BLACKFIRE:-"off"}

ENV_EXT[EXT_GD]="docker-php-ext-gd"
ENV_EXT_STATUS[EXT_GD]=${EXT_GD:-"off"}

ENV_EXT[EXT_IMAGICK]="docker-php-ext-imagick"
ENV_EXT_STATUS[EXT_IMAGICK]=${EXT_IMAGICK:-"off"}

ENV_EXT[EXT_IMAP]="docker-php-ext-imap"
ENV_EXT_STATUS[EXT_IMAP]=${EXT_IMAP:-"off"}

ENV_EXT[EXT_INTL]="docker-php-ext-intl"
ENV_EXT_STATUS[EXT_INTL]=${EXT_INTL:-"off"}

ENV_EXT[EXT_MCRYPT]="docker-php-ext-mcrypt"
ENV_EXT_STATUS[EXT_MCRYPT]=${EXT_MCRYPT:-"off"}

ENV_EXT[EXT_OPCACHE]="docker-php-ext-opcache"
ENV_EXT_STATUS[EXT_OPCACHE]=${EXT_OPCACHE:-"on"}

ENV_EXT[EXT_PDO_MYSQL]="docker-php-ext-pdo_mysql"
ENV_EXT_STATUS[EXT_PDO_MYSQL]=${EXT_PDO_MYSQL:-"off"}

ENV_EXT[EXT_MYSQL]="docker-php-ext-mysqli"
ENV_EXT_STATUS[EXT_MYSQL]=${EXT_MYSQL:-"off"}

ENV_EXT[EXT_REDIS]="docker-php-ext-redis"
ENV_EXT_STATUS[EXT_REDIS]=${EXT_REDIS:-"off"}

ENV_EXT[EXT_SOCKETS]="docker-php-ext-sockets"
ENV_EXT_STATUS[EXT_SOCKETS]=${EXT_SOCKETS:-"off"}

ENV_EXT[EXT_YAML]="docker-php-ext-yaml"
ENV_EXT_STATUS[EXT_YAML]=${EXT_YAML:-"off"}

ENV_EXT[EXT_ZIP]="docker-php-ext-zip"
ENV_EXT_STATUS[EXT_ZIP]=${EXT_ZIP:-"off"}

for KEY in "${!ENV_EXT[@]}"; do
    if [ ${ENV_EXT_STATUS[$KEY]} == 'on' ] ; then
        mv "/usr/local/etc/php/conf.d/"${ENV_EXT[$KEY]}".disabled" "/usr/local/etc/php/conf.d/"${ENV_EXT[$KEY]}".ini" 2> /dev/null || true
        # echo "Php Ext :" $KEY "enabled"
    else
        mv "/usr/local/etc/php/conf.d/"${ENV_EXT[$KEY]}".ini" "/usr/local/etc/php/conf.d/"${ENV_EXT[$KEY]}".disabled" 2> /dev/null || true
    fi
done

# Ini
declare -A ENV_CONFIG=()

# zzz-upload.ini
ENV_CONFIG[PHP_EXT_OPCACHE_MEMORY]=${PHP_EXT_OPCACHE_MEMORY:-"128"}
ENV_CONFIG[PHP_EXT_OPCACHE_VALIDATE_TIMESTAMPS]=${PHP_EXT_OPCACHE_VALIDATE_TIMESTAMPS:-"1"}

# zzz-upload.ini
ENV_CONFIG[PHP_POST_MAX_SIZE]=${PHP_POST_MAX_SIZE:-"64m"}
ENV_CONFIG[PHP_UPLOAD_MAX_FILESIZE]=${PHP_UPLOAD_MAX_FILESIZE:-"64m"}

# zzz-process.ini
ENV_CONFIG[FPM_PM]=${FPM_PM:-"dynamic"}
ENV_CONFIG[FPM_PM_MAX_CHILDREN]=${FPM_PM_MAX_CHILDREN:-"5"}
ENV_CONFIG[FPM_PM_START_SERVERS]=${FPM_PM_START_SERVERS:-"2"}
ENV_CONFIG[FPM_PM_MIN_SPARE_SERVERS]=${FPM_PM_MIN_SPARE_SERVERS:-"1"}
ENV_CONFIG[FPM_PM_MAX_SPARE_SERVERS]=${FPM_PM_MAX_SPARE_SERVERS:-"3"}
ENV_CONFIG[FPM_PM_PROCESS_IDLE_TIMEOUT]=${FPM_PM_PROCESS_IDLE_TIMEOUT:-"10s"}
ENV_CONFIG[FPM_PM_MAX_REQUESTS]=${FPM_PM_MAX_REQUESTS:-"0"}

# zzz-status.ini
ENV_CONFIG[FPM_STATUS_PATH]=${FPM_STATUS_PATH:-"/fpm-status"}
ENV_CONFIG[FPM_PING_PATH]=${FPM_PING_PATH:-"/fpm-ping"}
ENV_CONFIG[FPM_PING_RESPONSE]=${FPM_PING_RESPONSE:-"pong"}

for FILE in `find  /usr/local/etc/php /usr/local/etc/php-fpm.d -type f -name zzz-*`;  do
    for KEY in "${!ENV_CONFIG[@]}"; do
        sed -i.bak "s!\%"$KEY"\%!"${ENV_CONFIG[$KEY]}"!g" $FILE
    done
done

find  /usr/local/etc/php /usr/local/etc/php-fpm.d -type f -name zzz-*.bak -delete

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
    set -- php "$@"
fi

exec "$@"
