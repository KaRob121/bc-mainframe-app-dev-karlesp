//DBAD03D JOB MSGLEVEL=(1,1),NOTIFY=&SYSUID                             00010000
//*                                                                     00020000
//*  COBOL DB2 RUN JCL                                                  00030000
//*                                                                     00060000
//STEP01   EXEC PGM=IKJEFT01,                                           00070000
//             DYNAMNBR=20,REGION=4096K                                 00080000
//STEPLIB  DD  DISP=SHR,DSN=DSNA10.DBAG.SDSNEXIT                        00090000
//         DD  DISP=SHR,DSN=DSNA10.SDSNLOAD                             00100000
//SYSPRINT DD  SYSOUT=*                                                 00110000
//SYSTSPRT DD  SYSOUT=*                                                 00120000
//SYSUDUMP DD  SYSOUT=*                                                 00130000
//SYSTSIN  DD  *                                                        00140000
DSN SYSTEM (DBAG   )                                                    00150000
  RUN PROGRAM   (LSTCON ) -                                             00160001
      PLAN      (DBAD03P1) -                                            00170000
      LIBRARY   ('DBAD03.LOADLIB')                                      00180000
END                                                                     00250000
/*                                                                      00260000
//SYSOUT   DD  SYSOUT=*                                                 00270000
