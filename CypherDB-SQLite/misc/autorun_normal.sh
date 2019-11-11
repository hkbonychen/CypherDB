#!/bin/bash

#uSS
echo uSS
for i in $(seq 1 6)
do
./sqlite3.16.4_O2 /SDCMSC/tpch100MB_uSS_uNJ.db "select distinct(l_quantity) from lineitem where l_partkey >= 2000 and l_partkey <= 6000 order by l_quantity;"
free && sync && echo 3 > /proc/sys/vm/drop_caches && free
done

#uNJ
echo uNJ
for i in $(seq 1 6)
do
./sqlite3.16.4_O2 /SDCMSC/tpch100MB_uSS_uNJ.db "select avg(l_linenumber) from lineitem, orders where l_orderkey = o_orderkey and l_partkey>=2000 and l_partkey<=6000;"
free && sync && echo 3 > /proc/sys/vm/drop_caches && free
done

#uIDX
echo uIDX
for i in $(seq 1 6)
do
./sqlite3.16.4_O2 /SDCMSC/tpch100MB.db "select avg(l_linenumber) from lineitem where l_partkey >= 2000 and l_partkey <= 6000;"
free && sync && echo 3 > /proc/sys/vm/drop_caches && free
done
