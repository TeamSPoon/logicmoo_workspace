# Demo of protobufs.

# To run this, you must install protobufs first. The easiest way is:
#    sudo apt install protobuf-compiler
# Or you can get the latest source and buid it:
#    https://github.com/protocolbuffers/protobuf/blob/master/src/README.md

# The demo is run by:
#   make check

# Assumption: protoc and swipl are in your $PATH

# If you're having problems with the gcc flags, you might need to set
# PKGCONFIG_PATH. For example, if you install the protobuf compiler
# in $HOME/.local (./configure --prefix=$HOME/.local), then set
# PKG_CONFIG_PATH=$HOME/.local/lib/pkgconfig

# You might also need to set LD_LIBRARY_PATH or change the rule for
# "foo" to be: $(CXX) -static -o $@ ...

# This demo was tested with protoc versions 3.6.1 and 3.15.8
# on Ubuntu 20.04.2.

.SUFFIXES: .proto .cpp .cc .o .proto.wire .pl .py .proto.rawdump .proto.dump .proto.rawdump

.PHONY: FORCE check clean docs
.PHONY: test_all test_basic_usage test_segment_messages test_send_command test_send_precompiled_command

.DEFAULT_GOAL=test_all

test_all: check test_basic_usage test_segment_messages test_send_command test_send_precompiled_command

# SHELL:=/bin/bash
# PROTOC=$(shell type -p protoc)
PROTOC=protoc
SWIPL=swipl

# The following correspond to the default rules in GNU Make 4.2.1
# (There are no *.c files, only C++)
# CXX=g++
RM=rm -f

# The following is essentially GNU Make's built-in rule::
# %o: %.cpp
# 	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c $^

# -Wall produces warnings from the generated *.pb.cc files
CFLAGS=-O3
CXXFLAGS=-O3
# flags from pkg-config: -pthread -lprotobuf -lpthread
CPPFLAGS:=$(shell pkg-config --cflags protobuf)
LDFLAGS:=$(shell pkg-config --libs protobuf)

# SRC_PROTOBUF is where you've downloaded the protobuf sources
# (e.g., by git clone). This is not needed for "make check".
SRC_PROTOBUF=$(HOME)/src/protobuf

# These files don't need to be kept, but can be useful for debugging:
.PRECIOUS: %.pb.cc %.pb.h

# Protobuf code generator for C++
%.pb.cc %.pb.h: %.proto
	$(PROTOC) --cpp_out=. $?

# Protobuf code generator for Python
%_pb2.py: %.proto
	$(PROTOC) --python_out=. $?

# Handle "-" in file name for generating Python protobuf code
pb_vector_pb2.py: pb-vector.proto
	$(PROTOC) --python_out=. $?

# Make a binary protobuf msg file (see
# $(SRC_PROTOBUF)/src/google/protobuf/descriptor.proto) with a
# FileDescriptorSet message, describing the .proto and all its
# dependencies:
%.proto.wire: %.proto
	$(PROTOC) --include_imports --descriptor_set_out=$@ $?

descriptor.proto.wire: $(SRC_PROTOBUF)/src/google/protobuf/descriptor.proto
	$(PROTOC) --include_imports --descriptor_set_out=$@ \
		-I$(SRC_PROTOBUF)/src/google/protobuf \
		descriptor.proto

foo.o: pb-vector.pb.h foo.cpp

# foo: foo.cpp pb-vector.pb.cc pb-vector.pb.h
foo: pb-vector.pb.o foo.o
	@# To run, you might require setting LD_LIBRARY_PATH or specify -static
	$(CXX) -o $@ $^ $(CXXFLAGS) $(CPPFLAGS) $(LDFLAGS)

tmp99.tmp: vector_demo.pl ../eventually_implies.pl
	$(SWIPL) -s vector_demo.pl -g make_tmp99 --

check: foo tmp99.tmp FORCE
	./foo <tmp99.tmp
	$(PROTOC) --decode_raw <tmp99.tmp
	$(PROTOC) --decode=Vector pb-vector.proto <tmp99.tmp

# Run the basic_usage example
test_basic_usage: vector_demo.pl FORCE
	$(SWIPL) -g test_basic_usage -g halt vector_demo.pl

