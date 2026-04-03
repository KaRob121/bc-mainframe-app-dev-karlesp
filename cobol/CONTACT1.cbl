       Identification Division.
       Program-ID. CONTACT1.
       Data Division.
       Working-Storage Section.

           EXEC SQL
               INCLUDE SQLCA
           END-EXEC.
           EXEC SQL
               INCLUDE CONTACTS
           END-EXEC.

       01  FILLER              pic x value "N".
           88  End-of-Data           value "Y".
       01  WS-Message          pic x(80).
       01  WS-Record-Count     pic s9(07) packed-decimal value +0.
       01  WS-Error-SQLCODE    pic s999 sign leading separate.

       Procedure Division.

           EXEC SQL DECLARE CONTACTS_CUR CURSOR FOR
               SELECT
                   LANG,
                   SURNAME,
                   FIRST_NAME,
                   MIDDLE_NAME,
                   ADDL_NAME,
                   EMAIL_ADDR,
                   LAST_CONTACT,
                   LAST_RESPONSE,
                   DO_NOT_CONTACT
               FROM LABSCHEMA.CONTACTS
           END-EXEC
           EXEC SQL
               OPEN CONTACTS_CUR
           END-EXEC

           if SQLCODE not equal zero
               perform 9000-Bail
           end-if
           perform 1000-Fetch-and-Display
               until End-of-Data

           display "Number of rows: " WS-Record-Count
           EXEC SQL CLOSE CONTACTS_CUR END-EXEC
           goback
           .
       1000-Fetch-and-Display.
           EXEC SQL FETCH CONTACTS_CUR
               INTO
                   :LANG,
                   :SURNAME,
                   :FIRST-NAME,
                   :MIDDLE-NAME:MIDDLE-NAME-IND,
                   :ADDL-NAME:ADDL-NAME-IND,
                   :EMAIL-ADDR,
                   :LAST-CONTACT:LAST-CONTACT-IND,
                   :LAST-RESPONSE:LAST-RESPONSE-IND,
                   :DO-NOT-CONTACT:DO-NOT-CONTACT-IND
           END-EXEC

           if SQLCODE = 0
               add 1 to WS-Record-Count
               perform 2000-Display-Values
           else if SQLCODE = 100
               set End-of-Data to true
           else
               perform 9000-Bail
           end-if
           .
       2000-Display-Values.
           display "Lang: " LANG
           display "Surname: " SURNAME
           display "First Name: " FIRST-NAME
           if MIDDLE-NAME-IND < 0
               display "Middle Name: (NONE)"
           else
               display "Middle Name: " MIDDLE-NAME
           end-if
           if ADDL-NAME-IND < 0
               display "Additional Name: (NONE)"
           else
               display "Additional Name: " ADDL-NAME
           end-if
           display "Email Address: " EMAIL-ADDR
           if LAST-CONTACT-IND < 0
               display "Last Contact: (NONE)"
           else
               display "Last Contact: " LAST-CONTACT
           end-if
           if LAST-RESPONSE-IND < 0
               display "Last Response: (NONE)"
           else
               display "Last Response: " LAST-RESPONSE
           end-if
           if DO-NOT-CONTACT-IND < 0
               display "Do Not Contact: (NONE)"
           else
               display "Do Not Contact: " DO-NOT-CONTACT
           end-if
           .
       9000-Bail.
           move SQLCODE to WS-Error-SQLCODE
           display "SQL Error: SQLCODE " WS-Error-SQLCODE
           move 12 to return-code
           goback
           .
