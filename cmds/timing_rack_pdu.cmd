## cmds

require snmp,1.0.0
require iocStats,1856ef5
#require autosave,5.9.0

epicsEnvSet(TOP, "$(E3_CMD_TOP)")

epicsEnvSet(P, "TimingRack")
epicsEnvSet(R, "PDU")
epicsEnvSet("IOC",  "$(P)-$(R)")
epicsEnvSet("IOCST", "$(IOC):IocStats")


dbLoadRecords("iocAdminSoft.db","IOC=${IOCST}")

epicsEnvSet("TimingRackPDU", "10.4.8.111")

epicsEnvSet("MIBDIRS", "+$(TOP)/../mibs")
epicsEnvSet("DB_TOP", "$(TOP)/../template/")

devSnmpSetSnmpVersion("$(TimingRackPDU)","SNMP_VERSION_2c")

dbLoadTemplate("$(DB_TOP)/raritan-PX3-5260R-ess.substitutions", "PREFIX=$(IOC):, PDU_IP=$(TimingRackPDU)")

#devSnmpSetParam("DebugLevel",100)

iocInit()

dbl > "$(TOP)/$(IOC)_PVs.list"
