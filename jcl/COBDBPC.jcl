//MATEDGD JOB MSGLEVEL=(1,1),NOTIFY=&SYSUID                             00010000
//PLIB    JCLLIB ORDER=(MATE1.PROCLIB)                                  00011000
//*                                                                     00020000
//*  COBOL + DB2 PRECOMPILE AND LINKEDIT                                00030000
//*                                                                     00040000
//DBPREC  EXEC DB2COBCL,                                                00071000
//             COPYLIB=MATEDG.LAB.COPYLIB,     <= COPYBOOK LIBRARY      00072000
//             DCLGLIB=MATEDG.DCLGEN.COBOL,    <= DCLGEN LIBRARY        00072100
//             DBRMLIB=MATEDG.DBRMLIB,         <= DBRM LIBRARY          00072200
//             LOADLIB=MATEDG.LOADLIB,         <= LOAD LIBRARY          00072300
//             SRCLIB=MATEDG.LAB.COBOL,        <= SOURCE LIBRARY        00073000
//             MEMBER=TEAMLIST                 <= SOURCE MEMBER         00074002
