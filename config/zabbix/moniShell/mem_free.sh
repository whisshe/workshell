#!/bin/bash
#监控内存使用剩余
free -m |awk 'NR==2{print $4}'
