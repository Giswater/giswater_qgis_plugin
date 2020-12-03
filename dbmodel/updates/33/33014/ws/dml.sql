/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--11/11/2019
DELETE FROM audit_cat_param_user WHERE id IN ('expansiontankcat_vdefault', 'filtercat_vdefault', 'flexunioncat_vdefault', 'fountaincat_vdefault', 'greentapcat_vdefault', 
							'hydrant_vdefault', 'junctioncat_vdefault', 'manholecat_vdefault', 'metercat_vdefault', 'netelementcat_vdefault', 'netsamplepointcat_vdefault', 
							'netwjoincat_vdefault', 'pipecat_vdefault', 'pumpcat_vdefault', 'reductioncat_vdefault', 'registercat_vdefault', 'sourcecat_vdefault', 
							'tankcat_vdefault', 'tapcat_vdefault', 'valvecat_vdefault', 'waterwellcat_vdefault', 'wjoincat_vdefault', 'wtpcat_vdefault');

--14/11/2019
UPDATE audit_cat_param_user SET isparent=True, editability='{"trueWhenParentIn":[11]}' WHERE id ='inp_options_pattern';
							
							
--16/11/2019
ALTER TABLE inp_typevalue DISABLE TRIGGER gw_trg_typevalue_config_fk;
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_typevalue_pumptype', 1, 'PRESSURE GROUP', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_typevalue_pumptype', 2, 'PUMP STATION', NULL);

-- adding constraint againts field and domain value table
INSERT INTO typevalue_fk (typevalue_table, typevalue_name, target_table, target_field, parameter_id) VALUES ('inp_typevalue', 'inp_typevalue_pumptype', 'inp_pump', 'pump_type', NULL);


-- new variable for epanet_buildup_mode
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_options_buildup_mode', 1, 'FAST BUILDUP', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_options_buildup_mode', 2, 'STANDARD BUILDUP', NULL);

INSERT INTO audit_cat_param_user(id, formname, description, sys_role_id, label, isenabled, layout_id, layout_order, dv_querytext, 
project_type, isparent, isautoupdate, datatype, widgettype, ismandatory, isdeprecated, layoutname, vdefault, epaversion)
VALUES ('inp_options_buildup_mode','epaoptions','Mode to built up epanet assuming certain simplifications in order to make the first model as fast as possible (default management of null elevations, onfly transformations from tanks to reservoirs and status of valves and pumps)',
'role_epa', 'Buildup mode:', true, 1, 10, 'SELECT id, idval FROM inp_typevalue WHERE typevalue  = ''inp_options_buildup_mode''', 'ws', false, false, 'text', 'combo', true, false, 'grl_general_1', 2, '{"from":"2.0.12", "to":null, "language":"english"}')
ON CONFLICT (id) DO NOTHING;


--20/11/2019
SELECT setval('SCHEMA_NAME.config_api_form_fields_id_seq', (SELECT max(id) FROM config_api_form_fields), true);

INSERT INTO config_api_form_fields (formname, formtype, column_id, isenabled, ismandatory, datatype, widgettype, dv_querytext, label, iseditable, hidden)
VALUES ('v_inp_edit_pump', 'form','pump_type', true, false, 'string','combo', 'SELECT id, idval FROM inp_typevalue WHERE typevalue  = ''inp_typevalue_pumptype''','pump_type', true, false);
