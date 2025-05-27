/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

CREATE TRIGGER gw_trg_edit_arc INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_arc
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_arc('parent');

CREATE TRIGGER gw_trg_edit_node INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_node
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_node('parent');

CREATE TRIGGER gw_trg_edit_connec INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_connec
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_connec('parent');

CREATE TRIGGER gw_trg_edit_element_pol INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_pol_element
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_element_pol();

CREATE TRIGGER gw_trg_ui_element INSTEAD OF INSERT OR DELETE OR UPDATE ON v_ui_element_x_node
FOR EACH ROW EXECUTE FUNCTION gw_trg_ui_element('node');

CREATE TRIGGER gw_trg_ui_element INSTEAD OF INSERT OR DELETE OR UPDATE ON v_ui_element_x_connec
FOR EACH ROW EXECUTE FUNCTION gw_trg_ui_element('connec');

CREATE TRIGGER gw_trg_ui_element INSTEAD OF INSERT OR DELETE OR UPDATE ON v_ui_element_x_arc
FOR EACH ROW EXECUTE FUNCTION gw_trg_ui_element('arc');

CREATE TRIGGER gw_trg_ui_element INSTEAD OF INSERT OR DELETE OR UPDATE ON v_ui_element_x_link
FOR EACH ROW EXECUTE FUNCTION gw_trg_ui_element('link');

CREATE TRIGGER gw_trg_edit_pol_connec INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_pol_connec
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_man_connec_pol();

CREATE TRIGGER gw_trg_edit_pol_node INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_pol_node
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_man_node_pol();

CREATE TRIGGER gw_trg_edit_inp_node_junction INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_junction
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_node('inp_junction');

CREATE TRIGGER gw_trg_edit_inp_dscenario_junction INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_dscenario_junction
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('JUNCTION');

CREATE TRIGGER gw_trg_edit_inp_node_pump INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_pump
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_node('inp_pump');

CREATE TRIGGER gw_trg_edit_inp_arc_pipe INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_pipe
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_arc('inp_pipe');

CREATE TRIGGER gw_trg_edit_inp_arc_pump INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_virtualpump
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_arc('inp_virtualpump');

CREATE TRIGGER gw_trg_edit_inp_arc_virtualvalve INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_virtualvalve
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_arc('inp_virtualvalve');

CREATE TRIGGER gw_trg_edit_inp_dscenario_pipe INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_dscenario_pipe
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('PIPE');

CREATE TRIGGER gw_trg_edit_inp_dscenario_virtualvalve INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_dscenario_virtualvalve
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('VIRTUALVALVE');

CREATE TRIGGER gw_trg_edit_inp_dscenario_virtualpump INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_dscenario_virtualpump
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('VIRTUALPUMP');

CREATE TRIGGER gw_trg_edit_man_register_pol INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_pol_register
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_man_node_pol('man_register_pol');

CREATE TRIGGER gw_trg_edit_man_fountain_pol INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_pol_fountain
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_man_connec_pol('man_fountain_pol');

CREATE TRIGGER gw_trg_edit_man_tank_pol INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_pol_tank
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_man_node_pol('man_tank_pol');

CREATE TRIGGER gw_trg_edit_inp_dscenario_pump INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_dscenario_pump
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('PUMP');

CREATE TRIGGER gw_trg_edit_inp_node_pump INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_pump_additional
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_node('inp_pump_additional');

CREATE TRIGGER gw_trg_edit_inp_dscenario_pump_additional INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_dscenario_pump_additional
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('PUMP_ADDITIONAL');

CREATE TRIGGER gw_trg_edit_inp_dscenario_shortpipe INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_dscenario_shortpipe
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('SHORTPIPE');

CREATE TRIGGER gw_trg_edit_inp_node_shortpipe INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_shortpipe
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_node('inp_shortpipe');

CREATE TRIGGER gw_trg_edit_inp_dscenario_connec INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_dscenario_connec
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('CONNEC');

CREATE TRIGGER gw_trg_edit_inp_connec INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_connec
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_connec();

