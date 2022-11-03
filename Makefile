TOP_DIR = ../..
include $(TOP_DIR)/tools/Makefile.common

DEPLOY_RUNTIME ?= /kb/runtime
TARGET ?= /kb/deployment

WRAP_JAVA_TOOL = wrap_java
WRAP_JAVA_SCRIPT = bash $(TOOLS_DIR)/$(WRAP_JAVA_TOOL).sh

# identify the output jar names here
JARS = kmers.reps dl4j.eval

SRC_JAVA = $(shell $(TOOLS_DIR)/java-source $(CURDIR))
BIN_DIR = $(KB_TOP)/bin
BIN_JAVA = $(foreach mod,$(JARS),$(BIN_DIR)/$(mod))
JAR_JAVA = $(foreach mod,$(JARS),$(SEED_JARS)/$(mod).jar)

all: bin 

bin: $(BIN_JAVA) $(JAR_JAVA)

test:
	mvn test

show:
	echo jars $(JAR_JAVA)
	echo bins $(BIN_JAVA)
	echo source $(SRC_JAVA) 

clean:
	mvn clean

$(BIN_DIR)/%: $(SEED_JARS)/%.jar
	$(WRAP_JAVA_SCRIPT) $* $@

$(SEED_JARS)/%.jar: SRC_JAVA
	mvn package -Dmaven.test.skip=true

include $(TOP_DIR)/tools/Makefile.common.rules
