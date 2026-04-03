       Identification Division.
       Program-ID. THROWS1.
       Data Division.
       Working-Storage Section.

           EXEC SQL
               INCLUDE SQLCA
           END-EXEC.
           EXEC SQL
               INCLUDE THROWS
           END-EXEC.

       01  FILLER              pic x value "N".
           88  End-of-Data           value "Y".
       01  WS-Message          pic x(80).
       01  WS-Record-Count     pic s9(07) packed-decimal value +0.
       01  WS-Error-SQLCODE    pic s999 sign leading separate.

       Procedure Division.

           EXEC SQL DECLARE THROWS_CUR CURSOR FOR
               SELECT
                   THROW_ID,
                   PLAYER_ID,
                   FT_GAMES,
                   FT_ATTEMPTS,
                   FT_COMPLETED,
                   FT_THREE_POINTERS,
                   FT_PCT_COMPLETED,
                   FT_AVG_POINTS,
                   FT_LAST_UPDATE
               FROM LABSCHEMA.THROWS
           END-EXEC
           EXEC SQL
               OPEN THROWS_CUR
           END-EXEC

           if SQLCODE not equal zero
               perform 9000-Bail
           end-if
           perform 1000-Fetch-and-Display
               until End-of-Data

           display "Number of rows: " WS-Record-Count
           EXEC SQL CLOSE THROWS_CUR END-EXEC
           goback
           .
       1000-Fetch-and-Display.
           EXEC SQL FETCH THROWS_CUR
               INTO
                   :THROW-ID,
                   :PLAYER-ID,
                   :FT-GAMES,
                   :FT-ATTEMPTS,
                   :FT-COMPLETED,
                   :FT-THREE-POINTERS,
                   :FT-PCT-COMPLETED,
                   :FT-AVG-POINTS,
                   :FT-LAST-UPDATE:FT-LAST-UPDATE-IND
           END-EXEC

           if SQLCODE = 0
               add 1 to WS-Record-Count
               perform 2000-Display-Values
           else if SQLCODE = 100
               set End-of-Data to true
           else
               perform 9000-Bail
           end-if
           .
       2000-Display-Values.
           display "Throw ID: " THROW-ID
           display "Player ID: " PLAYER-ID
           display "FT Games: " FT-GAMES
           display "FT Attempts: " FT-ATTEMPTS
           display "FT Completed: " FT-COMPLETED
           display "FT Three Pointers: " FT-THREE-POINTERS
           display "FT Pct Completed: " FT-PCT-COMPLETED
           display "FT Avg Points: " FT-AVG-POINTS
           if FT-LAST-UPDATE-IND < 0
               display "FT Last Update: (NONE)"
           else
               display "FT Last Update: " FT-LAST-UPDATE
           end-if
           display " "
           .
       9000-Bail.
           move SQLCODE to WS-Error-SQLCODE
           display "SQL Error: SQLCODE " WS-Error-SQLCODE
           move 12 to return-code
           goback
           .
