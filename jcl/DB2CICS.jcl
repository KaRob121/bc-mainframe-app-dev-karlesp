//DBAD03D JOB MSGLEVEL=(1,1),NOTIFY=&SYSUID                             00010000
//*                                                                     00020000
//*  COBOL + DB2 + CICS COMPILE JCL                                     00030000
//*                                                                     00040000
//PLIB    JCLLIB ORDER=(MATE1.PROCLIB)                                  00050003
//DBONL   EXEC DB2CICSC,                                                00060001
//             COPYLIB=DBAD03.COPYLIB,         <= COPYBOOK LIBRARY      00070000
//             DCLGLIB=DBAD03.DCLGEN.COBOL,    <= DCLGEN LIBRARY        00080000
//             DBRMLIB=DBAD03.DBRMLIB,         <= DBRM LIBRARY          00090000
//             SRCLIB=DBAD03.CICS.SRCLIB,      <= SOURCE LIBRARY        00110000
//             MEMBER=EMPENQ01                 <= SOURCE MEMBER         00120000
