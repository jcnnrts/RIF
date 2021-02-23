# RIF

Before running any job, complete the jobcard.
Before running any job, do a 'c all <RIFHLQ>' to your chosen high level qualifier.
Before running any job, do a 'c all <DB2HLQ>' to your Db2 installation's HLQ.
Before running any job, check for parameters that have to be altered. They will always be masked with ????.

Allocate a <RIFHLQ>.RIFDBRM PDS to house the DBRMs.
Allocate a <RIFHLQ>.RIFLOAD PDS to house the load modules.

Allocate the following FB LRECL 80 libraries, proceed by transferring the relevant files to members in these libraries.
- RIFHLQ.RIFSRC
- RIFHLQ.RIFASM
- RIFHLQ.RIFJCL

Next:
1. Run the DDL in 'ddl/RIF database schemas.sql' on the subsystem you want to monitor.
2. Run the four compile jobs for the assembler programs in order.
3. Run the compile job for RIFSTIM.
4. Run the compile job for RIFMAIN.
5. Run the package bind job.
6. Run the plan bind job.


You can now start RIF as an STC by placing 'jcl/STC start procedure.jcl' somewhere in your JES PROCLIB concatenation, and issueing a "start <procname>" console command.
You can stop RIF by issueing the "stop <stcname>" command.