/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3494

DROP FUNCTION IF EXISTS "SCHEMA_NAME".gw_fct_pg2iber_pgully();
CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_pg2iber_pgully()
RETURNS json AS
$BODY$

/*
SELECT SCHEMA_NAME.gw_fct_pg2iber_pgully($${"client":{"device":4, "infoType":1, "lang":"ES","epsg":SRID_VALUE}, "data":{"resultId":"test1", "dumpSubcatch":"true","step":"0"}}$$) -- FULL PROCESS

*/

-- fid:

DECLARE

	v_result jsonb;
	v_version text;
	v_srid integer;
	v_isoperative boolean;
	v_statetype text;

BEGIN

	-- Search path
	SET search_path = "SCHEMA_NAME", public;

	SELECT giswater INTO v_version FROM sys_version ORDER BY id DESC LIMIT 1;

	v_isoperative = (SELECT value::json->>'onlyIsOperative' FROM config_param_user WHERE parameter='inp_options_debug' AND cur_user=current_user)::boolean;

	-- Use state_type only is operative true or not
	IF v_isoperative THEN
		v_statetype = ' AND value_state_type.is_operative = TRUE ';
	ELSE
		v_statetype = ' AND (value_state_type.is_operative = TRUE OR value_state_type.is_operative = FALSE)';
	END IF;

	EXECUTE '
		WITH temp_t_pgully AS (
			SELECT 
			gully_id,
			gullycat_id,
			case
				when pjoint_type = ''NODE'' then pjoint_id
				else a.node_2
			END AS node_id,  
			case
				when custom_top_elev is null then top_elev
				else custom_top_elev
			end as top_elev, 
			outlet_type,
			case
				when custom_width is null then total_width
				else custom_width
			end as width, 
			case
				when g.custom_length is null then total_length
				else g.custom_length
			end as length,
			case
				when custom_depth is null then depth
				else custom_depth
			end as depth,
			gully_method as method,
			weir_cd,
			orifice_cd,
			custom_a_param as a_param,
			custom_b_param as b_param,
			efficiency,
			g.the_geom
			FROM selector_sector s, ve_inp_pgully g
				LEFT JOIN arc a USING (arc_id)
				LEFT JOIN value_state_type ON id=g.state_type
			WHERE arc_id IS NOT NULL AND g.sector_id > 0 '||v_statetype||' AND s.cur_user = current_user and s.sector_id = g.sector_id
		),
		vi_t_pgully AS (
			SELECT temp_t_pgully.gully_id::text as code,
		    temp_t_pgully.outlet_type,
		    COALESCE(temp_t_pgully.node_id::text, ''-9999''::text) AS outlet_node,
		    temp_t_pgully.the_geom as the_geom,
		    COALESCE(temp_t_pgully.top_elev::numeric(12,3), ''-9999''::integer::numeric) AS top_elev,
		    temp_t_pgully.width::numeric(12,3) AS width,
		    temp_t_pgully.length::numeric(12,3) AS length,
		    COALESCE(temp_t_pgully.depth::numeric(12,3), ''-9999''::integer::numeric) AS depth,
		    temp_t_pgully.method,
		    COALESCE(temp_t_pgully.weir_cd::numeric(12,3), ''-9999''::integer::numeric) AS weir_cd,
		    COALESCE(temp_t_pgully.orifice_cd::numeric(12,3), ''-9999''::integer::numeric) AS orifice_cd,
		    COALESCE(temp_t_pgully.a_param::numeric(12,3), ''-9999''::integer::numeric) AS a_param,
		    COALESCE(temp_t_pgully.b_param::numeric(12,3), ''-9999''::integer::numeric) AS b_param,
			COALESCE(temp_t_pgully.efficiency, cat_gully.efficiency) AS efficiency
		   FROM temp_t_pgully
		     LEFT JOIN cat_gully ON cat_gully.id = temp_t_pgully.gullycat_id
		)
		SELECT 
			jsonb_build_object(
				''type'', ''FeatureCollection'',
				''features'', COALESCE(jsonb_agg(features.feature), ''[]''::jsonb)
			)
		FROM(
			SELECT jsonb_build_object(
			''type'', ''Feature'',
			''geometry'', st_asgeojson(ST_ForcePolygonCCW(ST_Transform(the_geom, 4326)))::jsonb,
			''properties'', to_jsonb(vi_t_pgully.*) - ''the_geom''
			) AS feature from vi_t_pgully) features;' INTO v_result;

	    RETURN ('{"status":"Accepted", "message":{"level":1, "text":"Process done successfully"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
             ',"data":{"result":' || v_result::text ||
                 '}'||
               '}'||
    		'}')::json;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;