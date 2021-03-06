#!/bin/bash
set -eux
#/home/fei/git/smr-ssd-cache_multi-user2/src/smr-ssd-cache 0 0 1 0 0 24795 4941 1 1 > /home/outputs/battle_lru.l &
#./smr-ssd-cache 0 0 1 0 0 24795 4941 0 1 > /home/outputs/battle_pore+.l &

./create.sh
make clean
make
./prepare.sh 4

cgexec -g "blkio:fo2" ./smr-ssd-cache 100000 25000 5 /tmp/fifo_user2_r /tmp/fifo_user2_w 2 > /tmp/test3_user2.txt &
iotop -b -p $! > /tmp/test3_iotop_usr2.txt &
cgexec -g "blkio:fo3" ./smr-ssd-cache 100000 25000 3 /tmp/fifo_user3_r /tmp/fifo_user3_w 3 > /tmp/test3_user3.txt &
iotop -b -p $! > /tmp/test3_iotop_usr3.txt &
cgexec -g "blkio:fo4" ./smr-ssd-cache 100000 25000 4 /tmp/fifo_user0_r /tmp/fifo_user0_w 0 > /tmp/test3_user0.txt &
iotop -b -p $! > /tmp/test3_iotop_usr0.txt &
cgexec -g "blkio:fo1" ./smr-ssd-cache 100000 25000 1 /tmp/fifo_user1_r /tmp/fifo_user1_w 1 > /tmp/test3_user1.txt &
iotop -b -p $! > /tmp/test3_iotop_usr1.txt &

sleep 20

./throttler > /tmp/test3_throttler.txt &
thro_pid=$!

while true
do
        ps -a | grep "smr"
        if [ $? -eq 1 ]
        then
            kill thro_pid
        else
            sleep 10s
        fi
done

wait


./create.sh

make clean
make
./prepare.sh 4

cgexec -g "blkio:fo2" ./smr-ssd-cache 100000 25000 5 /tmp/fifo_user2_r /tmp/fifo_user2_w 2 > /tmp/test3_user2_equal.txt &
iotop -b -p $! > /tmp/test3_iotop_usr2_equal.txt &
cgexec -g "blkio:fo3" ./smr-ssd-cache 100000 25000 3 /tmp/fifo_user3_r /tmp/fifo_user3_w 3 > /tmp/test3_user3_equal.txt &
iotop -b -p $! > /tmp/test3_iotop_usr3_equal.txt &
cgexec -g "blkio:fo4" ./smr-ssd-cache 100000 25000 4 /tmp/fifo_user0_r /tmp/fifo_user0_w 0 > /tmp/test3_user0_equal.txt &
iotop -b -p $! > /tmp/test3_iotop_usr0_equal.txt &
cgexec -g "blkio:fo1" ./smr-ssd-cache 100000 25000 1 /tmp/fifo_user1_r /tmp/fifo_user1_w 1 > /tmp/test3_user1_equal.txt &
iotop -b -p $! > /tmp/test3_iotop_user1_equal.txt &

wait


./create.sh
make clean
make
./prepare.sh 4

cgexec -g "blkio:fo2" ./smr-ssd-cache 100000 25000 2 /tmp/fifo_user2_r /tmp/fifo_user2_w 2 > /tmp/test4_user2.txt &
iotop -b -p $! > /tmp/test4_iotop_usr2.txt &
cgexec -g "blkio:fo3" ./smr-ssd-cache 100000 25000 1 /tmp/fifo_user3_r /tmp/fifo_user3_w 3 > /tmp/test4_user3.txt &
iotop -b -p $! > /tmp/test4_iotop_usr3.txt &
cgexec -g "blkio:fo4" ./smr-ssd-cache 100000 25000 0 /tmp/fifo_user0_r /tmp/fifo_user0_w 0 > /tmp/test4_user0.txt &
iotop -b -p $! > /tmp/test4_iotop_usr0.txt &
cgexec -g "blkio:fo1" ./smr-ssd-cache 100000 25000 5 /tmp/fifo_user1_r /tmp/fifo_user1_w 1 > /tmp/test4_user1.txt &
iotop -b -p $! > /tmp/test4_iotop_usr1.txt &

sleep 20
./throttler > /tmp/test4_throttler.txt &
thro_pid=$!

while true
do
        ps -a | grep "smr"
        if [ $? -eq 1 ]
        then
            kill thro_pid
        else
            sleep 10s
        fi
done

wait


./create.sh
make clean
make
./prepare.sh 4

cgexec -g "blkio:fo2" ./smr-ssd-cache 100000 25000 2 /tmp/fifo_user2_r /tmp/fifo_user2_w 2 > /tmp/test4_user2_equal.txt &
iotop -b -p $! > /tmp/test4_iotop_usr2_equal.txt &
cgexec -g "blkio:fo3" ./smr-ssd-cache 100000 25000 1 /tmp/fifo_user3_r /tmp/fifo_user3_w 3 > /tmp/test4_user3_equal.txt &
iotop -b -p $! > /tmp/test4_iotop_usr3_equal.txt &
cgexec -g "blkio:fo4" ./smr-ssd-cache 100000 25000 0 /tmp/fifo_user0_r /tmp/fifo_user0_w 0 > /tmp/test4_user0_equal.txt &
iotop -b -p $! > /tmp/test4_iotop_usr0_equal.txt &
cgexec -g "blkio:fo1" ./smr-ssd-cache 100000 25000 5 /tmp/fifo_user1_r /tmp/fifo_user1_w 1 > /tmp/test4_user1_equal.txt &
iotop -b -p $! > /tmp/test4_iotop_usr1_equal.txt &
wait
