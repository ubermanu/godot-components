.PHONY: test build

gut_version = 7.4.3

build:
	rm -rf dist
	mkdir -p dist/components
	cp -r src/* dist/components
	cd dist && zip -r components-$(shell date +%y%m%d).zip components -x "**/*.import"
	rm -rf dist/components

test:
	godot --headless -d -s --path $(shell pwd) addons/gut/gut_cmdln.gd

addons:
	mkdir -p addons
	rm -rf /tmp/Gut-$(gut_version) /tmp/gut.zip
	wget -O /tmp/gut.zip https://github.com/bitwes/Gut/archive/refs/tags/v$(gut_version).zip
	unzip /tmp/gut.zip -d /tmp
	mv /tmp/Gut-$(gut_version)/addons/gut addons/gut

clean:
	rm -rf dist **/*.import .godot addons
