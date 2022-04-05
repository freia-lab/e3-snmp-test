
epicsEnvSet("MIBDIRS", "+$(SNMP_CMD_TOP)/../mibs")
devSnmpSetSnmpVersion("PDU_IP","SNMP_VERSION_2c")
dbLoadRecords("raritan-PX3-5190R-ess.db", "PREFIX=$(IOC):, PDU_IP=$(PDU_IP)")
