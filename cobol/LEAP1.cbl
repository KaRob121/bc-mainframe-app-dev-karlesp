       Identification Division.
       Program-Id. LEAP1.
      *****************************************************************
      * Demonstrates calling a subprogram statically and passing a
      * single parameter area by reference.
      *****************************************************************
       Data Division.
       Working-Storage Section.
       01  Parms.
           copy LEAPPARM.
       01  Work-Areas.
           05  The-Year          pic x(09) value "The year ".
           05  The-Word-Is       pic x(04) value " is ".
           05  The-Word-Not      pic x(04) value "not ".
           05  A-Leap-Year       pic x(12) value "a leap year.".
           05  Output-Message    pic x(80).
       Procedure Division.
           move 1999 to Parm-Year
           perform Check-Leap-Year
           move 2000 to Parm-Year
           perform Check-Leap-Year
           move 2024 to Parm-Year
           perform Check-Leap-Year
           move 2100 to Parm-Year
           perform Check-Leap-Year
           goback
           .
       Check-Leap-Year.
           set Parm-Normal-Year to true
           call "ISLEAP1" using
               by reference Parms
           end-call
           move spaces to Output-Message 
           if Parm-Normal-Year
               string The-Year delimited by size
                      Parm-Year delimited by size
                      The-Word-Is delimited by size
                      The-Word-Not delimited by size
                      A-Leap-Year delimited by size
                   into Output-Message
               end-string
           else
               string The-Year delimited by size
                      Parm-Year delimited by size
                      The-Word-Is delimited by size
                      A-Leap-Year delimited by size
                   into Output-Message
               end-string
           end-if
           display Output-Message
           .




