/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;

DROP TRIGGER IF EXISTS gw_trg_fk_array_array_table_muni ON sector;
DROP TRIGGER IF EXISTS gw_trg_fk_array_id_table ON sector;
DROP TRIGGER IF EXISTS gw_trg_fk_array_id_table_update ON sector;
DROP TRIGGER IF EXISTS gw_trg_fk_array_array_table_muni ON dma;
DROP TRIGGER IF EXISTS gw_trg_fk_array_array_table_muni ON macroomunit;
DROP TRIGGER IF EXISTS gw_trg_fk_array_array_table_muni ON omunit;
DROP TRIGGER IF EXISTS gw_trg_fk_array_array_table_muni ON macroomzone;
DROP TRIGGER IF EXISTS gw_trg_fk_array_array_table_muni ON omzone;
DROP TRIGGER IF EXISTS gw_trg_fk_array_array_table_muni ON macrosector;
DROP TRIGGER IF EXISTS gw_trg_fk_array_array_table_muni ON dwfzone;
DROP TRIGGER IF EXISTS gw_trg_fk_array_array_table_muni ON drainzone;

CREATE TRIGGER gw_trg_fk_array_array_table_muni AFTER INSERT
OR UPDATE OF muni_id ON
sector FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('muni_id', 'utils.municipality', 'muni_id');
CREATE TRIGGER gw_trg_fk_array_id_table BEFORE DELETE ON
sector FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_id_table('sector_id', '{"dma":"sector_id", "dwfzone":"sector_id", "drainzone":"sector_id", "exploitation":"sector_id", "utils.municipality":"sector_id"}');
CREATE TRIGGER gw_trg_fk_array_id_table_update AFTER UPDATE OF sector_id ON
sector FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_id_table('sector_id', '{"utils.municipality":"sector_id", "exploitation":"sector_id"}');

CREATE TRIGGER gw_trg_fk_array_array_table_muni AFTER INSERT
OR UPDATE OF muni_id ON
dma FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('muni_id', 'utils.municipality', 'muni_id');

CREATE TRIGGER gw_trg_fk_array_array_table_muni AFTER INSERT
OR UPDATE OF muni_id ON
macroomunit FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('muni_id', 'utils.municipality', 'muni_id');

CREATE TRIGGER gw_trg_fk_array_array_table_muni AFTER INSERT
OR UPDATE OF muni_id ON
omunit FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('muni_id', 'utils.municipality', 'muni_id');

CREATE TRIGGER gw_trg_fk_array_array_table_muni AFTER INSERT
OR UPDATE OF muni_id ON
macroomzone FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('muni_id', 'utils.municipality', 'muni_id');

CREATE TRIGGER gw_trg_fk_array_array_table_muni AFTER INSERT
OR UPDATE OF muni_id ON
omzone FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('muni_id', 'utils.municipality', 'muni_id');

CREATE TRIGGER gw_trg_fk_array_array_table_muni AFTER INSERT
OR UPDATE OF muni_id ON
macrosector FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('muni_id', 'utils.municipality', 'muni_id');

CREATE TRIGGER gw_trg_fk_array_array_table_muni AFTER INSERT
OR UPDATE OF muni_id ON
dwfzone FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('muni_id', 'utils.municipality', 'muni_id');

CREATE TRIGGER gw_trg_fk_array_array_table_muni AFTER INSERT
OR UPDATE OF muni_id ON
drainzone FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('muni_id', 'utils.municipality', 'muni_id');
