//MATEVAB JOB 'COBOL BATCH',                                            00010001
//            MSGLEVEL=(1,1),NOTIFY=&SYSUID                             00020001
//CMP     EXEC IGYWCL,PGMLIB=&SYSUID..INNOV.PGMLIB,                     00070003
//             GOPGM=LEAP4,PARM.COBOL='LIB'                             00070239
//COBOL.SYSIN DD DSN=&SYSUID..COBOL.SOURCE(LEAP4),DISP=SHR              00070339
//COBOL.SYSLIB DD DSN=&SYSUID..COBOL.COPY,DISP=SHR                      00070401
//LKED.SYSLIB DD DSN=&LIBPRFX..SCEELKED,DISP=SHR                        00070534
//            DD DSN=&SYSUID..INNOV.PGMLIB,DISP=SHR                     00070634
