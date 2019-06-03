#!/usr/bin/env bash

echo "Checking USER ID"
www_uid=`stat -c "%u" /var/www/html`
www_gid=`stat -c "%g" /var/www/html`

echo "Host user is $www_uid:$www_gid"

if [ ! $www_uid -eq 0 ]; then
	echo "Updating airsnapshots user and group to match host IDs"
	usermod -u $www_uid airsnapshots
	groupmod -g $www_gid airsnapshots
fi

exec su - airsnapshots -c "$@"
