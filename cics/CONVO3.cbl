       Identification Division.
      *****************************************************************
      * Pseudoconversational design using Channel and Container.
      *****************************************************************
       Program-Id. CONVO3.
       Data Division.
       Working-Storage Section.
       01  WS-Work-Fields.
           05  WS-Resp                pic s9(08) binary.
           05  Display-RESP           pic 9(08).
           05  WS-Error-Message       pic x(79).
           05  WS-Channel-Name        pic x(16) value "Con-Channel".
           05  WS-Container-Name      pic x(16) value "Con-Container".
           05  filler                 pic x value space.
               88  New-Session              value "N".
               88  Continuing-Session       value "C".
       01  CTR-Container-Data.
           05  CTR-Request-Count      pic s9(05) packed-decimal.
           copy DFHAID.
           copy CONVMS.
       Procedure Division.
           perform 7000-Get-Container
           if New-Session
               move zero to CTR-Request-Count
               move low-values to CONVMAPO
               perform 1000-Prompt-User
           end-if
           perform 2000-Process-Request
           .
       1000-Prompt-User.
           perform 7100-Put-Container
           EXEC CICS SEND
               FROM(CONVMAPO)
               MAP('CONVMAP')
               MAPSET('CONVMS')
               ERASE
               FREEKB
           END-EXEC
           EXEC CICS RETURN
               TRANSID(EIBTRNID)
               CHANNEL(WS-Channel-Name)
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
           add 1 to CTR-Request-Count
           move CTR-Request-Count to COUNTO
           move REQI to VALO
           move spaces to REQO
           perform 1000-Prompt-User
           .
       7000-Get-Container.
           EXEC CICS GET CONTAINER(WS-Container-Name)
               CHANNEL(WS-Channel-Name)
               INTO(CTR-Container-Data)
               FLENGTH(length of CTR-Container-Data)
               RESP(WS-Resp)
           END-EXEC
           if WS-Resp equal DFHRESP(NORMAL)
               set Continuing-Session to true
           else
               set New-Session to true
               move zero to CTR-Request-Count
           end-if
           .
       7100-Put-Container.
           EXEC CICS PUT CONTAINER(WS-Container-Name)
               CHANNEL(WS-Channel-Name)
               FROM(CTR-Container-Data)
               FLENGTH(length of CTR-Container-Data)
               RESP(WS-Resp)
           END-EXEC
           if WS-Resp equal DFHRESP(NORMAL)
               continue
           else
               string "EIBRESP on PUT CONTAINER was "
                          delimited by size
                      Display-RESP
                          delimited by size
                  into WS-Error-Message
              end-string
              perform 9900-Die
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
       9900-Die.
           EXEC CICS SEND TEXT
               FROM(WS-Error-Message)
               LENGTH(length of WS-Error-Message)
               ERASE
               FREEKB
           END-EXEC
           EXEC CICS
               RETURN
           END-EXEC
           .
