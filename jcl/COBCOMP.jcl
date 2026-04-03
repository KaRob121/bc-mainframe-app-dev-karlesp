//DBAD03D JOB MSGLEVEL=(1,1),NOTIFY=&SYSUID                             00010000
//*                                                                     00020000
//*  COMPILE A COBOL PROGRAM                                            00030000
//*                                                                     00031000
//CL      EXEC COBOLCL,                                                 00070000
//             COPYLIB=DBAD03.COBOL.COPY,      <= COPYBOOK LIBRARY      00071001
//             LOADLIB=DBAD03.LOADLIB,         <= LOAD LIBRARY          00071100
//             SRCLIB=DBAD03.COBOL.SOURCE,     <= SOURCE LIBRARY        00072000
//             MEMBER=HELLO                    <= SOURCE MEMBER         00073000
