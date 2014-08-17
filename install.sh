sudo cp scripts/check_wifi_spectrum /usr/lib/nagios/plugins/check_wifi_spectrum
sudo chmod +x /usr/lib/nagios/plugins/check_wifi_spectrum
sudo mkdir /var/log/wifi/ 2> /dev/null
sudo chown -R nagios:adm /var/log/wifi/
sudo cp -i examples/empty_ap_database.db /var/log/wifi/access_points.db
sudo chmod -R 770 /var/log/wifi
sudo mkdir /etc/nagios-wifi/ 2> /dev/null
sudo cp config/wifi_scan.cfg /etc/nagios-wifi/
sudo cp config/check_wifi_spectrum.cfg /etc/nagios-plugins/config/
echo "[OK] installation done...."
echo "... now fill database by running /usr/lib/nagios/plugins/check_wifi_spectrum -a as a user from the 'adm' group."
