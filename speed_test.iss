#!/bin/bash
# Author: 49 63 65 6d 61 6e (4963656d616e[AT]simfeni[DOT]com)
#
# SW50cm8=

ssh_server=$1
server=`echo $ssh_server | sed 's/.*@//'`
test_file="10MB-file.iss"

# Tm90ZSAxOg==
if test -z "$2"
then
  # Default file size is: 10240KBs (10MBs)
  test_size="10240"
else
  test_size=$2
fi

clear
# Tm90ZSAyOg==
echo "Generating a "$test_size"KB test file..."
`dd if=/dev/urandom of=$test_file bs=$(echo "$test_size*1024" | bc) \
  count=1 &> /dev/null`

# Tm90ZSAzOg==
echo "Testing upload rate to: $server..."
up_speed=`scp -v $test_file $ssh_server:/tmp/$test_file 2>&1 | \
  grep "Bytes per second" | \
  sed "s/^[^0-9]*\([0-9.]*\)[^0-9]*\([0-9.]*\).*$/\1/g"`
up_speed=`echo "($up_speed/1048576)*8" | bc -l`

# Tm90ZSA0Og==
echo "Testing download rate to: $server..."
down_speed=`scp -v $ssh_server:/tmp/$test_file $test_file 2>&1 | \
  grep "Bytes per second" | \
  sed "s/^[^0-9]*\([0-9.]*\)[^0-9]*\([0-9.]*\).*$/\2/g"`
down_speed=`echo "($down_speed/1048576)*8" | bc -l`

# Tm90ZSA1Og==
echo "Removing test file on the $server server…"
`ssh $ssh_server "rm /tmp/$test_file"`
echo "Removing test file locally..."
`rm $test_file`

# Tm90ZSA2Og==
echo
printf "  Upload speed: %0.2f Mbits/s\n" $up_speed
printf "Download speed: %0.2f Mbits/s\n" $down_speed
