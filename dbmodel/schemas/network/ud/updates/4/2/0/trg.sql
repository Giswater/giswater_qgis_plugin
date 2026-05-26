/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


CREATE TRIGGER gw_trg_typevalue_fk_insert AFTER INSERT ON inp_gully
FOR EACH ROW EXECUTE FUNCTION gw_trg_typevalue_fk('inp_gully');

CREATE TRIGGER gw_trg_typevalue_fk_update AFTER UPDATE ON inp_gully
FOR EACH ROW EXECUTE FUNCTION gw_trg_typevalue_fk('inp_gully');

CREATE TRIGGER gw_trg_edit_inp_dscenario INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_inp_dscenario_inlet
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('INLET');

CREATE TRIGGER gw_trg_edit_ve_epa_inlet INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_epa_inlet
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_ve_epa('inlet');

CREATE TRIGGER gw_trg_edit_inp_node_inlet INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_inp_inlet
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_node('inp_inlet');

CREATE TRIGGER gw_trg_edit_gully INSTEAD OF INSERT OR DELETE OR UPDATE ON
ve_gully FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_gully('parent');

CREATE TRIGGER gw_trg_edit_connec INSTEAD OF INSERT OR DELETE OR UPDATE ON
ve_connec FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_connec('parent');

CREATE TRIGGER gw_trg_edit_node INSTEAD OF INSERT OR DELETE OR UPDATE ON
ve_node FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_node('parent');

CREATE TRIGGER gw_trg_edit_inp_node_junction INSTEAD OF INSERT OR DELETE OR UPDATE ON
ve_inp_junction FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_node('inp_junction');

CREATE TRIGGER gw_trg_edit_inp_treatment INSTEAD OF INSERT OR DELETE OR UPDATE ON
ve_inp_treatment FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_treatment();

CREATE TRIGGER gw_trg_edit_inp_inflows INSTEAD OF INSERT OR DELETE OR UPDATE ON
ve_inp_inflows_poll FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_inflows('INFLOWS-POLL');

CREATE TRIGGER gw_trg_edit_inp_inflows INSTEAD OF INSERT OR DELETE OR UPDATE ON
ve_inp_inflows FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_inflows('INFLOWS');

CREATE TRIGGER gw_trg_edit_inp_dwf INSTEAD OF INSERT OR DELETE OR UPDATE ON
ve_inp_dwf FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dwf();

CREATE TRIGGER gw_trg_edit_inp_dscenario INSTEAD OF INSERT OR DELETE OR UPDATE ON
ve_inp_dscenario_treatment FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('TREATMENT');

CREATE TRIGGER gw_trg_edit_inp_dscenario INSTEAD OF INSERT OR DELETE OR UPDATE ON
ve_inp_dscenario_junction FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('JUNCTION');

CREATE TRIGGER gw_trg_edit_inp_dscenario INSTEAD OF INSERT OR DELETE OR UPDATE ON
ve_inp_dscenario_inflows_poll FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('INFLOWS-POLL');

CREATE TRIGGER gw_trg_edit_inp_dscenario INSTEAD OF INSERT OR DELETE OR UPDATE ON
ve_inp_dscenario_inflows FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('INFLOWS');

CREATE TRIGGER gw_trg_edit_inp_node_storage INSTEAD OF INSERT OR DELETE OR UPDATE ON
ve_inp_storage FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_node('inp_storage');

CREATE TRIGGER gw_trg_edit_inp_dscenario INSTEAD OF INSERT OR DELETE OR UPDATE ON
ve_inp_dscenario_storage FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('STORAGE');

CREATE TRIGGER gw_trg_edit_inp_node_junction INSTEAD OF INSERT OR DELETE OR UPDATE ON
ve_inp_outfall FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_node('inp_outfall');

CREATE TRIGGER gw_trg_edit_inp_dscenario INSTEAD OF INSERT OR DELETE OR UPDATE ON
ve_inp_dscenario_outfall FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('OUTFALL');

CREATE TRIGGER gw_trg_edit_arc INSTEAD OF INSERT OR DELETE OR UPDATE ON
ve_arc FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_arc('parent');

CREATE TRIGGER gw_trg_edit_inp_arc_weir INSTEAD OF INSERT OR DELETE OR UPDATE ON
ve_inp_weir FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_arc('inp_weir');

