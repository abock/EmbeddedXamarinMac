CONFIGURATION = Debug
XAMMAC_PREFIX = /Library/Frameworks/Xamarin.Mac.framework/Versions/Current
MONO_PREFIX = $(XAMMAC_PREFIX)

# these will only be valid when running under xcodebuild (e.g. the 'plugin' target)
HOST_APP_BUNDLE = $(shell echo $$BUILT_PRODUCTS_DIR/$$FULL_PRODUCT_NAME)
HOST_APP_FRAMEWORKS = $(HOST_APP_BUNDLE)/Contents/Frameworks
HOST_APP_MONO_BUNDLE = $(HOST_APP_BUNDLE)/Contents/MonoBundle

.PHONY: all host-app plugin run clean

all: host-app

host-app:
	xcodebuild -project EmbeddedXamarinMac.xcodeproj -configuration $(CONFIGURATION)

# this target will be called by xcodebuild (script build phase
# in EmbeddedXamarinMac.xcodeproj invokes this target); this
# results in building the managed plugin and bundling all of
# the native dependencies into the app bundle
plugin:
	xbuild XMPlugin/XMPlugin.sln
	./mono-bundler $(MONO_PREFIX) v4.5 $(HOST_APP_MONO_BUNDLE) XMPlugin/bin/$(CONFIGURATION)/XMPlugin.dll
	mkdir -p $(HOST_APP_FRAMEWORKS)
	cp $(XAMMAC_PREFIX)/lib/libxammac.dylib $(HOST_APP_FRAMEWORKS)
	cp $(MONO_PREFIX)/lib/libmonosgen-2.0.dylib $(HOST_APP_FRAMEWORKS)
	install_name_tool -id @rpath/libmonosgen-2.0.dylib $(HOST_APP_FRAMEWORKS)/libmonosgen-2.0.dylib
	install_name_tool -id @rpath/libxammac.dylib $(HOST_APP_FRAMEWORKS)/libxammac.dylib
	install_name_tool -change @executable_path/libmonosgen-2.0.dylib @rpath/libmonosgen-2.0.dylib $(HOST_APP_BUNDLE)/Contents/MacOS/EmbeddedXamarinMac
	install_name_tool -change libxammac.dylib @rpath/libxammac.dylib $(HOST_APP_BUNDLE)/Contents/MacOS/EmbeddedXamarinMac

run:
	open -W build/$(CONFIGURATION)/EmbeddedXamarinMac.app

clean:
	rm -rf XMPlugin/{bin,obj} build
