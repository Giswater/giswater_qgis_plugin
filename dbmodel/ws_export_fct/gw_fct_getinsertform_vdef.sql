CREATE OR REPLACE FUNCTION "SCHEMA_NAME"."gw_fct_getinsertform_vdef"(p_x float8, p_y float8) RETURNS pg_catalog.text AS $BODY$
DECLARE

--    Variables
    form_data json;
    event_data record;    
    event_data_json json;
    v_the_geom public.geometry;
    count_aux integer;
    v_arc_id text;
    v_code text;
    v_state    text;
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
    v_return text;

BEGIN

    --    Set search path to local schema
    SET search_path = "SCHEMA_NAME", public;

    --  get api version
    EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''ApiVersion'') row'
        INTO api_version;

    -- Arc id
        v_arc_id:= (SELECT nextval('urn_id_seq')::text);
                  
    -- Make geometry column
    v_the_geom:= ST_SetSRID(ST_MakePoint(p_x, p_y),(SELECT ST_srid (the_geom) FROM SCHEMA_NAME.sector limit 1));

    -- Sector ID
    SELECT count(*)into count_aux FROM sector WHERE ST_DWithin(v_the_geom, sector.the_geom,0.001);
    IF count_aux = 1 THEN
        v_sector_id = (SELECT sector_id FROM sector WHERE ST_DWithin(v_the_geom, sector.the_geom,0.001) LIMIT 1);
    ELSIF count_aux > 1 THEN
        v_sector_id = (SELECT sector_id FROM v_edit_node WHERE ST_DWithin(v_the_geom, v_edit_node.the_geom, promixity_buffer_aux) 
        order by ST_Distance (v_the_geom, v_edit_node.the_geom) LIMIT 1);
    END IF;    
    IF (v_sector_id IS NULL) THEN
        v_sector_id := (SELECT "value"::integer FROM config_param_user WHERE "parameter"='sector_vdefault' AND "cur_user"="current_user"() LIMIT 1);
    END IF;
               
    -- Dma ID
    SELECT count(*)into count_aux FROM dma WHERE ST_DWithin(v_the_geom, dma.the_geom,0.001);
    IF count_aux = 1 THEN
        v_dma_id := (SELECT dma_id FROM dma WHERE ST_DWithin(v_the_geom, dma.the_geom,0.001) LIMIT 1);
    ELSIF count_aux > 1 THEN
        v_dma_id = (SELECT dma_id FROM v_edit_node WHERE ST_DWithin(v_the_geom, v_edit_node.the_geom, promixity_buffer_aux) 
        order by ST_Distance (v_the_geom, v_edit_node.the_geom) LIMIT 1);
    END IF;
    IF (v_dma_id IS NULL) THEN
        v_dma_id := (SELECT "value"::integer FROM config_param_user WHERE "parameter"='dma_vdefault' AND "cur_user"="current_user"() LIMIT 1);
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


    v_sector_id:= (SELECT name FROM sector WHERE sector_id=v_sector_id::integer);
    v_dma_id:= (SELECT name FROM dma WHERE dma_id=v_dma_id::integer);
    v_expl_id:= (SELECT name FROM exploitation WHERE expl_id=v_expl_id::integer);
    v_muni_id:= (SELECT name FROM ext_municipality WHERE muni_id=v_muni_id::integer);

    v_return:= '''arc_id'':'''|| v_arc_id ||''';''expl_id'':''' || v_expl_id ||''';''dma_id'':''' || v_dma_id ||''';''expl_id'':''' || v_expl_id ||''';''muni_id'':''' || v_muni_id ||'''';

--    Return
    RETURN v_return;
    

END;
$BODY$
LANGUAGE 'plpgsql' VOLATILE COST 100;

