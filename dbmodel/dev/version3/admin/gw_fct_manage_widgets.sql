/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 

--DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_admin_drop_all();


CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_admin_drop_all() RETURNS void AS
$BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_admin_drop_all();
*/


DECLARE 
	
BEGIN 


	-- search path
	SET search_path = "ws", public;

	/*
	
	-- force disable all widgets of dialog go2epa
	UPDATE sys_param_user SET iseditable = false WHERE formname = 'epaoptions';
	
	-- force state = 1
	UPDATE sys_param_user SET vdefault = '1' WHERE id = 'edit_state_vdefault';
	UPDATE config_param_user SET value = '1' WHERE parameter = 'edit_state_vdefault';
	UPDATE config_form_fields SET iseditable = false WHERE columnname = 'state' and formtype = 'form_feature' and tabname  ='data';
	
	-- force state_type = 2
	UPDATE sys_param_user SET vdefault = '2' WHERE id = 'edit_statetype_1_vdefault';
	UPDATE config_param_user SET value = '2' WHERE parameter = 'edit_statetype_1_vdefault';
	UPDATE config_form_fields SET iseditable = false WHERE columnname = 'state_type' and formtype = 'form_feature' and tabname  ='data';

	-- force hidden mapzones
	UPDATE config_form_fields SET hidden = true WHERE columnname = 'dma_id' and formtype = 'form_feature' and tabname  ='data';
	UPDATE config_form_fields SET hidden = true WHERE columnname = 'dqa_id' and formtype = 'form_feature' and tabname  ='data';
	UPDATE config_form_fields SET hidden = true WHERE columnname = 'minsector_id' and formtype = 'form_feature' and tabname  ='data';
	UPDATE config_form_fields SET hidden = true WHERE columnname = 'macrodma_id' and formtype = 'form_feature' and tabname  ='data';
	UPDATE config_form_fields SET hidden = true WHERE columnname = 'macrosector_id' and formtype = 'form_feature' and tabname  ='data';
	UPDATE config_form_fields SET hidden = true WHERE columnname = 'macroexpl_id' and formtype = 'form_feature' and tabname  ='data';
	UPDATE config_form_fields SET hidden = true WHERE columnname = 'macrodqa_id' and formtype = 'form_feature' and tabname  ='data';
	
	-- force disabled mapzones
	UPDATE config_form_fields SET iseditable = false WHERE columnname = 'sector_id' and formtype = 'form_feature' and tabname  ='data';
	UPDATE config_form_fields SET iseditable = false WHERE columnname = 'presszone_id' and formtype = 'form_feature' and tabname  ='data';
	UPDATE config_form_fields SET iseditable = false WHERE columnname = 'expl_id' and formtype = 'form_feature' and tabname  ='data';
	
	-- amagar camps poc usats en les features
	UPDATE config_form_fields SET hidden = true WHERE columnname = 'depth' and formtype = 'form_feature' and tabname  ='data';
	UPDATE config_form_fields SET hidden = true WHERE columnname = 'depth1' and formtype = 'form_feature' and tabname  ='data';
	UPDATE config_form_fields SET hidden = true WHERE columnname = 'depth2' and formtype = 'form_feature' and tabname  ='data';
	UPDATE config_form_fields SET hidden = true WHERE columnname = 'cat_pnom' and formtype = 'form_feature' and tabname  ='data';
	UPDATE config_form_fields SET hidden = true WHERE columnname = 'parent_id' and formtype = 'form_feature' and tabname  ='data';
	UPDATE config_form_fields SET hidden = true WHERE columnname = 'buildercat_id' and formtype = 'form_feature' and tabname  ='data';
	UPDATE config_form_fields SET hidden = true WHERE columnname = 'ownercat_id' and formtype = 'form_feature' and tabname  ='data';
	
	UPDATE config_form_fields SET hidden = true WHERE columnname = 'label_x' and formtype = 'form_feature' and tabname  ='data';
	UPDATE config_form_fields SET hidden = true WHERE columnname = 'label_y' and formtype = 'form_feature' and tabname  ='data';
	UPDATE config_form_fields SET hidden = true WHERE columnname = 'label_rotation' and formtype = 'form_feature' and tabname  ='data';
	UPDATE config_form_fields SET hidden = true WHERE columnname = 'label' and formtype = 'form_feature' and tabname  ='data';
	UPDATE config_form_fields SET hidden = true WHERE columnname = 'num_value' and formtype = 'form_feature' and tabname  ='data';

	UPDATE config_form_fields SET hidden = true WHERE columnname = 'brand' and formtype = 'form_feature' and tabname  ='data';
	UPDATE config_form_fields SET hidden = true WHERE columnname = 'brand2' and formtype = 'form_feature' and tabname  ='data';
	UPDATE config_form_fields SET hidden = true WHERE columnname = 'svg' and formtype = 'form_feature' and tabname  ='data';
	UPDATE config_form_fields SET hidden = true WHERE columnname = 'hemisphere' and formtype = 'form_feature' and tabname  ='data';
	UPDATE config_form_fields SET hidden = true WHERE columnname = 'asset_id' and formtype = 'form_feature' and tabname  ='data';
	UPDATE config_form_fields SET hidden = true WHERE columnname = 'workcat_id_plan' and formtype = 'form_feature' and tabname  ='data';
	UPDATE config_form_fields SET hidden = true WHERE columnname = 'undelete' and formtype = 'form_feature' and tabname  ='data';
	UPDATE config_form_fields SET hidden = true WHERE columnname = 'inventory' and formtype = 'form_feature' and tabname  ='data';
	UPDATE config_form_fields SET hidden = true WHERE columnname = 'link' and formtype = 'form_feature' and tabname  ='data';

	UPDATE config_form_fields SET hidden = true WHERE columnname = 'location_type' and formtype = 'form_feature' and tabname  ='data';
	UPDATE config_form_fields SET hidden = true WHERE columnname = 'staticpressure' and formtype = 'form_feature' and tabname  ='data';
	UPDATE config_form_fields SET hidden = true WHERE columnname = 'staticpress1' and formtype = 'form_feature' and tabname  ='data';
	UPDATE config_form_fields SET hidden = true WHERE columnname = 'staticpress2' and formtype = 'form_feature' and tabname  ='data';

	UPDATE config_form_fields SET hidden = true WHERE columnname = 'workcat_id_end' and formtype = 'form_feature' and tabname  ='data';

	-- conflictes order
	UPDATE config_form_fields SET layoutname = 'lyt_data_1', layoutorder=20 WHERE columnname = 'rotation' and formtype = 'form_feature' and tabname  ='data';
	UPDATE config_form_fields SET layoutname = 'lyt_data_2' WHERE columnname = 'broken' and formtype = 'form_feature' and tabname  ='data';

	-- especifics de valvula
	UPDATE config_form_fields SET hidden = true WHERE columnname = 'cat_valve2' and formtype = 'form_feature' and tabname  ='data';
	UPDATE config_form_fields SET hidden = true WHERE columnname = 'buried' and formtype = 'form_feature' and tabname  ='data';
	UPDATE config_form_fields SET hidden = true WHERE columnname = 'depth_valveshaft' and formtype = 'form_feature' and tabname  ='data';
	UPDATE config_form_fields SET hidden = true WHERE columnname = 'drive_type' and formtype = 'form_feature' and tabname  ='data';
	UPDATE config_form_fields SET hidden = true WHERE columnname = 'exit_code' and formtype = 'form_feature' and tabname  ='data';
	UPDATE config_form_fields SET hidden = true WHERE columnname = 'exit_type' and formtype = 'form_feature' and tabname  ='data';
	UPDATE config_form_fields SET hidden = true WHERE columnname = 'irrigation_indicator' and formtype = 'form_feature' and tabname  ='data';
	UPDATE config_form_fields SET hidden = true WHERE columnname = 'lin_meters' and formtype = 'form_feature' and tabname  ='data';
	UPDATE config_form_fields SET hidden = true WHERE columnname = 'model' and formtype = 'form_feature' and tabname  ='data';
	UPDATE config_form_fields SET hidden = true WHERE columnname = 'model2' and formtype = 'form_feature' and tabname  ='data';
	UPDATE config_form_fields SET hidden = true WHERE columnname = 'ordinarystatus' and formtype = 'form_feature' and tabname  ='data';

	UPDATE config_form_fields SET hidden = true WHERE columnname = 'pression_entry' and formtype = 'form_feature' and tabname  ='data' and formname NOT IN ('ve_node_vrp', 've_node_vsp', 've_node_vsp')
	UPDATE config_form_fields SET hidden = true WHERE columnname = 'pression_exit' and formtype = 'form_feature' and tabname  ='data' and formname NOT IN ('ve_node_vrp', 've_node_vsp', 've_node_vsp')

	UPDATE config_form_fields SET hidden = true WHERE columnname = 'regulator_location' and formtype = 'form_feature' and tabname  ='data';
	UPDATE config_form_fields SET hidden = true WHERE columnname = 'regulator_observ' and formtype = 'form_feature' and tabname  ='data';
	UPDATE config_form_fields SET hidden = true WHERE columnname = 'regulator_situation' and formtype = 'form_feature' and tabname  ='data';
	UPDATE config_form_fields SET hidden = true WHERE columnname = 'shutter' and formtype = 'form_feature' and tabname  ='data';

	-- placeholders
	UPDATE config_form_fields SET placeholder = null WHERE formtype = 'form_feature' and tabname  ='data';

	*/

RETURN ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;