/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2022/03/07
UPDATE config_toolbox SET active=false where id=2970;

INSERT INTO config_param_system ("parameter",value,descript,"label",isenabled,layoutorder,project_type,"datatype",widgettype,ismandatory,layoutname)
VALUES ('om_profile_guitarlegend','{"catalog":"CATALOG", "vs":"VS", "hs":"HS", "referencePlane":"REFERENCE",  "dimensions":"SLOPE / LENGTH", "ordinates": "ORDINATES", "topelev":"TOP ELEV", "ymax":"YMAX", "elev": "ELEV", "code":"CODE", "distance":"DISTANCE"}','It allows the configuration of legend labels when makeing a new profile','Profile guitar legend configuration:',false,13,'ws','json','linetext',true,'lyt_admin_om');

INSERT INTO config_param_system ("parameter",value,descript,"label",isenabled,layoutorder,project_type,"datatype",widgettype,ismandatory,layoutname)
VALUES ('om_profile_guitartext',$${"arc":"SELECT arc_id AS arc_id, concat(v_edit_arc.arccat_id,'-Ø',(c.dnom)::integer) as catalog, concat((((elevation2-coalesce(depth2,0)- elevation1-coalesce(depth1,0))/gis_length)*100)::numeric(12,2) ,' / ',gis_length::numeric(12,2),'m') as dimensions , arc_id as code FROM v_edit_arc JOIN cat_arc c ON id = arccat_id"}$$,'It allows the configuration of the text to show when makeing a new profile. Be careful, advanced SQL level is required to modify the query','Profile guitar text configuration:',false,14,'ws','json','linetext',true,'lyt_admin_om');

INSERT INTO config_param_system ("parameter",value,descript,"label",isenabled,layoutorder,project_type,"datatype",widgettype,ismandatory,layoutname)
VALUES ('om_profile_vdefault','{"arc":{"cat_geom1":"0.40"}, "node":{"cat_geom1":"1"}}','Default values used on profile tool if any of the values were NULL','Profile default values if NULL:',false,15,'ws','json','linetext',true,'lyt_admin_om');

INSERT INTO sys_table (id, descript, sys_role, source)
VALUES ('v_anl_grafanalytics_mapzones', 'Table to work with grafanalytics', 'role_epa', 'giswater') 
ON CONFLICT (id) DO NOTHING;