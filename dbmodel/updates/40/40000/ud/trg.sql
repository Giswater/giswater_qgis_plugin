/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

CREATE TRIGGER gw_trg_edit_element INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_element
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_element('element');

CREATE TRIGGER gw_trg_edit_samplepoint INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_samplepoint
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_samplepoint('samplepoint');

CREATE TRIGGER gw_trg_edit_arc INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_arc
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_arc('parent');

CREATE TRIGGER gw_trg_edit_node INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_node
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_node('parent');

CREATE TRIGGER gw_trg_edit_connec INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_connec
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_connec('parent');

CREATE TRIGGER gw_trg_edit_gully INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_gully
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_gully('parent');

CREATE TRIGGER gw_trg_edit_element_pol INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_pol_element
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_element_pol();

CREATE TRIGGER gw_trg_ui_element INSTEAD OF INSERT OR DELETE OR UPDATE ON v_ui_element_x_node
FOR EACH ROW EXECUTE FUNCTION gw_trg_ui_element('element_x_node');

CREATE TRIGGER gw_trg_ui_element INSTEAD OF INSERT OR DELETE OR UPDATE ON v_ui_element_x_connec
FOR EACH ROW EXECUTE FUNCTION gw_trg_ui_element('element_x_connec');

CREATE TRIGGER gw_trg_ui_element INSTEAD OF INSERT OR DELETE OR UPDATE ON v_ui_element_x_arc
FOR EACH ROW EXECUTE FUNCTION gw_trg_ui_element('element_x_arc');

CREATE TRIGGER gw_trg_ui_element INSTEAD OF INSERT OR DELETE OR UPDATE ON v_ui_element_x_gully
FOR EACH ROW EXECUTE FUNCTION gw_trg_ui_element('element_x_gully');

CREATE TRIGGER gw_trg_edit_inp_node_storage INSTEAD OF INSERT OR UPDATE OR DELETE
ON v_edit_inp_storage FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_inp_node('inp_storage');

CREATE TRIGGER gw_trg_edit_inp_dscenario INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_dscenario_storage
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('STORAGE');

CREATE TRIGGER gw_trg_edit_inp_dscenario INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_dscenario_outfall
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('OUTFALL');

CREATE TRIGGER gw_trg_edit_inp_node_junction INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_junction
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_node('inp_junction');

CREATE TRIGGER gw_trg_edit_inp_node_junction INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_outfall
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_node('inp_outfall');

CREATE TRIGGER gw_trg_edit_inp_treatment INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_treatment
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_treatment();

CREATE TRIGGER gw_trg_edit_inp_inflows INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_inflows_poll
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_inflows('INFLOWS-POLL');

CREATE TRIGGER gw_trg_edit_inp_inflows INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_inflows
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_inflows('INFLOWS');

CREATE TRIGGER gw_trg_edit_inp_dwf INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_dwf
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dwf();

CREATE TRIGGER gw_trg_edit_inp_dscenario INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_dscenario_treatment
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('TREATMENT');

CREATE TRIGGER gw_trg_edit_inp_dscenario INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_dscenario_junction
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('JUNCTION');

CREATE TRIGGER gw_trg_edit_inp_dscenario INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_dscenario_inflows_poll
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('INFLOWS-POLL');

CREATE TRIGGER gw_trg_edit_inp_dscenario INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_dscenario_inflows
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('INFLOWS');

CREATE TRIGGER gw_trg_edit_inp_flwreg INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_flwreg_outlet
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_flwreg('FLWREG-OUTLET');

CREATE TRIGGER gw_trg_edit_inp_flwreg INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_flwreg_weir
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_flwreg('FLWREG-WEIR');

CREATE TRIGGER gw_trg_edit_inp_flwreg INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_flwreg_pump
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_flwreg('FLWREG-PUMP');

CREATE TRIGGER gw_trg_edit_inp_flwreg INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_flwreg_orifice
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_flwreg('FLWREG-ORIFICE');

CREATE TRIGGER gw_trg_edit_inp_dscenario INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_dscenario_flwreg_outlet
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('FLWREG-OUTLET');

CREATE TRIGGER gw_trg_edit_inp_dscenario INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_dscenario_flwreg_weir
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('FLWREG-WEIR');

CREATE TRIGGER gw_trg_edit_inp_dscenario INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_dscenario_flwreg_pump
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('FLWREG-PUMP');

