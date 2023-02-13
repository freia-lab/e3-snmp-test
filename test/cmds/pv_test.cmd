require snmp

# SNMP simulation server
epicsEnvSet(HOST, "127.0.0.1:1024")

epicsEnvSet(USER, "simdata")

epicsEnvSet(TOP, "$(E3_CMD_TOP)/..")

epicsEnvSet("MIBDIRS", "+$(TOP)/mibs")

devSnmpSetSnmpVersion("$(HOST)","SNMP_VERSION_2c")

dbLoadRecords("$(TOP)/db/pv_test.db", "HOST=$(HOST), USER=$(USER)")
