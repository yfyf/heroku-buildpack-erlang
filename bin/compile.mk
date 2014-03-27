.PHONY: all compile deps erlang rebar

PROFILE_D=$(BUILD_DIR)/.profile.d
DIRS=$(BUILD_DIR) $(CACHE_DIR) $(ENV_DIR) $(PROFILE_D)

OTP_VERSION?=R16B03-1
OTP_TARBALL?=OTP_${OTP_VERSION}.tgz
OTP_TARBALL_URL="https://s3.amazonaws.com/heroku-buildpack-erlang/${OTP_TARBALL}"

REBAR_VSN?=2.2.0
REBAR_BIN_URL="https://github.com/rebar/rebar/releases/download/$(REBAR_VSN)/rebar"
REBAR_BIN_CACHED=$(CACHE_DIR)/rebar$(VSN)

HEROKU_APP_PATH=/app/
OTP_APP_PATH=/app/otp
PATHS_FILE=$(PROFILE_D)/paths.sh
EXTENDED_PATH=$(OTP_APP_PATH)/bin:$$PATH

ERLROOT=$(abspath $(BUILD_DIR)/otp)

all: compile

compile: $(BUILD_DIR)/Makefile deps
	export PATH=$(EXTENDED_PATH) && \
		 $(MAKE) -C $(BUILD_DIR)

deps: $(DIRS) erlang rebar $(PATHS_FILE)

$(PATHS_FILE): $(PROFILE_D)
	echo 'PATH=$(EXTENDED_PATH)' > $@
	chmod +x $@

rebar: $(BUILD_DIR)/rebar

$(BUILD_DIR)/rebar: $(REBAR_BIN_CACHED)
	cp $< $@

$(REBAR_BIN_CACHED):
	cd $(CACHE_DIR) && \
		curl -O $(REBAR_BIN_URL)
	chmod +x $@

erlang: $(OTP_APP_PATH)

$(OTP_APP_PATH): $(ERLROOT)
	## wtf, why is this needed?
	ln -sf $< $@
	${ERLROOT}/Install -minimal $@

$(ERLROOT): $(CACHE_DIR)/$(OTP_TARBALL)
	rm -rf $@
	mkdir -p $@
	tar zxf $< -C $@ --strip-components=2

$(CACHE_DIR)/$(OTP_TARBALL):
	cd $(CACHE_DIR) && curl -O ${OTP_TARBALL_URL}

$(DIRS):
	mkdir -p $@
