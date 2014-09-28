# copy plugin into plugin folder of nagios
sudo cp -i scripts/check_wifi_spectrum /usr/lib/nagios/plugins/check_wifi_spectrum
sudo chmod +x /usr/lib/nagios/plugins/check_wifi_spectrum

sudo mkdir /var/lib/nagios-wifi/ 2> /dev/null
sudo chown -R nagios:adm /var/lib/nagios-wifi/
sudo cp -i examples/empty_ap_database.db /var/lib/nagios-wifi/access_points.db
sudo chmod -R 770 /var/lib/nagios-wifi
echo "[OK] installation done...."
echo "... now fill database by running /usr/lib/nagios/plugins/check_wifi_spectrum -a as an user from the 'adm' group."
