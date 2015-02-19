# Embedded Xamarin.Mac Sample

This is a simple sample demonstrating how to embed Mono and Xamarin.Mac into
an existing native Mac application.

_Note: **this scenario is not supported by Xamarin**._

The embedding scenario is useful for applications which were traditionally
native applications that desire to over time port to C#/Xamarin.Mac or
native applications that wish to provide "plugin" support for .NET languages.

In these cases, the host application retains its normal startup behavior,
and manually initializes both the Mono and Xamarin.Mac runtimes. This
initialization is typically performed by normal Xamarin.Mac applications as
part of the normal build process, but must be done manually for embedders.

The two runtimes consist of:

* **Mono:** a .NET runtime
* **Xamarin.Mac:** a bridge between Objective-C frameworks such as AppKit,
  and Mono, allowing .NET applications to benefit from native platform
  functionality

Both runtimes should be dynamically linked into the host application.

Currently the Mono runtime shipped with Xamarin.Mac does not include full
profile (desktop) assemblies, rather only the `Xamarin.Mac,v2.0` .NET
framework which is based on the Xamarin mobile profile (the same base profile
used for Xamarin.iOS and Xamarin.Android).

If embedders need access to the full .NET framework (e.g.`.NETFramework,v4.5`)
then a custom Mono runtime must be built. This is demonstrated in the
[mono/](mono) directory of this repository. When building a custom Mono,
it is important that the `--enable-native-types` argument be passed to
`configure`. This enables JIT intrinsic support for the new native types
introduced in Xamarin.Mac: `nint`, `nuint`, and `nfloat`.

Currently the Mono runtime which can be downloaded from the Mono project
that is installed at `/Library/Frameworks/Mono.framework` is not suitable
for Xamarin.Mac as it is 32-bit only and does not support native types.

Embedders who can use the normal Xamarin.Mac .NET framework can simply use
the Mono runtime and assemblies included in Xamarin.Mac itself and do not
need to build a custom Mono runtime.

## Build Configuration

Whether or not your build is configured through Xcode or manually on the
command line (e.g. Makefiles), the following paths are important for building
and linking:

### Include path:

* `/Library/Frameworks/Xamarin.Mac.framework/Versions/Current/include/xamarin`

### Linking:

* `/Library/Frameworks/Xamarin.Mac.framework/Versions/Current/lib/libmono-2.0.dylib` **or** the `libmono-2.0.dylib` produced from a custom build
* `/Library/Frameworks/Xamarin.Mac.framework/Versions/Current/lib/libxammac.dylib`

## Building and Running the Sample

This sample does require a custom Mono and includes a Makefile to help
with building it. To bootstrap the Mono runtime:

	git submodule update --recursive --init
	make mono

Once Mono has been built, it will be installed to `mono/install`. From there,
the sample embedding application can be built and run:

	make
	make run

Note that the toplevel Makefile in this repository is mostly a wrapper around
`xcodebuild`. You can open `EmbeddedXamarinMac.xcodeproj` in Xcode and build/
run like normal.

The Xcode project will invoke `make plugin` to actually compile the C#
project and bundle the necessary assemblies and native libraries into the
resulting native `EmbeddedXamarinMac.app`.
