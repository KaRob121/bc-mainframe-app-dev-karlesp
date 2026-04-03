       01  FRTVMAPI.
           02  FILLER PIC X(12).
           02  TRANIDL    COMP  PIC  S9(4).
           02  TRANIDF    PICTURE X.
           02  FILLER REDEFINES TRANIDF.
             03 TRANIDA    PICTURE X.
           02  FILLER   PICTURE X(1).
           02  TRANIDI  PIC X(4).
           02  PAGEL    COMP  PIC  S9(4).
           02  PAGEF    PICTURE X.
           02  FILLER REDEFINES PAGEF.
             03 PAGEA    PICTURE X.
           02  FILLER   PICTURE X(1).
           02  PAGEI  PIC X(3).

           02  LINEI OCCURS 3.
               04  ACTL     COMP  PIC  S9(4).
               04  ACTF     PICTURE X.
               04  FILLER REDEFINES ACTF.
                 05 ACTA     PICTURE X.
               04  FILLER   PICTURE X(1).
               04  ACTI   PIC X(1).
               04  TEAML     COMP  PIC  S9(4).
               04  TEAMF     PICTURE X.
               04  FILLER REDEFINES TEAMF.
                 05 TEAMA     PICTURE X.
               04  FILLER   PICTURE X(1).
               04  TEAMI   PIC X(20).
               04  NAMEL     COMP  PIC  S9(4).
               04  NAMEF     PICTURE X.
               04  FILLER REDEFINES NAMEF.
                 05 NAMEA     PICTURE X.
               04  FILLER   PICTURE X(1).
               04  NAMEI   PIC X(20).
               04  GAMESXL     COMP  PIC  S9(4).
               04  GAMESXF     PICTURE X.
               04  FILLER REDEFINES GAMESXF.
                 05 GAMESXA     PICTURE X.
               04  FILLER   PICTURE X(1).
               04  GAMESXI   PIC X(7).
               04  GAMESL     COMP  PIC  S9(4).
               04  GAMESF     PICTURE X.
               04  FILLER REDEFINES GAMESF.
                 05 GAMESA     PICTURE X.
               04  FILLER   PICTURE X(1).
               04  GAMESI   PIC X(6).
               04  ATTSXL     COMP  PIC  S9(4).
               04  ATTSXF     PICTURE X.
               04  FILLER REDEFINES ATTSXF.
                 05 ATTSXA     PICTURE X.
               04  FILLER   PICTURE X(1).
               04  ATTSXI   PIC X(11).
               04  ATTSL     COMP  PIC  S9(4).
               04  ATTSF     PICTURE X.
               04  FILLER REDEFINES ATTSF.
                 05 ATTSA     PICTURE X.
               04  FILLER   PICTURE X(1).
               04  ATTSI   PIC X(6).
               04  COMPXL     COMP  PIC  S9(4).
               04  COMPXF     PICTURE X.
               04  FILLER REDEFINES COMPXF.
                 05 COMPXA     PICTURE X.
               04  FILLER   PICTURE X(1).
               04  COMPXI   PIC X(12).
               04  COMPL     COMP  PIC  S9(4).
               04  COMPF     PICTURE X.
               04  FILLER REDEFINES COMPF.
                 05 COMPA     PICTURE X.
               04  FILLER   PICTURE X(1).
               04  COMPI   PIC X(6).
               04  THREEXL     COMP  PIC  S9(4).
               04  THREEXF     PICTURE X.
               04  FILLER REDEFINES THREEXF.
                 05 THREEXA     PICTURE X.
               04  FILLER   PICTURE X(1).
               04  THREEXI   PIC X(13).
               04  THREEL     COMP  PIC  S9(4).
               04  THREEF     PICTURE X.
               04  FILLER REDEFINES THREEF.
                 05 THREEA     PICTURE X.
               04  FILLER   PICTURE X(1).
               04  THREEI   PIC X(6).
               04  PCTXL     COMP  PIC  S9(4).
               04  PCTXF     PICTURE X.
               04  FILLER REDEFINES PCTXF.
                 05 PCTXA     PICTURE X.
               04  FILLER   PICTURE X(1).
               04  PCTXI   PIC X(19).
               04  PCTL     COMP  PIC  S9(4).
               04  PCTF     PICTURE X.
               04  FILLER REDEFINES PCTF.
                 05 PCTA     PICTURE X.
               04  FILLER   PICTURE X(1).
               04  PCTI   PIC X(4).
               04  AVGXL     COMP  PIC  S9(4).
               04  AVGXF     PICTURE X.
               04  FILLER REDEFINES AVGXF.
                 05 AVGXA     PICTURE X.
               04  FILLER   PICTURE X(1).
               04  AVGXI   PIC X(13).
               04  AVGL     COMP  PIC  S9(4).
               04  AVGF     PICTURE X.
               04  FILLER REDEFINES AVGF.
                 05 AVGA     PICTURE X.
               04  FILLER   PICTURE X(1).
               04  AVGI   PIC X(4).
               04  UPDXL     COMP  PIC  S9(4).
               04  UPDXF     PICTURE X.
               04  FILLER REDEFINES UPDXF.
                 05 UPDXA     PICTURE X.
               04  FILLER   PICTURE X(1).
               04  UPDXI   PIC X(14).
               04  UPDL     COMP  PIC  S9(4).
               04  UPDF     PICTURE X.
               04  FILLER REDEFINES UPDF.
                 05 UPDA     PICTURE X.
               04  FILLER   PICTURE X(1).
               04  UPDI   PIC X(10).

           02  MSGL    COMP  PIC  S9(4).
           02  MSGF    PICTURE X.
           02  FILLER REDEFINES MSGF.
             03 MSGA    PICTURE X.
           02  FILLER   PICTURE X(1).
           02  MSGI  PIC X(79).
           02  HLPPF7L    COMP  PIC  S9(4).
           02  HLPPF7F    PICTURE X.
           02  FILLER REDEFINES HLPPF7F.
             03 HLPPF7A    PICTURE X.
           02  FILLER   PICTURE X(1).
           02  HLPPF7I  PIC X(9).
           02  HLPPF8L    COMP  PIC  S9(4).
           02  HLPPF8F    PICTURE X.
           02  FILLER REDEFINES HLPPF8F.
             03 HLPPF8A    PICTURE X.
           02  FILLER   PICTURE X(1).
           02  HLPPF8I  PIC X(9).

       01  FRTVMAPO REDEFINES FRTVMAPI.
           02  FILLER PIC X(12).
           02  FILLER PICTURE X(3).
           02  TRANIDC    PICTURE X.
           02  TRANIDO  PIC X(4).
           02  FILLER PICTURE X(3).
           02  PAGEC    PICTURE X.
           02  PAGEO PIC ZZ9.

           02  LINEO OCCURS 3.
               04  FILLER PICTURE X(3).
               04  ACTC     PICTURE X.
               04  ACTO   PIC X(1).
               04  FILLER PICTURE X(3).
               04  TEAMC     PICTURE X.
               04  TEAMO   PIC X(20).
               04  FILLER PICTURE X(3).
               04  NAMEC     PICTURE X.
               04  NAMEO   PIC X(20).
               04  FILLER PICTURE X(3).
               04  GAMESXC     PICTURE X.
               04  GAMESXO   PIC X(7).
               04  FILLER PICTURE X(3).
               04  GAMESC     PICTURE X.
               04  GAMESO  PIC ZZ,ZZ9.
               04  FILLER PICTURE X(3).
               04  ATTSXC     PICTURE X.
               04  ATTSXO   PIC X(11).
               04  FILLER PICTURE X(3).
               04  ATTSC     PICTURE X.
               04  ATTSO  PIC ZZ,ZZ9.
               04  FILLER PICTURE X(3).
               04  COMPXC     PICTURE X.
               04  COMPXO   PIC X(12).
               04  FILLER PICTURE X(3).
               04  COMPC     PICTURE X.
               04  COMPO  PIC ZZ,ZZ9.
               04  FILLER PICTURE X(3).
               04  THREEXC     PICTURE X.
               04  THREEXO   PIC X(13).
               04  FILLER PICTURE X(3).
               04  THREEC     PICTURE X.
               04  THREEO  PIC ZZ,ZZ9.
               04  FILLER PICTURE X(3).
               04  PCTXC     PICTURE X.
               04  PCTXO   PIC X(19).
               04  FILLER PICTURE X(3).
               04  PCTC     PICTURE X.
               04  PCTO  PIC Z9.9.
               04  FILLER PICTURE X(3).
               04  AVGXC     PICTURE X.
               04  AVGXO   PIC X(13).
               04  FILLER PICTURE X(3).
               04  AVGC     PICTURE X.
               04  AVGO  PIC Z9.9.
               04  FILLER PICTURE X(3).
               04  UPDXC     PICTURE X.
               04  UPDXO   PIC X(14).
               04  FILLER PICTURE X(3).
               04  UPDC     PICTURE X.
               04  UPDO  PIC 9999/99/99.

           02  FILLER PICTURE X(3).
           02  MSGC    PICTURE X.
           02  MSGO  PIC X(79).
           02  FILLER PICTURE X(3).
           02  HLPPF7C    PICTURE X.
           02  HLPPF7O  PIC X(9).
           02  FILLER PICTURE X(3).
           02  HLPPF8C    PICTURE X.
           02  HLPPF8O  PIC X(9).
