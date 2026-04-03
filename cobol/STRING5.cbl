       Identification Division.
       Program-Id. STRING5.
      *****************************************************************
      * Demonstrates various string/text processing features of COBOL.
      *****************************************************************
       Data Division.
       Working-Storage Section.

      * 77-level entries are deprecated. Use 01 instead.
       77  old-style-elementry-entry      pic x.

       01  Test-Values.
           05  SSN-on-the-Naughty-List    pic x(9) value "078051120".
           05  SSN-with-zero-Area         pic x(9) value "000887777".
           05  SSN-with-Nero-Area         pic x(9) value "666887777".
           05  SSN-with-zero-Group        pic x(9) value "111007777".
           05  SSN-with-zero-Serial       pic x(9) value "111880000".
           05  Official-Test-SSN          pic x(9) value "987654321".
           05  SSN-with-Area-over-740     pic x(9) value "741223333".
           05  Valid-SSN                  pic x(9) value "111223333".
           05  Employment-Date            pic x(8) value "20240813".
           05  Employee-Surname           pic x(5) value "SMITH".
           05  Employee-Tiebreak          pic x(4) value "J004". 

      * An elementary entry that isn't part of a group
       01  a-Social-Security-Number       pic x(9).

      * A group entry
       01  b-Social-Security-Number.
           05  b-SSN-Area                 pic x(3).
           05  b-SSN-Group                pic x(2).
           05  b-SSN-Serial               pic x(4).,

      * A group entry with 88-level entries
       01  Social-Security-Number.
           05  SSN.
               88  SSN-Invalid values 
                   "002281852" "042103580" "062360749" "078051120" 
                   "095073645" "128036045" "135016629" "141186941" 
                   "165167999" "165187999" "165207999" "165227999" 
                   "165247999" "189092294" "212097694" "212099999" 
                   "306302348" "308125070" "468288779" "549241889" 
                   "078051120" "219099999".
           05  SSN-Area                   pic x(3).
               88  SSN-Reserved-Area      value "987".
               88  SSN-Invalid-Area       values "000" "666".
           05  SSN-Group                  pic x(2).
               88  SSN-Invalid-Group      value "00".
           05  SSN-Serial                 pic x(4).
               88  SSN-Invalid-Serial     value "0000".

      * Contiguous group item to demonstrate 66-level RENAMES
           05  filler.
               10  Employment-Date-YYYYMMDD   pic x(8).
               10  Employee-Surname-1st-5     pic x(5).
               10  Employee-Surname-Tiebreak  pic x(4).

           66  Employee-Id renames SSN-Serial
                           through Employee-Surname-Tiebreak.

      * Group entry to format a Social Security Number.
      * Demonstrates MOVE CORRESPONDING.
       01  SSN-Formatted.
           05  SSN-Area                pic x(3).
           05  filler                  pic x value "-". 
           05  SSN-Group               pic x(2).
           05  filler                  pic x value "-". 
           05  SSN-Serial              pic x(4).

       Procedure Division.

           move Official-Test-SSN to a-Social-Security-Number
           display space
           display "Social Security Number standalone entry "
                   a-Social-Security-Number

           move Official-Test-SSN to b-Social-Security-Number
           display space
           display "Social Security Number group entry "
                   b-Social-Security-Number

           move Official-Test-SSN to SSN
           display space
           display "Format SSN standalone entry "
                   "using reference mmodification "
                   a-Social-Security-Number(1:3) "-"
                   a-Social-Security-Number(4:2) "-"
                   a-Social-Security-Number(6:)                   
 
           display space
           move corr SSN to SSN-Formatted
           display "MOVE CORRESPONDING to formatted SSN group entry "
                   SSN-Formatted

           move Employment-Date to Employment-Date-YYYYMMDD
           move Employee-Surname to Employee-Surname-1st-5
           move Employee-Tiebreak to Employee-Surname-Tiebreak
           move Official-Test-SSN to SSN
           display space
           display "Employee Id (66 RENAMES area) "
                   Employee-Id         

           display space 
           display "Using 88-level entries for data validation"
                   " with IF/ELSE"

           move SSN-on-the-Naughty-List to SSN
           perform Validate-SSN-with-IF
           move Official-Test-SSN       to SSN
           perform Validate-SSN-with-IF
           move SSN-with-zero-Area      to SSN
           perform Validate-SSN-with-IF
           move SSN-with-Nero-Area      to SSN
           perform Validate-SSN-with-IF
           move SSN-with-zero-Group     to SSN 
           perform Validate-SSN-with-IF
           move SSN-with-zero-Serial    to SSN
           perform Validate-SSN-with-IF
           move SSN-with-Area-over-740  to SSN
           perform Validate-SSN-with-IF
           move Valid-SSN               to SSN
           perform Validate-SSN-with-IF

           display space 
           display "Using 88-level entries for data validation"
                   " with EVALUATE"

           move SSN-on-the-Naughty-List to SSN
           perform Validate-SSN-with-EVALUATE
           move Official-Test-SSN       to SSN
           perform Validate-SSN-with-EVALUATE
           move SSN-with-zero-Area      to SSN
           perform Validate-SSN-with-EVALUATE
           move SSN-with-Nero-Area      to SSN
           perform Validate-SSN-with-EVALUATE
           move SSN-with-zero-Group     to SSN 
           perform Validate-SSN-with-EVALUATE
           move SSN-with-zero-Serial    to SSN
           perform Validate-SSN-with-EVALUATE
           move SSN-with-Area-over-740  to SSN
           perform Validate-SSN-with-EVALUATE
           move Valid-SSN               to SSN
           perform Validate-SSN-with-EVALUATE

           goback
           .
       Validate-SSN-with-IF.
           if SSN-Invalid 
               display "SSN " SSN " is on the invalid list"
           else if SSN-Reserved-Area
                    display "Area is reserved in " SSN
                else if SSN-Invalid-Area 
                         display "Area is invalid in " SSN
                     else if SSN-Invalid-Group
                              display "Group is invalid in " SSN
                          else if SSN-Invalid-Serial
                                   display "Serial is invalid in " SSN
                               else if SSN-Area of SSN > "740"
                                        display
                                        "Area above 740 not allowed"
                                    else 
                                        display 
                                        "SSN " SSN " appears valid"
                                    end-if
                               end-if
                          end-if
                     end-if
                end-if
           end-if    
           .
       Validate-SSN-with-EVALUATE.
           evaluate true
               when SSN-Invalid 
                    display "SSN " SSN " is on the invalid list"
               when SSN-Reserved-Area
                    display "Area is reserved in " SSN
               when SSN-Invalid-Area
                    display "Area is invalid in " SSN
               when SSN-Invalid-Group
                    display "Group is invalid in " SSN
               when SSN-Invalid-Serial
                    display "Serial is invalid in " SSN
               when other 
                    if SSN-Area of SSN > "740" 
                        display "Area above 740 not allowed"
                    else
                        display
                        "SSN " SSN " appears valid"
                    end-if
            end-evaluate
           .                                 