######################################
#                                    #
#           DEFAULT VALUES           #
#                                    #
######################################


DEFAULT_INTERFACE="wlan0"
DEFAULT_DATABASE_PATH="/var/lib/nagios-wifi"



################################
# preferable network interface #
################################

DEFAULT=$DEFAULT_INTERFACE
echo "What is the network interface that is used for scanning? [${DEFAULT}]:"
read ANSWER
case "$ANSWER" in
 "") ANSWER=$DEFAULT;;
esac
INTERFACE=$ANSWER

##################################
# location of the wifi databases #
##################################

DEFAULT=$DEFAULT_DATABASE_PATH
echo "Location of the wifi databases (that will be created)? [${DEFAULT}]:"
read ANSWER
case "$ANSWER" in
 "") ANSWER=$DEFAULT;;
esac
sudo mkdir -p $ANSWER 2> /dev/null 
sudo chown -R nagios:adm $ANSWER && sudo chmod -R 770 $ANSWER
if [ $? -eq 0 ]
then
	echo "[OK] Create lib folder for database in ${ANSWER}"
else
	echo "[ERROR] Create lib folder for database in ${ANSWER}"
	exit 1
fi
echo
DATABASE=$ANSWER/access_points.db
sudo cp -i examples/empty_ap_database.db $DATABASE
if [ $? -eq 0 ]
then
	echo "[OK] Create empty database for access points"
else
	echo "[ERROR] Could not create database file"
	exit 1
fi
echo

###############################################
# copy config file into the correct directory #
###############################################

DEFAULT=/etc/nagios-plugins/config/
echo "Where is the config directory of the nagios plugins? [${DEFAULT}]:"
read ANSWER
case "$ANSWER" in
 "") ANSWER=$DEFAULT;;
esac
CONFIG=$ANSWER/check_wifi_spectrum.cfg
sudo cp -i config/check_wifi_spectrum.cfg $CONFIG && \
	sudo sed -i -e 's|DATABASE|'$DATABASE'|' $CONFIG &&\
	sudo sed -i -e 's|INTERFACE|'$INTERFACE'|' $CONFIG
if [ $? -eq 0 ]
then
	echo "[OK] Copy the plugin configuration to ${ANSWER}"
else
	echo "[ERROR] Copy the plugin configuration to ${ANSWER}"
	exit 1
fi
echo

############################################
# copy plugin into plugin folder of nagios #
############################################

DEFAULT=/usr/lib/nagios/plugins
echo "What is the location of the nagios plugin folder? [${DEFAULT}]:"
read ANSWER
case "$ANSWER" in
 "") ANSWER=$DEFAULT;;
esac
sudo cp -i scripts/check_wifi_spectrum $ANSWER/check_wifi_spectrum && sudo chmod +x ${ANSWER}/check_wifi_spectrum
if [ $? -eq 0 ]
then
        echo "[OK] Copy the nagios script to ${ANSWER}"
else
        echo "[ERROR] Copy the nagios script to ${ANSWER}"
        exit 1
fi
echo

#######################
# Location of sqlite3 #
#######################

DEFAULT=/usr/bin/sqlite3
echo "What is the location of the sqlite3 binary? [${DEFAULT}]:"
read ANSWER
case "$ANSWER" in
 "") ANSWER=$DEFAULT;;
esac
ls $ANSWER
if [ $? -eq 0 ]
then
	echo "[OK] ${ANSWER} exists"
else
	echo "[ERROR] ${ANSWER} does not exists, please install or provide with correct details"
	exit 1
fi
echo

######################
# Location of iwlist #
######################

DEFAULT=/sbin/iwlist
echo "What is the location of the iwlist binary? [${DEFAULT}]:"
read ANSWER 
case "$ANSWER" in
 "") ANSWER=$DEFAULT;;
esac 
sudo ls $ANSWER
if [ $? -eq 0 ]
then
	echo "[OK] ${ANSWER} exists"
else
	echo "[ERROR] Could not find ${ANSWER}, please install or provide with correct details"
	exit 1
fi
echo

#################
# Fill database #
#################

DEFAULT=300
echo "Start scanning for a period of time, the longer this period is, the better the initial db"
echo "How long do we scan right now? [${DEFAULT}]:"
read ANSWER
case "$ANSWER" in
 "") ANSWER=$DEFAULT;;
esac
sudo scripts/check_wifi_spectrum -a $ANSWER -d $DATABASE
if [ $? -eq 0 ]
then
        echo "[OK] ${ANSWER} everything seems ok"
else
        echo "[ERROR] problems found, please check manually"
        exit 1
fi
echo

########
# DONE #
########

echo "[DONE] installation done"
echo 
echo "If you want to fill the database even more, run:"
echo "sudo /usr/lib/nagios/plugins/check_wifi_spectrum -a <time_you_want_to_scan_in_sec>"
echo
echo "--> IMPORTANT! configure the sudoers file in a way that nagios can run the iwlist command without password"
echo "--> IMPORTANT! otherwise the deamon will not be able to run the command"
