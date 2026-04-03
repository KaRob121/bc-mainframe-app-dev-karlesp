       Identification Division.
      *****************************************************************
      * Show some fields from EIBLK.
      *****************************************************************
       Program-Id. SHOWEIB.
       Data Division.
       Working-Storage Section.
       01  Input-Area.
           05  filler          pic x(08).
           05  In-Name         pic x(40) value spaces.
       01  Input-Length        pic s9(04) comp.
       01  Output-Length       pic s9(04) comp.

       01  W-EIBDATE-Unpacked        pic 9(07).
       01  W-EIBDATE-Breakdown redefines W-EIBDATE-Unpacked.
           05  filler                pic x.
           05  W-EIBDATE-Century     pic x.
               88  Century-21        value "1".
           05  W-EIBDATE-Year        pic x(02).
           05  W-EIBDATE-Day         pic x(03).

       01  W-Date-as-Integer         pic 9(08).

       01  W-EIBDATE-Full-Year-X.
           05  W-EIBDATE-1st-2       pic 9(02).
           05  W-Full-EIBDATE-Year   pic 9(02).
           05  W-Full-EIBDATE-Day    pic 9(03).
       01  W-EIBDATE-Full-Year
           redefines W-EIBDATE-Full-Year-X pic 9(07).

       01  W-Converted-Date-X.
           05  W-Converted-YYYY      pic x(04).
           05  W-Converted-MM        pic x(02).
           05  W-Converted-DD        pic x(02).
       01  W-Converted-Date
           redefines W-Converted-Date-X pic 9(08).

       01  W-EIBTIME-X.
           05  filler                pic x.
           05  W-EIBTIME-Fields.
               10  W-EIBTIME-Hours       pic x(02).
               10  W-EIBTIME-Minutes     pic x(02).
               10  W-EIBTIME-Seconds     pic x(02).
       01  W-EIBTIME redefines W-EIBTIME-X pic 9(7).

       01  Output-Area.
           05  filler          pic x(79) value spaces.
           05  Greeting-Line.
               10  filler      pic x(11) value "Greetings, ".
               10  Out-Name    pic x(68) value spaces.
           05  filler          pic x(79) value spaces.
           05  filler.
               10  filler      pic x(06) value "Date: ".
               10  Out-Date.
                   15  W-Converted-YYYY  pic x(04).
                   15  filler            pic x value "/".
                   15  W-Converted-MM    pic x(02).
                   15  filler            pic x value "/".
                   15  W-Converted-DD    pic x(02).
               10  filler      pic x(63) value spaces.
           05  filler.
               10  filler      pic x(06) value "Time: ".
               10  Out-Time.
                   15  W-EIBTIME-Hours       pic x(02).
                   15  filler                pic x value ":".
                   15  W-EIBTIME-Minutes     pic x(02).
                   15  filler                pic x value ":".
                   15  W-EIBTIME-Seconds     pic x(02).
               10  filler      pic x(65) value spaces.
           05  filler.
               10  filler      pic x(09) value "Tran Id: ".
               10  Out-Tranid  pic x(04).
               10  filler      pic x(66) value spaces.

       Procedure Division.

           move length of Input-Area to Input-Length

           EXEC CICS RECEIVE
               INTO(Input-Area)
               LENGTH(Input-Length)
           END-EXEC

           move In-Name to Out-Name
           compute Output-Length =
               Input-Length - 8
           end-compute
           string Out-Name(1:Output-Length) delimited by size
                   "!" delimited by size
               into Out-Name
           end-string

           move EIBDATE to W-EIBDATE-Unpacked
           move W-EIBDATE-Year to W-Full-EIBDATE-Year
           move W-EIBDATE-Day to W-Full-EIBDATE-Day
           move 19 to W-EIBDATE-1st-2
           if Century-21
               add 1 to W-EIBDATE-1st-2
           end-if
           compute W-Date-as-Integer =
               function integer-of-day(W-EIBDATE-Full-Year)
           end-compute
           compute W-Converted-Date =
               function date-of-integer(W-Date-as-Integer)
           end-compute
           move corr W-Converted-Date-X to Out-Date

           move EIBTIME to W-EIBTIME
           move corr W-EIBTIME-Fields to Out-Time
           move EIBTRNID to Out-Tranid

           EXEC CICS SEND TEXT
               FROM(Output-Area)
               LENGTH(length of Output-Area)
               ERASE
               FREEKB
           END-EXEC

           EXEC CICS
               RETURN
           END-EXEC
           .
