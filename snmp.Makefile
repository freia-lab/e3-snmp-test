#
#  Copyright (c) 2018 - Present  European Spallation Source ERIC
#
#  The program is free software: you can redistribute
#  it and/or modify it under the terms of the GNU General Public License
#  as published by the Free Software Foundation, either version 2 of the
#  License, or any newer version.
#
#  This program is distributed in the hope that it will be useful, but WITHOUT
#  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
#  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
#  more details.
#
#  You should have received a copy of the GNU General Public License along with
#  this program. If not, see https://www.gnu.org/licenses/gpl-2.0.txt
#
# 
# Author  : Jeong Han Lee
# email   : han.lee@esss.se
# Date    : Thursday, November 15 14:59:57 CET 2018
# version : 0.0.2
#

where_am_I := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
include $(E3_REQUIRE_TOOLS)/driver.makefile
include $(E3_REQUIRE_CONFIG)/DECOUPLE_FLAGS



EXCLUDE_ARCHS = linux-ppc64e6500
EXCLUDE_ARCHS += linux-corei7-poky

APP:=snmpApp
APPDB:=$(APP)/Db
APPSRC:=$(APP)/src


# USR_INCLUDES += -I$(where_am_I)$(APPSRC)

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
#TMPS=$(wildcard $(APPDB)/*.template)
TMPS=

db: $(SUBS) $(TMPS)

$(SUBS):
	@printf "Inflating database ... %44s >>> %40s \n" "$@" "$(basename $(@)).db"
	@rm -f  $(basename $(@)).db.d  $(basename $(@)).db
	$(MSI) -D $(USR_DBFLAGS) -o $(basename $(@)).db -S $@ > $(basename $(@)).db.d
	$(MSI)    $(USR_DBFLAGS) -o $(basename $(@)).db -S $@

$(TMPS):
	@printf "Inflating database ... %44s >>> %40s \n" "$@" "$(basename $(@)).db"
	@rm -f  $(basename $(@)).db.d  $(basename $(@)).db
	@$(MSI) -D $(USR_DBFLAGS) -o $(basename $(@)).db $@  > $(basename $(@)).db.d
	@$(MSI)    $(USR_DBFLAGS) -o $(basename $(@)).db $@


.PHONY: db $(SUBS) $(TMPS)

vlibs:

.PHONY: vlibs




