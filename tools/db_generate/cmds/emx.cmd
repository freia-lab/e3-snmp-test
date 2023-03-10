require snmp

epicsEnvSet(TOP, "$(E3_CMD_TOP)/..")

epicsEnvSet(P, "LAB-010:")
epicsEnvSet(DISCIPLINE, "Test")

epicsEnvSet(HOST_IP, "172.30.5.159")

dbLoadTemplate("$(TOP)/db/emx-example.subst", "P=$(P), DISCIPLINE=$(DISCIPLINE), HOST=$(HOST_IP)")

iocInit()
