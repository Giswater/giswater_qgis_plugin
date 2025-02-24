/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_moveconnec(p_data json)
 RETURNS json
 LANGUAGE plpgsql
AS $function$

--FUNCTION CODE: 
 *  FOR INDIVIDUAL CONNECS
SELECT SCHEMA_NAME.gw_fct_moveconnec ($${"client":{"device":4, "infoType":1, "lang":"ES"}, 
"form":{}, 
"feature":{"connecId":"124915"}, 
"data":{"distance":1}}$$);

 *  FOR MASSIVE CONNECS
SELECT SCHEMA_NAME.gw_fct_moveconnec (CONCAT('{"client":{"device":4, "infoType":1, "lang":"ES"}, 
"form":{}, "feature":{"connecId":"', connec_id, '"}, 
"data":{"distance":4, "plotLayer":"migra_alhencin.parcels_alhendin", "ramalLayer":"migra.alhencin.ramal"}}')::json) from connec
where connec_id in ('125552', '125553');


 *  TAKE INTO ACCOUNT CADASTRAL PLOT LAYER
SELECT SCHEMA_NAME.gw_fct_moveconnec ($${"client":{"device":4, "infoType":1, "lang":"ES"}, 
"form":{}, 
"feature":{"connecId":"124915"}, 
"data":{"distance":1, "plotLayer":"null"}}$$);


 *  TAKE INTO ACCOUNT CADASTRAL PLOT LAYER AND RAMALES
SELECT SCHEMA_NAME.gw_fct_moveconnec ($${"client":{"device":4, "infoType":1, "lang":"ES"}, 
"form":{}, "feature":{"connecId":"125943"}, 
"data":{"distance":4, "plotLayer":"migra_alhencin.parcels_alhendin", "ramalLayer":"migra.alhencin.ramal"}}$$);





* PRIORIDAD:
	ramal > parcela > tramo

* PROCESO:
1-miro si tiene ramales. 
	si tiene - > palante
	no tiene -> continuo
	
2-miro si tiene parcelas. 
	si dentro de parcela
		si connec está encima de tramo
		si connec está fuera de tramo
	no tiene parcelas
		si connec está encima de tramo
		si connec está fuera de tramo
		
	
3-si no tiene ramales ni parcelas -> miro si hay connecs sobre tramo
	si hay connec sobre tramo
		muevo el connec hacia el lado con más espacio libre
		conecto al tramo que tenía debajo
	no hay connec sobre tramo
		continua
		
	

 
*/

DECLARE

p_action text;

v_srid integer;
v_connec text;
v_distance float;
v_arc record;
v_version text;
v_project text;
v_sql text;
v_sql_aux text;
v_rec_plot record;
v_rec record;
v_arc_geom public.geometry;
v_mec record;
v_connec_geom public.geometry;
v_count integer;
v_error_context text;
v_plot_layer text;
v_geom_column text;

v_rec_point_final record;
v_point_final_reverse public.geometry;
v_ramal_layer text;
v_ramal_table text;
v_ramal_geom text;
v_percent_ramal numeric;
v_closest_parcel public.geometry;
v_point_final public.geometry;


v_sql_connec_parcel text;
v_sql_connec_tram text;

v_sql_parcel text;
v_sql_ramal text;

v_sql_final_point text;
v_sql_final_reverse_point text;


BEGIN

	-- Set search path to local schema
	SET search_path = "SCHEMA_NAME", public;

	-- get system variables
	SELECT  giswater, upper(project_type) INTO v_version, v_project FROM sys_version order by id desc limit 1;
	SELECT epsg into v_srid FROM sys_version limit 1;

	-- get parameters
	v_connec = (((p_data ->>'feature')::json->>'connecId'))::text;
	v_distance = (((p_data ->>'data')::json->>'distance'))::numeric;
	v_plot_layer = (((p_data ->>'data')::json->>'plotLayer'))::text;
	v_ramal_layer = (((p_data ->>'data')::json->>'ramalLayer'))::text;

	select the_geom into v_connec_geom from connec where connec_id = v_connec;


	
	-- sql to check if layers exist
	v_sql_parcel = 'select table_name, column_name from information_schema.columns where table_schema =  split_part('||quote_literal(v_plot_layer)||', ''.'', 1)
	and	table_name = split_part('||quote_literal(v_plot_layer)||', ''.'', 2) and column_name ilike ''%geom%''';


	v_sql_ramal = 'select table_name, column_name from information_schema.columns where table_schema =  split_part('||quote_literal(v_ramal_layer)||', ''.'', 1)
	and	table_name = split_part('||quote_literal(v_ramal_layer)||', ''.'', 2) and column_name ilike ''%geom%''';


	-- si está encima de tramo
	v_sql_connec_tram = '
	select c.connec_id, c.the_geom from connec c, arc a
		where st_dwithin(c.the_geom, a.the_geom, 0.01)
		and connec_id = '||quote_literal(v_connec)||' limit 1';
	
	

	-- sql si existe tabla de parceles
	execute 'select count(*) from ('||v_sql_parcel||')a' into v_count;

	if v_count > 0 then -- existe tabla de parceles
	
		execute v_sql_parcel into v_rec_plot;
	
		v_sql_connec_parcel = '
		select c.connec_id, c.the_geom from connec c, '||v_plot_layer||' p 
		where st_dwithin(c.the_geom, p.'||v_rec_plot.column_name||', 0.01)
		and connec_id = '||quote_literal(v_connec)||'' limit 1;
	
		execute 'select pa.'||v_rec_plot.column_name||' from '||v_plot_layer||' pa, connec c 
		where st_dwithin(c.the_geom, pa.'||v_rec_plot.column_name||', 20) 
		and c.connec_id = '||quote_literal(v_connec)||'
		order by st_distance(c.the_geom, pa.'||v_rec_plot.column_name||') limit 1
		' into v_closest_parcel;
		
	
	end if;

	
	-- posiciones a banda i banda de la posición original del connec
	v_sql_final_point = '
		with mec as ( --cojo el connec tal y el arco está debajo suyo
			select c.connec_id, c.the_geom as connec_geom, a.arc_id, a.the_geom as arc_geom from v_edit_arc a, v_edit_connec c 
			where st_dwithin(a.the_geom, c.the_geom, 0.01) and c.connec_id = '||quote_literal(v_connec)||'
		), percent_line as ( --porcentaje de la linia dnde se encuentra el connec
			select mec.*, st_linelocatepoint(arc_geom, connec_geom) as percent_connec from mec
		), angles as (
			select percent_line.*, st_azimuth(connec_geom, ST_LineInterpolatePoint(arc_geom, percent_connec)) as angle_final from percent_line
		)
		select angles.*, st_transform(st_project(st_transform(connec_geom, 4326), '||v_distance||', angle_final)::geometry, '||v_srid||') as point_final 
		from angles limit 1';
	
	execute v_sql_final_point into v_rec_point_final;


	v_sql_final_reverse_point =
	'with subq as ('||v_sql_final_point||') select
		st_setsrid(st_makepoint(
			2*st_x(connec_geom)-st_x(point_final), 
			2*st_y(connec_geom)-st_y(point_final)
		), '||v_srid||') as point_final from subq';
	
	execute v_sql_final_reverse_point into v_point_final_reverse;

	

	raise notice 'connec_id, arc_id: % %', v_connec, v_rec_point_final.arc_id;
-----------------

	-- si HAY ramal, hacerlo

	--raise exception 'v_sql_ramal %', v_sql_ramal;


	execute 'select count(*) from ('||v_sql_ramal||')a' into v_count;

	if v_count > 0 then --existe una capa de ramal con geometria
		
		execute v_sql_ramal into v_ramal_table, v_ramal_geom;
	
		-- busca els connecs que tocan a un ramal y a un tramo
		v_sql = 'select c.connec_id, c.the_geom as connec_geom, a.arc_id, a.the_geom as arc_geom, r.geom as ramal_geom from connec c, '||v_ramal_layer||' r, arc a 
		where st_dwithin(c.the_geom, r.geom, 0.01) 
		and st_dwithin (a.the_geom, c.the_geom, 0.01)
		';
	
		execute 'select count(*) from ('||v_sql||')a' into v_count;
	
		if v_count > 0 then -- hacer cosas con el ramal

			execute 'select connec_id, ramal_geom, st_linelocatepoint((ST_Dump(ramal_geom)).geom, connec_geom) from ('||v_sql||')a
			where connec_id = '||quote_literal(v_connec)||''
			into v_percent_ramal;
		
			if v_percent_ramal >= 0.6 then  --el connec está en el endpoint del ramal -> hay que updatera su geometria para que sea el startpoint del ramal
			
				EXECUTE '
				update connec c set the_geom = st_startpoint(a.ramal_geom) from ('||v_sql||')a
				where c.connec_id = a.connec_id and c.connec_id = '||quote_literal(v_connec)||'';
		
			elsif v_percent_ramal <= 0.6 then -- el connec está en el startpoint del ramal -> hay que updatear su geometrai para que sea el endpoint del ramal
			
				EXECUTE '
				update connec c set the_geom = st_endpoint(a.ramal_geom) from ('||v_sql||')a
				where c.connec_id = a.connec_id and c.connec_id = '||quote_literal(v_connec)||'';
		
			end if;	
		
				
		end if;
		
	
	end if;


	-- si no hay ramal: mira si tiene la capa de parcelas

	execute 'select count(*) from ('||v_sql_parcel||')a' into v_count;

	
	-- SI QUIERE TENER EN CUENTA LAS PARCELAS!
	if v_count > 0 then		
		
		-- mirar si el connec está dentro de parcela
		execute 'select count(*) from ('||v_sql_connec_parcel||')a' into v_count;
		
	
		if v_count > 0 then -- connec dentro de parcela
			
			execute 'select count(*) from ('||v_sql_connec_tram||')a' into v_count;
		
			if v_count > 0 then -- dentro de parcela + encima de tramo		
			
				if (st_distance(st_centroid(v_closest_parcel), v_rec_point_final.point_final) > 
					st_distance(st_centroid(v_closest_parcel), v_connec_geom)) then
								
					update connec set the_geom = v_point_final_reverse where connec_id = v_connec;
			
				else
					
					update connec set the_geom = v_rec_point_final.point_final where connec_id = v_connec;
						
				end if;
			
				execute 'SELECT gw_fct_setlinktonetwork($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{"id":"['||v_connec||']"},
				"data":{"feature_type":"CONNEC", "forcedArcs":"['||v_rec_point_final.arc_id||']"}}$$)';
			
				return '{"sucess connec_id":"'||v_connec||'"}';
				
			else -- dentro de la parcela + fuera del tramo
					
			
				execute 'SELECT gw_fct_setlinktonetwork($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":25830}, 
				"form":{}, "feature":{"id":"['||v_connec||']"}, "data":{"filterFields":{}, "pageInfo":{}, "feature_type":"CONNEC"}}$$);
				';
				return '{"sucess connec_id":"'||v_connec||'"}';
	
			end if; 
		
		else -- connec fuera de parcela
			
			execute 'select count(*) from ('||v_sql_connec_tram||')a' into v_count;	

			if v_count > 0 then -- fuera de parcela + encima de tramo		
				--tamos dentro de este if

				if (st_distance(st_centroid(v_closest_parcel), v_rec_point_final.point_final) > 
					st_distance(st_centroid(v_closest_parcel), v_connec_geom)) then
							
					--raise exception 'v_rec_point_final.point_final %', v_rec_point_final.point_final;
					update connec set the_geom = v_point_final_reverse where connec_id = v_connec;
				
					raise notice 'v_rec_point_final %', v_rec_point_final.arc_id;
					execute 'SELECT gw_fct_setlinktonetwork($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{"id":"['||v_connec||']"},
					"data":{"feature_type":"CONNEC", "forcedArcs":"['||v_rec_point_final.arc_id||']"}}$$)';
	
				else -- fuera de parcela + fuera dle tramo
					
					update connec set the_geom = v_rec_point_final.point_final where connec_id = v_connec;	
				
					raise notice 'v_rec_point_final %', v_rec_point_final.arc_id;
					execute 'SELECT gw_fct_setlinktonetwork($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{"id":"['||v_connec||']"},
					"data":{"feature_type":"CONNEC", "forcedArcs":"[]"}}$$)';
						
				end if;
			
			
				return '{"sucess connec_id":"'||v_connec||'"}';
			
			else -- fuera de la parcela + fuera del tramo
			
				execute 'SELECT gw_fct_setlinktonetwork($${
				"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":25830}, 
				"form":{}, 
				"feature":{"id":"['||v_connec||']"}, 
				"data":{"filterFields":{}, "pageInfo":{}, "feature_type":"CONNEC"}}$$)
				';
			
				return '{"sucess connec_id":"'||v_connec||'"}';

			end if; 

		end if;
	
  -- si no quiere tener en cuenta la parcela:
	else
		
		-- saber si el connec está encima del arco (v_count del v_rec).
		execute 'select * from ('||v_sql_connec_tram||')a' INTO v_count;
	
		if v_count > 0 then --el connec está encima de tramo
			
			-- update geom of connec
			update connec set the_geom = v_rec.point_final where connec_id = v_connec;
		
			v_sql = 'SELECT gw_fct_setlinktonetwork($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{"id":"['||v_connec||']"},
			"data":{"feature_type":"CONNEC", "forcedArcs":"['||v_rec_point_final.arc_id||']"}}$$);';
		
		end if; 
	
		v_sql = 'SELECT gw_fct_setlinktonetwork($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":25830}, "form":{}, 
		"feature":{"id":"['||v_connec||']"}, "data":{"filterFields":{}, "pageInfo":{}, "feature_type":"CONNEC"}}$$);';
		
		execute v_sql;

	
	end if;

	--raise exception 'final';

	-- control null values on geom
	if v_rec_point_final.point_final is null or v_point_final_reverse is null then 
	
		raise exception 'la geom final ha arribat null % %', v_rec_point_final.point_final, v_point_final_reverse;
	
	end if;
	--return definition

	--raise exception 'final';
	--  Exception handling
	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = pg_exception_context;  

	RETURN json_build_object(
    'status', 'Failed', 
    'NOSQLERR', SQLERRM, 
    'message', json_build_object(
        'level', right(SQLSTATE, 1), 
        'text', SQLERRM
    ), 
    'SQLSTATE', SQLSTATE, 
    'SQLCONTEXT', v_error_context,
    'details', json_build_object(
        'connec_id', v_connec, 
        --'closest_arc', v_rec_point_final.arc_id, 
        'closest_parcel', v_closest_parcel
    )
)::json;



END;
$function$
;
