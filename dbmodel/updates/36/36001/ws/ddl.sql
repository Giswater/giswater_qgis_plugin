/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2022/01/03
CREATE TABLE inp_dscenario_virtualvalve
(
  dscenario_id integer NOT NULL,
  arc_id character varying(16) NOT NULL,
  valv_type character varying(18),
  pressure numeric(12,4),
  flow numeric(12,4),
  coef_loss numeric(12,4),
  curve_id character varying(16),
  minorloss numeric(12,4),
  status character varying(12) DEFAULT 'ACTIVE'::character varying,
  add_settings double precision,
  CONSTRAINT inp_dscenario_virtualvalve_pkey PRIMARY KEY (arc_id, dscenario_id),
  CONSTRAINT inp_dscenario_virtualvalve_curve_id_fkey FOREIGN KEY (curve_id)
      REFERENCES inp_curve (id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT inp_dscenario_virtualvalve_arc_id_fkey FOREIGN KEY (arc_id)
      REFERENCES inp_virtualvalve (arc_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT inp_dscenario_virtualvalve_status_check CHECK (status::text = ANY (ARRAY['ACTIVE'::character varying::text, 'CLOSED'::character varying::text, 'OPEN'::character varying::text])),
  CONSTRAINT inp_dscenario_virtualvalve_valv_type_check CHECK (valv_type::text = ANY (ARRAY['FCV'::character varying::text, 'GPV'::character varying::text, 'PBV'::character varying::text, 'PRV'::character varying::text, 'PSV'::character varying::text, 'TCV'::character varying::text]))
);

CREATE TABLE inp_dscenario_pump_additional
(
  dscenario_id integer NOT NULL,
  node_id character varying(16) NOT NULL,
  power character varying,
  curve_id character varying,
  speed numeric(12,6),
  pattern character varying,
  status character varying(12),
  CONSTRAINT inp_dscenario_pump_additional_pkey PRIMARY KEY (node_id, dscenario_id),
  CONSTRAINT inp_dscenario_pump_additional_curve_id_fkey FOREIGN KEY (curve_id)
      REFERENCES inp_curve (id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT inp_dscenario_pump_additional_node_id_fkey FOREIGN KEY (node_id)
      REFERENCES node (node_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT inp_dscenario_pump_additional_status_check CHECK (status::text = ANY (ARRAY['CLOSED'::character varying::text, 'OPEN'::character varying::text]))
);

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
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_pump", "column":"effic_curve_id", "dataType":"character varying(18)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_pump", "column":"energy_price", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_pump", "column":"energy_pattern_id", "dataType":"character varying(18)", "isUtils":"False"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_pump", "column":"effic_curve_id", "dataType":"character varying(18)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_pump", "column":"energy_price", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_pump", "column":"energy_pattern_id", "dataType":"character varying(18)", "isUtils":"False"}}$$);

ALTER TABLE inp_pump DROP CONSTRAINT IF EXISTS inp_valve_effic_curve_id_fkey;
ALTER TABLE inp_pump ADD CONSTRAINT inp_valve_effic_curve_id_fkey FOREIGN KEY (effic_curve_id)
REFERENCES inp_curve (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE inp_dscenario_pump DROP CONSTRAINT IF EXISTS inp_valve_effic_curve_id_fkey;
ALTER TABLE inp_dscenario_pump ADD CONSTRAINT inp_valve_effic_curve_id_fkey FOREIGN KEY (effic_curve_id)
REFERENCES inp_curve (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

UPDATE inp_pump SET effic_curve_id=energyvalue 
WHERE energyparam ilike '%EFFIC%' AND energyvalue in (select id from inp_curve);

UPDATE inp_pump SET energy_price=energyvalue::float 
WHERE energyparam ilike '%PRICE%' and energyvalue ~ '^ *[-+]?[0-9]*([.][0-9]+)?[0-9]*(([eE][-+]?)[0-9]+)? *$' is true;

UPDATE inp_pump SET energy_pattern_id=energyvalue 
WHERE energyparam ilike '%PATTERN%' AND energyvalue in (select pattern_id from inp_pattern);
--PRIMERO HAY QUE REHACER LA VISTA VI_ENERGY
--SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"inp_pump", "column":"energyparam"}}$$);
--SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"inp_pump", "column":"energyvalue"}}$$);

--PUMP_ADDITIONAL REFACTOR
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_pump_additional", "column":"effic_curve_id", "dataType":"character varying(18)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_pump_additional", "column":"energy_price", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_pump_additional", "column":"energy_pattern_id", "dataType":"character varying(18)", "isUtils":"False"}}$$);
--create table dscenario

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_pump_additional", "column":"effic_curve_id", "dataType":"character varying(18)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_pump_additional", "column":"energy_price", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_pump_additional", "column":"energy_pattern_id", "dataType":"character varying(18)", "isUtils":"False"}}$$);

