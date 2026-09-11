generate:
	cd FSPlayerExample && xcodegen generate

install:
	cd FSPlayerExample && pod install

clean:
	rm -rf FSPlayerExample/Pods
	rm -rf FSPlayerExample/Podfile.lock
	rm -rf FSPlayerExample/FSPlayerExample.xcodeproj

setup:
	cd FSPlayerExample && xcodegen generate
