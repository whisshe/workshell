#!/bin/bash

rsync -avu --delete root@dba:/etc/mysql/ mysql/
rsync -avu --delete root@dbb:/etc/mysql/ mysqlslave/
rsync -avu --delete root@apia:/etc/nginx/ nginx/
rsync -avu --delete root@apia:/etc/php5/ php5/

cp /home/git/.ssh/authorized_keys .
