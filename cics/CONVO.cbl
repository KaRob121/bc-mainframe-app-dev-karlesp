       Identification Division.
      *****************************************************************
      * Conversational design
      *****************************************************************
       Program-Id. CONVO.
       Data Division.
       Working-Storage Section.
       01  WS-Work-Fields.
           05  filler                 pic x value 'N'.
               88  End-of-Session           value 'Y'.
           05  WS-Request-Count       pic s9(05) packed-decimal
                                            value zero.
           05  WS-Resp                pic s9(08) binary.
           copy DFHAID.
           copy CONVMS.
       Procedure Division.
           move low-values to CONVMAPO
           perform 1000-Prompt-User
           perform 2000-Process-Request
               until End-of-Session
           perform 9000-Return
           .
       1000-Prompt-User.
           EXEC CICS SEND
               FROM(CONVMAPO)
               MAP('CONVMAP')
               MAPSET('CONVMS')
               ERASE
               FREEKB
           END-EXEC
           .
       2000-Process-Request.
           EXEC CICS RECEIVE
               INTO(CONVMAPI)
               MAP('CONVMAP')
               MAPSET('CONVMS')
               RESP(WS-RESP)
           END-EXEC
           if WS-RESP = DFHRESP(MAPFAIL)
               continue
           end-if
           if EIBAID equal DFHPF12
               set End-of-Session to true
           else
               add 1 to WS-Request-Count
               move WS-Request-Count to COUNTO
               move REQI to VALO
               move spaces to REQO
               perform 1000-Prompt-User
           end-if
           .
       9000-Return.
           EXEC CICS SEND CONTROL
               ERASE
               FREEKB
           END-EXEC
           EXEC CICS
               RETURN
           END-EXEC
           .
