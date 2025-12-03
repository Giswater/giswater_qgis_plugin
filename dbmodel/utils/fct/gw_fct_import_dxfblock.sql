/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE:2504

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_utils_csv2pg_import_dxfblock(integer);
DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_utils_csv2pg_import_dxfblock(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_import_dxfblock(p_data json)
RETURNS json AS
$BODY$

/*
SELECT SCHEMA_NAME.gw_fct_import_dxfblock($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"feature":{},"data":{}}$$)


NOTES:
------
This function is a 0.1 version of import dxf files into giswater. 
This function only solves the importation of blocks with attributes
The file must be depurated before cleaning as much as possible of layers......
Only blocks must be on the dxf file

example to work without csv2pg plugin button:
delete from SCHEMA_NAME.temp_csv ;
copy SCHEMA_NAME.temp_csv (csv1) FROM 'c:\data\file.dxf';
update SCHEMA_NAME.temp_csv set fid = 237;
select SCHEMA_NAME.gw_fct_utils_csv2pg_importdxfblock(237);

--fid:237

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
	SELECT project_type, giswater, epsg  INTO v_project_type, v_version, v_epsg FROM sys_version ORDER BY id DESC LIMIT 1;

	-- manage log (fid: 237)
	DELETE FROM audit_check_data WHERE fid = 237 AND cur_user=current_user;
	INSERT INTO audit_check_data (fid, result_id, error_message) VALUES (237, v_result_id, concat('IMPORT DXF BLOCKS FILE'));
	INSERT INTO audit_check_data (fid, result_id, error_message) VALUES (237, v_result_id, concat('------------------------------'));
   
 	-- starting process	
	SELECT count(*)  INTO v_total FROM temp_csv WHERE cur_user=current_user;

	FOR v_record IN SELECT id, csv1 FROM temp_csv WHERE cur_user=current_user AND fid = 237 order by id
	LOOP 
		raise notice ' %', v_record;
		v_i=v_i+1;
		-- massive refactor of source field (getting target)
		IF v_record.csv1 = '66' THEN
			v_target= (SELECT id FROM temp_csv WHERE id = v_record.id+1);
		END IF;
		UPDATE temp_csv SET source=v_target WHERE v_record.id=temp_csv.id;

		v_percent:=((v_i::float/v_total::float)*100)::integer;

		IF v_percent > v_filter THEN
				v_filter = v_percent;
				raise notice '(1/2), % %% executed, %', v_percent, v_target;
		END IF;

	END LOOP;


	v_i=0;
	v_filter = 0;

	FOR v_record IN SELECT id, csv1, source FROM temp_csv WHERE cur_user=current_user AND fid = 237 AND source IS NOT NULL order by id
	LOOP 	
		v_i=v_i+1;
		-- xcoord
		IF v_record.csv1 = '10' THEN
			v_id=v_record.id+1;
			SELECT csv1 INTO v_value FROM temp_csv WHERE id=v_id;
			-- looking for the first xcoord value ( 10). Into the block there are two xcoord values. We are looking for the first one
			IF (SELECT csv2 FROM temp_csv WHERE id=v_record.source::integer) IS NULL THEN
				UPDATE temp_csv SET csv2=v_value WHERE temp_csv.id=v_record.source::integer;
			END IF;
		END IF;
		
		-- ycoord
		IF v_record.csv1 = '20' THEN
			v_id=v_record.id+1;
			SELECT csv1 INTO v_value FROM temp_csv WHERE id=v_id;
			-- looking for the first xcoord value ( 10). Into the block there are two xcoord values. We are looking for the first one
			IF (SELECT csv3 FROM temp_csv WHERE id=v_record.source::integer) IS NULL THEN
				UPDATE temp_csv SET csv3=v_value WHERE temp_csv.id=v_record.source::integer;
			END IF;
		END IF;

		-- value
		IF v_record.csv1 = '1' THEN
			v_id=v_record.id+1;
			SELECT csv1 INTO v_value FROM temp_csv WHERE id=v_id;
			UPDATE temp_csv SET csv4=v_value WHERE temp_csv.id=v_record.source::integer;
		END IF;

		-- rotation
		IF v_record.csv1 = '50' THEN
			v_id=v_record.id+1;
			SELECT csv1 INTO v_value FROM temp_csv WHERE id=v_id;
			UPDATE temp_csv SET csv5=v_value WHERE temp_csv.id=v_record.source::integer;
		END IF;

		-- layer
		IF v_record.csv1 = '7' THEN
			v_id=v_record.id+1;
			SELECT csv1 INTO v_value FROM temp_csv WHERE id=v_id;
			UPDATE temp_csv SET csv6=v_value WHERE temp_csv.id=v_record.source::integer;
		END IF;

		IF v_percent > v_filter THEN
				v_filter = v_percent;
				raise notice '(2/2), %%% executed', v_percent;
		END IF;		

	END LOOP;

	-- deleting previous values on destination table
	DELETE FROM temp_table WHERE fid = 237 AND cur_user=current_user;

	-- inserting result on point temp_table
	INSERT INTO temp_table (fid, text_column, geom_point)

	SELECT 237, concat('"value":"',csv4,'"rotation":"',csv5,'"layer":"',csv6), st_setsrid(st_makepoint(csv2::float, csv3::float),v_epsg) 
	FROM temp_csv WHERE cur_user=current_user AND fid = 237 AND csv2 is not null and source IS NOT NULL;

	-- Delete values from csv temporal table
	DELETE FROM temp_csv WHERE cur_user=current_user AND fid = 237;

	-- manage log (fid: 237)
	INSERT INTO audit_check_data (fid, result_id, error_message) VALUES (237, v_result_id, concat('Reading values from temp_csv table -> Done'));
	INSERT INTO audit_check_data (fid, result_id, error_message) VALUES (237, v_result_id, concat('Inserting values on temp_table as point geometry -> Done'));
	INSERT INTO audit_check_data (fid, result_id, error_message) VALUES (237, v_result_id, concat('Deleting values from temp_csv -> Done'));
	INSERT INTO audit_check_data (fid, result_id, error_message) VALUES (237, v_result_id, concat('Process finished, you can get your data from temp_table'));

	-- get log (fid: 237)
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, error_message AS message FROM audit_check_data WHERE cur_user="current_user"() AND fid = 237) row;
	v_result := COALESCE(v_result, '{}'); 
	v_result_info = concat ('{"values":',v_result, '}');
		
	-- Control nulls
	v_version := COALESCE(v_version, ''); 
	v_result_info := COALESCE(v_result_info, '{}'); 
 
	-- Return
	RETURN ('{"status":"Accepted", "message":{"level":0, "text":"Process executed"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||'}}'||
	    '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
