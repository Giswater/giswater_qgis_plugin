/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

CREATE TRIGGER gw_trg_edit_inp_dscenario_pattern INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_inp_dscenario_pattern 
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('PATTERN');

CREATE TRIGGER gw_trg_edit_inp_dscenario_pattern_value INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_inp_dscenario_pattern_value 
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('PATTERN_VALUE');

CREATE TRIGGER gw_trg_edit_inp_dscenario_demand INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_inp_dscenario_demand 
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario_demand();

CREATE TRIGGER gw_trg_dscenario_demand_feature AFTER INSERT ON inp_dscenario_demand
FOR EACH ROW EXECUTE FUNCTION gw_trg_dscenario_demand_feature();
CREATE TRIGGER gw_trg_typevalue_fk AFTER INSERT OR UPDATE ON inp_dscenario_demand
FOR EACH ROW EXECUTE FUNCTION gw_trg_typevalue_fk('inp_dscenario_demand');

CREATE TRIGGER gw_trg_edit_link INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_link 
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_link('LINK');

CREATE TRIGGER gw_trg_edit_inp_dscenario_connec INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_inp_dscenario_connec 
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('CONNEC');

CREATE TRIGGER gw_trg_edit_inp_connec INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_inp_connec 
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_connec();

CREATE TRIGGER gw_trg_edit_connec INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_connec 
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_connec('parent');

-- 02/04/2026
CREATE TRIGGER gw_trg_edit_plan_netscenario INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_plan_netscenario_dma 
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_plan_netscenario('DMA');

CREATE TRIGGER gw_trg_edit_plan_netscenario INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_plan_netscenario_presszone 
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_plan_netscenario('PRESSZONE');

-- 13/04/2026
DROP TRIGGER IF EXISTS gw_trg_fk_array_array_table_expl ON supplyzone;
DROP TRIGGER IF EXISTS gw_trg_fk_array_array_table_muni ON supplyzone;
DROP TRIGGER IF EXISTS gw_trg_fk_array_array_table_expl ON macrodma;
DROP TRIGGER IF EXISTS gw_trg_fk_array_array_table_expl ON macrodqa;


DO $$
DECLARE
    v_utils boolean;
