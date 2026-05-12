/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3136

-- Function: SCHEMA_NAME.gw_fct_import_inp_urn();

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_import_inp_urn() RETURNS json AS
$BODY$
DECLARE 
v_max_urn integer;
project_type_aux varchar;
v_count integer;
v_sql text;
rec record;
v_id integer;
v_result_info json;
v_version text;
v_result json;
rec_inp text;
v_tables text[];

BEGIN 

SET search_path = "SCHEMA_NAME", public;

DELETE FROM temp_data where fid=439;
DELETE FROM audit_check_data where fid=439;

SELECT project_type, giswater INTO project_type_aux, v_version FROM sys_version ORDER BY id DESC LIMIT 1;
	
	IF project_type_aux='WS' THEN
		SELECT GREATEST (
			(SELECT max(node_id::integer) FROM node WHERE node_id ~ '^\d+$'),
			(SELECT max(arc_id::integer) FROM arc WHERE arc_id ~ '^\d+$'),
			(SELECT max(connec_id::integer) FROM connec WHERE connec_id ~ '^\d+$'),
			(SELECT max(element_id::integer) FROM element WHERE element_id ~ '^\d+$'),
			(SELECT max(pol_id::integer) FROM polygon WHERE pol_id ~ '^\d+$')
			) INTO v_max_urn;

		v_sql = 'select 439 as fid, node_id as feature_id, concat(''code:'',code) as code, ''node'' as feature_type  FROM node where (node_id ~ ''^([0-9]+[.]?[0-9]*|[.][0-9]+)$'') IS FALSE UNION
		select 439 as fid, arc_id, concat(''code:'',code) as code,''arc'' as feature_type  FROM arc where (arc_id ~ ''^([0-9]+[.]?[0-9]*|[.][0-9]+)$'') IS FALSE UNION
		select 439 as fid, connec_id, concat(''code:'',code) as code,''connec'' as feature_type FROM connec where (connec_id ~ ''^([0-9]+[.]?[0-9]*|[.][0-9]+)$'') IS FALSE';

	ELSIF project_type_aux='UD' THEN
		SELECT GREATEST (
			(SELECT max(node_id::integer) FROM node WHERE node_id ~ '^\d+$'),
			(SELECT max(arc_id::integer) FROM arc WHERE arc_id ~ '^\d+$'),
			(SELECT max(connec_id::integer) FROM connec WHERE connec_id ~ '^\d+$'),
			(SELECT max(gully_id::integer) FROM gully WHERE gully_id ~ '^\d+$'),
			(SELECT max(element_id::integer) FROM element WHERE element_id ~ '^\d+$'),
			(SELECT max(pol_id::integer) FROM polygon WHERE pol_id ~ '^\d+$')
			) INTO v_max_urn;

		v_sql = 'select 439 as fid, node_id as feature_id, concat(''code:'',code) as code, ''node'' as feature_type  FROM node where (node_id ~ ''^([0-9]+[.]?[0-9]*|[.][0-9]+)$'') IS FALSE UNION
		select 439 as fid, arc_id, concat(''code:'',code) as code,''arc'' as feature_type  FROM arc where (arc_id ~ ''^([0-9]+[.]?[0-9]*|[.][0-9]+)$'') IS FALSE UNION
		select 439 as fid, connec_id, concat(''code:'',code) as code,''connec'' as feature_type FROM connec where (connec_id ~ ''^([0-9]+[.]?[0-9]*|[.][0-9]+)$'') IS FALSE UNION
		select 439 as fid, gully_id, concat(''code:'',code) as code,''gully'' as feature_type FROM gully where (gully_id ~ ''^([0-9]+[.]?[0-9]*|[.][0-9]+)$'') IS FALSE';

	END IF;

	EXECUTE 'INSERT INTO temp_data (fid,feature_id,log_message,feature_type) '||v_sql||';';

	PERFORM setval('urn_id_seq', v_max_urn, true);

	FOR rec in EXECUTE v_sql LOOP
		IF length(rec.feature_id) > 3 THEN
			
			v_id:= (SELECT nextval('urn_id_seq'));
			
			EXECUTE 'UPDATE '||rec.feature_type||' SET '||rec.feature_type||'_id = '||quote_literal(v_id)||' 
			WHERE '||rec.feature_type||'_id ='||quote_literal(rec.feature_id)||';';

			--update inp tables
			IF project_type_aux='UD' AND (rec.feature_type ='node' OR rec.feature_type ='arc') THEN
				EXECUTE 'SELECT count(*) FROM inp_controls WHERE position('||quote_literal(rec.feature_id)||' in text) > 0' INTO v_count;
				IF v_count>0 THEN
					EXECUTE 'UPDATE inp_controls SET text = replace(text,'||quote_literal(rec.feature_id)||', '||quote_literal(v_id)||' )
					WHERE position('||quote_literal(rec.feature_id)||' in text) > 0;';
				END IF;
			ELSIF project_type_aux='WS' AND (rec.feature_type ='node' OR rec.feature_type ='arc') THEN
				v_tables ='{inp_controls, inp_rules}';

				FOREACH rec_inp IN ARRAY(v_tables) LOOP
					EXECUTE 'SELECT count(*) FROM '||rec_inp||' WHERE position('||quote_literal(rec.feature_id)||' in text) > 0' INTO v_count;
					IF v_count>0 THEN
						Execute 'UPDATE '||rec_inp||' SET text = replace(text,'||quote_literal(rec.feature_id)||', '||quote_literal(v_id)||' )
						WHERE position('||quote_literal(rec.feature_id)||' in text) > 0;';

					END IF;
				END LOOP;

				v_tables ='{inp_energy}';

				FOREACH rec_inp IN ARRAY(v_tables) LOOP
					EXECUTE 'SELECT count(*) FROM '||rec_inp||' WHERE position('||quote_literal(rec.feature_id)||' in descript) > 0' INTO v_count;
					IF v_count>0 THEN
						EXECUTE 'UPDATE '||rec_inp||' SET descript = replace(text,'||quote_literal(rec.feature_id)||', '||quote_literal(v_id)||' )
						WHERE position('||quote_literal(rec.feature_id)||' in descript) > 0;';
					END IF;
				END LOOP;

				--inp_tags
				EXECUTE 'UPDATE inp_tags SET feature_id = '||quote_literal(v_id)||' 
				WHERE feature_id='||quote_literal(rec.feature_id)||';';
			END IF;
		ELSE
			EXECUTE 'UPDATE temp_data SET enabled=FALSE WHERE feature_id='||quote_literal(rec.feature_id)||';';
		END IF;

	END LOOP;

	EXECUTE concat('SELECT count(*) FROM temp_data WHERE feature_type=''node'' AND fid=439 AND enabled IS NULL') INTO v_count;
	IF v_count > 0 THEN
		INSERT INTO audit_check_data (fid, criticity, result_id, error_message, fcount)
		VALUES (439, 1, '439', concat('INFO: There are ',v_count,' nodes with new ID. Old values are set on code field. Features can be consulted in temp_data, fid 439.'),v_count);
	END IF;

	EXECUTE concat('SELECT count(*) FROM temp_data WHERE feature_type=''arc'' AND fid=439 AND enabled IS NULL') INTO v_count;
	IF v_count > 0 THEN
		INSERT INTO audit_check_data (fid, criticity, result_id, error_message, fcount)
		VALUES (439, 1, '439', concat('INFO: There are ',v_count,' arcs with new ID. Old values are set on code field. Features can be consulted in temp_data, fid 439.'),v_count);
	END IF;

	EXECUTE concat('SELECT count(*) FROM temp_data WHERE feature_type=''connec'' AND fid=439 AND enabled IS NULL') INTO v_count;
	IF v_count > 0 THEN
		INSERT INTO audit_check_data (fid, criticity, result_id, error_message, fcount)
		VALUES (439, 1, '439', concat('INFO: There are ',v_count,' connecs with new ID. Old values are set on code field. Features can be consulted in temp_data, fid 439.'),v_count);
	END IF;

	IF project_type_aux='UD' THEN
		EXECUTE concat('SELECT count(*) FROM temp_data WHERE feature_type=''gully'' AND fid=439 AND enabled IS NULL') INTO v_count;
		IF v_count > 0 THEN
			INSERT INTO audit_check_data (fid, criticity, result_id, error_message, fcount)
			VALUES (439, 1, '439', concat('INFO: There are ',v_count,' gullies with new ID. Old values are set on code field. Features can be consulted in temp_data, fid 439.'),v_count);
		END IF;
	END IF;

	EXECUTE concat('SELECT count(*) FROM temp_data WHERE fid=439 AND enabled IS FALSE') INTO v_count;
	IF v_count > 0 THEN
		INSERT INTO audit_check_data (fid, criticity, result_id, error_message, fcount)
		VALUES (439, 1, '439', concat('WARNING-439: There are ',v_count,' features with text ID unchanged during the process because they are shorter then 3 characters. Features can be consulted in temp_data, fid 439, enabled FALSE.'),v_count);
	END IF;

	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, error_message as message FROM audit_check_data WHERE cur_user="current_user"() AND fid=439 order by  id asc) row;

	--    Control nulls
	v_result_info := COALESCE(v_result, '{}'); 

	--  Return
	RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"Process done successfully"}, "version":"'||v_version||'"'||
	      ',"body":{"form":{}'||
	     ',"data":{ "info":'||v_result_info||'}}'||
	     '}')::json,3136, null, null, null);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
