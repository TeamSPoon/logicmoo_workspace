# Test of scalar_test.proto, scalar_test.pl
# Assumes that swipl is on the execution path

import os
from scalar_test_pb2 import Scalars1, Scalars2, Enum

scalars1a = Scalars1(
    v_double   =  1.5,
    v_float    =  2.5,
    v_int32    =  3,
    v_int64    =  4,
    v_uint32   =  5,
    v_uint64   =  6,
    v_sint32   =  7,
    v_sint64   =  8,
    v_fixed32  =  9,
    v_fixed64  = 10,
    v_sfixed32 = 11,
    v_sfixed64 = 12,
    v_bool     = False,
    v_string   = "écran 網目錦蛇",
    v_bytes    = b"\xc3\x28",  # See https://stackoverflow.com/questions/1301402/example-invalid-utf8-string
    v_enum     = Enum.E1,
)
# Test negative values - unsigned are caught by the Python runtime,
# so they get the values "10000000+..."
scalars1b = Scalars1(
    v_double   =  -1.5,
    v_float    =  -2.5,
    v_int32    =  -3,
    v_int64    =  -4,
    v_uint32   =   5+10000000,
    v_uint64   =   6+10000000,
    v_sint32   =  -7,
    v_sint64   =  -8,
    v_fixed32  =   9+1000,
    v_fixed64  =  10+1000,
    v_sfixed32 = -11,
    v_sfixed64 = -12,
    v_bool     = True,
    v_string   = "[àmímé níshíkíhéꜜbì] reticulated python",
    v_bytes    = b"\xf0\x28\x8c\x28",  # See https://stackoverflow.com/questions/1301402/example-invalid-utf8-string
    v_enum     = Enum.AnotherEnum,
)

def main():
    with open("scalars1a_from_python.wire", "wb") as f:
        f.write(scalars1a.SerializeToString())
    with open("scalars1b_from_python.wire", "wb") as f:
        f.write(scalars1b.SerializeToString())



if __name__ == "__main__":
    main()

