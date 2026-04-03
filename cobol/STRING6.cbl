       Identification Division.
       Program-Id. STRING6.
      *****************************************************************
      * Demonstrate STRING and UNSTRING.
      *****************************************************************
       Data Division.
       Working-Storage Section.
       01  English-Name.
           05  EN-First-Name           pic x(40).
           05  EN-Middle-Name          pic x(40). 
           05  EN-Last-Name            pic x(40).
       01  Spanish-Name.
           05  ES-Primer-Nombre        pic x(40).
           05  ES-Segundo-Nombre       pic x(40).
           05  ES-Primer-Apellido      pic x(40).
           05  ES-Segundo-Apellido     pic x(40).
       01  Formatted-Name              pic x(160).
       01  Unformatted-Name            pic x(160).    

       01  Fake-CSV-File.
         05 filler pic x(40) value "ES,Santiago,Navarro,Hector,Manuel".
         05 filler pic x(40) value "EN;Philip;Aaron;Johnson"
       01  Fake-CSV-Records redefines Fake-CSV-File.
           05  Fake-CSV-Record occurs 2 indexed by CSV-ix.
               10  Language-Code       pic x(2).
                   88 English-Lang     value "EN".
                   88 Spanish-Lang     value "ES".
               10  filler              pic x.
               10  CSV-Data            pic x(37).
       01  Inspect-Fields.
           05  Tally-Field             pic s9(9) packed-decimal.
           05  Work-Field-1            pic x(80).
           05  Work-Field-2            pic x(80).
           05  Work-Field-3            pic x(80).
           05  Work-Field-4            pic x(80).
           05  Work-Field-5            pic x(80).
           05  Initial-Text-Value-1    pic x(80) value
               "The quick brown fox jumped over the lazy dog.".
           05  Initial-Text-Value-2    pic x(80) value
               "       Something  wicked    this way     comes".
           05  Long-Text               pic x(160).
           
       Procedure Division.
      * Format names with MOVE statements
      * Display "Adams, John Q."
           move "John"      to EN-First-Name
           move "Quincy"    to EN-Middle-Name
           move "Adams"     to EN-Last-Name

           display space
           display "Let's format 'John Quincy Adams'"
                   " as 'Adams, John Q.'"

           display space
           display "Plain MOVE statements (doesn't work)"
           display "<"
               EN-Last-Name ", "
               EN-First-Name " "
               EN-Middle-Name(1:1) "."
           ">"
           
           display space
           display "MOVE using FUNCTION LENGTH to try and get "
                   "the 'real' length (doesn't work)"                         
           display "<"
               EN-Last-Name(1: function(length(EN-Last-Name))) ", "
               EN-First-Name(1: function(length(EN-First-Name))) " "
               EN-Middle-Name(1:1) "."
           ">"
           
           display space
           display "Using STRING to assemble the name parts"
           display "(Works provided there are no embedded spaces)"
           move all "X" to formatted-name
           String EN-Last-Name delimited by space
                  ", " delimited by size
                  EN-First-Name delimited by space
                  space delimited by size
                  EN-Middle-Name(1:1) delimited by size
                  "." delimited by size 
              into Formatted-Name(6:)
          end-string
          display "<" Formatted-Name ">"

          display space 
          display "Using UNSTRING to extract comma-separated values "
                  "into individual fields"        
          move "Santiago,Navarro,Hector,Manuel" to Unformatted-Name
          display "Sending field for UNSTRING: " Unformatted-Name
          unstring Unformatted-Name
              delimited by ","
              into ES-Primer-Apellido
                   ES-Segundo-Apellido
                   ES-Primer-Nombre
                   ES-Segundo-Nombre
          end-unstring
          display "ES-Primer-Nombre: " ES-Primer-Nombre
          display "ES-Segundo-Nombre: " ES-Segundo-Nombre
          display "ES-Primer-Apellido: " ES-Primer-Apellido
          display "ES-Segundo-Apellido: " ES-Segundo-Apellido

          display space
          display "Using UNSTRING with multiple input formats"
          perform with test before
                  varying CSV-ix from 1 by 1
                  until CSV-ix greater than 2
              if English-Lang(CSV-ix)
                  unstring CSV-Data(CSV-ix)
                  delimited by ";"
                  into EN-First-Name
                       EN-Middle-Name
                       EN-Last-Name
                  end-unstring 
              else
                  unstring CSV-Data(CSV-ix)
                  delimited by ","
                  into ES-Primer-Apellido
                       ES-Segundo-Apellido
                       ES-Primer-Nombre
                       ES-Segundo-Nombre
                  end-unstring
              end-if
           end-perform 
           display "ES-Primer-Nombre: " ES-Primer-Nombre
           display "ES-Segundo-Nombre: " ES-Segundo-Nombre
           display "ES-Primer-Apellido: " ES-Primer-Apellido
           display "ES-Segundo-Apellido: " ES-Segundo-Apellido
           display "EN-First-Name: " EN-First-Name
           display "EN-Middle-Name: " EN-Middle-Name
           display "EN-Last-Name: " EN-Last-Name

           move Initial-Text-Value-1 to Long-Text
           move zero to Tally-Field
           inspect Long-Text
               tallying Tally-Field
               for all "o"
           display space 
           display "Count occurrences of a character using INSPECT"

           move Initial-Text-Value-2 to Long-Text
           move zero to Tally-Field
           inspect Long-Text
               tallying Tally-Field
               for leading spaces
           display space 
           display "Count leading spaces using INSPECT"
           display "There are " Tally-Field " leading spaces "
                   "in the text:"
           display "<" Long-Text ">"
           
           move zero to Tally-Field
           inspect Long-Text
               tallying Tally-Field
               for characters after initial "S"
           display space 
           display "Count characters after a given value"
           display "There are " Tally-Field " characters after "
                   "the initial 'S' in the text:"
           display "<" Long-Text ">"

           inspect Long-Text
               replacing first "wicked" by "gentle"
           display space
           display "Replace substring with value of equal length "
                   "using INSPECT"
           display "The modified phrase is:"
           display "<" Long-Text ">"

           move Initial-Text-Value-2 to Long-Text
           move zero to Tally-Field
           inspect Long-Text
               tallying Tally-Field
               for characters before initial "wicked"
           add 6 to Tally-Field
           move Long-Text(1:Tally-Field) to Work-Field-1
           add 1 to Tally-Field
           move Long-Text(Tally-Field:) to Work-Field-2
           string Work-Field-1(1:Tally-Field) delimited by size
                  " sweet" delimited by size 
                  Work-Field-2 delimited by size
               into Long-Text
           end-string           
           display space 
           display "Insert a value in the middle of text using "
                   "INSPECT, STRING, and Reference Modification"
           display "Text after insertion:"
           display "<" Long-Text ">"
                   
           move Initial-Text-Value-2 to Long-Text
           move zero to Tally-Field                                           
           inspect Long-Text
               tallying Tally-Field
               for leading spaces
           add 1 to Tally-Field
      * The following line causes a compiler warning - overlapping move           
           move Long-Text(Tally-Field:) to Long-Text    
           display space
           display "Remove leading spaces using INSPECT and "
                   "Reference Modification"
           display "Result:"
           display "<" Long-Text "<"

           unstring Long-Text
               delimited by all spaces
               into Work-Field-1
                    Work-Field-2
                    Work-Field-3
                    Work-Field-4
                    Work-Field-5
           move spaces to Long-Text
           string Work-Field-1 delimited by space
                  space delimited by size
                  Work-Field-2 delimited by space
                  space delimited by size
                  Work-Field-3 delimited by space
                  space delimited by size
                  Work-Field-4 delimited by space
                  space delimited by size
                  Work-Field-5 delimited by space
               into Long-Text
           end-string
           display space
           display "Remove extra embedded spaces from text "
                   "using UNSTRING and STRING"
           display "Result:"
           display "<" Long-Text "<"

           move Initial-Text-Value-1 to Long-Text
           inspect Long-Text
               replacing first "fox" by "dog"
           inspect Long-Text
               replacing first "dog" by "fox"
               after initial "dog"
           display space
           display "Use INSPECT REPLACING to modify text"
           display "Result:"
           display Long-Text

           move "Maria de Guadalupe" to ES-Primer-Nombre
           move "Teresa" to ES-Segundo-Nombre
           move "Navarro" to ES-Primer-Apellido
           move "Quintera" to ES-Segundo-Apellido

           move function reverse(ES-Primer-Nombre)
               to Work-Field-1
           move zero to Tally-Field
           inspect Work-Field-1
               tallying Tally-Field
               for leading spaces
           compute Tally-Field =
               length of ES-Primer-Nombre
               - Tally-Field
           end-compute
           string 
                   ES-Primer-Apellido delimited by space
                   space delimited by size
                   ES-Segundo-Apellido(1:1) delimited by size
                   ". " delimited by size
                   ES-Primer-Nombre(1:Tally-Field) delimited by size
                   space delimited by size
                   ES-Segundo-Nombre(1:1) delimited by size
                   "." delimited by size
               into Formatted-Name
           end-string
           display space
           display "Using INSPECT, FUNCTION REVERSE, Reference "
                   "Modification, "
           display "and STRING to format a name that has "
                   "embedded spaces"
           display "Result:"
           display Formatted-Name                                                                    

           goback
           .