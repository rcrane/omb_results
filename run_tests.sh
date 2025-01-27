#!/bin/bash

for i in {1..10}
do
	for WL in TC01 TC02 TC03 TC04 TC05 TC06 TC06 TC08 TC09 TC10 TC11 TC12
	do
		docker run --rm -it --network=host -v ${PWD}/omb/native/:/results omb_native /bin/sh -c "sh ./bin/benchmark workloads/neardata/$WL.yaml --drivers driver-pravega/pravega.yaml && cp /openmessaging-benchmark-0.0.1-SNAPSHOT/*.json /results/"
	done
done



