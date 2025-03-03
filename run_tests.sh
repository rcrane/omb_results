#!/bin/bash


for i in {1..10}
do
	#for WL in TC01 TC02 TC03 TC04 TC05 TC06 TC07 TC08 TC09 TC10 TC11 TC12 TC13 TC14 TC15
	for WL in TC31 TC32 TC33 TC34 TC35 TC36 TC37 TC38 TC39 TC40 TC41 TC42 TC43 TC44 TC45
	do
		pgrep -f "kubectl port-forward" | xargs --no-run-if-empty kill
		kubectl port-forward service/pravega-pravega-controller -n neardata2 9090 &
		#docker run --rm -it --network=host -v ${PWD}/omb/native/:/results omb_native /bin/sh -c "sh ./bin/benchmark workloads/neardata/$WL.yaml --drivers driver-pravega/pravega.yaml && cp /openmessaging-benchmark-0.0.1-SNAPSHOT/*.json /results/"
		docker run --rm -it --network=host -v ${PWD}/prb/native/:/results prb_native /bin/bash -c "./target/release/pravega-rust-benchmark workloads/$WL.yaml && cp /prb/result*.json /results/"
		sleep 5
		pgrep -f "kubectl port-forward" | xargs --no-run-if-empty kill
	done
done



