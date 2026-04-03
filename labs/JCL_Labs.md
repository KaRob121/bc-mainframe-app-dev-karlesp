[README](../README.md) 

# z/OS JCL Labs 

### JCL Lab 1 - Create sequential data set with IEFBR14 

In the JCL library provided in the lab environment, create a job containing one step that executes utility IEFBR14. Code a DD statement for that step to allocate and catalog a sequential data set with the name ```shell <userid>.TEST.QSAM1```. 

Create a new member in the ```userid.JOBLIB``` library for this JCL. Use the sample IEFBR14 JCL provided in your initial setup as a general guide, but don't use that JCL directly for this exercise.

Be sure the job name on the JOB statement is _your userid_ with the numeral "1" appended to it. For example, if your userid is ```MATEXX``` then the job name will be ```MATEXX1```.

Allocate space in tracks with 1 track primary and 1 track secondary, and specify that unused space is to be released. 

Specify the volume you are required to use per the setup email. If you did not receive a setup email, ask your instructor for guidance on this. Always use this volume in the subsequent labs.

For the DISP parameter on the DD statement: The status of the data set is NEW. If the step is successful, catalog the data set; otherwise, delete it. 

Use SDSF to review the job output. 

Use ISPF Option 3.4 to check the attributes of the new data set to be sure they are what you expected based on your DD parameters.

**Detailed instructions**

Usually we will provide detailed instructions for things you haven't done before. In general, we will expect you to apply what you have learned and fill in the details for lab exercises.

In the instructions, we use capital letters ```LIKE THIS``` for ISPF keywords and lower-case letters ```like this``` for user-specific values that you code in your JCL. The system itself is not case-sensitive. Where we ask you to type ```CREATE``` you can type ```create```.

