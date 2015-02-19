SYSTEM_MONO_FRAMEWORK_PATH=/Library/Frameworks/Mono.framework/Versions/Current
PATH = $(SYSTEM_MONO_FRAMEWORK_PATH)/bin:/usr/bin:/bin:/usr/sbin:/sbin
MONO_PATH = mono

MACOSX_VERSION_MIN = 10.9
XCODE_DEVELOPER_ROOT = /Applications/Xcode.app
SYSROOT = $(XCODE_DEVELOPER_ROOT)/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX$(MACOSX_VERSION_MIN).sdk

MONO_INSTALL_PREFIX = $(CURDIR)/install

CPPFLAGS = \
	-isysroot $(SYSROOT) \
	-mmacosx-version-min=$(MACOSX_VERSION_MIN)
CFLAGS = -O3 -arch x86_64
CXXFLAGS = $(CFLAGS)

AUTOGEN_FLAGS =
CONFIGURE_FLAGS = \
	--prefix=$(MONO_INSTALL_PREFIX) \
	--host=x86_64-apple-darwin10 \
	--enable-maintainer-mode \
	--with-glib=embedded \
	--with-mcs-docs=no \
	--disable-shared-handles \
	--disable-nls \
	--disable-iconv \
	--enable-native-types \
	--with-profile2=no \
	--with-profile4=yes \
	--with-profile4_5=yes \
	$(AUTOGEN_FLAGS)

.PHONY: all build install clean

all: build install

$(MONO_PATH)/configure: $(MONO_PATH)/autogen.sh
	cd $(MONO_PATH) && NOCONFIGURE=1 ./autogen.sh $(AUTOGEN_FLAGS)

$(MONO_PATH)/Makefile: $(MONO_PATH)/configure
	cd $(MONO_PATH) && \
		PATH="$(PATH)" \
		CPPFLAGS="$(CPPFLAGS)" \
		CFLAGS="$(CFLAGS)" \
		CXXFLAGS="$(CXXFLAGS)" \
		./configure $(CONFIGURE_FLAGS)

build: $(MONO_PATH)/Makefile
	PATH=$(PATH) $(MAKE) -C $(MONO_PATH)

install: $(MONO_PATH)/Makefile
	PATH=$(PATH) $(MAKE) -C $(MONO_PATH) -j1 install

clean:
	@echo "** WARNING: about to run 'git checkout .' and 'git clean -xfd' in: "
	@echo
	@echo "   - $(MONO_PATH)"
	@echo
	@printf "Type YES to continue: "
	@read CONTINUE_CLEAN && [ $$CONTINUE_CLEAN = YES ]
	@echo Cleaning...
	rm -f $(MONO_PATH)/configure
	rm -rf $(MONO_INSTALL_PREFIX)
	cd $(MONO_PATH) && git clean -xfd && git checkout .
