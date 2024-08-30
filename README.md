# flutter-engine
Flutter Engine Artifacts

## engine sdk

Contains libraries and tools for running Embedded Flutter on Linux

## Download and checksum validation

Example download
```
arch=armv7hf
commit=c9b9d5780da342eb3f0f5e439a7db06f7d112575
runtime=debug
curl -L -O https://github.com/meta-flutter/flutter-engine/releases/download/linux-engine-sdk-$runtime-$arch-$commit/linux-engine-sdk-$runtime-$arch-$commit.tar.gz
curl -L -O https://github.com/meta-flutter/flutter-engine/releases/download/linux-engine-sdk-$runtime-$arch-$commit/linux-engine-sdk-$runtime-$arch-$commit.tar.gz.sha256
sha256sum -c linux-engine-sdk-$runtime-$arch-$commit.tar.gz.sha256
```

If the downloaded files are good you will see
```
linux-engine-sdk-debug-unopt-arm64-c9b9d5780da342eb3f0f5e439a7db06f7d112575.tar.gz: OK
```

Never use a binary build artifact from a server that you cannot validate the expected checksum.  It's there for a reason, use it.

## glibc version issue issues

When running binaries on your Linux host, if it fails to execute due to interpreter error you can use the following pattern:
```
unshare -mr chroot `pwd`/engine-sdk /usr/bin/gen_snapshot --version
Dart SDK version: 3.6.0-164.0.dev (dev) (Tue Aug 20 13:05:46 2024 -0700) on "linux_x64"
```
