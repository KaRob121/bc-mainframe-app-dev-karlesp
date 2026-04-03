       Identification Division.
      *****************************************************************
      * Sending a BMS map to a 3270 device.
      *****************************************************************
       Program-Id. HELLO3.
       Data Division.
       Working-Storage Section.
           copy HELOMSD.
       Procedure Division.
           EXEC CICS SEND
               FROM(HELOMAPO)
               MAP('HELOMAP')
               MAPSET('HELOMSD')
               ERASE
               FREEKB
           END-EXEC
           EXEC CICS
               RETURN
           END-EXEC
           .
