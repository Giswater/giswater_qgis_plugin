/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 31/03/2026
DROP TRIGGER IF EXISTS gw_trg_edit_controls ON node;
DROP TRIGGER IF EXISTS gw_trg_edit_controls ON arc;
DROP TRIGGER IF EXISTS gw_trg_edit_controls ON connec;
DROP TRIGGER IF EXISTS gw_trg_edit_controls ON link;

CREATE TRIGGER gw_trg_edit_controls BEFORE DELETE OR UPDATE
ON node FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_controls('node_id');

CREATE TRIGGER gw_trg_edit_controls BEFORE DELETE OR UPDATE
ON arc FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_controls('arc_id');

CREATE TRIGGER gw_trg_edit_controls BEFORE DELETE OR UPDATE
ON connec FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_controls('connec_id');

CREATE TRIGGER gw_trg_edit_controls BEFORE DELETE OR UPDATE
ON link FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_controls('link_id');

DROP TRIGGER gw_trg_fk_array_array_table_expl ON ext_municipality;
DROP TRIGGER gw_trg_fk_array_array_table_sector ON ext_municipality;

create trigger gw_trg_edit_address instead of insert or delete or update on ve_address for each row execute function gw_trg_edit_address();
create trigger gw_trg_edit_municipality instead of insert or delete or update on ve_municipality for each row execute function gw_trg_edit_municipality();
create trigger gw_trg_edit_plot instead of insert or delete or update on ve_plot for each row execute function gw_trg_edit_plot();
create trigger gw_trg_edit_streetaxis instead of insert or delete or update on ve_streetaxis for each row execute function gw_trg_edit_streetaxis();

-- 10/04/2026
CREATE TRIGGER gw_trg_fk_array_array_table_expl AFTER INSERT OR UPDATE OF expl_visibility ON node
FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('expl_visibility', 'exploitation', 'expl_id');

CREATE TRIGGER gw_trg_fk_array_array_table_expl AFTER INSERT OR UPDATE OF expl_visibility ON arc
FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('expl_visibility', 'exploitation', 'expl_id');

CREATE TRIGGER gw_trg_fk_array_array_table_expl AFTER INSERT OR UPDATE OF expl_visibility ON connec
FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('expl_visibility', 'exploitation', 'expl_id');

CREATE TRIGGER gw_trg_fk_array_array_table_expl AFTER INSERT OR UPDATE OF expl_visibility ON link
FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('expl_visibility', 'exploitation', 'expl_id');

CREATE TRIGGER gw_trg_fk_array_array_table_expl AFTER INSERT OR UPDATE OF expl_visibility ON element
FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('expl_visibility', 'exploitation', 'expl_id');

-- 13/04/2026
DROP TRIGGER IF EXISTS gw_trg_fk_array_array_table_sector ON exploitation;
DROP TRIGGER IF EXISTS gw_trg_fk_array_array_table_muni ON exploitation;
DROP TRIGGER IF EXISTS gw_trg_fk_array_array_table_expl ON sector;
DROP TRIGGER IF EXISTS gw_trg_fk_array_array_table_muni ON sector;
DROP TRIGGER IF EXISTS gw_trg_fk_array_array_table_expl ON macroomzone;
DROP TRIGGER IF EXISTS gw_trg_fk_array_array_table_expl ON omzone;

DO $$
DECLARE
    v_utils boolean;
