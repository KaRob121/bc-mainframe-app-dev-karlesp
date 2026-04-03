       Identification Division.
       Program-Id. TABSRCH.
      *****************************************************************
      * Follow the instructions given in source comments.
      *****************************************************************
       Environment Division.
       Input-Output Section.

      * <your code goes here - SELECT>

       Data Division.
       File Section.

      * <your code goes here - FD>

       Working-Storage Section.
       01  Input-Record.
           copy TABREC.

      * <your code goes here - File Status field>

       Procedure Division.

      * Complete the missing code in the Environment Division,
      * Input-Output Section and the Data Division, File Section
      * to suport a sequential data set with fixed-blocked format
      * and 80-byte logical records. 
      * Specify a value for BLOCK CONTAINS that causes the program 
      * not to care what the actual block size is.
      *
      * Create a job in your JCL library to execute program TABSRCH.
      * Include a DD statement for the input data set named
      * <userid>.INNOV.TABDATA and give it a DDNAME that matches the
      * external name you coded on the SELECT statement for the file.
      * 
      * Code logic to open, read, and close the data set and to
      * populate a table in Working-Storage with the records from
      * the data set.
      *
      * Then code table search logic as described below. 
      *
      * Search #1 - serial search. 
      *
      * Find the US mountain outside of Alaska with the highest
      * elevation. Display its name, state abbreviation, and
      * elevation.
      *
      * Search #2 - binary search.
      * 
      * Note - The table is sorted descending by MTN-Elevation.
      *
      * Find the mountain with the highest elevation under 4500
      * meters. Display its name, state abbreviation, and
      * elevation.

      * <your code goes here>


           goback
           .
