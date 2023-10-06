#!/usr/bin/env python3

import logging
import argparse
import re
from pathlib import Path
from typing import Dict

import yaml
from snmphandler import SnmpHandler

TEMPLATE_FILE = Path("snmp_pv.template")
TEMPLATE_SENSOR_FILE = Path("snmp_sensor_pv.template")

DEVICE_DICT = Path("device_dict.yaml")

logger = logging.getLogger()
logging.basicConfig(format="%(levelname)s:%(message)s", level=logging.DEBUG)


def get_parser():
    parser = argparse.ArgumentParser(
        formatter_class=argparse.ArgumentDefaultsHelpFormatter
    )

    # Use subparsers for different SNMP versions
    subparsers = parser.add_subparsers(dest='version')
    parser_snmp_v2c = subparsers.add_parser('2c', help="SNMP v2c")
    parser_snmp_v3 = subparsers.add_parser('3', help="SNMP v3")

    parser.add_argument("host_ip", help="IP address of the SNMP device")
    parser.add_argument(
        "device",
        choices=["nVent", "EMX"],
        help="Type of device",
    )

    parser.add_argument(
        "--substitution-filename",
        "-s",
        metavar="",
        required=False,
        default="subst/auto_substitution_file.substitution",
        help="Name and path of substitution file",
    )

    parser_snmp_v3.add_argument(
        "--user",
        "-u",
        required=True,
        help="Security name",
    )

    parser_snmp_v3.add_argument(
        "--authentication-protocol",
        "-a",
        choices=["MD5", "SSH"],
        default="MD5",
        help="Authentication protocol",
    )

    parser_snmp_v3.add_argument(
        "--authentication-protocol-pass-phrase",
        "-A",
        help="Authentication protocol pass phrase",
    )

    parser_snmp_v3.add_argument(
        "--level",
        "-l",
        choices=["noAuthNoPriv", "authNoPriv", "authPriv"],
        default="authPriv",
        help="Security level",
    )

    parser_snmp_v3.add_argument(
        "--privacy-protocol",
        "-x",
        choices=["DES", "AES"],
        default="DES",
        help="Privacy protocol",
    )

    parser_snmp_v3.add_argument(
        "--privacy-protocol-pass-phase",
        "-X",
        help="Privacy protocol pass phrase",
    )

    return parser


