.PHONY: build

build:
	rm -rf dist
	mkdir -p dist/components
	cp -r src/* dist/components
	cd dist && zip -r components-$(shell date +%y%m%d).zip components -x "**/*.import"
