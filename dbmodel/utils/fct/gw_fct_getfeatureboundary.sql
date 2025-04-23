/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

-- FUNCTION CODE: 3282

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_getfeatureboundary(p_data json)
  RETURNS json AS
$BODY$

/*
SELECT SCHEMA_NAME.gw_fct_getfeatureboundary($${"client":{"device":4, "infoType":1, "lang":"ES"},"form":{},"feature":{"arc":[2001,2002], "node":[], "connec":[3001, 3002]},"data":{"type":"feature"}}$$)
SELECT SCHEMA_NAME.gw_fct_getfeatureboundary($${"client":{"device":4, "infoType":1, "lang":"ES"},"form":{},"feature":{"update_tables":["node", "arc", "connec", "link"]},"data":{"type":"time", "lastSeed":"2023-05-05", "extra":"expl_id = '1' AND sector_id = '10007' AND state = '1'"}}$$)

-- The user need to have all the selector well configured on database because this function works with v_edit_ layers...

*/

DECLARE
v_type text;
v_data json;
v_querynode text = '';
v_queryarc text = '';
v_queryconnec text = '';
v_querygully text = '';
v_array text;
v_querytext text;
v_boundary geometry;
v_geojson json;
v_lastseed text;
v_table text;
v_updatetables text;
v_extra text;

BEGIN

	-- Set search path to local schema
	SET search_path = "SCHEMA_NAME", public;

	v_type = ((p_data ->>'data')::json->>'type');

	IF v_type = 'time' THEN

	    v_lastseed = ((p_data ->>'data')::json->>'lastSeed');
	    v_updatetables = ((p_data ->>'feature')::json->>'update_tables');
	    v_extra = ((p_data ->>'data')::json->>'extra');
	    v_querytext = '';

	    FOR v_table IN SELECT json_array_elements_text(v_updatetables::json) LOOP
	        v_querytext = concat(
	            v_querytext,
	            ' SELECT the_geom FROM ', v_table,
	            ' WHERE updated_at > ''', v_lastseed, '''::timestamp',
	            CASE
	                WHEN v_extra IS NOT NULL AND v_extra <> ''
	                THEN ' AND ' || v_extra
	                ELSE ''
	            END,
	            ' UNION'
	        );
	    END LOOP;

		v_querytext = left(v_querytext, length(v_querytext) - 6);
		v_querytext = CONCAT('SELECT ST_AsGeoJSON(COALESCE(ST_Collect(ST_Buffer(the_geom, 2)), ST_GeomFromText(''POINT EMPTY'')))
		FROM (', v_querytext, ') AS combined_geometries');

	ELSIF v_type = 'feature' THEN
		v_array =  COALESCE(replace(replace(((p_data ->>'feature')::json->>'node'),'[','('),']',')'),'()') ;
		IF v_array != '()' THEN
			v_querynode = concat('SELECT the_geom FROM v_edit_node WHERE node_id::integer IN ', v_array);
		END IF;

		v_array =  COALESCE(replace(replace(((p_data ->>'feature')::json->>'arc'),'[','('),']',')'),'()') ;
		IF v_array != '()' THEN
			v_queryarc = concat('SELECT the_geom FROM v_edit_arc WHERE arc_id::integer IN ', v_array);
		END IF;

		v_array =  COALESCE(replace(replace(((p_data ->>'feature')::json->>'connec'),'[','('),']',')'),'()') ;
		IF v_array != '()' THEN
			v_queryconnec = concat('SELECT the_geom FROM v_edit_connec WHERE connec_id::integer IN ', v_array);
		END IF;

		v_array =  COALESCE(replace(replace(((p_data ->>'feature')::json->>'gully'),'[','('),']',')'),'()') ;
		IF v_array != '()' THEN
			v_querygully = concat('SELECT the_geom FROM v_edit_gully WHERE gully_id::integer IN ', v_array);
		END IF;

		-- Building the query text
		v_querytext = concat('SELECT ST_AsGeoJSON(ST_Collect(ST_Buffer(the_geom, 2))) from (', v_querynode, v_queryarc, v_queryconnec, v_querygully, ') a');

	END IF;

	-- Execute query text and set boundary geometry
	EXECUTE v_querytext INTO v_geojson;

	RETURN v_geojson;

	-- Exception handling
	EXCEPTION WHEN OTHERS THEN RETURN NULL;

END;
$BODY$
LANGUAGE plpgsql VOLATILE
COST 100;