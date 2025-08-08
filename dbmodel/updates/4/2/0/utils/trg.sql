/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

CREATE TRIGGER gw_trg_edit_frelem_x_node BEFORE INSERT ON element_x_node
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_frelem_x_node();

CREATE TRIGGER gw_trg_edit_municipality INSTEAD OF INSERT OR DELETE OR UPDATE ON v_ext_municipality
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_municipality();

CREATE TRIGGER gw_trg_ui_rpt_cat_result INSTEAD OF INSERT OR DELETE OR UPDATE ON v_ui_rpt_cat_result
FOR EACH ROW EXECUTE FUNCTION gw_trg_ui_rpt_cat_result();

-- 05/08/2025
-- PSECTOR
CREATE TRIGGER gw_trg_edit_psector INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_plan_psector
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_psector('plan');

CREATE TRIGGER gw_trg_ui_plan_psector INSTEAD OF INSERT OR DELETE OR UPDATE ON v_ui_plan_psector
FOR EACH ROW EXECUTE FUNCTION gw_trg_ui_plan_psector();

-- 08/08/2025
CREATE TRIGGER gw_trg_plan_psector_after_node AFTER INSERT ON node
FOR EACH ROW
WHEN (NEW.state = 2)
EXECUTE FUNCTION gw_trg_insert_psector_x_feature('node');

CREATE TRIGGER gw_trg_plan_psector_after_arc AFTER INSERT ON arc
FOR EACH ROW
WHEN (NEW.state = 2)
EXECUTE FUNCTION gw_trg_insert_psector_x_feature('arc');

CREATE TRIGGER gw_trg_plan_psector_after_connec AFTER INSERT ON connec
FOR EACH ROW
WHEN (NEW.state = 2)
EXECUTE FUNCTION gw_trg_insert_psector_x_feature('connec');
