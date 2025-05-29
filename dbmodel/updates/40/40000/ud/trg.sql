/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;

-- MAPZONES
CREATE TRIGGER gw_trg_edit_controls BEFORE DELETE OR UPDATE ON omzone
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_controls('omzone_id');

CREATE TRIGGER gw_trg_typevalue_fk_insert AFTER INSERT ON omzone
FOR EACH ROW EXECUTE FUNCTION gw_trg_typevalue_fk('omzone');

CREATE TRIGGER gw_trg_typevalue_fk_update AFTER UPDATE OF omzone_type ON omzone
FOR EACH ROW WHEN (((old.omzone_type)::TEXT IS DISTINCT FROM (new.omzone_type)::TEXT)) EXECUTE FUNCTION gw_trg_typevalue_fk('omzone');


CREATE TRIGGER gw_trg_edit_controls BEFORE DELETE OR UPDATE ON drainzone
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_controls('drainzone_id');

CREATE TRIGGER gw_trg_typevalue_fk_insert AFTER INSERT ON drainzone
FOR EACH ROW EXECUTE FUNCTION gw_trg_typevalue_fk('drainzone');

CREATE TRIGGER gw_trg_typevalue_fk_update AFTER UPDATE OF drainzone_type ON drainzone
FOR EACH ROW WHEN (((old.drainzone_type)::TEXT IS DISTINCT FROM (new.drainzone_type)::TEXT)) EXECUTE FUNCTION gw_trg_typevalue_fk('drainzone');


CREATE TRIGGER gw_trg_edit_controls BEFORE DELETE OR UPDATE ON sector
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_controls('sector_id');

CREATE TRIGGER gw_trg_typevalue_fk_insert AFTER INSERT ON sector
FOR EACH ROW EXECUTE FUNCTION gw_trg_typevalue_fk('sector');

CREATE TRIGGER gw_trg_typevalue_fk_update AFTER UPDATE OF sector_type ON sector
FOR EACH ROW WHEN (((old.sector_type)::TEXT IS DISTINCT FROM (new.sector_type)::TEXT)) EXECUTE FUNCTION gw_trg_typevalue_fk('sector');


CREATE TRIGGER gw_trg_edit_controls BEFORE DELETE OR UPDATE ON macroomzone
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_controls('macroomzone_id');


CREATE TRIGGER gw_trg_edit_controls BEFORE DELETE OR UPDATE ON macrosector
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_controls('macrosector_id');

DROP TRIGGER IF EXISTS gw_trg_edit_element ON inp_frweir;
DROP TRIGGER IF EXISTS gw_trg_edit_element ON inp_frorifice;
DROP TRIGGER IF EXISTS gw_trg_edit_element ON inp_froutlet;
DROP TRIGGER IF EXISTS gw_trg_edit_element ON inp_frpump;

CREATE TRIGGER gw_trg_visit_event_update_xy AFTER INSERT OR UPDATE OF position_id, position_value ON om_visit_event
FOR EACH ROW EXECUTE FUNCTION gw_trg_visit_event_update_xy();

CREATE TRIGGER gw_trg_plan_psector_x_node BEFORE
INSERT
    OR
UPDATE
    OF node_id,
    state ON
    plan_psector_x_node FOR EACH ROW EXECUTE FUNCTION gw_trg_plan_psector_x_node();