#!/bin/bash
#
#-md4            to use the md4 message digest algorithm
#-md5            to use the md5 message digest algorithm
#-ripemd160      to use the ripemd160 message digest algorithm
#-sha            to use the sha message digest algorithm
#-sha1           to use the sha1 message digest algorithm
#-sha224         to use the sha224 message digest algorithm
#-sha256         to use the sha256 message digest algorithm
#-sha384         to use the sha384 message digest algorithm
#-sha512         to use the sha512 message digest algorithm
#-whirlpool      to use the whirlpool message digest algorithm
#
#Hash an input file with all openssl digest algorithims.

if [ $# -eq 0 ]
then
    echo "Missing required input file"
    echo "Usage: $(basename $0) <file name>"
    exit 255
fi

INFILE=$1
ALGO=( -md4 -md5 -ripemd160 -sha -sha1 -sha224 -sha256 -sha384 -sha512 -whirlpool )


for (( i=0; i < ${#ALGO[*]}; i++ )) 
do
    openssl dgst ${ALGO[$i]} $INFILE
done
