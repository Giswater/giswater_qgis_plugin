/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE:


CREATE OR REPLACE FUNCTION ud.gw_fct_pg2epa_repair_epatype(p_data json)
  RETURNS json AS
$BODY$

/* example

-- execute

SELECT ud.gw_fct_pg2epa_repair_epatype($${"client":{"device":4, "infoType":1, "lang":"ES"}}$$);


ALTER TABLE ws.cat_feature_node DROP CONSTRAINT node_type_epa_table_check;

ALTER TABLE ws.cat_feature_node
  ADD CONSTRAINT node_type_epa_table_check CHECK (epa_table::text = ANY (ARRAY['inp_virtualvalve'::text, 'inp_inlet'::text, 'not_defined'::text, 'inp_junction'::text, 'inp_pump'::text, 'inp_reservoir'::text, 'inp_tank'::text, 'inp_valve'::text, 'inp_shortpipe'::text]));


-- log
SELECT * FROM ws.audit_check_data where fid = 214 AND criticity  > 1 order by id

-- check ws
SELECT * FROM 
(SELECT epa_type, count(*) as count_node FROM node where state > 0 group by epa_type order by 2)a
FULL JOIN
(SELECT 'JUNCTION' AS epa_type, count(*) as count_inp FROM inp_junction join node using (node_id ) where state > 0
union
SELECT 'RESERVOIR', count(*) FROM inp_reservoir join node using (node_id ) where state > 0
union
SELECT 'PUMP', count(*) FROM inp_pump join node using (node_id ) where state > 0
union
SELECT 'TANK', count(*) FROM inp_tank join node using (node_id ) where state > 0
union
SELECT 'SHORTPIPE', count(*) FROM inp_shortpipe join node using (node_id ) where state > 0
union
SELECT 'VALVE', count(*) FROM inp_valve join node using (node_id ) where state > 0
union
SELECT 'INLET', count(*) FROM inp_inlet join node using (node_id ) where state > 0)b
USING (epa_type)


-- check ud
SELECT * FROM 
(SELECT epa_type, count(*) as count_node FROM node where state > 0 group by epa_type order by 2)a
FULL JOIN
(SELECT 'JUNCTION' AS epa_type, count(*) as count_inp FROM inp_junction join node using (node_id ) where state > 0
union
SELECT 'STORAGE', count(*) FROM inp_storage join node using (node_id ) where state > 0  
union
SELECT 'DIVIDER', count(*) FROM inp_divider join node using (node_id ) where state > 0 
union
SELECT 'OUTFALL', count(*) FROM inp_outfall join node using (node_id ) where state > 0  )b
>>>>>>> 48e1595f5... Update pg2epa_repair_epa_type function
USING (epa_type)
*/





DECLARE
v_version text;
v_error_context text;
v_projecttype text;
v_affectrow integer;
v_fid integer = 214;
v_criticity integer = 0;

rec_feature record;

