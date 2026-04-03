       Identification Division.
       Program-Id. UNSTR.
      *****************************************************************
      * UNSTRING sandbox
      *****************************************************************
       Data Division.
       Working-Storage Section.
       01  filler.
           05  Sending-Field                pic x(40).
           05  Receiving-Field-1            pic x(20).
           05  Field-1-Delimiter            pic x(2).
           05  Field-1-Count                pic 9(3).
           05  Receiving-Field-2            pic x(20).
           05  Field-2-Delimiter            pic x(2).
           05  Field-2-Count                pic 9(3).
           05  Receiving-Field-3            pic x(20).
           05  Field-3-Delimiter            pic x(2).
           05  Field-3-Count                pic 9(3).
           05  Receiving-Field-4            pic x(20).
           05  Field-4-Delimiter            pic x(2).
           05  Field-4-Count                pic 9(3).
           05  Delimiter-1                  pic x(2).
           05  Delimiter-2                  pic x(2).
           05  Tally-Field            pic s9(9) packed-decimal.
           05  Pointer-Field          pic s9(9) packed-decimal.
    
       Procedure Division.

           display "UNSTRING example 1: Simplest case"
           move "Alpha Beta" to Sending-Field
           perform Clear-Receiving-Fields
           unstring Sending-Field
               delimited by space
               into Receiving-Field-1
                    Receiving-Field-2
           end-unstring
           display "Sending-Field: " Sending-Field
           display "Receiving-Field-1: " Receiving-Field-1
           display "Receiving-field-2: " Receiving-Field-2
                                
           display space
           display "UNSTRING example 2: "
                   "Multiple occurrences of delimiter"
           move "Alpha   Beta" to Sending-Field
           perform Clear-Receiving-Fields
           unstring Sending-Field
               delimited by space
               into Receiving-Field-1 Receiving-Field-2
                    Receiving-Field-3 Receiving-Field-4
           end-unstring
           display "Sending-Field: " Sending-Field
           display "Receiving-Field-1: " Receiving-Field-1
           display "Receiving-field-2: " Receiving-Field-2
           display "Receiving-Field-3: " Receiving-Field-3
           display "Receiving-field-4: " Receiving-Field-4
                                
           display space
           display "UNSTRING example 3: "
                   "Multiple occurrences of delimiter with ALL"
           move "Alpha   Beta" to Sending-Field
           perform Clear-Receiving-Fields
           unstring Sending-Field
               delimited by all space
               into Receiving-Field-1 Receiving-Field-2
                    Receiving-Field-3 Receiving-Field-4
           end-unstring
           display "Sending-Field: " Sending-Field
           display "Receiving-Field-1: " Receiving-Field-1
           display "Receiving-field-2: " Receiving-Field-2
           display "Receiving-Field-3: " Receiving-Field-3
           display "Receiving-field-4: " Receiving-Field-4
                                
           display space
           display "UNSTRING example 4: "
                   "Delimiter consisting of more than one character"
           move "AlphaABBeta" to Sending-Field
           perform Clear-Receiving-Fields
           unstring Sending-Field
               delimited by "AB"
               into Receiving-Field-1 Receiving-Field-2
                    Receiving-Field-3 Receiving-Field-4
           end-unstring
           display "Sending-Field: " Sending-Field
           display "Receiving-Field-1: " Receiving-Field-1
           display "Receiving-field-2: " Receiving-Field-2
           display "Receiving-Field-3: " Receiving-Field-3
           display "Receiving-field-4: " Receiving-Field-4
                                
           display space
           display "UNSTRING example 5: "
                   "Multiple delimiters"
           move "Alpha Beta,Gamma Delta" to Sending-Field
           perform Clear-Receiving-Fields
           unstring Sending-Field
               delimited by space or ","
               into Receiving-Field-1 Receiving-Field-2
                    Receiving-Field-3 Receiving-Field-4
           end-unstring
           display "Sending-Field: " Sending-Field
           display "Receiving-Field-1: " Receiving-Field-1
           display "Receiving-field-2: " Receiving-Field-2
           display "Receiving-Field-3: " Receiving-Field-3
           display "Receiving-field-4: " Receiving-Field-4
                                
           display space
           display "UNSTRING example 6: "
                   "Multiple delimiters with overlapping values"
           move "AlphaXYZBetaYZGammaXYDelta" to Sending-Field
           perform Clear-Receiving-Fields
           unstring Sending-Field
               delimited by "XY" or "YZ"
               into Receiving-Field-1 Receiving-Field-2
                    Receiving-Field-3 Receiving-Field-4
           end-unstring
           display "Sending-Field: " Sending-Field
           display "Receiving-Field-1: " Receiving-Field-1
           display "Receiving-field-2: " Receiving-Field-2
           display "Receiving-Field-3: " Receiving-Field-3
           display "Receiving-field-4: " Receiving-Field-4
                                
           display space
           display "UNSTRING example 7: "
                   "Delimiters in fields"
           move "AlphaXYZBetaYZGammaXYDelta" to Sending-Field
           perform Clear-Receiving-Fields
           move "XY" to Delimiter-1
           move "YZ" to Delimiter-2
           unstring Sending-Field
               delimited by Delimiter-1 or Delimiter-2
               into Receiving-Field-1 Receiving-Field-2
                    Receiving-Field-3 Receiving-Field-4
           end-unstring
           display "Sending-Field: " Sending-Field
           display "Receiving-Field-1: " Receiving-Field-1
           display "Receiving-field-2: " Receiving-Field-2
           display "Receiving-Field-3: " Receiving-Field-3
           display "Receiving-field-4: " Receiving-Field-4
                                
           display space
           display "UNSTRING example 8: "
                   "Capturing the delimiter found for each field"
           move "AlphaXYZBetaYZGammaXYDelta" to Sending-Field
           perform Clear-Receiving-Fields
           move "XY" to Delimiter-1
           move "YZ" to Delimiter-2
           unstring Sending-Field
               delimited by Delimiter-1 or Delimiter-2
               into Receiving-Field-1 delimiter in Field-1-Delimiter
                    Receiving-Field-2 delimiter in Field-2-Delimiter
                    Receiving-Field-3 delimiter in Field-3-Delimiter
                    Receiving-Field-4 delimiter in Field-4-Delimiter
           end-unstring
           display "Sending-Field: " Sending-Field
           display "Receiving-Field-1: " Receiving-Field-1
                   " Field-1-Delimiter: " Field-1-Delimiter
           display "Receiving-field-2: " Receiving-Field-2
                   " Field-2-Delimiter: " Field-2-Delimiter
           display "Receiving-Field-3: " Receiving-Field-3
                   " Field-3-Delimiter: " Field-3-Delimiter
           display "Receiving-field-4: " Receiving-Field-4
                   " Field-4-Delimiter: " Field-4-Delimiter
                                
           display space
           display "UNSTRING example 9: "
                   "Capturing the number of characters found for each field"
           move "AlphaXYZBetaYZGammaXYDelta" to Sending-Field
           perform Clear-Receiving-Fields
           move "XY" to Delimiter-1
           move "YZ" to Delimiter-2
           unstring Sending-Field
               delimited by Delimiter-1 or Delimiter-2
               into Receiving-Field-1 delimiter in Field-1-Delimiter
                                      count in Field-1-Count
                    Receiving-Field-2 delimiter in Field-2-Delimiter
                                      count in Field-2-Count
                    Receiving-Field-3 delimiter in Field-3-Delimiter
                                      count in Field-3-Count
                    Receiving-Field-4 delimiter in Field-4-Delimiter
                                      count in Field-4-Count
           end-unstring
           display "Sending-Field: " Sending-Field
           display "Receiving-Field-1: " Receiving-Field-1
                   " Field-1-Delimiter: " Field-1-Delimiter
                   " Field-1-Count: " Field-1-Count
           display "Receiving-field-2: " Receiving-Field-2
                   " Field-2-Delimiter: " Field-2-Delimiter
                   " Field-2-Count: " Field-2-Count
           display "Receiving-Field-3: " Receiving-Field-3
                   " Field-3-Delimiter: " Field-3-Delimiter
                   " Field-3-Count: " Field-3-Count
           display "Receiving-field-4: " Receiving-Field-4
                   " Field-4-Delimiter: " Field-4-Delimiter
                   " Field-4-Count: " Field-4-Count
                                
           display space
           display "UNSTRING example 10: "
                   "Counting the number of fields extracted"
           move "AlphaXYZBetaYZGammaXYDelta" to Sending-Field
           perform Clear-Receiving-Fields
           move "XY" to Delimiter-1
           move "YZ" to Delimiter-2
           move zero to Tally-Field
           unstring Sending-Field
               delimited by Delimiter-1 or Delimiter-2
               into Receiving-Field-1 delimiter in Field-1-Delimiter
                                      count in Field-1-Count
                    Receiving-Field-2 delimiter in Field-2-Delimiter
                                      count in Field-2-Count
                    Receiving-Field-3 delimiter in Field-3-Delimiter
                                      count in Field-3-Count
                    Receiving-Field-4 delimiter in Field-4-Delimiter
                                      count in Field-4-Count
               tallying in Tally-Field                       
           end-unstring
           display "Sending-Field: " Sending-Field
           display "Receiving-Field-1: " Receiving-Field-1
                   " Field-1-Delimiter: " Field-1-Delimiter
                   " Field-1-Count: " Field-1-Count
           display "Receiving-field-2: " Receiving-Field-2
                   " Field-2-Delimiter: " Field-2-Delimiter
                   " Field-2-Count: " Field-2-Count
           display "Receiving-Field-3: " Receiving-Field-3
                   " Field-3-Delimiter: " Field-3-Delimiter
                   " Field-3-Count: " Field-3-Count
           display "Receiving-field-4: " Receiving-Field-4
                   " Field-4-Delimiter: " Field-4-Delimiter
                   " Field-4-Count: " Field-4-Count
           display "Tally-Field: " Tally-Field            
                                
           display space
           display "UNSTRING example 11: "
                   "Counting the number of characters examined"
           move "AlphaXYZBetaYZGammaXYDelta" to Sending-Field
           perform Clear-Receiving-Fields
           move "XY" to Delimiter-1
           move "YZ" to Delimiter-2
           move 1 to Pointer-Field
           unstring Sending-Field
               delimited by Delimiter-1 or Delimiter-2
               into Receiving-Field-1 delimiter in Field-1-Delimiter
                                      count in Field-1-Count
                    Receiving-Field-2 delimiter in Field-2-Delimiter
                                      count in Field-2-Count
                    Receiving-Field-3 delimiter in Field-3-Delimiter
                                      count in Field-3-Count
                    Receiving-Field-4 delimiter in Field-4-Delimiter
                                      count in Field-4-Count
               with pointer Pointer-Field                       
           end-unstring
           display "Sending-Field: " Sending-Field
           display "Receiving-Field-1: " Receiving-Field-1
                   " Field-1-Delimiter: " Field-1-Delimiter
                   " Field-1-Count: " Field-1-Count
           display "Receiving-field-2: " Receiving-Field-2
                   " Field-2-Delimiter: " Field-2-Delimiter
                   " Field-2-Count: " Field-2-Count
           display "Receiving-Field-3: " Receiving-Field-3
                   " Field-3-Delimiter: " Field-3-Delimiter
                   " Field-3-Count: " Field-3-Count
           display "Receiving-field-4: " Receiving-Field-4
                   " Field-4-Delimiter: " Field-4-Delimiter
                   " Field-4-Count: " Field-4-Count
           display "Pointer-Field: " Pointer-Field            

           display space
           display "UNSTRING example 12: ON OVERFLOW"
           perform Clear-Receiving-Fields
           move "Alpha,Beta,Gamma,Delta,Epsilon" to Sending-Field
           unstring Sending-Field
               delimited by ","
               into Receiving-Field-1
                    Receiving-Field-2
                    Receiving-Field-3
               on overflow
                    "Overflow condition was raised"
           end-unstring 
            
           goback
           .
       Clear-Receiving-Fields.
           move spaces to Receiving-Field-1 Field-1-Delimiter
                          Receiving-Field-2 Field-2-Delimiter
                          Receiving-Field-3 Field-3-Delimiter
                          Receiving-Field-4 Field-4-Delimiter
                          Delimiter-1
                          Delimiter-2
           move zeroes to Field-1-Count
                          Field-2-Count
                          Field-3-Count
                          Field-4-Count
           .                              