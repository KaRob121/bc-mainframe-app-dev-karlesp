       Identification Division.
       Program-Id. ISLEAP3.
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
           if function mod(Year-to-Check 4) not zero
           or function mod(Year-to-Check 100) zero
           and function mod(Year-to-Check 400) not zero    
               set Parm-Normal-Year to true
           else
               set Parm-Leap-Year to true
           end-if
           goback
           .             