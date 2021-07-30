#!/bin/sh

##### Config

use_xTeveAPI="no"
use_xTeveRP="no"
use_TVH_Play="no"
use_TVH_xml="no"
use_TVH_move="no"


### xTeve ip, Port in case API is used to update XEPG
xTeveIP="192.168.1.2"
xTevePORT="34400"

### setup rewrite rule für Reverse Proxy https xml usage
# the rewritten url will be then http://yourxtevedomain.de/xmltv/xteverp.xml
xtevelocal="http://192.168.1.2:34400"
xteveRP="https://xteve.mydomain.de"
xtevelocalfile="/root/.xteve/data/xteve.xml"
xteveRPfile="/root/.xteve/data/xteverp.xml"
# if wished, a ready RP m3u file generator, url will be http://yourxtevedomain.de/xmltv/xteverp.m3u
xtevelocalm3ufile="/root/.xteve/data/xteve.m3u"
xteveRPm3ufile="/root/.xteve/data/xteverp.m3u"

### TVHeadend ip, Port in case m3u Playlist is wanted
TVHIP="192.168.1.2"
TVHPORT="9981"
TVHUSER="username"
TVHPASS="password"
TVHOUT="/root/.xteve/data/channels.m3u"
## TVHeadend xml as source in case wanted ### Disable TVH_move caue senseless and looping epg ...
TVHXML="/root/.xteve/data/tvhguide.xml"

### Copy a final xml (sample xteve) to tvheadend Data ### u have to mount TVHPATH data dir
TVHSOURCE="/root/.xteve/data/xteve.xml"
TVHPATH="/TVH"

# cronjob, check sample_cron.txt with an editor to adjust time

### END Config
##
#

# get TVH playlist
if [ "$use_TVH_Play" = "yes" ]; then
	if [ -z "$TVHIP" ]; then
		echo "no TVHeadend credentials"
	else
		if [ -z "$TVHUSER" ]; then
			wget -O $TVHOUT http://$TVHIP:$TVHPORT/playlist
		else
			wget -O $TVHOUT http://$TVHUSER:$TVHPASS@$TVHIP:$TVHPORT/playlist
		fi
	fi
fi

sleep 1

# get TVH xml
if [ "$use_TVH_xml" = "yes" ]; then
	if [ -z "$TVHIP" ]; then
		echo "no TVHeadend credentials"
	else
		if [ -z "$TVHUSER" ]; then
			wget -O $TVHXML http://$TVHIP:$TVHPORT/xmltv
		else
			wget -O $TVHXML http://$TVHUSER:$TVHPASS@$TVHIP:$TVHPORT/xmltv
		fi
	fi
fi

sleep 1

# update xteve via API
if [ "$use_xTeveAPI" = "yes" ]; then
	if [ -z "$xTeveIP" ]; then
		echo "no xTeve credentials"
	else
		curl -X POST -d '{"cmd":"update.xmltv"}' http://$xTeveIP:$xTevePORT/api/
		sleep 1
		curl -X POST -d '{"cmd":"update.xepg"}' http://$xTeveIP:$xTevePORT/api/
		sleep 1
	fi
fi

# create rewritten xml and m3u file
if [ "$use_xTeveRP" = "yes" ]; then
	if [ -z "$xteveRPfile" ]; then
		echo "no Path credential"
	else
		sleep 10
		cp $xtevelocalfile $xteveRPfile
		sed -i "s;$xtevelocal;$xteveRP;g" $xteveRPfile
		sleep 2
		gzip -kf $xteveRPfile
	fi
	if [ -z "$xteveRPm3ufile" ]; then
		echo "no Path credential"
	else
		cp $xtevelocalm3ufile $xteveRPm3ufile
		sed -i "s;$xtevelocal;$xteveRP;g" $xteveRPm3ufile
	fi
fi

# copy file to TVHeadend
if [ "$use_TVH_move" = "yes" ]; then
	if [ -z "$TVHPATH" ]; then
		echo "no Path credential"
	else
		cp $TVHSOURCE $TVHPATH/guide.xml
	fi
fi

exit