CREATE TRIGGER gw_trg_edit_inp_arc_virtual INSTEAD OF INSERT OR DELETE OR UPDATE ON
ve_inp_virtual FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_arc('inp_virtual');

CREATE TRIGGER gw_trg_edit_inp_arc_pump INSTEAD OF INSERT OR DELETE OR UPDATE ON
ve_inp_pump FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_arc('inp_pump');

CREATE TRIGGER gw_trg_edit_inp_arc_outlet INSTEAD OF INSERT OR DELETE OR UPDATE ON
ve_inp_outlet FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_arc('inp_outlet');

CREATE TRIGGER gw_trg_edit_inp_arc_orifice INSTEAD OF INSERT OR DELETE OR UPDATE ON
ve_inp_orifice FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_arc('inp_orifice');

CREATE TRIGGER gw_trg_edit_inp_arc_conduit INSTEAD OF INSERT OR DELETE OR UPDATE ON
ve_inp_conduit FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_arc('inp_conduit');

CREATE TRIGGER gw_trg_edit_inp_dscenario INSTEAD OF INSERT OR DELETE OR UPDATE ON
ve_inp_dscenario_conduit FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('CONDUIT');

CREATE TRIGGER gw_trg_ve_dwfzone INSTEAD OF INSERT OR DELETE OR UPDATE ON
ve_dwfzone FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_dwfzone('EDIT');

CREATE TRIGGER gw_trg_v_ui_dwfzone INSTEAD OF INSERT OR DELETE OR UPDATE ON
v_ui_dwfzone FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_dwfzone('UI');

-- 14/07/2025
-- view
CREATE TRIGGER gw_trg_edit_dma INSTEAD OF INSERT OR DELETE OR UPDATE ON
ve_dma FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_dma();

CREATE TRIGGER gw_trg_edit_link INSTEAD OF INSERT OR DELETE OR UPDATE ON
ve_link FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_link('LINK');

-- 15/07/2025
CREATE TRIGGER gw_trg_v_ui_macroomzone INSTEAD OF DELETE OR UPDATE
ON v_ui_macroomzone FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_macroomzone('UI');

-- Expl_id
DROP TRIGGER IF EXISTS gw_trg_fk_array_id_table ON exploitation;
DROP TRIGGER IF EXISTS gw_trg_fk_array_id_table_update ON exploitation;
CREATE TRIGGER gw_trg_fk_array_id_table BEFORE DELETE ON exploitation
FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_id_table('expl_id', '{"dma":"expl_id", "macroomzone":"expl_id", "dwfzone":"expl_id", "drainzone":"expl_id", "sector":"expl_id", "ext_municipality":"expl_id"}');

CREATE TRIGGER gw_trg_fk_array_id_table_update AFTER UPDATE ON exploitation
FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_id_table('expl_id', '{"dma":"expl_id", "macroomzone":"expl_id", "dwfzone":"expl_id", "drainzone":"expl_id", "sector":"expl_id", "ext_municipality":"expl_id"}');

CREATE TRIGGER gw_trg_fk_array_array_table_expl AFTER INSERT OR UPDATE ON dma
FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('expl_id', 'exploitation', 'expl_id');
-- The others are already created

DO $$
DECLARE
    v_utils boolean;
BEGIN

	SELECT value::boolean INTO v_utils FROM config_param_system WHERE parameter='admin_utils_schema';

	IF v_utils IS true THEN
        -- Muni_id
        DROP TRIGGER IF EXISTS gw_trg_fk_array_id_table ON utils.municipality;
        DROP TRIGGER IF EXISTS gw_trg_fk_array_id_table_update ON utils.municipality;
        CREATE TRIGGER gw_trg_fk_array_id_table BEFORE DELETE ON utils.municipality
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_id_table('muni_id', '{"dma":"muni_id", "dwfzone":"muni_id", "drainzone":"muni_id", "exploitation":"muni_id", "sector":"muni_id"}');

        CREATE TRIGGER gw_trg_fk_array_id_table_update AFTER UPDATE ON utils.municipality
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_id_table('muni_id', '{"dma":"muni_id", "dwfzone":"muni_id", "drainzone":"muni_id", "exploitation":"muni_id", "sector":"muni_id"}');

        CREATE TRIGGER gw_trg_fk_array_array_table_muni AFTER INSERT OR UPDATE ON dma
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('muni_id', 'utils.municipality', 'muni_id');
    ELSE
        -- Muni_id
        DROP TRIGGER IF EXISTS gw_trg_fk_array_id_table ON ext_municipality;
        DROP TRIGGER IF EXISTS gw_trg_fk_array_id_table_update ON ext_municipality;
        CREATE TRIGGER gw_trg_fk_array_id_table BEFORE DELETE ON ext_municipality
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_id_table('muni_id', '{"dma":"muni_id", "dwfzone":"muni_id", "drainzone":"muni_id", "exploitation":"muni_id", "sector":"muni_id"}');

        CREATE TRIGGER gw_trg_fk_array_id_table_update AFTER UPDATE ON ext_municipality
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_id_table('muni_id', '{"dma":"muni_id", "dwfzone":"muni_id", "drainzone":"muni_id", "exploitation":"muni_id", "sector":"muni_id"}');

        CREATE TRIGGER gw_trg_fk_array_array_table_muni AFTER INSERT OR UPDATE ON dma
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('muni_id', 'ext_municipality', 'muni_id');
    END IF;


