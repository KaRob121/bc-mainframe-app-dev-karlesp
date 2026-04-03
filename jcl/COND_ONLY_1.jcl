//MATEVA1  JOB (123),'COND=ONLY EXAMPLE',
//             CLASS=A,MSGCLASS=A,MSGLEVEL=(1,1),
//             NOTIFY=&SYSUID
//**********************************************************************
//* SKIP STEP2 UNLESS A PRIOR STEP FAILS
//**********************************************************************
//STEP1    EXEC PGM=IEFBR14
//*
//* STEP2 runs only if STEP1 fails
//*
//STEP2    EXEC PGM=IEFBR14,COND=ONLY