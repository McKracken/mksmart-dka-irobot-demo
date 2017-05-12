#!/bin/bash

# source kmi_catkin workspace
source /home/ilaria/kmi_catkin_ws/devel/setup.bash
echo "setup.bash sourced"

# launch stage simulation (will open a new wiindow with the map)
xterm -e roslaunch kmi_navigation stage_kmi.launch &
echo "stage started"

sleep 3
#launch move_base
xterm -e roslaunch kmi_navigation move_base_kmi_simulated.launch &
echo "move_base started"
sleep 2

#start the robot server
nohup python /home/ilaria/kmi_catkin_ws/src/kmi_ros/dynamic_knowledge_acquisition/scripts/robot_server.py -w eduroam -p 8080 > robot_server.log &
echo "started the robot server (set up for eduroam / KBserverport 8080) "

sleep 2

# launch dka-server
cd /home/ilaria/workspace/dka-robo/server
nohup ./run.sh -l KB_partial_kmi_simulated.nq > server.log &
echo "dka-server started"

sleep 2

# set bot
./dka.sh setbot http://localhost:5000
echo "set bot at localhost:5000"

sleep 2

echo "Making random query"
./dka.sh query "select ?room ?wifiSignal where {graph ?expiryDateInMs {  ?room <http://data.open.ac.uk/kmi/robo/hasWiFiSignal> ?wifiSignal. } }"

echo "Yayyy :)"
