#! /bin/bash

pushd $1

SYSROOT=$2

mkdir -p engine-sdk/{data,lib,bin,lib/arm-linux-gnueabihf,usr/lib/arm-linux-gnueabihf,bin/clang_x64,usr/include,sdk/lib}

# 
# /data 
# 
cp icudtl.dat engine-sdk/data/

# 
# Include
# 
cp flutter_embedder.h engine-sdk/usr/include/

# 
# SDK
# 
cp -r flutter_patched_sdk engine-sdk/sdk/
if [ -e shader_lib ]; then
	cp -r shader_lib engine-sdk/sdk/lib
fi

# 
# /bin
# 
cp clang_x64/exe.unstripped/* engine-sdk/bin/clang_x64/

# 
# /lib
# 
export cwd=$(pwd)
cd so.unstripped
for file in *; do
    cp "$file" $cwd/engine-sdk/lib/
    cp "../$file.TOC" $cwd/engine-sdk/sdk/lib/
done
cd $cwd

# 
# ld-linux-*
# 
cp $SYSROOT/lib/ld-linux-armhf.so* engine-sdk/lib/

# 
# /usr/lib/$ARCH-linux-gnu
# 
cp $SYSROOT/lib/arm-linux-gnueabihf/libdl-* 				engine-sdk/lib/arm-linux-gnueabihf/
cp $SYSROOT/usr/lib/arm-linux-gnueabihf/libdl.so*			engine-sdk/usr/lib/arm-linux-gnueabihf/
cp -d $SYSROOT/lib/arm-linux-gnueabihf/libdl.so* 			engine-sdk/lib/arm-linux-gnueabihf/
cp -d $SYSROOT/usr/lib/arm-linux-gnueabihf/libdl-* 			engine-sdk/usr/lib/arm-linux-gnueabihf/
cp $SYSROOT/lib/arm-linux-gnueabihf/libpthread-* 			engine-sdk/lib/arm-linux-gnueabihf/
cp $SYSROOT/usr/lib/arm-linux-gnueabihf/libpthread-* 		engine-sdk/usr/lib/arm-linux-gnueabihf/
cp -d $SYSROOT/lib/arm-linux-gnueabihf/libpthread.so* 		engine-sdk/lib/arm-linux-gnueabihf/
cp -d $SYSROOT/usr/lib/arm-linux-gnueabihf/libpthread.so*	engine-sdk/usr/lib/arm-linux-gnueabihf/
cp $SYSROOT/lib/arm-linux-gnueabihf/libm-* 					engine-sdk/lib/arm-linux-gnueabihf/
cp $SYSROOT/usr/lib/arm-linux-gnueabihf/libm-* 				engine-sdk/usr/lib/arm-linux-gnueabihf/
cp -d $SYSROOT/lib/arm-linux-gnueabihf/libm.so* 			engine-sdk/lib/arm-linux-gnueabihf/
cp -d $SYSROOT/usr/lib/arm-linux-gnueabihf/libm.so*			engine-sdk/usr/lib/arm-linux-gnueabihf/
cp $SYSROOT/lib/arm-linux-gnueabihf/libc-* 					engine-sdk/lib/arm-linux-gnueabihf/
cp $SYSROOT/usr/lib/arm-linux-gnueabihf/libc-* 				engine-sdk/usr/lib/arm-linux-gnueabihf/
cp -d $SYSROOT/lib/arm-linux-gnueabihf/libc.so* 			engine-sdk/lib/arm-linux-gnueabihf/
cp -d $SYSROOT/usr/lib/arm-linux-gnueabihf/libc.so*			engine-sdk/usr/lib/arm-linux-gnueabihf/

# 
# Strip Components
# 
export CLANG_BIN_PATH=../../flutter/buildtools/linux-x64/clang/bin
mkdir -p .debug
for file in $(pwd)/engine-sdk/bin/clang_x64/*; do
	if [ -f "$file" ]; then
		$CLANG_BIN_PATH/llvm-strip --only-keep-debug -o $file.debug $file
		$CLANG_BIN_PATH/llvm-strip $file
	fi
done
mv $(pwd)/engine-sdk/bin/clang_x64/*.debug $(pwd)/.debug/
for file in $(pwd)/engine-sdk/lib/*; do
	if [ -f "$file" ]; then
		$CLANG_BIN_PATH/llvm-strip --only-keep-debug -o $file.debug $file
		$CLANG_BIN_PATH/llvm-strip $file
	fi
done
mv $(pwd)/engine-sdk/lib/*.debug $(pwd)/.debug/

popd
