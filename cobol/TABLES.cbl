       Identification Division.
       Program-Id. TABLES.
      *****************************************************************
      * Sandbox for exploring COBOL tables.
      *****************************************************************
       Data Division.
       Working-Storage Section.

      * Populating a table with static data via REDEFINES
       
       01  Airport-Table-Data.
           05  filler                   pic x(3) value "ATL".
           05  filler                   pic x(4) value "KATL".
           05  filler                   pic x(30) value "Atlanta".
           05  filler                   pic x(70) value 
               "Hartsfield-Jackson Atlanta International Airport".
           05  filler                   pic x(3) value "CAN".
           05  filler                   pic x(4) value "ZGGG".
           05  filler                   pic x(30) value "Guangzhou".
           05  filler                   pic x(70) value 
               "Guangzhou Baiyun International Airport".
           05  filler                   pic x(3) value "DEN".
           05  filler                   pic x(4) value "KDEN".
           05  filler                   pic x(30) value "Denver".
           05  filler                   pic x(70) value 
               "Denver International Airport".
           05  filler                   pic x(3) value "DFW".
           05  filler                   pic x(4) value "KDFW".
           05  filler                   pic x(30) value "Dallas".
           05  filler                   pic x(70) value 
               "Dallas-Ft. Worth International Airport".
           05  filler                   pic x(3) value "IST".
           05  filler                   pic x(4) value "LTFM".
           05  filler                   pic x(30) value "Istanbul".
           05  filler                   pic x(70) value 
               "Istanbul Airport".
           05  filler                   pic x(3) value "LKA".
           05  filler                   pic x(4) value "WRKL".
           05  filler pic x(30) value "Nusa Tenggara Timur".
           05  filler                   pic x(70) value 
               "Gewayentana Airport".
           05  filler                   pic x(3) value "LOS".
           05  filler                   pic x(4) value "DNMM".
           05  filler                   pic x(30) value "Lagos".
           05  filler                   pic x(70) value 
               "Murtala Mohammed International Airport".
           05  filler                   pic x(3) value "SYD".
           05  filler                   pic x(4) value "YSSY".
           05  filler                   pic x(30) value "Sydney".
           05  filler                   pic x(70) value 
               "Sydney Airport".

       01  Airport-Table redefines Airport-Table-Data.
           05  Airport-Info occurs 8 times
                   ascending Airport-IATA-Code
                   indexed by Airport-Ix.
               10  Airport-IATA-Code    pic x(3).
               10  Airport-ICAO-Code    pic x(4).
               10  Airport-Nearest-City pic x(30).
               10  Airport-Name         pic x(70).

       01  Search-City-Name             pic x(30).
       01  Search-IATA-Code             pic x(3).
       01  Inv-Total-Display            pic $,$$$,$$$,$$$,$$9.99+.

      * Defining a two-level table 
       
       01  Inv-Line-Count               pic 9(2).
       01  Invoice.
           05  Inv-Total                pic s9(13)v99.
           05  Inv-Line occurs 1 to 10 times
                        depending on Inv-Line-Count
                        indexed by Line-Ix.
               10  Inv-Line-Total       pic s9(11)v99.
               10  Inv-Line-Item occurs 10 times
                                 indexed by Item-Ix.
                   15  Inv-Product      pic x(8).
                   15  Inv-Unit-Price   pic s9(5)v99.
                   15  Inv-Quantity     pic 9(5).
                   15  Inv-Ext-Price    pic s9(7)v99.
                   15  Inv-Sales-Tax    pic sv9(5).

       Procedure Division.

      * Serial search example
      * Guangzhou is in the table. Fargo is not in the table.

           move "Guangzhou" to Search-City-Name
      *    move "Fargo" to Search-City-Name
       
           search Airport-Info
               varying Airport-Ix
               at end
                   display "No airport found near " Search-City-Name
               when Airport-Nearest-City(Airport-Ix)
                       equal Search-City-Name
                   display Airport-Name(Airport-Ix) 
                   display "    is near " Search-City-Name
           end-search
            
      * Binary search example
      * The airport table is already in order by IATA code. 

           move "LOS" to Search-IATA-Code

           search all Airport-Info
               at end
                   display "No airport found with IATA code "
                       Search-IATA-Code
               when Airport-IATA-Code(Airport-Ix)
                       is equal to Search-IATA-Code
                   display "IATA Code " Search-IATA-Code 
                       " is assigned to " Airport-Name(Airport-Ix)
           end-search
            
      * Iterating over a table with PERFORM 
       
      * Put some test data into the table 
           move 2 to Inv-Line-Count
           move "ABCDEFGH" to Inv-Product    ( 1 1 )
           move +15.47     to Inv-Unit-Price ( 1 1 )
           move 2          to Inv-Quantity   ( 1 1 )
           move +0.025     to Inv-Sales-Tax  ( 1 1 )
           move "BCDEFGHI" to Inv-Product    ( 1 2 )
           move +66.12     to Inv-Unit-Price ( 1 2 )
           move 1          to Inv-Quantity   ( 1 2 )
           move +0.025     to Inv-Sales-Tax  ( 1 2 )
           move "CDEFGHIJ" to Inv-Product    ( 1 3 )
           move +2.88      to Inv-Unit-Price ( 1 3 )
           move 6          to Inv-Quantity   ( 1 3 )
           move +0.000     to Inv-Sales-Tax  ( 1 3 )
           move "DEFGHIJK" to Inv-Product    ( 1 4 )
           move +29.99     to Inv-Unit-Price ( 1 4 )
           move 3          to Inv-Quantity   ( 1 4 )
           move +0.025     to Inv-Sales-Tax  ( 1 4 )
           move spaces     to Inv-Product    ( 1 5 )
           move "EFGHIJKL" to Inv-Product    ( 2 1 )
           move +3.50      to Inv-Unit-Price ( 2 1 )
           move 9          to Inv-Quantity   ( 2 1 )
           move +0.025     to Inv-Sales-Tax  ( 2 1 )
           move "FGHIJKLM" to Inv-Product    ( 2 2 )
           move +2.44      to Inv-Unit-Price ( 2 2 )
           move 8          to Inv-Quantity   ( 2 2 )
           move +0.025     to Inv-Sales-Tax  ( 2 2 )
           move spaces     to Inv-Product    ( 2 3 )

      * Iterate over the table to compute the invoice total
           move zero to Inv-Total
           perform with test before
                   varying Line-Ix from 1 by 1
                   until Line-Ix greater than Inv-Line-Count
               move zero to Inv-Line-Total(Line-Ix)
               perform with test before
                       varying Item-Ix from 1 by 1
                       until Item-Ix greater than 10
                       or Inv-Product(Line-Ix, Item-Ix) = spaces
                   compute Inv-Ext-Price(Line-Ix, Item-Ix) =
                       (Inv-Unit-Price(Line-Ix, Item-Ix)
                        * Inv-Quantity(Line-Ix, Item-Ix))
                       * (1 + Inv-Sales-Tax(Line-Ix, Item-Ix))
                   end-compute
                   add Inv-Ext-Price(Line-Ix, Item-Ix)
                       to Inv-Line-Total(Line-Ix)
                   end-add
               end-perfgorm
               add Inv-Line-Total(Line-Ix) to Inv-Total
           end-perform
            
           move Inv-Total to Inv-Total-Display
           display "Inv-Total: " Inv-Total-Display

           goback
           .                           