CREATE TRIGGER gw_trg_edit_inp_dscenario INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_dscenario_flwreg_orifice
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('FLWREG-ORIFICE');

CREATE TRIGGER gw_trg_edit_inp_arc_orifice INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_orifice
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_arc('inp_orifice');

CREATE TRIGGER gw_trg_edit_inp_arc_outlet INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_outlet
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_arc('inp_outlet');

CREATE TRIGGER gw_trg_edit_inp_arc_pump INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_pump
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_arc('inp_pump');

CREATE TRIGGER gw_trg_edit_inp_arc_virtual INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_virtual
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_arc('inp_virtual');

CREATE TRIGGER gw_trg_edit_inp_arc_weir INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_weir
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_arc('inp_weir');

CREATE TRIGGER gw_trg_edit_inp_dscenario INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_dscenario_conduit
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('CONDUIT');

CREATE TRIGGER gw_trg_edit_inp_arc_conduit INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_conduit
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_arc('inp_conduit');

CREATE TRIGGER gw_trg_edit_pol_gully INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_pol_gully
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_man_gully_pol();

CREATE TRIGGER gw_trg_edit_link INSTEAD OF INSERT OR UPDATE OR DELETE ON v_edit_link
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_link();

CREATE TRIGGER gw_trg_edit_dma INSTEAD OF INSERT OR UPDATE OR DELETE ON v_edit_dma
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_dma('dma');

CREATE trigger gw_trg_edit_drainzone INSTEAD OF INSERT OR UPDATE OR DELETE ON v_edit_drainzone
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_drainzone('EDIT');

CREATE trigger gw_trg_edit_sector INSTEAD OF INSERT OR UPDATE OR DELETE ON v_edit_sector
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_sector('EDIT');

CREATE TRIGGER gw_trg_v_edit_dwfzone INSTEAD OF INSERT OR DELETE OR UPDATE
ON v_edit_dwfzone FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_dwfzone('EDIT');

CREATE TRIGGER gw_trg_edit_review_gully INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_review_gully
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_review_gully();

CREATE TRIGGER gw_trg_edit_review_connec INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_review_connec
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_review_connec();

-- 30/10/2024
DROP TRIGGER IF EXISTS gw_trg_typevalue_fk ON arc;
CREATE TRIGGER gw_trg_typevalue_fk AFTER INSERT OR UPDATE OF verified, function_type, category_type, fluid_type, location_type
ON arc FOR EACH ROW EXECUTE FUNCTION gw_trg_typevalue_fk('arc');

DROP TRIGGER IF EXISTS gw_trg_typevalue_fk ON node;
CREATE TRIGGER gw_trg_typevalue_fk AFTER INSERT OR UPDATE OF verified, function_type, category_type, fluid_type, location_type
ON node FOR EACH ROW EXECUTE FUNCTION gw_trg_typevalue_fk('node');

DROP TRIGGER IF EXISTS gw_trg_typevalue_fk ON connec;
CREATE TRIGGER gw_trg_typevalue_fk AFTER INSERT OR UPDATE OF verified, function_type, category_type, fluid_type, location_type
ON connec FOR EACH ROW EXECUTE FUNCTION gw_trg_typevalue_fk('connec');

DROP TRIGGER IF EXISTS gw_trg_typevalue_fk ON gully;
CREATE TRIGGER gw_trg_typevalue_fk AFTER INSERT OR UPDATE OF verified, units_placement, function_type, category_type, fluid_type, location_type
ON gully FOR EACH ROW EXECUTE FUNCTION gw_trg_typevalue_fk('gully');

-- 14/11/2024
CREATE TRIGGER gw_trg_edit_inp_dscenario INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_dscenario_lids
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('LIDS');

-- 19/11/2024
CREATE TRIGGER gw_trg_mantypevalue_fk_insert AFTER
INSERT
    ON
    gully FOR EACH ROW EXECUTE FUNCTION gw_trg_mantypevalue_fk('gully');
