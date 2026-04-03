***********************************************************************
* Free Throw application - mapset for "add" and "update"
***********************************************************************
FRTUMSD  DFHMSD MODE=INOUT,                                            XX
               CTRL=(FREEKB,FRSET),                                    X
               CURSLOC=YES,                                            X
               DSATTS=COLOR,                                           X
               MAPATTS=(COLOR,HILIGHT),                                X
               COLOR=TURQUOISE,                                        X
               STORAGE=AUTO,                                           X
               LANG=COBOL,                                             X
               TIOAPFX=YES,                                            X
               TYPE=&SYSPARM
FRTUMAP DFHMDI SIZE=(24,80),LINE=1,COLUMN=1
TRANID  DFHMDF POS=(1,1),LENGTH=4,ATTRB=(ASKIP,NORM,FSET),             X
               COLOR=YELLOW
        DFHMDF POS=(1,28),LENGTH=23,ATTRB=(ASKIP,NORM),                X
               INITIAL='Free Throw Statistics -'
SCRTITL DFHMDF POS=(01,52),LENGTH=10,ATTRB=(ASKIP,NORM,FSET)
        DFHMDF POS=(03,01),LENGTH=16,ATTRB=(ASKIP,NORM),               X
               INITIAL='     Team Name: '
TEAM    DFHMDF POS=(03,18),LENGTH=20,ATTRB=(UNPROT,BRT,IC),            X
               COLOR=YELLOW,HILIGHT=UNDERLINE
        DFHMDF POS=(03,39),LENGTH=0
        DFHMDF POS=(04,01),LENGTH=16,ATTRB=(ASKIP,NORM),               X
               INITIAL='   Player Name: '
NAME    DFHMDF POS=(04,18),LENGTH=20,ATTRB=(UNPROT,BRT),               X
               COLOR=YELLOW,HILIGHT=UNDERLINE
        DFHMDF POS=(04,39),LENGTH=0
        DFHMDF POS=(05,01),LENGTH=16,ATTRB=(ASKIP,NORM),               X
               INITIAL='  Games Played: '
GAMES   DFHMDF POS=(05,18),PICOUT='ZZ,ZZ9',ATTRB=(UNPROT,BRT),         X
               COLOR=YELLOW,HILIGHT=UNDERLINE
        DFHMDF POS=(05,25),LENGTH=0
        DFHMDF POS=(06,01),LENGTH=23,ATTRB=(ASKIP,NORM),               X
               INITIAL='Free Throws Attempted: '
ATTS    DFHMDF POS=(06,25),PICOUT='ZZ,ZZ9',ATTRB=(UNPROT,BRT),         X
               COLOR=YELLOW,HILIGHT=UNDERLINE
        DFHMDF POS=(06,32),LENGTH=14,ATTRB=(ASKIP,NORM),               X
               INITIAL='   Completed: '
COMP    DFHMDF POS=(06,47),PICOUT='ZZ,ZZ9',ATTRB=(UNPROT,BRT),         X
               COLOR=YELLOW,HILIGHT=UNDERLINE
        DFHMDF POS=(06,54),LENGTH=15,ATTRB=(ASKIP,NORM),               X
               INITIAL='   3-Pointers: '
THREE   DFHMDF POS=(06,70),PICOUT='ZZ,ZZ9',ATTRB=(UNPROT,BRT),         X
               COLOR=YELLOW,HILIGHT=UNDERLINE
        DFHMDF POS=(06,77),LENGTH=0
        DFHMDF POS=(08,31),LENGTH=17,ATTRB=(ASKIP,NORM),               X
               INITIAL='Calculated Values'
        DFHMDF POS=(10,01),LENGTH=19,ATTRB=(ASKIP,NORM),               X
               INITIAL='Percent Completed: '
PCT     DFHMDF POS=(10,21),PICOUT='ZZ9.9',ATTRB=(ASKIP,BRT),           X
               COLOR=YELLOW
        DFHMDF POS=(10,27),LENGTH=31,ATTRB=(ASKIP,NORM),               X
               INITIAL='   Average FT Points per Game: '
AVG     DFHMDF POS=(10,59),PICOUT='Z9.9',ATTRB=(ASKIP,BRT),            X
               COLOR=YELLOW
        DFHMDF POS=(10,64),LENGTH=0
        DFHMDF POS=(11,01),LENGTH=27,ATTRB=(ASKIP,NORM),               X
               INITIAL='Last Updated (YYYY/MM/DD): '
UPD     DFHMDF POS=(11,29),PICOUT='9999/99/99',ATTRB=(ASKIP,BRT),      X
               COLOR=YELLOW
MSG     DFHMDF POS=(23,1),LENGTH=79,ATTRB=(ASKIP,BRT),COLOR=YELLOW
        DFHMDF POS=(24,1),LENGTH=79,ATTRB=(ASKIP,NORM),                X
               INITIAL='ENTER Validate  PF5 Save  PF12 Cancel'
        DFHMSD TYPE=FINAL
        END
