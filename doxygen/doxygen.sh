#!/bin/bash

pwd;

env;

echo "-------- source setup ---------"
source /opt/sphenix/core/bin/sphenix_setup.sh -n

env;

echo "doxygen at " `which doxygen`
echo "dot at " `which dot`


echo "-------- Doxyfile additional setup ---------"
echo "CVS_STRIP_FROM_PATH = " `pwd` | tee -a Doxyfile
echo "INPUT                  = " `/bin/ls -d */` | tee -a Doxyfile

echo "-------- start doxygen ---------"
doxygen Doxyfile >& doxygen.log

