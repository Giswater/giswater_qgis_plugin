/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE:2524
  
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_utils_csv2pg_import_swmm_inp(p_path text)
  RETURNS integer AS

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_utils_csv2pg_import_swmm_inp('D:\dades\test.inp');
SELECT SCHEMA_NAME.gw_fct_utils_csv2pg_import_swmm_inp(NULL);

*/

$BODY$
	DECLARE
	rpt_rec record;
	epsg_val integer;
	v_point_geom public.geometry;
	v_line_geom public.geometry;
	schemas_array name[];
	v_target text;
	v_count integer=0;
	project_type_aux varchar;
	geom_array public.geometry array;
	v_data record;
	v_extend_val public.geometry;
	v_rec_table record;
	v_query_fields text;
	v_rec_view record;
	v_sql text;
	v_csv2pgcat_id integer =12;
	v_thegeom public.geometry;
	v_node_id text;
	v_node1 text;
	v_node2 text;
	v_elevation float;
	v_arc2node_reverse boolean = true; -- MOST IMPORTANT variable of this function. When true importation will be used making and arc2node reverse transformation for pumps and valves. Only works using Giswater sintaxis of additional pumps
	v_delete_prev boolean = true; -- used on dev mode to
	v_querytext text;
	v_nodecat text;
	i integer=1;
	v_arc_id text;
	v_id text;
	v_mantablename text;
	v_epatablename text;
	
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

	IF v_delete_prev THEN

		DELETE FROM rpt_cat_result;
		
		-- Disable constraints
		PERFORM gw_fct_admin_schema_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"DROP"}}$$);

		-- Delete system and user catalogs
		DELETE FROM macroexploitation;
		DELETE FROM exploitation;
		DELETE FROM sector;
		DELETE FROM dma;
		DELETE FROM ext_municipality;
		DELETE FROM selector_expl;
		DELETE FROM selector_state;

		DELETE FROM arc_type ;
		DELETE FROM node_type ;
		DELETE FROM connec_type ;
		DELETE FROM gully_type ;
		DELETE FROM cat_feature;
		DELETE FROM cat_mat_arc;
		DELETE FROM cat_mat_node;
		DELETE FROM cat_arc;
		DELETE FROM cat_node;
	
 
		-- Delete data
		DELETE FROM node;
		DELETE FROM arc;

		DELETE FROM man_storage;
		DELETE FROM man_junction;
		DELETE FROM man_outfall;
		DELETE FROM man_manhole;
		DELETE FROM man_conduit;
		DELETE FROM man_varc;

	
		DELETE FROM config_param_user ;

		FOR v_id IN SELECT id FROM audit_cat_table WHERE (sys_role_id='role_epa' AND id NOT LIKE 'v%') and  id not like 'inp_%'
		LOOP 
			RAISE NOTICE 'v_id %', v_id;
			EXECUTE 'DELETE FROM '||quote_ident(v_id);
		END LOOP;
			
	ELSE 
		-- Disable constraints
		PERFORM gw_fct_admin_schema_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"DROP"}}$$);		
	END IF;
	
	-- use the copy function of postgres to import from file in case of file must be provided as a parameter
	IF p_path IS NOT NULL THEN
		EXECUTE 'SELECT gw_fct_utils_csv2pg_import_temp_data('||quote_literal(v_csv2pgcat_id)||','||quote_literal(p_path)||' )';
	END IF;

	-- Harmonize the source table
	FOR rpt_rec IN SELECT * FROM temp_csv2pg WHERE user_name=current_user AND csv2pgcat_id=v_csv2pgcat_id order by id
	LOOP
		-- massive refactor of source field (getting target)
		--Fill in the fields source with the name of the target in order to refactor and read data correctly
		IF rpt_rec.csv1 LIKE '[%' THEN
			v_target=rpt_rec.csv1;
		END IF;
		UPDATE temp_csv2pg SET source=v_target WHERE rpt_rec.id=temp_csv2pg.id;

		raise notice '1st loop %', rpt_rec;
	END LOOP;
		-- refactor of [OPTIONS] target
		--Target in order to insert them to the tables using editable views, which have different values concatenated into one field. 
		--Those values are later separated using the trigger in order to put it in corresponding fields if necessary.
		--Concatenation is made using ';' when the values need the separation in the next step (trigger) and by ' ' when they are inserted into the same field.

	FOR rpt_rec IN SELECT * FROM temp_csv2pg WHERE user_name=current_user AND csv2pgcat_id=v_csv2pgcat_id order by id
	LOOP

		raise notice 'Second loop %', rpt_rec;

		IF rpt_rec.source ='[TEMPERATURE]' AND rpt_rec.csv3 is not null THEN 
			IF rpt_rec.csv1 LIKE 'TIMESERIES' OR rpt_rec.csv1 LIKE 'FILE' OR rpt_rec.csv1 LIKE 'SNOWMELT' THEN
				UPDATE temp_csv2pg SET csv2=concat(csv2,' ',csv3,' ',csv4,' ',csv5,' ',csv6,' ',csv7,' ',csv8,' ',csv9,' ',csv10,' ',csv11,' ',csv12,' ',csv13,' ',csv14,' ',csv15,' ',csv16 ),
				csv3=null, csv4=null,csv5=null,csv6=null,csv7=null, csv8=null, csv9=null,csv10=null,csv11=null,csv12=null, csv13=null, csv14=null,csv15=null,csv16=null WHERE temp_csv2pg.id=rpt_rec.id;
			ELSE
				UPDATE temp_csv2pg SET csv1=concat(csv1,' ',csv2),csv2=concat(csv3,' ',csv4,' ',csv5,' ',csv6,' ',csv7,' ',csv8,' ',csv9,' ',csv10,' ',csv11,' ',csv12,' ',csv13,' ',csv14,' ',csv15,' ',csv16 ),
				csv3=null, csv4=null,csv5=null,csv6=null,csv7=null, csv8=null, csv9=null,csv10=null,csv11=null,csv12=null, csv13=null, csv14=null,csv15=null,csv16=null WHERE temp_csv2pg.id=rpt_rec.id;
			END IF;
		END IF;

		/*					
		IF rpt_rec.source LIKE '%TRANSECTS%'  AND rpt_rec.csv2 is not null THEN 
			UPDATE temp_csv2pg SET csv1=(concat(csv1,' ',csv2,' ',csv3,' ',csv4,' ',csv5,' ',csv6,' ',csv7,' ',csv8,' ',csv9,' ',csv10,' ',csv11,' ',csv12,' ',csv13)), 
			csv2=null,csv3=null, csv4=null, csv5=null, csv6=null, csv7=null,csv8=null, csv9=null,csv10=null, csv11=null,csv12=null,csv13=null WHERE temp_csv2pg.id=rpt_rec.id; 
		END IF;	
			
		IF rpt_rec.source LIKE '[CONTROLS%'  AND rpt_rec.csv2 is not null THEN 
			UPDATE temp_csv2pg SET csv1=(concat(csv1,' ',csv2,' ',csv3,' ',csv4,' ',csv5,' ',csv6,' ',csv7,' ',csv8,' ',csv9,' ',csv10,' ',csv11,' ',csv12,' ',csv13)), 
			csv2=null, csv3=null, csv4=null, csv5=null, csv6=null, csv7=null, csv8=null, csv9=null, csv10=null, csv11=null,csv12=null,csv13=null WHERE temp_csv2pg.id=rpt_rec.id; 
		END IF;	
		*/
			
		IF rpt_rec.source LIKE '%TREATMENT%'  AND rpt_rec.csv2 is not null THEN 
			UPDATE temp_csv2pg SET csv3=(concat(csv3,' ',csv4,' ',csv5,' ',csv6,' ',csv7,' ',csv8,' ',csv9,' ',csv10,' ',csv11,' ',csv12,' ',csv13)), 
			csv4=null, csv5=null, csv6=null, csv7=null, csv8=null, csv9=null, csv10=null, csv11=null,csv12=null,csv13=null WHERE temp_csv2pg.id=rpt_rec.id; 
		END IF;	
			
		IF rpt_rec.source LIKE '%HYDROGRAPH%'  AND rpt_rec.csv2 is not null THEN 
			UPDATE temp_csv2pg SET csv1=(concat(csv1,' ',csv2,' ',csv3,' ',csv4,' ',csv5,' ',csv6,' ',csv7,' ',csv8,' ',csv9,' ',csv10,' ',csv11,' ',csv12,' ',csv13)), 
			csv2=null, csv3=null,csv4=null, csv5=null, csv6=null, csv7=null, csv8=null, csv9=null, csv10=null, csv11=null,csv12=null,csv13=null WHERE temp_csv2pg.id=rpt_rec.id; 
		END IF;	
		
		IF rpt_rec.source LIKE '%ADJUSTMENT%'  AND rpt_rec.csv3 is not null THEN 
			UPDATE temp_csv2pg SET csv2=concat(csv2,';',csv3,';',csv4,';',csv5,';',csv6,';',csv7,';',csv8,';',csv9,';',csv10,';',csv11,';',csv12,';',csv13),
			csv3=null,csv4=null,csv5=null,csv6=null,csv7=null,csv8=null,csv9=null,csv10=null,csv11=null,csv12=null,csv13=null WHERE temp_csv2pg.id=rpt_rec.id; 
		END IF;
		
		IF rpt_rec.source LIKE '%MAP%'  AND rpt_rec.csv3 is not null THEN 
			UPDATE temp_csv2pg SET csv2=concat(csv2,';',csv3,';',csv4,';',csv5),csv3=null,csv4=null,csv5=null WHERE temp_csv2pg.id=rpt_rec.id; 
		END IF;	
					
		IF rpt_rec.source LIKE '%GWF%' AND rpt_rec.csv4 is not null THEN 
			UPDATE temp_csv2pg SET csv2=concat(csv2,';',csv3),csv3=concat(csv4,';',csv5),csv4=null,csv5=null WHERE temp_csv2pg.id=rpt_rec.id; 
		END IF;	
			
		IF rpt_rec.source LIKE '%BACKDROP%' AND rpt_rec.csv2 is not null THEN 
			UPDATE temp_csv2pg SET csv1=concat(csv1,' ',csv2,' ',csv3,' ',csv4,' ',csv5,' ',csv6),
			csv2=null, csv3=null,csv4=null, csv5=null,csv6=null WHERE temp_csv2pg.id=rpt_rec.id; 
		END IF;	
	
		IF rpt_rec.source LIKE '%EVAPORATION%' AND rpt_rec.csv3 is not null THEN 
			UPDATE temp_csv2pg SET csv2=concat(csv2,';',csv3,';',csv4,';',csv5,';',csv6,csv7,';',csv8,';',csv9,';',csv10,';',csv11,';',csv12,';',csv13),
			csv3=null,csv4=null, csv5=null,csv6=null,csv7=null,csv8=null,csv9=null,csv10=null,csv11=null,csv12=null,csv13=null WHERE temp_csv2pg.id=rpt_rec.id; 
		END IF;	
	END LOOP;
	
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

	-- CATALOGS
	--cat_feature
	--node
	INSERT INTO cat_feature VALUES ('EPAMANH','JUNCTION','NODE');
	INSERT INTO cat_feature VALUES ('EPAOUTF','OUTFALL','NODE');
	INSERT INTO cat_feature VALUES ('EPASTOR','STORAGE','NODE');
	
	--arc
	INSERT INTO cat_feature VALUES ('EPACOND','CONDUIT','ARC');
	--nodarc
	INSERT INTO cat_feature VALUES ('EPAWEIR','VARC','ARC');
	INSERT INTO cat_feature VALUES ('EPAPUMP','VARC','ARC');
	INSERT INTO cat_feature VALUES ('EPAORIF','VARC','ARC');
	INSERT INTO cat_feature VALUES ('EPAOUTL','VARC','ARC');
	
	--arc_type
	--arc
	INSERT INTO arc_type VALUES ('EPACOND', 'CONDUIT', 'CONDUIT', 'man_conduit', 'inp_conduit', TRUE);
	INSERT INTO arc_type VALUES ('EPAWEIR', 'VARC', 'WEIR', 'man_varc', 'inp_weir', TRUE);
	INSERT INTO arc_type VALUES ('EPAORIF', 'VARC', 'ORIFICE', 'man_varc', 'inp_orifice', TRUE);
	INSERT INTO arc_type VALUES ('EPAPUMP', 'VARC', 'PUMP', 'man_varc', 'inp_pump', TRUE);
	INSERT INTO arc_type VALUES ('EPAOUTL', 'VARC', 'OUTLET', 'man_varc', 'inp_outlet', TRUE);

	--node_type
	INSERT INTO node_type VALUES ('EPAMANH', 'MANHOLE', 'JUNCTION', 'man_manhole', 'inp_junction', TRUE);
	INSERT INTO node_type VALUES ('EPAOUTF', 'OUTFALL', 'OUTFALL', 'man_outfall', 'inp_outfall', TRUE);
	INSERT INTO node_type VALUES ('EPASTOR', 'STORAGE', 'STORAGE', 'man_storage', 'inp_storage', TRUE);

	--cat_mat_node 
	INSERT INTO cat_mat_node VALUES ('EPAMAT');
	INSERT INTO cat_mat_arc VALUES ('EPAMAT');
	
	--cat_node
	INSERT INTO cat_node VALUES ('EPAMANH-CAT', 'EPAMAT');
	INSERT INTO cat_node VALUES ('EPAOUTF-CAT', 'EPAMAT');
	INSERT INTO cat_node VALUES ('EPASTOR-CAT', 'EPAMAT');

	-- cat_arc
	INSERT INTO cat_arc VALUES ('EPAWEIR-CAT', 'EPAMAT');
	INSERT INTO cat_arc VALUES ('EPAORIF-CAT', 'EPAMAT');
	INSERT INTO cat_arc VALUES ('EPAPUMP-CAT', 'EPAMAT');
	INSERT INTO cat_arc VALUES ('EPAOUTL-CAT', 'EPAMAT');


	-- LOOPING THE EDITABLE VIEWS TO INSERT DATA
	FOR v_rec_table IN SELECT * FROM sys_csv2pg_config WHERE reverse_pg2csvcat_id=v_csv2pgcat_id order by id
	LOOP

		raise notice 'Third loop %', v_rec_table;

		--identifing the humber of fields of the editable view
		FOR v_rec_view IN SELECT row_number() over (order by v_rec_table.tablename) as rid, column_name, data_type from information_schema.columns where table_name=v_rec_table.tablename AND table_schema='SCHEMA_NAME'
		LOOP
			IF v_rec_view.rid=1 THEN
				v_query_fields = concat ('csv',v_rec_view.rid,'::',v_rec_view.data_type);
			ELSE
				v_query_fields = concat (v_query_fields,' , csv',v_rec_view.rid,'::',v_rec_view.data_type);
			END IF;
		END LOOP;
		
		--inserting values on editable view
		v_sql = 'INSERT INTO '||v_rec_table.tablename||' SELECT '||v_query_fields||' FROM temp_csv2pg where source like '||quote_literal(concat('%',v_rec_table.target,'%'))||' 
		AND csv2pgcat_id='||v_csv2pgcat_id||' AND (csv1 NOT LIKE ''[%'' AND csv1 NOT LIKE '';%'') AND user_name='||quote_literal(current_user);

		raise notice 'v_sql %', v_sql;
		EXECUTE v_sql;
	END LOOP;
		
	-- Create arc geom
	v_querytext = 'SELECT * FROM arc ';
		
	FOR v_data IN EXECUTE v_querytext
	LOOP

		raise notice 'Fifth loop %', v_data;

		--Insert start point, add vertices if exist, add end point
		SELECT array_agg(the_geom) INTO geom_array FROM node WHERE v_data.node_1=node_id;
		FOR rpt_rec IN SELECT * FROM temp_csv2pg WHERE user_name=current_user AND csv2pgcat_id=v_csv2pgcat_id and source='[VERTICES]' AND csv1=v_data.arc_id order by id 
		LOOP	
			v_point_geom=ST_SetSrid(ST_MakePoint(rpt_rec.csv2::numeric,rpt_rec.csv3::numeric),epsg_val);
			geom_array=array_append(geom_array,v_point_geom);
		END LOOP;

		geom_array=array_append(geom_array,(SELECT the_geom FROM node WHERE v_data.node_2=node_id));

		UPDATE arc SET the_geom=ST_MakeLine(geom_array) where arc_id=v_data.arc_id;

	END LOOP;
	
	-- Subcatchments geometry
	--Create points out of vertices defined in inp file create a line out all points and transform it into a polygon.
	FOR v_data IN SELECT * FROM subcatchment LOOP

		raise notice 'Six loop %', v_data;
	
		FOR rpt_rec IN SELECT * FROM temp_csv2pg WHERE user_name=current_user AND csv2pgcat_id=v_csv2pgcat_id and source ilike '[Polygons]' AND csv1=v_data.subc_id order by id 
		LOOP	
			raise notice 'Six-inter loop %', v_data;

			v_point_geom=ST_SetSrid(ST_MakePoint(rpt_rec.csv2::numeric,rpt_rec.csv3::numeric),epsg_val);
			INSERT INTO temp_table (text_column,geom_point) VALUES (v_data.subc_id,v_point_geom);

			--geom_array=array_append(geom_array,v_point_geom);
		END LOOP;
		SELECT ARRAY(SELECT geom_point FROM temp_table WHERE text_column=v_data.subc_id) into geom_array;
		v_line_geom=ST_MakeLine(geom_array);
		INSERT INTO temp_table (text_column,geom_line) VALUES (v_data.subc_id,v_line_geom);
		IF array_length(geom_array, 1) > 3 THEN
				v_line_geom=ST_MakeLine(geom_array);
				INSERT INTO temp_table (text_column,geom_line) VALUES (v_data.subc_id,v_line_geom);

				IF ST_IsClosed(v_line_geom) THEN
					UPDATE subcatchment SET the_geom=ST_Multi(ST_Polygon(v_line_geom,epsg_val)) where subc_id=v_data.subc_id;
					INSERT INTO temp_table (geom_line) VALUES (v_line_geom);
				ELSE
					v_line_geom = ST_AddPoint(v_line_geom, ST_StartPoint(v_line_geom));
					IF ST_IsClosed(v_line_geom) THEN
						UPDATE subcatchment SET the_geom=ST_Multi(ST_Polygon(v_line_geom,epsg_val)) where subc_id=v_data.subc_id;
						INSERT INTO temp_table (geom_line) VALUES (v_line_geom);
					ELSE
						RAISE NOTICE 'The polygon cant be created because the geometry is not closed. Subc_id: ,%', v_data.subc_id;
					END IF;
				END IF;
			ELSE 
				RAISE NOTICE 'The polygonn cant be created because it has less than 4 vertexes. Subc_id: ,%', v_data.subc_id;
			END IF;
		
	END LOOP;
		
	-- Mapzones geometry
	--Create the same geometry of all mapzones by making the Convex Hull over all the existing arcs
	EXECUTE 'SELECT ST_Multi(ST_ConvexHull(ST_Collect(the_geom))) FROM arc;'
	into v_extend_val;
	update exploitation SET the_geom=v_extend_val;
	update sector SET the_geom=v_extend_val;
	update dma SET the_geom=v_extend_val;
	update ext_municipality SET the_geom=v_extend_val;

	-- Enable constraints
	PERFORM gw_fct_admin_schema_manage_ct($${"client":{"lang":"ES"},"data":{"action":"ADD"}}$$);
	
RETURN v_count;
	
END;
$BODY$
LANGUAGE plpgsql VOLATILE
COST 100;
