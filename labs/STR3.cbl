       Identification Division.
       Program-Id. STR3.
      *****************************************************************
      * Follow the instructions given in source comments.
      *****************************************************************
       Data Division.
       Working-Storage Section. 

       01  Generic-Output-Field     pic x(132).

       01  Street-Address.
           05  Addr-Street-Number    pic x(6).
           05  Addr-Street-Name      pic x(30).
           05  Addr-Stree-Direction  pic x.
           05  Addr-Street-Type      pic x(12).
           05  Addr-Unit             pic x(6).
           05  Addr-Unit-Type        pic x(6).
           05  Addr-City             pic x(30).
           05  Addr-State            pic x(2).
           05  Addr-Zipcode.
               10  Addr-Zip-5        pic x(5).
               10  Addr-Zip-4        pic x(4).

       01  CSV-Record.
           05  filler pic x(80) value
               "1182,Euclid,N,Ave.,12G,Apt.,Cleveland,OH,441061234"  

       Procedure Division. 

      * Complete the following code to include missing move statements
      * and use STRING to populate Generic-Output-Field with the value 
      * indicated below. Handle values with embedded spaces using 
      * INSPECT and FUNCTION REVERSE as appropriate. 
      *
      * Display the result.
      *
      *          1         2         3         4         5         6
      * 123456789012345678901234567890123456789012345678901234567890
      *
      * Seinfeld: 129 W. 81st St. Apt. 5A, New York, NY 10024   

           move spaces to Street-Address Generic-Output-Field
           move "129" to Addr-Street-Number 
           move "W" to Addr-Street-Direction
           move "New   York" to Addr-City
           display Generic-Output-Field



      * Use UNSTRING to populate Street-Address from CSV-Record.
      * The format the values in Generic-Output-Field as shown below.
      * Use whatever COBOL statements you need to accomplish this.
      *
      *          1         2         3         4         5         6
      * 123456789012345678901234567890123456789012345678901234567890
      *
      * 1182 N. Euclid Ave., Apt. 12G, Cleveland, OH 44106-1234

      * <your code goes here>
           display Generic-Output-Field     

           goback
           .
