#!/bin/bash


FF_PACKAGES="ntls findface-nnapi fkvideo-detector python3-facenapi.core python3-facenapi findface-tarantool-server findface-tarantool-build-index findface-ui findface-mass-enroll findface-extraction-api findface-repo findface-rtmp-server findface-upload python3-nnd"
SIDE_PACKAGES="mongod* tarantool*"
ALL_PACKAGES="$FF_PACKAGES $SIDE_PACKAGES findface-data*"

now=$(date +"%m_%d_%Y.%H:%M")

echo "############################
!!!This script will remove FindFace Server, MongoDB and Tarantool by command prompt.
It can ERASE face data!!!
Config files will be backed up to ~/ffserver_bak/."

backupCfg() {
    mkdir $HOME/ffserver_bak/
    mkdir $HOME/ffserver_bak/etc/
    for cfg in /etc/{{findface-{nnapi,searchapi,facenapi,extraction-api},fkvideo*}.ini,ntls.cfg,tntapi*.json};
    do
        if [ -f "$cfg" ]; then
            mv "$cfg" "$HOME/ffserver_bak/${cfg}_$now.bak"
            echo "File $cfg found and deleted. Backup created."
        else
            echo "NO such file or directory $cfg"
        fi
    done
}

backupTntCfg() {
    mkdir $HOME/ffserver_bak/tnt/
    cp /etc/tarantool/instances.enabled/* $HOME/ffserver_bak/tnt/
    for cfg in $HOME/ffserver_bak/tnt/*.lua;
    do
        if [ -f "$cfg" ]; then
            mv "$cfg" "${cfg}_$now.bak"
            echo "File $cfg found and deleted. Backup created."
        else
            echo "NO such file or directory $cfg"
        fi
    done
}

backupNginxCfg() {
    mkdir $HOME/ffserver_bak/nginx/
    cp /etc/nginx/sites-enabled/* $HOME/ffserver_bak/nginx/
    for cfg in $HOME/ffserver_bak/nginx/*;
    do
        if [ -f "$cfg" ]; then
            mv "$cfg" "${cfg}_$now.bak"
            echo "File $cfg found and deleted. Backup created."
        else
            echo "NO such file or directory $cfg"
        fi
    done
}

uninstallServer() {
    service 'findface*' stop
    service 'fkvideo*' stop
    service 'ntls' stop
    service 'nginx*' stop
    service 'tarantool*' stop
    service 'mongod*' stop

    backupCfg
    backupTntCfg
    backupNginxCfg

    apt-get -y purge $FF_PACKAGES

    # rm -rf /opt/ntech
    rm -rf /var/findface-repo

    # rm /etc/nginx/sites-available/ffupload
    rm /etc/nginx/sites-available/nnapi
    rm /etc/nginx/sites-available/ntls
    rm /etc/nginx/ntls.htpasswd

    # rm -rf /etc/tarantool/sites.available/FindFace*

    # rm -rf /var/lib/ffupload

    # rm -rf /usr/bin/mongo*
    # rm -rf /var/lib/mongodb/*

    # rm /etc/apt/sources.list.d/ntechlab.list
    # rm /etc/apt/sources.list.d/mongodb-org-*
    # apt-key del E2CADE97

    systemctl daemon-reload
    apt-get update

    service 'tarantool*' start
    service 'mongod*' start
}

uninstallAll() {
    service 'findface*' stop
    service 'fkvideo*' stop
    service 'ntls' stop
    service 'nginx*' stop
    service 'tarantool*' stop
    service 'mongod*' stop

    backupCfg
    backupTntCfg
    backupNginxCfg

    apt-get -y purge $ALL_PACKAGES

    rm -rf /opt/ntech
    rm -rf /var/findface-repo

    rm /etc/nginx/sites-available/ffupload
    rm /etc/nginx/sites-available/nnapi
    rm /etc/nginx/sites-available/ntls
    rm /etc/nginx/ntls.htpasswd

    rm -rf /etc/tarantool/sites.available/FindFace*

    rm -rf /var/lib/ffupload

    rm -rf /usr/bin/mongo*
    rm -rf /var/lib/mongodb/*

    rm /etc/apt/sources.list.d/ntechlab.list
    rm /etc/apt/sources.list.d/mongodb-org-*
    apt-key del E2CADE97

    systemctl daemon-reload
    apt-get update

}

while true; do
    read -p "
server  = uninstall server components. Faces and DB will be saved.
all     = uninstall all server components (include neural network) and wipe all saved faces.
no      = cancel operation.
Please select one

> " asc
    case $asc in
    server ) uninstallServer; break;;
    all ) uninstallAll; break;;
    no ) exit;;
        * ) echo "

############################
Please answer server/all/no.";;
    esac
done

echo "Done"
