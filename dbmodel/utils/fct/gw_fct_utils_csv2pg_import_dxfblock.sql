/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE:2504

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_utils_csv2pg_import_dxfblock(integer);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_utils_csv2pg_import_dxfblock(p_data json)
RETURNS json AS
$BODY$

/*
SELECT SCHEMA_NAME.gw_fct_utils_csv2pg_import_dxfblock($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"feature":{},"data":{}}$$)


NOTES:
------
This function is a 0.1 version of import dxf files into giswater. 
This function only solves the importation of blocks with attributes
The file must be depurated before cleaning as much as possible of layers......
Only blocks must be on the dxf file


example to work without csv2pg plugin button:
delete from SCHEMA_NAME.temp_csv2pg ;
copy SCHEMA_NAME.temp_csv2pg (csv1) FROM 'c:\data\file.dxf';
update SCHEMA_NAME.temp_csv2pg set csv2pgcat_id=8;
select SCHEMA_NAME.gw_fct_utils_csv2pg_importdxfblock(8);
*/


DECLARE
v_record record;
v_target text;
v_total integer;
v_id int8;
v_value text;
v_i integer=0;
v_filter float=0;
v_percent integer;
v_result_id text= 'import dxf blocks';
v_result json;
v_result_info json;
v_project_type text;
v_version text;
v_epsg integer;

BEGIN

	--  Search path
	SET search_path = "SCHEMA_NAME", public;

	-- get system parameters
	SELECT wsoftware, giswater, epsg  INTO v_project_type, v_version, v_epsg FROM version order by 1 desc limit 1;

	-- manage log (fprocesscat 42)
	DELETE FROM audit_check_data WHERE fprocesscat_id=42 AND user_name=current_user;
	INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) VALUES (42, v_result_id, concat('IMPORT DXF BLOCKS FILE'));
	INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) VALUES (42, v_result_id, concat('------------------------------'));
   
 	-- starting process	
	SELECT count(*)  INTO v_total FROM temp_csv2pg WHERE user_name=current_user;


	FOR v_record IN SELECT id, csv1 FROM temp_csv2pg WHERE user_name=current_user AND csv2pgcat_id=8 order by id
	LOOP 
		v_i=v_i+1;
		-- massive refactor of source field (getting target)
		IF v_record.csv1 LIKE ' 66' THEN
			v_target=v_record.id;
		END IF;
		UPDATE temp_csv2pg SET source=v_target WHERE v_record.id=temp_csv2pg.id;

		v_percent:=((v_i::float/v_total::float)*100)::integer;

		IF v_percent > v_filter THEN
				v_filter = v_percent;
				raise notice '(1/2), % %% executed', v_percent;
		END IF;

	END LOOP;


	v_i=0;
	v_filter = 0;

	FOR v_record IN SELECT id, csv1, source FROM temp_csv2pg WHERE user_name=current_user AND csv2pgcat_id=8 order by id
	LOOP 	
		v_i=v_i+1;
		-- xcoord
		IF v_record.csv1 = ' 10' AND v_record.source IS NOT NULL THEN
			v_id=v_record.id+1;
			SELECT csv1 INTO v_value FROM temp_csv2pg WHERE id=v_id;
			-- looking for the first xcoord value ( 10). Into the block there are two xcoord values. We are looking for the first one
			IF (SELECT csv2 FROM temp_csv2pg WHERE id=v_record.source::integer) IS NULL THEN
				UPDATE temp_csv2pg SET csv2=v_value WHERE temp_csv2pg.id=v_record.source::integer;	
			END IF;
		END IF;
		
		-- ycoord
		IF v_record.csv1 = ' 20' AND v_record.source IS NOT NULL THEN
			v_id=v_record.id+1;
			SELECT csv1 INTO v_value FROM temp_csv2pg WHERE id=v_id;
			-- looking for the first xcoord value ( 10). Into the block there are two xcoord values. We are looking for the first one
			IF (SELECT csv3 FROM temp_csv2pg WHERE id=v_record.source::integer) IS NULL THEN
				UPDATE temp_csv2pg SET csv3=v_value WHERE temp_csv2pg.id=v_record.source::integer;
			END IF;
		END IF;

		-- value
		IF v_record.csv1 = '  1' AND v_record.source IS NOT NULL THEN
			v_id=v_record.id+1;
			SELECT csv1 INTO v_value FROM temp_csv2pg WHERE id=v_id;
			UPDATE temp_csv2pg SET csv4=v_value WHERE temp_csv2pg.id=v_record.source::integer;
		END IF;

		-- rotation
		IF v_record.csv1 = ' 50' AND v_record.source IS NOT NULL THEN
			v_id=v_record.id+1;
			SELECT csv1 INTO v_value FROM temp_csv2pg WHERE id=v_id;
			UPDATE temp_csv2pg SET csv5=v_value WHERE temp_csv2pg.id=v_record.source::integer;
		END IF;

		-- layer
		IF v_record.csv1 = '  7' AND v_record.source IS NOT NULL THEN
			v_id=v_record.id+1;
			SELECT csv1 INTO v_value FROM temp_csv2pg WHERE id=v_id;
			UPDATE temp_csv2pg SET csv6=v_value WHERE temp_csv2pg.id=v_record.source::integer;
		END IF;

		IF v_percent > v_filter THEN
				v_filter = v_percent;
				raise notice '(2/2), %%% executed', v_percent;
		END IF;		

	END LOOP;

	-- deleting previous values on destination table
	DELETE FROM temp_table WHERE fprocesscat_id=42 AND user_name=current_user;

	-- inserting result on point temp_table
	INSERT INTO temp_table (fprocesscat_id, text_column, geom_point) 
	SELECT 42, concat('"value":"',csv4,'"rotation":"',csv5,'"layer":"',csv6), st_setsrid(st_makepoint(csv2::float, csv3::float),v_epsg) FROM temp_csv2pg WHERE user_name=current_user AND csv2pgcat_id=8;

	-- Delete values from csv temporal table
	DELETE FROM temp_csv2pg WHERE user_name=current_user AND csv2pgcat_id=8;

	-- manage log (fprocesscat 42)
	INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) VALUES (42, v_result_id, concat('Reading values from temp_csv2pg table -> Done'));
	INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) VALUES (42, v_result_id, concat('Inserting values on temp_table as point geometry -> Done'));
	INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) VALUES (42, v_result_id, concat('Deleting values from temp_csv2pg -> Done'));
	INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) VALUES (42, v_result_id, concat('Process finished'));

	-- get log (fprocesscat 42)
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, error_message AS message FROM audit_check_data WHERE user_name="current_user"() AND fprocesscat_id=42) row; 
	v_result := COALESCE(v_result, '{}'); 
	v_result_info = concat ('{"geometryType":"", "values":',v_result, '}');
			
	-- Control nulls
	v_version := COALESCE(v_version, '{}'); 
	v_result_info := COALESCE(v_result_info, '{}'); 
 
	-- Return
	RETURN ('{"status":"Accepted", "message":{"priority":0, "text":"Process executed"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||'}}'||
	    '}')::json;
	    
	--    Exception handling
	--EXCEPTION WHEN OTHERS THEN 
	--RETURN ('{"status":"Failed","message":{"priority":2, "text":' || to_json(SQLERRM) || '}, "version":"'|| v_version ||'","SQLSTATE":' || to_json(SQLSTATE) || '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
