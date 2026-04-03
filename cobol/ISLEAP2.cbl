       Identification Division.
       Program-Id. ISLEAP2.
      *****************************************************************
      * Determine whether a given year is a leap year. 
      * Called with a single parameter area by content.
      *****************************************************************
       Data Division.
       Linkage Section.
       01  Year-to-Check                 pic 9(4).
       01  Is-Leap-Year                  pic x.
           88  Normal-Year               value "N".
           88  Leap-Year                 value "L".
       Procedure Division 
               using Year-to-Check
               returning Is-Leap-Year.
           evaluate true
               when function mod(Parm-Year 4) not zero
               when function mod(Parm-Year 100) zero
                and function mod(Parm-Year 400) not zero
                   set Parm-Normal-Year to true
               when other
                   set Parm-Leap-Year to true
           end-evaluate
           goback
           .             