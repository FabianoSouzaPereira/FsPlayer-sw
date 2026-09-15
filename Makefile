export LANG := en_US.UTF-8
export LC_ALL := en_US.UTF-8
export SSL_CERT_FILE ?= /etc/ssl/cert.pem

BUILD_DIR := $(CURDIR)/.build/xcframework
XCFRAMEWORK := $(CURDIR)/FSPlayer.xcframework

.PHONY: generate project xcframework install setup clean

project:
	cd FSPlayerExample && xcodegen generate

xcframework: project
	rm -rf "$(BUILD_DIR)" "$(XCFRAMEWORK)"
	mkdir -p "$(BUILD_DIR)"
	cd FSPlayerExample && xcodebuild archive \
		-workspace FSPlayerExample.xcworkspace \
		-scheme FSPlayer \
		-configuration Release \
		-destination 'generic/platform=iOS' \
		-archivePath "$(BUILD_DIR)/ios.xcarchive" \
		SKIP_INSTALL=NO \
		BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
		ONLY_ACTIVE_ARCH=NO \
		CODE_SIGNING_ALLOWED=NO
	cd FSPlayerExample && xcodebuild archive \
		-workspace FSPlayerExample.xcworkspace \
		-scheme FSPlayer \
		-configuration Release \
		-destination 'generic/platform=iOS Simulator' \
		-archivePath "$(BUILD_DIR)/ios-simulator.xcarchive" \
		SKIP_INSTALL=NO \
		BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
		ONLY_ACTIVE_ARCH=NO \
		CODE_SIGNING_ALLOWED=NO
	xcodebuild -create-xcframework \
		-framework "$(BUILD_DIR)/ios.xcarchive/Products/Library/Frameworks/FSPlayer.framework" \
		-framework "$(BUILD_DIR)/ios-simulator.xcarchive/Products/Library/Frameworks/FSPlayer.framework" \
		-output "$(XCFRAMEWORK)"

generate: xcframework

install: generate
setup: generate

clean:
	rm -rf FSPlayerExample/Pods
	rm -rf FSPlayerExample/Podfile.lock
	rm -rf FSPlayerExample/FSPlayerExample.xcodeproj
	rm -rf FSPlayerExample/FSPlayerExample.xcworkspace
	rm -rf .build
