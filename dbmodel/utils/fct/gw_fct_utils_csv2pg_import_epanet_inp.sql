/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE:2522
  
CREATE OR REPLACE FUNCTION ws_inp.gw_fct_utils_csv2pg_import_epanet_inp(p_csv2pgcat_id_aux integer)
  RETURNS integer AS
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
	
BEGIN

	-- Search path
	SET search_path = "ws_inp", public;

	-- GET'S
    	-- Get schema name
	schemas_array := current_schemas(FALSE);

	-- Get project type
	SELECT wsoftware INTO project_type_aux FROM version LIMIT 1;
	
	-- Get SRID
	SELECT epsg INTO epsg_val FROM version LIMIT 1;
	

	--DELETE'S
	-- delete previous registres on the audit log data table
	DELETE FROM audit_log_project where fprocesscat_id=p_csv2pgcat_id_aux AND user_name=current_user;
 
	--delete previous values
	delete from arc CASCADE;
	delete from node CASCADE;
	delete from exploitation;
	delete from macroexploitation;
	delete from sector;
	delete from dma;
	delete from inp_curve_id cascade;
	delete from ext_municipality;
	delete from cat_node;
	delete from cat_arc;
	delete from cat_mat_arc;
	delete from cat_mat_node;
	delete from inp_cat_mat_roughness;
	delete from selector_state where cur_user=current_user;
	delete from config_param_user where cur_user=current_user;
	delete from inp_tags;
	--delete from inp_pattern cascade;
	delete from inp_report cascade;
	delete from inp_times cascade;
	delete from inp_valve_importinp cascade;
	delete from inp_pump_importinp cascade;
	

	-- DISSABLE DATABASE CONSTRAINTS AND PROCEDURES
	-- disabled triggers
	ALTER TABLE node DISABLE TRIGGER gw_trg_node_update;
	ALTER TABLE arc DISABLE TRIGGER gw_trg_topocontrol_arc;

	-- dissable (temporary) inp foreign keys
	ALTER TABLE inp_junction DROP CONSTRAINT IF EXISTS inp_junction_pattern_id_fkey;
	ALTER TABLE inp_pattern_value DROP CONSTRAINT inp_pattern_value_pattern_id_fkey;
	ALTER TABLE inp_source DROP CONSTRAINT inp_source_pattern_id_fkey;
	-- ALTER TABLE inp_tags DROP CONSTRAINT inp_tags_node_id_fkey;
	ALTER TABLE inp_valve_importinp DROP CONSTRAINT inp_valve_importinp_curve_id_fkey;
	ALTER TABLE ws_inp.inp_pump_importinp DROP CONSTRAINT inp_pump_importinp_curve_id_fkey;

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
	FOR rpt_rec IN SELECT * FROM temp_csv2pg WHERE user_name=current_user AND csv2pgcat_id=p_csv2pgcat_id_aux order by id
	LOOP
		-- massive refactor of source field (getting target)
		IF rpt_rec.csv1 LIKE '[%' THEN
			v_target=rpt_rec.csv1;
		END IF;
		UPDATE temp_csv2pg SET source=v_target WHERE rpt_rec.id=temp_csv2pg.id;
 
		-- refactor of [OPTIONS] target
		IF rpt_rec.source ='[OPTIONS]' AND rpt_rec.csv1 ILIKE 'Specific' THEN UPDATE temp_csv2pg SET csv1='specific_gravity', csv2=csv3, csv3=NULL WHERE temp_csv2pg.id=rpt_rec.id; END IF;
		IF rpt_rec.source ='[OPTIONS]' AND rpt_rec.csv1 ILIKE 'Demand' THEN UPDATE temp_csv2pg SET csv1='demand_multiplier', csv2=csv3, csv3=NULL WHERE temp_csv2pg.id=rpt_rec.id; END IF;
		IF rpt_rec.source ='[OPTIONS]' AND rpt_rec.csv1 ILIKE 'Emitter' THEN UPDATE temp_csv2pg SET csv1='emitter_exponent', csv2=csv3, csv3=NULL WHERE temp_csv2pg.id=rpt_rec.id; END IF;
		IF rpt_rec.source ='[OPTIONS]' AND rpt_rec.csv1 ILIKE 'Unbalanced' THEN UPDATE temp_csv2pg SET csv2=concat(csv2,' ',csv3), csv3=NULL WHERE temp_csv2pg.id=rpt_rec.id; END IF;

		-- other refactors if we need
		-- todo
	END LOOP;

	-- CATALOGS
	--cat_feature
	--node
	/*INSERT INTO cat_feature VALUES ('EPAJUNCTION','JUNCTION','NODE');
	INSERT INTO cat_feature VALUES ('EPATANK','TANK','NODE');
	INSERT INTO cat_feature VALUES ('EPARESERVOIR','SOURCE','NODE');
	--arc
	INSERT INTO cat_feature VALUES ('EPAPIPE','PIPE','ARC');
	--nodarc
	--INSERT INTO cat_feature VALUES ('EPACHECKVALVE','VARC','ARC');
	--INSERT INTO cat_feature VALUES ('EPAFLWCONVALVE','VARC','ARC');
	--INSERT INTO cat_feature VALUES ('EPAGENPURVALVE','VARC','ARC');
	--INSERT INTO cat_feature VALUES ('EPAPREBRKVALVE','VARC','ARC');
	--INSERT INTO cat_feature VALUES ('EPAPRESUSVALVE','VARC','ARC');
	--INSERT INTO cat_feature VALUES ('EPAPREREDVALVE','VARC','ARC');
	--INSERT INTO cat_feature VALUES ('EPATHRTLEVALVE','VARC','ARC');
	versus ¿?
	INSERT INTO cat_feature VALUES ('EPAVALVE','VARC','ARC');
	INSERT INTO cat_feature VALUES ('EPAPUMP','VARC','ARC');
	
	--arc_type
	--arc
	INSERT INTO arc_type VALUES ('EPAPIPE', 'PIPE', 'PIPE', 'man_pipe', 'inp_pipe',TRUE);
	--nodarc
	--INSERT INTO arc_type VALUES ('EPACHECKVALVE', 'VARC', 'VALVE', 'man_varc', 'inp_valve_importinp',TRUE);
	--INSERT INTO arc_type VALUES ('EPAFLWCONVALVE', 'VARC', 'VALVE', 'man_varc', 'inp_valve_importinp',TRUE);
	--INSERT INTO arc_type VALUES ('EPAGENPURVALVE', 'VARC', 'VALVE', 'man_varc', 'inp_valve_importinp',TRUE);
	--INSERT INTO arc_type VALUES ('EPAPREBRKVALVE', 'VARC', 'VALVE', 'man_varc', 'inp_valve_importinp',TRUE);
	--INSERT INTO arc_type VALUES ('EPAPRESUSVALVE', 'VARC', 'VALVE', 'man_varc', 'inp_valve_importinp',TRUE);
	--INSERT INTO arc_type VALUES ('EPAPREREDVALVE', 'VARC', 'VALVE', 'man_varc', 'inp_valve_importinp',TRUE);
	--INSERT INTO arc_type VALUES ('EPATHRTLEVALVE', 'VARC', 'VALVE', 'man_varc', 'inp_valve_importinp',TRUE);
	--versus ¿?
	INSERT INTO arc_type VALUES ('EPAVALVE', 'VARC', 'PIPE', 'man_varc', 'inp_valve_importinp',TRUE);
	INSERT INTO arc_type VALUES ('EPAPUMP', 'VARC', 'PIPE', 'man_varc', 'inp_pump_importinp',TRUE);
	--node_type
	--node
	INSERT INTO node_type VALUES ('EPAJUNCTION', 'JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction',TRUE);
	INSERT INTO node_type VALUES ('EPATANK', 'TANK', 'TANK', 'man_tank', 'inp_tank',TRUE);
	INSERT INTO node_type VALUES ('EPARESERVOIR', 'SOURCE', 'RESERVOIR', 'man_source', 'inp_reservoir',TRUE);
*/
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
	SELECT DISTINCT ON (temp_csv2pg.csv6)  csv6, 'GLOBAL PERIOD', 0, 999, csv6::numeric FROM ws_inp.temp_csv2pg WHERE source='[PIPES]' AND csv1 not like ';%' and csv6 IS NOT NULL;
	
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
	FOR v_rec_table IN SELECT * FROM sys_csv2pg_config WHERE reverse_pg2csvcat_id=10
	LOOP
		--identifing the humber of fields of the editable view
		FOR v_rec_view IN SELECT row_number() over (order by v_rec_table.tablename) as rid, column_name, data_type from information_schema.columns where table_name=v_rec_table.tablename AND table_schema='ws_inp'
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
		v_sql = 'INSERT INTO '||v_rec_table.tablename||' SELECT '||v_query_fields||' FROM temp_csv2pg where source='||quote_literal(v_rec_table.target)||' 
		AND csv2pgcat_id=10 AND (csv1 NOT LIKE ''[%'' AND csv1 NOT LIKE '';%'') AND user_name='||quote_literal(current_user);

	--	raise notice 'v_sql %', v_sql;
		EXECUTE v_sql;
		
	END LOOP;


	-- CREATE GEOM'S
	--arc
	FOR v_data IN SELECT * FROM arc  LOOP

		--Insert start point, add vertices if exist, add end point

		SELECT array_agg(the_geom) INTO geom_array FROM node WHERE v_data.node_1=node_id;

		FOR rpt_rec IN SELECT * FROM temp_csv2pg WHERE user_name=current_user AND csv2pgcat_id=p_csv2pgcat_id_aux and source='[VERTICES]' AND csv1=v_data.arc_id order by id 
		LOOP	
			v_point_geom=ST_SetSrid(ST_MakePoint(rpt_rec.csv2::numeric,rpt_rec.csv3::numeric),epsg_val);
			geom_array=array_append(geom_array,v_point_geom);
		END LOOP;

		geom_array=array_append(geom_array,(SELECT the_geom FROM node WHERE v_data.node_2=node_id));

		UPDATE arc SET the_geom=ST_MakeLine(geom_array) where arc_id=v_data.arc_id;
		
	end loop;
	
	--mapzones
	EXECUTE 'SELECT ST_Multi(ST_ConvexHull(ST_Collect(the_geom))) FROM arc;'
	into v_extend_val;
	update exploitation SET the_geom=v_extend_val;
	update sector SET the_geom=v_extend_val;
	update dma SET the_geom=v_extend_val;
	update ext_municipality SET the_geom=v_extend_val;


	--ENABLE CONSTRAINTS AND PROCEDURES
	--enable constraints
	IF project_type_aux='WS' THEN
		--INSERT INTO inp_pattern SELECT DISTINCT pattern_id FROM inp_pattern_value;
		
		-- enable inp foreign keys
		--ALTER TABLE ws_inp.inp_junction ADD CONSTRAINT inp_junction_pattern_id_fkey FOREIGN KEY (pattern_id) REFERENCES ws_inp.inp_pattern (pattern_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;
		--ALTER TABLE ws_inp."inp_pattern_value" ADD CONSTRAINT "inp_pattern_value_pattern_id_fkey" FOREIGN KEY ("pattern_id") REFERENCES ws_inp."inp_pattern" ("pattern_id") ON DELETE CASCADE ON UPDATE CASCADE;
		--ALTER TABLE ws_inp."inp_source" ADD CONSTRAINT "inp_source_pattern_id_fkey" FOREIGN KEY ("pattern_id") REFERENCES ws_inp."inp_pattern" ("pattern_id") ON DELETE CASCADE ON UPDATE CASCADE;
		ALTER TABLE inp_junction ADD CONSTRAINT inp_junction_pattern_id_fkey FOREIGN KEY (pattern_id) REFERENCES inp_pattern (pattern_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;
		ALTER TABLE "inp_pattern_value" ADD CONSTRAINT "inp_pattern_value_pattern_id_fkey" FOREIGN KEY ("pattern_id") REFERENCES "inp_pattern" ("pattern_id") ON DELETE CASCADE ON UPDATE CASCADE;
		ALTER TABLE "inp_source" ADD CONSTRAINT "inp_source_pattern_id_fkey" FOREIGN KEY ("pattern_id") REFERENCES "inp_pattern" ("pattern_id") ON DELETE CASCADE ON UPDATE CASCADE;
		ALTER TABLE inp_valve_importinp ADD CONSTRAINT inp_valve_importinp_curve_id_fkey FOREIGN KEY (curve_id) REFERENCES inp_curve_id (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;
		ALTER TABLE ws_inp.inp_pump_importinp ADD CONSTRAINT inp_pump_importinp_curve_id_fkey FOREIGN KEY (curve_id) REFERENCES ws_inp.inp_curve_id (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;
		--ALTER TABLE "inp_tags" ADD CONSTRAINT "inp_tags_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
	END IF;

	--enable triggers
	ALTER TABLE node ENABLE TRIGGER gw_trg_node_update;
	ALTER TABLE arc ENABLE TRIGGER gw_trg_topocontrol_arc;
	RETURN v_count;
	
	END;
	$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
