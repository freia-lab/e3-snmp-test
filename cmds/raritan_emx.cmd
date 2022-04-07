
require snmp,1.0.0
#require iocStats,1856ef5


epicsEnvSet(TOP, "$(E3_CMD_TOP)")


epicsEnvSet(P, "Raritan")
epicsEnvSet(R, "EMX")
epicsEnvSet("IOC",  "$(P)-$(R)")
epicsEnvSet("IOCST", "$(IOC):IocStats")
epicsEnvSet("SNMP_USER", "public")
epicsEnvSet("USER_R", "$(SNMP_USER)")
epicsEnvSet("USER_W", "guru")

#dbLoadRecords("iocAdminSoft.db","IOC=${IOCST}")

epicsEnvSet("EMX1", "10.0.5.197")

epicsEnvSet("MIBDIRS", "+$(TOP)/../mibs")
epicsEnvSet("DB_TOP", "$(TOP)/../template/")

devSnmpSetSnmpVersion("$(EXM1)", "SNMP_VERSION_2c")

dbLoadRecords("$(DB_TOP)/raritan-emx-info.template",         "P=$(IOC):, USER=$(USER_R), HOST=$(EMX1)")
dbLoadRecords("$(DB_TOP)/raritan-emx-extsensor-unit.template" ,  "P=$(IOC):, USER=$(USER_R), HOST=$(EMX1), EXT_SENSOR_ID=1")
dbLoadRecords("$(DB_TOP)/raritan-emx-extsensor-unit.template" ,  "P=$(IOC):, USER=$(USER_R), HOST=$(EMX1), EXT_SENSOR_ID=2")
dbLoadRecords("$(DB_TOP)/raritan-emx-extsensor-unit.template" ,  "P=$(IOC):, USER=$(USER_R), HOST=$(EMX1), EXT_SENSOR_ID=3")
dbLoadRecords("$(DB_TOP)/raritan-emx-extsensor-unit.template" ,  "P=$(IOC):, USER=$(USER_R), HOST=$(EMX1), EXT_SENSOR_ID=4")
dbLoadRecords("$(DB_TOP)/raritan-emx-extsensor-unit.template" ,  "P=$(IOC):, USER=$(USER_R), HOST=$(EMX1), EXT_SENSOR_ID=17")
dbLoadRecords("$(DB_TOP)/raritan-emx-extsensor-unit.template" ,  "P=$(IOC):, USER=$(USER_R), HOST=$(EMX1), EXT_SENSOR_ID=18")



#dbLoadTemplate("$(DB_TOP)/raritan-PX3-5190R-ess.substitutions", "PREFIX=$(P1)-$(R):, PDU_IP=$(PDU1)")


iocInit()

dbl > "$(TOP)/$(IOC)_PVs.list"
