#!/bin/bash

if [ "$OS" = "Windows_NT" ]; then
    ./mingw64.sh
    exit 0
fi

# Linux build

make clean || echo clean

rm -f config.status
./autogen.sh || echo done

# Ubuntu 10.04 (gcc 4.4)
extracflags="-O3 -march=native -w -D_REENTRANT -funroll-loops -fvariable-expansion-in-unroller -fmerge-all-constants -fbranch-target-load-optimize2 -fsched2-use-superblocks -falign-loops=16 -falign-functions=16 -falign-jumps=16 -falign-labels=16"

# Debian 7.7 / Ubuntu 14.04 (gcc 4.7+)
extracflags="$extracflags -Ofast -fuse-linker-plugin -ftree-loop-if-convert-stores"

if [ ! "0" = `cat /proc/cpuinfo | grep -c avx` ]; then
    # march native doesn't always works, ex. some Pentium Gxxx (no avx)
    extracflags="$extracflags -march=native"
fi


# Intel(R) Xeon(R) CPU E5-2676 v3 @ 2.40GHz 4 threads (d2.xlarge)


#309-310
#CFLAGS="-O3 $extracflags -flto -march=native -DUSE_ASM -pg" ./configure --with-crypto --with-curl

#311-312
CFLAGS="-O3 $extracflags -flto -march=native -DUSE_ASM -pg" CXXFLAGS="-std=gnu++11" ./configure --with-crypto --with-curl

#281
#CFLAGS="-O3 $extracflags -flto -march=native -DUSE_ASM -pg" CXXFLAGS="$CFLAGS" ./configure --with-crypto --with-curl

#280
#CFLAGS="-O3 $extracflags -flto -march=native -DUSE_ASM -pg" CXXFLAGS="$CFLAGS -std=gnu++11" ./configure --with-crypto --with-curl


#269
#CFLAGS="-O3 $extracflags -march=native -DUSE_ASM -pg" ./configure --with-crypto --with-curl

#264
#CFLAGS="-O3 $extracflags -march=native -DUSE_ASM -pg" CXXFLAGS="-std=gnu++11" ./configure --with-crypto --with-curl

#242
#CFLAGS="-O3 $extracflags -march=native -DUSE_ASM -pg" CXXFLAGS="$CFLAGS" ./configure --with-crypto --with-curl

#245
#CFLAGS="-O3 $extracflags -march=native -DUSE_ASM -pg" CXXFLAGS="$CFLAGS -std=gnu++11" ./configure --with-crypto --with-curl


make -j $(grep processor /proc/cpuinfo | wc -l)

strip -s cpuminer
