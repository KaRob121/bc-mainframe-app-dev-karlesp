***********************************************************************
* Free Throw application - mapset for "view"
***********************************************************************
FRTVMSD  DFHMSD MODE=INOUT,                                            XX
               CTRL=(FREEKB,FRSET),                                    X
               CURSLOC=YES,                                            X
               DSATTS=COLOR,                                           X
               MAPATTS=(COLOR,HILIGHT),                                X
               COLOR=TURQUOISE,                                        X
               STORAGE=AUTO,                                           X
               LANG=COBOL,                                             X
               TIOAPFX=YES,                                            X
               TYPE=&SYSPARM
FRTVMAP DFHMDI SIZE=(24,80),LINE=1,COLUMN=1
TRANID  DFHMDF POS=(1,1),LENGTH=4,ATTRB=(ASKIP,NORM,FSET),             X
               COLOR=YELLOW
        DFHMDF POS=(1,30),LENGTH=21,ATTRB=(ASKIP,NORM),                X
               INITIAL='Free Throw Statistics'
        DFHMDF POS=(1,71),LENGTH=05,ATTRB=(ASKIP,NORM),                X
               INITIAL='Page '
PAGE    DFHMDF POS=(1,77),PICOUT='ZZ9',ATTRB=(ASKIP,BRT)
        DFHMDF POS=(3,1),LENGTH=79,ATTRB=(ASKIP,NORM),                 X
               INITIAL='Action  Team                 Name'
ACT1    DFHMDF POS=(05,3),LENGTH=1,ATTRB=(UNPROT,BRT,IC),              X
               HILIGHT=UNDERLINE,COLOR=YELLOW
        DFHMDF POS=(05,5),LENGTH=0
TEAM1   DFHMDF POS=(05,9),LENGTH=20,ATTRB=(ASKIP,BRT,FSET),            X
               COLOR=YELLOW
NAME1   DFHMDF POS=(05,31),LENGTH=20,ATTRB=(ASKIP,BRT,FSET),           X
               COLOR=YELLOW
GAMESX1 DFHMDF POS=(06,9),LENGTH=7,ATTRB=(ASKIP,NORM),                 X
               INITIAL='Games: '
GAMES1  DFHMDF POS=(06,17),PICOUT='ZZ,ZZ9',ATTRB=(ASKIP,BRT,FSET),     X
               COLOR=YELLOW
ATTSX1  DFHMDF POS=(06,24),LENGTH=11,ATTRB=(ASKIP,NORM),               X
               INITIAL=' Attempts: '
ATTS1   DFHMDF POS=(06,36),PICOUT='ZZ,ZZ9',ATTRB=(ASKIP,BRT,FSET),     X
               COLOR=YELLOW
COMPX1  DFHMDF POS=(06,43),LENGTH=12,ATTRB=(ASKIP,NORM),               X
               INITIAL=' Completed: '
COMP1   DFHMDF POS=(06,56),PICOUT='ZZ,ZZ9',ATTRB=(ASKIP,BRT,FSET),     X
               COLOR=YELLOW
THREEX1 DFHMDF POS=(07,9),LENGTH=13,ATTRB=(ASKIP,NORM),                X
               INITIAL=' 3-pointers: '
THREE1  DFHMDF POS=(07,23),PICOUT='ZZ,ZZ9',ATTRB=(ASKIP,BRT,FSET),     X
               COLOR=YELLOW
PCTX1   DFHMDF POS=(07,30),LENGTH=19,ATTRB=(ASKIP,NORM),               X
               INITIAL='Percent completed: '
PCT1    DFHMDF POS=(07,50),PICOUT='Z9.9',ATTRB=(ASKIP,BRT,FSET),       X
               COLOR=YELLOW
AVGX1   DFHMDF POS=(07,55),LENGTH=13,ATTRB=(ASKIP,NORM),               X
               INITIAL=' Avg points: '
AVG1    DFHMDF POS=(07,69),PICOUT='Z9.9',ATTRB=(ASKIP,BRT,FSET),       X
               COLOR=YELLOW
UPDX1   DFHMDF POS=(08,9),LENGTH=14,ATTRB=(ASKIP,NORM),                X
               INITIAL='Last Updated: '
UPD1    DFHMDF POS=(08,24),PICOUT='9999/99/99',ATTRB=(ASKIP,BRT,FSET), X
               COLOR=YELLOW
ACT2    DFHMDF POS=(10,3),LENGTH=1,ATTRB=(UNPROT,BRT),                 X
               HILIGHT=UNDERLINE,COLOR=YELLOW
        DFHMDF POS=(10,5),LENGTH=0
TEAM2   DFHMDF POS=(10,9),LENGTH=20,ATTRB=(ASKIP,BRT,FSET),            X
               COLOR=YELLOW
NAME2   DFHMDF POS=(10,31),LENGTH=20,ATTRB=(ASKIP,BRT,FSET),           X
               COLOR=YELLOW
GAMESX2 DFHMDF POS=(11,9),LENGTH=7,ATTRB=(ASKIP,NORM),                 X
               INITIAL='Games: '
GAMES2  DFHMDF POS=(11,17),PICOUT='ZZ,ZZ9',ATTRB=(ASKIP,BRT,FSET),     X
               COLOR=YELLOW
ATTSX2  DFHMDF POS=(11,24),LENGTH=11,ATTRB=(ASKIP,NORM),               X
               INITIAL=' Attempts: '
ATTS2   DFHMDF POS=(11,36),PICOUT='ZZ,ZZ9',ATTRB=(ASKIP,BRT,FSET),     X
               COLOR=YELLOW
