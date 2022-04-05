
require snmp,dev
require iocStats,1856ef5

###
###
###>>
###>> Environmet Variables
###>>
epicsEnvSet("ENGINEER","")
epicsEnvSet("LOCATION","")

epicsEnvSet("TOP", "$(E3_CMD_TOP)/..")
epicsEnvSet("DB_TOP", "$(TOP)/template")
epicsEnvSet("CMD_TOP", "$(E3_CMD_TOP)")

epicsEnvSet("IOCSTATS_CMD_TOP", "$(TOP)/../e3-iocStats/cmds")
epicsEnvSet("AUTOSAVE_CMD_TOP", "$(TOP)/../e3-autosave/cmds")


epicsEnvSet(P, "Raritan")
epicsEnvSet(R, "EMX")
epicsEnvSet("IOC",  "$(P)-$(R)")
epicsEnvSet("IOCST", "$(IOC):IocStats")
epicsEnvSet("SNMP_USER", "public")
epicsEnvSet("USER_R", "$(SNMP_USER)")
epicsEnvSet("USER_W", "guru")

epicsEnvSet("EMX1", "172.16.60.30")
epicsEnvSet("MIBDIRS", "+$(TOP)/../mibs")


iocshLoad("$(TOP)/iocsh/raritan_emx888.iocsh", "HOSTNAME=$(EMX1)")

devSnmpSetParam("DebugLevel",4)

###
###
###>>
###>> IocStats
###>>
#iocshLoad "$(IOCSTATS_CMD_TOP)/iocStats.cmd" "IOC=$(IOC):IocStats"

###
###
###>>
###>> snmp for Raritan
###>>
dbLoadRecords("$(DB_TOP)/raritan-emx-info.template",             "P=$(IOC)-FEB:, USER=$(USER_R), HOST=$(EMX1)")
# dbLoadRecords("$(DB_TOP)/raritan-emx-extsensor-unit.template" ,  "P=$(IOC)-FEB:, USER=$(USER_R), HOST=$(EMX1), EXT_SENSOR_ID=1")

dbLoadRecords("$(DB_TOP)/raritan-emx-lhx-unit.template" ,         "P=$(IOC)-FEB:, USER=$(USER_R), HOST=$(EMX1), LHX_ID=1")
dbLoadRecords("$(DB_TOP)/raritan-emx-lhx-unit-ctrl.template" ,    "P=$(IOC)-FEB:, USER=$(USER_W), HOST=$(EMX1), LHX_ID=1")
dbLoadRecords("$(DB_TOP)/raritan-emx-lhx-unit.template" ,         "P=$(IOC)-FEB:, USER=$(USER_R), HOST=$(EMX1), LHX_ID=5")
dbLoadRecords("$(DB_TOP)/raritan-emx-lhx-unit-ctrl.template" ,    "P=$(IOC)-FEB:, USER=$(USER_W), HOST=$(EMX1), LHX_ID=5")

dbLoadTemplate("$(DB_TOP)/raritan-emx-lhx-unit-sensors.template" , "PREF=$(IOC)-FEB:, HOST_IP=$(EMX1), LHX_UNIT=1")
# dbLoadRecords("$(DB_TOP)/raritan-emx-lhx-unit-gsensors.template",  "P=$(IOC)-FEB:, LHX_ID=1")

