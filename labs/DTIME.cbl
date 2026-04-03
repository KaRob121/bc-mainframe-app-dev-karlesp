       Identification Division.
       Program-Id. DTIME.
      *****************************************************************
      * Follow the instructions given in source comments.
      *****************************************************************
       Data Division.
       Working-Storage Section.

       01  Date-and-Time.
           05  DT-Year               pic 9(04).
           05  DT-Month              pic 9(02).
           05  DT-Day-of-Month       pic 9(02).
           05  DT-Hour               pic 9(02).
           05  DT-Minute             pic 9(02).
           05  DT-Second             pic 9(02).
           05  DT-Hundredth          pic 9(02).
           05  filler                pic x.
               88  DT-Behind-GMT     value "-".
               88  DT-Ahead-of-GMT   value "+".
               88  DT-GMT            value "0".
           05  DT-GMT-Offset-Hours   pic 9(02).
           05  DT-GMT-Offset-Minutes pic 9(02).

       01  Work-Dates.
           05  Date-1                pic 9(8).
           05  Date-2                pic 9(8).

       01  Day-of-Week-Code          pic 9.
       01  Day-of-Week-Values.
           05  filler pic x(9) value "Monday   ".
       01  Day-of-Week-Table redefines Day-of-Week-Values.
           05  Day-Name    occurs 1 times
                           indexed by Day-Index
                           pic x(9).






       Procedure Division.

      * Use the appropriate intrinsic function to get the current
      * system date and time and place the value in Date-and-Time.
      * Display the date and time in the following format:
      *
      *          1         2         3         4         5         6
      * 123456789012345678901234567890123456789012345678901234567890
      * The date/time: YYYY-MM-DD hh:mm:ss HH before GMT
      *                                       after GMT
      *                                       GMT

      * <your code goes here>

      * Complete the code for Day-of-Week-Values, following the
      * pattern suggested by the incomplete code. Adjust the occurs
      * clause value in Day-of-Week-Table accordingly.
      * Use the appropriate ACCEPT statement to obtain the day of
      * week code for the current system date.
      * Display messages of the form:
      *
      *          1         2         3         4         5         6
      * 123456789012345678901234567890123456789012345678901234567890
      * Today is a Wednesday
      * Tomorrow will be a Thursday

      * <your code goes here>
           display "Today is a ?????????"
           display "Tomorrow will be a ?????????"


      * Use the appropriate intrinsic functions and arithmetic
      * statements to calculate the number of days between two dates.

           move 20260524 to Date-1
           move 20251213 to Date-2
      *    display "There are ??? days between ??? and ???"  <= FIX
           move 20251031 to Date-1
           move 20240702 to Date-2
      *    display "There are ??? days between ??? and ???"  <= FIX


           goback
           .
