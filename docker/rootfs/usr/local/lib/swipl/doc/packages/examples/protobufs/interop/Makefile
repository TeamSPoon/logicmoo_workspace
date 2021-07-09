# Protobuf interoperability tests

.DEFAULT_GOAL=test
.PHONY=test clean FORCE run_scalar_test run_scalar_test_cc
# SHELL:=/bin/bash
# These files don't need to be kept, but can be useful for debugging:
.PRECIOUS: %.pb.cc %.pb.h %_pb.h

# PROTOC=$(shell type -p protoc)
# PYTHON=$(shell type -p python3)
PROTOC=protoc
PYTHON=python3
SWIPL=swipl

# -Wall produces warnings from the generated *.pb.cc files
CFLAGS=-O3
CXXFLAGS=-O3
# flags from pkg-config: -pthread -lprotobuf -lpthread
CPPFLAGS:=$(shell pkg-config --cflags protobuf)
LDFLAGS:=$(shell pkg-config --libs protobuf)

.SUFFIXES: .proto .py .pl .wire

FORCE:

test: scalars1_wire scalar_test_read_prolog scalar_test_read_cc scalar_test_read_python

# Protobuf code generator for Python and C++
%_pb2.py %.pb.h %.pb.cc: %.proto
	$(PROTOC) --python_out=. --cpp_out=. $?

.PHONY: scalar_test_read_prolog
scalar_test_read_prolog: scalar_test_read.pl scalars1b_from_cc.wire scalars1b_from_cc.wire
	$(SWIPL) scalar_test_read.pl

.PHONY: scalar_test_read_python
scalar_test_read_python: scalar_test_read.py scalars1a_from_prolog.wire scalars1b_from_prolog.wire
	$(PYTHON) scalar_test_read.py

.PHONY: scalar_test_read_cc
scalar_test_read_cc: scalar_test_read scalars1a_from_prolog.wire scalars1b_from_prolog.wire
	./scalar_test_read

.PHONY: scalars1_wire
scalars1_wire: scalars1a_from_prolog.wire scalars1b_from_prolog.wire \
	scalars1a_from_cc.wire scalars1b_from_cc.wire \
	scalars1a_from_python.wire scalars1b_from_python.wire
	diff scalars1a_from_prolog.wire scalars1a_from_cc.wire
	diff scalars1a_from_prolog.wire scalars1a_from_cc.wire
	diff scalars1a_from_python.wire scalars1a_from_python.wire
	diff scalars1b_from_prolog.wire scalars1b_from_cc.wire
	diff scalars1b_from_prolog.wire scalars1b_from_python.wire
	diff scalars1b_from_python.wire scalars1b_from_cc.wire

scalars1a_from_prolog.wire scalars1b_from_prolog.wire: scalar_test_write.pl scalar_test_common.pl
	$(RM) scalars1a_from_prolog.wire scalars1b_from_prolog.wire
	$(SWIPL) ./scalar_test_write.pl
	@# $(PROTOC) -I. --decode=scalar_test.Scalars1 scalar_test.proto <scalars1a_from_prolog.wire
	@# $(PROTOC) -I. --decode=scalar_test.Scalars1 scalar_test.proto <scalars1b_from_prolog.wire

scalars1a_from_cc.wire scalars1b_from_cc.wire: scalar_test_write
	$(RM) scalars1a_from_cc.wire scalars1b_from_cc.wire
	./scalar_test_write
	@# $(PROTOC) -I. --decode=scalar_test.Scalars1 scalar_test.proto <scalars1a_from_cc.wire
	@# $(PROTOC) -I. --decode=scalar_test.Scalars1 scalar_test.proto <scalars1b_from_cc.wire

scalars1a_from_python.wire scalars1b_from_python.wire: scalar_test_write.py scalar_test_pb2.py
	$(RM) scalars1a_from_python.wire scalars1b_from_python.wire
	$(PYTHON) scalar_test_write.py
	@# $(PROTOC) -I. --decode=scalar_test.Scalars1 scalar_test.proto <scalars1a_from_python.wire
	@# $(PROTOC) -I. --decode=scalar_test.Scalars1 scalar_test.proto <scalars1b_from_python.wire

scalar_test_write: scalar_test.pb.o scalar_test_write.o
	$(CXX) -o $@ $^ $(CXXFLAGS) $(CPPFLAGS) $(LDFLAGS)

scalar_test_write.o: scalar_test.pb.h scalar_test.pb.cc scalar_test_write.cc

scalar_test_read: scalar_test.pb.o scalar_test_read.o
	$(CXX) -o $@ $^ $(CXXFLAGS) $(CPPFLAGS) $(LDFLAGS)

scalar_test_read.o: scalar_test.pb.h scalar_test.pb.cc scalar_test_read.cc

clean:
	$(RM) -r *_pb2.py *.wire *.o *.pb.h *.pb.cc scalar_test_write scalar_test_read