END $$;

-- The others are already created

-- Sector_id
DROP TRIGGER IF EXISTS gw_trg_fk_array_id_table ON sector;
DROP TRIGGER IF EXISTS gw_trg_fk_array_id_table_update ON sector;
CREATE TRIGGER gw_trg_fk_array_id_table BEFORE DELETE ON sector
FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_id_table('sector_id', '{"dma":"sector_id", "dwfzone":"sector_id", "drainzone":"sector_id", "exploitation":"sector_id", "ext_municipality":"sector_id"}');

CREATE TRIGGER gw_trg_fk_array_id_table_update AFTER UPDATE ON sector
FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_id_table('sector_id', '{"dma":"sector_id", "dwfzone":"sector_id", "drainzone":"sector_id", "exploitation":"sector_id", "ext_municipality":"sector_id"}');

CREATE TRIGGER gw_trg_fk_array_array_table_sector AFTER INSERT OR UPDATE ON dma
FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('sector_id', 'sector', 'sector_id');
-- The others are already created

-- old v_edit parent tables:
CREATE TRIGGER gw_trg_edit_arc INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_arc
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_arc('parent');

CREATE TRIGGER gw_trg_edit_node INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_node
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_node('parent');

CREATE TRIGGER gw_trg_edit_connec INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_connec
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_connec('parent');

CREATE TRIGGER gw_trg_edit_gully INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_gully
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_gully('parent');

CREATE TRIGGER gw_trg_edit_link INSTEAD OF INSERT OR UPDATE OR DELETE ON v_edit_link
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_link('parent');
-- ================================

CREATE TRIGGER gw_trg_edit_ve_epa_frpump INSTEAD OF INSERT OR DELETE OR UPDATE ON
ve_epa_frpump FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_ve_epa('frpump');

CREATE TRIGGER gw_trg_edit_ve_epa_frorifice INSTEAD OF INSERT OR DELETE OR UPDATE ON
ve_epa_frorifice FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_ve_epa('frorifice');

CREATE TRIGGER gw_trg_edit_ve_epa_froutlet INSTEAD OF INSERT OR DELETE OR UPDATE ON
ve_epa_froutlet FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_ve_epa('froutlet');

CREATE TRIGGER gw_trg_edit_ve_epa_frweir INSTEAD OF INSERT OR DELETE OR UPDATE ON
ve_epa_frweir FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_ve_epa('frweir');

CREATE TRIGGER gw_trg_edit_inp_dscenario INSTEAD OF INSERT OR DELETE OR UPDATE ON
ve_inp_dscenario_frpump FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('FLWREG-PUMP');

-- 08/08/2025
CREATE TRIGGER gw_trg_plan_psector_after_gully AFTER INSERT ON gully
FOR EACH ROW
WHEN (NEW.state = 2)
EXECUTE FUNCTION gw_trg_insert_psector_x_feature('gully');

CREATE TRIGGER gw_trg_edit_plan_psector_connec INSTEAD OF INSERT OR DELETE OR UPDATE
ON ve_plan_psector_x_connec FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_plan_psector_x_connect('plan_psector_x_connec');

CREATE TRIGGER gw_trg_edit_plan_psector_gully INSTEAD OF INSERT OR DELETE OR UPDATE ON
ve_plan_psector_x_gully FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_plan_psector_x_connect('plan_psector_x_gully');