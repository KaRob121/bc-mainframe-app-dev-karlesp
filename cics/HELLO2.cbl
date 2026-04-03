       Identification Division.
      *****************************************************************
      * Sending plain text to a 3270 device.
      *****************************************************************
       Program-Id. HELLO2.
       Data Division.
       Working-Storage Section.
       01  Text-Area.
           05  Line-1      pic x(79) value spaces.
           05  Line-2      pic x(79) value spaces.
           05  Line-3      pic x(79) value spaces.
           05  Line-4      pic x(79) value spaces.
           05  Line-5      pic x(79) value "Hello, World!".
       Procedure Division.
           EXEC CICS SEND TEXT
               FROM(Text-Area)
               LENGTH(length of Text-Area)
               ERASE
               FREEKB
           END-EXEC
           EXEC CICS
               RETURN
           END-EXEC
           .
