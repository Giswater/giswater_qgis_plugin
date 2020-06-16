/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2020/06/05
DROP TABLE cat_arc_class;
DROP TABLE cat_arc_class_cat;
DROP TABLE cat_arc_class_type;

-- 2020/06/02
ALTER TABLE om_rec_result_arc DROP CONSTRAINT om_rec_result_arc_pkey;
ALTER TABLE om_rec_result_arc ADD CONSTRAINT plan_rec_result_arc_pkey PRIMARY KEY (arc_id, result_id);
ALTER TABLE om_rec_result_arc DROP COLUMN id;
ALTER TABLE om_rec_result_arc RENAME TO plan_rec_result_arc;
UPDATE sys_table SET id = 'plan_rec_result_arc', sys_sequence = null, sys_sequence_field = null WHERE id = 'om_rec_result_arc';

ALTER TABLE om_rec_result_node DROP CONSTRAINT om_rec_result_node_pkey;
ALTER TABLE om_rec_result_node ADD CONSTRAINT plan_rec_result_node_pkey PRIMARY KEY (node_id, result_id);
ALTER TABLE om_rec_result_node DROP COLUMN id;
ALTER TABLE om_rec_result_node RENAME TO plan_rec_result_node;
UPDATE sys_table SET id = 'plan_rec_result_node', sys_sequence = null, sys_sequence_field = null WHERE id = 'om_rec_result_node';

ALTER TABLE om_reh_result_arc DROP CONSTRAINT om_reh_result_arc_pkey;
ALTER TABLE om_reh_result_arc ADD CONSTRAINT plan_reh_result_arc_pkey PRIMARY KEY (arc_id, result_id);
ALTER TABLE om_reh_result_arc DROP COLUMN id;
ALTER TABLE om_reh_result_arc RENAME TO plan_reh_result_arc;
UPDATE sys_table SET id = 'plan_reh_result_arc', sys_sequence = null, sys_sequence_field = null WHERE id = 'om_reh_result_arc';

ALTER TABLE om_reh_result_node DROP CONSTRAINT om_reh_result_node_pkey;
ALTER TABLE om_reh_result_node ADD CONSTRAINT plan_reh_result_node_pkey PRIMARY KEY (node_id, result_id);
ALTER TABLE om_reh_result_node DROP COLUMN id;
ALTER TABLE om_reh_result_node RENAME TO plan_reh_result_node;
UPDATE sys_table SET id = 'plan_reh_result_node', sys_sequence = null, sys_sequence_field = null WHERE id = 'om_reh_result_node';

UPDATE config_toolbox set active = true;

update config_toolbox SET inputparams = replace(inputparams::text, 'layout_order', 'layoutorder')::json;
update config_toolbox SET inputparams = replace(inputparams::text, 'datepickertime', 'datetime')::json;
update config_toolbox SET inputparams = replace(inputparams::text, 'is_mandatory', 'ismandatory')::json;


ALTER TABLE om_result_cat RENAME TO plan_result_cat;
ALTER TABLE plan_result_cat ADD CONSTRAINT plan_result_cat_unique UNIQUE (name);

UPDATE sys_table SET id = 'plan_result_cat', sys_sequence = null, sys_sequence_field = null WHERE id = 'om_result_cat';

ALTER TABLE plan_result_cat RENAME network_price_coeff  TO coefficient;

-- drop id result inp table
DROP VIEW IF EXISTS v_ui_rpt_cat_result;
ALTER TABLE rpt_cat_result DROP COLUMN id;

INSERT INTO config_toolbox VALUES (2890,'Calculate cost of reconstruction',TRUE,'{"featureType":[]}',
'[{"widgetname":"resultName", "label":"Result name:", "widgettype":"text","datatype":"string","layoutname":"grl_option_parameters","layoutorder":1, "placeholder":"result name" ,"value":""},
{"widgetname":"step", "label":"Step:", "widgettype":"combo", "datatype":"text", "layoutname":"grl_option_parameters","layoutorder":2,"comboIds":["1","2"],
"comboNames":["STEP-1: Create result prices", "STEP-2: Update result using acoeff & initcost)"], "selectedId":"1"}, 
{"widgetname":"coefficient", "label":"Coefficient:", "widgettype":"text","datatype":"float","layoutname":"grl_option_parameters","layoutorder":3, "placeholder":"1", "value":""},
{"widgetname":"descript", "label":"Description:", "widgettype":"text","datatype":"string","layoutname":"grl_option_parameters","layoutorder":4, "placeholder":"description" ,"ismandatory":false, "value":""}]');
   
 
ALTER TABLE anl_polygon RENAME fprocesscat_id TO fid;

-- rename tables
ALTER TABLE inp_curve RENAME TO inp_curve_value;
ALTER TABLE inp_curve_id RENAME TO inp_curve;

-- drop context
ALTER TABLE config_param_system DROP COLUMN context;
ALTER TABLE sys_table DROP COLUMN context;

-- drop sys_rows
ALTER TABLE sys_table DROP COLUMN sys_rows;

-- rename sys_role_id to sys_role
ALTER TABLE sys_function RENAME sys_role_id TO sys_role;
ALTER TABLE sys_param_user RENAME sys_role_id TO sys_role;
ALTER TABLE sys_table RENAME sys_role_id TO sys_role;

ALTER TABLE selector_audit RENAME fprocesscat_id TO fid;

ALTER TABLE sys_table DROP column isdeprecated;
ALTER TABLE sys_message DROP column isdeprecated;
ALTER TABLE sys_function DROP column isdeprecated;
ALTER TABLE config_param_system DROP column isdeprecated;

ALTER TABLE config_csv DROP column sys_role;
