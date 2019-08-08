# Updateclient for the DynDNS Host ddnss.de

This client is at this moment only for Dualstack. <br />
It updates IPv4 and IPv6 simultaneously.


## Usage


Set **HOSTNAME** to your Hostname which you want to update. <br />
If you want to update more than one with the same ip, then <br />
`HOSTNAME="host1,host2"`


Set **CLIENTKEY** to your Update-Key


Now make your script executable <br />
`chmod +x dynupdate.sh`


The Script has no Daemon. You have to put it in your e.g. cronfile <br />
`crontab -e`


I run this Script every 5 Minutes <br />
`*/5 * * * * /<folder where you save it>/dynupdate.sh`
