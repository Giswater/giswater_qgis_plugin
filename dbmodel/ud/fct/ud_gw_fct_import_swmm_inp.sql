/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE:2524

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_utils_csv2pg_import_swmm_inp(text);
DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_utils_csv2pg_import_swmm_inp(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_import_swmm_inp(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_import_swmm_inp($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"feature":{},
"data":{"parameters":{"createSubcGeom":false}}}$$)

-- fid: 239

*/

DECLARE

rpt_rec record;
v_epsg integer;
v_point_geom public.geometry;
v_line_geom public.geometry;
schemas_array name[];
v_target text;
v_count integer=0;
v_projecttype varchar;
geom_array public.geometry array;
geom_array_vertex public.geometry array;
v_data record;
v_extend_val public.geometry;
v_rec_table record;
v_query_fields text;
v_rec_view record;
v_sql text;
v_fid integer = 239;
v_thegeom public.geometry;
v_node_id text;
v_node1 text;
v_node2 text;
v_elevation float;
v_createsubcgeom boolean = true; 
v_delete_prev boolean = true; -- used on dev mode to
v_querytext text;
v_nodecat text;
i integer=1;
v_arc_id text;
v_id text;
v_mantablename text;
v_epatablename text;
v_result json;
v_result_info json;
v_result_point json;
v_result_line json;
v_version text;
v_path text;
v_error_context text;
v_linkoffsets text;

BEGIN
	-- Search path
	SET search_path = "SCHEMA_NAME", public;

	-- get project type and srid
	SELECT project_type, epsg, giswater INTO v_projecttype, v_epsg, v_version FROM sys_version LIMIT 1;

	-- get input data
	v_createsubcgeom := (((p_data ->>'data')::json->>'parameters')::json->>'createSubcGeom')::boolean;
	v_path := ((p_data ->>'data')::json->>'parameters')::json->>'path'::text;

	-- delete previous data on log table
	DELETE FROM audit_check_data WHERE cur_user="current_user"() AND fid = 239;
	
		-- create a header
	INSERT INTO audit_check_data (fid, error_message) VALUES (239, 'IMPORT INP SWMM FILE');
	INSERT INTO audit_check_data (fid, error_message) VALUES (239, '-------------------------------');

	v_delete_prev = true;

	IF v_delete_prev THEN

		DELETE FROM rpt_cat_result;
		DELETE FROM plan_psector;
		
		-- Disable constraints
		PERFORM gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"DROP"}}$$);

		-- Delete system and user catalogs
		DELETE FROM macroexploitation;
		DELETE FROM exploitation;
		DELETE FROM sector;
		DELETE FROM dma;
		DELETE FROM ext_municipality;
		DELETE FROM selector_expl;
		DELETE FROM selector_state;

		DELETE FROM cat_feature_arc ;
		DELETE FROM cat_feature_node ;
		DELETE FROM cat_feature_connec ;
		DELETE FROM cat_feature_gully ;
		DELETE FROM cat_feature;
		DELETE FROM cat_mat_arc;
		DELETE FROM cat_mat_node;
		DELETE FROM cat_arc;
		DELETE FROM cat_node;
		DELETE FROM cat_dwf_scenario;
		DELETE FROM cat_hydrology;
	
		-- Delete data
		DELETE FROM node;
		DELETE FROM arc;

		DELETE FROM man_storage;
		DELETE FROM man_junction;
		DELETE FROM man_outfall;
		DELETE FROM man_manhole;
		DELETE FROM man_conduit;
		DELETE FROM man_varc;
		DELETE FROM config_param_user WHERE parameter ILIKE 'inp_options%' AND cur_user = current_user;
		DELETE FROM config_param_user WHERE parameter ILIKE 'inp_report%' AND cur_user = current_user;

		FOR v_id IN SELECT id FROM sys_table WHERE (sys_role ='role_edit' AND id NOT LIKE 'v%')
		LOOP 
			--RAISE NOTICE 'v_id %', v_id;
			EXECUTE 'DELETE FROM '||quote_ident(v_id);
		END LOOP;

		
		FOR v_id IN SELECT id FROM sys_table WHERE (sys_role ='role_epa' AND id NOT LIKE 'v%')
		LOOP 
			--RAISE NOTICE 'v_id %', v_id;
			EXECUTE 'DELETE FROM '||quote_ident(v_id);
		END LOOP;
			
	ELSE 
		-- Disable constraints
		PERFORM gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"DROP"}}$$);		
	END IF;

	RAISE NOTICE 'step 1/7';
	INSERT INTO audit_check_data (fid, error_message) VALUES (239, 'INFO: Constraints of schema temporary disabled -> Done');
	
	-- use the copy function of postgres to import from file in case of file must be provided as a parameter
	IF v_path IS NOT NULL THEN
		EXECUTE 'SELECT gw_fct_utils_csv2pg_import_temp_data('||quote_literal(v_fid)||','||quote_literal(v_path)||' ) ';
	END IF;

	RAISE NOTICE 'step 2/7';
	INSERT INTO audit_check_data (fid, error_message) VALUES (239, 'INFO: Inserting data from inp file to temp_csv table -> Done');

	UPDATE temp_csv SET csv2=concat(csv2,' ',csv3,' ',csv4,' ',csv5,' ',csv6,' ',csv7,' ',csv8,' ',csv9,' ',csv10,' ',csv11,' ',csv12,' ',csv13,' ',csv14,' ',csv15,' ',csv16 ),
	csv3=null, csv4=null,csv5=null,csv6=null,csv7=null, csv8=null, csv9=null,csv10=null,csv11=null,csv12=null, csv13=null, csv14=null,csv15=null,csv16=null WHERE source='[TEMPERATURE]' AND (csv1='TIMESERIES' OR csv1='FILE' OR csv1='SNOWMELT');

	UPDATE temp_csv SET csv1=concat(csv1,' ',csv2),csv2=concat(csv3,' ',csv4,' ',csv5,' ',csv6,' ',csv7,' ',csv8,' ',csv9,' ',csv10,' ',csv11,' ',csv12,' ',csv13,' ',csv14,' ',csv15,' ',csv16 ),
	csv3=null, csv4=null,csv5=null,csv6=null,csv7=null, csv8=null, csv9=null,csv10=null,csv11=null,csv12=null, csv13=null, csv14=null,csv15=null,csv16=null WHERE source='[TEMPERATURE]' AND csv1!='TIMESERIES' AND csv1!='FILE' AND csv1!='SNOWMELT';
	
	UPDATE temp_csv SET csv1=(concat(csv1,' ',csv2,' ',csv3,' ',csv4,' ',csv5,' ',csv6,' ',csv7,' ',csv8,' ',csv9,' ',csv10,' ',csv11,' ',csv12,' ',csv13)), 
	csv2=null, csv3=null, csv4=null, csv5=null, csv6=null, csv7=null, csv8=null, csv9=null, csv10=null, csv11=null,csv12=null,csv13=null WHERE source='[CONTROLS]';

	UPDATE temp_csv SET csv3=(concat(csv3,' ',csv4,' ',csv5,' ',csv6,' ',csv7,' ',csv8,' ',csv9,' ',csv10,' ',csv11,' ',csv12,' ',csv13)), 
	csv4=null, csv5=null, csv6=null, csv7=null, csv8=null, csv9=null, csv10=null, csv11=null,csv12=null,csv13=null WHERE source='[TREATMENT]'; 

	UPDATE temp_csv SET csv1=(concat(csv1,' ',csv2,' ',csv3,' ',csv4,' ',csv5,' ',csv6,' ',csv7,' ',csv8,' ',csv9,' ',csv10,' ',csv11,' ',csv12,' ',csv13)), 
	csv2=null, csv3=null,csv4=null, csv5=null, csv6=null, csv7=null, csv8=null, csv9=null, csv10=null, csv11=null,csv12=null,csv13=null WHERE source='[HYDROGRAPHS]'; 

	UPDATE temp_csv SET csv4 = replace(csv4,'"',''), csv5 = replace(csv5,'"',''), csv6 = replace(csv6,'"',''), csv7 = replace(csv7,'"','') WHERE source='[DWF]';
		
	UPDATE temp_csv SET csv2=concat(csv2,';',csv3,';',csv4,';',csv5),csv3=null,csv4=null,csv5=null WHERE source='[MAP]'; 
					
	UPDATE temp_csv SET csv2=concat(csv2,';',csv3),csv3=concat(csv4,';',csv5),csv4=null,csv5=null WHERE  source='[GWF]';
			
	UPDATE temp_csv SET csv1=concat(csv1,' ',csv2,' ',csv3,' ',csv4,' ',csv5,' ',csv6), csv2=null, csv3=null,csv4=null, csv5=null,csv6=null WHERE  source='[BACKDROP]';
	
	UPDATE temp_csv SET csv2=concat(csv2,';',csv3,';',csv4,';',csv5,';',csv6,csv7,';',csv8,';',csv9,';',csv10,';',csv11,';',csv12,';',csv13),
	csv3=null,csv4=null, csv5=null,csv6=null,csv7=null,csv8=null,csv9=null,csv10=null,csv11=null,csv12=null,csv13=null WHERE source='[EVAPORATION]';


	RAISE NOTICE 'step 3/7';
	INSERT INTO audit_check_data (fid, error_message) VALUES (239, 'INFO: Creating map zones and catalogs -> Done');

	-- MAPZONES
	INSERT INTO macroexploitation(macroexpl_id,name) VALUES(1,'macroexploitation1');
	INSERT INTO exploitation(expl_id,name,macroexpl_id) VALUES(1,'exploitation1',1);
	INSERT INTO sector(sector_id,name) VALUES(1,'sector1');
	INSERT INTO dma(dma_id,name) VALUES(1,'dma1');
	INSERT INTO ext_municipality(muni_id,name) VALUES(1,'municipality1');

	-- SELECTORS
	--insert values into selectors
	INSERT INTO selector_expl(expl_id,cur_user) VALUES (1,current_user);
	INSERT INTO selector_state(state_id,cur_user) VALUES (1,current_user);
	INSERT INTO selector_sector(sector_id,cur_user) VALUES (1,current_user);
	INSERT INTO selector_inp_hydrology(hydrology_id,cur_user) VALUES (1,current_user);
	INSERT INTO config_param_user (parameter, value, cur_user) VALUES ('inp_options_dwfscenario', '1', current_user);

	INSERT INTO audit_check_data (fid, error_message) VALUES (239, 'INFO: Setting selectors -> Done');

	-- CATALOGS
	--cat_feature
	ALTER TABLE cat_feature DISABLE TRIGGER gw_trg_cat_feature;
	--node
	INSERT INTO cat_feature (id, system_id, feature_type, parent_layer) VALUES ('EPAMANH','JUNCTION','NODE', 'v_edit_node');
	INSERT INTO cat_feature (id, system_id, feature_type, parent_layer) VALUES ('EPAOUTF','OUTFALL','NODE', 'v_edit_node');
	INSERT INTO cat_feature (id, system_id, feature_type, parent_layer) VALUES ('EPASTOR','STORAGE','NODE', 'v_edit_node');
	
	--arc
	INSERT INTO cat_feature (id, system_id, feature_type, parent_layer) VALUES ('EPACOND','CONDUIT','ARC', 'v_edit_arc');
	--nodarc
	INSERT INTO cat_feature (id, system_id, feature_type, parent_layer) VALUES ('EPAWEIR','VARC','ARC', 'v_edit_arc');
	INSERT INTO cat_feature (id, system_id, feature_type, parent_layer) VALUES ('EPAPUMP','VARC','ARC', 'v_edit_arc');
	INSERT INTO cat_feature (id, system_id, feature_type, parent_layer) VALUES ('EPAORIF','VARC','ARC', 'v_edit_arc');
	INSERT INTO cat_feature (id, system_id, feature_type, parent_layer) VALUES ('EPAOUTL','VARC','ARC', 'v_edit_arc');

	INSERT INTO cat_dwf_scenario VALUES (1, 'test');
	
	--arc_type
	--arc
	INSERT INTO cat_feature_arc VALUES ('EPACOND', 'CONDUIT', 'CONDUIT', 'man_conduit', 'inp_conduit');
	INSERT INTO cat_feature_arc VALUES ('EPAWEIR', 'VARC', 'WEIR', 'man_varc', 'inp_weir');
	INSERT INTO cat_feature_arc VALUES ('EPAORIF', 'VARC', 'ORIFICE', 'man_varc', 'inp_orifice');
	INSERT INTO cat_feature_arc VALUES ('EPAPUMP', 'VARC', 'PUMP', 'man_varc', 'inp_pump');
	INSERT INTO cat_feature_arc VALUES ('EPAOUTL', 'VARC', 'OUTLET', 'man_varc', 'inp_outlet');

	--node_type
	INSERT INTO cat_feature_node VALUES ('EPAMANH', 'MANHOLE', 'JUNCTION', 'man_manhole', 'inp_junction', 2, TRUE,TRUE);
	INSERT INTO cat_feature_node VALUES ('EPAOUTF', 'OUTFALL', 'OUTFALL', 'man_outfall', 'inp_outfall', 2, TRUE,TRUE);
	INSERT INTO cat_feature_node VALUES ('EPASTOR', 'STORAGE', 'STORAGE', 'man_storage', 'inp_storage', 2, TRUE,TRUE);
	
	ALTER TABLE cat_feature ENABLE TRIGGER gw_trg_cat_feature;
	--cat_mat_node 
	INSERT INTO cat_mat_node VALUES ('EPAMAT');
	INSERT INTO cat_mat_arc VALUES ('EPAMAT');
	
	--cat_node
	INSERT INTO cat_node (id, matcat_id, active) VALUES ('EPAMANH-CAT', 'EPAMAT', TRUE);
	INSERT INTO cat_node (id, matcat_id, active) VALUES ('EPAOUTF-CAT', 'EPAMAT', TRUE);
	INSERT INTO cat_node (id, matcat_id, active) VALUES ('EPASTOR-CAT', 'EPAMAT', TRUE);

	-- cat_arc
	INSERT INTO cat_arc (id, matcat_id, active) VALUES ('EPAWEIR-CAT', 'EPAMAT', TRUE);
	INSERT INTO cat_arc (id, matcat_id, active) VALUES ('EPAORIF-CAT', 'EPAMAT', TRUE);
	INSERT INTO cat_arc (id, matcat_id, active) VALUES ('EPAPUMP-CAT', 'EPAMAT', TRUE);
	INSERT INTO cat_arc (id, matcat_id, active) VALUES ('EPAOUTL-CAT', 'EPAMAT', TRUE);


	--create child views 
	PERFORM gw_fct_admin_manage_child_views($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{},
 	"data":{"filterFields":{}, "pageInfo":{}, "multi_create":"True" }}$$);

	-- enable temporary the constraint in order to use ON CONFLICT on insert
	ALTER TABLE config_param_user ADD CONSTRAINT config_param_user_parameter_cur_user_unique UNIQUE(parameter, cur_user);

	-- improve velocity for junctions using directy tables in spite of vi_junctions view
	INSERT INTO node (node_id, code, top_elev, ymax, node_type, nodecat_id, epa_type, sector_id, dma_id, expl_id, state, state_type) 
	SELECT csv1, csv1, csv2::numeric(12,3), csv3::numeric(12,3), 'EPAMANH', 'EPAMANH-CAT', 'JUNCTION', 1, 1, 1, 1, 2 
	FROM temp_csv where source='[JUNCTIONS]' AND fid = v_fid  AND (csv1 NOT LIKE '[%' AND csv1 NOT LIKE ';%') AND cur_user=current_user;
	INSERT INTO inp_junction (node_id, y0, ysur, apond) 
	SELECT csv1, csv4::numeric(12,3), csv5::numeric(12,3), csv6::numeric(12,3) FROM temp_csv where source='[JUNCTIONS]' AND fid =239  AND (csv1 NOT LIKE '[%' AND csv1 NOT LIKE ';%') AND cur_user=current_user;
	INSERT INTO man_manhole 
	SELECT csv1 FROM temp_csv where source='[JUNCTIONS]' AND fid = v_fid  AND (csv1 NOT LIKE '[%' AND csv1 NOT LIKE ';%') AND cur_user=current_user;

	-- improve velocity for conduits using directy tables in spite of vi_conduits view
	INSERT INTO arc (arc_id, code, node_1,node_2, custom_length, sys_elev1, sys_elev2, arc_type, epa_type, arccat_id, matcat_id, sector_id, dma_id, expl_id, state, state_type) 
	SELECT csv1, csv1, csv2, csv3, csv4::numeric(12,3), csv6::numeric(12,3), csv7::numeric(12,3), 'EPACOND', 'CONDUIT', csv5, csv5, 1, 1, 1, 1, 2 
	FROM temp_csv where source='[CONDUITS]' AND fid = v_fid  AND (csv1 NOT LIKE '[%' AND csv1 NOT LIKE ';%') AND cur_user=current_user;
	INSERT INTO man_conduit(arc_id) SELECT csv1
	FROM temp_csv where source='[CONDUITS]' AND fid = v_fid  AND (csv1 NOT LIKE '[%' AND csv1 NOT LIKE ';%') AND cur_user=current_user;
	INSERT INTO inp_conduit (arc_id, custom_n, q0, qmax) SELECT csv1, csv5::numeric(12,3), csv8::numeric(12,3), csv9::numeric(12,3)
	FROM temp_csv where source='[CONDUITS]' AND fid = v_fid  AND (csv1 NOT LIKE '[%' AND csv1 NOT LIKE ';%') AND cur_user=current_user;

	-- LOOPING THE EDITABLE VIEWS TO INSERT DATA
	FOR v_rec_table IN SELECT * FROM config_fprocess WHERE fid=v_fid AND tablename NOT IN ('vi_conduits', 'vi_junction') order by orderby
	LOOP
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
		v_sql = 'INSERT INTO '||v_rec_table.tablename||' SELECT '||v_query_fields||' FROM temp_csv where source like '||quote_literal(concat('%',v_rec_table.target,'%'))||' 
		AND fid='||v_fid||' AND (csv1 NOT LIKE ''[%'' AND csv1 NOT LIKE '';%'') AND cur_user='||quote_literal(current_user)||' ORDER BY id';

		--raise notice 'v_sql %', v_sql;
		EXECUTE v_sql;
	END LOOP;

	-- refactor of linksoffsets
	v_linkoffsets = (SELECT value FROM config_param_user WHERE parameter='inp_options_link_offsets' AND cur_user=current_user);
	IF v_linkoffsets != 'ELEVATION' THEN
		UPDATE arc SET sys_elev1 = b.a1,  sys_elev2 = b.a2 FROM 
		(SELECT a.arc_id, n1.sys_elev - sys_elev1 AS a1, n2.sys_elev - sys_elev2 AS a2 FROM arc a JOIN v_edit_node n1 ON n1.node_id = node_1 JOIN v_edit_node n2 ON n2.node_id = node_2) b
		WHERE b.arc_id = arc.arc_id;
	END IF;
	
	-- enable temporary the constraint in order to use ON CONFLICT on insert
	ALTER TABLE config_param_user DROP CONSTRAINT config_param_user_parameter_cur_user_unique;

	RAISE NOTICE 'step 4/7';
	INSERT INTO audit_check_data (fid, error_message) VALUES (239, 'WARNING: Values of options / times / report are not updated. Default values of Giswater are keeped');
	INSERT INTO audit_check_data (fid, error_message) VALUES (239, 'INFO: Inserting data into tables using vi_* views -> Done');
	INSERT INTO audit_check_data (fid, error_message) VALUES (239, 'WARNING: Controls and rules have been stored on inp_controls_importinp table. This is a temporary table. Data need to be moved to inp_controls_x_arc table to be used later');

	-- Create arc geom
	v_querytext = 'SELECT * FROM arc ';
		
	FOR v_data IN EXECUTE v_querytext
	LOOP

		--raise notice '4th loop %', v_data;
		--Insert start point, add vertices if exist, add end point
		SELECT array_agg(the_geom) INTO geom_array FROM node WHERE v_data.node_1=node_id;
	
		SELECT array_agg(ST_SetSrid(ST_MakePoint(csv2::numeric,csv3::numeric),v_epsg)order by id) INTO  geom_array_vertex FROM temp_csv 
		WHERE cur_user=current_user AND fid =v_fid and source='[VERTICES]' and csv1=v_data.arc_id;
		
		IF geom_array_vertex IS NOT NULL THEN
			geom_array=array_cat(geom_array, geom_array_vertex);
		END IF;
		
		geom_array=array_append(geom_array,(SELECT the_geom FROM node WHERE v_data.node_2=node_id));

		UPDATE arc SET the_geom=ST_MakeLine(geom_array) where arc_id=v_data.arc_id;

	END LOOP;

	RAISE NOTICE 'step 5/7';
	INSERT INTO audit_check_data (fid, error_message) VALUES (239, 'INFO: Creating arc geometry from extremal nodes and intermediate vertex -> Done');
	INSERT INTO audit_check_data (fid, error_message) VALUES (239, 'WARNING: Link geometries as ORIFICE, WEIRS, PUMPS AND OULETS will not transformed using reverse nod2arc strategy as nodes. It will keep as arc');

	
	-- Subcatchments geometry
	IF v_createsubcgeom THEN
		--Create points out of vertices defined in inp file create a line out all points and transform it into a polygon.
		FOR v_data IN SELECT * FROM inp_subcatchment LOOP
		
			FOR rpt_rec IN SELECT * FROM temp_csv WHERE cur_user=current_user AND fid =v_fid and source ilike '[Polygons]' AND csv1=v_data.subc_id order by id
			LOOP	
			
				v_point_geom=ST_SetSrid(ST_MakePoint(rpt_rec.csv2::numeric,rpt_rec.csv3::numeric),v_epsg);
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
					UPDATE inp_subcatchment SET the_geom=ST_Multi(ST_Polygon(v_line_geom,v_epsg)) where subc_id=v_data.subc_id;
					INSERT INTO temp_table (geom_line) VALUES (v_line_geom);
				ELSE
					v_line_geom = ST_AddPoint(v_line_geom, ST_StartPoint(v_line_geom));
					IF ST_IsClosed(v_line_geom) THEN
						UPDATE inp_subcatchment SET the_geom=ST_Multi(ST_Polygon(v_line_geom,v_epsg)) where subc_id=v_data.subc_id;
						INSERT INTO temp_table (geom_line) VALUES (v_line_geom);
					ELSE
						RAISE NOTICE 'The polygon cant be created because the geometry is not closed. Subc_id: ,%', v_data.subc_id;
					END IF;
				END IF;
			ELSE 
				RAISE NOTICE 'The polygonn cant be created because it has less than 4 vertexes. Subc_id: ,%', v_data.subc_id;
			END IF;
		END LOOP;
	END IF;


	RAISE NOTICE 'step-6/7';
	INSERT INTO audit_check_data (fid, error_message) VALUES (239, 'INFO: Creating subcathcment polygons -> Done');
			
	-- Mapzones geometry
	--Create the same geometry of all mapzones by making the Convex Hull over all the existing arcs
	EXECUTE 'SELECT ST_Multi(ST_ConvexHull(ST_Collect(the_geom))) FROM arc;'
	into v_extend_val;
	update exploitation SET the_geom=v_extend_val;
	update sector SET the_geom=v_extend_val;
	update dma SET the_geom=v_extend_val;
	update ext_municipality SET the_geom=v_extend_val;

	-- Create cat_mat_arc on import inp function
	INSERT INTO cat_mat_arc	SELECT DISTINCT (matcat_id) FROM arc WHERE matcat_id IS NOT NULL;

	-- Enable constraints
	PERFORM gw_fct_admin_manage_ct($${"client":{"lang":"ES"},"data":{"action":"ADD"}}$$);

	RAISE NOTICE 'step-7/7';
	INSERT INTO audit_check_data (fid, error_message) VALUES (239, 'INFO: Enabling constraints -> Done');
	INSERT INTO audit_check_data (fid, error_message) VALUES (239, 'INFO: Process finished');

	-- get results
	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT error_message as message FROM audit_check_data WHERE cur_user="current_user"() AND fid = v_fid  order by id) row;
	v_result := COALESCE(v_result, '{}'); 
	v_result_info = concat ('{"geometryType":"", "values":',v_result, '}');
	
	--Control nulls
	v_version := COALESCE(v_version, '{}'); 
	v_result_info := COALESCE(v_result_info, '{}'); 
	v_result_point := COALESCE(v_result_point, '{}'); 
	v_result_line := COALESCE(v_result_line, '{}'); 	

	-- 	Return
	RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"Import inp done successfully"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||','||
				'"point":'||v_result_point||','||
				'"line":'||v_result_line||'}'||
		       '}'||
	    '}')::json, 2524);

	--  Exception handling
	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN ('{"status":"Failed", "body":{"data":{"info":{"values":[{"message":'||to_json(SQLERRM)||'}]}}}, "NOSQLERR":' || 
	to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