CREATE TRIGGER gw_trg_edit_inp_dscenario_tank INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_dscenario_tank
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('TANK');

CREATE TRIGGER gw_trg_edit_inp_node_tank INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_tank
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_node('inp_tank');

CREATE TRIGGER gw_trg_edit_inp_dscenario_reservoir INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_dscenario_reservoir
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('RESERVOIR');

CREATE TRIGGER gw_trg_edit_inp_node_reservoir INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_reservoir
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_node('inp_reservoir');

CREATE TRIGGER gw_trg_edit_inp_dscenario_valve INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_dscenario_valve
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('VALVE');

CREATE TRIGGER gw_trg_edit_inp_dscenario_demand INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_dscenario_demand
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario_demand();

CREATE TRIGGER gw_trg_edit_inp_node_valve INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_valve
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_node('inp_valve');

CREATE TRIGGER gw_trg_edit_inp_dscenario_inlet INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_dscenario_inlet
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('INLET');

CREATE TRIGGER gw_trg_edit_inp_node_inlet INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_inlet
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_node('inp_inlet');

CREATE TRIGGER gw_trg_edit_controls BEFORE DELETE OR UPDATE
ON presszone FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_controls('presszone_id');

CREATE TRIGGER gw_trg_edit_controls BEFORE DELETE OR UPDATE
ON dqa FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_controls('dqa_id');

CREATE TRIGGER gw_trg_edit_controls BEFORE DELETE OR UPDATE
ON supplyzone FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_controls('supplyzone_id');


CREATE TRIGGER gw_trg_edit_link INSTEAD OF INSERT OR UPDATE OR DELETE ON v_edit_link
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_link();

CREATE TRIGGER gw_trg_edit_plan_netscenario INSTEAD OF INSERT OR DELETE OR UPDATE ON
v_edit_plan_netscenario_presszone FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_plan_netscenario('PRESSZONE');

CREATE TRIGGER gw_trg_edit_minsector INSTEAD OF INSERT OR DELETE OR UPDATE ON
v_edit_minsector FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_minsector();

CREATE TRIGGER gw_trg_edit_samplepoint INSTEAD OF INSERT OR DELETE OR UPDATE ON
v_edit_samplepoint FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_samplepoint('samplepoint');

CREATE TRIGGER gw_trg_typevalue_fk AFTER INSERT OR UPDATE ON
dqa FOR EACH ROW EXECUTE FUNCTION gw_trg_typevalue_fk('dqa');

CREATE TRIGGER gw_trg_typevalue_fk AFTER INSERT OR UPDATE ON
sector FOR EACH ROW EXECUTE FUNCTION gw_trg_typevalue_fk('sector');

CREATE TRIGGER gw_trg_edit_review_connec INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_review_connec
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_review_connec();

-- 05/12/24
CREATE TRIGGER gw_trg_dscenario_demand_feature AFTER INSERT ON inp_dscenario_demand
FOR EACH ROW EXECUTE FUNCTION gw_trg_dscenario_demand_feature();

CREATE TRIGGER gw_trg_typevalue_fk AFTER INSERT OR UPDATE ON inp_dscenario_demand
FOR EACH ROW EXECUTE FUNCTION gw_trg_typevalue_fk('inp_dscenario_demand');

-- 13/12/24
CREATE TRIGGER gw_trg_edit_anl_hydrant INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_anl_hydrant
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_anl_hydrant();

CREATE TRIGGER gw_trg_edit_ve_epa_junction INSTEAD OF INSERT OR DELETE OR UPDATE ON
ve_epa_junction FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_ve_epa('junction');

CREATE TRIGGER gw_trg_edit_ve_epa_tank INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_epa_tank
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_ve_epa('tank');

CREATE TRIGGER gw_trg_edit_ve_epa_reservoir INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_epa_reservoir
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_ve_epa('reservoir');

CREATE TRIGGER gw_trg_edit_ve_epa_connec INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_epa_connec
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_ve_epa('connec');

