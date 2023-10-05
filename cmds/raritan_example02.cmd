require snmp

epicsEnvSet(TOP, "$(E3_CMD_TOP)")

epicsEnvSet(P, "Sys")
epicsEnvSet(R, "Dis-Dev-Idx")
epicsEnvSet("PREFIX", "$(P):$(R):")

epicsEnvSet("USER_R", "public")
epicsEnvSet("USER_W", "admin")
epicsEnvSet("FQDN", "not-a-real-host.cslab.esss.lu.se")

epicsEnvSet("MIBDIRS", "+$(TOP)/../mibs")
epicsEnvSet("DB_TOP", "$(TOP)/../template/")

devSnmpSetSnmpVersion("FQDN", "SNMP_VERSION_2c")

dbLoadRecords("$(DB_TOP)/raritan-pdu-info.template", "P=$(PREFIX), USER=$(USER_R), HOST=$(FQDN)")
dbLoadRecords("$(DB_TOP)/raritan-pdu-inlet.template", "P=$(PREFIX), USER=$(USER_R), HOST=$(FQDN)")
dbLoadRecords("$(DB_TOP)/raritan-pdu-outlet.template", "P=$(PREFIX), USER=$(USER_R), HOST=$(FQDN), OUTLET_ID=1")
dbLoadRecords("$(DB_TOP)/raritan-pdu-outlet.template", "P=$(PREFIX), USER=$(USER_R), HOST=$(FQDN), OUTLET_ID=2")
dbLoadRecords("$(DB_TOP)/raritan-pdu-outlet.template", "P=$(PREFIX), USER=$(USER_R), HOST=$(FQDN), OUTLET_ID=3")
dbLoadRecords("$(DB_TOP)/raritan-pdu-outlet.template", "P=$(PREFIX), USER=$(USER_R), HOST=$(FQDN), OUTLET_ID=4")
dbLoadRecords("$(DB_TOP)/raritan-pdu-outlet.template", "P=$(PREFIX), USER=$(USER_R), HOST=$(FQDN), OUTLET_ID=5")
dbLoadRecords("$(DB_TOP)/raritan-pdu-outlet.template", "P=$(PREFIX), USER=$(USER_R), HOST=$(FQDN), OUTLET_ID=6")
dbLoadRecords("$(DB_TOP)/raritan-pdu-outlet.template", "P=$(PREFIX), USER=$(USER_R), HOST=$(FQDN), OUTLET_ID=7")
dbLoadRecords("$(DB_TOP)/raritan-pdu-outlet.template", "P=$(PREFIX), USER=$(USER_R), HOST=$(FQDN), OUTLET_ID=8")
dbLoadRecords("$(DB_TOP)/raritan-pdu-outlet-ctrl.template", "P=$(PREFIX), USER=$(USER_W), HOST=$(FQDN), OUTLET_ID=1")
dbLoadRecords("$(DB_TOP)/raritan-pdu-outlet-ctrl.template", "P=$(PREFIX), USER=$(USER_W), HOST=$(FQDN), OUTLET_ID=2")
dbLoadRecords("$(DB_TOP)/raritan-pdu-outlet-ctrl.template", "P=$(PREFIX), USER=$(USER_W), HOST=$(FQDN), OUTLET_ID=3")
dbLoadRecords("$(DB_TOP)/raritan-pdu-outlet-ctrl.template", "P=$(PREFIX), USER=$(USER_W), HOST=$(FQDN), OUTLET_ID=4")
dbLoadRecords("$(DB_TOP)/raritan-pdu-outlet-ctrl.template", "P=$(PREFIX), USER=$(USER_W), HOST=$(FQDN), OUTLET_ID=5")
dbLoadRecords("$(DB_TOP)/raritan-pdu-outlet-ctrl.template", "P=$(PREFIX), USER=$(USER_W), HOST=$(FQDN), OUTLET_ID=6")
dbLoadRecords("$(DB_TOP)/raritan-pdu-outlet-ctrl.template", "P=$(PREFIX), USER=$(USER_W), HOST=$(FQDN), OUTLET_ID=7")
dbLoadRecords("$(DB_TOP)/raritan-pdu-outlet-ctrl.template", "P=$(PREFIX), USER=$(USER_W), HOST=$(FQDN), OUTLET_ID=8")
dbLoadRecords("$(DB_TOP)/raritan-pdu-extsensor-unit.template", "P=$(PREFIX), USER=$(USER_R), HOST=$(FQDN), EXT_SENSOR_ID=1")
dbLoadRecords("$(DB_TOP)/raritan-pdu-extsensor-unit.template", "P=$(PREFIX), USER=$(USER_R), HOST=$(FQDN), EXT_SENSOR_ID=2")
dbLoadRecords("$(DB_TOP)/raritan-pdu-extsensor-unit.template", "P=$(PREFIX), USER=$(USER_R), HOST=$(FQDN), EXT_SENSOR_ID=3")
dbLoadRecords("$(DB_TOP)/raritan-pdu-extsensor-unit.template", "P=$(PREFIX), USER=$(USER_R), HOST=$(FQDN), EXT_SENSOR_ID=4")

#devSnmpSetParam("DebugLevel", 4)
