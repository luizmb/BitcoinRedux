# Lint

lint-check: check-lint
lint-check:
	swiftlint

lint-autocorrect: check-lint
lint-autocorrect:
	swiftlint autocorrect

# Carthage Copy

carthage-copy: check-carthage
carthage-copy:
	export SCRIPT_INPUT_FILE_0=$(SRCROOT)/Carthage/Build/${PLATFORM}/RxSwift.framework \
	export SCRIPT_INPUT_FILE_1=$(SRCROOT)/Carthage/Build/${PLATFORM}/RxCocoa.framework \
	export SCRIPT_INPUT_FILE_2=$(SRCROOT)/Carthage/Build/${PLATFORM}/SwiftRex.framework \
	export SCRIPT_INPUT_FILE_3=$(SRCROOT)/Carthage/Build/${PLATFORM}/SwiftRexMonitorMiddleware.framework \
	export SCRIPT_INPUT_FILE_COUNT=4 \
	export SCRIPT_OUTPUT_FILE_0=$(BUILT_PRODUCTS_DIR)/$(FRAMEWORKS_FOLDER_PATH)/RxSwift.framework \
	export SCRIPT_OUTPUT_FILE_1=$(BUILT_PRODUCTS_DIR)/$(FRAMEWORKS_FOLDER_PATH)/RxCocoa.framework \
	export SCRIPT_OUTPUT_FILE_2=$(BUILT_PRODUCTS_DIR)/$(FRAMEWORKS_FOLDER_PATH)/SwiftRex.framework \
	export SCRIPT_OUTPUT_FILE_3=$(BUILT_PRODUCTS_DIR)/$(FRAMEWORKS_FOLDER_PATH)/SwiftRexMonitorMiddleware.framework \
	export SCRIPT_OUTPUT_FILE_COUNT=4; \
	carthage copy-frameworks

carthage-copy-mac: PLATFORM = Mac
carthage-copy-mac: carthage-copy

carthage-copy-ios: PLATFORM = iOS
carthage-copy-ios: carthage-copy

carthage-copy-watchos: PLATFORM = watchOS
carthage-copy-watchos: carthage-copy

carthage-copy-tvos: PLATFORM = tvOS
carthage-copy-tvos: carthage-copy

# Pre-Build

prebuild-mac: lint-autocorrect lint-check # carthage-copy-mac

prebuild-ios: lint-autocorrect lint-check # carthage-copy-ios

prebuild-watchos: lint-autocorrect lint-check # carthage-copy-watchos

prebuild-tvos: lint-autocorrect lint-check # carthage-copy-tvos

# Validate pre-reqs

LINT := $(shell command -v swiftlint 2> /dev/null)
CARTHAGE := $(shell command -v carthage 2> /dev/null)

check-lint:
ifndef LINT
    $(error "Swiftlint not installed, please run `brew install swiftlint`")
endif

check-carthage:
ifndef CARTHAGE
    $(error "Carthage not installed, please run `brew install carthage`")
endif