CREATE TRIGGER gw_trg_edit_ve_epa_inlet INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_epa_inlet
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_ve_epa('inlet');


CREATE TRIGGER gw_trg_edit_ve_epa_pump INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_epa_pump
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_ve_epa('pump');

CREATE TRIGGER gw_trg_edit_ve_epa_pump_additional INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_epa_pump_additional
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_ve_epa('pump_additional');

CREATE TRIGGER gw_trg_edit_ve_epa_valve INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_epa_valve
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_ve_epa('valve');

CREATE TRIGGER gw_trg_edit_ve_epa_shortpipe INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_epa_shortpipe
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_ve_epa('shortpipe');

CREATE TRIGGER gw_trg_edit_ve_epa_pipe INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_epa_pipe
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_ve_epa('pipe');

CREATE TRIGGER gw_trg_edit_ve_epa_virtualvalve INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_epa_virtualvalve
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_ve_epa('virtualvalve');

CREATE TRIGGER gw_trg_edit_ve_epa_virtualpump INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_epa_virtualpump
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_ve_epa('virtualpump');

-- EDIT
CREATE TRIGGER gw_trg_v_edit_macrodqa INSTEAD OF INSERT OR DELETE OR UPDATE
ON v_edit_macrodqa FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_macrodqa('EDIT');

CREATE TRIGGER gw_trg_v_edit_macrodma INSTEAD OF INSERT OR DELETE OR UPDATE
ON v_edit_macrodma FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_macrodma('EDIT');

CREATE TRIGGER gw_trg_v_edit_macrosector INSTEAD OF INSERT OR DELETE OR UPDATE
ON v_edit_macrosector FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_macrosector('EDIT');

CREATE TRIGGER gw_trg_v_edit_macroomzone INSTEAD OF INSERT OR DELETE OR UPDATE
ON v_edit_macroomzone FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_macroomzone('EDIT');

CREATE TRIGGER gw_trg_v_edit_dqa INSTEAD OF INSERT OR DELETE OR UPDATE
ON v_edit_dqa FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_dqa('EDIT');

CREATE TRIGGER gw_trg_v_edit_dma INSTEAD OF INSERT OR DELETE OR UPDATE
ON v_edit_dma FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_dma('EDIT');

CREATE TRIGGER gw_trg_v_edit_sector INSTEAD OF INSERT OR DELETE OR UPDATE
ON v_edit_sector FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_sector('EDIT');

CREATE TRIGGER gw_trg_v_edit_omzone INSTEAD OF INSERT OR DELETE OR UPDATE
ON v_edit_omzone FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_omzone('EDIT');

CREATE TRIGGER gw_trg_v_edit_presszone INSTEAD OF INSERT OR DELETE OR UPDATE
ON v_edit_presszone FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_presszone('EDIT');

CREATE TRIGGER gw_trg_v_edit_supplyzone INSTEAD OF INSERT OR DELETE OR UPDATE
ON v_edit_supplyzone FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_supplyzone('EDIT');

-- UI
CREATE TRIGGER gw_trg_v_ui_macrodqa INSTEAD OF INSERT OR DELETE OR UPDATE
ON v_ui_macrodqa FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_macrodqa('UI');

CREATE TRIGGER gw_trg_v_ui_macrodma INSTEAD OF INSERT OR DELETE OR UPDATE
ON v_ui_macrodma FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_macrodma('UI');

CREATE TRIGGER gw_trg_v_ui_macrosector INSTEAD OF INSERT OR DELETE OR UPDATE
ON v_ui_macrosector FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_macrosector('UI');

CREATE TRIGGER gw_trg_v_ui_macroomzone INSTEAD OF INSERT OR DELETE OR UPDATE
ON v_ui_macroomzone FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_macroomzone('UI');

CREATE TRIGGER gw_trg_v_ui_dqa INSTEAD OF INSERT OR DELETE OR UPDATE
ON v_ui_dqa FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_dqa('UI');

CREATE TRIGGER gw_trg_v_ui_dma INSTEAD OF INSERT OR DELETE OR UPDATE
ON v_ui_dma FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_dma('UI');

