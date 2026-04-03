//MATEVAF  JOB (123),'CREATE FRTHROW',
//             CLASS=A,MSGCLASS=A,MSGLEVEL=(1,1),
//             NOTIFY=&SYSUID
//*******************************************************************
//* CREATE KSDS FOR THE FREETHROW EXERCISE
//*******************************************************************
//CATGDG   EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//FRSEED   DD DSN=MATEVA.INNOV.FRSEED,DISP=SHR
//SYSIN    DD *
 DELETE MATEVA.INNOV.FRTHROW
 IF LASTCC < 9 THEN -
  DEFINE CLUSTER(NAME(MATEVA.INNOV.FRTHROW) -
    RECORDSIZE(77 77)    -
    CYLINDERS(2 1)       -
    FREESPACE(10 20)     -
    KEYS(40 0)           -
    CISZ(4096)           -
    VOLUMES(DEVHD3)      -
    INDEXED)             -
  INDEX(NAME(MATEVA.INNOV.FRTHROW.INDEX)) -
  DATA(NAME(MATEVA.INNOV.FRTHROW.DATA))
  IF LASTCC = 0 THEN -
    REPRO -
      INFILE(FRSEED) -
      OUTDATASET(MATEVA.INNOV.FRTHROW)
/*
