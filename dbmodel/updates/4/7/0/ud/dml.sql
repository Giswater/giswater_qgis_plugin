/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

INSERT INTO macroomunit (macroomunit_id) VALUES(0) ON CONFLICT (macroomunit_id) DO NOTHING;
INSERT INTO omunit (omunit_id) VALUES(0) ON CONFLICT (omunit_id) DO NOTHING;

INSERT INTO sys_param_user (id,formname,descript,sys_role,"label",isenabled,layoutorder,project_type,isparent,isautoupdate,"datatype",widgettype,ismandatory,layoutname,iseditable,"source")
VALUES ('edit_insert_show_elevation_from_dem','config','If true, the elevation will be showed from the DEM raster when inserting a new feature','role_edit','Show elevation from DEM:',true,28,'utils',false,false,'boolean','check',false,'lyt_other',true,'core');
INSERT INTO config_param_user ("parameter", value, cur_user) VALUES('edit_insert_show_elevation_from_dem', 'true', 'postgres');

UPDATE sys_param_user SET descript = 'If elev, try to recalculate elev if ymax is not null. If ymax, try to recalculate ymax if elev is not null.'
WHERE id = 'edit_node_topelev_options';
