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

UPDATE sys_feature_class SET epa_default = 'UNDEFINED' WHERE id = 'CJOIN' or id = 'VGULLY';
UPDATE sys_feature_class SET epa_default = 'GULLY' WHERE id = 'GINLET';

UPDATE om_typevalue SET idval = 'NOT TREATED' WHERE id = '3' AND typevalue = 'treatment_type';
UPDATE om_typevalue SET idval = 'PRETREATED' WHERE id = '2' AND typevalue = 'treatment_type';

INSERT INTO sys_foreignkey (typevalue_table, typevalue_name, target_table, target_field, parameter_id, active)
VALUES('om_typevalue', 'treatment_type', 'link', 'treatment_type', NULL, true);

UPDATE config_function SET style=
'{
  "style": {
    "point": {
      "style": "categorized",
      "field": "feature_type",
      "transparency": 0.5,
      "width": 2,
      "values": [
        {
          "id": "NODE",
          "color": [255, 0, 0],
		  "legend_id": "NODE (profile)"
        },
        {
          "id": "GULLY",
          "color": [216, 197, 52],
		  "legend_id": "GULLY (profile)"
        },
        {
          "id": "CONNEC",
          "color": [166, 206, 227],
		  "legend_id": "CONNEC (profile)"
        }
      ]
    },
    "line": {
      "style": "categorized",
      "field": "feature_type",
      "transparency": 0.5,
      "width": 2,
      "values": [
        {
          "id": "ARC",
          "color": [176, 250, 248],
		  "legend_id": "ARC (profile)"
        },
        {
          "id": "LINK",
          "color": [255, 116, 130],
		  "legend_id": "LINK (profile)"
        }
      ]
    },
    "polygon": {}
  }
}'::json
WHERE id=2832;

UPDATE config_param_system SET value='{"sys_table_id":"ve_gully","sys_id_field":"gully_id","sys_search_field":"gully_id","alias":"Gullies","cat_field":"gullycat_id","orderby":"3","search_type":"gully"}', project_type='ud' WHERE "parameter"='basic_search_network_gully';

-- 19/01/2026
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type) VALUES(4470, 'Fluid type autoupdate is enabled. Disable it to update the fluid type with this function.', NULL, 2, true, 'ud', 'core', 'UI');