CREATE TRIGGER gw_trg_mantypevalue_fk_update AFTER
UPDATE
    OF function_type,
    category_type,
    fluid_type,
    location_type ON
    gully FOR EACH ROW
    WHEN (((old.function_type)::TEXT IS DISTINCT FROM (new.function_type)::TEXT)
    OR ((OLD.category_type)::TEXT IS DISTINCT FROM (NEW.category_type)::TEXT)
    OR ((OLD.fluid_type)::TEXT IS DISTINCT FROM (NEW.fluid_type)::TEXT)
    OR ((OLD.location_type)::TEXT IS DISTINCT FROM (NEW.location_type)::TEXT))
    EXECUTE FUNCTION gw_trg_mantypevalue_fk('gully');

-- 02/12/2024
CREATE TRIGGER gw_trg_edit_ve_epa_orifice INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_epa_orifice FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_ve_epa('orifice');

-- 04/12/2024
CREATE TRIGGER gw_trg_edit_inp_dwf INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_cat_dwf
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dwf('cat_dwf');

-- 09/12/2024
CREATE TRIGGER gw_trg_edit_ve_epa_storage INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_epa_storage
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_ve_epa('storage');

-- 12/12/2024
CREATE TRIGGER gw_trg_cat_material_fk_insert AFTER INSERT ON cat_gully
FOR EACH ROW EXECUTE FUNCTION gw_trg_cat_material_fk('gully');

CREATE TRIGGER gw_trg_cat_material_fk_update AFTER UPDATE OF matcat_id ON cat_gully
FOR EACH ROW WHEN (((old.matcat_id)::TEXT IS DISTINCT FROM (new.matcat_id)::TEXT)) EXECUTE FUNCTION gw_trg_cat_material_fk('gully');

CREATE TRIGGER gw_trg_cat_material_fk_insert AFTER INSERT ON arc
FOR EACH ROW EXECUTE FUNCTION gw_trg_cat_material_fk('arc');
CREATE TRIGGER gw_trg_cat_material_fk_update AFTER UPDATE OF matcat_id ON arc
FOR EACH ROW WHEN (((old.matcat_id)::TEXT IS DISTINCT FROM (new.matcat_id)::TEXT)) EXECUTE FUNCTION gw_trg_cat_material_fk('arc');

CREATE TRIGGER gw_trg_cat_material_fk_insert AFTER INSERT ON node
FOR EACH ROW EXECUTE FUNCTION gw_trg_cat_material_fk('node');
CREATE TRIGGER gw_trg_cat_material_fk_update AFTER UPDATE OF matcat_id ON node
FOR EACH ROW WHEN (((old.matcat_id)::TEXT IS DISTINCT FROM (new.matcat_id)::TEXT)) EXECUTE FUNCTION gw_trg_cat_material_fk('node');

CREATE TRIGGER gw_trg_cat_material_fk_insert AFTER INSERT ON connec
FOR EACH ROW EXECUTE FUNCTION gw_trg_cat_material_fk('connec');
CREATE TRIGGER gw_trg_cat_material_fk_update AFTER UPDATE OF matcat_id ON connec
FOR EACH ROW WHEN (((old.matcat_id)::TEXT IS DISTINCT FROM (new.matcat_id)::TEXT)) EXECUTE FUNCTION gw_trg_cat_material_fk('connec');

CREATE TRIGGER gw_trg_cat_material_fk_insert AFTER INSERT ON gully
FOR EACH ROW EXECUTE FUNCTION gw_trg_cat_material_fk('gully');

CREATE TRIGGER gw_trg_cat_material_fk_update AFTER UPDATE OF matcat_id ON gully
FOR EACH ROW WHEN (((old.matcat_id)::TEXT IS DISTINCT FROM (new.matcat_id)::TEXT)) EXECUTE FUNCTION gw_trg_cat_material_fk('gully');

CREATE TRIGGER gw_trg_vi_xsections INSTEAD OF INSERT OR DELETE OR UPDATE ON vi_options
FOR EACH ROW EXECUTE FUNCTION gw_trg_vi('vi_options');

CREATE TRIGGER gw_trg_vi_xsections INSTEAD OF INSERT OR DELETE OR UPDATE ON vi_report
FOR EACH ROW EXECUTE FUNCTION gw_trg_vi('vi_report');

CREATE TRIGGER gw_trg_vi_timeseries INSTEAD OF INSERT OR DELETE OR UPDATE ON vi_timeseries
FOR EACH ROW EXECUTE FUNCTION gw_trg_vi('vi_timeseries');

CREATE TRIGGER gw_trg_edit_inp_coverage INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_coverage
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_coverage();

