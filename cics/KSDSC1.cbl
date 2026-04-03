       Identification Division.
       Program-Id. KSDSC1.
      *****************************************************************
      * KSDSC1 - CICS PSEUDOCONVERSATIONAL CRUD PROGRAM             *
      *          FOR VSAM KSDS DATA STORE                            *
      *                                                               *
      * This program demonstrates:                                    *
      * - Pseudoconversational programming style                     *
      * - Testing EIBRESP instead of HANDLE CONDITION                *
      * - CRUD operations on VSAM KSDS                              *
      * - Modern CICS programming practices                          *
      * - Container and Channel usage instead of COMMAREA           *
      * - ACTION field function selection                            *
      * - BMS mapset integration                                     *
      *                                                               *
      * Functions (ACTION field values):                             *
      * - H  = Display usage help                                    *
      * - S  = Save changes                                          *
      * - SX = Save changes and exit                                 *
      * - A  = Add new record                                        *
      * - D  = Delete current record                                 *
      * - P  = Browse backward                                       *
      * - N  = Browse forward                                        *
      * - C  = Cancel unsaved changes                                *
      * - X  = Exit without saving                                   *
      *****************************************************************

       Environment Division.

       Data Division.
       Working-Storage Section.

      * CICS Response codes
       01  Cics-Resp               PIC S9(8) COMP.
       01  Cics-Resp2              PIC S9(8) COMP.

      * Include BMS-generated copybook
           COPY CRUDM.

      * Container and Channel names
       01  Channel-Names.
           05  Channel-Name        PIC X(16) VALUE 'KSDSC1-CHANNEL'.
           05  Container-Control   PIC X(16) VALUE 'CONTROL-DATA'.
           05  Container-Screen    PIC X(16) VALUE 'SCREEN-DATA'.
           05  Container-Record    PIC X(16) VALUE 'RECORD-DATA'.

      * Container data lengths
       01  Container-Lengths.
           05  Control-Length      PIC S9(8) COMP.
           05  Screen-Length       PIC S9(8) COMP.
           05  Record-Length       PIC S9(8) COMP.

      * File definitions
       01  File-Name               PIC X(8) VALUE 'CONTACTS'.
       01  Record-Key              PIC X(10).

      * Control data for pseudoconversations
       01  Control-Data.
           05  Transaction-Count   PIC S9(4) COMP VALUE ZERO.
           05  Current-Key         PIC X(10).
           05  Last-Operation      PIC X(10).
           05  First-Time-Flag     PIC X VALUE 'Y'.
               88  Is-First-Time   VALUE 'Y'.
               88  Not-First-Time  VALUE 'N'.
           05  Change-Flag         PIC X VALUE 'N'.
               88  Has-Changes     VALUE 'Y'.
               88  No-Changes      VALUE 'N'.
           05  Browse-Position     PIC X(10).

      * Screen data fields
       01  Screen-Fields.
           05  Screen-Action       PIC X(2).
           05  Screen-Key          PIC X(10).
           05  Screen-Name         PIC X(30).
           05  Screen-Address      PIC X(50).
           05  Screen-Phone        PIC X(15).
           05  Screen-Email        PIC X(50).
           05  Screen-Message      PIC X(79).
           05  Screen-Count        PIC Z,ZZ9.

      * Record layout for VSAM file
       01  Record-Area.
           05  Rec-Key             PIC X(10).
           05  Rec-Name            PIC X(30).
           05  Rec-Address         PIC X(50).
           05  Rec-Phone           PIC X(15).
           05  Rec-Email           PIC X(50).
           05  Rec-Timestamp       PIC S9(15) COMP-3.

      * Operation status indicators
       01  Operation-Status        PIC X VALUE 'S'.
           88  Operation-Success   VALUE 'S'.
           88  Operation-Error     VALUE 'E'.

      * Action code processing
       01  Action-Code             PIC X(2).
           88  Action-Help         VALUE 'H '.
           88  Action-Save         VALUE 'S '.
           88  Action-Save-Exit    VALUE 'SX'.
           88  Action-Add          VALUE 'A '.
           88  Action-Delete       VALUE 'D '.
           88  Action-Browse-Prev  VALUE 'P '.
           88  Action-Browse-Next  VALUE 'N '.
           88  Action-Cancel       VALUE 'C '.
           88  Action-Exit         VALUE 'X '.

      * Transaction and map names
       01  Trans-Id                PIC X(4) VALUE 'KSD1'.
       01  Mapset-Name             PIC X(8) VALUE 'CRUDMS'.
       01  Map-Name                PIC X(8) VALUE 'CRUDM'.

      * Message constants
       01  Message-Constants.
           05  Msg-Welcome         PIC X(79) VALUE
               'KSDSC1 - VSAM KSDS CRUD Program - Enter ACTION and use ENTER'.
           05  Msg-Add-Success     PIC X(79) VALUE
               'Record added successfully'.
           05  Msg-Upd-Success     PIC X(79) VALUE
               'Record updated successfully'.
           05  Msg-Del-Success     PIC X(79) VALUE
               'Record deleted successfully'.
           05  Msg-Record-Found    PIC X(79) VALUE
               'Record found and displayed'.
           05  Msg-Not-Found       PIC X(79) VALUE
               'Record not found'.
           05  Msg-Duplicate       PIC X(79) VALUE
               'Record already exists - use S to update'.
           05  Msg-File-Error      PIC X(79) VALUE
               'File I/O error occurred'.
           05  Msg-Key-Required    PIC X(79) VALUE
               'Record key is required'.
           05  Msg-Action-Required PIC X(79) VALUE
               'Action code is required'.
           05  Msg-Invalid-Action  PIC X(79) VALUE
               'Invalid action code - use H for help'.
           05  Msg-Container-Error PIC X(79) VALUE
               'Container operation error'.
           05  Msg-Changes-Saved   PIC X(79) VALUE
               'Changes saved successfully'.
           05  Msg-Changes-Cancel  PIC X(79) VALUE
               'Changes cancelled'.
           05  Msg-Help-Text       PIC X(79) VALUE
               'H=Help S=Save SX=Save&Exit A=Add D=Del P=Prev N=Next C=Cancel X=Exit'.

       Linkage Section.

       Procedure Division.

      *****************************************************************
      * MAIN PROCESSING LOGIC                                        *
      *****************************************************************
       1000-Main-Process.
           
           PERFORM 1100-Initialize
           
           EVALUATE TRUE
               WHEN Is-First-Time
                   PERFORM 2000-First-Time-Processing
               WHEN OTHER
                   PERFORM 2100-Subsequent-Processing
           END-EVALUATE
           
           PERFORM 8000-Return-To-Cics
           .

      *****************************************************************
      * INITIALIZATION                                               *
      *****************************************************************
       1100-Initialize.
           
           MOVE LOW-VALUES TO CRUDMO
           
           MOVE SPACES TO Screen-Message
           SET Operation-Success TO TRUE
           
      *    Check if we have a channel with control data
           PERFORM 1200-Get-Control-Data
           
           IF Cics-Resp = DFHRESP(NORMAL)
               SET Not-First-Time TO TRUE
           ELSE
               SET Is-First-Time TO TRUE
               INITIALIZE Control-Data
           END-IF
           
           ADD 1 TO Transaction-Count
           .

      *****************************************************************
      * GET CONTROL DATA FROM CONTAINER                              *
      *****************************************************************
       1200-Get-Control-Data.
           
           EXEC CICS GET CONTAINER(Container-Control)
                     CHANNEL(Channel-Name)
                     INTO(Control-Data)
                     FLENGTH(Control-Length)
                     RESP(Cics-Resp)
                     RESP2(Cics-Resp2)
           END-EXEC
           .

      *****************************************************************
      * FIRST TIME PROCESSING                                        *
      *****************************************************************
       2000-First-Time-Processing.
           
           MOVE Msg-Welcome TO Screen-Message
           MOVE 'INITIALIZE' TO Last-Operation
           PERFORM 3000-Send-Map
           .

      *****************************************************************
      * SUBSEQUENT PROCESSING                                        *
      *****************************************************************
       2100-Subsequent-Processing.
           
           PERFORM 2200-Receive-Map
           
           IF Operation-Success
               PERFORM 4000-Validate-Input
           END-IF
           
           IF Operation-Success
               PERFORM 4100-Process-Action
           END-IF
           
           PERFORM 3000-Send-Map
           .

      *****************************************************************
      * RECEIVE MAP FROM TERMINAL                                    *
      *****************************************************************
       2200-Receive-Map.
           
           EXEC CICS RECEIVE MAP(Map-Name)
                     MAPSET(Mapset-Name)
                     INTO(CRUDMI)
                     RESP(Cics-Resp)
                     RESP2(Cics-Resp2)
           END-EXEC
           
           EVALUATE Cics-Resp
               WHEN DFHRESP(NORMAL)
                   SET Operation-Success TO TRUE
                   PERFORM 2400-Map-Fields-To-Screen
               WHEN DFHRESP(MAPFAIL)
                   SET Operation-Success TO TRUE
                   MOVE SPACES TO Screen-Message
               WHEN OTHER
                   MOVE 'Map receive error' TO Screen-Message
                   SET Operation-Error TO TRUE
           END-EVALUATE
           .

      *****************************************************************
      * MAP FIELDS FROM BMS INPUT TO SCREEN FIELDS                   *
      *****************************************************************
       2400-Map-Fields-To-Screen.
           
           IF ACTIONL > 0
               MOVE ACTIONI TO Screen-Action
           END-IF
           IF KEYL > 0
               MOVE KEYI TO Screen-Key
           END-IF
           IF NAMEL > 0
               MOVE NAMEI TO Screen-Name
           END-IF
           IF ADDRL > 0
               MOVE ADDRI TO Screen-Address
           END-IF
           IF PHONEL > 0
               MOVE PHONEI TO Screen-Phone
           END-IF
           IF EMAILL > 0
               MOVE EMAILI TO Screen-Email
           END-IF
           .

      *****************************************************************
      * MAP FIELDS FROM SCREEN TO BMS OUTPUT                         *
      *****************************************************************
       2500-Screen-Fields-To-Map.
           
           MOVE Screen-Action  TO ACTIONO
           MOVE Screen-Key     TO KEYO
           MOVE Screen-Name    TO NAMEO
           MOVE Screen-Address TO ADDRO
           MOVE Screen-Phone   TO PHONEO
           MOVE Screen-Email   TO EMAILO
           MOVE Screen-Message TO MSGO
           MOVE Screen-Count   TO COUNTO
           .

      *****************************************************************
      * SEND MAP TO TERMINAL                                         *
      *****************************************************************
       3000-Send-Map.
           
           MOVE Transaction-Count TO Screen-Count
           PERFORM 2500-Screen-Fields-To-Map
           
           EXEC CICS SEND MAP(Map-Name)
                     MAPSET(Mapset-Name)
                     FROM(CRUDMO)
                     ERASE
                     RESP(Cics-Resp)
                     RESP2(Cics-Resp2)
           END-EXEC
           
           IF Cics-Resp NOT = DFHRESP(NORMAL)
               EXEC CICS SEND TEXT
                         FROM('Map send error occurred')
                         LENGTH(23)
                         ERASE
               END-EXEC
           END-IF
           .

      *****************************************************************
      * VALIDATE INPUT FIELDS                                        *
      *****************************************************************
       4000-Validate-Input.
           
           MOVE Screen-Action TO Action-Code
           
           EVALUATE TRUE
               WHEN Action-Help OR Action-Save OR Action-Save-Exit OR
                    Action-Add OR Action-Delete OR Action-Browse-Prev OR
                    Action-Browse-Next OR Action-Cancel OR Action-Exit
                   CONTINUE
               WHEN Screen-Action = SPACES
                   MOVE Msg-Action-Required TO Screen-Message
                   SET Operation-Error TO TRUE
               WHEN OTHER
                   MOVE Msg-Invalid-Action TO Screen-Message
                   SET Operation-Error TO TRUE
           END-EVALUATE
           .

      *****************************************************************
      * PROCESS ACTION FUNCTION                                      *
      *****************************************************************
       4100-Process-Action.
           
           EVALUATE TRUE
               WHEN Action-Help
                   PERFORM 4200-Display-Help
               WHEN Action-Save
                   PERFORM 4300-Save-Changes
               WHEN Action-Save-Exit
                   PERFORM 4400-Save-And-Exit
               WHEN Action-Add
                   PERFORM 4500-Add-Mode
               WHEN Action-Delete
                   PERFORM 4600-Delete-Record
               WHEN Action-Browse-Prev
                   PERFORM 4700-Browse-Backward
               WHEN Action-Browse-Next
                   PERFORM 4800-Browse-Forward
               WHEN Action-Cancel
                   PERFORM 4900-Cancel-Changes
               WHEN Action-Exit
                   PERFORM 5000-Exit-Without-Save
           END-EVALUATE
           .

      *****************************************************************
      * DISPLAY HELP INFORMATION                                     *
      *****************************************************************
       4200-Display-Help.
           
           MOVE Msg-Help-Text TO Screen-Message
           MOVE 'HELP' TO Last-Operation
           .

      *****************************************************************
      * SAVE CHANGES                                                 *
      *****************************************************************
       4300-Save-Changes.
           
           IF Screen-Key = SPACES
               MOVE Msg-Key-Required TO Screen-Message
           ELSE
               PERFORM 6000-Update-Record
           END-IF
           .

      *****************************************************************
      * SAVE CHANGES AND EXIT                                        *
      *****************************************************************
       4400-Save-And-Exit.
           
           IF Screen-Key NOT = SPACES
               PERFORM 6000-Update-Record
           END-IF
           PERFORM 9000-Terminate-Program
           .

      *****************************************************************
      * PREPARE FOR ADD MODE                                         *
      *****************************************************************
       4500-Add-Mode.
           
           PERFORM 6400-Clear-Screen-Fields
           MOVE 'Enter new record data and use S to save'
             TO Screen-Message
           MOVE 'ADD-MODE' TO Last-Operation
           .

      *****************************************************************
      * DELETE CURRENT RECORD                                        *
      *****************************************************************
       4600-Delete-Record.
           
           IF Screen-Key = SPACES
               MOVE Msg-Key-Required TO Screen-Message
           ELSE
               PERFORM 6300-Delete-Record
           END-IF
           .

      *****************************************************************
      * BROWSE BACKWARD                                              *
      *****************************************************************
       4700-Browse-Backward.
           
           PERFORM 5100-Start-Browse-Backward
           PERFORM 5200-Read-Previous
           .

      *****************************************************************
      * BROWSE FORWARD                                               *
      *****************************************************************
       4800-Browse-Forward.
           
           PERFORM 5300-Start-Browse-Forward
           PERFORM 5400-Read-Next
           .

      *****************************************************************
      * CANCEL CHANGES                                               *
      *****************************************************************
       4900-Cancel-Changes.
           
           PERFORM 6400-Clear-Screen-Fields
           MOVE Msg-Changes-Cancel TO Screen-Message
           SET No-Changes TO TRUE
           MOVE 'CANCEL' TO Last-Operation
           .

      *****************************************************************
      * EXIT WITHOUT SAVING                                         *
      *****************************************************************
       5000-Exit-Without-Save.
           
           PERFORM 9000-Terminate-Program
           .

      *****************************************************************
      * START BROWSE BACKWARD                                        *
      *****************************************************************
       5100-Start-Browse-Backward.
           
           IF Screen-Key = SPACES
               MOVE HIGH-VALUES TO Record-Key
           ELSE
               MOVE Screen-Key TO Record-Key
           END-IF
           
           EXEC CICS STARTBR FILE(File-Name)
                     RIDFLD(Record-Key)
                     RESP(Cics-Resp)
                     RESP2(Cics-Resp2)
           END-EXEC
           .

      *****************************************************************
      * READ PREVIOUS RECORD                                         *
      *****************************************************************
       5200-Read-Previous.
           
           EXEC CICS READPREV FILE(File-Name)
                     INTO(Record-Area)
                     RIDFLD(Record-Key)
                     RESP(Cics-Resp)
                     RESP2(Cics-Resp2)
           END-EXEC
           
           EVALUATE Cics-Resp
               WHEN DFHRESP(NORMAL)
                   PERFORM 6500-Display-Record
                   MOVE 'BROWSE-PREV' TO Last-Operation
               WHEN DFHRESP(ENDFILE)
                   MOVE 'Beginning of file reached' TO Screen-Message
               WHEN OTHER
                   MOVE Msg-File-Error TO Screen-Message
           END-EVALUATE
           
           EXEC CICS ENDBR FILE(File-Name)
           END-EXEC
           .

      *****************************************************************
      * START BROWSE FORWARD                                         *
      *****************************************************************
       5300-Start-Browse-Forward.
           
           IF Screen-Key = SPACES
               MOVE LOW-VALUES TO Record-Key
           ELSE
               MOVE Screen-Key TO Record-Key
           END-IF
           
           EXEC CICS STARTBR FILE(File-Name)
                     RIDFLD(Record-Key)
                     RESP(Cics-Resp)
                     RESP2(Cics-Resp2)
           END-EXEC
           .

      *****************************************************************
      * READ NEXT RECORD                                             *
      *****************************************************************
       5400-Read-Next.
           
           EXEC CICS READNEXT FILE(File-Name)
                     INTO(Record-Area)
                     RIDFLD(Record-Key)
                     RESP(Cics-Resp)
                     RESP2(Cics-Resp2)
           END-EXEC
           
           EVALUATE Cics-Resp
               WHEN DFHRESP(NORMAL)
                   PERFORM 6500-Display-Record
                   MOVE 'BROWSE-NEXT' TO Last-Operation
               WHEN DFHRESP(ENDFILE)
                   MOVE 'End of file reached' TO Screen-Message
               WHEN OTHER
                   MOVE Msg-File-Error TO Screen-Message
           END-EVALUATE
           
           EXEC CICS ENDBR FILE(File-Name)
           END-EXEC
           .

      *****************************************************************
      * ADD NEW RECORD OR UPDATE EXISTING                            *
      *****************************************************************
       6000-Update-Record.
           
           MOVE Screen-Key     TO Rec-Key
           MOVE Screen-Name    TO Rec-Name
           MOVE Screen-Address TO Rec-Address
           MOVE Screen-Phone   TO Rec-Phone
           MOVE Screen-Email   TO Rec-Email
           
           EXEC CICS ASKTIME ABSTIME(Rec-Timestamp)
           END-EXEC
           
      *    Try to write as new record first
           EXEC CICS WRITE FILE(File-Name)
                     FROM(Record-Area)
                     RIDFLD(Rec-Key)
                     RESP(Cics-Resp)
                     RESP2(Cics-Resp2)
           END-EXEC
           
           EVALUATE Cics-Resp
               WHEN DFHRESP(NORMAL)
                   MOVE Msg-Add-Success TO Screen-Message
                   MOVE 'ADD' TO Last-Operation
                   PERFORM 6400-Clear-Screen-Fields
               WHEN DFHRESP(DUPREC)
      *            Record exists, try to update it
                   PERFORM 6200-Rewrite-Record
               WHEN OTHER
                   MOVE Msg-File-Error TO Screen-Message
           END-EVALUATE
           .

      *****************************************************************
      * REWRITE EXISTING RECORD                                      *
      *****************************************************************
       6200-Rewrite-Record.
           
      *    First read for update
           EXEC CICS READ FILE(File-Name)
                     INTO(Record-Area)
                     RIDFLD(Rec-Key)
                     UPDATE
                     RESP(Cics-Resp)
                     RESP2(Cics-Resp2)
           END-EXEC
           
           IF Cics-Resp = DFHRESP(NORMAL)
               MOVE Screen-Name    TO Rec-Name
               MOVE Screen-Address TO Rec-Address
               MOVE Screen-Phone   TO Rec-Phone
               MOVE Screen-Email   TO Rec-Email
               
               EXEC CICS ASKTIME ABSTIME(Rec-Timestamp)
               END-EXEC
               
               EXEC CICS REWRITE FILE(File-Name)
                         FROM(Record-Area)
                         RESP(Cics-Resp)
                         RESP2(Cics-Resp2)
               END-EXEC
               
               IF Cics-Resp = DFHRESP(NORMAL)
                   MOVE Msg-Upd-Success TO Screen-Message
                   MOVE 'UPDATE' TO Last-Operation
               ELSE
                   MOVE Msg-File-Error TO Screen-Message
               END-IF
           ELSE
               MOVE Msg-File-Error TO Screen-Message
           END-IF
           .

      *****************************************************************
      * DELETE RECORD                                                *
      *****************************************************************
       6300-Delete-Record.
           
           MOVE Screen-Key TO Record-Key
           
           EXEC CICS DELETE FILE(File-Name)
                     RIDFLD(Record-Key)
                     RESP(Cics-Resp)
                     RESP2(Cics-Resp2)
           END-EXEC
           
           EVALUATE Cics-Resp
               WHEN DFHRESP(NORMAL)
                   MOVE Msg-Del-Success TO Screen-Message
                   MOVE 'DELETE' TO Last-Operation
                   PERFORM 6400-Clear-Screen-Fields
               WHEN DFHRESP(NOTFND)
                   MOVE Msg-Not-Found TO Screen-Message
               WHEN OTHER
                   MOVE Msg-File-Error TO Screen-Message
           END-EVALUATE
           .

      *****************************************************************
      * CLEAR SCREEN FIELDS                                          *
      *****************************************************************
       6400-Clear-Screen-Fields.
           
           MOVE SPACES TO Screen-Action
           MOVE SPACES TO Screen-Key
           MOVE SPACES TO Screen-Name
           MOVE SPACES TO Screen-Address
           MOVE SPACES TO Screen-Phone
           MOVE SPACES TO Screen-Email
           .

      *****************************************************************
      * DISPLAY RECORD ON SCREEN                                     *
      *****************************************************************
       6500-Display-Record.
           
           MOVE Rec-Key     TO Screen-Key
           MOVE Rec-Name    TO Screen-Name
           MOVE Rec-Address TO Screen-Address
           MOVE Rec-Phone   TO Screen-Phone
           MOVE Rec-Email   TO Screen-Email
           MOVE Rec-Key     TO Current-Key
           .

      *****************************************************************
      * RETURN TO CICS WITH CHANNEL                                  *
      *****************************************************************
       8000-Return-To-Cics.
           
           PERFORM 8100-Put-Containers
           
           EXEC CICS RETURN TRANSID(Trans-Id)
                     CHANNEL(Channel-Name)
                     RESP(Cics-Resp)
                     RESP2(Cics-Resp2)
           END-EXEC
           .

      *****************************************************************
      * PUT DATA INTO CONTAINERS                                     *
      *****************************************************************
       8100-Put-Containers.
           
      *    Put control data
           EXEC CICS PUT CONTAINER(Container-Control)
                     CHANNEL(Channel-Name)
                     FROM(Control-Data)
                     FLENGTH(LENGTH OF Control-Data)
                     RESP(Cics-Resp)
                     RESP2(Cics-Resp2)
           END-EXEC
           
           IF Cics-Resp NOT = DFHRESP(NORMAL)
               MOVE Msg-Container-Error TO Screen-Message
           END-IF
           
      *    Put screen data
           EXEC CICS PUT CONTAINER(Container-Screen)
                     CHANNEL(Channel-Name)
                     FROM(Screen-Fields)
                     FLENGTH(LENGTH OF Screen-Fields)
                     RESP(Cics-Resp)
                     RESP2(Cics-Resp2)
           END-EXEC
           
      *    Put record data
           EXEC CICS PUT CONTAINER(Container-Record)
                     CHANNEL(Channel-Name)
                     FROM(Record-Area)
                     FLENGTH(LENGTH OF Record-Area)
                     RESP(Cics-Resp)
                     RESP2(Cics-Resp2)
           END-EXEC
           .

      *****************************************************************
      * TERMINATE PROGRAM                                            *
      *****************************************************************
       9000-Terminate-Program.
           
           STRING 'Thank you for using KSDSC1 program. '
                  'Transactions processed: ' Transaction-Count
                  DELIMITED BY SIZE
                  INTO Screen-Message
           END-STRING
           
           EXEC CICS SEND TEXT
                     FROM(Screen-Message)
                     LENGTH(LENGTH OF Screen-Message)
                     ERASE
           END-EXEC
           
           EXEC CICS RETURN
           END-EXEC
           .
