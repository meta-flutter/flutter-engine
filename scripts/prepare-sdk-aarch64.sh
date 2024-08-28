#! /bin/bash

mkdir -p engine-sdk/{data,bin,lib/aarch64-linux-gnu,usr/lib/aarch64-linux-gnu,usr/include,sdk/lib}

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
cp exe.unstripped/* engine-sdk/bin/

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
cp $SYSROOT/lib/ld-linux-aarch64.so* engine-sdk/lib/

# 
# /usr/lib/$ARCH-linux-gnu
# 
cp $SYSROOT/lib/aarch64-linux-gnu/libdl-* 				engine-sdk/lib/aarch64-linux-gnu/
cp $SYSROOT/usr/lib/aarch64-linux-gnu/libdl.so*			engine-sdk/usr/lib/aarch64-linux-gnu/
cp -d $SYSROOT/lib/aarch64-linux-gnu/libdl.so* 			engine-sdk/lib/aarch64-linux-gnu/
cp -d $SYSROOT/usr/lib/aarch64-linux-gnu/libdl-* 		engine-sdk/usr/lib/aarch64-linux-gnu/
cp $SYSROOT/lib/aarch64-linux-gnu/libpthread-* 			engine-sdk/lib/aarch64-linux-gnu/
cp $SYSROOT/usr/lib/aarch64-linux-gnu/libpthread-* 		engine-sdk/usr/lib/aarch64-linux-gnu/
cp -d $SYSROOT/lib/aarch64-linux-gnu/libpthread.so* 	engine-sdk/lib/aarch64-linux-gnu/
cp -d $SYSROOT/usr/lib/aarch64-linux-gnu/libpthread.so*	engine-sdk/usr/lib/aarch64-linux-gnu/
cp $SYSROOT/lib/aarch64-linux-gnu/libm-* 				engine-sdk/lib/aarch64-linux-gnu/
cp $SYSROOT/usr/lib/aarch64-linux-gnu/libm-* 			engine-sdk/usr/lib/aarch64-linux-gnu/
cp -d $SYSROOT/lib/aarch64-linux-gnu/libm.so* 			engine-sdk/lib/aarch64-linux-gnu/
cp -d $SYSROOT/usr/lib/aarch64-linux-gnu/libm.so*		engine-sdk/usr/lib/aarch64-linux-gnu/
cp $SYSROOT/lib/aarch64-linux-gnu/libc-* 				engine-sdk/lib/aarch64-linux-gnu/
cp $SYSROOT/usr/lib/aarch64-linux-gnu/libc-* 			engine-sdk/usr/lib/aarch64-linux-gnu/
cp -d $SYSROOT/lib/aarch64-linux-gnu/libc.so* 			engine-sdk/lib/aarch64-linux-gnu/
cp -d $SYSROOT/usr/lib/aarch64-linux-gnu/libc.so*		engine-sdk/usr/lib/aarch64-linux-gnu/

# 
# Strip Components
# 
export CLANG_BIN_PATH=../../flutter/buildtools/linux-x64/clang/bin
mkdir -p .debug
for file in $(pwd)/engine-sdk/bin/*; do
	if [ -f "$file" ]; then
		$CLANG_BIN_PATH/llvm-strip --only-keep-debug -o $file.debug $file
		$CLANG_BIN_PATH/llvm-strip $file
	fi
done
mv $(pwd)/engine-sdk/bin/*.debug $(pwd)/.debug/
for file in $(pwd)/engine-sdk/lib/*; do
	if [ -f "$file" ]; then
		$CLANG_BIN_PATH/llvm-strip --only-keep-debug -o $file.debug $file
		$CLANG_BIN_PATH/llvm-strip $file
	fi
done
mv $(pwd)/engine-sdk/lib/*.debug $(pwd)/.debug/
