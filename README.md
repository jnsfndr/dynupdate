# Updateclient for the DynDNS Host ddnss.de

This client can update v4 and v6 <br />
It can update v4 and v6 simultaneously.


## Usage


Set **HOSTNAME** to your Hostname which you want to update. <br />
If you want to update more than one with the same ip, then <br />
`HOSTNAME="host1,host2"` <br />


Set **CLIENTKEY** to your Update-Key <br />

If you want to update IPv4 **AND** IPv6, then let the values be true. <br />
Change the values to false if you only want to change one IP. <br />


Now make your script executable <br />
`chmod +x dynupdate.sh`


The Script has no Daemon. You have to put it in your e.g. cronfile <br />
`crontab -e`


I run this Script every 5 Minutes <br />
`*/5 * * * * /<folder where you save it>/dynupdate.sh`
