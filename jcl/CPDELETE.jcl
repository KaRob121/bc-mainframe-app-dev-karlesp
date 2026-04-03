//MATEVA5  JOB (123),'MOVE DATA SET',
//             CLASS=A,MSGCLASS=A,MSGLEVEL=(1,1),
//             NOTIFY=&SYSUID
//********************************************************************* 
//* "MOVE" A DATA SET BY COPYING IT AND DELETING THE OLD ONE
//*********************************************************************
//COPY     EXEC PGM=IEBGENER 
//SYSIN    DD DUMMY
//SYSPRINT DD SYSOUT=*
//SYSUT1   DD DSN=&SYSUID..INNOV.HAMLET,
//            DISP=(OLD,DELETE,KEEP)
//SYSUT2   DD DSN=&SYSUID..INNOV.SPEECH,
//            DISP=(NEW,CATLG,DELETE),
//            SPACE=(TRK,(1,1),RLSE),
//            DCB=(DSORG=PS,RECFM=FB,LRECL=80,BLKSIZE=1600),
//            UNIT=SYSDA 