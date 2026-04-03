       Identification Division.
       Program-Id. LSTCON.
      *****************************************************
      * List the contents of the CONTACTS table           *
      *****************************************************
       Data Division.
       Working-Storage Section.
           EXEC SQL
             INCLUDE SQLCA
           END-EXEC.
           EXEC SQL
             INCLUDE CONTACTS
           END-EXEC.
           EXEC SQL
                DECLARE CONTACTS-CURSOR CURSOR FOR
                SELECT ID,
                       LANG,
                       SURNAME,
                       FIRST_NAME,
                       MIDDLE_NAME
                  FROM CONTACTS
           END-EXEC.
       01  Out-Language pic x(80).

       Procedure Division.
           DISPLAY "List Contacts"

           EXEC SQL
                OPEN CONTACTS-CURSOR
           END-EXEC

           DISPLAY "Open cursor SQLCODE: " SQLCODE

           perform 1000-Get-Next-Row
             until SQLCODE NOT EQUAL 0

           EXEC SQL
                CLOSE CONTACTS-CURSOR
           END-EXEC

           DISPLAY "Close cursor SQLCODE: " SQLCODE

           goback
           .
       1000-Get-Next-Row.
           initialize DCLCONTACTS
           EXEC SQL
                FETCH CONTACTS-CURSOR INTO
                    :CONTACT-ID,
                    :LANG,
                    :SURNAME,
                    :FIRST-NAME,
                    :MIDDLE-NAME,
                    :ADDL-NAME,
                    :EMAIL-ADDR
           END-EXEC
           if SQLCODE = 0
               evaluate LANG of DCLCONTACTS
                   when "EN"
                        move "English" to Out-Language
                   when "ES"
                        move "Spanish" to Out-Language
                   when other
                        move "Undefined language code: " to Out-Language
                        move LANG of DCLCONTACTS
                                 to Out-Language(26:2)
               end-evaluate
               display space
               display "Contact ID: " CONTACT-ID
               display "Language: " Out-Language
               display "Surname: <" SURNAME-TEXT ">"
               display "First Name: <" FIRST-NAME-TEXT ">"
               if MIDDLE-NAME-LEN > zero
                   display "Middle Name: <" MIDDLE-NAME-TEXT ">"
               else
                   display "MiddleName: (none)"
               end-if
           end-if
           .
