/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 9/2/2024;
ALTER TABLE inp_typevalue DISABLE TRIGGER gw_trg_typevalue_config_fk;
UPDATE inp_typevalue SET typevalue = '_inp_options_networkmode' WHERE typevalue = 'inp_options_networkmode' and id = '1';
UPDATE inp_typevalue SET idval = 'BASIC NETWORK' WHERE typevalue = 'inp_options_networkmode' and id = '2';
UPDATE inp_typevalue SET idval = 'NETWORK & CONNECS' WHERE typevalue = 'inp_options_networkmode' and id = '4';
ALTER TABLE inp_typevalue ENABLE TRIGGER gw_trg_typevalue_config_fk;

-- 24/2/2024;
DELETE FROM config_form_fields WHERE formname = 've_epa_virtualpump' and columnname = 'price_pattern';

-- 26/02/2024
UPDATE config_form_fields
	SET widgetcontrols='{"saveValue": false, "tableUpsert": "v_edit_inp_dscenario_virtualpump"}'::json, linkedobject='tbl_inp_dscenario_virtualpump', columnname='tbl_inp_virtualpump'
	WHERE formname='ve_epa_virtualpump' AND columnname='tbl_inp_pump';

-- 28/02/2024

DELETE FROM config_form_fields
	WHERE formname='inp_dscenario_connec' AND formtype='form_feature' AND columnname='pjoint_type' AND tabname='tab_none';
DELETE FROM config_form_fields
	WHERE formname='inp_dscenario_connec' AND formtype='form_feature' AND columnname='pjoint_id' AND tabname='tab_none';

UPDATE sys_table
	SET addparam='{"pkey": "dscenario_id, feature_id"}'::json
	WHERE id='inp_dscenario_demand';