COMPX2  DFHMDF POS=(11,43),LENGTH=12,ATTRB=(ASKIP,NORM),               X
               INITIAL=' Completed: '
COMP2   DFHMDF POS=(11,56),PICOUT='ZZ,ZZ9',ATTRB=(ASKIP,BRT,FSET),     X
               COLOR=YELLOW
THREEX2 DFHMDF POS=(12,9),LENGTH=13,ATTRB=(ASKIP,NORM),                X
               INITIAL=' 3-pointers: '
THREE2  DFHMDF POS=(12,23),PICOUT='ZZ,ZZ9',ATTRB=(ASKIP,BRT,FSET),     X
               COLOR=YELLOW
PCTX2   DFHMDF POS=(12,30),LENGTH=19,ATTRB=(ASKIP,NORM),               X
               INITIAL='Percent completed: '
PCT2    DFHMDF POS=(12,50),PICOUT='Z9.9',ATTRB=(ASKIP,BRT,FSET),       X
               COLOR=YELLOW
AVGX2   DFHMDF POS=(12,55),LENGTH=13,ATTRB=(ASKIP,NORM),               X
               INITIAL=' Avg points: '
AVG2    DFHMDF POS=(12,69),PICOUT='Z9.9',ATTRB=(ASKIP,BRT,FSET),       X
               COLOR=YELLOW
UPDX2   DFHMDF POS=(13,9),LENGTH=14,ATTRB=(ASKIP,NORM),                X
               INITIAL='Last Updated: '
UPD2    DFHMDF POS=(13,24),PICOUT='9999/99/99',ATTRB=(ASKIP,BRT,FSET), X
               COLOR=YELLOW
ACT3    DFHMDF POS=(15,3),LENGTH=1,ATTRB=(UNPROT,BRT),                 X
               HILIGHT=UNDERLINE,COLOR=YELLOW
        DFHMDF POS=(15,5),LENGTH=0
TEAM3   DFHMDF POS=(15,9),LENGTH=20,ATTRB=(ASKIP,BRT,FSET),            X
               COLOR=YELLOW
NAME3   DFHMDF POS=(15,31),LENGTH=20,ATTRB=(ASKIP,BRT,FSET),           X
               COLOR=YELLOW
GAMESX3 DFHMDF POS=(16,9),LENGTH=7,ATTRB=(ASKIP,NORM),                 X
               INITIAL='Games: '
GAMES3  DFHMDF POS=(16,17),PICOUT='ZZ,ZZ9',ATTRB=(ASKIP,BRT,FSET),     X
               COLOR=YELLOW
ATTSX3  DFHMDF POS=(16,24),LENGTH=11,ATTRB=(ASKIP,NORM),               X
               INITIAL=' Attempts: '
ATTS3   DFHMDF POS=(16,36),PICOUT='ZZ,ZZ9',ATTRB=(ASKIP,BRT,FSET),     X
               COLOR=YELLOW
COMPX3  DFHMDF POS=(16,43),LENGTH=12,ATTRB=(ASKIP,NORM),               X
               INITIAL=' Completed: '
COMP3   DFHMDF POS=(16,56),PICOUT='ZZ,ZZ9',ATTRB=(ASKIP,BRT,FSET),     X
               COLOR=YELLOW
THREEX3 DFHMDF POS=(17,9),LENGTH=13,ATTRB=(ASKIP,NORM),                X
               INITIAL=' 3-pointers: '
THREE3  DFHMDF POS=(17,23),PICOUT='ZZ,ZZ9',ATTRB=(ASKIP,BRT,FSET),     X
               COLOR=YELLOW
PCTX3   DFHMDF POS=(17,30),LENGTH=19,ATTRB=(ASKIP,NORM),               X
               INITIAL='Percent completed: '
PCT3    DFHMDF POS=(17,50),PICOUT='Z9.9',ATTRB=(ASKIP,BRT,FSET),       X
               COLOR=YELLOW
AVGX3   DFHMDF POS=(17,55),LENGTH=13,ATTRB=(ASKIP,NORM),               X
               INITIAL=' Avg points: '
AVG3    DFHMDF POS=(17,69),PICOUT='Z9.9',ATTRB=(ASKIP,BRT,FSET),       X
               COLOR=YELLOW
UPDX3   DFHMDF POS=(18,9),LENGTH=14,ATTRB=(ASKIP,NORM),                X
               INITIAL='Last Updated: '
UPD3    DFHMDF POS=(18,24),PICOUT='9999/99/99',ATTRB=(ASKIP,BRT,FSET), X
               COLOR=YELLOW
        DFHMDF POS=(22,1),LENGTH=79,ATTRB=(ASKIP,NORM),                X
               INITIAL='Action: A=Add, C=Change, D=Delete'
MSG     DFHMDF POS=(23,1),LENGTH=79,ATTRB=(ASKIP,BRT),COLOR=YELLOW
        DFHMDF POS=(24,1),LENGTH=19,ATTRB=(ASKIP,NORM),                X
               INITIAL='ENTER Take Action  '
HLPPF7  DFHMDF POS=(24,21),LENGTH=9,ATTRB=(ASKIP,NORM),                X
               INITIAL='PF7 Prev '
HLPPF8  DFHMDF POS=(24,31),LENGTH=9,ATTRB=(ASKIP,NORM),                X
               INITIAL='PF8 Next '
        DFHMDF POS=(24,41),LENGTH=26,ATTRB=(ASKIP,NORM),               X
               INITIAL='PF12 Exit'
        DFHMSD TYPE=FINAL
        END
