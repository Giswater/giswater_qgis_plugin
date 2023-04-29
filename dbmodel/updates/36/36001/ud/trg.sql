/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2022/03/02

CREATE TRIGGER gw_trg_edit_ve_epa_junction INSTEAD OF INSERT OR UPDATE OR DELETE ON ve_epa_junction
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_ve_epa('junction');

CREATE TRIGGER gw_trg_edit_ve_epa_conduit INSTEAD OF INSERT OR UPDATE OR DELETE ON ve_epa_conduit
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_ve_epa('conduit');

CREATE TRIGGER gw_trg_edit_ve_epa_outfall INSTEAD OF INSERT OR UPDATE OR DELETE ON ve_epa_outfall
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_ve_epa('outfall');

CREATE TRIGGER gw_trg_edit_ve_epa_storage INSTEAD OF INSERT OR UPDATE OR DELETE ON ve_epa_storage
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_ve_epa('storage');

CREATE TRIGGER gw_trg_edit_ve_epa_pump INSTEAD OF INSERT OR UPDATE OR DELETE ON ve_epa_pump
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_ve_epa('pump');

CREATE TRIGGER gw_trg_edit_ve_epa_virtual INSTEAD OF INSERT OR UPDATE OR DELETE ON ve_epa_virtual
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_ve_epa('virtual');

CREATE TRIGGER gw_trg_edit_ve_epa_netgully INSTEAD OF INSERT OR UPDATE OR DELETE ON ve_epa_netgully
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_ve_epa('netgully');

CREATE TRIGGER gw_trg_edit_ve_epa_weir INSTEAD OF INSERT OR UPDATE OR DELETE ON ve_epa_weir
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_ve_epa('weir');

CREATE TRIGGER gw_trg_edit_ve_epa_orifice INSTEAD OF INSERT OR UPDATE OR DELETE ON ve_epa_orifice
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_ve_epa('orifice');

CREATE TRIGGER gw_trg_edit_ve_epa_outlet INSTEAD OF INSERT OR UPDATE OR DELETE ON ve_epa_outlet
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_ve_epa('outlet');

DROP TRIGGER IF EXISTS gw_trg_vi_timeseries ON vi_timeseries;
CREATE TRIGGER   gw_trg_vi_timeseries
    INSTEAD OF INSERT OR DELETE OR UPDATE 
    ON vi_timeseries
    FOR EACH ROW
    EXECUTE FUNCTION gw_trg_vi('vi_timeseries');

DROP TRIGGER IF EXISTS gw_trg_link_data ON gully;
CREATE TRIGGER gw_trg_link_data AFTER INSERT OR UPDATE OF epa_type, state_type, expl_id2
ON gully FOR EACH ROW EXECUTE FUNCTION gw_trg_link_data('gully');

DROP TRIGGER IF EXISTS gw_trg_link_data ON connec;
CREATE TRIGGER gw_trg_link_data AFTER INSERT OR UPDATE OF  state_type, expl_id2
ON connec FOR EACH ROW EXECUTE FUNCTION gw_trg_link_data('connec');

