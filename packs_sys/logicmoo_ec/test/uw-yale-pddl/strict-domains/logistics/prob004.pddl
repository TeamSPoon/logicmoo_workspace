(DEFINE (PROBLEM ATT-LOG3)
   (:DOMAIN LOGISTICS-STRIPS)
   (:OBJECTS PACKAGE1 PACKAGE2 PACKAGE3 PACKAGE4 PACKAGE5 PACKAGE6
             PACKAGE7 PACKAGE8 PGH-TRUCK BOS-TRUCK LA-TRUCK AIRPLANE1
             AIRPLANE2 BOS-PO PGH-PO LA-PO BOS-AIRPORT PGH-AIRPORT
             LA-AIRPORT PGH BOS LA)
   (:INIT (OBJ PACKAGE1)
          (OBJ PACKAGE2)
          (OBJ PACKAGE3)
          (OBJ PACKAGE4)
          (OBJ PACKAGE5)
          (OBJ PACKAGE6)
          (OBJ PACKAGE7)
          (OBJ PACKAGE8)
          (TRUCK PGH-TRUCK)
          (TRUCK BOS-TRUCK)
          (TRUCK LA-TRUCK)
          (AIRPLANE AIRPLANE1)
          (AIRPLANE AIRPLANE2)
          (LOCATION BOS-PO)
          (LOCATION LA-PO)
          (LOCATION PGH-PO)
          (LOCATION BOS-AIRPORT)
          (LOCATION LA-AIRPORT)
          (LOCATION PGH-AIRPORT)
          (AIRPORT BOS-AIRPORT)
          (AIRPORT PGH-AIRPORT)
          (AIRPORT LA-AIRPORT)
          (CITY PGH)
          (CITY BOS)
          (CITY LA)
          (IN-CITY PGH-PO PGH)
          (IN-CITY PGH-AIRPORT PGH)
          (IN-CITY BOS-PO BOS)
          (IN-CITY BOS-AIRPORT BOS)
          (IN-CITY LA-PO LA)
          (IN-CITY LA-AIRPORT LA)
          (AT PACKAGE1 PGH-PO)
          (AT PACKAGE2 PGH-PO)
          (AT PACKAGE3 PGH-PO)
          (AT PACKAGE4 PGH-PO)
          (AT PACKAGE5 BOS-PO)
          (AT PACKAGE6 BOS-PO)
          (AT PACKAGE7 BOS-PO)
          (AT PACKAGE8 LA-PO)
          (AT AIRPLANE1 PGH-AIRPORT)
          (AT AIRPLANE2 PGH-AIRPORT)
          (AT BOS-TRUCK BOS-PO)
          (AT PGH-TRUCK PGH-PO)
          (AT LA-TRUCK LA-PO))
   (:GOAL (AND (AT PACKAGE1 BOS-PO))))