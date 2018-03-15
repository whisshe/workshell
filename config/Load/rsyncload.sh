#!/bin/bash
for A in apia apix gamea gameb gamec gamed servicea www dba dbb
do 
rsync -avu /home/deploy/config_dep/Load/load.sh root@$A:/tmp/  
done
ansible -i host -u root host -m shell -a "nohup /tmp/load.sh stop &"  
ansible -i host -u root host -m shell -a "nohup /tmp/load.sh start &"  
