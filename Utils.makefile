export BUCK=buck
export TELEGRAM_ENV_SET=1
export DEVELOPMENT_CODE_SIGN_IDENTITY=iPhone Distribution: Digital Fortress LLC (C67CF9S4VU)
export DISTRIBUTION_CODE_SIGN_IDENTITY=iPhone Distribution: Digital Fortress LLC (C67CF9S4VU)
export DEVELOPMENT_TEAM=C67CF9S4VU
export API_ID=8
export API_HASH=7245de8e747a0d6fbe11f7cc14fcc0bb
export BUNDLE_ID=ph.telegra.Telegraph
export IS_INTERNAL_BUILD=false
export IS_APPSTORE_BUILD=true
export APPSTORE_ID=686449807
export APP_SPECIFIC_URL_SCHEME=tgapp
export BUILD_NUMBER=199
export ENTITLEMENTS_APP=Telegram-iOS/Telegram-iOS-AppStoreLLC.entitlements
export DEVELOPMENT_PROVISIONING_PROFILE_APP=match Development ph.telegra.Telegraph
export DISTRIBUTION_PROVISIONING_PROFILE_APP=match AppStore ph.telegra.Telegraph
export ENTITLEMENTS_EXTENSION_SHARE=Share/Share-AppStoreLLC.entitlements
export DEVELOPMENT_PROVISIONING_PROFILE_EXTENSION_SHARE=match Development ph.telegra.Telegraph.Share
export DISTRIBUTION_PROVISIONING_PROFILE_EXTENSION_SHARE=match AppStore ph.telegra.Telegraph.Share
export ENTITLEMENTS_EXTENSION_WIDGET=Widget/Widget-AppStoreLLC.entitlements
export DEVELOPMENT_PROVISIONING_PROFILE_EXTENSION_WIDGET=match Development ph.telegra.Telegraph.Widget
export DISTRIBUTION_PROVISIONING_PROFILE_EXTENSION_WIDGET=match AppStore ph.telegra.Telegraph.Widget
export ENTITLEMENTS_EXTENSION_NOTIFICATIONSERVICE=NotificationService/NotificationService-AppStoreLLC.entitlements
export DEVELOPMENT_PROVISIONING_PROFILE_EXTENSION_NOTIFICATIONSERVICE=match Development ph.telegra.Telegraph.NotificationService
export DISTRIBUTION_PROVISIONING_PROFILE_EXTENSION_NOTIFICATIONSERVICE=match AppStore ph.telegra.Telegraph.NotificationService
export ENTITLEMENTS_EXTENSION_NOTIFICATIONCONTENT=NotificationContent/NotificationContent-AppStoreLLC.entitlements
export DEVELOPMENT_PROVISIONING_PROFILE_EXTENSION_NOTIFICATIONCONTENT=match Development ph.telegra.Telegraph.NotificationContent
export DISTRIBUTION_PROVISIONING_PROFILE_EXTENSION_NOTIFICATIONCONTENT=match AppStore ph.telegra.Telegraph.NotificationContent
export ENTITLEMENTS_EXTENSION_INTENTS=SiriIntents/SiriIntents-AppStoreLLC.entitlements
export DEVELOPMENT_PROVISIONING_PROFILE_EXTENSION_INTENTS=match Development ph.telegra.Telegraph.SiriIntents
export DISTRIBUTION_PROVISIONING_PROFILE_EXTENSION_INTENTS=match AppStore ph.telegra.Telegraph.SiriIntents
export DEVELOPMENT_PROVISIONING_PROFILE_WATCH_APP=match Development ph.telegra.Telegraph.watchkitapp
export DISTRIBUTION_PROVISIONING_PROFILE_WATCH_APP=match AppStore ph.telegra.Telegraph.watchkitapp
export DEVELOPMENT_PROVISIONING_PROFILE_WATCH_EXTENSION=match Development ph.telegra.Telegraph.watchkitapp.watchkitextension
export DISTRIBUTION_PROVISIONING_PROFILE_WATCH_EXTENSION=match AppStore ph.telegra.Telegraph.watchkitapp.watchkitextension
export BUILDBOX_DIR=buildbox
export CODESIGNING_PROFILES_VARIANT=appstore
export PACKAGE_METHOD=appstore

export BUCK_DEBUG_OPTIONS=\
	--config custom.other_cflags="-O0 -D DEBUG" \
  	--config custom.other_cxxflags="-O0 -D DEBUG" \
  	--config custom.optimization="-Onone" \
  	--config custom.config_swift_compiler_flags="-DDEBUG"

export BUCK_RELEASE_OPTIONS=\
	--config custom.other_cflags="-Os" \
  	--config custom.other_cxxflags="-Os" \
  	--config custom.optimization="-O" \
  	--config custom.config_swift_compiler_flags="-whole-module-optimization"

export BUCK_THREADS_OPTIONS=--config build.threads=$(shell sysctl -n hw.logicalcpu)

ifneq ($(BUCK_HTTP_CACHE),)
	ifeq ($(BUCK_CACHE_MODE),)
		BUCK_CACHE_MODE=readwrite
	endif
	export BUCK_CACHE_OPTIONS=\
		--config cache.mode=http \
		--config cache.http_url="$(BUCK_HTTP_CACHE)" \
		--config cache.http_mode="$(BUCK_CACHE_MODE)"
endif

ifneq ($(BUCK_DIR_CACHE),)
	export BUCK_CACHE_OPTIONS=\
		--config cache.mode=dir \
		--config cache.dir="$(BUCK_DIR_CACHE)" \
		--config cache.dir_mode="readwrite"
endif

check_env:
ifndef BUCK
	$(error BUCK is not set)
endif
	sh check_env.sh

kill_xcode:
	killall Xcode || true
