//MATEVAL  JOB (123),'LIST GDG',
//             CLASS=A,MSGCLASS=A,MSGLEVEL=(1,1),
//             NOTIFY=&SYSUID
//**********************************************************************
//* LIST INDIVIDUAL AND CONCATENATED GENERATION DATA SETS
//**********************************************************************
//*
//* Current generation
//*
//COPY1    EXEC PGM=IEBGENER
//SYSIN    DD DUMMY
//SYSPRINT DD SYSOUT=*
//SYSUT1   DD DSN=&SYSUID..SAMPLE.GDG(0),DISP=SHR
//SYSOUT   DD SYSOUT=*
//*
//* One generation back
//*
//COPY2    EXEC PGM=IEBGENER
//SYSIN    DD DUMMY
//SYSPRINT DD SYSOUT=*
//SYSUT1   DD DSN=&SYSUID..SAMPLE.GDG(-1),DISP=SHR
//SYSOUT   DD SYSOUT=*
//*
//* All generations
//*
//COPY2    EXEC PGM=IEBGENER
//SYSIN    DD DUMMY
//SYSPRINT DD SYSOUT=*
//SYSUT1   DD DSN=&SYSUID..SAMPLE.GDG,DISP=SHR,
//            GDGORDER=FIFO
//SYSOUT   DD SYSOUT=*

