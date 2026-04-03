//MATEVAG  JOB (123),'LOAD GDS',
//             CLASS=A,MSGCLASS=A,MSGLEVEL=(1,1),
//             NOTIFY=&SYSUID
//**********************************************************************
//* COPY IN-LINE DATA TO A GDS USING IEBGENER
//**********************************************************************
//COPY1    EXEC PGM=IEBGENER
//SYSIN    DD DUMMY
//SYSPRINT DD SYSOUT=*
//SYSUT1   DD DATA
To die: To sleep; no more.
And by a sleep to say we end the heart-ache
and the thousand natural shocks that flesh is heir to,
'tis a consummation devoutly to be wished.
/*
//SYSUT2   DD DSN=&SYSUID..SAMPLE.GDG(+1),
//            DISP=(NEW,CATLG,DELETE),
//            DCB=&SYSUID..MODELDCB.GDG,
//            SPACE=(TRK,(1,1),RLSE),UNIT=SYSDA 