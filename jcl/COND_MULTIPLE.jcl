//MATEVA1  JOB (123),'COND MULTIPLE',
//             CLASS=A,MSGCLASS=A,MSGLEVEL=(1,1),
//             NOTIFY=&SYSUID
//**********************************************************************
//* COND SPECIFYING MULTIPLE CONDITIONS
//**********************************************************************
//STEP1    EXEC PGM=BOOMER
//STEPLIB  DD DSN=&SYSUID..LOADLIB,DISP=SHR
//*
//* STEP2 runs only if STEP1 fails 
//*
//STEP2    EXEC PGM=IEFBR14,COND=ONLY
//*
//* STEP3 runs only if STEP1 completes with condition code <= 8
//*
//STEP3    EXEC PGM=IEFBR14,COND=((12,GT), (4,LE,STEP2))