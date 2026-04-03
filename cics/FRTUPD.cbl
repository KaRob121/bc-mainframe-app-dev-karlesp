       Identification Division.
       Program-Id. FRTUPD.
      *****************************************************************
      * Update a Free Throw record
      *****************************************************************
       Data Division.
       Working-Storage Section.
           copy DFHAID.
           copy DFHBMSCA.
           copy FRTUMSD.
           copy FTCONST.
       01  Free-Throw-Record.
           copy FRTHROW.
       01  FT-Container-Data.
           02  CON-First-Time                 pic x.
               88  First-Time                 value "Y".
           02  FT-Record.
           copy FRTHROW.
           02  Validation-Errors              pic x(79).
       01  CICS-Response-Code                 pic s9(9) binary.
       01  Display-Messages.
           05  Highlight-Control              pic x.
               88  Highlight-Error            value "Y".
           05  MSG-Out                        pic x(79).
           05  MSG-Undefined-PF-Key           pic x(16)
               value 'Undefined PF key'.
           05  MSG-Initial-Prompt.
               10  filler                     pic x(79)
               value "Overtype values to be changed".
           05  MSG-Record-Updated             pic x(79)
               value "Record successfully updated".
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
           perform 7000-Get-Container
           evaluate CICS-Response-Code
               when DFHRESP(NORMAL)
                   if First-Time
                       perform 0000-First-Time
                   else
                       perform 1000-Process-User-Input
                   end-if
               when DFHRESP(CHANNELERR)
               when DFHRESP(CONTAINERERR)
                   perform 9800-Start-Initial-Trans
               when other
                   perform 8100-Container-Error
           end-evaluate
           .
       0000-First-Time.
      *****************************************************************
      * First entry into this program in a conversation.
      *****************************************************************
           move spaces to CON-First-Time
           move low-values to FRTUMAPO
           perform 4000-Copy-from-Record-to-Map
           move FT-Update-TransId to TRANIDO
           move MSG-Initial-Prompt to MSGO
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
               MAP(FT-Add-Map)
               MAPSET(FT-Add-Mapset)
               INTO(FRTUMAPI)
               ASIS
           END-EXEC
           .
       1200-Check-Attention-Id-Keys.
      *****************************************************************
      * Handle AID keys that trigger special action.
      *****************************************************************
           evaluate EIBAID
               when DFHENTER
                   perform 2000-Validate-Input
               when DFHPF5
                   perform 5000-Save-Changes
               when DFHPF12
                   perform 9500-Transfer-to-View
               when other
                   move MSG-Undefined-PF-Key to MSGO
                   perform 7100-Put-Container
                   perform 9100-Display-and-Return
           end-evaluate
           .
       2000-Validate-Input.
      *****************************************************************
      * Validate newly-submitted and previously-stored input values.
      *****************************************************************
           if TEAML greater than 0
               move TEAMI to FT-Team-Name in FT-Container-Data
           end-if
           if NAMEL greater than 0
               move NAMEI to FT-Player-Name in FT-Container-Data
           end-if
           if GAMESL greater than 0
               EXEC CICS BIF DEEDIT
                   FIELD(GAMESI)
                   LENGTH(length of GAMESI)
               END-EXEC
               move GAMESI to FT-Games in FT-Container-Data
           end-if
           if ATTSL greater than 0
               EXEC CICS BIF DEEDIT
                   FIELD(ATTSI)
                   LENGTH(length of ATTSI)
               END-EXEC
               move ATTSI to FT-Attempts in FT-Container-Data
           end-if
           if COMPL greater than 0
               EXEC CICS BIF DEEDIT
                   FIELD(COMPI)
                   LENGTH(length of COMPI)
               END-EXEC
               move COMPI to FT-Completed in FT-Container-Data
           end-if
           if THREEL greater than 0
               EXEC CICS BIF DEEDIT
                   FIELD(THREEI)
                   LENGTH(length of THREEI)
               END-EXEC
               move THREEI to FT-Three-Pointers in FT-Container-Data
           end-if

           perform 7100-Put-Container
           EXEC CICS LINK
               PROGRAM(FT-Validation-Program)
               CHANNEL(FT-Channel-Name)
           END-EXEC

           perform 7000-Get-Container
           if Validation-Errors greater than spaces
               move Validation-Errors to MSGO
           end-if
           perform 4000-Copy-from-Record-to-Map

           .
       4000-Copy-from-Record-to-Map.
      *****************************************************************
      * Populate output map from container data.
      *****************************************************************
           move FT-Team-Name in FT-Container-Data to TEAMO
           move FT-Player-Name in FT-Container-Data to NAMEO
           move FT-Games in FT-Container-Data to GAMESO
           move FT-Attempts in FT-Container-Data to ATTSO
           move FT-Completed in FT-Container-Data to COMPO
           move FT-Three-Pointers in FT-Container-Data to THREEO
           move FT-Pct-Completed in FT-Container-Data to PCTO
           move FT-Avg-Points in FT-Container-Data to AVGO
           move FT-Last-Update in FT-Container-Data to UPDO
           .
       5000-Save-Changes.
      *****************************************************************
      * Add the record unless there are still validation errors.
      *****************************************************************
           perform 4000-Copy-from-Record-to-Map
           if Validation-Errors greater than spaces
               move Validation-Errors to MSGO
           else
               move function current-date
                   to FT-Last-Update in FT-Container-Data
               EXEC CICS READ
                   FILE(FT-File-Name)
                   RIDFLD(FT-Record(1:40))
                   INTO(Free-Throw-Record)
                   UPDATE
                   RESP(CICS-Response-Code)
               END-EXEC
               if EIBRESP equal DFHRESP(NORMAL)
                   continue
               else
                   move "READ UPDATE" to ERR-Operation
                   move FT-File-Name to Err-File-Name
                   move EIBRESP to ERR-EIBRESP
                   move EIBRESP2 to ERR-EIBRESP2
                   move MSG-File-Error to MSGO
                   perform 7100-Put-Container
                   perform 9100-Display-and-Return
               end-if
               move FT-Record to Free-Throw-Record
               EXEC CICS REWRITE
                   FILE(FT-File-Name)
                   FROM(Free-Throw-Record)
                   RESP(CICS-Response-Code)
               END-EXEC
               if EIBRESP equal DFHRESP(NORMAL)
                   move MSG-Record-Updated to MSGO
               else
                   move "REWRITE" to ERR-Operation
                   move FT-File-Name to Err-File-Name
                   move EIBRESP to ERR-EIBRESP
                   move EIBRESP2 to ERR-EIBRESP2
                   move MSG-File-Error to MSGO
               end-if
           end-if
           .
       7000-Get-Container.
      *****************************************************************
      * Copy container data to working storage.
      *****************************************************************
           EXEC CICS GET CONTAINER(FT-Container-Name)
               CHANNEL(FT-Channel-Name)
               INTO(FT-Container-Data)
               FLENGTH(length of FT-Container-Data)
               RESP(CICS-Response-Code)
           END-EXEC
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
           move "UPDATE" to SCRTITLO
           move DFHBMASK to TEAMA
           move DFHBMASK to NAMEA
           if Highlight-Error
               move DFHRED to MSGC
               move space to Highlight-Control
           end-if
           EXEC CICS SEND
               MAP(FT-Update-Map)
               MAPSET(FT-Update-Mapset)
               FROM(FRTUMAPO)
               ERASE
               FREEKB
           END-EXEC
           EXEC CICS RETURN
               TRANSID(FT-Update-TransId)
               CHANNEL(FT-Channel-Name)
           END-EXEC
           .
       9500-Transfer-to-View.
           EXEC CICS XCTL
               PROGRAM(FT-View-Program)
           END-EXEC
           .
       9800-Start-Initial-Trans.
      *****************************************************************
      * This program must be passed the record that is to be updated.
      * Therefore, if it is started directly from terminal input, we
      * end this transaction and start a View transaction.
      *****************************************************************
           EXEC CICS START
               TRANSID(FT-View-TransId)
               TERMID(EIBTRMID)
           END-EXEC
           EXEC CICS RETURN
           END-EXEC
           .
