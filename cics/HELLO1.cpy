       Identification Division.
      *****************************************************************
      * Writing to a 3270 device the hard way - hard-coded data stream.
      *****************************************************************
       Program-Id. HELLO1.
       Data Division.
       Working-Storage Section.
           copy HELLODS.
       Procedure Division.
           EXEC CICS SEND
               FROM(HELLO-DATA-STREAM)
               LENGTH(length of HELLO-DATA-STREAM)
               ERASE
               FREEKB
           END-EXEC
           EXEC CICS
               RETURN
           END-EXEC
           .
