# Inter-operatbility

This directory contains some tests for verifying inter-operability
between Prolog protobufs and other languages. The initial version of
this uses Python, but it is anticipated that other languages will be
added in the future (e.g., C++, JavaScript).

The tests are *not* part of the standard release process because they
require having the protobuf compiler (`protoc`) installed and also a
version of Python 3.

To run the tests:
```
make test
make clean
```
You can specify these additional variables:
```
make PROTOC=/path/to/protoc PYTHON=/path/to/python3 SWIPL=/path/to/swipl test
```

The tests require the Python protobuf support. One way of installing it is:
```
python3 -m pip install protobuf
```

## Future work

These tests write into the current directory. This prevents using a
read-only source tree, amongst other things. The tests should be
modified to use a separate "build" directory.
