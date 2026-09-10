generate:
	cd FSPlayerExample && xcodegen generate

install:
	cd FSPlayerExample && pod install

clean:
	rm -rf FSPlayerExample/Pods
	rm -f FSPlayerExample/Podfile.lock
	rm -rf FSPlayerExample/FsPlayerExample.xcodeproj

setup:
	cd FSPlayerExample && xcodegen generate