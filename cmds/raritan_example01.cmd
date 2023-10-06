require snmp

epicsEnvSet(TOP, "$(E3_CMD_TOP)")

epicsEnvSet(P, "Sys")
epicsEnvSet(R, "Dis-Dev-Idx")
epicsEnvSet("PREFIX", "$(P):$(R):")

epicsEnvSet("FQDN", "not-a-real-host.cslab.esss.lu.se")

epicsEnvSet("MIBDIRS", "+$(TOP)/../mibs")
epicsEnvSet("DB_TOP", "$(TOP)/../template/")

devSnmpSetSnmpVersion("$(FQDN)", "SNMP_VERSION_2c")

dbLoadTemplate("$(DB_TOP)/raritan-PX3-5260R-ess.substitutions", "PREFIX=$(PREFIX):, PDU_IP=$(FQDN)")

#devSnmpSetParam("DebugLevel", 100)
