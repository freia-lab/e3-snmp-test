# e3-snmp

Wrapper for the `snmp` module.

## Installation

```sh
$ make init patch build
$ make install
```

For further targets, type `make`.

## Usage

```sh
$ iocsh -r "snmp"
```

## Additional information

This wrapper contains a test suite (see `./docs/README/md`) as well as a database generation utility (under `./tools`). It also contains [MIB](https://en.wikipedia.org/wiki/Management_information_base)-files for a few select devices.

## Contributing

Contributions through pull/merge requests only.
