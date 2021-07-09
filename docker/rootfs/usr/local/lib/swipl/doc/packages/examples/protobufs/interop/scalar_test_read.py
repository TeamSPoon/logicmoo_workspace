# Test of scalar_test.proto, scalar_test.pl

import os
import unittest
from scalar_test_pb2 import Scalars1, Scalars2, Enum

class TestScalar(unittest.TestCase):

    def test_scalar1_enum(self):
        self.assertEqual(0, Enum.E1)
        self.assertEqual(1, Enum.Enum2)
        self.assertEqual(2, Enum.AnotherEnum)

    def test_scalar1a(self):
        m1a = Scalars1()
        with open("scalars1a_from_prolog.wire", "rb") as f:
            m1a.ParseFromString(f.read())
        self.assertEqual(m1a.v_double,    1.5)
        self.assertEqual(m1a.v_float,     2.5)
        self.assertEqual(m1a.v_int32,     3)
        self.assertEqual(m1a.v_int64,     4)
        self.assertEqual(m1a.v_uint32,    5)
        self.assertEqual(m1a.v_uint64,    6)
        self.assertEqual(m1a.v_sint32,    7)
        self.assertEqual(m1a.v_sint64,    8)
        self.assertEqual(m1a.v_fixed32,   9)
        self.assertEqual(m1a.v_fixed64,   10)
        self.assertEqual(m1a.v_sfixed32,  11)
        self.assertEqual(m1a.v_sfixed64,  12)
        self.assertEqual(m1a.v_bool,      False)
        self.assertEqual(m1a.v_string,    "écran 網目錦蛇")
        self.assertEqual(m1a.v_bytes,     b"\xc3\x28")
        self.assertEqual(m1a.v_enum,      Enum.E1)

    def test_scalar1b(self):
        m1b = Scalars1()
        with open("scalars1b_from_prolog.wire", "rb") as f:
            m1b.ParseFromString(f.read())
        self.assertEqual(m1b.v_double,    -1.5)
        self.assertEqual(m1b.v_float,     -2.5)
        self.assertEqual(m1b.v_int32,     -3)
        self.assertEqual(m1b.v_int64,     -4)
        self.assertEqual(m1b.v_uint32,     5+10000000)
        self.assertEqual(m1b.v_uint64,     6+10000000)
        self.assertEqual(m1b.v_sint32,    -7)
        self.assertEqual(m1b.v_sint64,    -8)
        self.assertEqual(m1b.v_fixed32,    9+1000)
        self.assertEqual(m1b.v_fixed64,   10+1000)
        self.assertEqual(m1b.v_sfixed32, -11)
        self.assertEqual(m1b.v_sfixed64, -12)
        self.assertEqual(m1b.v_bool,      True)
        self.assertEqual(m1b.v_string,    "[àmímé níshíkíhéꜜbì] reticulated python")
        self.assertEqual(m1b.v_bytes,     b"\xf0\x28\x8c\x28")  # See https://stackoverflow.com/questions/1301402/example-invalid-utf8-string
        self.assertEqual(m1b.v_enum,      Enum.AnotherEnum)


if __name__ == "__main__":
    unittest.main()
