#!/bin/bash

EXE=cli/epi2me-cli
EXE=../data/epi2me-cli
red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`

OK="$green OK $reset"
FAIL="$red FAIL $reset"

function run_test() {
    cmd="$EXE $2"
    output=`$cmd 2>&1`
    if [[ $output = *"$3"* ]]; then
        result=$OK
    else
        echo "CMD: $cmd"
        result=$FAIL
        echo "$red[ $output ]$reset"
        echo "expected : $3"
    fi
    echo "* $1 : $result"  
}

run_test "version" "-v" "API version 3.0.0"
run_test "help" "-h" "Example Usage"
run_test "accounts" "--useraccounts" "10771562"
run_test "mcdemo profile" "--profile mcdemo --useraccounts" "13040972"
run_test "apikey" "--useraccounts --apikey 5cd6e79e5e17f7fef141097afb7eb0da169ea074" "13040972"
run_test "list workflows for mcdemo" "--profile mcdemo -l" "Fastq Connection Test"
run_test "list workflows for admin" "-l" "Fastq Ecoli Alignment"
run_test "profiles" "--profiles" "mcdemo"
run_test "describe ref upload" "--describe 1714" "epi2me:category: reference,storage"
run_test "describe custom align" "--describe 1667" "Label: ecoli HUSEC2011"
run_test "accounts check" "--profile mcdemo -w 1715" "valid billing account"
run_test "consent" "--profile mcdemo -w 1656 --billing 13040972" "Is the data a whole or partial human genome"
run_test "aggregated telemetry" "--profile mcdemo -t --instance 180227 --workflow 1692" "180227-1692.json"

