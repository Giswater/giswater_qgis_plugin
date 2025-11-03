/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

INSERT INTO sys_fprocess (fid,fprocess_name,project_type,"source",isaudit,fprocess_type,active)
VALUES (640,'Dynamic omunit analysis','ud','core',true,'Function process',true);

INSERT INTO sys_param_user (id,formname,descript,sys_role,"label",isenabled,layoutorder,project_type,isparent,isautoupdate,"datatype",widgettype,ismandatory,layoutname,iseditable,"source")
VALUES ('plan_psector_auto_insert_connec','config','Automatic insertion of connected connecs/gullies when inserting an arc','role_plan','Automatic connec/gully insertion:',true,12,'utils',false,false,'boolean','check',false,'lyt_masterplan',true,'core');
