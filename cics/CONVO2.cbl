       Identification Division.
      *****************************************************************
      * Pseudoconversational design using COMMAREA
      *****************************************************************
       Program-Id. CONVO2.
       Data Division.
       Working-Storage Section.
       01  WS-Work-Fields.
           05  filler                 pic x value 'N'.
               88  End-of-Session           value 'Y'.
           05  WS-Request-Count       pic s9(05) packed-decimal.
           05  WS-Resp                pic s9(08) binary.
           copy DFHAID.
           copy CONVMS.
       Linkage Section.
       01  DFHCOMMAREA.
           05  LS-Request-Count       pic s9(05) packed-decimal.
       Procedure Division.
           if EIBCALEN equal zero
               move zero to WS-Request-Count
               move low-values to CONVMAPO
               perform 1000-Prompt-User
           else
               move LS-Request-Count to WS-Request-Count
           end-if
           perform 2000-Process-Request
           .
       1000-Prompt-User.
           EXEC CICS SEND
               FROM(CONVMAPO)
               MAP('CONVMAP')
               MAPSET('CONVMS')
               ERASE
               FREEKB
           END-EXEC
           EXEC CICS RETURN
               COMMAREA(WS-Request-Count)
               LENGTH(length of WS-Request-Count)
               TRANSID(EIBTRNID)
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
               perform 9000-Return
           end-if
           add 1 to WS-Request-Count
           move WS-Request-Count to COUNTO
           move REQI to VALO
           move spaces to REQO
           perform 1000-Prompt-User
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
