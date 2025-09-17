/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

UPDATE sys_table SET alias = 'Inp Raingage' WHERE id = 've_raingage';

INSERT INTO dwfzone (dwfzone_id, code, "name", dwfzone_type, expl_id, sector_id, muni_id, descript, link, graphconfig, stylesheet, lock_level, active, the_geom, created_at, created_by, updated_at, updated_by, drainzone_id, addparam) VALUES(-1, '-1', 'Conflict', NULL, '{0}', NULL, NULL, 'Dwfzone used on graphanalytics algorithm when two ore more zones has conflict in terms of some interconnection.', NULL, '{"use":[{"nodeParent":""}], "ignore":[], "forceClosed":[]}'::json, NULL, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO sector (sector_id, code, "name", descript, sector_type, expl_id, muni_id, macrosector_id, parent_id, graphconfig, stylesheet, link, lock_level, active, the_geom, created_at, created_by, updated_at, updated_by, addparam) VALUES(-1, '-1', 'Conflict', 'Sector used on graphanalytics algorithm when two ore more zones has conflict in terms of some interconnection.', NULL, '{0}', NULL, 0, NULL, '{"use":[{"nodeParent":""}], "ignore":[], "forceClosed":[]}'::json, NULL, NULL, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO omzone (omzone_id, code, "name", descript, omzone_type, expl_id, macroomzone_id, minc, maxc, effc, link, graphconfig, stylesheet, lock_level, active, the_geom, created_at, created_by, updated_at, updated_by, sector_id, muni_id, addparam) VALUES(-1, '-1', 'Conflict', 'Omzone used on graphanalytics algorithm when two ore more zones has conflict in terms of some interconnection.', NULL, '{0}', 0, NULL, NULL, NULL, NULL, '{"use":[{"nodeParent":""}], "ignore":[], "forceClosed":[]}'::json, NULL, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
UPDATE dma SET descript='Undefined',"name"='Undefined',code='0' WHERE dma_id=0;
INSERT INTO dma (dma_id, code, "name", descript, dma_type, muni_id, expl_id, sector_id, avg_press, pattern_id, effc, graphconfig, stylesheet, lock_level, link, addparam, active, the_geom, created_at, created_by, updated_at, updated_by) VALUES(-1, '-1', 'Conflict', 'Dma used on graphanalytics algorithm when two ore more zones has conflict in terms of some interconnection.', NULL, NULL, '{0}', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, true, NULL, NULL, NULL, NULL, NULL);

UPDATE sys_table SET alias='Lids Dscenario',addparam='{"pkey":"dscenario_id, subc_id"}'::json WHERE id='ve_inp_dscenario_lids';

-- 15/09/2025
DELETE FROM sys_param_user WHERE id='edit_gully_linkcat_vdefault';

-- Internal diameter
UPDATE config_form_fields
	SET "label"='Internal diameter:',tooltip='Internal diameter'
	WHERE formname='cat_link' AND formtype='form_feature' AND columnname='dint' AND tabname='tab_none';


-- 16/09/2025
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_chamber' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_change' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_circ_manhole' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_highpoint' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_jump' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_junction' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_netgully' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_netinit' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_outfall' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_overflow_storage' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_pump_station' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_rect_manhole' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_register' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_sandbox' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_sewer_storage' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_valve' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_virtual_node' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_weir' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_wwtp' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_out_manhole' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_connec' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_connec_cjoin' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_connec_connec' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_connec_vconnec' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';

-- 16/09/2025
INSERT INTO sys_table (id, descript, sys_role, project_template, context, orderby, alias, notify_action, isaudit, keepauditdays, "source", addparam) 
VALUES('man_ginlet', NULL, 'role_edit', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL) ON CONFLICT DO NOTHING;

UPDATE om_typevalue SET idval = 'STORMWATER' WHERE typevalue = 'fluid_type' AND id = '1';
UPDATE om_typevalue SET idval = 'COMBINED DILUTED' WHERE typevalue = 'fluid_type' AND id = '2';
UPDATE om_typevalue SET idval = 'SEWAGE' WHERE typevalue = 'fluid_type' AND id = '3';
UPDATE om_typevalue SET idval = 'COMBINED' WHERE typevalue = 'fluid_type' AND id = '4';

-- 17/09/2025
UPDATE config_form_fields SET columnname = 'dwfzone_id', label = 'Dwfzone', tooltip = 'dwfzone_id', 
	dv_querytext = 'SELECT dwfzone_id as id, name as idval FROM dwfzone WHERE dwfzone_id = 0 UNION SELECT dwfzone_id as id, name as idval FROM dwfzone WHERE dwfzone_id IS NOT NULL AND active IS TRUE',
	dv_querytext_filterc = ' AND dwfzone.expl_id'
WHERE formtype = 'form_feature' AND tabname = 'tab_data' AND columnname = 'omzone_id' AND layoutname = 'lyt_bot_1';