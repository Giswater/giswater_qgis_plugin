/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: XXXX


CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_getinsertform_vdef(
    p_x double precision,
    p_y double precision)
  RETURNS json AS
$BODY$
DECLARE

--    Variables
	form_data json;
	event_data record;	
	event_data_json json;
	v_the_geom public.geometry;
	count_aux integer;
	v_feature_id text;
	v_code text;
	v_state	text;
	v_state_type text;
	v_workcat_id text;
	v_ownercat_id text;
	v_soilcat_id text;
	v_verified text;
	v_presszonecat_id text;
	v_builtdate text;
	v_sector_id text;
	v_dma_id text;
	v_expl_id text;
	v_muni_id text;
	api_version text;

BEGIN

	--    Set search path to local schema
	SET search_path = "SCHEMA_NAME", public;

	--  get api version
	EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''ApiVersion'') row'
        INTO api_version;

	-- Get feature id
        v_feature_id:= (SELECT nextval('urn_id_seq')::text);
      			
	-- Make geometry column
	v_the_geom:= ST_SetSRID(ST_MakePoint(p_x, p_y),(SELECT ST_srid (the_geom) FROM SCHEMA_NAME.sector limit 1));

	-- Sector ID
	v_sector_id := (SELECT "value"::integer FROM config_param_user WHERE "parameter"='sector_vdefault' AND "cur_user"="current_user"() LIMIT 1);

	IF (v_sector_id IS NULL) THEN
		SELECT count(*)into count_aux FROM sector WHERE ST_DWithin(v_the_geom, sector.the_geom,0.001);
		IF count_aux = 1 THEN
			v_sector_id = (SELECT sector_id FROM sector WHERE ST_DWithin(v_the_geom, sector.the_geom,0.001) LIMIT 1);
		ELSIF count_aux > 1 THEN
			v_sector_id = (SELECT sector_id FROM v_edit_node WHERE ST_DWithin(v_the_geom, v_edit_node.the_geom, promixity_buffer_aux) 
			order by ST_Distance (v_the_geom, v_edit_node.the_geom) LIMIT 1);
		END IF;	
	END IF;
               
	-- Dma ID
	v_dma_id := (SELECT "value"::integer FROM config_param_user WHERE "parameter"='dma_vdefault' AND "cur_user"="current_user"() LIMIT 1);
	IF (v_dma_id IS NULL) THEN
		SELECT count(*)into count_aux FROM dma WHERE ST_DWithin(v_the_geom, dma.the_geom,0.001);
		IF count_aux = 1 THEN
			v_dma_id := (SELECT dma_id FROM dma WHERE ST_DWithin(v_the_geom, dma.the_geom,0.001) LIMIT 1);
		ELSIF count_aux > 1 THEN
			v_dma_id = (SELECT dma_id FROM v_edit_node WHERE ST_DWithin(v_the_geom, v_edit_node.the_geom, promixity_buffer_aux) 
			order by ST_Distance (v_the_geom, v_edit_node.the_geom) LIMIT 1);
		END IF;
	END IF; 
              	
	-- Exploitation	
	v_expl_id :=  (SELECT "value"::integer FROM config_param_user WHERE "parameter"='exploitation_vdefault' AND "cur_user"="current_user"() LIMIT 1);		
	IF (v_expl_id IS NULL) THEN
		v_expl_id := (SELECT expl_id FROM exploitation WHERE ST_DWithin(v_the_geom, exploitation.the_geom,0.001) LIMIT 1);
	END IF;

	-- Municipality 
	v_muni_id := (SELECT "value"::integer FROM config_param_user WHERE "parameter"='municipality_vdefault' AND "cur_user"="current_user"() LIMIT 1);
	IF (v_muni_id IS NULL) THEN
		v_muni_id := (SELECT muni_id FROM ext_municipality WHERE ST_DWithin(v_the_geom, ext_municipality.the_geom,0.001) LIMIT 1);		
	END IF;


	v_sector_id:= (SELECT row_to_json(a) FROM (SELECT name FROM sector WHERE sector_id=v_sector_id::integer)a);
	v_dma_id:= (SELECT row_to_json(a) FROM (SELECT name FROM dma WHERE dma_id=v_dma_id::integer)a);
	v_expl_id:= (SELECT row_to_json(a) FROM (SELECT name FROM exploitation WHERE expl_id=v_expl_id::integer)a);
	v_muni_id:= (SELECT row_to_json(a) FROM (SELECT name FROM ext_municipality WHERE muni_id=v_muni_id::integer)a);
 

--    Control NULL's
    v_feature_id := COALESCE(v_feature_id, '{}');
    v_sector_id := COALESCE(v_sector_id, '{}');
    v_dma_id := COALESCE(v_dma_id, '{}');
    v_expl_id := COALESCE(v_expl_id, '{}');
    v_muni_id := COALESCE(v_muni_id, '{}');
    

--    Return
    RETURN ('{"status":"Accepted"' ||
	', "feature_id":"' || v_feature_id || '"' ||
        ', "sector_id":' || v_sector_id || 
        ', "dma_id":' || v_dma_id ||
        ', "expl_id":' || v_expl_id ||
        ', "muni_id":' || v_muni_id ||
        '}')::json;

--   Exception handling
    EXCEPTION WHEN OTHERS THEN 
        RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ', "apiVersion":'|| api_version ||',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;




END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

