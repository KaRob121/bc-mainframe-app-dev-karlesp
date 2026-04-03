//MATEVA1  JOB (123),'COND=EVEN EXAMPLE',
//             CLASS=A,MSGCLASS=A,MSGLEVEL=(1,1),
//             NOTIFY=&SYSUID
//**********************************************************************
//* EXECUTE STEP2 EVEN IF A PRIOR STEP FAILS
//**********************************************************************
//STEP1    EXEC PGM=BOOMER
//STEPLIB  DD DSN=&SYSUID..LOADLIB,DISP=SHR
//*
//* STEP2 runs even if STEP1 fails
//*
//STEP2    EXEC PGM=IEFBR14,COND=EVEN