BEGIN

	SELECT value::boolean INTO v_utils FROM config_param_system WHERE parameter='admin_utils_schema';

	IF v_utils IS true THEN
        CREATE TRIGGER gw_trg_fk_array_array_table_muni AFTER INSERT OR UPDATE OF muni_id ON exploitation 
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('muni_id', 'utils.municipality', 'muni_id');
        CREATE TRIGGER gw_trg_fk_array_array_table_muni AFTER INSERT OR UPDATE OF muni_id ON sector 
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('muni_id', 'utils.municipality', 'muni_id');
        CREATE TRIGGER gw_trg_fk_array_array_table_muni AFTER INSERT OR UPDATE OF muni_id ON macrosector 
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('muni_id', 'utils.municipality', 'muni_id');
        CREATE TRIGGER gw_trg_fk_array_array_table_muni AFTER INSERT OR UPDATE OF muni_id ON dma 
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('muni_id', 'utils.municipality', 'muni_id');
        CREATE TRIGGER gw_trg_fk_array_array_table_muni AFTER INSERT OR UPDATE OF muni_id ON omzone 
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('muni_id', 'utils.municipality', 'muni_id');
        CREATE TRIGGER gw_trg_fk_array_array_table_muni AFTER INSERT OR UPDATE OF muni_id ON macroomzone 
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('muni_id', 'utils.municipality', 'muni_id');
    ELSE
        CREATE TRIGGER gw_trg_fk_array_array_table_muni AFTER INSERT OR UPDATE OF muni_id ON exploitation 
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('muni_id', 'ext_municipality', 'muni_id');
        CREATE TRIGGER gw_trg_fk_array_array_table_muni AFTER INSERT OR UPDATE OF muni_id ON sector 
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('muni_id', 'ext_municipality', 'muni_id');
        CREATE TRIGGER gw_trg_fk_array_array_table_muni AFTER INSERT OR UPDATE OF muni_id ON macrosector 
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('muni_id', 'ext_municipality', 'muni_id');
        CREATE TRIGGER gw_trg_fk_array_array_table_muni AFTER INSERT OR UPDATE OF muni_id ON dma 
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('muni_id', 'ext_municipality', 'muni_id');
        CREATE TRIGGER gw_trg_fk_array_array_table_muni AFTER INSERT OR UPDATE OF muni_id ON omzone 
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('muni_id', 'ext_municipality', 'muni_id');
        CREATE TRIGGER gw_trg_fk_array_array_table_muni AFTER INSERT OR UPDATE OF muni_id ON macroomzone 
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('muni_id', 'ext_municipality', 'muni_id');
    END IF;

    CREATE TRIGGER gw_trg_fk_array_array_table_sector AFTER INSERT OR UPDATE OF sector_id ON exploitation 
    FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('sector_id', 'sector', 'sector_id');

    CREATE TRIGGER gw_trg_fk_array_array_table_expl AFTER INSERT OR UPDATE OF expl_id ON sector 
    FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('expl_id', 'exploitation', 'expl_id');

    CREATE TRIGGER gw_trg_fk_array_array_table_expl AFTER INSERT OR UPDATE OF expl_id ON macrosector 
    FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('expl_id', 'exploitation', 'expl_id');

    CREATE TRIGGER gw_trg_fk_array_array_table_expl AFTER INSERT OR UPDATE OF expl_id ON dma 
	FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('expl_id', 'exploitation', 'expl_id');
	CREATE TRIGGER gw_trg_fk_array_array_table_sector AFTER INSERT OR UPDATE OF sector_id ON dma 
	FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('sector_id', 'sector', 'sector_id');

    CREATE TRIGGER gw_trg_fk_array_array_table_expl AFTER INSERT OR UPDATE OF expl_id ON omzone 
	FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('expl_id', 'exploitation', 'expl_id');
	CREATE TRIGGER gw_trg_fk_array_array_table_sector AFTER INSERT OR UPDATE OF sector_id ON omzone 
	FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('sector_id', 'sector', 'sector_id');

    CREATE TRIGGER gw_trg_fk_array_array_table_expl AFTER INSERT OR UPDATE OF expl_id ON macroomzone 
	FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('expl_id', 'exploitation', 'expl_id');
	CREATE TRIGGER gw_trg_fk_array_array_table_sector AFTER INSERT OR UPDATE OF sector_id ON macroomzone 
	FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('sector_id', 'sector', 'sector_id');
END; $$;



