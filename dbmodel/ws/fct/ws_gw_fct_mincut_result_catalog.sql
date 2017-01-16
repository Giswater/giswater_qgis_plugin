/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


DROP FUNCTION IF EXISTS "SCHEMA_NAME".gw_fct_mincut_result_catalog();
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_mincut_result_catalog()
  RETURNS void AS
$BODY$

DECLARE
	result_cat_id_aux	varchar;
	polygon_rec			record;
	arc_rec				record;
	node_rec			record;
	valve_rec			record;
	connec_rec			record;
	hydrometer_rec  	record;

BEGIN
    -- Search path
    SET search_path = "SCHEMA_NAME", public;

    -- Insert catalog table
    SELECT nextval ('"SCHEMA_NAME".anl_mincut_result_cat_seq'::regclass) INTO result_cat_id_aux ;
    INSERT INTO anl_mincut_result_cat (id) VALUES (result_cat_id_aux);

    -- Insert polygon table
    SELECT * INTO polygon_rec FROM anl_mincut_polygon;
    INSERT INTO anl_mincut_result_polygon (mincut_result_cat_id,polygon_id,the_geom) VALUES (result_cat_id_aux, polygon_rec.polygon_id, polygon_rec.the_geom);
        
    -- Insert arc table
    FOR arc_rec IN SELECT * FROM anl_mincut_arc
    LOOP
        INSERT INTO anl_mincut_result_arc (mincut_result_cat_id, arc_id) VALUES (result_cat_id_aux, arc_rec.arc_id);
    END LOOP;
    
    -- Insert node table
    FOR node_rec IN SELECT * FROM anl_mincut_node
    LOOP
	INSERT INTO anl_mincut_result_node (mincut_result_cat_id, node_id) VALUES (result_cat_id_aux, node_rec.node_id);
    END LOOP;

    -- Insert valve table
    FOR valve_rec IN SELECT * FROM anl_mincut_valve
    LOOP
	INSERT INTO anl_mincut_result_valve (mincut_result_cat_id, valve_id) VALUES (result_cat_id_aux, valve_rec.valve_id);
    END LOOP;

    -- Insert connec table
    FOR connec_rec IN SELECT * FROM v_anl_mincut_connec
    LOOP
	INSERT INTO anl_mincut_result_connec (mincut_result_cat_id, connec_id) VALUES (result_cat_id_aux, connec_rec.connec_id);
    END LOOP;

    -- Insert hydrometer table
    FOR hydrometer_rec IN SELECT * FROM v_anl_mincut_hydrometer
    LOOP
	INSERT INTO anl_mincut_result_hydrometer (mincut_result_cat_id, hydrometer_id) VALUES (result_cat_id_aux, hydrometer_rec.hydrometer_id);
    END LOOP;

    -- Insert selector table
    DELETE FROM anl_mincut_result_selector;
    INSERT INTO anl_mincut_result_selector (id) VALUES (result_cat_id_aux);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