ALTER TABLE inp_pump_additional DROP CONSTRAINT IF EXISTS inp_valve_effic_curve_id_fkey;
ALTER TABLE inp_pump_additional ADD CONSTRAINT inp_valve_effic_curve_id_fkey FOREIGN KEY (effic_curve_id)
REFERENCES inp_curve (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE inp_dscenario_pump_additional DROP CONSTRAINT IF EXISTS inp_valve_effic_curve_id_fkey;
ALTER TABLE inp_dscenario_pump_additional ADD CONSTRAINT inp_valve_effic_curve_id_fkey FOREIGN KEY (effic_curve_id)
REFERENCES inp_curve (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

UPDATE inp_pump_additional SET effic_curve_id=energyvalue 
WHERE energyparam ilike '%EFFIC%' AND energyvalue in (select id from inp_curve);

UPDATE inp_pump_additional SET energy_price=energyvalue::float 
WHERE energyparam ilike '%PRICE%' and energyvalue ~ '^ *[-+]?[0-9]*([.][0-9]+)?[0-9]*(([eE][-+]?)[0-9]+)? *$' is true;

UPDATE inp_pump_additional SET energy_pattern_id=energyvalue 
WHERE energyparam ilike '%PATTERN%' AND energyvalue in (select pattern_id from inp_pattern);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"inp_pump_additional", "column":"energyparam"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"inp_pump_additional", "column":"energyvalue"}}$$);

--PIPE REFACTOR
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_pipe", "column":"bulk_coeff", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_pipe", "column":"wall_coeff", "dataType":"float", "isUtils":"False"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_pipe", "column":"bulk_coeff", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_pipe", "column":"wall_coeff", "dataType":"float", "isUtils":"False"}}$$);


UPDATE inp_pipe SET bulk_coeff=reactionvalue::float 
WHERE reactionparam ilike '%bulk%' and reactionvalue ~ '^ *[-+]?[0-9]*([.][0-9]+)?[0-9]*(([eE][-+]?)[0-9]+)? *$' is true;

UPDATE inp_pipe SET bulk_coeff=reactionvalue::float 
WHERE reactionparam ilike '%wall%' and reactionvalue ~ '^ *[-+]?[0-9]*([.][0-9]+)?[0-9]*(([eE][-+]?)[0-9]+)? *$' is true;
--PRIMERO HAY QUE REHACER LA VISTA VI_REACTIONS
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"inp_pipe", "column":"reactionparam"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"inp_pipe", "column":"reactionvalue"}}$$);

--SHORTPIPE REFACTOR
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_shortpipe", "column":"bulk_coeff", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_shortpipe", "column":"wall_coeff", "dataType":"float", "isUtils":"False"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_shortpipe", "column":"bulk_coeff", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_shortpipe", "column":"wall_coeff", "dataType":"float", "isUtils":"False"}}$$);

--TANK REFACTOR
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_tank", "column":"mixing_model", "dataType":"character varying(18)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_tank", "column":"mixing_fraction", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_tank", "column":"reaction_coeff", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_tank", "column":"init_quality", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_tank", "column":"source_type", "dataType":"character varying(18)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_tank", "column":"source_quality", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_tank", "column":"source_pattern_id", "dataType":"character varying(1)", "isUtils":"False"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_tank", "column":"mixing_model", "dataType":"character varying(18)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_tank", "column":"mixing_fraction", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_tank", "column":"reaction_coeff", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_tank", "column":"init_quality", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_tank", "column":"source_type", "dataType":"character varying(18)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_tank", "column":"source_quality", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_tank", "column":"source_pattern_id", "dataType":"character varying(1)", "isUtils":"False"}}$$);

UPDATE inp_tank j SET mixing_model = mix_type,mixing_fraction=value FROM inp_mixing s WHERE s.node_id = j.node_id;
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

UPDATE inp_virtualvalve j SET init_quality = initqual FROM inp_quality s WHERE s.node_id = j.arc_id;

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
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_inlet", "column":"mixing_model", "dataType":"character varying(18)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_inlet", "column":"mixing_fraction", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_inlet", "column":"reaction_coeff", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_inlet", "column":"init_quality", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_inlet", "column":"source_type", "dataType":"character varying(18)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_inlet", "column":"source_quality", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_inlet", "column":"source_pattern_id", "dataType":"character varying(1)", "isUtils":"False"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_inlet", "column":"mixing_model", "dataType":"character varying(18)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_inlet", "column":"mixing_fraction", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_inlet", "column":"reaction_coeff", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_inlet", "column":"init_quality", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_inlet", "column":"source_type", "dataType":"character varying(18)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_inlet", "column":"source_quality", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_inlet", "column":"source_pattern_id", "dataType":"character varying(1)", "isUtils":"False"}}$$);

UPDATE inp_inlet j SET mixing_model = mix_type,mixing_fraction=value FROM inp_mixing s WHERE s.node_id = j.node_id;
UPDATE inp_inlet j SET init_quality = initqual FROM inp_quality s WHERE s.node_id = j.node_id;
UPDATE inp_inlet j SET source_type = sourc_type FROM inp_source s WHERE s.node_id = j.node_id;
UPDATE inp_inlet j SET source_quality = quality FROM inp_source s WHERE s.node_id = j.node_id;
UPDATE inp_inlet j SET source_pattern_id = s.pattern_id FROM inp_source s WHERE s.node_id = j.node_id;

---remove tables
ALTER TABLE inp_emitter RENAME TO _inp_emitter_;
ALTER TABLE inp_quality RENAME TO _inp_quality_;
ALTER TABLE inp_source RENAME TO _inp_source_;
ALTER TABLE inp_reactions RENAME TO _inp_reactions_;
ALTER TABLE inp_mixing RENAME TO _inp_mixing_;

DELETE FROM sys_table WHERE id  IN ('inp_quality', 'inp_source','inp_emitter','inp_reactions','inp_mixing');