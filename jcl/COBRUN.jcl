//DBAD03D JOB MSGLEVEL=(1,1),NOTIFY=&SYSUID                             00010002
//*                                                                     00020000
//*  RUN A COBOL PROGRAM                                                00030001
//*                                                                     00060000
//STEP01  EXEC PGM=COB001                                               00070005
//STEPLIB  DD  DSN=DBAD03.LOADLIB,DISP=SHR                              00090005
//SYSOUT   DD  SYSOUT=*                                                 00100001