CREATE TRIGGER gw_trg_v_ui_sector INSTEAD OF INSERT OR DELETE OR UPDATE
ON v_ui_sector FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_sector('UI');

CREATE TRIGGER gw_trg_v_ui_presszone INSTEAD OF INSERT OR DELETE OR UPDATE
ON v_ui_presszone FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_presszone('UI');

CREATE TRIGGER gw_trg_v_ui_omzone INSTEAD OF INSERT OR DELETE OR UPDATE
ON v_ui_omzone FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_omzone('UI');

CREATE TRIGGER gw_trg_v_ui_supplyzone INSTEAD OF INSERT OR DELETE OR UPDATE
ON v_ui_supplyzone FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_supplyzone('UI');

-- delete duplicated triggers
DROP TRIGGER IF EXISTS gw_trg_edit_macrosector ON v_edit_macrosector;
DROP TRIGGER IF EXISTS gw_trg_edit_macrodma ON v_edit_macrodma;

CREATE TRIGGER gw_trg_typevalue_fk_insert AFTER INSERT
ON supplyzone FOR EACH ROW EXECUTE FUNCTION gw_trg_typevalue_fk('supplyzone');

CREATE TRIGGER gw_trg_typevalue_fk_update AFTER UPDATE OF supplyzone_type
ON supplyzone FOR EACH ROW WHEN (((old.supplyzone_type)::TEXT IS DISTINCT
FROM (new.supplyzone_type)::TEXT)) EXECUTE FUNCTION gw_trg_typevalue_fk('supplyzone');

-- 06/02/2025
CREATE TRIGGER gw_trg_mantypevalue_fk_insert AFTER INSERT ON node
FOR EACH ROW EXECUTE FUNCTION gw_trg_mantypevalue_fk('node');

CREATE TRIGGER gw_trg_mantypevalue_fk_update AFTER UPDATE OF function_type, category_type, location_type ON node
FOR EACH ROW
WHEN ((((old.function_type)::TEXT IS DISTINCT FROM (new.function_type)::TEXT)
OR ((old.category_type)::TEXT IS DISTINCT FROM (new.category_type)::TEXT)
OR ((old.location_type)::TEXT IS DISTINCT FROM (new.location_type)::TEXT)))
EXECUTE FUNCTION gw_trg_mantypevalue_fk('node');

CREATE TRIGGER gw_trg_node_arc_divide AFTER INSERT ON node
FOR EACH ROW EXECUTE FUNCTION gw_trg_node_arc_divide();

CREATE TRIGGER gw_trg_node_rotation_update AFTER INSERT OR UPDATE OF hemisphere, the_geom ON node
FOR EACH ROW EXECUTE FUNCTION gw_trg_node_rotation_update();

CREATE TRIGGER gw_trg_node_statecontrol BEFORE INSERT OR UPDATE OF state ON node
FOR EACH ROW EXECUTE FUNCTION gw_trg_node_statecontrol();

CREATE TRIGGER gw_trg_topocontrol_node AFTER INSERT OR UPDATE OF the_geom, custom_top_elev, state ON node
FOR EACH ROW EXECUTE FUNCTION gw_trg_topocontrol_node();

CREATE TRIGGER gw_trg_typevalue_fk_insert AFTER INSERT ON node
FOR EACH ROW EXECUTE FUNCTION gw_trg_typevalue_fk('node');

CREATE TRIGGER gw_trg_typevalue_fk_update AFTER UPDATE OF verified ON node
FOR EACH ROW WHEN (((old.verified)::TEXT IS DISTINCT
FROM (new.verified)::TEXT)) EXECUTE FUNCTION gw_trg_typevalue_fk('node');

CREATE TRIGGER gw_trg_edit_review_node INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_review_node
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_review_node();

-- 10/02/2025
CREATE TRIGGER gw_trg_ui_doc_x_arc INSTEAD OF INSERT OR DELETE OR UPDATE ON v_ui_doc_x_arc
FOR EACH ROW EXECUTE FUNCTION gw_trg_ui_doc('arc');

