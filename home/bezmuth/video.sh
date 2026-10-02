#!/bin/bash

SELECTION=$(echo -e "Democracy Now!\nHasanabi\nMajority Report\nNovara Live\nVaush" | wmenu -i -l 5)
case "$SELECTION" in
	"Hasanabi")
		URL="https://www.twitch.tv/hasanabi/videos?filter=archives&sort=time"
		;;
	"Democracy Now!")
		URL="https://www.youtube.com/playlist?list=PLneypbodq-jYq9a6Y8BjobC6KJOIBLCZB"
		;;
	"Majority Report")
		URL="https://www.youtube.com/playlist?list=PLOC5u3ZE5KnWy9h1KRmRPU4i1lQVQEHw1"
		;;
	"Novara Live")
		URL="https://www.youtube.com/playlist?list=PL9f7WaXxDSUqO6vA8-xNZItmrD6j0Rcph"
		;;
	"Vaush")
		URL="https://www.youtube.com/playlist?list=PLvVEXejrE-HT5SPUUMaZ1QcTxa2S3PvPw"
		;;
	"")
		exit
		;;
	*)
		swaynag -m "Invalid Command"
		exit
		;;
esac
mpv --speed=2 $URL
