       IDENTIFICATION DIVISION.
       PROGRAM-ID. D03PGM1.

      *************************************************
      *   A SAMPLE COBOL/CICS PROGRAM WITH DB2        *
      *                                               *
      *  AUTHOR        : RAMESH                       *
      *  DATE-WRITTEN  : 2013-MAY                     *
      *************************************************

       ENVIRONMENT DIVISION.

       DATA DIVISION.

       WORKING-STORAGE SECTION.
       01 WS-EMPNO         PIC 9(6).
       01 WS-SQLCODE       PIC -9(08).
       01 WS-COMMAREA      PIC X(10).

           COPY D03MPS1.
           COPY DFHAID.
           COPY DFHBMSCA.

           EXEC SQL
             INCLUDE SQLCA
           END-EXEC.

           EXEC SQL
             INCLUDE EMPLOYEE
           END-EXEC.

       LINKAGE SECTION.

       01 DFHCOMMAREA         PIC X(10).

       PROCEDURE DIVISION.

           IF EIBCALEN > ZERO
             MOVE DFHCOMMAREA  TO WS-COMMAREA
           END-IF.

           EVALUATE TRUE

             WHEN EIBCALEN = ZERO
               MOVE LOW-VALUES   TO  EMPENQO
               PERFORM SEND-MAP

             WHEN EIBAID = DFHCLEAR
               MOVE LOW-VALUES   TO  EMPENQO
               PERFORM SEND-MAP

             WHEN EIBAID = DFHPA1 OR DFHPA2 OR DFHPA3
               CONTINUE

             WHEN EIBAID = DFHPF3
               MOVE LOW-VALUES TO  EMPENQO
               MOVE "BYE, PRESS CLEAR KEY TO ENTER A TRANSACTION ID"
                    TO MSG1O
               PERFORM SEND-MAP-DATA

               EXEC CICS
                 RETURN
               END-EXEC

             WHEN EIBAID = DFHENTER
               PERFORM PROCESS-PARA

             WHEN OTHER
               MOVE LOW-VALUES TO EMPENQO
               MOVE "INVALID KEY PRESSED" TO MSG1O
               PERFORM SEND-MAP-DATA

           END-EVALUATE.

           EXEC CICS
              RETURN TRANSID('D031')
              COMMAREA (WS-COMMAREA)
           END-EXEC.

       PROCESS-PARA.

           PERFORM RECEIVE-MAP.

           MOVE ENQIDI    TO WS-EMPNO.
           MOVE WS-EMPNO  TO EMPNO.

           EXEC SQL
              SELECT EMPNO,
                     NAME
                INTO
                    :EMPNO,
                     :NAME
                FROM EMPLOYEE WHERE EMPNO = :EMPNO
           END-EXEC.

           MOVE SQLCODE       TO  WS-SQLCODE.
           DISPLAY "SQLCODE: " WS-SQLCODE.

           EVALUATE SQLCODE
             WHEN 0
               MOVE EMPNO         TO  WS-EMPNO
               MOVE WS-EMPNO      TO  EMPNOO
               MOVE NAME          TO  NAMEO
               MOVE "OK!"         TO  MSG1O
             WHEN 100
               MOVE "EMPLOYEE ID NOT FOUND" TO MSG1O
               MOVE SPACES        TO  EMPNOO
               MOVE SPACES        TO  NAMEO
             WHEN OTHER
               STRING "SQL CODE: " DELIMITED BY SIZE
                      WS-SQLCODE   DELIMITED BY SIZE
                 INTO MSG1O
           END-EVALUATE.

           MOVE -1 TO ENQIDL.
           PERFORM SEND-MAP-DATA.

           EXIT.

       SEND-MAP.
           EXEC CICS SEND
              MAP    ('EMPENQ')
              MAPSET ('D03MPS1')
              FROM   (EMPENQO)
              ERASE
           END-EXEC.

           EXIT.

       SEND-MAP-DATA.
           EXEC CICS SEND
              MAP    ('EMPENQ')
              MAPSET ('D03MPS1')
              FROM   (EMPENQO)
              DATAONLY
           END-EXEC.

           EXIT.

       RECEIVE-MAP.
            EXEC CICS RECEIVE
              MAP    ('EMPENQ')
              MAPSET ('D03MPS1')
              INTO   (EMPENQI)
            END-EXEC.

           EXIT.
