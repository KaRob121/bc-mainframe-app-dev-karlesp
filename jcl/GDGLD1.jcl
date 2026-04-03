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
To be, or not to be, that is the question:
Whether 'tis nobler in the mind to suffer
The slings and arrows of outrageous fortune
Or to take arms against a sea of troubles
And by opposing end them.
/*
//SYSUT2   DD DSN=&SYSUID..SAMPLE.GDG(+1),
//            DISP=(NEW,CATLG,DELETE),
//            DCB=&SYSUID..MODELDCB.GDG,
//            SPACE=(TRK,(1,1),RLSE),UNIT=SYSDA 