/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2020/01/10
DELETE FROM audit_cat_param_user WHERE id IN ('audit_project_plan_result', 'audit_project_epa_result');


UPDATE audit_cat_param_user SET formname='hidden_value', label='Skip demand pattern' WHERE id= 'inp_options_skipdemandpattern';
		
		

--2020/01/07
UPDATE config_api_form_fields SET reload_field = '{"reload":["cat_matcat_id", "cat_pnom", "cat_dnom"]}', isautoupdate = TRUE
WHERE column_id='arccat_id' and formtype='feature';

UPDATE config_api_form_fields SET reload_field = '{"reload":["cat_matcat_id", "cat_pnom", "cat_dnom"]}', isautoupdate = TRUE
WHERE column_id='nodecat_id' and formtype='feature';

UPDATE config_api_form_fields SET reload_field = '{"reload":["cat_matcat_id", "cat_pnom", "cat_dnom"]}', isautoupdate = TRUE
WHERE column_id='connecat_id' and formtype='feature';


--2020/01/09
SELECT setval('SCHEMA_NAME.config_api_form_fields_id_seq', (SELECT max(id) FROM config_api_form_fields), true);

DELETE FROM config_api_form_fields WHERE formname = 'inp_energy_gl' or formname = 'inp_reactions_gl';

INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, true, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('inp_mixing') AND 
column_name not in (select column_id from config_api_form_fields where formname='inp_mixing');

INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, true, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('inp_emitter') AND 
column_name not in (select column_id from config_api_form_fields where formname='inp_emitter');


INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, true, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('inp_source') AND 
column_name not in (select column_id from config_api_form_fields where formname='inp_source');

INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, true, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('v_edit_inp_demand') AND 
column_name not in (select column_id from config_api_form_fields where formname='v_edit_inp_demand');

INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, true, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('inp_pump_additional') AND 
column_name not in (select column_id from config_api_form_fields where formname='inp_pump_additional');

INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, true, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('inp_controls_x_arc') AND 
column_name not in (select column_id from config_api_form_fields where formname='inp_controls_x_arc');

INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, true, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('inp_rules_x_arc') AND 
column_name not in (select column_id from config_api_form_fields where formname='inp_rules_x_arc');


INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, true, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('inp_rules_x_node') AND 
column_name not in (select column_id from config_api_form_fields where formname='inp_rules_x_node');

INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, true, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('inp_curve_id') AND 
column_name not in (select column_id from config_api_form_fields where formname='inp_curve_id') AND column_name!='the_geom';

INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, true, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('inp_curve') AND 
column_name not in (select column_id from config_api_form_fields where formname='inp_curve');

INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, true, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('inp_pattern') AND 
column_name not in (select column_id from config_api_form_fields where formname='inp_pattern');

INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, true, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('inp_pattern_value') AND 
column_name not in (select column_id from config_api_form_fields where formname='inp_pattern_value');


INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, true, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('inp_energy') AND 
column_name not in (select column_id from config_api_form_fields where formname='inp_energy');

INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, true, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('inp_reactions') AND 
column_name not in (select column_id from config_api_form_fields where formname='inp_reactions');


INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, true, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('inp_quality') AND 
column_name not in (select column_id from config_api_form_fields where formname='inp_quality');

INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, true, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('v_edit_inp_connec') AND 
column_name not in (select column_id from config_api_form_fields where formname='v_edit_inp_connec') AND column_name!='the_geom';

UPDATE config_api_form_fields set widgettype='doubleSpinbox' WHERE (column_id='depth' OR column_id='elevation') AND formname='v_edit_inp_connec';

UPDATE config_api_form_fields set widgettype='combo', dv_querytext='SELECT id, name as idval FROM value_state WHERE id IS NOT NULL' 
WHERE column_id='state' AND formname='v_edit_inp_connec';

UPDATE config_api_form_fields set widgettype='combo', dv_querytext='SELECT sector_id as id,name as idval FROM sector WHERE sector_id IS NOT NULL' 
WHERE column_id='sector_id' AND formname='v_edit_inp_connec';

UPDATE config_api_form_fields set widgettype='combo', dv_isnullvalue= true, dv_querytext='SELECT DISTINCT (pattern_id) AS id,  pattern_id  AS idval FROM inp_pattern WHERE pattern_id IS NOT NULL' 
WHERE column_id='pattern_id' AND formname='v_edit_inp_connec';

UPDATE config_api_form_fields set widgettype='combo', dv_querytext='SELECT id, id as idval FROM cat_connec WHERE id IS NOT NULL' 
WHERE column_id='connecat_id' AND formname='v_edit_inp_connec';

--rpt output
INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, false, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('v_rpt_node_hourly') AND 
column_name not in (select column_id from config_api_form_fields where formname='v_rpt_node_hourly') AND column_name!='the_geom';


INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, false, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('v_rpt_node') AND 
column_name not in (select column_id from config_api_form_fields where formname='v_rpt_node') AND column_name!='the_geom';

INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
WHEN data_type = 'timestamp without time zone' THEN 'date'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, false, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('v_rpt_node_all') AND 
column_name not in (select column_id from config_api_form_fields where formname='v_rpt_node_all') AND column_name!='the_geom';


INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, false, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('v_rpt_arc_hourly') AND 
column_name not in (select column_id from config_api_form_fields where formname='v_rpt_arc_hourly') AND column_name!='the_geom';


INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, false, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('v_rpt_arc') AND 
column_name not in (select column_id from config_api_form_fields where formname='v_rpt_arc') AND column_name!='the_geom';

INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
WHEN data_type = 'timestamp without time zone' THEN 'date'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, false, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('v_rpt_arc_all') AND 
column_name not in (select column_id from config_api_form_fields where formname='v_rpt_arc_all') AND column_name!='the_geom';


INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, false, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('v_rpt_energy_usage') AND 
column_name not in (select column_id from config_api_form_fields where formname='v_rpt_energy_usage') AND column_name!='the_geom';


INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, false, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('v_rpt_hydraulic_status') AND 
column_name not in (select column_id from config_api_form_fields where formname='v_rpt_hydraulic_status') AND column_name!='the_geom';


INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, false, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('v_rpt_comp_node_hourly') AND 
column_name not in (select column_id from config_api_form_fields where formname='v_rpt_comp_node_hourly') AND column_name!='the_geom';


INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, false, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('v_rpt_comp_node') AND 
column_name not in (select column_id from config_api_form_fields where formname='v_rpt_comp_node') AND column_name!='the_geom';

INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, false, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('v_rpt_comp_arc_hourly') AND 
column_name not in (select column_id from config_api_form_fields where formname='v_rpt_comp_arc_hourly') AND column_name!='the_geom';


INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, false, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('v_rpt_comp_arc') AND 
column_name not in (select column_id from config_api_form_fields where formname='v_rpt_comp_arc') AND column_name!='the_geom';


INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, false, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('v_rpt_comp_energy_usage') AND 
column_name not in (select column_id from config_api_form_fields where formname='v_rpt_comp_energy_usage') AND column_name!='the_geom';


INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, false, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('v_rpt_comp_hydraulic_status') AND 
column_name not in (select column_id from config_api_form_fields where formname='v_rpt_comp_hydraulic_status') AND column_name!='the_geom';


--map zones
INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, true, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('v_edit_dqa') AND 
column_name not in (select column_id from config_api_form_fields where formname='v_edit_dqa') AND column_name !='the_geom';

UPDATE config_api_form_fields set widgettype='combo', dv_isnullvalue=true,
dv_querytext='SELECT DISTINCT (pattern_id) AS id,  pattern_id  AS idval FROM inp_pattern WHERE pattern_id IS NOT NULL'
WHERE column_id='pattern_id' AND formname IN ('v_edit_dqa');

UPDATE config_api_form_fields set widgettype='combo', dv_isnullvalue=true,
dv_querytext='SELECT DISTINCT id,  idval FROM edit_typevalue WHERE id IS NOT NULL AND typevalue=''dqa_type'''
WHERE column_id='dqa_type' AND formname IN ('v_edit_dqa');

INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, true, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('v_edit_presszone') AND 
column_name not in (select column_id from config_api_form_fields where formname='v_edit_presszone') AND column_name !='the_geom';


INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, true, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('v_edit_macrodqa') AND 
column_name not in (select column_id from SCHEMA_NAME.config_api_form_fields where formname='v_edit_macrodqa') AND column_name !='the_geom';


--om

INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' or data_type = 'double precision' THEN 'double' 
WHEN data_type = 'smallint' or data_type = 'bigint' THEN 'integer'
WHEN data_type='timestamp without time zone' THEN 'date'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, false, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('v_anl_mincut_result_cat') AND 
column_name not in (select column_id from config_api_form_fields where formname='v_anl_mincut_result_cat') AND column_name !='anl_the_geom' AND column_name !='exec_the_geom';


INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' or data_type = 'bigint' THEN 'integer'
WHEN data_type='timestamp without time zone' THEN 'date'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, false, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('v_anl_mincut_result_valve') AND 
column_name not in (select column_id from config_api_form_fields where formname='v_anl_mincut_result_valve') AND column_name !='the_geom';

INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' or data_type = 'bigint' THEN 'integer'
WHEN data_type='timestamp without time zone' THEN 'date'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, false, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('v_anl_mincut_result_connec') AND 
column_name not in (select column_id from config_api_form_fields where formname='v_anl_mincut_result_connec') AND column_name !='the_geom';


INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' or data_type = 'bigint' THEN 'integer'
WHEN data_type='timestamp without time zone' THEN 'date'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, false, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('v_anl_mincut_result_node') AND 
column_name not in (select column_id from config_api_form_fields where formname='v_anl_mincut_result_node') AND column_name !='the_geom';


INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' or data_type = 'bigint' THEN 'integer'
WHEN data_type='timestamp without time zone' THEN 'date'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, false, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('v_anl_mincut_result_arc') AND 
column_name not in (select column_id from config_api_form_fields where formname='v_anl_mincut_result_arc') AND column_name !='the_geom';

--catalogs

INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' or data_type = 'bigint' THEN 'integer'
WHEN data_type='timestamp without time zone' THEN 'date'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, true, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('cat_mat_arc') AND 
column_name not in (select column_id from config_api_form_fields where formname='cat_mat_arc') AND column_name !='the_geom';

INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' or data_type = 'bigint' THEN 'integer'
WHEN data_type='timestamp without time zone' THEN 'date'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, true, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('cat_node') AND 
column_name not in (select column_id from config_api_form_fields where formname='cat_node') AND column_name !='the_geom';

INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' or data_type = 'bigint' THEN 'integer'
WHEN data_type='timestamp without time zone' THEN 'date'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, true, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('inp_cat_mat_roughness') AND 
column_name not in (select column_id from config_api_form_fields where formname='inp_cat_mat_roughness') AND column_name !='the_geom';

INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' or data_type = 'bigint' THEN 'integer'
WHEN data_type='timestamp without time zone' THEN 'date'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, true, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('cat_connec') AND 
column_name not in (select column_id from config_api_form_fields where formname='cat_connec') AND column_name !='the_geom';

INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' or data_type = 'bigint' THEN 'integer'
WHEN data_type='timestamp without time zone' THEN 'date'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, true, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('cat_presszone') AND 
column_name not in (select column_id from config_api_form_fields where formname='cat_presszone') AND column_name !='the_geom';

