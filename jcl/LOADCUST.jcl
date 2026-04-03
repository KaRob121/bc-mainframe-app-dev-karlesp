//LOADCUST JOB (ACCT),'LOAD CUSTOMER DATA',
//             CLASS=A,MSGCLASS=X,MSGLEVEL=(1,1),
//             NOTIFY=&SYSUID
//*
//* JOB TO LOAD TEST DATA INTO CUSTOMER VSAM KSDS
//* USING IDCAMS REPRO UTILITY
//*
//* RECORD LAYOUT:
//*   CUSTOMER-ID      PIC X(10)  - POSITIONS 1-10
//*   CUSTOMER-NAME    PIC X(30)  - POSITIONS 11-40
//*   CUSTOMER-ADDRESS PIC X(50)  - POSITIONS 41-90
//*   CUSTOMER-PHONE   PIC X(15)  - POSITIONS 91-105
//*   CUSTOMER-EMAIL   PIC X(40)  - POSITIONS 106-145
//*   TOTAL RECORD LENGTH: 145 BYTES
//*
//STEP1    EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//INFILE   DD DSN=MATEDG.CUSTDATA,DISP=SHR
//SYSIN    DD *
 /*                                              */
 /* REPRO TEST DATA INTO CUSTOMER KSDS          */
 /*                                              */
 REPRO -
   INFILE(INFILE) -
   OUTDATASET(MATEDG.CUSTFILE)
 
 /*                                              */
 /* PRINT RECORDS TO VERIFY LOAD                */
 /*                                              */
 PRINT -
   INDATASET(MATEDG.CUSTFILE) -
   COUNT(10)
 
 /*                                              */
 /* LIST CATALOG FOR CLUSTER STATISTICS         */
 /*                                              */
 LISTCAT -
   ENTRIES(MATEDG.CUSTFILE) -
   ALL
/*
//
