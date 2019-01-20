/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2508


CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_getinsertform_vdef(
    p_feature_cat text,
    p_x double precision,
    p_y double precision)
  RETURNS json AS
$BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_getinsertform_vdef('WJOIN',2,2)
*/

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
	v_project_type varchar;
	v_cat_id varchar;
	v_type varchar;
	v_feature_type varchar;
	v_feature_cat varchar;
	v_fieldtype varchar;
	v_fieldcat  varchar;
	v_tabletype varchar;
	v_tablecat  varchar;
	v_cat_vdef varchar;
	v_type_vdef varchar;
	v_inventory varchar;
        v_publish varchar;
        v_uncertain varchar;
	
BEGIN
	--    Set search path to local schema
	SET search_path = "SCHEMA_NAME", public;

	-- get project type
	SELECT wsoftware INTO v_project_type FROM version LIMIT 1;

	--  get api version
	EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''ApiVersion'') row'
        INTO api_version;

        -- get sys_feature_type
	v_feature_type := (SELECT lower(type) FROM sys_feature_cat WHERE id=p_feature_cat);	

	-- lower feature cat
	v_feature_cat :=lower(p_feature_cat);

	-- Get feature id
        v_feature_id:= (SELECT nextval('urn_id_seq')::text);

-- Map zones
	-- Make geometry column
	v_the_geom:= ST_SetSRID(ST_MakePoint(p_x, p_y),(SELECT ST_srid (the_geom) FROM sector limit 1));

	-- Sector ID
	v_sector_id := (SELECT "value"::integer FROM config_param_user WHERE "parameter"='sector_vdefault' AND "cur_user"="current_user"() LIMIT 1);

	IF (v_sector_id IS NULL) THEN
		SELECT count(*)into count_aux FROM sector WHERE ST_DWithin(v_the_geom, sector.the_geom,0.001);
		IF count_aux = 1 THEN
			v_sector_id = (SELECT sector_id FROM sector WHERE ST_DWithin(v_the_geom, sector.the_geom,0.001) LIMIT 1);
		ELSIF count_aux > 1 THEN
			v_sector_id = (SELECT sector_id FROM v_edit_node WHERE ST_DWithin(v_the_geom, v_edit_node.the_geom, 10) 
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
			v_dma_id = (SELECT dma_id FROM v_edit_node WHERE ST_DWithin(v_the_geom, v_edit_node.the_geom, 10) 
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


-- Other values
	-- feature catalog & feature type
	IF v_project_type='WS' THEN

			-- definition of variables
			v_fieldtype = concat(v_feature_type,'type_id');
			v_fieldcat = concat(v_feature_cat,'cat_id');
			v_cat_vdef = concat(v_feature_cat,'cat_vdefault');
			v_tabletype = concat(v_feature_type,'_type');
			v_tablecat = concat('cat_',v_feature_type);
	
			-- feature catalog
			EXECUTE 'SELECT row_to_json(a) FROM (SELECT value FROM config_param_user WHERE "parameter"='||quote_literal(v_cat_vdef)||' AND "cur_user"='||quote_literal(current_user)||' LIMIT 1) a'
				INTO v_cat_id;

			IF v_cat_id IS NULL THEN
				EXECUTE 'SELECT row_to_json(a) FROM (SELECT value FROM config_param_user WHERE "parameter"= '||quote_literal(v_cat_vdef)||' LIMIT 1) a'
					INTO v_cat_id;
				IF v_cat_id IS NULL THEN 
					EXECUTE ' SELECT row_to_json(a) FROM (SELECT '||v_tablecat||'.id FROM '||v_tablecat||
						' JOIN '||v_tabletype||' ON '||v_tabletype||'.id = '||v_fieldtype||
						' WHERE type = '||quote_literal(upper(v_feature_cat))||' LIMIT 1) a'
						INTO v_cat_id;
				END IF;
			END IF;
			
	ELSE 	
			
			-- definition of variables
			v_fieldtype = concat(v_feature_type,'_type');
			v_type_vdef = concat(v_feature_type,'type_vdefault');
			v_cat_vdef = concat(v_feature_type,'cat_vdefault');
			v_tabletype = concat(v_feature_type,'_type');
			v_tablecat = concat('cat_',v_feature_type);
			
	
			--feature_catalog
			EXECUTE 'SELECT row_to_json(a) FROM (SELECT value FROM config_param_user WHERE "parameter"='||quote_literal(v_cat_vdef)||' AND "cur_user"='||quote_literal(current_user)||' LIMIT 1) a'
				INTO v_cat_id;

			IF v_cat_id IS NULL THEN
				EXECUTE 'SELECT row_to_json(a) FROM (SELECT value FROM config_param_user WHERE "parameter"= '||quote_literal(v_cat_vdef)||' LIMIT 1) a'
					INTO v_cat_id;
					
				IF v_cat_id IS NULL THEN 
					EXECUTE 'SELECT row_to_json(a) FROM (SELECT id FROM '||v_tablecat||' LIMIT 1) a'
						INTO v_cat_id;
				END IF;
			END IF;
			
			-- feature_type
			EXECUTE 'SELECT row_to_json(a) FROM (SELECT value FROM config_param_user WHERE "parameter"= '||quote_literal(v_type_vdef)||' AND "cur_user"='||quote_literal(current_user)||' LIMIT 1) a'
			INTO v_type;

			IF v_type IS NULL THEN
				EXECUTE 'SELECT row_to_json(a) FROM (SELECT value FROM config_param_user WHERE "parameter"= '||quote_literal(v_type_vdef)||' LIMIT 1) a'
					INTO v_type;

				IF v_type IS NULL THEN 
					EXECUTE 'SELECT row_to_json(a) FROM (SELECT id FROM '||v_tabletype||
					' WHERE type = '||quote_literal(upper(v_feature_cat))||'LIMIT 1) a'
					INTO v_type;
				END IF;
			END IF;
	END IF;

	-- state
	v_state := (SELECT "value"::integer FROM config_param_user WHERE "parameter"='state_vdefault' AND "cur_user"="current_user"() LIMIT 1);
	IF v_state IS NULL THEN
		v_state:= 1;
	END IF;
	v_state:= (SELECT row_to_json(a) FROM (SELECT name FROM value_state WHERE id=v_state::integer)a);

	
	-- state type
	v_state_type := (SELECT "value"::integer FROM config_param_user WHERE "parameter"='statetype_vdefault' AND "cur_user"="current_user"() LIMIT 1);
	IF v_state_type IS NULL THEN
			v_state_type := (SELECT "value"::integer FROM config_param_user WHERE "parameter"='statetype_vdefault' LIMIT 1);
			IF v_state_type IS NULL THEN 
				v_state_type := (SELECT id FROM value_state_type WHERE state=1 LIMIT 1);
			END IF;
	END IF;
	
	v_state_type:= (SELECT row_to_json(a) FROM (SELECT name FROM value_state_type WHERE id=v_state_type::integer)a);

	v_inventory := (SELECT row_to_json(a) FROM (SELECT "value"::boolean FROM config_param_system WHERE "parameter"='edit_inventory_sysvdefault' LIMIT 1)a);
	v_publish := (SELECT row_to_json(a) FROM (SELECT "value"::boolean FROM config_param_system WHERE "parameter"='edit_publish_sysvdefault' LIMIT 1)a);
	v_uncertain := (SELECT row_to_json(a) FROM (SELECT "value"::boolean FROM config_param_system WHERE "parameter"='edit_uncertain_sysvdefault' LIMIT 1)a);

--    Control NULL's
    v_feature_id := COALESCE(v_feature_id, '{}');
    v_sector_id := COALESCE(v_sector_id, '{}');
    v_dma_id := COALESCE(v_dma_id, '{}');
    v_expl_id := COALESCE(v_expl_id, '{}');
    v_muni_id := COALESCE(v_muni_id, '{}');
    
    v_cat_id := COALESCE(v_cat_id, '{}');
    v_type := COALESCE(v_type, '{}');
    v_state := COALESCE(v_state, '{}');
    v_state_type := COALESCE(v_state_type, '{}');
    v_inventory := COALESCE(v_inventory, '{}');
    v_publish := COALESCE(v_publish, '{}');
    v_uncertain := COALESCE(v_uncertain, '{}');
    

--    Return
    RETURN ('{"status":"Accepted"' ||
	', "feature_id":"' || v_feature_id || '"' ||
        ', "sector_id":' || v_sector_id || 
       ', "dma_id":' || v_dma_id ||
      ', "expl_id":' || v_expl_id ||
        ', "muni_id":' || v_muni_id ||
	', "cat_id":' || v_cat_id ||
	', "type":' || v_type ||
        ', "state":' || v_state ||
        ', "state_type":' || v_state_type ||        
        ', "inventory":' || v_inventory || 
        ', "publish":' || v_publish || 
        ', "uncertain":' || v_uncertain || 

        '}')::json;

--   Exception handling
  --  EXCEPTION WHEN OTHERS THEN 
    --    RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ', "apiVersion":'|| api_version ||',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;