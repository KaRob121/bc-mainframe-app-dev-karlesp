       Identification Division.
       Program-Id. FRTDEL.
      *****************************************************************
      * Delete a Free Throw record
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
           02  CON-Status                     pic x.
               88  First-Time                 value "Y".
               88  Confirm-Deletion           value "C".
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
               10  fille                      pic x(79)
               value "Press PF5 to delete".
           05  MSG-Confirm-Deletion           pic x(79)
               value "Press PF5 again to confirm, PF12 to cancel".
           05  MSG-Record-Deleted             pic x(79)
               value "Record successfully deleted".
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
           move spaces to CON-Status
           move low-values to FRTUMAPO
           perform 4000-Copy-from-Record-to-Map
           move FT-Delete-TransId to TRANIDO
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
                   continue
               when DFHPF5
                   if Confirm-Deletion
                       perform 5000-Save-Changes
                       move spaces to CON-Status
                   else
                       perform 6000-Confirm
                       set Confirm-Deletion to true
                   end-if
               when DFHPF12
                   perform 9500-Transfer-to-View
               when other
                   move MSG-Undefined-PF-Key to MSGO
                   perform 7100-Put-Container
                   perform 9100-Display-and-Return
           end-evaluate
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
           EXEC CICS DELETE
               FILE(FT-File-Name)
               RIDFLD(FT-Record(1:40))
               RESP(CICS-Response-Code)
           END-EXEC
           if EIBRESP equal DFHRESP(NORMAL)
               move MSG-Record-Deleted to MSGO
           else
               move "DELETE" to ERR-Operation
               move FT-File-Name to Err-File-Name
               move EIBRESP to ERR-EIBRESP
               move EIBRESP2 to ERR-EIBRESP2
               move MSG-File-Error to MSGO
               perform 7100-Put-Container
               perform 9100-Display-and-Return
           end-if
           .
       6000-Confirm.
      *****************************************************************
      * Prompt the user to confirm the deletion.
      *****************************************************************
           perform 4000-Copy-from-Record-to-Map
           move MSG-Confirm-Deletion to MSGO
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
           move "DELETE" to SCRTITLO
           move DFHBMASK to TEAMA
           move DFHBMASK to NAMEA
           if Highlight-Error
               move DFHRED to MSGC
               move space to Highlight-Control
           end-if
           EXEC CICS SEND
               MAP(FT-Delete-Map)
               MAPSET(FT-Delete-Mapset)
               FROM(FRTUMAPO)
               ERASE
               FREEKB
           END-EXEC
           EXEC CICS RETURN
               TRANSID(FT-Delete-TransId)
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
