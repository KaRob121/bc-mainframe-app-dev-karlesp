//MATEVA1  JOB (123),'COND STEP REF',
//             CLASS=A,MSGCLASS=A,MSGLEVEL=(1,1),
//             NOTIFY=&SYSUID
//**********************************************************************
//* COND WITH REFERENCE TO A SPECIFIC JOB STEP
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
//STEP3    EXEC PGM=IEFBR14,COND=(8,LE,STEP1)