CREATE TRIGGER gw_trg_ui_doc_x_connec INSTEAD OF INSERT OR DELETE OR UPDATE ON v_ui_doc_x_connec
FOR EACH ROW EXECUTE FUNCTION gw_trg_ui_doc('connec');

CREATE TRIGGER gw_trg_ui_doc_x_node INSTEAD OF INSERT OR DELETE OR UPDATE ON v_ui_doc_x_node
FOR EACH ROW EXECUTE FUNCTION gw_trg_ui_doc('node');

CREATE TRIGGER gw_trg_ui_doc_x_visit INSTEAD OF INSERT OR DELETE OR UPDATE ON v_ui_doc_x_visit
FOR EACH ROW EXECUTE FUNCTION gw_trg_ui_doc('visit');

DROP TRIGGER IF EXISTS gw_trg_link_data ON connec;
CREATE TRIGGER gw_trg_link_data
AFTER UPDATE OF epa_type, state_type, expl_visibility, conneccat_id, fluid_type, n_hydrometer
ON connec FOR EACH ROW EXECUTE PROCEDURE gw_trg_link_data('connec');

CREATE TRIGGER gw_trg_edit_inp_pattern INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_pattern
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_pattern('inp_pattern');

CREATE TRIGGER gw_trg_edit_inp_pattern_value INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_pattern_value
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_pattern('inp_pattern_value');


-- 14/03/2025
CREATE TRIGGER gw_trg_arc_link_update AFTER
UPDATE OF the_geom ON arc FOR EACH ROW EXECUTE FUNCTION gw_trg_arc_link_update();
CREATE TRIGGER gw_trg_arc_node_values AFTER
INSERT OR UPDATE OF node_1, node_2, the_geom ON arc FOR EACH ROW EXECUTE FUNCTION gw_trg_arc_node_values();
CREATE TRIGGER gw_trg_arc_noderotation_update AFTER
INSERT OR DELETE OR UPDATE OF the_geom ON arc FOR EACH ROW EXECUTE FUNCTION gw_trg_arc_noderotation_update();
CREATE TRIGGER gw_trg_topocontrol_arc BEFORE
INSERT OR UPDATE OF the_geom, state ON arc FOR EACH ROW EXECUTE FUNCTION gw_trg_topocontrol_arc();
CREATE TRIGGER gw_trg_edit_controls AFTER
DELETE OR UPDATE ON arc FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_controls('arc_id');
CREATE TRIGGER gw_trg_mantypevalue_fk_insert AFTER
INSERT ON arc FOR EACH ROW EXECUTE FUNCTION gw_trg_mantypevalue_fk('arc');
CREATE TRIGGER gw_trg_mantypevalue_fk_update AFTER UPDATE OF function_type, category_type, location_type ON arc
FOR EACH ROW
WHEN ((((old.function_type)::TEXT IS DISTINCT FROM (new.function_type)::TEXT)
OR ((old.category_type)::TEXT IS DISTINCT FROM (new.category_type)::TEXT)
OR ((old.location_type)::TEXT IS DISTINCT FROM (new.location_type)::TEXT)))
EXECUTE FUNCTION gw_trg_mantypevalue_fk('arc');

CREATE TRIGGER gw_trg_typevalue_fk_insert AFTER
INSERT ON arc FOR EACH ROW EXECUTE FUNCTION gw_trg_typevalue_fk('arc');
CREATE TRIGGER gw_trg_typevalue_fk_update AFTER
UPDATE OF verified, datasource, lock_level ON arc FOR EACH ROW
    WHEN (((old.verified IS DISTINCT
FROM
    new.verified)
    OR (old.datasource IS DISTINCT
FROM
    new.datasource)
    OR (old.lock_level IS DISTINCT
FROM
    new.lock_level))) EXECUTE FUNCTION gw_trg_typevalue_fk('arc');



