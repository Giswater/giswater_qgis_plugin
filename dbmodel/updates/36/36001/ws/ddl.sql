/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2022/01/03


-- JUNCTION REFACTOR
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_junction", "column":"emitter_coeff", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_junction", "column":"init_quality", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_junction", "column":"source_type", "dataType":"character varying(18)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_junction", "column":"source_quality", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_junction", "column":"source_pattern_id", "dataType":"character varying(1)", "isUtils":"False"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_junction", "column":"emitter_coeff", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_junction", "column":"init_quality", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_junction", "column":"source_type", "dataType":"character varying(18)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_junction", "column":"source_quality", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_junction", "column":"source_pattern_id", "dataType":"character varying(16)", "isUtils":"False"}}$$);

UPDATE inp_junction j SET emitter_coeff = coef FROM inp_emitter s WHERE s.node_id = j.node_id;
UPDATE inp_junction j SET init_quality = initqual FROM inp_quality s WHERE s.node_id = j.node_id;
UPDATE inp_junction j SET source_type = sourc_type FROM inp_source s WHERE s.node_id = j.node_id;
UPDATE inp_junction j SET source_quality = quality FROM inp_source s WHERE s.node_id = j.node_id;
UPDATE inp_junction j SET source_pattern_id = s.pattern_id FROM inp_source s WHERE s.node_id = j.node_id;

UPDATE config_form_fields SET columnname = 'emitter_coeff' WHERE columnname='coef' and formname = 'inp_emitter';
UPDATE config_form_fields SET columnname = 'init_quality' WHERE columnname='initqual' and formname = 'inp_quality';
UPDATE config_form_fields SET columnname = 'source_type' WHERE columnname='sourc_type' and formname = 'inp_source';
UPDATE config_form_fields SET columnname = 'source_quality' WHERE columnname='quality' and formname = 'inp_source';
UPDATE config_form_fields SET columnname = 'source_pattern_id_id'WHERE columnname='pattern_id' and formname = 'inp_source';

UPDATE config_form_fields SET formname = 'v_edit_inp_junction' 
WHERE formname IN ('inp_quality','inp_source','inp_emitter') AND columnname!='node_id';

DELETE FROM config_form_fields WHERE formname in ('inp_quality', 'inp_source','inp_emitter');

INSERT INTO config_form_fields 
SELECT 'v_edit_inp_dscenario_junction', formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden 
FROM config_form_fields WHERE formname ='v_edit_inp_junction' AND columnname in ('node_id','demand','pattern_id','demand_type', 'emitter_coeff',
'init_quality', 'source_type', 'source_quality', 'source_pattern_id') ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

--PUMP REFACTOR
--nodarc_id es una concatenacion dentro de la vista o un campo mas? Salen ambos campos - node_id y nodearc_id? ambos campos
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_pump", "column":"energy_price", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_pump", "column":"price_pattern_id", "dataType":"character varying(18)", "isUtils":"False"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_pump", "column":"energy_price", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_pump", "column":"energy_pattern_id", "dataType":"character varying(18)", "isUtils":"False"}}$$);
--how to update those fields??? - XAVI
--Energy - epanet - section C
--2puntos con pump
--UPDATE inp_pump j SET energy_price = sourc_type FROM inp_energy s WHERE s.node_id = j.node_id;

--PIPE REFACTOR
--pipe has fields reactionparam character varying(30),reactionvalue character varying(30), already its the same thing? - XAVI
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_pipe", "column":"bulk_coeff", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_pipe", "column":"wall_coeff", "dataType":"float", "isUtils":"False"}}$$);

--SHORTPIPE REFACTOR
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_pipe", "column":"reactionparam", "dataType":"character varying(30)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_pipe", "column":"reactionvalue", "dataType":"character varying(30)", "isUtils":"False"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_shortpipe", "column":"bulk_coeff", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_shortpipe", "column":"wall_coeff", "dataType":"float", "isUtils":"False"}}$$);

--TANK REFACTOR
--mixing_model - que tipo de campo es? en inp_mixing hay type y value
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_tank", "column":"mixing_model", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_tank", "column":"bulk_coeff", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_tank", "column":"wall_coeff", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_tank", "column":"init_quality", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_tank", "column":"source_type", "dataType":"character varying(18)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_tank", "column":"source_quality", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_tank", "column":"source_pattern_id", "dataType":"character varying(1)", "isUtils":"False"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_tank", "column":"mixing_model", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_tank", "column":"bulk_coeff", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_tank", "column":"wall_coeff", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_tank", "column":"init_quality", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_tank", "column":"source_type", "dataType":"character varying(18)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_tank", "column":"source_quality", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_tank", "column":"source_pattern_id", "dataType":"character varying(1)", "isUtils":"False"}}$$);

UPDATE inp_tank j SET init_quality = initqual FROM inp_quality s WHERE s.node_id = j.node_id;
UPDATE inp_tank j SET source_type = sourc_type FROM inp_source s WHERE s.node_id = j.node_id;
UPDATE inp_tank j SET source_quality = quality FROM inp_source s WHERE s.node_id = j.node_id;
UPDATE inp_tank j SET source_pattern_id = s.pattern_id FROM inp_source s WHERE s.node_id = j.node_id;

