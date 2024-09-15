#! /bin/bash

pushd $1

SYSROOT=$2

mkdir -p engine-sdk/{bin,include,lib,data,clang_x64/bin,clang_x64/lib64}

# 
# Include
# 
cp flutter_embedder.h engine-sdk/include/

# 
# /data 
# 
cp icudtl.dat engine-sdk/data/

# 
# SDK
# 
cp -r flutter_patched_sdk engine-sdk/sdk/
if [ -e shader_lib ]; then
	cp -r shader_lib engine-sdk/
fi

export cwd=$(pwd)

# 
# host - x64
# 
cd clang_x64/exe.unstripped
for file in *; do
    cp "../$file" $cwd/engine-sdk/clang_x64/bin/

    # Copy each library with its parent directories to the target directory
    for library in $(ldd "$file" | cut -d '>' -f 2 | awk '{print $1}')
    do
        [ -f "${library}" ] && cp --verbose --parents "${library}" "$cwd/engine-sdk/clang_x64/"
    done
done
cd $cwd

# 
# /lib
# 
cd so.unstripped
for file in *; do
    cp "../$file" $cwd/engine-sdk/lib/
done
cd $cwd

popd
