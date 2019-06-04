
#!/bin/bash
set -e

airsnapshots='/home/airsnapshots/.composer/vendor/bin/airsnapshots'
wpdir='/var/www/html'

maybe_run_airsnapshots() {
    if [ -e /home/airsnapshots/.airsnapshots/config.json ]; then

        su - airsnapshots -c  "cd $wpdir; $airsnapshots $*"
     else
        echo 'Air DB Snapshots is not configured, you must run ./airsnapshots.<sh|bat> configure <repository> from the bin/ directory';
        exit 1;
    fi
}

case "$1" in
    configure)
        su - airsnapshots -c "$airsnapshots $*"
        ;;
    *)
        maybe_run_airsnapshots "$@"
        ;;
esac
