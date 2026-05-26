/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;

-- MAPZONES
-- Create fk for arrays thorught triggers:
DO $$
DECLARE
    v_utils boolean;
BEGIN

	SELECT value::boolean INTO v_utils FROM config_param_system WHERE parameter='admin_utils_schema';

	IF v_utils IS true THEN

        -- Expl_id 
        CREATE TRIGGER gw_trg_fk_array_id_table BEFORE DELETE ON exploitation
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_id_table('expl_id', '{"supplyzone":"expl_id", "macrodma":"expl_id", "macrodqa":"expl_id", "macroomzone":"expl_id", "utils.municipality":"expl_id"}');

        CREATE TRIGGER gw_trg_fk_array_id_table_update AFTER UPDATE ON exploitation
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_id_table('expl_id', '{"supplyzone":"expl_id", "macrodma":"expl_id", "macrodqa":"expl_id", "macroomzone":"expl_id", "utils.municipality":"expl_id"}');

        CREATE TRIGGER gw_trg_fk_array_array_table_expl AFTER INSERT OR UPDATE ON supplyzone
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('expl_id', 'exploitation', 'expl_id');

        CREATE TRIGGER gw_trg_fk_array_array_table_expl AFTER INSERT OR UPDATE ON macrodma
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('expl_id', 'exploitation', 'expl_id');

        CREATE TRIGGER gw_trg_fk_array_array_table_expl AFTER INSERT OR UPDATE ON macrodqa
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('expl_id', 'exploitation', 'expl_id');

        CREATE TRIGGER gw_trg_fk_array_array_table_expl AFTER INSERT OR UPDATE ON macroomzone
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('expl_id', 'exploitation', 'expl_id');

        CREATE TRIGGER gw_trg_fk_array_array_table_expl AFTER INSERT OR UPDATE ON utils.municipality
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('expl_id', 'exploitation', 'expl_id');

        -- Muni_id
        CREATE TRIGGER gw_trg_fk_array_id_table BEFORE DELETE ON utils.municipality
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_id_table('muni_id', '{"supplyzone":"muni_id", "exploitation":"muni_id"}');

        CREATE TRIGGER gw_trg_fk_array_id_table_update AFTER UPDATE ON utils.municipality
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_id_table('muni_id', '{"supplyzone":"muni_id", "exploitation":"muni_id"}');

        CREATE TRIGGER gw_trg_fk_array_array_table_muni AFTER INSERT OR UPDATE ON supplyzone
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('muni_id', 'utils.municipality', 'muni_id');

        CREATE TRIGGER gw_trg_fk_array_array_table_muni AFTER INSERT OR UPDATE ON exploitation
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('muni_id', 'utils.municipality', 'muni_id');

        -- Sector_id
        CREATE TRIGGER gw_trg_fk_array_id_table BEFORE DELETE ON sector
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_id_table('sector_id', '{"utils.municipality":"sector_id", "exploitation":"sector_id"}');

        CREATE TRIGGER gw_trg_fk_array_id_table_update AFTER UPDATE ON sector
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_id_table('sector_id', '{"utils.municipality":"sector_id", "exploitation":"sector_id"}');

        CREATE TRIGGER gw_trg_fk_array_array_table_sector AFTER INSERT OR UPDATE ON utils.municipality
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('sector_id', 'sector', 'sector_id');

        CREATE TRIGGER gw_trg_fk_array_array_table_sector AFTER INSERT OR UPDATE ON exploitation
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('sector_id', 'sector', 'sector_id');
    
    ELSE
    
        -- Expl_id 
        CREATE TRIGGER gw_trg_fk_array_id_table BEFORE DELETE ON exploitation
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_id_table('expl_id', '{"supplyzone":"expl_id", "macrodma":"expl_id", "macrodqa":"expl_id", "macroomzone":"expl_id", "ext_municipality":"expl_id"}');

        CREATE TRIGGER gw_trg_fk_array_id_table_update AFTER UPDATE ON exploitation
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_id_table('expl_id', '{"supplyzone":"expl_id", "macrodma":"expl_id", "macrodqa":"expl_id", "macroomzone":"expl_id", "ext_municipality":"expl_id"}');

        CREATE TRIGGER gw_trg_fk_array_array_table_expl AFTER INSERT OR UPDATE ON supplyzone
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('expl_id', 'exploitation', 'expl_id');

        CREATE TRIGGER gw_trg_fk_array_array_table_expl AFTER INSERT OR UPDATE ON macrodma
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('expl_id', 'exploitation', 'expl_id');

        CREATE TRIGGER gw_trg_fk_array_array_table_expl AFTER INSERT OR UPDATE ON macrodqa
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('expl_id', 'exploitation', 'expl_id');

        CREATE TRIGGER gw_trg_fk_array_array_table_expl AFTER INSERT OR UPDATE ON macroomzone
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('expl_id', 'exploitation', 'expl_id');

        CREATE TRIGGER gw_trg_fk_array_array_table_expl AFTER INSERT OR UPDATE ON ext_municipality
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('expl_id', 'exploitation', 'expl_id');

        -- Muni_id
        CREATE TRIGGER gw_trg_fk_array_id_table BEFORE DELETE ON ext_municipality
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_id_table('muni_id', '{"supplyzone":"muni_id", "exploitation":"muni_id"}');

        CREATE TRIGGER gw_trg_fk_array_id_table_update AFTER UPDATE ON ext_municipality
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_id_table('muni_id', '{"supplyzone":"muni_id", "exploitation":"muni_id"}');

        CREATE TRIGGER gw_trg_fk_array_array_table_muni AFTER INSERT OR UPDATE ON supplyzone
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('muni_id', 'ext_municipality', 'muni_id');

        CREATE TRIGGER gw_trg_fk_array_array_table_muni AFTER INSERT OR UPDATE ON exploitation
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('muni_id', 'ext_municipality', 'muni_id');

        -- Sector_id
        CREATE TRIGGER gw_trg_fk_array_id_table BEFORE DELETE ON sector
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_id_table('sector_id', '{"ext_municipality":"sector_id", "exploitation":"sector_id"}');

        CREATE TRIGGER gw_trg_fk_array_id_table_update AFTER UPDATE ON sector
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_id_table('sector_id', '{"ext_municipality":"sector_id", "exploitation":"sector_id"}');

        CREATE TRIGGER gw_trg_fk_array_array_table_sector AFTER INSERT OR UPDATE ON ext_municipality
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('sector_id', 'sector', 'sector_id');

        CREATE TRIGGER gw_trg_fk_array_array_table_sector AFTER INSERT OR UPDATE ON exploitation
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('sector_id', 'sector', 'sector_id');

    END IF;
END; $$;