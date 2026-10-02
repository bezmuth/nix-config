#!/bin/bash

SELECTION=$(echo -e "24/7 LoFi\nBBC Radio 3\nBBC World Service\nAdroit Jazz Underground\nLainchan\nStop Playback" | wmenu -i -l 6)
case "$SELECTION" in
	"24/7 LoFi")
		playerctl -p mpv stop
		URL="http://usa9.fastcast4u.com/proxy/jamz?mp=/1"
		;;
	"BBC Radio 3")
		playerctl -p mpv stop
		URL="http://as-hls-ww-live.akamaized.net/pool_23461179/live/ww/bbc_radio_three/bbc_radio_three.isml/bbc_radio_three-audio%3d128000.norewind.m3u8"
		;;
	"BBC World Service")
		playerctl -p mpv stop
		URL="http://stream.live.vc.bbcmedia.co.uk/bbc_world_service"
		;;
	"Adroit Jazz Underground")
		playerctl -p mpv stop
		URL="https://icecast.walmradio.com:8443/jazz_opus"
		;;
	"Lainchan")
		playerctl -p mpv stop
		URL="https://radio.lainchan.org/listen/lainchan_radio_main/radio.mp3.m3u"
		;;
	"Stop Playback")
		playerctl -p mpv stop
		exit
		;;
	"")
		exit
		;;
	*)
		swaynag -m "Invalid Command"
		exit
		;;
esac
mpv -- $URL
