(DEFINE (PROBLEM ASSEM-18)
   (:DOMAIN ASSEMBLY)
   (:OBJECTS SOCKET DEVICE DOODAD-3 KLUDGE-4 HACK-1 GIMCRACK-2 FROB
             VALVE TUBE PLUG DOODAD KLUDGE SPROCKET WIRE HACK BRACKET
             WIDGET UNIT CONNECTOR HOOZAWHATSIE THINGUMBOB FASTENER
             GIMCRACK CONTRAPTION FOOBAR WHATSIS COIL MOUNT - ASSEMBLY
             HAMMOCK CLAMP - RESOURCE)
   (:INIT (AVAILABLE DOODAD-3)
          (AVAILABLE KLUDGE-4)
          (AVAILABLE HACK-1)
          (AVAILABLE GIMCRACK-2)
          (AVAILABLE VALVE)
          (AVAILABLE TUBE)
          (AVAILABLE DOODAD)
          (AVAILABLE KLUDGE)
          (AVAILABLE WIRE)
          (AVAILABLE HACK)
          (AVAILABLE BRACKET)
          (AVAILABLE UNIT)
          (AVAILABLE CONNECTOR)
          (AVAILABLE HOOZAWHATSIE)
          (AVAILABLE THINGUMBOB)
          (AVAILABLE GIMCRACK)
          (AVAILABLE CONTRAPTION)
          (AVAILABLE FOOBAR)
          (AVAILABLE WHATSIS)
          (AVAILABLE COIL)
          (AVAILABLE MOUNT)
          (REQUIRES DEVICE CLAMP)
          (REQUIRES FROB HAMMOCK)
          (REQUIRES PLUG CLAMP)
          (REQUIRES SPROCKET CLAMP)
          (REQUIRES WIDGET CLAMP)
          (REQUIRES FASTENER CLAMP)
          (PART-OF DEVICE SOCKET)
          (PART-OF FROB SOCKET)
          (PART-OF PLUG SOCKET)
          (PART-OF WIDGET SOCKET)
          (PART-OF FASTENER SOCKET)
          (PART-OF DOODAD-3 DEVICE)
          (PART-OF KLUDGE-4 DEVICE)
          (PART-OF HACK-1 DEVICE)
          (PART-OF GIMCRACK-2 DEVICE)
          (PART-OF VALVE FROB)
          (PART-OF TUBE FROB)
          (PART-OF DOODAD PLUG)
          (PART-OF KLUDGE PLUG)
          (PART-OF SPROCKET PLUG)
          (PART-OF WIRE SPROCKET)
          (PART-OF HACK SPROCKET)
          (PART-OF BRACKET SPROCKET)
          (PART-OF UNIT WIDGET)
          (PART-OF CONNECTOR WIDGET)
          (PART-OF HOOZAWHATSIE WIDGET)
          (PART-OF THINGUMBOB WIDGET)
          (PART-OF GIMCRACK FASTENER)
          (PART-OF CONTRAPTION FASTENER)
          (PART-OF FOOBAR FASTENER)
          (PART-OF WHATSIS FASTENER)
          (PART-OF COIL FASTENER)
          (PART-OF MOUNT FASTENER)
          (ASSEMBLE-ORDER PLUG DEVICE SOCKET)
          (ASSEMBLE-ORDER WIDGET PLUG SOCKET)
          (ASSEMBLE-ORDER DOODAD-3 KLUDGE-4 DEVICE)
          (ASSEMBLE-ORDER HACK-1 DOODAD-3 DEVICE)
          (ASSEMBLE-ORDER GIMCRACK-2 DOODAD-3 DEVICE)
          (ASSEMBLE-ORDER VALVE TUBE FROB)
          (ASSEMBLE-ORDER DOODAD SPROCKET PLUG)
          (ASSEMBLE-ORDER HOOZAWHATSIE UNIT WIDGET)
          (ASSEMBLE-ORDER THINGUMBOB HOOZAWHATSIE WIDGET))
   (:GOAL (COMPLETE SOCKET)))