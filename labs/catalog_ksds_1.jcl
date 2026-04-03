//USERIDK  JOB 'CREATE KSDS',
//             CLASS=A,MSGCLASS=A,MSGLEVEL=(1,1),
//             NOTIFY=&SYSUID
//*********************************************************************
//* Is this a meaningful comment?
//*********************************************************************
//CATKSDS  EXEC PGM=IDCAMS
//KSDSDATA DD DSN=USERID.INNOV.DATA1,DISP=SHR
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
 DELETE USERID.INNOV.KSDS
 IF LASTCC = 0 THEN -
   DEFINE CLUSTER(USERID.INNOV.KSDS1) -
     RECORDSIZE(40 40) -
     TRACKS(1 2) -
     FREESPACE(10 20) - 
     KEYS(5 0) -
     CISZ(4096) -
     VOLUMES(DEVHD3) -
     NONINDEXED) -
   INDEX(NAME(USERID.INNOV.KSDS1.INDEX)) -
   DATA(NAME(USERID.INNOV.KSDS1.DATA))
   IF LASTCC = 0 THEN -
     LISTCAT - 
       ENTRIES(USERID.INNOV.KSDS1) -
       ALL
     IF LASTCC = 0 THEN -
       REPRO -
         INFILE(KSDSDATA) -
         OUTDATASET(USERID.INNOV.KSDS)
       IF LASTCC = 0 THEN - 
         PRINT INDATASET(USERID.INNOV.KSDS1) -
           CHARACTER
/*         