class OID:
    def __init__(
        self,
        oid_node: str,
        index: str,
        mask: str,
        record_type: str,
        device_type: str,
        property_: str,
    ) -> None:

        self.sensor_record = False  # assume until proven otherwise

        self.oid_node = oid_node
        self.index = index
        self.mask = mask
        self.record_type = record_type
        self.device_type = device_type
        self.property_ = property_

        self.egu: str
        self.description: str
        self.sensor_type: str

    def get_description(self, snmphandler: SnmpHandler) -> None:
        """Get description from MIB file

        The actual device is not involved in this operation
        """
        self.description = (
            snmphandler.snmptranslate(self.oid_node, "DESCRIPTION", "-Td")
        ).strip()

        # trim description to fit epics field
        self.description = self.description[:39]
        if not re.search('"$', self.description):
            self.description += '"'

    def get_sensor_type(
        self, mib_dict: Dict[str, str], snmphandler: SnmpHandler
    ) -> None:

        sensor_type_oid_node = mib_dict["#sensor-type"]["oid_root_node"] + self.index
        self.sensor_type = get_oid_value(sensor_type_oid_node, snmphandler)

        if self.sensor_type == "onOff":
            # use sensor subtype instead (e.g. smokeDetection)
            sensor_type_oid_node = (
                mib_dict["#sensor-subtype"]["oid_root_node"] + self.index
            )
            self.sensor_type = get_oid_value(sensor_type_oid_node, snmphandler)

    def get_property(self) -> None:
        with open(DEVICE_DICT) as d:
            device_dict = yaml.safe_load(d)
        property_dict = device_dict["property_dict"]
        self.property_ = property_dict.get(self.sensor_type, self.sensor_type)

    def get_egu(self, mib_dict: Dict[str, str], snmphandler: SnmpHandler) -> None:
        sensor_egu_oid_node = mib_dict["#sensor-egu"]["oid_root_node"] + self.index
        self.egu = get_oid_value(sensor_egu_oid_node, snmphandler)
        if self.egu == "none":
            self.egu = "''"

    def to_epics_record(self) -> str:
        """Convert OID object to EPICS record definition for substitution file

        Align all the fields to create a readable substitution file.
        """

        if self.index == ".0":
            index_compressed = "-:"
        else:
            index_compressed = "-" + self.index.replace(".", "") + ":"

        sensor_index = index_compressed

        # the f-string format does not allow backslash so add the "" now
        self.property_ = '"' + self.property_ + '"'

        if self.sensor_record:
            record_str = (
                f"{'{':>13}"
                f"{(self.record_type + ','):{11}}"
                f"{('-' + self.device_type + ','):{12}}"
                f"{(index_compressed + ','):{8}}"
                f"{(sensor_index + ','):{8}}"
                f"{(self.property_ + ','):{32}}"
                f"{(self.egu + ','):{12}}"
                f"{(self.oid_node + ','):{52}}"
                f"{(self.mask + ','):{12}}"
                f"{self.description}"
                "}"
            )
        else:
            record_str = (
                f"{'{':>13}"
                f"{(self.record_type +','):{11}}"
                f"{('-' + self.device_type + ','):{12}}"
                f"{(index_compressed + ','):{8}}"
                f"{(self.property_ + ','):{32}}"
                f"{(self.oid_node + ','):{52}}"
                f"{(self.mask + ','):{12}}"
                f"{self.description}"
                "}"
            )

        return record_str


def get_oid_value(type_oid_node: str, snmphandler: SnmpHandler) -> str:
    # e.g. "STRING: Temperature Cooler"
    # or "INTEGER: onOff(14)"
    field = snmphandler.snmpget(type_oid_node, "-Ov")

    # remove unwanted ->
    # e.g. "TemperatureCooler"
    # or "onOff"
    pattern = r"\S*:\s((?:(?![\(]).)*)"
    match = re.match(pattern, field)
    value = re.sub(r"\s", "", match.group(1))

    return value


