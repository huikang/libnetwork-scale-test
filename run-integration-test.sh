#! /bin/bash
set -o xtrace

current_dir=`dirname $0`
source ${current_dir}/test-scripts/ci-function.sh

case "$EMULATION_TYPE" in
	"dnet")
		make
		test_dnet
		;;
	"swarmkit")
		echo "run swarmkit emulation"
		test_swarm
		;;
	*)
        exit 1
esac
