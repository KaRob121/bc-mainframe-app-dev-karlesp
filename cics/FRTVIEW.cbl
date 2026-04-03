       Identification Division.
       Program-Id. FRTVIEW.
      *****************************************************************
      * View Free Throw statistics
      *****************************************************************
       Data Division.
       Working-Storage Section.
           copy DFHAID.
           copy DFHBMSCA.
           copy FRTVMSD2.
           copy FTCONST.
       01  Free-Throw-Record.
           copy FRTHROW.
       01  FT-Container-Data.
           05  CON-Page-Number                pic 9(04).
           05  CON-End-of-File-Reached        pic x.
               88  End-of-File-Reached        value 'Y'.
           05  CON-First-Key                  pic x(40).
           05  CON-Last-Key                   pic x(40).
       01  Container-to-Pass.
           05  First-Time-Flag                pic x.
           05  Record-to-Pass                 pic x(77).
           05  filler                         pic x(79).
       01  Pagination-Fields.
           05  PAG-Start-Key.
               10  filler                     pic x(39).
               10  PAG-Key-Bump               pic x.
           05  PAG-Subscript                  pic s9(4) binary.
           05  PAG-End-of-Data                pic x.
               88  End-of-Data                value 'Y'.
           05  Max-Rows-per-Page              pic s9(4) binary
                                              value +3.
       01  CICS-Response-Code                 pic s9(9) binary.
       01  Transaction-Id-to-Return           pic x(4).
       01  Transfer-to-Program                pic x(8).
       01  Display-Messages.
           05  Highlight-Control              pic x.
               88  Highlight-Error            value 'Y'.
           05  MSG-Out                        pic x(79).
           05  MSG-Undefined-PF-Key           pic x(16)
               value 'Undefined PF key'.
           05  MSG-Initial-Prompt.
               10  filler                     pic x(79)
                   value 'Provide filter criteria and press Enter, or om
      -                  'it criteria to see all records.'.
           05  MSG-Top-of-File                pic x(11)
               value 'Top of file'.
           05  MSG-No-More-Records            pic x(26)
               value 'No more records to display'.
           05  MSG-Container-Error.
               10  filler                     pic x(14)
               value 'GET CONTAINER('.
               10  ERR-Container-Name         pic x(16).
               10  filler                     pic x(10).
               10  ERR-Channel-Name           pic x(16).
               10  filler                     pic x(2) value ') '.
               10  ERR-Container-EIBRESP      pic 9(8).
               10  filler                     pic x value space.
               10  ERR-Container-EIBRESP2     pic 9(8).
           05  MSG-File-Error.
               10  ERR-Operation              pic x(12).
               10  filler                     pic x(6)
                   value ' file '.
               10  ERR-File-Name              pic x(8).
               10  filler                     pic x value space.
               10  ERR-EIBRESP                pic 9(8).
               10  filler                     pic x value space.
               10  ERR-EIBRESP2               pic 9(8).
       Procedure Division.
           EXEC CICS GET CONTAINER(FT-Container-Name)
               CHANNEL(FT-Channel-Name)
               INTO(FT-Container-Data)
               RESP(CICS-Response-Code)
           END-EXEC
           evaluate CICS-Response-Code
               when DFHRESP(NORMAL)
                   perform 1000-Process-User-Input
               when DFHRESP(CHANNELERR)
               when DFHRESP(CONTAINERERR)
                   perform 0000-First-Time
               when other
                   perform 8100-Container-Error
           end-evaluate
           .
       0000-First-Time.
      *****************************************************************
      * First entry into this program in a conversation.
      *****************************************************************
           initialize FT-Container-Data
           move zero to CON-Page-Number
           move "N" to CON-End-of-File-Reached
           move "N" to PAG-End-of-Data
           move low-values to PAG-Start-Key
           move low-values to FRTVMAPO
           move FT-View-TransId to TRANIDO
           perform 2000-Browse-Forward-Fill-Map
           perform 7100-Put-Container
           perform 9100-Display-and-Return
           .
       1000-Process-User-Input.
      *****************************************************************
      * Route control to the appropriate paragraph based on transid.
      *****************************************************************
           perform 1100-Receive-Map
           perform 1200-Check-Attention-Id-Keys
           perform 7100-Put-Container
           perform 9100-Display-and-Return
           .
       1100-Receive-Map.
      *****************************************************************
      * Receive mapped data from the terminal.
      *****************************************************************
           EXEC CICS RECEIVE
               MAP(FT-View-Map)
               MAPSET(FT-View-Mapset)
               INTO(FRTVMAPI)
               ASIS
           END-EXEC
           .
       1200-Check-Attention-Id-Keys.
      *****************************************************************
      * Handle AID keys that trigger special action.
      *****************************************************************
           evaluate EIBAID
               when DFHPF12
                   perform 9900-End-Transaction
               when DFHPF8
                   if End-of-File-Reached
                       subtract 1 from CON-Page-Number
                       move CON-First-Key to PAG-Start-Key
                   else
                       move CON-Last-Key to PAG-Start-Key
                       move high-values to PAG-Key-Bump
                   end-if
                   perform 2000-Browse-Forward-Fill-Map
               when DFHPF7
                   if CON-Page-Number less than 2
                       move zero to CON-Page-Number
                       move CON-First-Key to PAG-Start-Key
                       perform 2000-Browse-Forward-Fill-Map
                   else
                       move CON-First-Key to PAG-Start-Key
                       move space to CON-End-of-File-Reached
                       perform 2500-Browse-Backward-Fill-Map
                   end-if
               when DFHENTER
                   perform varying PAG-Subscript from 1 by 1
                           until PAG-Subscript
                               greater than Max-Rows-per-Page
                       evaluate ACTI(PAG-Subscript)
                           when "A"
                               move FT-Add-Program
                                    to Transfer-to-Program
                               perform 9400-Transfer
                           when "C"
                               perform 1300-Copy-Selected-Record
                               move FT-Update-Program
                                    to Transfer-to-Program
                               perform 9400-Transfer
                           when "D"
                               perform 1300-Copy-Selected-Record
                               move FT-Delete-Program
                                    to Transfer-to-Program
                               perform 9400-Transfer
                           when other
                               continue
                       end-evaluate
                   end-perform
               when other
                   perform 9900-End-Transaction
           end-evaluate
           .
       1300-Copy-Selected-Record.
      *****************************************************************
      * Copy the selected record fields from the input map to the
      * container to pass to the update or delete program.
      *****************************************************************
           move spaces to Container-to-Pass
           move "Y" to First-Time-Flag
           move TEAMI(PAG-Subscript) to FT-Team-Name
           move NAMEI(PAG-Subscript) to FT-Player-Name
           EXEC CICS BIF DEEDIT
               FIELD(GAMESI(PAG-Subscript))
               LENGTH(length of GAMESI(PAG-Subscript))
           END-EXEC
           move GAMESI(PAG-Subscript) to FT-Games
           EXEC CICS BIF DEEDIT
               FIELD(ATTSI(PAG-Subscript))
               LENGTH(length of ATTSI(PAG-Subscript))
           END-EXEC
           move ATTSI(PAG-Subscript) to FT-Attempts
           EXEC CICS BIF DEEDIT
               FIELD(COMPI(PAG-Subscript))
               LENGTH(length of COMPI(PAG-Subscript))
           END-EXEC
           move COMPI(PAG-Subscript) to FT-Completed
           EXEC CICS BIF DEEDIT
               FIELD(THREEI(PAG-Subscript))
               LENGTH(length of THREEI(PAG-Subscript))
           END-EXEC
           move THREEI(PAG-Subscript) to FT-Three-Pointers
           EXEC CICS BIF DEEDIT
               FIELD(PCTI(PAG-Subscript))
               LENGTH(length of PCTI(PAG-Subscript))
           END-EXEC
           move PCTI(PAG-Subscript) to FT-Pct-Completed
           EXEC CICS BIF DEEDIT
               FIELD(AVGI(PAG-Subscript))
               LENGTH(length of AVGI(PAG-Subscript))
           END-EXEC
           move AVGI(PAG-Subscript) to FT-Avg-Points
           move UPDI(PAG-Subscript)(1:4) to FT-Last-Update(1:4)
           move UPDI(PAG-Subscript)(6:2) to FT-Last-Update(5:2)
           move UPDI(PAG-Subscript)(9:2) to FT-Last-Update(7:2)
           move Free-Throw-Record to Record-to-Pass
           move Max-Rows-per-Page to PAG-Subscript
           .
       2000-Browse-Forward-Fill-Map.
      *****************************************************************
      * Browse to end of file or until output map is filled.
      *****************************************************************
           perform 2100-Start-Browse
           perform 2200-Read-Forward
           perform 2900-End-Browse
           .
       2100-Start-Browse.
      *****************************************************************
      * Initiate browse based on the key currently set.
      *****************************************************************
           move spaces to CON-First-Key CON-Last-Key
           EXEC CICS STARTBR
               FILE(FT-File-Name)
               RIDFLD(PAG-Start-Key)
               RESP(CICS-Response-Code)
           END-EXEC
           evaluate EIBRESP
               when DFHRESP(NORMAL)
                    continue
               when other
                    move "STARTBR" to ERR-Operation
                    perform 8200-File-Error
           end-evaluate
           .
       2200-Read-Forward.
      *****************************************************************
      * Read forward to end of file or until max lines on the map.
      *****************************************************************
           add 1 to CON-Page-Number
           move "N" to PAG-End-of-Data
           perform varying PAG-Subscript from 1 by 1
                   until PAG-Subscript greater than Max-Rows-per-Page
                   or End-of-Data
               perform 2300-Next-Record
           end-perform
           if End-of-Data
               set End-of-File-Reached to true
               subtract 1 from PAG-Subscript
               perform varying PAG-Subscript
                       from PAG-Subscript by 1
                       until PAG-Subscript
                             greater than Max-Rows-per-Page
                   move DFHPROTN to
                            ACTA(PAG-Subscript)
                            TEAMA(PAG-Subscript)
                            NAMEA(PAG-Subscript)
                            GAMESA(PAG-Subscript)
                            GAMESXA(PAG-Subscript)
                            ATTSA(PAG-Subscript)
                            ATTSXA(PAG-Subscript)
                            COMPA(PAG-Subscript)
                            COMPXA(PAG-Subscript)
                            THREEA(PAG-Subscript)
                            THREEXA(PAG-Subscript)
                            PCTA(PAG-Subscript)
                            PCTXA(PAG-Subscript)
                            AVGA(PAG-Subscript)
                            AVGXA(PAG-Subscript)
                            UPDA(PAG-Subscript)
                            UPDXA(PAG-Subscript)
               end-perform
           else
               perform 2400-Read-Next
               if EIBRESP equal DFHRESP(ENDFILE)
                   set End-of-Data to true
               end-if
           end-if
           .
       2300-Next-Record.
      *****************************************************************
      * Read the next record and populate the output map.
      *****************************************************************
           perform 2400-Read-Next
           evaluate EIBRESP
               when DFHRESP(NORMAL)
                    perform 4000-Copy-from-Record-to-Map
               when DFHRESP(ENDFILE)
                    set End-of-Data to true
               when other
                    move "READNEXT" to ERR-Operation
                    perform 8200-File-Error
           end-evaluate
           .
       2400-Read-Next.
      *****************************************************************
      * READNEXT command performed from multiple places.
      *****************************************************************
           EXEC CICS READNEXT
               FILE(FT-File-Name)
               RIDFLD(PAG-Start-Key)
               INTO(Free-Throw-Record)
               RESP(CICS-Response-Code)
           END-EXEC
           .
       2500-Browse-Backward-Fill-Map.
      *****************************************************************
      * Browse to beginning of file or until output map is filled.
      *****************************************************************
           perform 2100-Start-Browse
           perform 2800-Read-Previous
           perform 2600-Read-Backward
           perform 2900-End-Browse
           .
       2600-Read-Backward.
      *****************************************************************
      * Read backward and populate output map fields.
      *****************************************************************
           subtract 1 from CON-Page-Number
           move PAG-Start-Key to CON-Last-Key
           move spaces to PAG-End-of-Data
           perform varying PAG-Subscript from Max-Rows-per-Page by -1
                   until PAG-Subscript is less than 1
                   or End-of-Data
               perform 2700-Previous-Record
           end-perform
           .
       2700-Previous-Record.
      *****************************************************************
      * Read the previous record and populate the output map.
      *****************************************************************
           perform 2800-Read-Previous
           evaluate EIBRESP
               when DFHRESP(NORMAL)
                    perform 4000-Copy-from-Record-to-Map
               when DFHRESP(ENDFILE)
                    set End-of-Data to true
               when other
                    move "READPREV" to ERR-Operation
                    perform 8200-File-Error
           end-evaluate
           .
       2800-Read-Previous.
      *****************************************************************
      * READPREV command performed from multiple places.
      *****************************************************************
           EXEC CICS READPREV
               FILE(FT-File-Name)
               RIDFLD(PAG-Start-Key)
               INTO(Free-Throw-Record)
               RESP(CICS-Response-Code)
           END-EXEC
           .
       2900-End-Browse.
      *****************************************************************
      * Terminate the current browse and save first and last keys.
      *****************************************************************
           EXEC CICS ENDBR
               FILE(FT-File-Name)
           END-EXEC
           move TEAMO(1) to FT-Team-Name
           move NAMEO(1) to FT-Player-Name
           move FT-Record-Key to CON-First-Key
           if TEAMO(2) equal spaces
               move FT-Record-Key to CON-Last-Key
           else
               if TEAMO(3) equal spaces
                   move TEAMO(2) to FT-Team-Name
                   move NAMEO(2) to FT-Player-Name
                   move FT-Record-Key to CON-Last-Key
               else
                   move TEAMO(3) to FT-Team-Name
                   move NAMEO(3) to FT-Player-Name
                   move FT-Record-Key to CON-Last-Key
               end-if
           end-if
           .
       4000-Copy-from-Record-to-Map.
      *****************************************************************
      * Populate a line in the output map from the current record.
      *****************************************************************
            move FT-Team-Name to TEAMO(PAG-Subscript)
            move FT-Player-Name to NAMEO(PAG-Subscript)
            move FT-Games to GAMESO(PAG-Subscript)
            move FT-Attempts to ATTSO(PAG-Subscript)
            move FT-Completed to COMPO(PAG-Subscript)
            move FT-Three-Pointers to THREEO(PAG-Subscript)
            move FT-Pct-Completed to PCTO(PAG-Subscript)
            move FT-Avg-Points to AVGO(PAG-Subscript)
            move FT-Last-Update to UPDO(PAG-Subscript)
           .
       7100-Put-Container.
      *****************************************************************
      * Copy working storage data to the container.
      *****************************************************************
           EXEC CICS PUT CONTAINER(FT-Container-Name)
               CHANNEL(FT-Channel-Name)
               FROM(FT-Container-Data)
               FLENGTH(length of FT-Container-Data)
               RESP(CICS-Response-Code)
           END-EXEC
           if CICS-Response-Code equal DFHRESP(NORMAL)
               continue
           else
               perform 8100-Container-Error
           end-if
           .
       8100-Container-Error.
      *****************************************************************
      * Display response codes after unexpected condition when
      * getting a container.
      *****************************************************************
           move FT-Channel-Name to ERR-Channel-Name
           move FT-Container-Name to ERR-Container-Name
           move EIBRESP to ERR-Container-EIBRESP
           move EIBRESP2 to ERR-Container-EIBRESP2
           move MSG-Container-Error to MSGO
           perform 9100-Display-and-Return
           .
       8200-File-Error.
      *****************************************************************
      * Display response codes after unexpected condition when
      * performing a File Control operation.
      *****************************************************************
           move FT-File-Name to ERR-File-Name
           move EIBRESP to ERR-EIBRESP
           move EIBRESP2 to ERR-EIBRESP2
           move MSG-File-Error to MSG-Out
           set Highlight-Error to true
           perform 9100-Display-and-Return
           .
      *****************************************************************
      * Display the output map and do a pseudoconversational return.
      *****************************************************************
       9100-Display-and-Return.
           move CON-Page-Number to PAGEO
           if Highlight-Error
               move DFHRED to MSGC
               move space to Highlight-Control
           end-if
           if End-of-Data
               move DFHPROTN to HLPPF8A
               move MSG-No-More-Records to MSGO
           end-if
           if CON-Page-Number less than 2
               move DFHPROTN to HLPPF7A
               move MSG-Top-of-File to MSGO
           end-if
           EXEC CICS SEND
               MAP(FT-View-Map)
               MAPSET(FT-View-Mapset)
               FROM(FRTVMAPO)
               ERASE
               FREEKB
           END-EXEC
           EXEC CICS RETURN
               TRANSID(FT-View-TransId)
               CHANNEL(FT-Channel-Name)
           END-EXEC
           .
       9400-Transfer.
           EXEC CICS PUT CONTAINER(FT-Container-Name)
               CHANNEL(FT-Channel-Name)
               FROM(Container-to-Pass)
               FLENGTH(length of Container-to-Pass)
           END-EXEC
           EXEC CICS XCTL
               PROGRAM(Transfer-to-Program)
               CHANNEL(FT-Channel-Name)
           END-EXEC
           .
       9900-End-Transaction.
           EXEC CICS SEND CONTROL
               ERASE FREEKB
           END-EXEC
           EXEC CICS RETURN END-EXEC
           .
