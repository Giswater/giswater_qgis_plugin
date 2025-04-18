/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
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

drop trigger if exists gw_trg_edit_element on inp_frweir;
drop trigger if exists gw_trg_edit_element on inp_frorifice;
drop trigger if exists gw_trg_edit_element on inp_froutlet;
drop trigger if exists gw_trg_edit_element on inp_frpump;
