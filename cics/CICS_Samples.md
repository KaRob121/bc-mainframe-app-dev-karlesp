# z/OS Training

## CICS samples

#### Three-Week Curriculum

CICS training in the three-week curriculum is limited to a technical overview and practice with navigating CICS transactions. To provide some transactions to navigate, we have developed a CICS version of the Free Throw Statistics application you worked with in the batch COBOL segment. To set this up in the lab environment, do the following (or ask your instructor to do it):

**Step 1: Upload sample files**

- Upload ```cics/FRTADD.cbl``` as ```<userid>.COBOL.SOURCE(FRTADD)```
- Upload ```cics/FRTDEL.cbl``` as ```<userid>.COBOL.SOURCE(FRTDEL)```
- Upload ```cics/FRTVAL.cbl``` as ```<userid>.COBOL.SOURCE(FRTVAL)```
- Upload ```cics/FRTUPD.cbl``` as ```<userid>.COBOL.SOURCE(FRTUPD)```
- Upload ```cics/FRTVIEW.cbl``` as ```<userid>.COBOL.SOURCE(FRTVIEW)```
- Upload ```cics/FRTHROW.cpy``` as ```<userid>.COBOL.COPY(FRTHROW)```
- Upload ```cics/FTCONST.cpy``` as ```<userid>.COBOL.COPY(FTCONST)```
- Upload ```cics/FRTVMSD2.cpy``` as ```<userid>.COBOL.COPY(FRTVMSD2)```
- Upload ```cics/FRTUMSD.asm``` as ```<userid>.CICS.MAPLIB(FRTUMSD)```
- Upload ```cics/FRTVMSD.asm``` as ```<userid>.CICS.MAPLIB(FRTVMSD)```
- Upload ```cics/CREFRTHR.jcl``` as ```<userid>.INNOV.JCL(CREFRTHR)```
- Upload ```cics/FRSEED.txt``` as ```<userid>.INNOV.FRSEED```, RECFM=FB, LRECL=77, BLKSIZE=7700

**Step 2: Create and load the VSAM KSDS** 

Run job ```CRFRTHR``` to DELETE, DEFINE, and REPRO seed data into ```<userid>.INNOV.FRTHROW```.

**Step 3: Assemble the BMS mapsets** 

Assemble the BMS mapsets - **FRTUMSD** and **FRTVMSG**. The Mathrutech environment provides JCL in ```<userid>.JOBLIB(MAPCOMP)``` to do this. Be sure and change the names of libraries and members to match the sources you are assembling. 

** Step 4: Compile the sample COBOL programs**

The Mathrutech environment provides COBOL CICS compile JCL in ```<userid>.JOBLIB(CICSC)```. Be sure and change the names of libraries and members to match the sources you are assembling.

Step 5: Define and install CICS resources

Sign on to CICS and use CEDA to **DEFINE** and **INSTALL** the following resources:

- File **FRTHROW** - a VSAM KSDS with DSName ```<userid>.INNOV.FRTHROW```, with **BROWSE**, **READ**, **DELETE**, **UPDATE**, and **WRITE** privileges. 

- Programs **FRTVIEW**, **FRTADD**, **FRTDEL**, **FRTUPD**, and **FRTVAL**. All are COBOL programs. 

- Programs **FRTUMSD** and **FRTVMSD**. These are Assembler programs (mapsets).

- Transaction **FRTV** associated with program **FRTVIEW**.

- Transaction **FRTA** associated with program **FRTADD**.

- Transaction **FRTD** associated with program **FRTDEL**.

- Transaction **FRTU** associated with program **FRTUPD**. 

**Step 6: Practice navigating CICS transactions**

Using a 3270 terminal emulator to access CICS, the display consists of a grid of character positions 80 columns wide and 24 rows high. It is not a graphical display.
While you can use your mouse to position the cursor when you use a terminal emulator on a graphical UI like Microsoft Windows, Mac OSX, Gnome, or similar, the 3270 as such does not support pointing devices. Navigation with the keyboard is standard.

The CICS environment is not user-friendly. The basic UI looks like a black screen with a blinking cursor at line 1, column 1. 

If you get stuck, use your terminal emulator's option to simulate the SYS-REQ (System Request) key - standard on 3270 keyboards but nonexistent on your physical keyboard. Then you can type **LOGOFF** and start over.

The Free Throw Statistics application supports Create-Read-Update-Delete (CRUD) operations on the Free Throw KSDS. 

Transaction **FRTV** is the entry point to the application. Type **FRTV** on a blank CICS screen and press **ENTER**. 

On the View screen, you can browse forward and backward through the records in the Free Throw KSDS. The layout and behavior are typical of CICS applications. 

To navigate to the Update (Change) function, type the letter "C" in the Action field next to the record you want to change. That will take you to an update screen with the current contents of the selected record pre-populated. 

Make changes by overtyping the fields that allow input. Press **ENTER** to validate the data, and **PF5** to apply the changes to the Free Throw KSDS. This behavior is typical of CICS applications. 

To return to the View screen, press **PF12**. 

To navigate to the Create (Add) function, type the letter "A" in the Action field next to any record shown on the View screen. You can also clear the screen and type **FRTA** to initiate the Add program. 

The Add program displays an empty form with enterable fields for the new record. Fill in the fields and press **ENTER** to validate your entries, and **PF5** to add the record to the file. 

The behavior is typical of CICS applications. 

To retun to the View screen, press **PF12**. 

To navigate to the Delete function, type the letter "D" in the Action field next to the record you want to delete. That takes you to a "delete" screen that shows the contents of the selected record. 

Press **PF5** to delete the record. The application prompts you to confirm the deletion. You can press **PF5** again to confirm the deletion, or **PF12** to cancel the deletion request. 

If you type transaction identifier **FRTU** or **FRTD** on a cleared screen, the application will "redirect" to the view screen (transaction id **FRTV**), as the update and delete programs must be passed the record key they should operate on. 

These behaviors are typical of CICS applications. 



