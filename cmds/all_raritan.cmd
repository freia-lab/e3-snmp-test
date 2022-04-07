
require snmp,1.0.0
require iocStats,1856ef5


epicsEnvSet(TOP, "$(E3_CMD_TOP)")


epicsEnvSet(P1, "Raritan")
epicsEnvSet(P2, "TimingRack")
epicsEnvSet(R, "PDU")
epicsEnvSet("IOC",  "$(P2)-$(R)")
epicsEnvSet("IOCST", "$(IOC):IocStats")


dbLoadRecords("iocAdminSoft.db","IOC=${IOCST}")

epicsEnvSet("PDU1", "10.0.6.58")
epicsEnvSet("TimingRackPDU", "10.4.8.111")

epicsEnvSet("MIBDIRS", "+$(TOP)/../mibs")
epicsEnvSet("DB_TOP", "$(TOP)/../template/")

devSnmpSetSnmpVersion("$(PDU1)", "SNMP_VERSION_2c")
devSnmpSetSnmpVersion("$(TimingRackPDU)","SNMP_VERSION_2c")


dbLoadTemplate("$(DB_TOP)/raritan-PX3-5190R-ess.substitutions", "PREFIX=$(P1)-$(R):, PDU_IP=$(PDU1)")
dbLoadTemplate("$(DB_TOP)/raritan-PX3-5260R-ess.substitutions", "PREFIX=$(IOC):, PDU_IP=$(TimingRackPDU)")


iocInit()

dbl > "$(TOP)/$(IOC)_PVs.list"
