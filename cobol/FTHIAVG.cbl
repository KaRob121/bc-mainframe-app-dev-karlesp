       Identification Division.
      **********************************************************************
      * Display the players with the highest average points on each team in
      * descending order by average points value. 
      ********************************************************************* 
       Program-ID. FTHIAVG.
       Data Division.
       Working-Storage Section.

           EXEC SQL INCLUDE SQLCA END-EXEC.
           EXEC SQL INCLUDE THROWS END-EXEC.
           EXEC SQL INCLUDE PLAYERS END-EXEC.
           EXEC SQL INCLUDE TEAMS END-EXEC.

       01  WS-Player-Name      pic x(100).
       01  WS-Team-Name        pic x(100).
       01  WS-Avg-Points       pic s9(5)v9 packed-decimal.
       01  WS-Column-Headings.
           05  filler pic x(07) value "Place".
           05  filler pic x(30) value "Player".
           05  filler pic x(30) value "Team".
           05  filler pic x(30) value "Avg Points".
       01  WS-Output-Line.
           05  OUT-Place           pic z,zzz.
           05  filler              pic x(02) value ". ".
           05  OUT-Player-Name     pic x(30).
           05  OUT-Team-Name       pic x(30).
           05  OUT-Avg-Points      pic z,zz9.9.
       01  FILLER              pic x value "N".
           88  End-of-Data           value "Y".
       01  WS-Message          pic x(80).
       01  WS-Place            pic s9(5) packed-decimal value zero.
       01  WS-Error-SQLCODE    pic s999 sign leading separate.

       Procedure Division.

           EXEC SQL DECLARE FT_CUR CURSOR FOR
               SELECT
                   P.PLAYER_NAME,
                   T.TEAM_NAME,
                   FT.FT_AVG_POINTS                                        OINTS
                       FROM LABSCHEMA.PLAYERS P
                   JOIN LABSCHEMA.THROWS FT
                     ON P.PLAYER_ID = FT.PLAYER_ID
                   JOIN LABSCHEMA.TEAMS T
                     ON P.TEAM_ID = T.TEAM_ID
                   WHERE (P.TEAM_ID, FT.FT_AVG_POINTS) IN (
                       SELECT P2.TEAM_ID, MAX(FT2.FT_AVG_POINTS)
                           FROM LABSCHEMA.PLAYERS P2
                   JOIN LABSCHEMA.THROWS FT2
                       ON P2.PLAYER_ID = FT2.PLAYER_ID
               GROUP BY P2.TEAM_ID
               )
               ORDER BY FT.FT_AVG_POINTS DESC
           END-EXEC
           EXEC SQL
               OPEN FT_CUR
           END-EXEC

           if SQLCODE not equal zero
               perform 9000-Bail
           end-if
           display WS-Column-Headings
           perform 1000-Fetch-and-Display
               until End-of-Data

           EXEC SQL CLOSE FT_CUR END-EXEC
           goback
           .
       1000-Fetch-and-Display.
           EXEC SQL FETCH FT_CUR
               INTO
                   :WS-Player-Name,
                   :WS-Team-Name,
                   :WS-Avg-Points
           END-EXEC

           if SQLCODE = 0
               perform 2000-Display-Values
           else if SQLCODE = 100
               set End-of-Data to true
           else
               perform 9000-Bail
           end-if
           .
       2000-Display-Values.
           add 1 to WS-Place
           move WS-Place to OUT-Place
           move WS-Player-Name to OUT-Player-Name
           move WS-Team-Name to OUT-Team-Name
           move WS-Avg-Points to OUT-Avg-Points
           display WS-Output-Line
           .
       9000-Bail.
           move SQLCODE to WS-Error-SQLCODE
           display "SQL Error: SQLCODE " WS-Error-SQLCODE
           move 12 to return-code
           goback
           .