CREATE TRIGGER gw_trg_connec_proximity_insert BEFORE INSERT ON connec
FOR EACH ROW EXECUTE FUNCTION gw_trg_connec_proximity();
CREATE TRIGGER gw_trg_connec_proximity_update AFTER UPDATE OF the_geom ON connec
FOR EACH ROW EXECUTE FUNCTION gw_trg_connec_proximity();
CREATE TRIGGER gw_trg_connect_update AFTER UPDATE OF arc_id, pjoint_id, pjoint_type, the_geom ON connec
FOR EACH ROW EXECUTE FUNCTION gw_trg_connect_update('connec');
CREATE TRIGGER gw_trg_unique_field AFTER INSERT OR UPDATE OF customer_code, state ON connec
FOR EACH ROW EXECUTE FUNCTION gw_trg_unique_field('connec');
CREATE TRIGGER gw_trg_edit_controls AFTER DELETE OR UPDATE ON connec
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_controls('connec_id');
CREATE TRIGGER gw_trg_mantypevalue_fk_insert AFTER INSERT ON connec
FOR EACH ROW EXECUTE FUNCTION gw_trg_mantypevalue_fk('connec');

CREATE TRIGGER gw_trg_mantypevalue_fk_update AFTER UPDATE OF function_type, category_type, location_type ON connec
FOR EACH ROW
WHEN ((((old.function_type)::TEXT IS DISTINCT FROM (new.function_type)::TEXT)
OR ((old.category_type)::TEXT IS DISTINCT FROM (new.category_type)::TEXT)
OR ((old.location_type)::TEXT IS DISTINCT FROM (new.location_type)::TEXT)))
EXECUTE FUNCTION gw_trg_mantypevalue_fk('connec');

CREATE TRIGGER gw_trg_typevalue_fk_insert AFTER INSERT ON connec
FOR EACH ROW EXECUTE FUNCTION gw_trg_typevalue_fk('connec');
CREATE TRIGGER gw_trg_typevalue_fk_update AFTER UPDATE OF verified, datasource, lock_level ON connec
FOR EACH ROW
    WHEN (((old.verified IS DISTINCT
FROM
    new.verified)
    OR (old.datasource IS DISTINCT
FROM
    new.datasource)
    OR (old.lock_level IS DISTINCT
FROM
    new.lock_level))) EXECUTE FUNCTION gw_trg_typevalue_fk('connec');


CREATE TRIGGER gw_trg_edit_controls AFTER DELETE OR UPDATE ON element
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_controls('element_id');

CREATE TRIGGER gw_trg_typevalue_fk_insert AFTER INSERT ON element
FOR EACH ROW EXECUTE FUNCTION gw_trg_typevalue_fk('element');

CREATE TRIGGER gw_trg_typevalue_fk_update AFTER UPDATE OF datasource, lock_level ON element
FOR EACH ROW
    WHEN (((old.datasource IS DISTINCT
FROM
    new.datasource)
    OR (old.lock_level IS DISTINCT
FROM
    new.lock_level))) EXECUTE FUNCTION gw_trg_typevalue_fk('element');

CREATE TRIGGER gw_trg_mantypevalue_fk_insert AFTER INSERT ON element
FOR EACH ROW EXECUTE FUNCTION gw_trg_mantypevalue_fk('element');

CREATE TRIGGER gw_trg_mantypevalue_fk_update AFTER UPDATE OF function_type, category_type, location_type ON element
FOR EACH ROW
WHEN ((((old.function_type)::TEXT IS DISTINCT FROM (new.function_type)::TEXT)
OR ((old.category_type)::TEXT IS DISTINCT FROM (new.category_type)::TEXT)
OR ((old.location_type)::TEXT IS DISTINCT FROM (new.location_type)::TEXT)))
EXECUTE FUNCTION gw_trg_mantypevalue_fk('element');

CREATE TRIGGER gw_trg_link_connecrotation_update AFTER
INSERT
    OR
UPDATE
    OF the_geom ON
    link FOR EACH ROW EXECUTE FUNCTION gw_trg_link_connecrotation_update();
CREATE TRIGGER gw_trg_link_data AFTER
INSERT
    OR
