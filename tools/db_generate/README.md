# snmp-generate-db

## Prerequisites
In order to run the script, you must install the following:

 * python3
 * net-snmp
 * net-snmp-utils

 And the python modules:

 * pyyaml

## MIB files and nodefiles
The python script requires a dictonary containing the OIDs that you want to parse, together with the EPICS record type of the corresponding PV. See **device_dict.yaml**.

OIDs are found in the MIB file of the device.

By default, net-snmp loads MIB files from the following directories:

* $HOME/.snmp/mibs
* /usr/local/share/snmp/mibs


## Running the script

```
$ db_generate.py -h
```

## Edit the substitution file

The substitution file follows the pattern:
```
{RECORD_TYPE, DEVICE_TYPE, INDEX, PROPERTY, OID, MASK, DESC}
```
and for the sensors:
```
{RECORD_TYPE, DEVICE_TYPE, INDEX, PROPERTY, EGU, OID, MASK, DESC}
```

To get properly named PVs it is recommended to manually edit e.g. DEVICE_TYPE and INDEX.