INSERT INTO config_form_fields 
SELECT 'v_edit_inp_tank', formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden 
FROM config_form_fields WHERE formname ='v_edit_inp_junction' AND 
columnname in ('init_quality', 'source_type', 'source_quality', 'source_pattern_id') 
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields 
SELECT 'v_edit_inp_dscenario_tank', formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden 
FROM config_form_fields WHERE formname ='v_edit_inp_tank' 
AND columnname in ('init_quality', 'source_type', 'source_quality', 'source_pattern_id')
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

-- RESERVOIR REFACTOR
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_reservoir", "column":"init_quality", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_reservoir", "column":"source_type", "dataType":"character varying(18)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_reservoir", "column":"source_quality", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_reservoir", "column":"source_pattern_id", "dataType":"character varying(16)", "isUtils":"False"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_reservoir", "column":"init_quality", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_reservoir", "column":"source_type", "dataType":"character varying(18)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_reservoir", "column":"source_quality", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_reservoir", "column":"source_pattern_id", "dataType":"character varying(16)", "isUtils":"False"}}$$);

UPDATE inp_reservoir j SET init_quality = initqual FROM inp_quality s WHERE s.node_id = j.node_id;
UPDATE inp_reservoir j SET source_type = sourc_type FROM inp_source s WHERE s.node_id = j.node_id;
UPDATE inp_reservoir j SET source_quality = quality FROM inp_source s WHERE s.node_id = j.node_id;
UPDATE inp_reservoir j SET source_pattern_id = s.pattern_id FROM inp_source s WHERE s.node_id = j.node_id;

INSERT INTO config_form_fields 
SELECT 'v_edit_inp_reservoir', formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden 
FROM config_form_fields WHERE formname ='v_edit_inp_junction' AND 
columnname in ('init_quality', 'source_type', 'source_quality', 'source_pattern_id') 
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields 
SELECT 'v_edit_inp_dscenario_reservoir', formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden 
FROM config_form_fields WHERE formname ='v_edit_inp_reservoir' 
AND columnname in ('init_quality', 'source_type', 'source_quality', 'source_pattern_id')
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;


--VALVE REFACTOR
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_valve", "column":"init_quality", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_valve", "column":"init_quality", "dataType":"float", "isUtils":"False"}}$$);

UPDATE inp_valve j SET init_quality = initqual FROM inp_quality s WHERE s.node_id = j.node_id;

INSERT INTO config_form_fields 
SELECT 'v_edit_inp_reservoir', formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden 
FROM config_form_fields WHERE formname ='v_edit_inp_junction' AND columnname in ('init_quality') 
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields 
SELECT 'v_edit_inp_dscenario_reservoir', formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden 
FROM config_form_fields WHERE formname ='v_edit_inp_reservoir' AND columnname in ('init_quality')
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

--VIRTUALVALVE REFACTOR
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_virtualvalve", "column":"init_quality", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_virtualvalve", "column":"init_quality", "dataType":"float", "isUtils":"False"}}$$);

UPDATE inp_virtualvalve j SET init_quality = initqual FROM inp_quality s WHERE s.node_id = j.node_id;

INSERT INTO config_form_fields 
SELECT 'inp_virtualvalve', formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden 
FROM config_form_fields WHERE formname ='v_edit_inp_junction' AND columnname in ('init_quality') 
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields 
SELECT 'inp_dscenario_virtualvalve', formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden 
FROM config_form_fields WHERE formname ='inp_virtualvalve' AND columnname in ('init_quality')
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

--INLET REFACTOR

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_inlet", "column":"head", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_inlet", "column":"mixing_model", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_inlet", "column":"bulk_coeff", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_inlet", "column":"wall_coeff", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_inlet", "column":"init_quality", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_inlet", "column":"source_type", "dataType":"character varying(18)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_inlet", "column":"source_quality", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_inlet", "column":"source_pattern_id", "dataType":"character varying(1)", "isUtils":"False"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_inlet", "column":"mixing_model", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_inlet", "column":"bulk_coeff", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_inlet", "column":"wall_coeff", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_inlet", "column":"init_quality", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_inlet", "column":"source_type", "dataType":"character varying(18)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_inlet", "column":"source_quality", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_inlet", "column":"source_pattern_id", "dataType":"character varying(1)", "isUtils":"False"}}$$);

UPDATE inp_inlet j SET init_quality = initqual FROM inp_quality s WHERE s.node_id = j.node_id;
UPDATE inp_inlet j SET source_type = sourc_type FROM inp_source s WHERE s.node_id = j.node_id;
UPDATE inp_inlet j SET source_quality = quality FROM inp_source s WHERE s.node_id = j.node_id;
UPDATE inp_inlet j SET source_pattern_id = s.pattern_id FROM inp_source s WHERE s.node_id = j.node_id;

---remove tables
ALTER TABLE inp_emitter RENAME TO _inp_emitter_;
ALTER TABLE inp_quality RENAME TO _inp_quality_;
ALTER TABLE inp_source RENAME TO _inp_source_;
ALTER TABLE inp_reactions RENAME TO _inp_reactions_;

DELETE FROM sys_table WHERE id  IN ('inp_quality', 'inp_source','inp_emitter','inp_reactions');