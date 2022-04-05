## cmds

require snmp,1.0.0
require iocStats,1856ef5
require autosave,5.9.0

epicsEnvSet(TOP, "$(E3_CMD_TOP)")

epicsEnvSet(P, "LabS-Utgard-VIP:Rack-Chopper")
epicsEnvSet(R, "PDU")
epicsEnvSet("IOC",  "$(P)-$(R)")
epicsEnvSet("IOCST", "$(IOC):IocStats")

epicsEnvSet("AUTOSAVE_DIR", "/opt/nonvolatile_local")

dbLoadRecords("iocAdminSoft.db","IOC=${IOCST}")

epicsEnvSet("MIBDIRS", "+$(TOP)/../mibs")
epicsEnvSet("DB_TOP", "$(TOP)/../template/")

devSnmpSetSnmpVersion("10.4.0.121","SNMP_VERSION_2c")

# MIB file Prefix
epicsEnvSet("PDU1", "10.4.0.121")

dbLoadTemplate("$(DB_TOP)/raritan-PX3-5190R-ess.substitutions", "PREFIX=$(IOC):, PDU_IP=$(PDU1)")

#devSnmpSetParam("DebugLevel",100)

## autosave/restore machinery
save_restoreSet_Debug(0)                        # optional
save_restoreSet_IncompleteSetsOk(1)             # optional
save_restoreSet_DatedBackupFiles(1)             # optional

system("install -m 777 -d $(AUTOSAVE_DIR)/$(IOC)/autosave/save")# optional, but if omitted, must ensure path exists, requires system module
system("install -m 777 -d $(AUTOSAVE_DIR)/$(IOC)/autosave/req") # optional, but if omitted, must ensure path exists, requires system module

set_savefile_path("$(AUTOSAVE_DIR)/$(IOC)/autosave","/save")    # optional, but recommended. Replace TOP macro as required
set_requestfile_path("$(AUTOSAVE_DIR)/$(IOC)/autosave","/req")  # optional, but recommended. Replace TOP macro as required

set_pass0_restoreFile("info_positions.sav")     # before record initialization
set_pass0_restoreFile("info_settings.sav")      # before record initialization
set_pass1_restoreFile("info_settings.sav")      # after record initialization

iocInit()

## more autosave/restore machinery
cd $(AUTOSAVE_DIR)/$(IOC)/autosave/req          # sets location for autosave file generation
makeAutosaveFiles()                             # generates info_positions.req and info_settings.req from info tags in database
create_monitor_set("info_positions.req", 5 , "")
create_monitor_set("info_settings.req", 15 , "")

dbl > "$(TOP)/$(IOC)_PVs.list"
