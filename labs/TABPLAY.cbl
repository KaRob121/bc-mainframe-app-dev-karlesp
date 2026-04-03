       Identification Division.
       Program-Id. TABPLAY.
      *****************************************************************
      * Follow the instructions given in source comments.
      *****************************************************************
       Data Division.
       Working-Storage Section.

       01  City-Data.
           05  filler                pic x(35) value
               "New York            NY008335897053K".
           05  filler                pic x(35) value
               "Los Angeles         CA003822238019O".
           05  filler                pic x(35) value
               "Chicago             IL002665039029O".
           05  filler                pic x(35) value
               "Houston             TX002302878000P".
           05  filler                pic x(35) value
               "Phoenix             AZ0016444090226".
           05  filler                pic x(35) value
               "Philadelphia        PA001567258022Q".
           05  filler                pic x(35) value
               "San Antonio         TX0014729090267".
           05  filler                pic x(35) value
               "San Diego           CA001381162004K".
           05  filler                pic x(35) value
               "Dallas              TX001299544003P".
           05  filler                pic x(35) value
               "Austin              TX0009744470131".
           05  filler                pic x(35) value
               "Jacksonville        FL0009713190229".
           05  filler                pic x(35) value
               "San Jose            CA000971233041N".
           05  filler                pic x(35) value
               "Fort Worth          TX0009567090411".
           05  filler                pic x(35) value
               "Columbus            OH0009079710025".
           05  filler                pic x(35) value
               "Charlotte           NC0008977200265".
           05  filler                pic x(35) value
               "Indianapolis        IN000880621007R".
           05  filler                pic x(35) value
               "San Francisco       CA000808437075}".
           05  filler                pic x(35) value
               "Seattle             WA0007492560166".
           05  filler                pic x(35) value
               "Denver              CO000713252003K".
           05  filler                pic x(35) value
               "Oklahoma City       OK0006948000202".

       01  City-Table redefines City-Data.
           05  City-Entry occurs 20 indexed by City-Index.
               10  City-Name             pic X(20).
               10  City-State            pic X(02).
      *            as of 2022
               10  City-Population       pic 9(09).
      *            percent change 2000-2022
               10  City-Pop-Change       pic sv9(04).

       01  Work-Fields.
           05  General-Counter           pic s9(3) packed-decimal.
           05  Display-Population        pic ZZZ,ZZZ,ZZZ,ZZ9.
           05  Display-Growth            pic +Z9.99.


       Procedure Division.

      * We did not cover sorting tables in class. You can find
      * information about it at
      * https://www.ibm.com/docs/en/cobol-zos/6.4
      *     ?topic=tables-sorting-table

           sort City-Entry descending City-Pop-Change
           display "The fastest-growing city is "
                   City-Name(1) ", " City-State(1)

           goback
           .
