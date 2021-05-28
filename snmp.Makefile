where_am_I := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
include $(E3_REQUIRE_TOOLS)/driver.makefile
include $(E3_REQUIRE_CONFIG)/DECOUPLE_FLAGS


EXCLUDE_ARCHS = linux-ppc64e6500
EXCLUDE_ARCHS += linux-corei7-poky

APP:=snmpApp
APPDB:=$(APP)/Db
APPSRC:=$(APP)/src


USR_CFLAGS   += `net-snmp-config --cflags`
USR_CFLAGS   += -DNETSNMP_NO_INLINE

USR_LDFLAGS  += `net-snmp-config --libs`

USR_CFLAGS   += $(shell $(PERL) $(where_am_I)$(APPSRC)/getNetSNMPversion.pl)
USR_CPPFLAGS += $(shell $(PERL) $(where_am_I)$(APPSRC)/getNetSNMPversion.pl)

TEMPLATES += $(wildcard $(APPDB)/*.db)
TEMPLATES += $(wildcard $(APPDB)/*.template)

SOURCES   += $(APPSRC)/snmpRegister.cpp
SOURCES   += $(APPSRC)/snmpSessShow.c
SOURCES   += $(APPSRC)/devSnmp.cpp

DBDS      += $(APPSRC)/devSnmp.dbd

SCRIPTS += $(wildcard ../mibs/*-MIB)

USR_DBFLAGS += -I . -I ..
USR_DBFLAGS += -I $(EPICS_BASE)/db
USR_DBFLAGS += -I $(APPDB)

SUBS=$(wildcard $(APPDB)/*.substitutions)

.PHONY: db
db: $(SUBS) $(TMPS)

.PHONY: $(SUBS)
$(SUBS):
	@printf "Inflating database ... %44s >>> %40s \n" "$@" "$(basename $(@)).db"
	@rm -f  $(basename $(@)).db.d  $(basename $(@)).db
	$(MSI) -D $(USR_DBFLAGS) -o $(basename $(@)).db -S $@ > $(basename $(@)).db.d
	$(MSI)    $(USR_DBFLAGS) -o $(basename $(@)).db -S $@

.PHONY: $(TMPS)
$(TMPS):
	@printf "Inflating database ... %44s >>> %40s \n" "$@" "$(basename $(@)).db"
	@rm -f  $(basename $(@)).db.d  $(basename $(@)).db
	@$(MSI) -D $(USR_DBFLAGS) -o $(basename $(@)).db $@  > $(basename $(@)).db.d
	@$(MSI)    $(USR_DBFLAGS) -o $(basename $(@)).db $@

.PHONY: vlibs
vlibs:
