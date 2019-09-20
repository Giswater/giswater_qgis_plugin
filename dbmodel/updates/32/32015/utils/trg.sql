/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

 
CREATE TRIGGER gw_trg_plan_psector_x_connec BEFORE INSERT OR UPDATE OF connec_id ON plan_psector_x_connec 
FOR EACH ROW EXECUTE PROCEDURE gw_trg_plan_psector_x_connec();

CREATE TRIGGER gw_trg_plan_psector_link AFTER INSERT OR UPDATE OF arc_id ON plan_psector_x_connec 
FOR EACH ROW EXECUTE PROCEDURE gw_trg_plan_psector_link('connec');

CREATE TRIGGER gw_trg_plan_psector_x_connec_geom AFTER INSERT OR UPDATE OR DELETE ON plan_psector_x_connec
FOR EACH ROW EXECUTE PROCEDURE gw_trg_plan_psector_geom('plan');


--28/06/2019
CREATE TRIGGER gw_trg_ui_event_x_arc INSTEAD OF INSERT OR UPDATE OR DELETE ON v_ui_event_x_arc
FOR EACH ROW EXECUTE PROCEDURE gw_trg_ui_event('om_visit_event');


CREATE TRIGGER gw_trg_ui_event_x_connec INSTEAD OF INSERT OR UPDATE OR DELETE ON v_ui_event_x_connec
FOR EACH ROW EXECUTE PROCEDURE gw_trg_ui_event('om_visit_event');


CREATE TRIGGER gw_trg_ui_event_x_node INSTEAD OF INSERT OR UPDATE OR DELETE ON v_ui_event_x_node
FOR EACH ROW EXECUTE PROCEDURE gw_trg_ui_event('om_visit_event');

-- DROP TRIGGER gw_trg_man_addfields_value_arc_control ON SCHEMA_NAME.arc;

DROP TRIGGER IF EXISTS gw_trg_man_addfields_value_arc_control ON arc;
DROP TRIGGER IF EXISTS gw_trg_man_addfields_value_node_control ON node;
DROP TRIGGER IF EXISTS gw_trg_man_addfields_value_connec_control ON connec;

CREATE TRIGGER gw_trg_edit_foreignkey AFTER UPDATE OF arc_id OR DELETE ON arc
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_foreignkey('arc_id');

CREATE TRIGGER gw_trg_edit_foreignkey AFTER UPDATE OF node_id OR DELETE ON node
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_foreignkey('node_id');

CREATE TRIGGER gw_trg_edit_foreignkey AFTER UPDATE OF connec_id OR DELETE ON connec
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_foreignkey('connec_id');


--01/07/2019
CREATE TRIGGER gw_trg_edit_rtc_hydro_data INSTEAD OF UPDATE ON v_ui_hydroval_x_connec
FOR EACH ROW EXECUTE PROCEDURE gw_trg_ui_hydroval_connec();