1. Use ISPF Option 3.4, Data Set List Utility, to find your data sets. In the field ```Dsname level```, type your userid. Leave the other fields empty. Press ENTER. This displays a list of the data sets that are catalogued under your userid. 
2. Navigate using arrow and tab keys to the entry, ```userid.JOBLIB```. This is the JCL library provided for developer accounts on the system. 
3. In the ```Command``` field to the left of the data set name, type the letter ```E``` (for _edit_) and press ENTER. This will take you to ISPF Option 2, Edit, and open the member list for data set ```userid.JOBLIB```. 
4. Navigate to the member name ```IEFBR14```. In the ```Command``` field to the left of the member name, type the letter ```S``` (for _select_) and press ENTER. This opens member ```IEFBR14``` in the ISPF editor. 
5. Now you will create a new member in the same library by using the ISPF ```CREATE``` command. In the ```Command``` field at the top of the editor, type ```CREATE userid1``` but don't press ENTER yet. If your user id is ```MATEXX```, the value of ```userid1``` should be ```MATEXX1```. 
6. Use the ISPF ```cc``` line command to select the lines you want to copy into the new member you are creating. In this case, you want the flowerbox comments just above job step ```STEP10``` and all the lines down to the next flowerbox. Those are (probably) lines 3 and 15. Type ```cc``` on line 3 and ```cc``` on line 15 (or whatever the line numbers are in your case).
7. Now visually examine what you have typed. The ```Command``` field at the top should have ```CREATE userid1``` and there should be ```cc``` line commands bracketing all of job step ```STEP10```. Make any necessary corrections, and press ENTER. 
8. A message at the upper right-hand corner of the display should read, ```MEMBER userid1 CREATED```. 
9. Press ```PF12``` to exit from member ```IEFBR14``` without saving changes. 
10. Now you can use ISPF Option 2, Edit, to edit the new member ```userid1```. 
11. In member ```userid1```, make sure the job name on the JOB statement is ```userid1```. 
12. On the DD statement, specify the volume serial for the volume the system owners want us to use, probably ```DEVHD3``` but possibly different - check your developer access email. 
13. Visually examine your JCL to see that it looks correct. Be especially careful about the job name on the JOB statement and the volumne serial specification on the DD statement, because those pertain to compliance with rules for using the system. 
14. To save your changes, type ```SAVE``` in the ```Command``` field. 
15. To submit the job, type ```SUB``` in the ```Command``` field. TSO will display a message stating that the job has been submitted, or an error message. This may happen immediately or after a short delay, depending on how busy the system is as the moment.
16. After reading the TSO message, press ```ENTER``` to dismiss it. 
17. TSO will also display a message giving the completion status of the job. The submit and status messages may appear together, as these operations take very little time. A completion code of 0000 means the job was successful. 
18. To see the output from your job, navigate to SDSF from the ISPF Primary Option Menu, option ```S```, or by typing ```=S``` in any field that accepts commands (most fields do). 
19. SDSF displays a list of _queues_ where the system stores input and output data sets. The output from your job will be in the Held queue. Choose option ```H``` to view this queue. You will see a list of all the job output for jobs whose names begin with your userid. At this point, there should be one job there, named ```userid1```. 
20. Type a question mark (```?```) next to the job name, ```userid1```. SDSF will display a list of three output data sets that were created when the job ran - unless you had a JCL error. 
21. Next to data set name ```JESMSGLG``` (Job Entry Subsystem message log), type ```s``` and press ```ENTER```. This will open the data set read-only.
22. Read the contents of ```JESMSGLG``` and see if you can understand the information. It shows all the steps that were executed and the procedures where the steps are defined. In this case, there is one job step and no procedures. The ```RC``` value is the return code from the step. A value of zeros means the step ran successfully. We also see how many "cards" were read (remember, z/OS thinks it's still reading punched cards), how many output records were written, and how much space the output data is taking up in the system spooler. It also gives the execution time, which in this case is probably zero because the job ran very quickly. 
23. Use ```PF3``` to return to the list of SDSF output data sets. 
24. Type an ```s``` next to data set name ```JESJCL``` to open it. This data set contains the JCL statements that were processed to run the job. It shows how any symbols were resolved. In this case, you have the symbol ```&SYSUID``` in your JCL. Here you can see that JES substituted your userid wherever that symbol appears in the JCL. This can be good to know if you're troubleshooting a job and it had the wrong symbol or an undefined symbol somewhere. 
25. Use ```PF3``` to return to the list of SDSF output data sets.
26. Type an ```s``` next to data set name ```JESYSMSG``` to open it. This data set contains any system-generated messages that were output during execution of the job. You see the start and stop times for each job step and information about all data sets that were accessed in the job. In this case, you can see that data set ```userid.TEST.QSAM1``` was catalogued and it resides on volume serial ```DEVHD3```. You can also see the job step ended with completion code zero, success. 
27. Use ```PF3``` to return to the list of SDSF output data sets. Use ```PF3``` again to return to the list of data sets in the Held queue. If you want to get rid of the SDSF output, type the letter ```P``` (for _purge_) next to the job name and press ```ENTER```. SDSF will display a dialog asking what you want to do. Choose option ```1``` to purge the data sets. 
28. Now verify that the data set was created with the characteristics you intended. Either return to the ISPF Primary Opton Menu and choose option 3.4, or enter ```=3.4``` in the Command field.
29. You've already seen how to look for your data sets under Option 3.4. Do that again to see the list of your data sets. The new one, ```userid.TEST.QSAM```, will be listed. 
30. Navigate to that entry and type the letter ```s``` (for _select_) next to it, and press ENTER. This displays information about the data set. Examine the values and see if you understand what they mean, or can make a reasonable guess about what they might mean. Ensure the data set was created with the characteristics you intended to code in your JCL. 



### JCL Lab 2 - Create and load a sequential data set 

Create a job containing one step that executes utility IEBGENER. 

For SYSUT1, code an in-line data set containing a few records with whatever text you wish. 

For SYSUT2, code a DD statement to create a sequential data set similar to your ```<userid>.TEST.QSAM1``` and name it ```<userid>.TEST.QSAM2```. Make it a fixed-blocked data set with 80-byte records and 16000-byte blocks.

Use SDSF to review the results of the run and see that the records you coded under SYSUT1 were loaded into the new QSAM2 data set.

Use ISPF Option 3.4 to check the attributes of the new data set to be sure they are what you expected based on your DD parameters.



### JCL Lab 3 - Create a source library with IEFBR14

In the JCL library provided in the lab environment, create a job containing one step that executes utility IEFBR14. Code a DD statement for that step to allocate and catalog a library (that is, a PDSE) suitable for storing program source. Remember all program source in traditional mainframe languages consists of 80-character records, so you will want the library to house 80-byte records. Make the blocksize an even multiple of 80. Name the new library ```<userid>.COBOL.SOURCE```.

Allocate space in tracks with 2 tracks primary and 8 tracks secondary. Specify 10 directory blocks. 

If the step is successful, catalog the data set; otherwise, delete it.

Use SDSF to review the job output. 

Use ISPF Option 3.4 to check the attributes of the new data set to be sure they are what you expected based on your DD parameters.



### JCL Lab 4 - Create a model DSCB

In the JCL library provided in the lab environment, create a job to run IEFBR14. 

Using the material for _JCL Module 6 - IEBGENER_ and _JCL Module 10 - PDS_ as a guide, code a DD statement to catalog a model DSCB for a PDSE (Library) suitable for JCL and program source. It will have record format fixed-blocked, logical record length 80, and block size a multiple of 80. 

Use SDSF to review the job output. 

Use ISPF Option 3.4 to check the attributes of the new data set to be sure they are what you expected based on your DD parameters.

From now on, use your JCL library instead of the default one provided in the lab environment.



### JCL Lab 5 - Use the model DSCB to create a JCL library

The task is to write a job stream that creates a JCL library and copies the members of the default JCL library to the new one in a single step.

Create a job to run IEBCOPY. See _JCL Module 10 - PDS_ for information about IEBCOPY. 

Code the SYSUT1 DD statement to refer to the default JCL library provided in the lab environment. It will be the source of the copy operation. 

Refer to the model DSCB you created in Lab 4 in the DCB parameter of the SYSUT2 DD statement to create another PDSE. Name this PDSE ```<userid>.INNOV.JCL```. Allocate space in tracks with 2 primary, 8 secondary, and 10 directory blocks. 

Use SDSF to review the job output. 

Use ISPF Option 3.4 to check the attributes of the new data set to be sure they are what you expected based on your DD parameters.

Use ISPF Option 1 to see the members in ```<userid>.INNOV.JCL``` and make sure all the members were copied from the default JCL library to the new one.

From now on, use your JCL library instead of the default one that was provided.



### JCL Lab 6 - Use the model DSCB to create a COBOL source library

The task is to write a job stream that creates a source library for COBOL code.

Refer to the model DSCB you created in Lab 4 in the DCB parameter of the SYSUT2 DD statement to create another PDSE. Name this PDSE ```<userid>.INNOV.JCL```. Allocate space in tracks with 2 primary, 8 secondary, and 10 directory blocks. 

Use SDSF to review the job output. 

Use ISPF Option 3.4 to check the attributes of the new data set to be sure they are what you expected based on your DD parameters.

From now on, use your COBOL source library for COBOL source code.



### JCL Lab 7 - Create a program object library

The task is to write a job stream that creates a program object library - that is, a PDSE as opposed to a PDS load library. Name it ```<userid>.INNOV.PGMLIB```.

Use SDSF to review the job output. 

Use ISPF Option 3.4 to check the attributes of the new data set to be sure they are what you expected based on your DD parameters.

From now on, use your COBOL source library for COBOL source code.



### JCL Lab 8 - Sort on two fields 

Refer to material in _JCL Module 7 - Sort_ for information about DFSORT.

Upload file ```labs/sort_input_1.txt``` from this repository to z/OS data set ```<userid>.DATA.SRTIN1```. Format is fixed-blocked, logical record length is 46, block size is 460. Allocate 1 track primary, 1 track secondary.

The SRTIN1 data set will be the input to a SORT (the SORTIN DD).

The record layout is:

Pos 1-6  Salesperson Id          1- 6
Pos 7-36 Name                    7-36 
Pos 37-38 Month                  37-38
Pos 39-46 Value of Closed Sales  39-46

Code a job stream to execute SORT to sort the SRTIN1 data set on:
    
- Month ascending 
- Value of Closed Sales descending 
- Name ascending 

Format the output records as follows:

Pos 1-2 Month
Pos 3-10 Value of Closed Sales
Pos 11-16 Salesperson Id
Pos 17-46 Name

Catalog the output data set as ```<userid>.DATA.SRTOUT1```. Remember to pad the output records with spaces. 



### JCL Lab 9 - Multi-step sort, catalogued procedures, and conditional execution  

Refer to material in _JCL Module 8 - PROC_ for information on temporary data sets and stored procedures and _JCL Module 9 - COMD_ for information on conditional step execution.

Upload file ```labs/sort_input_2.txt``` from this repository. Name the z/OS data set ```<userid>.DATA.SRTIN2```. It has the same attributes as ```<userid>.DATA.SRTIN2```. 

The SORT specifications are the same as in Lab 6. This time, write a job stream that sorts each of the two input data sets in separate steps. The SORTOUT datasets are to be temporary data sets.

The two steps will be identical except for the names of the data sets. Extract that JCL into a procedure and catalog the procedure. The final job stream will invoke the procedure twice instead of duplicating the SORT JCL in both steps. If the first SORT fails, don't execute the second SORT. 

After running the two sorts, execute SORT again to merge the sorted data sets (the temporary data sets). If any previous step fails, don't execute the merge step.

Catalog the output data set as ```<userid>.DATA.SRTOUT2```.  



### JCL Lab 10 - Create and load a GDG

Refer to material in _JCL Module 11 - GDG_ for information on Generation Data Groups (GDGs) and Generation Data Sets (GDSs). 

Upload files ```labs/gds_input_1.txt```, ```labs/gds_input_2.txt```, and ```labs/gds_input_3.txt``` as ```<userid>.DATA.GDSIN1```, ```GDSIN2```, and ```GDSIN3``` respectively. 

Create a job that defines a model DSCB specifying fixed-blocked format, logical record length 80, and block size 16000. 

Create a job that runs the IDCAMS utility to delete/define a Generation Data Group named ```<userid>.INNOV.GDG1```. 

Create a job that copies a QSAM data set to the next GDS (that is, the +1 generation) of the new GDG. 

Either (1) run the copy job three times or (2) duplicate the copy step three times in the same job or (3) define a JCL procedure for the copy step and invoke it three times in the copy job to copy ```<userid>.DATA.GDSIN1```, ```GDSIN2```, and ```GDSIN3``` to the GDG you created. 

Use ISPF Option 3.4 to verify the results of the various steps in the lab exercise. 

Create a job that copies the current generation of the GDG to SYSOUT. 

Use SDSF to see that the correct version was copied to SYSOUT. 



### JCL Lab 11 - Create and load a VSAM KSDS 

Refer to material in _JCL Module 12 - VSAM_ for information on using IDCAMS to manage VSAM data sets. 

Upload file ```labs/ksds_data_1.txt``` as ```<userid>.INNOV.DATA1```. Specify format fixed-blocked, logical record length 40, block size 16000.

Upload file ```labs/catalog_ksds.jcl``` as ```<userid>.INNOV.JCL(CATKSDS)```.

Run the CATKSDS job to delete, define, listcat, load, and print a Key Sequenced Data Set (KSDS) named ```<userid>.INNOV.KSDS1```. There are intentional errors in the JCL and the IDCAMS commands that you will have to diagnose and correct before the job will run successfully. 

Use SDSF and ISPF Option 3.2 to check the results. 
