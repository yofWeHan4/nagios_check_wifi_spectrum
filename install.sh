############################################
# copy plugin into plugin folder of nagios #
############################################

DEFAULT=/usr/lib/nagios/plugins/
echo "What is the location of the nagios plugin folder? [${DEFAULT}]:"
read ANSWER
case "$ANSWER" in
 "") ANSWER=$DEFAULT;;
esac
sudo cp -i scripts/check_wifi_spectrum $ANSWER/check_wifi_spectrum && sudo chmod +x $ANSWER/check_wifi_spectrum
if [ $? -eq 0 ]
then
	echo "[OK] Copy the nagios script to ${ANSWER}"
else
	echo "[ERROR] Copy the nagios script to ${ANSWER}"
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
sudo cp -i config/check_wifi_spectrum.cfg $ANSWER
if [ $? -eq 0 ]
then
	echo "[OK] Copy the plugin configuration to ${ANSWER}"
else
	echo "[ERROR] Copy the plugin configuration to ${ANSWER}"
	exit 1
fi
echo

##################################
# location of the wifi databases #
##################################

DEFAULT=/var/lib/nagios-wifi/
echo "Location of the wifi databases (will be created)? [${DEFAULT}]:"
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
sudo cp -i examples/empty_ap_database.db $ANSWER/access_points.db
if [ $? -eq 0 ]
then
	echo "[OK] Create empty database for access points"
else
	echo "[ERROR] Could not create database file"
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
ls $ANSWER
sudo ls $ANSWER
if [ $? -eq 0 ]
then
	echo "[OK] ${ANSWER} exists"
else
	echo "[ERROR] Could not find ${ANSWER}, please install or provide with correct details"
	exit 1
fi
echo

########
# DONE #
########

echo "[DONE] installation done"
echo 
echo "If you want to fill the database, run:"
echo "sudo /usr/lib/nagios/plugins/check_wifi_spectrum -a <time_you_want_to_scan_in_sec>"
