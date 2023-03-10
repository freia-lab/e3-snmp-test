import os
from typing import List
from logging import Logger


class SnmpManager:
    def __init__(self, cmd):
        self.cmd = cmd

    def __enter__(self):
        self.snmpresult = os.popen(self.cmd, mode="r")
        return self.snmpresult

    def __exit__(self, exc_type, exc_value, exc_traceback):
        self.snmpresult.close()


class SnmpHandler:
    def __init__(self, logger: Logger, host_ip: str) -> None:
        self.logger = logger
        self.host_ip = host_ip

        self.arg_protocol = "-v2c"
        self.arg_community = "-c public"

    def snmpwalk(self, oid_root: str, snmp_general_options=None) -> List[str]:
        """Wrapper for `snmpwalk`."""
        # e.g. "snmpwalk -v2c -c public 172.30.5.159 LHX-MIB::measurementsSensorValue"
        cmd = f"snmpwalk {self.arg_protocol} {self.arg_community} \
            {self.host_ip} {oid_root}"
        if snmp_general_options:
            cmd += f" {snmp_general_options}"

        out = []
        with SnmpManager(cmd) as p:
            while True:
                line = p.readline()
                if not line:
                    break
                out += [line]
        return out

    def snmpget(self, oid: str, snmp_general_options=None) -> str:
        """Wrapper for `snmpget`."""

        # e.g. "snmpget -v2c -c public 172.30.5.159 ...
        # LHX-MIB::measurementsSensorValue.5.0.1 -Ov"
        cmd = f"snmpget {self.arg_protocol} {self.arg_community} {self.host_ip} {oid}"
        if snmp_general_options:
            cmd += f" {snmp_general_options}"

        with SnmpManager(cmd) as p:
            out = p.read()
        return out

    def snmptranslate(
        self, oid_root: str, keyword: str, snmp_general_options=None
    ) -> str:
        """Wrapper for `snmptranslate`.

        Returns the line associated with the keyword.
        See MIB file for keywords.
        """
        # e.g. "snmptranslate LHX-MIB::measurementsSensorValue -Td"
        cmd = f"snmptranslate {oid_root}"
        if snmp_general_options:
            cmd += f" {snmp_general_options}"

        with SnmpManager(cmd) as p:
            # parse through the returned line
            while True:
                # e.g
                # "DESCRIPTION   "The descriptive ID of the sensor (e.g. Fan Speed 1)."
                line = p.readline()
                if not line:
                    break
                splitline = line.split(maxsplit=1)
                if splitline[0] == keyword:  # e.g. "DESCRIPTION"
                    return splitline[1]
