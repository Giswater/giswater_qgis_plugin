/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--26/07/2024
CREATE TRIGGER gw_trg_ui_rpt_cat_result
INSTEAD OF INSERT OR DELETE OR UPDATE
ON v_ui_rpt_cat_result
FOR EACH ROW EXECUTE FUNCTION gw_trg_ui_rpt_cat_result();

--05/08/2024
CREATE trigger gw_trg_ui_doc_x_gully instead OF
INSERT
    OR
DELETE
    OR
UPDATE
    ON
    v_ui_doc_x_gully FOR each row EXECUTE function gw_trg_ui_doc('doc_x_gully');

--07/08/2024
CREATE TRIGGER gw_trg_edit_element INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_element
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_element('element');

CREATE TRIGGER gw_trg_edit_samplepoint INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_samplepoint
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_samplepoint('samplepoint');

CREATE TRIGGER gw_trg_edit_streetaxis INSTEAD OF INSERT OR DELETE OR UPDATE ON v_ext_streetaxis
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_streetaxis();

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
