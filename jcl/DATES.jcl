//jobname JOB 'DATES',
//            MSGLEVEL=(1,1),NOTIFY=&SYSUID
//JOBLIB  DD DSN=&SYSUID..midlevel.lowlevel,DISP=SHR
//RUN     EXEC PGM=DATES
//* The SYSIN data set contains records that will be
//* read when the program issues an ACCEPT statement.
//SYSIN   DD *
2023123100305000-0600
2024034
/*
//SYSOUT DD SYSOUT=*