BEGIN

	SELECT value::boolean INTO v_utils FROM config_param_system WHERE parameter='admin_utils_schema';

	IF v_utils IS true THEN
		CREATE TRIGGER gw_trg_fk_array_array_table_muni AFTER INSERT OR UPDATE OF muni_id ON macrodma 
		FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('muni_id', 'utils.municipality', 'muni_id');
		CREATE TRIGGER gw_trg_fk_array_array_table_muni AFTER INSERT OR UPDATE OF muni_id ON dqa 
		FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('muni_id', 'utils.municipality', 'muni_id');
		CREATE TRIGGER gw_trg_fk_array_array_table_muni AFTER INSERT OR UPDATE OF muni_id ON macrodqa 
		FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('muni_id', 'utils.municipality', 'muni_id');
		CREATE TRIGGER gw_trg_fk_array_array_table_muni AFTER INSERT OR UPDATE OF muni_id ON presszone 
		FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('muni_id', 'utils.municipality', 'muni_id');
		CREATE TRIGGER gw_trg_fk_array_array_table_muni AFTER INSERT OR UPDATE OF muni_id ON supplyzone 
		FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('muni_id', 'utils.municipality', 'muni_id');
		CREATE TRIGGER gw_trg_fk_array_array_table_muni AFTER INSERT OR UPDATE OF muni_id ON crmzone 
		FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('muni_id', 'utils.municipality', 'muni_id');
		CREATE TRIGGER gw_trg_fk_array_array_table_muni AFTER INSERT OR UPDATE OF muni_id ON plan_netscenario_dma 
		FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('muni_id', 'utils.municipality', 'muni_id');
		CREATE TRIGGER gw_trg_fk_array_array_table_muni AFTER INSERT OR UPDATE OF muni_id ON plan_netscenario_presszone 
		FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('muni_id', 'utils.municipality', 'muni_id');
    ELSE
		CREATE TRIGGER gw_trg_fk_array_array_table_muni AFTER INSERT OR UPDATE OF muni_id ON macrodma 
		FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('muni_id', 'ext_municipality', 'muni_id');
		CREATE TRIGGER gw_trg_fk_array_array_table_muni AFTER INSERT OR UPDATE OF muni_id ON dqa 
		FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('muni_id', 'ext_municipality', 'muni_id');
        CREATE TRIGGER gw_trg_fk_array_array_table_muni AFTER INSERT OR UPDATE OF muni_id ON macrodqa 
		FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('muni_id', 'ext_municipality', 'muni_id');
		CREATE TRIGGER gw_trg_fk_array_array_table_muni AFTER INSERT OR UPDATE OF muni_id ON presszone 
		FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('muni_id', 'ext_municipality', 'muni_id');
		CREATE TRIGGER gw_trg_fk_array_array_table_muni AFTER INSERT OR UPDATE OF muni_id ON supplyzone 
		FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('muni_id', 'ext_municipality', 'muni_id');
		CREATE TRIGGER gw_trg_fk_array_array_table_muni AFTER INSERT OR UPDATE OF muni_id ON crmzone 
		FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('muni_id', 'ext_municipality', 'muni_id');
		CREATE TRIGGER gw_trg_fk_array_array_table_muni AFTER INSERT OR UPDATE OF muni_id ON plan_netscenario_dma 
		FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('muni_id', 'ext_municipality', 'muni_id');
		CREATE TRIGGER gw_trg_fk_array_array_table_muni AFTER INSERT OR UPDATE OF muni_id ON plan_netscenario_presszone 
		FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('muni_id', 'ext_municipality', 'muni_id');
    END IF;

	CREATE TRIGGER gw_trg_fk_array_array_table_expl AFTER INSERT OR UPDATE OF expl_id ON macrodma 
	FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('expl_id', 'exploitation', 'expl_id');
	CREATE TRIGGER gw_trg_fk_array_array_table_sector AFTER INSERT OR UPDATE OF sector_id ON macrodma 
	FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('sector_id', 'sector', 'sector_id');

	CREATE TRIGGER gw_trg_fk_array_array_table_expl AFTER INSERT OR UPDATE OF expl_id ON dqa 
	FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('expl_id', 'exploitation', 'expl_id');
	CREATE TRIGGER gw_trg_fk_array_array_table_sector AFTER INSERT OR UPDATE OF sector_id ON dqa 
	FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('sector_id', 'sector', 'sector_id');

    CREATE TRIGGER gw_trg_fk_array_array_table_expl AFTER INSERT OR UPDATE OF expl_id ON macrodqa 
	FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('expl_id', 'exploitation', 'expl_id');
	CREATE TRIGGER gw_trg_fk_array_array_table_sector AFTER INSERT OR UPDATE OF sector_id ON macrodqa 
	FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('sector_id', 'sector', 'sector_id');

    CREATE TRIGGER gw_trg_fk_array_array_table_expl AFTER INSERT OR UPDATE OF expl_id ON presszone 
	FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('expl_id', 'exploitation', 'expl_id');
	CREATE TRIGGER gw_trg_fk_array_array_table_sector AFTER INSERT OR UPDATE OF sector_id ON presszone 
	FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('sector_id', 'sector', 'sector_id');

    CREATE TRIGGER gw_trg_fk_array_array_table_expl AFTER INSERT OR UPDATE OF expl_id ON supplyzone 
	FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('expl_id', 'exploitation', 'expl_id');
	CREATE TRIGGER gw_trg_fk_array_array_table_sector AFTER INSERT OR UPDATE OF sector_id ON supplyzone 
	FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('sector_id', 'sector', 'sector_id');

    CREATE TRIGGER gw_trg_fk_array_array_table_expl AFTER INSERT OR UPDATE OF expl_id ON crmzone 
	FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('expl_id', 'exploitation', 'expl_id');
	CREATE TRIGGER gw_trg_fk_array_array_table_sector AFTER INSERT OR UPDATE OF sector_id ON crmzone 
	FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('sector_id', 'sector', 'sector_id');

    CREATE TRIGGER gw_trg_fk_array_array_table_expl AFTER INSERT OR UPDATE OF expl_id ON plan_netscenario_dma 
	FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('expl_id', 'exploitation', 'expl_id');
	CREATE TRIGGER gw_trg_fk_array_array_table_sector AFTER INSERT OR UPDATE OF sector_id ON plan_netscenario_dma 
	FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('sector_id', 'sector', 'sector_id');

    CREATE TRIGGER gw_trg_fk_array_array_table_expl AFTER INSERT OR UPDATE OF expl_id ON plan_netscenario_presszone 
	FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('expl_id', 'exploitation', 'expl_id');
	CREATE TRIGGER gw_trg_fk_array_array_table_sector AFTER INSERT OR UPDATE OF sector_id ON plan_netscenario_presszone 
	FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('sector_id', 'sector', 'sector_id');
END; $$;