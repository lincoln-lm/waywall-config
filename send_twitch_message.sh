#!/bin/bash

TOKEN_PATH=$1
MESSAGE="$2"

{
    echo "PASS $(cat $TOKEN_PATH)"
    echo "NICK lincoln_lm"
    echo "JOIN #lincoln_lm"
    echo "PRIVMSG #lincoln_lm :$MESSAGE"
} | nc -N "irc.chat.twitch.tv" 6667
