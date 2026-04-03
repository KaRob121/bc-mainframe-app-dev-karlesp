       Identification Division.
       Program-ID. TEAMLIST.
       Data Division.
       Working-Storage Section.

           EXEC SQL INCLUDE SQLCA END-EXEC.
           EXEC SQL INCLUDE PLAYERS END-EXEC.
           EXEC SQL INCLUDE TEAMS END-EXEC.

       01  WS-Team-Name        pic x(100).
       01  WS-Short-Team-Name  pic x(80).
           88  No-More-Teams   value high-values.
       01  WS-Player-Name      pic x(100).
       01  WS-No-Such-Team-Line.
           05  filler pic x(23) value "There is no team named ".
           05  WS-No-Such-Team-Name pic x(60).
       01  WS-Team-Name-Line.
           05  filler pic x(06) value "Team: ".
           05  WS-Team-Name-Out pic x(60).
       01  WS-Player-Name-Line.
           05  filler pic x(04) value spaces.
           05  WS-Player-Name-Out pic x(60).
       01  filler              pic x value "N".
           88  First-Time            value "Y".
           88  Not-First-Time        value "N".
       01  filler              pic x value "N".
           88  More-Rows             value "N".
           88  End-of-Data           value "Y".
       01  WS-SQL-Error.
           05  filler          pic x(08) value "SQLCODE ".
           05  WS-Error-SQLCODE  pic s999 sign leading separate.
           05  filler          pic x(78) value spaces.

       Procedure Division.

           EXEC SQL DECLARE TEAM_CUR SCROLL CURSOR FOR
               SELECT
                   T.TEAM_NAME,
                   P.PLAYER_NAME
                       FROM LABSCHEMA.TEAMS T
                   JOIN LABSCHEMA.PLAYERS P
                     ON P.TEAM_ID = T.TEAM_ID
                   WHERE T.TEAM_NAME = :WS-Team-Name
           END-EXEC

           perform 4000-Accept-Team-Name
           perform 1000-Process-Team
               until No-More-Teams
           goback
           .
       1000-Process-Team.

           EXEC SQL OPEN TEAM_CUR END-EXEC

           if SQLCODE not equal zero
               perform 9000-Bail
           end-if
           set First-Time to true
           set More-Rows to true
           perform 2000-Process-Players
               until End-of-Data

           EXEC SQL CLOSE TEAM_CUR END-EXEC

           perform 4000-Accept-Team-Name
           .
       2000-Process-Players.

           EXEC SQL FETCH TEAM_CUR
               INTO
                   :WS-Team-Name,
                   :WS-Player-Name
           END-EXEC

           if SQLCODE = 0
               perform 3000-Write-Output
           else if SQLCODE = 100
               set End-of-Data to true
               if First-Time
                  move WS-Team-Name to WS-No-Such-Team-Name
                  display WS-No-Such-Team-Line
               end-if
           else
               perform 9000-Bail
           end-if
           .
       3000-Write-Output.

           if First-Time
               move WS-Team-Name to WS-Team-Name-Out
               display WS-Team-Name-Line
               set Not-First-Time to true
           end-if
           move WS-Player-Name to WS-Player-Name-Out
           display WS-Player-Name-Line
           .
       4000-Accept-Team-Name.
           move high-values to WS-Short-Team-Name
           accept WS-Short-Team-Name

           if No-More-Teams
               display "No more teams"
           else
               move WS-Short-Team-Name to WS-Team-Name
               display WS-Team-Name
           end-if
           .
       9000-Bail.
           move SQLCODE to WS-Error-SQLCODE
           display WS-SQL-Error
           move 12 to return-code
           goback
           .
