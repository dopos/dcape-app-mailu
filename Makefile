# app custom Makefile

APP_NAME ?= mailu

# The domain name of this homeserver.
APP_DOMAIN ?= dev.lan

# Hostname for external access
APP_SITE ?= $(APP_NAME).$(APP_DOMAIN)

# Default username for create-user-admin
APP_USER ?= admin

# Docker repo & image name without version
#IMAGE    ?= 

# TODO: false/yes??
USE_DB = yes

#USE_TLS = yes

# ------------------------------------------------------------------------------
# app custom config

IMAGE_VER        ?= latest

DATA_PATH        ?= $(APP_NAME)
DCAPE_ROOT       ?= /opt/dcape/var


# ------------------------------------------------------------------------------
# .env template (custom part)
# inserted in .env.sample via 'make config'
define CONFIG_CUSTOM
# ------------------------------------------------------------------------------
# app custom config, generated by make config
# db:$(USE_DB) user:$(ADD_USER)

# Relative data path for service data
DATA_PATH=$(DATA_PATH)

# Path to /opt/dcape/var. Used only outside drone
DCAPE_ROOT=$(DCAPE_ROOT)

endef

# ------------------------------------------------------------------------------
# Find and include DCAPE/apps/drone/dcape-app/Makefile
DCAPE_COMPOSE   ?= dcape-compose
DCAPE_MAKEFILE  ?= $(shell docker inspect -f "{{.Config.Labels.dcape_app_makefile}}" $(DCAPE_COMPOSE))
ifeq ($(shell test -e $(DCAPE_MAKEFILE) && echo -n yes),yes)
  include $(DCAPE_MAKEFILE)
else
  include /opt/dcape-app/Makefile
endif
