//MATEVAX  JOB (123),'INIT AIX',
//             CLASS=A,MSGCLASS=A,MSGLEVEL=(1,1),
//             NOTIFY=&SYSUID
//**********************************************************************
//* DEFINE AN ALTERNATE INDEX AND PATH AND BUILD THE INDEX
//**********************************************************************
//INITAIX   EXEC PGM=IDCAMS
//SYSPRINT  DD SYSOUT=*
//SYSOUT    DD SYSOUT=*
//SYSIN     DD *
 DELETE MATEVA.DATA.AIX 
 IF LASTCC < 9 THEN -
 DEFINE AIX( -
   NAME(MATEVA.DATA.AIX) -
   RELATE(MATEVA.DATA.KSDS2) -
   CYLINDERS(2 1) - 
   CISZ(4096) -
   FREESPACE(10 20) -
   KEYS(15 4) -
   NONUNIQUEKEY -
   VOLUMES(DEVHD3) -
 )
 IF LASTCC = 0 THEN -
   DEFINE PATH (NAME(MATEVA.DATA.AIX.PATH) -
                PATHENTRY(MATEVA.DATA.AIX) UPDATE)
   IF LASTCC = 0 THEN -
     BLDINDEX -
       INDATASET(MATEVA.DATA.KSDS2) -
       OUTDATASET(MATEVA.DATA.AIX) 
/*   