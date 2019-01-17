/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE:2522
  
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_utils_csv2pg_import_epanet_inp(p_csv2pgcat_id integer, p_path text)
  RETURNS integer AS

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_utils_csv2pg_import_epanet_inp('D:\dades\test.inp')
*/

$BODY$
	DECLARE
	rpt_rec record;
	epsg_val integer;
	v_point_geom public.geometry;
	v_value text;
	v_config_fields record;
	v_query_text text;
	schemas_array name[];
	v_table_pkey text;
	v_column_type text;
	v_pkey_column_type text;
	v_pkey_value text;
	v_tablename text;
	v_fields record;
	v_target text;
	v_count integer=0;
	project_type_aux varchar;
	v_xcoord numeric;
	v_ycoord numeric;
	geom_array public.geometry array;
	v_data record;
	id_last text;
	v_typevalue text;
	v_extend_val public.geometry;
	v_rec_table record;
	v_query_fields text;
	v_num_column integer;
	v_rec_view record;
	v_sql text;
	v_split text;
	v_newproject boolean=TRUE;
	
BEGIN

	-- Search path
	SET search_path = "SCHEMA_NAME", public;

	-- GET'S
    	-- Get schema name
	schemas_array := current_schemas(FALSE);

	-- Get project type
	SELECT wsoftware INTO project_type_aux FROM version LIMIT 1;
	
	-- Get SRID
	SELECT epsg INTO epsg_val FROM version LIMIT 1;

	-- use the copy function of postgres to import from file in case of file must be provided as a parameter
	IF p_path IS NOT NULL THEN
		EXECUTE 'SELECT gw_fct_utils_csv2pg_import_temp_data('||quote_literal(p_csv2pgcat_id)||','||quote_literal(p_path)||' )';
	END IF;

	-- MAPZONES
	INSERT INTO macroexploitation(macroexpl_id,name) VALUES(1,'macroexploitation1');
	INSERT INTO exploitation(expl_id,name,macroexpl_id) VALUES(1,'exploitation1',1);
	INSERT INTO sector(sector_id,name) VALUES(1,'sector1');
	INSERT INTO dma(dma_id,name) VALUES(1,'dma1');
	INSERT INTO ext_municipality(muni_id,name) VALUES(1,'municipality1');

	-- SELECTORS
	--insert values into selector
	INSERT INTO selector_expl(expl_id,cur_user) VALUES (1,current_user);
	INSERT INTO selector_state(state_id,cur_user) VALUES (1,current_user);

	
	
	-- HARMONIZE THE SOURCE TABLE
	FOR rpt_rec IN SELECT * FROM temp_csv2pg WHERE user_name=current_user AND csv2pgcat_id=p_csv2pgcat_id order by id
	LOOP
		-- massive refactor of source field (getting target)
		IF rpt_rec.csv1 LIKE '[%' THEN
			v_target=rpt_rec.csv1;
		END IF;
		UPDATE temp_csv2pg SET source=v_target WHERE rpt_rec.id=temp_csv2pg.id;
	END LOOP;

	FOR rpt_rec IN SELECT * FROM temp_csv2pg WHERE user_name=current_user AND csv2pgcat_id=p_csv2pgcat_id order by id
	LOOP
		raise notice 'v_target,%,%', rpt_rec.source,rpt_rec.id;
		-- refactor of [OPTIONS] target
		IF rpt_rec.source ='[OPTIONS]' AND rpt_rec.csv1 ILIKE 'Specific' THEN UPDATE temp_csv2pg SET csv1='specific_gravity', csv2=csv3, csv3=NULL WHERE temp_csv2pg.id=rpt_rec.id; END IF;
		IF rpt_rec.source ='[OPTIONS]' AND rpt_rec.csv1 ILIKE 'Demand' THEN UPDATE temp_csv2pg SET csv1='demand_multiplier', csv2=csv3, csv3=NULL WHERE temp_csv2pg.id=rpt_rec.id; END IF;
		IF rpt_rec.source ='[OPTIONS]' AND rpt_rec.csv1 ILIKE 'Emitter' THEN UPDATE temp_csv2pg SET csv1='emitter_exponent', csv2=csv3, csv3=NULL WHERE temp_csv2pg.id=rpt_rec.id; END IF;
		IF rpt_rec.source ='[OPTIONS]' AND rpt_rec.csv1 ILIKE 'Unbalanced' THEN UPDATE temp_csv2pg SET csv2=concat(csv2,' ',csv3), csv3=NULL WHERE temp_csv2pg.id=rpt_rec.id; END IF;
		IF rpt_rec.source ='[TIMES]' AND rpt_rec.csv2 ILIKE 'Clocktime'  THEN 
			UPDATE temp_csv2pg SET csv1=concat(csv1,'_',csv2), csv2=concat(csv3,' ',csv4), csv3=null,csv4=null WHERE temp_csv2pg.id=rpt_rec.id; END IF;
		IF rpt_rec.source ='[TIMES]' AND (rpt_rec.csv2 ILIKE 'Timestep' OR rpt_rec.csv2 ILIKE 'Start' )THEN 
			UPDATE temp_csv2pg SET csv1=concat(csv1,'_',csv2), csv2=csv3, csv3=null WHERE temp_csv2pg.id=rpt_rec.id; END IF;

		IF rpt_rec.source ilike '[ENERGY]%' AND rpt_rec.csv1 ILIKE 'PUMP' THEN 
			UPDATE temp_csv2pg SET csv1=concat(csv1,' ',csv2,' ',csv3), csv2=csv4, csv3=null,  csv4=null WHERE temp_csv2pg.id=rpt_rec.id;
		ELSIF rpt_rec.source ilike '[ENERGY]%' AND (rpt_rec.csv1 ILIKE 'GLOBAL' OR  rpt_rec.csv1 ILIKE 'DEMAND') THEN
			UPDATE temp_csv2pg SET csv1=concat(csv1,' ',csv2), csv2=csv3, csv3=null WHERE temp_csv2pg.id=rpt_rec.id; END IF;
		IF rpt_rec.source ='[PUMPS]' and rpt_rec.csv4 ILIKE 'Power' THEN 
			UPDATE temp_csv2pg SET csv4=concat(csv5,' ',csv7,' ',csv9,' ',csv11), csv5=NULL, csv6=null, csv7=null,csv8=null,csv9=null,csv10=null,csv11=null WHERE temp_csv2pg.id=rpt_rec.id; END IF;
		IF rpt_rec.source ='[RULES]' and rpt_rec.csv2 IS NOT NULL THEN 
			UPDATE temp_csv2pg SET csv1=concat(csv1,' ',csv2,' ',csv3,' ',csv4,' ',csv5,' ',csv6,' ',csv7,' ',csv8,' ',csv9,' ',csv10 ), 
			csv2=null, csv3=null, csv4=null,csv5=NULL, csv6=null, csv7=null,csv8=null,csv9=null,csv10=null,csv11=null WHERE temp_csv2pg.id=rpt_rec.id; END IF;
		IF rpt_rec.source ='[CONTROLS]'and rpt_rec.csv2 IS NOT NULL THEN 
			UPDATE temp_csv2pg SET csv1=concat(csv1,' ',csv2,' ',csv3,' ',csv4,' ',csv5,' ',csv6,' ',csv7,' ',csv8,' ',csv9,' ',csv10 ), 
			csv2=null, csv3=null, csv4=null,csv5=NULL, csv6=null, csv7=null,csv8=null,csv9=null,csv10=null,csv11=null WHERE temp_csv2pg.id=rpt_rec.id; END IF;
		IF rpt_rec.source ='[PATTERNS]' and rpt_rec.csv3 IS NOT NULL THEN 
			UPDATE temp_csv2pg SET csv2=concat(csv2,' ',csv3,' ',csv4,' ',csv5,' ',csv6,' ',csv7,' ',csv8,' ',csv9,' ',csv10,' ',csv11,' ',csv12,' ',csv13,
			csv14,' ',csv15,' ',csv16,' ',csv17,' ',csv18,' ',csv19,' ',csv20,' ',csv21,' ',csv22,' ',csv23,' ',csv24,' ',csv25), 
			csv3=null, csv4=null,csv5=NULL, csv6=null, csv7=null,csv8=null,csv9=null,csv10=null,csv11=null,csv12=null, csv13=null,
			csv14=null,csv15=NULL, csv16=null, csv17=null,csv18=null,csv19=null,csv20=null,csv21=null,csv22=null, csv23=null,csv24=null, csv25=null
			WHERE temp_csv2pg.id=rpt_rec.id;
		END IF;
	END LOOP;

	-- CATALOGS
	--cat_feature
	--node
	INSERT INTO cat_feature VALUES ('EPAJUNCTION','JUNCTION','NODE');
	INSERT INTO cat_feature VALUES ('EPATANK','TANK','NODE');
	INSERT INTO cat_feature VALUES ('EPARESERVOIR','SOURCE','NODE');
	--arc
	INSERT INTO cat_feature VALUES ('EPAPIPE','PIPE','ARC');
	--nodarc
	INSERT INTO cat_feature VALUES ('EPACHECKVALVE','VARC','ARC');
	INSERT INTO cat_feature VALUES ('EPAFLWCONVALVE','VARC','ARC');
	INSERT INTO cat_feature VALUES ('EPAGENPURVALVE','VARC','ARC');
	INSERT INTO cat_feature VALUES ('EPAPREBRKVALVE','VARC','ARC');
	INSERT INTO cat_feature VALUES ('EPAPRESUSVALVE','VARC','ARC');
	INSERT INTO cat_feature VALUES ('EPAPREREDVALVE','VARC','ARC');
	INSERT INTO cat_feature VALUES ('EPATHRTLEVALVE','VARC','ARC');
	INSERT INTO cat_feature VALUES ('EPAVALVE','VARC','ARC');
	INSERT INTO cat_feature VALUES ('EPAPUMP','VARC','ARC');
	
	--arc_type
	--arc
	INSERT INTO arc_type VALUES ('EPAPIPE', 'PIPE', 'PIPE', 'man_pipe', 'inp_pipe',TRUE);
	--nodarc
	INSERT INTO arc_type VALUES ('EPACHECKVALVE', 'VARC', 'VALVE', 'man_varc', 'inp_valve_importinp',TRUE);
	INSERT INTO arc_type VALUES ('EPAFLWCONVALVE', 'VARC', 'VALVE', 'man_varc', 'inp_valve_importinp',TRUE);
	INSERT INTO arc_type VALUES ('EPAGENPURVALVE', 'VARC', 'VALVE', 'man_varc', 'inp_valve_importinp',TRUE);
	INSERT INTO arc_type VALUES ('EPAPREBRKVALVE', 'VARC', 'VALVE', 'man_varc', 'inp_valve_importinp',TRUE);
	INSERT INTO arc_type VALUES ('EPAPRESUSVALVE', 'VARC', 'VALVE', 'man_varc', 'inp_valve_importinp',TRUE);
	INSERT INTO arc_type VALUES ('EPAPREREDVALVE', 'VARC', 'VALVE', 'man_varc', 'inp_valve_importinp',TRUE);
	INSERT INTO arc_type VALUES ('EPATHRTLEVALVE', 'VARC', 'VALVE', 'man_varc', 'inp_valve_importinp',TRUE);
	INSERT INTO arc_type VALUES ('EPAVALVE', 'VARC', 'PIPE', 'man_varc', 'inp_valve_importinp',TRUE);
	INSERT INTO arc_type VALUES ('EPAPUMP', 'VARC', 'PIPE', 'man_varc', 'inp_pump_importinp',TRUE);
	--node_type
	--node
	INSERT INTO node_type VALUES ('EPAJUNCTION', 'JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction',TRUE);
	INSERT INTO node_type VALUES ('EPATANK', 'TANK', 'TANK', 'man_tank', 'inp_tank',TRUE);
	INSERT INTO node_type VALUES ('EPARESERVOIR', 'SOURCE', 'RESERVOIR', 'man_source', 'inp_reservoir',TRUE);

	--cat_mat_arc
	--arc
	INSERT INTO cat_mat_arc 
	SELECT DISTINCT csv6 FROM temp_csv2pg WHERE source='[PIPES]' AND csv6 IS NOT NULL;
	--nodarc
	INSERT INTO cat_mat_arc VALUES ('EPAMAT');
		
	--cat_mat_node 
	INSERT INTO cat_mat_node VALUES ('EPAMAT');

	--inp_cat_mat_roughness
	INSERT INTO inp_cat_mat_roughness (matcat_id, period_id, init_age, end_age, roughness)
	SELECT DISTINCT ON (temp_csv2pg.csv6)  csv6, 'GLOBAL PERIOD', 0, 999, csv6::numeric FROM SCHEMA_NAME.temp_csv2pg WHERE source='[PIPES]' AND csv1 not like ';%' and csv6 IS NOT NULL;
	
	--cat_arc
	--pipe w
	INSERT INTO cat_arc( id, arctype_id, matcat_id,  dnom)
	SELECT DISTINCT ON (csv6, csv5) concat(csv6::numeric(10,3),'-',csv5::numeric(10,3))::text, 'EPAPIPE', csv6, csv5 FROM temp_csv2pg WHERE source='[PIPES]' AND csv1 not like ';%' AND csv5 IS NOT NULL;
	--nodarc
	INSERT INTO cat_arc ( id, arctype_id, matcat_id,dnom) SELECT DISTINCT ON (csv5,csv4) concat(csv5,'-',csv4::numeric(10,3))::text, 'EPAVALVE', 'EPAMAT', csv4 from temp_csv2pg WHERE source='[VALVES]' AND csv1 not like ';%' AND csv5 IS NOT NULL ;
	INSERT INTO cat_arc VALUES  ('EPAPUMP-DEF', 'EPAPUMP', 'EPAMAT');

	--cat_node
	INSERT INTO cat_node VALUES ('EPAJUNCTION-DEF', 'EPAJUNCTION', 'EPAMAT');
	INSERT INTO cat_node VALUES ('EPATANK-DEF', 'EPATANK', 'EPAMAT');
	INSERT INTO cat_node VALUES ('EPARESERVOIR-DEF', 'EPARESERVOIR', 'EPAMAT');

	-- LOOPING THE EDITABLE VIEWS TO INSERT DATA
	FOR v_rec_table IN SELECT * FROM sys_csv2pg_config WHERE reverse_pg2csvcat_id=p_csv2pgcat_id
	LOOP
		--identifing the humber of fields of the editable view
		FOR v_rec_view IN SELECT row_number() over (order by v_rec_table.tablename) as rid, column_name, data_type from information_schema.columns where table_name=v_rec_table.tablename AND table_schema='SCHEMA_NAME'
		LOOP	
			IF v_rec_view.rid=1 and v_rec_table.fields not LIKE 'concat%'THEN
				v_query_fields = concat ('csv',v_rec_view.rid,'::',v_rec_view.data_type);
				
			ELSIF v_rec_view.rid=1 and v_rec_table.fields LIKE 'concat%'  then
				--insert of fields which are concatenation in first field
				v_query_fields = concat (split_part(v_rec_table.fields,';'::text,v_rec_view.rid::integer),'::',v_rec_view.data_type);
				
			ELSIF v_rec_table.fields LIKE '%concat%' THEN
				--insert of fields which are concatenation 
				v_query_fields = concat (v_query_fields,', ',split_part(v_rec_table.fields,';'::text,v_rec_view.rid::integer),'::',v_rec_view.data_type);
				
			ELSE
				v_query_fields = concat (v_query_fields,' , csv',v_rec_view.rid,'::',v_rec_view.data_type);
				
			END IF;
		END LOOP;
		
		--inserting values on editable view

		raise notice 'v_query_fields %,%', v_query_fields,v_rec_table.fields;
		
		v_sql = 'INSERT INTO '||v_rec_table.tablename||' SELECT '||v_query_fields||' FROM temp_csv2pg where source='||quote_literal(v_rec_table.target)||' 
		AND csv2pgcat_id='||p_csv2pgcat_id||'  AND (csv1 NOT LIKE ''[%'' AND csv1 NOT LIKE '';%'') AND user_name='||quote_literal(current_user);

		raise notice 'v_sql %', v_sql;
		EXECUTE v_sql;		
	END LOOP;
	
	-- Create arc geom
	FOR v_data IN SELECT * FROM arc  
	LOOP
		--Insert start point, add vertices if exist, add end point
		SELECT array_agg(the_geom) INTO geom_array FROM node WHERE v_data.node_1=node_id;
		FOR rpt_rec IN SELECT * FROM temp_csv2pg WHERE user_name=current_user AND csv2pgcat_id=p_csv2pgcat_id and source='[VERTICES]' AND csv1=v_data.arc_id order by id 
		LOOP	
			v_point_geom=ST_SetSrid(ST_MakePoint(rpt_rec.csv2::numeric,rpt_rec.csv3::numeric),epsg_val);
			geom_array=array_append(geom_array,v_point_geom);
		END LOOP;

		geom_array=array_append(geom_array,(SELECT the_geom FROM node WHERE v_data.node_2=node_id));

		UPDATE arc SET the_geom=ST_MakeLine(geom_array) where arc_id=v_data.arc_id;

	END LOOP;
	
	--mapzones
	EXECUTE 'SELECT ST_Multi(ST_ConvexHull(ST_Collect(the_geom))) FROM arc;'
	into v_extend_val;
	update exploitation SET the_geom=v_extend_val;
	update sector SET the_geom=v_extend_val;
	update dma SET the_geom=v_extend_val;
	update ext_municipality SET the_geom=v_extend_val;


	IF project_type_aux='WS' THEN
		INSERT INTO inp_pattern SELECT DISTINCT pattern_id FROM inp_pattern_value;
	END IF;


RETURN v_count;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

