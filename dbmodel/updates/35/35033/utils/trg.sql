/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;



DROP TRIGGER IF EXISTS gw_trg_node_border ON arc;
CREATE TRIGGER gw_trg_feature_border
    AFTER INSERT OR DELETE OR UPDATE OF expl_id, sector_id,the_geom
    ON arc
    FOR EACH ROW
    EXECUTE PROCEDURE gw_trg_feature_border('ARC');

DROP TRIGGER IF EXISTS gw_trg_node_border ON node;
CREATE TRIGGER gw_trg_feature_border
    AFTER UPDATE OF expl_id, sector_id
    ON node
    FOR EACH ROW
    EXECUTE PROCEDURE gw_trg_feature_border('NODE');
