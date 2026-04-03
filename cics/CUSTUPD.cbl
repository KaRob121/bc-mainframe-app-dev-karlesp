       Identification Division.
      *****************************************************************
      * CRUD operations against the customer data file (CUSTFILE).
      *****************************************************************
       Program-Id. CUSTUPD.
       Data Division.
       Working-Storage Section.
       01  WS-Work-Fields.
           05  WS-Resp                pic s9(08) binary.
           05  Display-RESP           pic 9(08).
           05  WS-Error-Message       pic x(79).
           05  WS-Channel-Name
                   pic x(16) value "Cust-Channel".
           05  WS-Record-Container-Name
                   pic x(16) value "Cust-Record".
           05  WS-State-Container-Name
                   pic x(16) value "Cust-State".
           05  WS-Customer-File-Name
                   pic x(08) value 'CUSTFILE'.
           05  WS-Session-State       pic x value space.
               88  New-Session              value "N".
               88  Continuing-Session       value "C".
               88  Add-Pending              value "A".
               88  Delete-Pending           value "D".
           05  WS-Phone-Number.
               10  WS-Phone-Area            pic x(03).
               10  WS-Phone-Prefix          pic x(03).
               10  WS-Phone-Line            pic x(04).
           05  WS-Phone-Number-Formatted.
               10  filler                   pic x value "(".
               10  WS-Phone-Area            pic x(03).
               10  filler                   pic x(02) value ") ".
               10  WS-Phone-Prefix          pic x(03).
               10  filler                   pic x value "-".
               10  WS-Phone-Line            pic x(04).
           05  WS-Record-Key.
               10  filler                   pic x(09).
               10  WS-Record-Key-Last-Byte  pic x(01).
       01  WS-Customer-Record.
           copy CUSTREC replacing ==:PREFIX:== by ==WS==.

       01  Record-Container-Data.
           05  CURR-Customer-Record.
               copy CUSTREC replacing ==:PREFIX:== by ==CURR==.
           05  ORIG-Customer-Record.
               copy CUSTREC replacing ==:PREFIX:== by ==ORIG==.

       01  WS-Message-Delimiter        pic x(02).
       01  WS-Validation-Result        pic x.
           88  Validation-OK       value "O".
           88  Validation-Failed   value "F".

       01  WS-Action-Code              pic x(02).
           88  ACTION-None         value spaces.
           88  ACTION-Cancel       value "C".
           88  ACTION-Add          value "A".
           88  ACTION-Delete       value "D".
           88  ACTION-Save         value "S".
           88  ACTION-Next         value "N".
           88  ACTION-Previous     value "P".
           88  ACTION-Exit         value "X".
           88  ACTION-Save-and-Exit value "SX".
       01  WS-Messages.
           05  MESS-Initial-Prompt.
               10  filler              pic x(40) value
                   "Make changes, browse, or enter a differe".
               10  filler              pic x(39) value
                   "nt Customer Id.".
           05  MESS-Empty-File.
               10  filler              pic x(40) value
                   "File CUSTFILE is empty. If this is expe".
               10  filler              pic x(39) value
                   "cted, try adding a record.".
           05  MESS-Record-Not-Found.
               10  filler              pic x(79) value
                   "Record not found.".
           05  MESS-Add-Pending.
               10  filler              pic x(79) value
                   "Add pending.".
           05  MESS-Changes-Pending.
               10  filler              pic x(79) value
                   "Changes pending.".
           05  MESS-No-Changes-Pending.
               10  filler              pic x(79) value
                   "No changes pending.".
           05  MESS-Changes-Canceled.
               10  filler              pic x(79) value
                   "Pending changes canceled.".
           05  MESS-Enter-New-Values.
               10  filler              pic x(79) value
                   "Enter values for new customer record.".
           05  MESS-Undefined-Action.
               10  filler              pic x(19) value
                   "Undefined Action: ".
               10  MESS-Action         pic x(02).
               10  filler              pic x(58) value spaces.
           05  MESS-Record-Added.
               10  filler              pic x(79) value
                   "Record added.".
           05  MESS-Duplicate-Record.
               10  filler              pic x(39) value
                   "Record already exists with Customer ID ".
               10  MESS-Duplicate-Key  pic x(10).
               10  filler              pic x(30) value spaces.
           05  MESS-Record-Changed.
               10  filler              pic x(79) value
                   "Record changed.".
           05  MESS-Confirm-Delete.
               10  filler              pic x(79) value
                   "Please submit D again to confirm, or C to cancel.".
           05  MESS-Record-Deleted.
               10  filler              pic x(79) value
                   "Record deleted.".
           05  ERR-Message.
               10  filler              pic x(08) value
                   "EIBRESP ".
               10  ERR-EIBRESP         pic 9(08).
               10  filler              pic x(04) value
                   " on ".
               10  ERR-Command         pic x(59).

           copy CUSTMS.
           copy DFHAID.

       Procedure Division.
           perform 7000-Check-Session-State
           if New-Session
               perform 0100-First-Time-Processing
           else
               perform 2000-Process-Request
           end-if
           .
       0100-First-Time-Processing.
      *****************************************************************
      * Get the first record in the file by default.
      *****************************************************************
               move spaces to WS-Customer-Record
               move low-values to WS-Customer-Id
               EXEC CICS READ
                   FILE(WS-Customer-File-Name)
                   INTO(WS-Customer-Record)
                   RIDFLD(WS-Customer-Id)
                   GTEQ
                   RESP(WS-Resp)
               END-EXEC
               evaluate WS-Resp
                   when DFHRESP(NORMAL)
                        perform 6000-Populate-Map-From-Record
                        move MESS-Initial-Prompt to MSGO
                   when DFHRESP(NOTFND)
                        move MESS-Empty-File to MSGO
                   when other
                        move WS-Resp to ERR-EIBRESP
                        string "READ FILE(" delimited by size
                               WS-Customer-File-Name
                                   delimited by size
                               ")" delimited by size
                           into ERR-Command
                        end-string
                        perform 9900-Die
               end-evaluate
               perform 7400-Copy-Record-to-Container
               set Continuing-Session to true
               perform 1000-Prompt-User
           .
       1000-Prompt-User.
      *****************************************************************
      * Display the current record and prompt user for action.
      *****************************************************************
           perform 6000-Populate-Map-From-Record
           perform 7100-Save-Session-State
           perform 7300-Put-Record-Container
           EXEC CICS SEND
               FROM(CUSTMO)
               MAP('CUSTM')
               MAPSET('CUSTMS')
               ERASE
               FREEKB
           END-EXEC
           EXEC CICS RETURN
               TRANSID(EIBTRNID)
               CHANNEL(WS-Channel-Name)
           END-EXEC
           .
       2000-Process-Request.
      *****************************************************************
      * Receive terminal input and process the user's request.
      *****************************************************************
           EXEC CICS RECEIVE
               INTO(CUSTMI)
               MAP('CUSTM')
               MAPSET('CUSTMS')
               RESP(WS-RESP)
           END-EXEC
      *    Treat MAPFAIL as NORMAL.
      *    In this case it means the user pressed Enter without
      *    entering anything in any input field.
           if WS-RESP = DFHRESP(MAPFAIL)
               continue
           end-if
           if EIBAID equal DFHPF12
               perform 9000-Return
           end-if
           move spaces to MSGO
           if ACTIONL > 0
               move ACTIONI to WS-Action-Code
               evaluate true
                   when ACTION-None
                        continue
                   when ACTION-Exit
                        perform 9000-Return
                   when ACTION-Save
                        perform 3400-Save-Changes
                   when ACTION-Save-and-Exit
                        perform 3400-Save-Changes
                        perform 9000-Return
                   when ACTION-Add
                        perform 3100-Setup-New-Record
                   when ACTION-Delete
                        if Delete-Pending
                            perform 3300-Delete-Current-Record
                        else
                            perform 3200-Setup-Delete-Record
                        end-if
                   when ACTION-Cancel
                        perform 3900-Cancel-Changes
                   when ACTION-Next
                        perform 4000-Next-Record
                   when ACTION-Previous
                        perform 4200-Previous-Record
                   when other
                       move ACTIONI to MESS-Action
                       move MESS-Undefined-Action to MSGO
               end-evaluate
           end-if
           perform 6100-Populate-Record-From-Map
           perform 1000-Prompt-User
           .
       3000-Read-Customer-Record.
      *****************************************************************
      * Read a single record based on the customer id received
      * from the terminal.
      *****************************************************************
           EXEC CICS READ
               FILE(WS-Customer-File-Name)
               INTO(WS-Customer-Record)
               RIDFLD(WS-Customer-Id)
               LENGTH(length of WS-Customer-Record)
               RESP(WS-Resp)
           END-EXEC
           evaluate WS-Resp
               when DFHRESP(NORMAL)
                    perform 7400-Copy-Record-to-Container
                    perform 6000-Populate-Map-From-Record
               when DFHRESP(NOTFND)
                    move low-values to CUSTMO
                    move WS-Customer-Id to KEYO
                    move MESS-Record-Not-Found to MSGO
               when other
                    perform 8000-Read-Error
           end-evaluate
           .
       3100-Setup-New-Record.
      *****************************************************************
      * The user entered action A. Set things up so they can enter
      * values for the new record.
      *****************************************************************
           set Add-Pending to true
           initialize CURR-Customer-Record
           initialize WS-Customer-Record
           move low-values to CUSTMO
           move -1 to KEYL
           move 0718 to EIBCPOSN
           move MESS-Enter-New-Values to MSGO
           .
       3200-Setup-Delete-Record.
      *****************************************************************
      * The user entered action D. Set things up so they can confirm
      * or cancel the delete request on the next pass.
      *****************************************************************
           set Delete-Pending to true
           move "D" to ACTIONO
           move MESS-Confirm-Delete to MSGO
           .
       3300-Delete-Current-Record.
      *****************************************************************
      * The user confirmed their delete request.
      *****************************************************************
           EXEC CICS DELETE
               FILE(WS-Customer-File-Name)
               RIDFLD(CURR-Customer-Id)
               RESP(WS-Resp)
           END-EXEC
           if WS-Resp equal DFHRESP(NORMAL)
               continue
           else
               move WS-Resp to ERR-EIBRESP
               string "DELETE FILE(" delimited by size
                      WS-Customer-File-Name
                          delimited by size
                      ")" delimited by size
                  into ERR-Command
               end-string
               perform 9900-Die
           end-if
           perform 4000-Next-Record
           .
       3400-Save-Changes.
      *****************************************************************
      * The user entered action S to save pending changes.
      * This may be either an "add" or an "update".
      *****************************************************************
           if CURR-Customer-Record equal ORIG-Customer-Record
               move MESS-No-Changes-Pending to MSGO
           else
               perform 5000-Validate-Before-Save
               if Validation-OK
                   perform 3500-Add-or-Update
               end-if
           end-if
           .
       3500-Add-or-Update.
           if Add-Pending
               perform 3600-Add-New-Record
           else
               perform 3700-Update-Current-Record
           end-if
           .
       3600-Add-New-Record.
           EXEC CICS WRITE
               FILE(WS-Customer-File-Name)
               FROM(CURR-Customer-Record)
               LENGTH(length of CURR-Customer-Record)
               RIDFLD(CURR-Customer-Id)
               KEYLENGTH(length of CURR-Customer-Id)
               RESP(WS-Resp)
           END-EXEC
           evaluate true
               when WS-Resp equal DFHRESP(NORMAL)
                    set Continuing-Session to true
                    move MESS-Record-Added to MSGO
               when WS-Resp equal DFHRESP(DUPREC)
                    move CURR-Customer-Id to MESS-Duplicate-Key
                    move MESS-Duplicate-Record to MSGO
               when other
                    move WS-Resp to ERR-EIBRESP
                    string "WRITE FILE(" delimited by size
                           WS-Customer-File-Name
                               delimited by size
                           ")" delimited by size
                       into ERR-Command
                    end-string
                    perform 9900-Die
           end-evaluate
           .
       3700-Update-Current-Record.
           move CURR-Customer-Record to WS-Customer-Record
           EXEC CICS READ
               UPDATE
               FILE(WS-Customer-File-Name)
               INTO(WS-Customer-Record)
               LENGTH(length of WS-Customer-Record)
               RIDFLD(WS-Customer-Id)
               KEYLENGTH(length of WS-Customer-Id)
               RESP(WS-Resp)
           END-EXEC
           if WS-Resp equal DFHRESP(NORMAL)
               continue
           else
               move WS-Resp to ERR-EIBRESP
               string "READ UPDATE FILE(" delimited by size
                      WS-Customer-File-Name
                          delimited by size
                      ")" delimited by size
                  into ERR-Command
               end-string
               perform 9900-Die
           end-if
           EXEC CICS REWRITE
               FILE(WS-Customer-File-Name)
               FROM(CURR-Customer-Record)
               LENGTH(length of CURR-Customer-Record)
               RESP(WS-Resp)
           END-EXEC
           if WS-Resp equal DFHRESP(NORMAL)
               continue
           else
               move WS-Resp to ERR-EIBRESP
               string "REWRITE FILE(" delimited by size
                      WS-Customer-File-Name
                          delimited by size
                      ")" delimited by size
                  into ERR-Command
               end-string
               perform 9900-Die
           end-if
           move MESS-Record-Changed to MSGO
           .
       3900-Cancel-Changes.
      *****************************************************************
      * Reestablish the original record as the current record.
      *****************************************************************
           set Continuing-Session to true
           move ORIG-Customer-Record to CURR-Customer-Record
           move MESS-Changes-Canceled to MSGO
           .
       4000-Next-Record.
      *****************************************************************
      * Get the next logical record in the file. Records are in
      * ascending order by primary key. When we reach end of file,
      * wrap around to the first record.
      *****************************************************************
           move CURR-Customer-Id to WS-Record-Key
           move high-values to WS-Record-Key-Last-Byte
           EXEC CICS READ
               FILE(WS-Customer-File-Name)
               INTO(WS-Customer-Record)
               LENGTH(length of WS-Customer-Record)
               RIDFLD(WS-Record-Key)
               KEYLENGTH(length of WS-Record-Key)
               GTEQ
               RESP(WS-Resp)
           END-EXEC
           evaluate WS-Resp
               when DFHRESP(NORMAL)
                    perform 7400-Copy-Record-to-Container
                    perform 6000-Populate-Map-From-Record
               when DFHRESP(NOTFND)
                    perform 0100-First-Time-Processing
               when other
                    perform 8000-Read-Error
           end-evaluate
           .
       4200-Previous-Record.
      *****************************************************************
      * Get the previous logical record in the file. Records are in
      * ascending order by primary key.
      *****************************************************************
           EXEC CICS STARTBR
               FILE(WS-Customer-File-Name)
               RIDFLD(CURR-Customer-Id)
               RESP(WS-Resp)
           END-EXEC
           if WS-Resp equal DFHRESP(NORMAL)
               continue
           else
               move WS-Resp to ERR-EIBRESP
               string "STARTBR FILE(" delimited by size
                      WS-Customer-File-Name
                          delimited by size
                      ")" delimited by size
                  into ERR-Command
               end-string
               perform 4400-End-Browse
               perform 9900-Die
           end-if
      * First READPREV gets the same record we have now
           perform 4300-Read-Previous
           if WS-Resp equal DFHRESP(NORMAL)
               continue
           else
               move WS-Resp to ERR-EIBRESP
               string "READPREV FILE(" delimited by size
                      WS-Customer-File-Name
                          delimited by size
                      ") first time" delimited by size
                  into ERR-Command
               end-string
               perform 9900-Die
           end-if
      * Second READPREV gets the record before the current one
           perform 4300-Read-Previous
           evaluate WS-Resp
               when DFHRESP(NORMAL)
                    continue
               when DFHRESP(ENDFILE)
                    perform 4400-End-Browse
                    perform 0100-First-Time-Processing
               when other
               move WS-Resp to ERR-EIBRESP
               string "READPREV FILE(" delimited by size
                      WS-Customer-File-Name
                          delimited by size
                      ") second time" delimited by size
                  into ERR-Command
               end-string
               perform 4400-End-Browse
               perform 9900-Die
           end-evaluate
           perform 4400-End-Browse
           set Continuing-Session to true
           move WS-Customer-Record to
                CURR-Customer-Record
                ORIG-Customer-Record
           move MESS-Initial-Prompt to MSGO
           .
       4300-Read-Previous.
           EXEC CICS READPREV
               FILE(WS-Customer-File-Name)
               INTO(WS-Customer-Record)
               LENGTH(length of WS-Customer-Record)
               RIDFLD(CURR-Customer-Id)
               KEYLENGTH(length of CURR-Customer-Id)
               RESP(WS-Resp)
           END-EXEC
           .
       4400-End-Browse.
      *****************************************************************
      * Unconditional end browse. This is called during normal
      * processing as well as after any unexpected error condition
      * as a precaution against hanging the transaction.
      *****************************************************************
           EXEC CICS ENDBR
               FILE(WS-Customer-File-Name)
               RESP(WS-Resp)
           END-EXEC
           .
       5000-Validate-Before-Save.
      *****************************************************************
      * Check input values before honoring save request.
      *****************************************************************
           set Validation-OK to true
           move spaces to MSGO
           move space to WS-Message-Delimiter
           if CURR-Customer-Name equal spaces
               move "Name required#" to MSGO
               move ", " to WS-Message-Delimiter
           end-if
           if CURR-Customer-Address equal spaces
               string MSGO delimited by "#"
                      WS-Message-Delimiter delimited by size
                      "Address required#" delimited by size
                 into MSGO
               end-string
               move ", " to WS-Message-Delimiter
           end-if
           if CURR-Customer-Email equal spaces
               string MSGO delimited by "#"
                      WS-Message-Delimiter delimited by size
                      "Email required#" delimited by size
                 into MSGO
               end-string
           end-if
           if MSGO equal spaces
               continue
           else
               string MSGO delimited by "#" into MSGO end-string
               set Validation-Failed to true
           end-if
           .
       6000-Populate-Map-From-Record.
      *****************************************************************
      * Copy values from the current record to the output map.
      *****************************************************************
           move spaces                  to ACTIONO
           move CURR-Customer-Id        to KEYO
           move CURR-Customer-Name      to NAMEO
           move CURR-Customer-Address   to ADDRO
           move CURR-Customer-Phone     to PHONEO
           move CURR-Customer-Phone to WS-Phone-Number
           move corr WS-Phone-Number to WS-Phone-Number-Formatted
           move WS-Phone-Number-Formatted to PHONEO
           move CURR-Customer-Email     to EMAILO
           .
       6100-Populate-Record-From-Map.
      *****************************************************************
      * Copy values from the terminal to the current record.
      * Only copy fields whose modified data tags are set.
      * When the user is editing a new record, they might change the
      * record key value and that's okay.
      * If they're editing an existing record and they change the key
      * value, then we want to display the record with the new key
      * and discard pending changes.
      *****************************************************************
           if KEYL > 0
               if Add-Pending
                   move KEYI to CURR-Customer-Id
               else
                   if KEYI not equal CURR-Customer-Id
                       move KEYI to WS-Customer-Id
                       perform 3000-Read-Customer-Record
                   end-if
               end-if
           end-if
           if NAMEL > 0
               move NAMEI to CURR-Customer-Name
           end-if
           if ADDRL > 0
               move ADDRI to CURR-Customer-Address
           end-if
           if PHONEL > 0
               EXEC CICS BIF DEEDIT
                   FIELD(PHONEI)
                   LENGTH(length of PHONEI)
               END-EXEC
               move PHONEI to CURR-Customer-Phone
           end-if
           if EMAILL > 0
               move EMAILI to CURR-Customer-Email
           end-if
           if CURR-Customer-Record not equal ORIG-Customer-Record
           and MSGO equal spaces
               move MESS-Changes-Pending to MSGO
           end-if
           .
       7000-Check-Session-State.
      *****************************************************************
      * If the container or channel doesn't exist, it means this is
      * the first invocation of the program in a new user session.
      *****************************************************************
           EXEC CICS GET
               CONTAINER(WS-State-Container-Name)
               CHANNEL(WS-Channel-Name)
               INTO(WS-Session-State)
               FLENGTH(length of WS-Session-State)
               RESP(WS-Resp)
           END-EXEC
           if WS-Resp equal DFHRESP(NORMAL)
               continue
           else
               set New-Session to true
           end-if
           .
       7100-Save-Session-State.
      *****************************************************************
      * The state information indicates whether this is the start of a
      * new session, the continuation of a session, or if an add or
      * delete operation is pending (those require multiple passes
      * through the program).
      *****************************************************************
           EXEC CICS PUT CONTAINER(WS-State-Container-Name)
               CHANNEL(WS-Channel-Name)
               FROM(WS-Session-State)
               FLENGTH(length of WS-Session-State)
               RESP(WS-Resp)
           END-EXEC
           evaluate WS-Resp
               when DFHRESP(NORMAL)
                    continue
               when other
                    move WS-Resp to ERR-EIBRESP
                    string "PUT CONTAINER("
                               delimited by size
                           WS-State-Container-Name
                               delimited by size
                           ")" delimited by size
                       into ERR-Command
                    end-string
                    perform 9900-Die
           end-evaluate
           .
       7200-Get-Record-Container.
      *****************************************************************
      * Get the original version of the current record and unsaved
      * changes from the record container.
      *****************************************************************
           EXEC CICS GET
               CONTAINER(WS-Record-Container-Name)
               CHANNEL(WS-Channel-Name)
               INTO(Record-Container-Data)
               FLENGTH(length of Record-Container-Data)
               RESP(WS-Resp)
           END-EXEC
           if WS-Resp equal DFHRESP(NORMAL)
               continue
           else
               move spaces to Record-Container-Data
           end-if
           perform 7400-Copy-Record-to-Container
           .
       7300-Put-Record-Container.
      *****************************************************************
      * The record container holds the original versioon of the current
      * record and any unsaved changes the user has made to the record.
      *****************************************************************
           EXEC CICS PUT CONTAINER(WS-Record-Container-Name)
               CHANNEL(WS-Channel-Name)
               FROM(Record-Container-Data)
               FLENGTH(length of Record-Container-Data)
               RESP(WS-Resp)
           END-EXEC
           evaluate WS-Resp
               when DFHRESP(NORMAL)
                    continue
               when other
                    move WS-Resp to ERR-EIBRESP
                    string "PUT CONTAINER("
                               delimited by size
                           WS-Record-Container-Name
                               delimited by size
                           ")" delimited by size
                       into ERR-Command
                    end-string
                    perform 9900-Die
           end-evaluate
              .
       7400-Copy-Record-to-Container.
           move WS-Customer-Record to
               CURR-Customer-Record
               ORIG-Customer-Record
           .
       8000-Read-Error.
            move WS-Resp to ERR-EIBRESP
            string "READ FILE(" delimited by size
                   WS-Customer-File-Name
                       delimited by size
                   ")" delimited by size
               into ERR-Command
            end-string
            perform 9900-Die
           .
       9000-Return.
      *****************************************************************
      * Normal exit. Clear the screen and return control to CICS.
      *****************************************************************
           EXEC CICS SEND CONTROL
               ERASE
               FREEKB
           END-EXEC
           EXEC CICS
               RETURN
           END-EXEC
           .
       9900-Die.
      *****************************************************************
      * Something happened we can't handle gracefully. Clear the
      * screen, display a message with the value of EIBRESP, and
      * return control to CICS.
      *****************************************************************
           EXEC CICS SEND TEXT
               FROM(ERR-Message)
               LENGTH(length of ERR-Message)
               ERASE
               FREEKB
           END-EXEC
           EXEC CICS
               RETURN
           END-EXEC
           .
