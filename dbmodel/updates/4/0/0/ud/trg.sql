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


-- Create fk for arrays thorught triggers:
DO $$
DECLARE
    v_utils boolean;
BEGIN

	SELECT value::boolean INTO v_utils FROM config_param_system WHERE parameter='admin_utils_schema';

	IF v_utils IS true THEN

        -- Expl_id 
        CREATE TRIGGER gw_trg_fk_array_id_table BEFORE DELETE ON exploitation
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_id_table('expl_id', '{"macroomzone":"expl_id", "dwfzone":"expl_id", "drainzone":"expl_id", "sector":"expl_id", "utils.municipality":"expl_id"}');

        CREATE TRIGGER gw_trg_fk_array_id_table_update AFTER UPDATE ON exploitation
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_id_table('expl_id', '{"macroomzone":"expl_id", "dwfzone":"expl_id", "drainzone":"expl_id", "sector":"expl_id", "utils.municipality":"expl_id"}');

        CREATE TRIGGER gw_trg_fk_array_array_table_expl AFTER INSERT OR UPDATE ON macroomzone
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('expl_id', 'exploitation', 'expl_id');

        CREATE TRIGGER gw_trg_fk_array_array_table_expl AFTER INSERT OR UPDATE ON dwfzone
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('expl_id', 'exploitation', 'expl_id');

        CREATE TRIGGER gw_trg_fk_array_array_table_expl AFTER INSERT OR UPDATE ON drainzone
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('expl_id', 'exploitation', 'expl_id');

        CREATE TRIGGER gw_trg_fk_array_array_table_expl AFTER INSERT OR UPDATE ON sector
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('expl_id', 'exploitation', 'expl_id');

        CREATE TRIGGER gw_trg_fk_array_array_table_expl AFTER INSERT OR UPDATE ON utils.municipality
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('expl_id', 'exploitation', 'expl_id');

        -- Muni_id
        CREATE TRIGGER gw_trg_fk_array_id_table BEFORE DELETE ON utils.municipality
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_id_table('muni_id', '{"dwfzone":"muni_id", "drainzone":"muni_id", "exploitation":"muni_id", "sector":"muni_id"}');

        CREATE TRIGGER gw_trg_fk_array_id_table_update AFTER UPDATE ON utils.municipality
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_id_table('muni_id', '{"dwfzone":"muni_id", "drainzone":"muni_id", "exploitation":"muni_id", "sector":"muni_id"}');

        CREATE TRIGGER gw_trg_fk_array_array_table_muni AFTER INSERT OR UPDATE ON dwfzone
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('muni_id', 'utils.municipality', 'muni_id');

        CREATE TRIGGER gw_trg_fk_array_array_table_muni AFTER INSERT OR UPDATE ON drainzone
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('muni_id', 'utils.municipality', 'muni_id');

        CREATE TRIGGER gw_trg_fk_array_array_table_muni AFTER INSERT OR UPDATE ON exploitation
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('muni_id', 'utils.municipality', 'muni_id');

        CREATE TRIGGER gw_trg_fk_array_array_table_muni AFTER INSERT OR UPDATE ON sector
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('muni_id', 'utils.municipality', 'muni_id');

        -- Sector_id
        CREATE TRIGGER gw_trg_fk_array_id_table BEFORE DELETE ON sector
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_id_table('sector_id', '{"dwfzone":"sector_id", "drainzone":"sector_id", "exploitation":"sector_id", "utils.municipality":"sector_id"}');

        CREATE TRIGGER gw_trg_fk_array_id_table_update AFTER UPDATE ON sector
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_id_table('sector_id', '{"dwfzone":"sector_id", "drainzone":"sector_id", "exploitation":"sector_id", "utils.municipality":"sector_id"}');

        CREATE TRIGGER gw_trg_fk_array_array_table_sector AFTER INSERT OR UPDATE ON dwfzone
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('sector_id', 'sector', 'sector_id');

        CREATE TRIGGER gw_trg_fk_array_array_table_sector AFTER INSERT OR UPDATE ON drainzone
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('sector_id', 'sector', 'sector_id');

        CREATE TRIGGER gw_trg_fk_array_array_table_sector AFTER INSERT OR UPDATE ON exploitation
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('sector_id', 'sector', 'sector_id');

        CREATE TRIGGER gw_trg_fk_array_array_table_sector AFTER INSERT OR UPDATE ON utils.municipality
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('sector_id', 'sector', 'sector_id');

    ELSE

        -- Expl_id 
        CREATE TRIGGER gw_trg_fk_array_id_table BEFORE DELETE ON exploitation
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_id_table('expl_id', '{"macroomzone":"expl_id", "dwfzone":"expl_id", "drainzone":"expl_id", "sector":"expl_id", "ext_municipality":"expl_id"}');

        CREATE TRIGGER gw_trg_fk_array_id_table_update AFTER UPDATE ON exploitation
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_id_table('expl_id', '{"macroomzone":"expl_id", "dwfzone":"expl_id", "drainzone":"expl_id", "sector":"expl_id", "ext_municipality":"expl_id"}');

        CREATE TRIGGER gw_trg_fk_array_array_table_expl AFTER INSERT OR UPDATE ON macroomzone
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('expl_id', 'exploitation', 'expl_id');

        CREATE TRIGGER gw_trg_fk_array_array_table_expl AFTER INSERT OR UPDATE ON dwfzone
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('expl_id', 'exploitation', 'expl_id');

        CREATE TRIGGER gw_trg_fk_array_array_table_expl AFTER INSERT OR UPDATE ON drainzone
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('expl_id', 'exploitation', 'expl_id');

        CREATE TRIGGER gw_trg_fk_array_array_table_expl AFTER INSERT OR UPDATE ON sector
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('expl_id', 'exploitation', 'expl_id');

        CREATE TRIGGER gw_trg_fk_array_array_table_expl AFTER INSERT OR UPDATE ON ext_municipality
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('expl_id', 'exploitation', 'expl_id');

        -- Muni_id
        CREATE TRIGGER gw_trg_fk_array_id_table BEFORE DELETE ON ext_municipality
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_id_table('muni_id', '{"dwfzone":"muni_id", "drainzone":"muni_id", "exploitation":"muni_id", "sector":"muni_id"}');

        CREATE TRIGGER gw_trg_fk_array_id_table_update AFTER UPDATE ON ext_municipality
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_id_table('muni_id', '{"dwfzone":"muni_id", "drainzone":"muni_id", "exploitation":"muni_id", "sector":"muni_id"}');

        CREATE TRIGGER gw_trg_fk_array_array_table_muni AFTER INSERT OR UPDATE ON dwfzone
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('muni_id', 'ext_municipality', 'muni_id');

        CREATE TRIGGER gw_trg_fk_array_array_table_muni AFTER INSERT OR UPDATE ON drainzone
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('muni_id', 'ext_municipality', 'muni_id');

        CREATE TRIGGER gw_trg_fk_array_array_table_muni AFTER INSERT OR UPDATE ON exploitation
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('muni_id', 'ext_municipality', 'muni_id');

        CREATE TRIGGER gw_trg_fk_array_array_table_muni AFTER INSERT OR UPDATE ON sector
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('muni_id', 'ext_municipality', 'muni_id');

        -- Sector_id
        CREATE TRIGGER gw_trg_fk_array_id_table BEFORE DELETE ON sector
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_id_table('sector_id', '{"dwfzone":"sector_id", "drainzone":"sector_id", "exploitation":"sector_id", "ext_municipality":"sector_id"}');

        CREATE TRIGGER gw_trg_fk_array_id_table_update AFTER UPDATE ON sector
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_id_table('sector_id', '{"dwfzone":"sector_id", "drainzone":"sector_id", "exploitation":"sector_id", "ext_municipality":"sector_id"}');

        CREATE TRIGGER gw_trg_fk_array_array_table_sector AFTER INSERT OR UPDATE ON dwfzone
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('sector_id', 'sector', 'sector_id');

        CREATE TRIGGER gw_trg_fk_array_array_table_sector AFTER INSERT OR UPDATE ON drainzone
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('sector_id', 'sector', 'sector_id');

        CREATE TRIGGER gw_trg_fk_array_array_table_sector AFTER INSERT OR UPDATE ON exploitation
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('sector_id', 'sector', 'sector_id');

        CREATE TRIGGER gw_trg_fk_array_array_table_sector AFTER INSERT OR UPDATE ON ext_municipality
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('sector_id', 'sector', 'sector_id');

    END IF;
END; $$;