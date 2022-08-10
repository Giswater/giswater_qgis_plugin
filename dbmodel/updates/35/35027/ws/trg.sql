/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2022/08/04

DROP TRIGGER IF EXISTS gw_trg_edit_sector ON v_edit_sector;
CREATE TRIGGER gw_trg_edit_sector
INSTEAD OF INSERT OR UPDATE OR DELETE ON v_edit_sector
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_sector('sector');

DROP TRIGGER IF EXISTS gw_trg_edit_dma ON v_edit_dma;
CREATE TRIGGER gw_trg_edit_dma
INSTEAD OF INSERT OR UPDATE OR DELETE ON v_edit_dma
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_dma('dma');

DROP TRIGGER IF EXISTS gw_trg_edit_presszone ON v_edit_presszone;
CREATE TRIGGER gw_trg_edit_presszone
INSTEAD OF INSERT OR UPDATE OR DELETE ON v_edit_presszone
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_presszone();

DROP TRIGGER IF EXISTS gw_trg_edit_dqa ON v_edit_dqa;
CREATE TRIGGER gw_trg_edit_dqa 
INSTEAD OF INSERT OR UPDATE OR DELETE ON v_edit_dqa
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_dqa();

DROP TRIGGER IF EXISTS gw_trg_edit_cat_feature ON v_edit_cat_feature_node;
CREATE TRIGGER gw_trg_edit_cat_feature
INSTEAD OF INSERT OR UPDATE OR DELETE ON v_edit_cat_feature_node
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_cat_feature('node');

DROP TRIGGER IF EXISTS gw_trg_edit_anl_hydrant ON v_edit_anl_hydrant;
CREATE TRIGGER gw_trg_edit_anl_hydrant
INSTEAD OF INSERT OR UPDATE OR DELETE ON v_edit_anl_hydrant
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_anl_hydrant('node');