CREATE TRIGGER gw_trg_vi_dwf INSTEAD OF INSERT OR DELETE OR UPDATE ON vi_dwf
FOR EACH ROW EXECUTE FUNCTION gw_trg_vi('vi_dwf');

CREATE TRIGGER gw_trg_edit_inp_subcatchment INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_subcatchment
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_subcatchment('subcatchment');

CREATE TRIGGER gw_trg_vi_gwf INSTEAD OF INSERT OR DELETE OR UPDATE ON vi_gwf
FOR EACH ROW EXECUTE FUNCTION gw_trg_vi('vi_gwf');

CREATE TRIGGER gw_trg_vi_lid_usage INSTEAD OF INSERT OR DELETE OR UPDATE ON vi_lid_usage
FOR EACH ROW EXECUTE FUNCTION gw_trg_vi('vi_lid_usage');

CREATE TRIGGER gw_trg_vi_subareas INSTEAD OF INSERT OR DELETE OR UPDATE ON vi_subareas
FOR EACH ROW EXECUTE FUNCTION gw_trg_vi('vi_subareas');

CREATE TRIGGER gw_trg_edit_inp_subc2outlet INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_subc2outlet
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_subc2outlet();

CREATE TRIGGER gw_trg_vi_loadings INSTEAD OF INSERT OR DELETE OR UPDATE ON vi_loadings
FOR EACH ROW EXECUTE FUNCTION gw_trg_vi('vi_loadings');

CREATE TRIGGER gw_trg_edit_inp_timeseries INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_timeseries
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_timeseries('inp_timeseries');

CREATE TRIGGER gw_trg_edit_inp_timeseries INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_timeseries_value
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_timeseries('inp_timeseries_value');

--10/01/2025
--28/01/2025


CREATE TRIGGER gw_trg_edit_ve_epa_junction INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_epa_junction
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_ve_epa('junction');

CREATE TRIGGER gw_trg_edit_ve_epa_pump INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_epa_pump
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_ve_epa('pump');


-- CREATE TRIGGER for cat_feature_flwreg
CREATE TRIGGER gw_trg_edit_cat_feature INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_cat_feature_flwreg
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_cat_feature('flwreg');

--CREATE TRIGGER for parent view by passing parameter 'parent'
CREATE TRIGGER gw_trg_edit_flwreg INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_flwreg
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_flwreg('parent');

CREATE TRIGGER gw_trg_flw_regulator BEFORE INSERT OR UPDATE ON inp_flwreg_orifice FOR EACH ROW EXECUTE FUNCTION gw_trg_flw_regulator('orifice');

CREATE TRIGGER gw_trg_flw_regulator BEFORE INSERT OR UPDATE ON inp_flwreg_weir
FOR EACH ROW EXECUTE FUNCTION gw_trg_flw_regulator('weir');

CREATE TRIGGER gw_trg_typevalue_fk_insert AFTER INSERT ON inp_flwreg_weir
FOR EACH ROW EXECUTE FUNCTION gw_trg_typevalue_fk('inp_flwreg_weir');

CREATE TRIGGER gw_trg_typevalue_fk_update AFTER UPDATE of weir_type, flap on inp_flwreg_weir
FOR EACH ROW WHEN (((old.weir_type)::TEXT IS DISTINCT FROM (new.weir_type)::text OR ((old.flap)::TEXT IS DISTINCT FROM (new.flap)::text))) EXECUTE FUNCTION gw_trg_typevalue_fk('inp_flwreg_weir');


CREATE TRIGGER gw_trg_flw_regulator BEFORE INSERT OR UPDATE ON inp_flwreg_pump
FOR EACH ROW EXECUTE FUNCTION gw_trg_flw_regulator('pump');

CREATE TRIGGER gw_trg_typevalue_fk_insert AFTER INSERT ON inp_flwreg_pump
FOR EACH ROW EXECUTE FUNCTION gw_trg_typevalue_fk('inp_flwreg_pump');

CREATE TRIGGER gw_trg_typevalue_fk_update AFTER UPDATE of status ON inp_flwreg_pump
FOR EACH ROW WHEN (((old.status)::TEXT IS DISTINCT FROM (new.status)::text)) EXECUTE FUNCTION gw_trg_typevalue_fk('inp_flwreg_pump');


--CREATE TRIGGER gw_trg_flw_regulator BEFORE INSERT OR UPDATE ON inp_flwreg_orifice
--FOR EACH ROW EXECUTE FUNCTION gw_trg_flw_regulator('orifice');


