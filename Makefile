BUNDLE=rbenv exec bundle
LANG_VAR=LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
FASTLANE=$(LANG_VAR) $(BUNDLE) exec fastlane

setup:
	brew update
	brew upgrade
	brew cleanup
	brew install rbenv swiftlint
	rbenv install -s
	rbenv exec gem install bundler
	rbenv rehash
	$(BUNDLE) install
	git submodule update --init --recursive

test:
	$(FASTLANE) test