BEGIN


	-- Set search path to local schema
	SET search_path = "ud", public;
	
	--  get version
	SELECT project_type, giswater INTO v_projecttype, v_version FROM sys_version;

	-- delete auxiliar tables
	DELETE FROM audit_check_data WHERE fid = v_fid;
	
	IF v_projecttype  = 'WS' THEN
	
		FOR rec_feature IN 
		SELECT DISTINCT ON (cat_feature_node.id) cat_feature_node.*, cat_node.id as nodecat_id, s.epa_table FROM cat_node JOIN cat_feature_node ON cat_node.nodetype_id = cat_feature_node.id 
		JOIN cat_feature ON cat_feature_node.id = cat_feature.id JOIN sys_feature_epa_type s ON cat_feature_node.epa_default = s.id
		WHERE epa_default != 'UNDEFINED' AND cat_feature.active = true
		LOOP

			-- check if exists features with this cat_feature
			UPDATE node SET epa_type = epa_type FROM cat_node WHERE nodetype_id = rec_feature.id AND state > 0 AND cat_node.id = nodecat_id;
			GET DIAGNOSTICS v_affectrow = row_count;
			IF v_affectrow = 0 THEN 
				INSERT INTO audit_check_data (fid,  criticity, error_message)
				VALUES (v_fid, 2, concat(rec_feature.id,': No features are on inventory with this cat_feature. If you do not uses, we recommend to disable it (cat_feature.active = false)'));
			END IF;
		
			-- update epa_type
			UPDATE node SET epa_type = rec_feature.epa_default FROM cat_node WHERE nodetype_id = rec_feature.id AND state > 0 AND cat_node.id = nodecat_id AND epa_type != rec_feature.epa_default;
			
			GET DIAGNOSTICS v_affectrow = row_count;
			IF v_affectrow > 0 THEN v_criticity = 2; ELSE v_criticity = 1; END IF;
			INSERT INTO audit_check_data (fid,  criticity, error_message)
			VALUES (v_fid, v_criticity, concat(rec_feature.id,': UPDATE node SET epa_type = ',quote_literal(rec_feature.epa_default),' WHERE nodecat_id = ''', rec_feature.id,''' AND state > 0 - ',v_affectrow, ' ROWS' ));

			RAISE NOTICE 'rec_feature % afected row %', rec_feature, v_affectrow;
		
			-- insert missed features on inp tables
			EXECUTE 'INSERT INTO '||quote_ident(rec_feature.epa_table)||' (node_id)   
				SELECT node_id FROM node LEFT JOIN (SELECT node_id FROM '||quote_ident(rec_feature.epa_table)||' ) b USING (node_id)
				WHERE epa_type = '||quote_literal(rec_feature.epa_default)||'  AND b.node_id IS NULL AND state >0	
				ON CONFLICT (node_id) DO NOTHING';
				
			GET DIAGNOSTICS v_affectrow = row_count;
			IF v_affectrow > 0 THEN v_criticity = 2; ELSE v_criticity = 1; END IF;
			INSERT INTO audit_check_data (fid,  criticity, error_message)
			VALUES (v_fid, v_criticity, concat(rec_feature.id,': INSERT INTO ',rec_feature.epa_table, ' - ', v_affectrow, ' ROWS'));

		END LOOP;

		UPDATE node SET epa_type = 'UNDEFINED' FROM cat_feature_node f JOIN cat_node c ON c.nodetype_id = f.id WHERE f.epa_default = 'UNDEFINED' and node.nodecat_id = c.id;

		-- node's delete
		FOR rec_feature IN 
		SELECT DISTINCT ON (epa_default) c.*, epa_table FROM cat_feature_node c JOIN sys_feature_epa_type s ON c.epa_default = s.id WHERE epa_default !='UNDEFINED'
		LOOP
			RAISE NOTICE 'rec_feature % ', rec_feature;
			
			-- delete wrong features on inp tables
			EXECUTE 'DELETE FROM '||quote_ident(rec_feature.epa_table)||' WHERE node_id NOT IN (SELECT node_id FROM node WHERE epa_type = '||quote_literal(rec_feature.epa_default)||' AND state > 0)';
			GET DIAGNOSTICS v_affectrow = row_count;
			IF v_affectrow > 0 THEN v_criticity = 2; ELSE v_criticity = 1; END IF;
			INSERT INTO audit_check_data (fid,  criticity, error_message)
			VALUES (v_fid, v_criticity, concat(rec_feature.id,': DELETE FROM ',rec_feature.epa_table,' - ',v_affectrow, ' ROWS'));

			EXECUTE 'DELETE FROM '||quote_ident(rec_feature.epa_table)||' WHERE node_id IN (SELECT node_id FROM node WHERE epa_type = ''UNDEFINED'' AND state > 0)';
			GET DIAGNOSTICS v_affectrow = row_count;
			IF v_affectrow > 0 THEN v_criticity = 2; ELSE v_criticity = 1; END IF;
			INSERT INTO audit_check_data (fid,  criticity, error_message)
			VALUES (v_fid, v_criticity, concat(rec_feature.id,': DELETE FROM ',rec_feature.epa_table,' - ',v_affectrow, ' ROWS'));			
		END LOOP;

		-- arc's insert
		FOR rec_feature IN 
		SELECT DISTINCT ON (cat_feature_arc.id) cat_feature_arc.*, cat_arc.id as arccat_id, epa_table FROM cat_arc JOIN cat_feature_arc ON cat_arc.arctype_id = cat_feature_arc.id 
		JOIN cat_feature ON cat_feature_arc.id = cat_feature.id JOIN sys_feature_epa_type s ON cat_feature_arc.epa_default = s.id
		WHERE epa_default != 'UNDEFINED' AND cat_feature.active = true
		LOOP

			-- check if exists features with this cat_feature
			UPDATE arc SET epa_type = epa_type FROM cat_arc WHERE arctype_id = rec_feature.id AND state > 0 AND cat_arc.id = arccat_id;
			GET DIAGNOSTICS v_affectrow = row_count;
			IF v_affectrow = 0 THEN 
				INSERT INTO audit_check_data (fid,  criticity, error_message)
				VALUES (v_fid, 2, concat(rec_feature.id,': No features are on inventory with this cat_feature. If you do not uses, we recommend to disable it (cat_feature.active = false)'));
			END IF;
		
			-- update epa_type
			UPDATE arc SET epa_type = rec_feature.epa_default FROM cat_arc WHERE arctype_id = rec_feature.id AND state > 0 AND cat_arc.id = arccat_id AND epa_type != rec_feature.epa_default;
			
			GET DIAGNOSTICS v_affectrow = row_count;
			IF v_affectrow > 0 THEN v_criticity = 2; ELSE v_criticity = 1; END IF;
			INSERT INTO audit_check_data (fid,  criticity, error_message)
			VALUES (v_fid, v_criticity, concat(rec_feature.id,': UPDATE arc SET epa_type = ',quote_literal(rec_feature.epa_default),' WHERE arccat_id = ''', rec_feature.id,''' AND state > 0 - ',v_affectrow, ' ROWS' ));

			RAISE NOTICE 'rec_feature % afected row %', rec_feature, v_affectrow;
		
			-- insert missed features on inp tables
			EXECUTE 'INSERT INTO '||quote_ident(rec_feature.epa_table)||' (arc_id)   
				SELECT arc_id FROM arc LEFT JOIN (SELECT arc_id FROM '||quote_ident(rec_feature.epa_table)||' ) b USING (arc_id)
				WHERE epa_type = '||quote_literal(rec_feature.epa_default)||'  AND b.arc_id IS NULL AND state >0	
				ON CONFLICT (arc_id) DO NOTHING';
				
			GET DIAGNOSTICS v_affectrow = row_count;
			IF v_affectrow > 0 THEN v_criticity = 2; ELSE v_criticity = 1; END IF;
			INSERT INTO audit_check_data (fid,  criticity, error_message)
			VALUES (v_fid, v_criticity, concat(rec_feature.id,': INSERT INTO ',rec_feature.epa_table, ' - ', v_affectrow, ' ROWS'));

		END LOOP;

		-- arcs's delete
		FOR rec_feature IN 
		SELECT DISTINCT ON (epa_default) c.*, epa_table FROM cat_feature_arc c JOIN sys_feature_epa_type s ON c.epa_default = s.id
		LOOP
			-- delete wrong features on inp tables
			EXECUTE 'DELETE FROM '||quote_ident(rec_feature.epa_table)||' WHERE arc_id NOT IN (SELECT arc_id FROM arc WHERE epa_type = '||quote_literal(rec_feature.epa_default)||' AND state > 0)';
		
			GET DIAGNOSTICS v_affectrow = row_count;

			RAISE NOTICE 'rec_feature % afected row %', rec_feature, v_affectrow;

			
			IF v_affectrow > 0 THEN v_criticity = 2; ELSE v_criticity = 1; END IF;
			INSERT INTO audit_check_data (fid,  criticity, error_message)
			VALUES (v_fid, v_criticity, concat(rec_feature.id,': DELETE FROM ',rec_feature.epa_table,' - ',v_affectrow, ' ROWS'));
			
		END LOOP;

		-- connec
		INSERT INTO inp_connec
		SELECT connec_id FROM connec WHERE state > 0 
		ON CONFLICT (connec_id) DO NOTHING;

	ELSE 
		INSERT INTO inp_junction
		SELECT node_id FROM node WHERE state >0 and epa_type = 'JUNCTION'
		ON CONFLICT (node_id) DO NOTHING;

		INSERT INTO inp_storage
		SELECT node_id FROM node WHERE state >0 and epa_type = 'STORAGE'
		ON CONFLICT (node_id) DO NOTHING;

		INSERT INTO inp_outfall
		SELECT node_id FROM node WHERE state >0 and epa_type = 'OUTFALL'
		ON CONFLICT (node_id) DO NOTHING;
		
		INSERT INTO inp_divider
		SELECT node_id FROM node WHERE state >0 and epa_type = 'DIVIDER'
		ON CONFLICT (node_id) DO NOTHING;
		
		DELETE FROM inp_junction WHERE node_id IN (SELECT node_id FROM node WHERE epa_type = 'UNDEFINED');
		DELETE FROM inp_storage WHERE node_id IN (SELECT node_id FROM node WHERE epa_type = 'UNDEFINED');
		DELETE FROM inp_outfall WHERE node_id IN (SELECT node_id FROM node WHERE epa_type = 'UNDEFINED');
		DELETE FROM inp_divider WHERE node_id IN (SELECT node_id FROM node WHERE epa_type = 'UNDEFINED');

		DELETE FROM inp_junction WHERE node_id NOT IN (SELECT node_id FROM node WHERE epa_type = 'JUNCTION');
		DELETE FROM inp_storage WHERE node_id NOT IN (SELECT node_id FROM node WHERE epa_type = 'STORAGE');
		DELETE FROM inp_outfall WHERE node_id NOT IN (SELECT node_id FROM node WHERE epa_type = 'OUTFALL');
		DELETE FROM inp_divider WHERE node_id NOT IN (SELECT node_id FROM node WHERE epa_type = 'DIVIDER');

	END IF;
	     
	-- Return
	RETURN '{"status":"Accepted"}';

	-- Exception handling
	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