#dbLoadRecords("$(DB_TOP)/raritan-emx-lhx-unit-sensors.template",  "P=$(IOC)-FEB:, USER=$(USER_R), HOST=$(EMX1), LHX_ID=1, SENSOR_NAME=AirTemp,   SENSOR_ID=0, SENSOR_SUBID=2")
#dbLoadRecords("$(DB_TOP)/raritan-emx-lhx-unit-sensors.template",  "P=$(IOC)-FEB:, USER=$(USER_R), HOST=$(EMX1), LHX_ID=1, SENSOR_NAME=AirTemp,   SENSOR_ID=0, SENSOR_SUBID=3")
#dbLoadRecords("$(DB_TOP)/raritan-emx-lhx-unit-sensors.template",  "P=$(IOC)-FEB:, USER=$(USER_R), HOST=$(EMX1), LHX_ID=1, SENSOR_NAME=AirTemp,   SENSOR_ID=0, SENSOR_SUBID=4")
#dbLoadRecords("$(DB_TOP)/raritan-emx-lhx-unit-sensors.template",  "P=$(IOC)-FEB:, USER=$(USER_R), HOST=$(EMX1), LHX_ID=1, SENSOR_NAME=AirTemp,   SENSOR_ID=0, SENSOR_SUBID=5")
#dbLoadRecords("$(DB_TOP)/raritan-emx-lhx-unit-sensors.template",  "P=$(IOC)-FEB:, USER=$(USER_R), HOST=$(EMX1), LHX_ID=1, SENSOR_NAME=AirTemp,   SENSOR_ID=0, SENSOR_SUBID=6")
#dbLoadRecords("$(DB_TOP)/raritan-emx-lhx-unit-sensors.template",  "P=$(IOC)-FEB:, USER=$(USER_R), HOST=$(EMX1), LHX_ID=1, SENSOR_NAME=AirTemp,   SENSOR_ID=0, SENSOR_SUBID=7")

#dbLoadRecords("$(DB_TOP)/raritan-emx-lhx-unit-sensors.template",  "P=$(IOC)-FEB:, USER=$(USER_R), HOST=$(EMX1), LHX_ID=1, SENSOR_NAME=WaterTemp, SENSOR_ID=1, SENSOR_SUBID=1")

#dbLoadRecords("$(DB_TOP)/raritan-emx-lhx-unit-sensors.template",  "P=$(IOC)-FEB:, USER=$(USER_R), HOST=$(EMX1), LHX_ID=1, SENSOR_NAME=FanSpeed,  SENSOR_ID=2, SENSOR_SUBID=1")
#dbLoadRecords("$(DB_TOP)/raritan-emx-lhx-unit-sensors.template",  "P=$(IOC)-FEB:, USER=$(USER_R), HOST=$(EMX1), LHX_ID=1, SENSOR_NAME=FanSpeed,  SENSOR_ID=2, SENSOR_SUBID=2")
#dbLoadRecords("$(DB_TOP)/raritan-emx-lhx-unit-sensors.template",  "P=$(IOC)-FEB:, USER=$(USER_R), HOST=$(EMX1), LHX_ID=1, SENSOR_NAME=FanSpeed,  SENSOR_ID=2, SENSOR_SUBID=3")
#dbLoadRecords("$(DB_TOP)/raritan-emx-lhx-unit-sensors.template",  "P=$(IOC)-FEB:, USER=$(USER_R), HOST=$(EMX1), LHX_ID=1, SENSOR_NAME=FanSpeed,  SENSOR_ID=2, SENSOR_SUBID=4")
#dbLoadRecords("$(DB_TOP)/raritan-emx-lhx-unit-sensors.template",  "P=$(IOC)-FEB:, USER=$(USER_R), HOST=$(EMX1), LHX_ID=1, SENSOR_NAME=FanSpeed,  SENSOR_ID=2, SENSOR_SUBID=5")
#dbLoadRecords("$(DB_TOP)/raritan-emx-lhx-unit-sensors.template",  "P=$(IOC)-FEB:, USER=$(USER_R), HOST=$(EMX1), LHX_ID=1, SENSOR_NAME=FanSpeed,  SENSOR_ID=2, SENSOR_SUBID=6")


#dbLoadRecords("$(DB_TOP)/raritan-emx-lhx-unit.template" ,       "P=$(IOC)-FEB:, USER=$(USER_R), HOST=$(EMX1), LHX_ID=5")
#dbLoadRecords("$(DB_TOP)/raritan-emx-lhx-unit-ctrl.template" ,  "P=$(IOC)-FEB:, USER=$(USER_W), HOST=$(EMX1), LHX_ID=5")



#dbLoadTemplate("$(DB_TOP)/raritan-PX3-5190R-ess.substitutions", "PREFIX=$(P1)-$(R):, PDU_IP=$(PDU1)")


iocInit()

dbl > "$(TOP)/$(IOC)_PVs.list"
