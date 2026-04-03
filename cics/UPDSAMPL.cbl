           EXEC SQL
               UPDATE LABSCHEMA.CUST
                   SET CUST_NAME = :CUST-NAME,
                       CUST_ADDRESS = :CUST-ADDRESS,
                       CUST_PHONE = :CUST-PHONE,
                       CUST_EMAIL = :CUST-EMAIL
                   WHERE CUST_ID = :CUST-ID
           END-EXEC