CREATE TRIGGER gw_trg_flw_regulator BEFORE INSERT OR UPDATE ON inp_flwreg_outlet
FOR EACH ROW EXECUTE FUNCTION gw_trg_flw_regulator('outlet');

CREATE TRIGGER gw_trg_typevalue_fk_insert AFTER INSERT ON inp_flwreg_outlet
FOR EACH ROW EXECUTE FUNCTION gw_trg_typevalue_fk('inp_flwreg_outlet');

CREATE TRIGGER gw_trg_typevalue_fk_update AFTER UPDATE of outlet_type, flap on inp_flwreg_outlet
FOR EACH ROW WHEN ((((old.outlet_type)::TEXT IS DISTINCT FROM (new.outlet_type)::text) or ((old.flap)::TEXT IS DISTINCT FROM (new.flap)::text))) EXECUTE FUNCTION gw_trg_typevalue_fk('inp_flwreg_outlet');

CREATE trigger gw_trg_v_ui_drainzone INSTEAD OF INSERT OR UPDATE OR DELETE ON v_ui_drainzone
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_drainzone('UI');

CREATE trigger gw_trg_v_ui_sector INSTEAD OF INSERT OR UPDATE OR DELETE ON v_ui_sector
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_sector('UI');

CREATE trigger gw_trg_v_ui_macrosector INSTEAD OF INSERT OR UPDATE OR DELETE ON v_ui_macrosector
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_macrosector('UI');

CREATE trigger gw_trg_v_ui_dwfzone INSTEAD OF INSERT OR UPDATE OR DELETE ON v_ui_dwfzone
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_dwfzone('UI');

-- delete duplicated triggers
DROP TRIGGER IF EXISTS gw_trg_edit_macrosector ON v_edit_macrosector;
DROP TRIGGER IF EXISTS gw_trg_edit_macrodma ON v_edit_macrodma;

CREATE TRIGGER gw_trg_v_edit_macrodma INSTEAD OF INSERT OR DELETE OR UPDATE
ON v_edit_macrodma
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_macrodma('EDIT');

CREATE TRIGGER gw_trg_v_edit_macrosector INSTEAD OF INSERT OR DELETE OR UPDATE
ON v_edit_macrosector
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_macrosector('EDIT');

CREATE TRIGGER gw_trg_edit_review_node instead OF INSERT OR DELETE OR UPDATE
ON v_edit_review_node FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_review_node();
CREATE TRIGGER gw_trg_typevalue_fk_insert AFTER INSERT
ON dwfzone FOR EACH ROW EXECUTE FUNCTION gw_trg_typevalue_fk('dwfzone');

CREATE TRIGGER gw_trg_typevalue_fk_update AFTER UPDATE OF dwfzone_type
ON dwfzone FOR EACH ROW WHEN (((old.dwfzone_type)::TEXT IS DISTINCT
FROM (new.dwfzone_type)::TEXT)) EXECUTE FUNCTION gw_trg_typevalue_fk('dwfzone');

-- 10/02/2025
CREATE TRIGGER gw_trg_ui_doc_x_arc INSTEAD OF INSERT OR DELETE OR UPDATE ON v_ui_doc_x_arc
FOR EACH ROW EXECUTE FUNCTION gw_trg_ui_doc('doc_x_arc');

CREATE TRIGGER gw_trg_ui_doc_x_connec INSTEAD OF INSERT OR DELETE OR UPDATE ON v_ui_doc_x_connec
FOR EACH ROW EXECUTE FUNCTION gw_trg_ui_doc('doc_x_connec');

CREATE TRIGGER gw_trg_ui_doc_x_gully INSTEAD OF INSERT OR DELETE OR UPDATE ON v_ui_doc_x_gully
FOR EACH ROW EXECUTE FUNCTION gw_trg_ui_doc('doc_x_gully');

CREATE TRIGGER gw_trg_ui_doc_x_node INSTEAD OF INSERT OR DELETE OR UPDATE ON v_ui_doc_x_node
FOR EACH ROW EXECUTE FUNCTION gw_trg_ui_doc('doc_x_node');

CREATE TRIGGER gw_trg_ui_doc_x_visit INSTEAD OF INSERT OR DELETE OR UPDATE ON v_ui_doc_x_visit
FOR EACH ROW EXECUTE FUNCTION gw_trg_ui_doc('doc_x_visit');