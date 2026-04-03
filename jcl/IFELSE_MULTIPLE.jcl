//MATEVA1  JOB (123),'IF/ELSE MULTIPLE',
//             CLASS=A,MSGCLASS=A,MSGLEVEL=(1,1),
//             NOTIFY=&SYSUID
//**********************************************************************
//* IF STATEMENTS SPECIFYING MULTIPLE CONDITIONS
//**********************************************************************
//STEP1    EXEC PGM=BOOMER
//STEPLIB  DD DSN=&SYSUID..LOADLIB,DISP=SHR
//*
//* STEP2 runs only if STEP1 fails 
//*
//         IF (ABEND | STEP1.RC < 5) THEN
//STEP2    EXEC PGM=IEFBR14
//         ENDIF
//*
//* STEP3 runs only if STEP1 completes with condition code <= 8
//*
//         IF (RC > 12 & STEP2.RC <= 4) THEN
//STEP3    EXEC PGM=IEFBR14
//         ENDIF