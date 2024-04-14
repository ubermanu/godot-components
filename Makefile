.PHONY: test build

build:
	rm -rf dist
	mkdir -p dist/components
	cp -r src/* dist/components
	cd dist && zip -r components-$(shell date +%y%m%d).zip components -x "**/*.import"
	rm -rf dist/components

test:
	godot -d -s --path $(shell pwd) addons/gut/gut_cmdln.gd