def parse_through_mib_dict(
    device_type: str,
    snmphandler: SnmpHandler,
    mib_dict: Dict[str, str],
    substitution_file: Path,
    tmp_sensor_substitution_file: Path,
) -> None:
    """Generate substitutions file from MIB dictionary.

    Parse through mib_dict (retrieved from device_dict.py)
    and get relevant information for each OID.
    """
    with open(DEVICE_DICT) as d:
        device_dict = yaml.safe_load(d)

    for key, val in mib_dict.items():
        # get node and record type for the key (e.g. "sensor-value")
        # as specified in node file
        # e.g. "LHX-MIB::measurementsSensorValue" and "ai"
        root_node = val["oid_root_node"]
        record_type = val["EPICS_record_type"]

        with substitution_file.open("a") as f:
            f.write(f"\t\t\t#{root_node}\n")

        oid_outputs = snmphandler.snmpwalk(root_node)

        # perform operations on each OID (node) in subtree
        for oid_output in oid_outputs:
            # e.g.
            # oid_output = "EMD-MIB::deviceMACAddress.034 = STRING: 0:d:5d:18:8e:6a\n"
            pattern = r"^([A-Z]*(-MIB::)[a-zA-Z]*(\.[\S]*))\s=\s(\S*:)\s((?:(?!$).)*)"
            match = re.match(pattern, oid_output)
            if match.group(2):  # check that it is actually an OID "-MIB::"
                oid = OID(
                    oid_node=match.group(1),
                    index=match.group(3),
                    mask=match.group(4),
                    record_type=record_type,
                    device_type=device_type,
                    property_=key,
                )
                logger.info(f"Processing {oid.oid_node}")

                oid.get_description(snmphandler)

                # get the sensor type (e.g. 'TT') for all sensor records
                if key in [
                    "#sensor-type",
                    "#sensor-subtype",
                    "sensor-value",
                    "#sensor-egu",
                    "#sensor-dd",
                    "#sensor-lopr",
                    "#sensor-lolo",
                    "#sensor-low",
                    "#sensor-hopr",
                    "#sensor-hihi",
                    "#sensor-high",
                ]:
                    oid.get_sensor_type(mib_dict, snmphandler)
                    # translate
                    sensor_type_dict = device_dict["sensor_type_dict"]

                    if oid.sensor_type in sensor_type_dict:
                        oid.device_type = sensor_type_dict[oid.sensor_type]
                    else:
                        # if not known just use the device (e.g EMX)
                        pass

                # get correct property and EGU field for the sensor value records
                if key == "sensor-value":
                    oid.sensor_record = True
                    oid.get_property()
                    # get the unit
                    oid.get_egu(mib_dict, snmphandler)

                # transform all OID info into a record line
                record = oid.to_epics_record()

                # write it to the .substitution file
                with substitution_file.open(
                    "a"
                ) as f, tmp_sensor_substitution_file.open("a") as f_sensor:
                    if key == "sensor-value":
                        f_sensor.writelines(record + "\n")
                    else:
                        f.writelines(record + "\n")


def main(args):
    snmphandler = SnmpHandler(logger, args)

    # For some devices it is necessary to parse through multiple mib files,
    # e.g. for the EMX both EMD-MIB and LHX-MIB are used.
    with open(DEVICE_DICT) as d:
        device_dict = yaml.safe_load(d)

    substitution_file = Path(args.substitution_filename)

    # for the sensor measurement records:
    tmp_sensor_substitution_file = Path("tmp_sensor_substitution_file.txt")

    with substitution_file.open("w") as f, tmp_sensor_substitution_file.open(
        "w"
    ) as f_sensor:
        f.write("file " + "$(TOP)/db/" + str(TEMPLATE_FILE) + "\n{\n")
        f_sensor.write("file " + "$(TOP)/db/" + str(TEMPLATE_SENSOR_FILE) + "\n{\n")
    with substitution_file.open("a") as f, tmp_sensor_substitution_file.open(
        "a"
    ) as f_sensor:
        f.write(
            f"{'pattern {':>13}RECORD_TYPE, DEVICE_TYPE, INDEX, "
            "PROPERTY, OID, MASK, DESC}\n"
        )
        f_sensor.write(
            f"{'pattern {':>13}RECORD_TYPE, DEVICE_TYPE, INDEX, SENSOR_INDEX,  "
            "PROPERTY, EGU, OID, MASK, DESC}\n"
        )

    logger.info("Walking")

    mib_dicts = device_dict["device_mib_dict"][args.device]

    for mib_dict in mib_dicts:
        parse_through_mib_dict(
            args.device,
            snmphandler,
            mib_dict,
            substitution_file,
            tmp_sensor_substitution_file,
        )

    logger.info(f"Writing to {args.substitution_filename}")

    with substitution_file.open("a") as f, tmp_sensor_substitution_file.open(
        "a"
    ) as f_sensor:
        f_sensor.write("}\n")
        f.write("}\n")

    # now combine the files:
    with substitution_file.open("+a") as f, tmp_sensor_substitution_file.open(
        "r"
    ) as f_sensor:
        # appending the contents of the second file to the first file
        f.write(f_sensor.read())

    # remove the temp file
    tmp_sensor_substitution_file.unlink()

    logger.info("Finished.")


if __name__ == "__main__":
    parser = get_parser()
    args = parser.parse_args()
    main(args)
