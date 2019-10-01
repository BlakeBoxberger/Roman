TARGET = simulator:clang::12.0
ARCHS = x86_64

#TARGET = iphone::11.2:11.0
#ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Roman

Roman_FILES = Tweak.x
Roman_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"

after-uninstall::
	"killall -9 SpringBoard"

ifneq (,$(filter x86_64,$(ARCHS)))
setup:: clean all
	@rm -f /opt/simject/$(TWEAK_NAME).dylib
	@cp -v $(THEOS_OBJ_DIR)/$(TWEAK_NAME).dylib /opt/simject/$(TWEAK_NAME).dylib
	@cp -v $(PWD)/$(TWEAK_NAME).plist /opt/simject
	@/Users/BlakeBoxberger/simject/bin/resim
endif

ifneq (,$(filter x86_64,$(ARCHS)))
remove::
	@rm -f /opt/simject/$(TWEAK_NAME).dylib
	@rm -f /opt/simject/$(TWEAK_NAME).plist
	@/Users/BlakeBoxberger/simject/bin/resim
endif
