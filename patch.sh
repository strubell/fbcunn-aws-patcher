#!/bin/bash

FBCUNN_DIR=$1
PATCH_DIR=`pwd`

if [ ! $# -eq 1 ]; then
  echo Usage: `basename $0` /path/to/fbcunn
  echo
  exit
fi

cd $FBCUNN_DIR

# build against $CUDA_CC compute capability
sed -i 's/sm_35/sm_30/' CMakeLists.txt

# the functions we need to patch
funcs="shfl ldg"

# add patch include at end of list of includes to ensure that it comes after <cuda_runtime.h>
for func in $funcs; do
  for file in `cat $PATCH_DIR/${func}_files`; do
    awk -v var=$func \
    'BEGIN {c=1;} a=/(^#include)|(^$)/{b=1}b&&c&&!a{print "#include <generics/"var".h>\n";c=0}1' \
    $file > $file.tmp
    mv $file.tmp $file
  done
done


