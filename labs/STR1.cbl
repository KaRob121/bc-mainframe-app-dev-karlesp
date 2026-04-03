       Identification Division.
       Program-Id. STR1.
      *****************************************************************
      * Follow the instructions given in source comments.
      *****************************************************************
       Data Division.
       Working-Storage Section. 

       01  Generic-Output-Field     pic x(132).

      * Complete the entries under Street-Address so that:
      * (1) The items starting with Addr- are subordinate to
      *     Street-Address and all items from Addr-Street-Number
      *     through Addr-Zipcode are at the same level. 
      * (2) Addr-Zip-5 and Addr-Zip-4 are subordinate to Addr-Zipcode.
      * (3) Addr-Street-Name is 30 characters long.
      * (4) Addr-Street-Type is 12 characters long.

       01  Street-Address.
           05  Addr-Street-Number    pic x(6).
           05  Addr-Street-Name      pic x(??).
           05  Addr-Stree-Direction  pic x.
           05  Addr-Street-Type      pic x(??).
           04  Addr-Unit             pic x(6).
           05  Addr-Unit-Type        pic x(6).
           05  Addr-City             pic x(30).
           05  Addr-State            pic x(2).
           05  Addr-Zipcode.
               10  Addr-Zip-5        pic x(5).
               10  Addr-Zip-4        pic x(4).


       Procedure Division. 

      * Complete the following code to display the line indicated below.
      * Note: The rows of numbers are character positions in the output 
      * record, not values to display.
      *
      *          1         2         3         4         5         6
      * 123456789012345678901234567890123456789012345678901234567890
      *
      * Munster Mansion: 1313  Mockingbird                   Lane   

           move "1313" to Addr-Street-Number
           move "Lane" to Addr-Street-Type
           move "Mockingbird Heights" to Addr-City
           display ?

      * Complete the following code to use reference modification to 
      * populate Generic-Output-Field with the value indicated below 
      * and display it.     
      *
      *          1         2         3         4         5         6
      * 123456789012345678901234567890123456789012345678901234567890
      *
      * Seinfeld: 129 W. 81st St. Apt. 5A, New York, NY 10024   

           move spaces to Street-Address Generic-Output-Field
           move "129" to Addr-Street-Number 
           move "St." to Addr-Street-Type
           move "Apt." to Addr-Unit-Type
           move Addr-Street-Number(1:3) to Generic-Output-Field(1:3)
           display Generic-Output-Field

      * Complete the following code to use reference modification,
      * FUNCTION UPPER-CASE(x), and FUNCTION LOWER-CASE(x) to 
      * populate Generic-Output-Field with the value indicated below 
      * and display it.     
      *
      *          1         2         3         4         5         6
      * 123456789012345678901234567890123456789012345678901234567890
      *
      * Flintstones: 342 Gravelpit Terrace, Bedrock

          move spaces to Street-Address
          move "grAvElPiT" to Addr-Street-Name
          move "tERRace" to Addr-Street-Type
          display Generic-Output-Field  

           goback
           .
