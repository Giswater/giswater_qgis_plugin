
/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


--FUNCTION CODE: XXXX


CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_audit() RETURNS TRIGGER AS $body$
DECLARE
    v_old_data json;
    v_new_data json;
    v_log_id integer;
    v_foreign_audit boolean;
BEGIN

--  Set search path to local schema
    SET search_path = "SCHEMA_NAME", public;


    IF (TG_OP = 'INSERT') THEN
        INSERT INTO audit.audit_fid_log (fid, fcount, groupby, criticity, tstamp, schema)
        VALUES (NEW.fid, NEW.fcount, NEW.groupby, NEW.criticity, NEW.tstamp, 'SCHEMA_NAME');

        INSERT INTO audit.anl_arc (arc_id, arccat_id, state, arc_id_aux, expl_id, fid, cur_user, 
        the_geom, the_geom_p, descript, result_id, node_1, node_2, sys_type, 
        code, cat_geom1, length, slope, total_length, z1, z2, y1, y2, 
        elev1, elev2, losses,schema)
        SELECT arc_id, arccat_id, state, arc_id_aux, expl_id, fid, cur_user, 
        the_geom, the_geom_p, descript, result_id, node_1, node_2, sys_type, 
        code, cat_geom1, length, slope, total_length, z1, z2, y1, y2, 
        elev1, elev2, losses, 'SCHEMA_NAME'
        FROM anl_arc WHERE fid=NEW.fid AND cur_user=current_user;

        INSERT INTO anl_node (node_id, nodecat_id, state, num_arcs, node_id_aux, nodecat_id_aux, 
        state_aux, expl_id, fid, cur_user, the_geom, arc_distance, arc_id, 
        descript, result_id, total_distance, sys_type, code, cat_geom1, 
        elevation, elev, depth, state_type, sector_id, losses, schema)
        SELECT node_id, nodecat_id, state, num_arcs, node_id_aux, nodecat_id_aux, 
        state_aux, expl_id, fid, cur_user, the_geom, arc_distance, arc_id, 
        descript, result_id, total_distance, sys_type, code, cat_geom1, 
        elevation, elev, depth, state_type, sector_id, losses, 'SCHEMA_NAME'
        FROM anl_node WHERE fid=NEW.fid AND cur_user=current_user;

        RETURN NEW;
    END IF;

END;
$body$
LANGUAGE plpgsql;



CREATE TRIGGER gw_trg_audit
  AFTER INSERT ON SCHEMA_NAME.audit_fid_log
  FOR EACH ROW
  EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_audit();
