*
* skedf.ctl - sked/drudg program control file
*
* Last modified by NRV 991108 for drudg in FS9.5
*
* This file is free-field except for section names
* which must begin with $ in column 1 and have no
* blanks.  Either upper or lower case is OK for section names.
* Remember path and file names in UNIX are case sensitive.  
*
$catalogs 
*
* Catalog file names: used only by sked.
*
*
$schedules 
*
* Schedule file path:
* Enter here the absolute path for reading/writing schedules. 
* This path is prepended to schedule files by SKED and DRUDG.
* Default is null, i.e. use your local directory.
*
*
$drudg
*
* DRUDG file path:
* Enter here the absolute path for writing DRUDG output files,
* e.g. SNAP files. This path is prepended to files written by DRUDG. 
* Default is null, i.e. use your local directory.
*
*
$scratch 
*
* Scratch directory:
* Enter the absolute path for scratch files. 
* This path is prepended to scratch files by SKED and DRUDG.
* Default is null, i.e. use your local directory.
* All scratch files except the SKED command log are
* deleted upon exiting the programs.
*
/tmp/
*
$print
*
* Printer commands: enter printer type for drudg.
* Recognized names: laser, epson, epson24, file. 
*
printer      laser
*
* Printer scripts: enter name of script to be executed 
* for different types of output. Recognized key words
* are: portrait, landscape, labels. If no label script
* is specified, drudg defaults to using "lpr". If no
* portrait or landscape scripts are specified, drudg
* defaults to embedding escape sequences for the
* appropriate output and uses "recode latin1:ibmpc"
* piped to lpr to print the output file. 
* Formats: 
* portrait <script name for portrait output>
* landscape <script name for landscape output>
* labels <script name for bar code label output>
*
$misc
*
* Epoch of SOURCE commands may be specified here.
* Format:
* epoch <epoch>
* Example:
* epoch 2000
*
* Station equipment may be specified here. 
* Valid types are listed by drudg when Option 11 is used.
* If the schedule file does not have equipment specified, then the 
* types listed here will be used.
* If the schedule file does have equipment specified, then the
* types in the schedule file will be used and a warning message 
* will be printed.
* Format:
* equipment <rack> <recorder A> <recorder B>
* Example:
equipment Mark4  Mark4  none