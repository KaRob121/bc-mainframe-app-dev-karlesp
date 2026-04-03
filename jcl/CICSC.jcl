//DBAD03D JOB MSGLEVEL=(1,1),NOTIFY=&SYSUID                             00010000
//*                                                                     00020000
//*  COMPILE A COBOL + CICS PROGRAM                                     00030000
//*                                                                     00040000
//CICSCOB  EXEC CICSCOBC,                                               00071003
//             COPYLIB=DBAD03.COPYLIB,         <= COPYBOOK LIBRARY      00071100
//             SRCLIB=DBAD03.CICS.SRCLIB,      <= SOURCE LIBRARY        00072000
//             MEMBER=SEND01                   <= SOURCE MEMBER         00073002
