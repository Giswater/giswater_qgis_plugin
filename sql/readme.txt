/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


This file explains the sql's structure of this folder


-- Folders structure
--------------------------------
api
corporate
dev
example
i18n
tools
ud
updates
utils
ws

subfolder structure of ud/ws/utils folder
	- ddl
	- ddlrule
	- ddlview
	- dml
	- fct
	- ftrg
	- tablect
	- trg
	
--- Instructions to update sql's
--------------------------------
1) FUNCTION AND TRIGGER FUNCTION:  
	It's mandatory to modify the original definition. They must be unique and must be located on (fct) and (ftrg) folders. 
	In case of different code for different versions 'IF' on code will be used
	Use always one file for each function/trigger
	
2) VIEWS:
	It's forbidden to modify the original definition. Keep the original defition but put a comment there like 'definiton updated on 3.x.xxxx'
	Use ddlview.sql file located on ws/ud/utils update folders.
	DROP IS NOT FORBIDDEN but use it only if it's needed.
	DROP CASCADE IS FORBIDDEN. If it's needed, take time and wait for next major release.
	Identify any change on any view on the chapter views of changelog.txt file
	
	
3)  TABLES, RULES, TRIGGERS, CONSTRAINTS:
	It's forbidden to modify the original definition. Keep the original defition but put a comment there like 'definiton updated on 3.x.xxxx'
	Use below files located on ws/ud/utils update folders
		ddl.sql
		dml.sql
		ddlrule.sql
		tablect.sql
		trg.sql	
	DROP IS FORBIDDEN for all. If same function / trigger / table / view or sequence becomes deprecated we must use:
		UPDATE audit_cat_table / audit_cat_function / audit_cat_sequence  SET isdeprectaded=TRUE
	
	
4) DML
	It's forbidden to modify the original definition. Keep the original defition but put a comment there like 'definiton updated on 3.x.xxxx'
	Use below files located on ws/ud/utils update folders
		ddl.sql
		dml.sql
		ddlrule.sql
		tablect.sql
		trg.sql	
5) I18N 
	It's forbidden to modify the original definition. Keep the original defition but put a comment there 'definiton updated on 3.x.xxxx'
	It's specific case of dml
	Use below files located on EN/ES/CA/PT folders
		ud.sql
		ws.sql
		utils.sql
6) API: 
	Same as ud/ws projects but without ws/ud folders
	No ws/ud folders means that no specific ws/ud sql file will be located on API folder
	In case of specific ws/ud API table/view/function use update files of ws/ud to work with
	
7) OTHER PROJECT TYPES
	If you are looking to use Giswater sql project creation and update structure of specific project
	- Define list of other project types on config.file
	- Create folder with same name defined on config.file and use this subfolder structure:
		example
		i18n
		updates
		ddl
		ddlrule
		ddlview
		dml
		fct
		ftrg
		tablect
		trg
	- Same behaviour of WS/UD will be done with the unique difference of the location of folders


-- Changelog file
-----------------------------
	- Use it to register any change on sqls.
	- Issue is mandatory. If not exits, create new one on Github.
	- If we need to drop whitout cascade some view, changelog has two parts in order to identify as best as possible that special AND UNIQUE CASE OF DROPS
	
	
	
-- Workflows
----------------------------	
1) CREATE EMPTY PROJECT
2) CREATE EMPTY PROJECT WITHOUT CONSTRAINTS AND TRIGGERS
3) CREATE PROJECT WITH SAMPLE DATA
4) CREATE PROJECT WITH SAMPLE FOR DEV
5) CREATE PROJECT USING INP FILE
6) PROJECT UPDATE
7) CREATE API
8) API UPDATE
9) LAST PROCESS FUNCTION
	- Grant permissions to all relations using audit_cat_* tables
	- Enable foreing keys with utils schema if exists
	- Drop deprecated table/views/functions/sequences ONLY for new projects