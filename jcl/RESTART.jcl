//MATEVAR  JOB (123),'RESTART',
//             CLASS=A,MSGCLASS=A,MSGLEVEL=(1,1),
//*            RESTART=STEP3,
//             NOTIFY=&SYSUID
//********************************************************************* 
//* RESTART JOB AT SPECIFIED STEP
//*********************************************************************
//STEP1    EXEC PGM=IEBGENER 
//SYSIN    DD DUMMY
//SYSPRINT DD SYSOUT=*
//SYSUT1   DD DATA
I was written in STEP1.
/*
//SYSUT2   DD SYSOUT=*
//*
//STEP2    EXEC PGM=IEBGENER 
//SYSIN    DD DUMMY
//SYSPRINT DD SYSOUT=*
//SYSUT1   DD DATA
I was written in STEP2.
/*
//SYSUT2   DD SYSOUT=*
//*
//STEP3    EXEC PGM=IEBGENER 
//SYSIN    DD DUMMY
//SYSPRINT DD SYSOUT=*
//SYSUT1   DD DATA
I was written in STEP3.
/*
//SYSUT2   DD SYSOUT=*
//*