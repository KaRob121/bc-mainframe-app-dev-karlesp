       Identification Division.
       Program-ID. FTHIAVG.
       Data Division.
       Working-Storage Section.

           EXEC SQL INCLUDE SQLCA END-EXEC.
           EXEC SQL INCLUDE THROWS END-EXEC.
           EXEC SQL INCLUDE PLAYERS END-EXEC.
           EXEC SQL INCLUDE TEAMS END-EXEC.

       01  FILLER              pic x value "N".
           88  End-of-Data           value "Y".
       01  WS-Message          pic x(80).
       01  WS-Place            pic s9(5) packed-decimal value zero.
       01  WS-Place-Display    pic zz,zz0.
       01  WS-Error-SQLCODE    pic s999 sign leading separate.

       Procedure Division.

           EXEC SQL DECLARE FT_CUR CURSOR FOR
               SELECT
                   PLAYER_NAME,
                   TEAM_NAME,
                   FT_AVG_POINTS                                        OINTS
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
           perform 1000-Fetch-and-Display
               until End-of-Data

           EXEC SQL CLOSE FT_CUR END-EXEC
           goback
           .
       1000-Fetch-and-Display.
           EXEC SQL FETCH FT_CUR
               INTO
                   :TEAM_NAME,
                   :PLAYER_NAME,
                   :FT_AVG_POINTS
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
           perform 2100-Increment-Place
           display "Player: " PLAYER_NAME of DCLPLAYERS
           display "Team:   " TEAM_NAME of DCLTEAMS
           display "Avg Points: " FT_AVG_POINTS of DCLTHROWS
           .
       2100-Increment-Place.
           add 1 to WS-Place
           move WS-Place to WS-Place-Display
           .
       9000-Bail.
           move SQLCODE to WS-Error-SQLCODE
           display "SQL Error: SQLCODE " WS-Error-SQLCODE
           move 12 to return-code
           goback
           .