# Run the protobuf_segment_messages test.
# See also rules  descriptor.proto.rawdump, descriptor.proto.dump

test_segment_messages: descriptor.proto.wire vector_demo.pl FORCE
	$(SWIPL) -g test_segment_messages -g halt vector_demo.pl

test_send_command: vector_demo.pl FORCE
	$(SWIPL) -g test_send_command -g halt vector_demo.pl

test_send_precompiled_command: vector_demo.pl FORCE
	$(SWIPL) -g test_send_precompiled_command -g halt vector_demo.pl

clean:
	@# TODO: special handling for descriptor.* files
	$(RM) -r foo *.o *.pb.cc *.pb.h *.tmp *_pb2.py *.proto.wire doc/ *.proto.rawdump addressbook.proto.dump

# Generate the documentation from ../protobufs.pl
# The result is in ../doc/protobufs.html
docs:
	cd .. && swipl -g 'use_module(library(doc_files))' \
		-g 'doc_save(.,[])' -g halt protobufs.pl

# TODO: remove the following

SRC_PROTOBUF=$(HOME)/src/protobuf

addressbook.proto.dump: addressbook.proto.wire
	$(PROTOC) -I. -I$(SRC_PROTOBUF)/src/google/protobuf \
		--decode=google.protobuf.FileDescriptorSet \
		descriptor.proto \
		<$? >$@

.PHONY: addressbook.segment
addressbook.segment: descriptor_proto.pl addressbook.proto.wire FORCE
	swipl -g "descriptor_segment('addressbook.proto.wire', Msg), print_term(Msg, []), halt." descriptor_proto.pl

.PHONY: descriptor.segment
descriptor.segment: descriptor_proto.pl descriptor.proto.wire FORCE
	swipl -g "descriptor_segment('descriptor.proto.wire', Msg), print_term(Msg, []), halt." descriptor_proto.pl

descriptor.proto.dump: descriptor.proto.wire
	$(PROTOC) -I. -I$(SRC_PROTOBUF)/src/google/protobuf \
		--decode=google.protobuf.FileDescriptorSet \
		descriptor.proto \
		<$? >$@

descriptor.proto.parse: descriptor.proto.dump parse_descriptor_proto_dump.pl FORCE
	swipl -g parse_descriptor -g halt parse_descriptor_proto_dump.pl

descriptor.proto.rawdump: descriptor.proto.wire
	$(PROTOC) --decode_raw <descriptor.proto.wire >$@

# Assume you've cloned git@github.com:protocolbuffers/protobuf.git (fetch) to $(HOME)/src.
# Note that ../golden_message.2.5.0 is the same as $(HOME)/src/protobuf/python/compatibility_tests/v2.5.0/tests/google/protobuf/internal/golden_message
dump_golden:
	$(PROTOC) -I$(HOME)/src/protobuf/src \
		--decode=protobuf_unittest.TestAllTypes \
		google/protobuf/unittest.proto \
		<../golden_message.2.5.0

# For testing: this is what the build does:

.PHONY: test_protobufs
test_protobufs:
	$(SWIPL) "-p" "foreign=" "-f" "none" "--no-packs" "-s" ../test_protobufs.pl "-g" "test_protobufs" "-t" "halt"

# For looking at the generated documentation.  This assumes that
# you're working in ~/src/contrib-protobufs and that there's also
# ~/src/swipl-devel (and you might wish to stash
# ~/src/swipl-devel/packages/protobufs somewhere).
# Also, cmake doesn't seem to play nicely with symlinks,
# so we can't just do
#    ln -s $(HOME)/src/contrib-protobufs $(HOME)/src/swipl-devel/packages/protobufs

.PHONY: test_doc
test_doc:
	rsync -avHx --delete $(HOME)/src/contrib-protobufs/ $(HOME)/src/swipl-devel/packages/protobufs/
	cd $(HOME)/src/swipl-devel && \
		mkdir -p build && \
		cd build && \
		cmake -G Ninja .. && \
		ninja && \
		gio open $(HOME)/src/swipl-devel/build/packages/protobufs/protobufs.html