UPDATE
    OF the_geom ON
    link FOR EACH ROW EXECUTE FUNCTION gw_trg_link_data('link');

-- 09/04/2025
CREATE TRIGGER gw_trg_edit_controls BEFORE DELETE OR UPDATE ON macrosector
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_controls('macrosector_id');

CREATE TRIGGER gw_trg_edit_controls BEFORE DELETE OR UPDATE ON macrodma
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_controls('macrodma_id');

CREATE TRIGGER gw_trg_edit_controls BEFORE DELETE OR UPDATE ON macrodqa
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_controls('macrodqa_id');

CREATE TRIGGER gw_trg_edit_exploitation INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_exploitation
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_exploitation();

CREATE TRIGGER gw_trg_edit_controls BEFORE DELETE OR UPDATE ON exploitation
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_controls('expl_id');

CREATE TRIGGER gw_trg_edit_controls BEFORE DELETE OR UPDATE ON macroexploitation
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_controls('macroexpl_id');

CREATE TRIGGER gw_trg_typevalue_fk_insert AFTER INSERT
ON omzone FOR EACH ROW EXECUTE FUNCTION gw_trg_typevalue_fk('omzone');

CREATE TRIGGER gw_trg_typevalue_fk_update AFTER UPDATE OF omzone_type
ON omzone FOR EACH ROW WHEN (((old.omzone_type)::TEXT IS DISTINCT
FROM (new.omzone_type)::TEXT)) EXECUTE FUNCTION gw_trg_typevalue_fk('omzone');

-- 19/05/2025
CREATE TRIGGER gw_trg_edit_cat_feature INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_cat_feature_node
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_cat_feature('node');


-- 22/05/2025
CREATE TRIGGER gw_trg_fk_array_id_table BEFORE DELETE ON arc
FOR EACH ROW EXECUTE FUNCTION gw_trg_check_array_fk_id_table('arc_id', '{"man_source":"inlet_arc", "man_tank":"inlet_arc", "man_wtp":"inlet_arc", "man_valve":"to_arc", "man_pump":"to_arc", "man_meter":"to_arc"}');

CREATE TRIGGER gw_trg_fk_array_id_table_update AFTER UPDATE ON arc
FOR EACH ROW EXECUTE FUNCTION gw_trg_check_array_fk_id_table('arc_id', '{"man_source":"inlet_arc", "man_tank":"inlet_arc", "man_wtp":"inlet_arc", "man_valve":"to_arc", "man_pump":"to_arc", "man_meter":"to_arc"}');

CREATE TRIGGER gw_trg_fk_array_array_table AFTER INSERT OR UPDATE ON man_source
FOR EACH ROW EXECUTE FUNCTION gw_trg_check_array_fk_array_table('inlet_arc', 'arc', 'arc_id');

CREATE TRIGGER gw_trg_fk_array_array_table AFTER INSERT OR UPDATE ON man_tank
FOR EACH ROW EXECUTE FUNCTION gw_trg_check_array_fk_array_table('inlet_arc', 'arc', 'arc_id');

CREATE TRIGGER gw_trg_fk_array_array_table AFTER INSERT OR UPDATE ON man_wtp
FOR EACH ROW EXECUTE FUNCTION gw_trg_check_array_fk_array_table('inlet_arc', 'arc', 'arc_id');

CREATE TRIGGER gw_trg_fk_array_array_table AFTER INSERT OR UPDATE ON man_valve
FOR EACH ROW EXECUTE FUNCTION gw_trg_check_array_fk_array_table('to_arc', 'arc', 'arc_id');

CREATE TRIGGER gw_trg_fk_array_array_table AFTER INSERT OR UPDATE ON man_pump
FOR EACH ROW EXECUTE FUNCTION gw_trg_check_array_fk_array_table('to_arc', 'arc', 'arc_id');

CREATE TRIGGER gw_trg_fk_array_array_table AFTER INSERT OR UPDATE ON man_meter
FOR EACH ROW EXECUTE FUNCTION gw_trg_check_array_fk_array_table('to_arc', 'arc', 'arc_id');
