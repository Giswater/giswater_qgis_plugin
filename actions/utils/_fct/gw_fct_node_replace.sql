/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2126


DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_node_replace(character varying, varchar, date, boolean);


CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_node_replace(
    old_node_id_aux character varying,
    workcat_id_end_aux character varying,
    enddate_aux date,
    keep_elements_bool boolean)
  RETURNS character varying AS
$BODY$
DECLARE

	the_geom_aux public.geometry;
	query_string_select text;
	query_string_insert text;
	query_string_update text;
	arc_id_aux varchar;
	new_node_id_aux varchar;
	column_aux varchar;
	value_aux text;
	state_aux integer;
	state_type_aux integer;
	epa_type_aux text;
	rec_arc record;	
	project_type_aux varchar;
	nodetype_aux varchar;
	nodecat_aux varchar;
	sector_id_aux integer;
	dma_id_aux integer;
	expl_id_aux integer;
	man_table_aux varchar;
	epa_table_aux varchar;
	v_urn_id int8;
	v_code_autofill boolean;
	v_code	int8;
	v_node_id int8;
	
	
	
BEGIN

	-- Search path
	SET search_path = 'SCHEMA_NAME', public;

	-- values
	SELECT wsoftware INTO project_type_aux FROM version LIMIT 1;
	IF project_type_aux='WS' then
		SELECT nodetype_id INTO  nodetype_aux FROM v_edit_node WHERE node_id=old_node_id_aux;
	ELSE 
		SELECT node_type INTO nodetype_aux FROM v_edit_node WHERE node_id=old_node_id_aux;
	END IF;
	SELECT nodecat_id INTO nodecat_aux FROM v_edit_node WHERE node_id=old_node_id_aux;
	SELECT epa_type INTO epa_type_aux FROM v_edit_node WHERE node_id=old_node_id_aux;
	SELECT state_type INTO state_type_aux FROM v_edit_node WHERE node_id=old_node_id_aux;
	SELECT sector_id INTO sector_id_aux FROM v_edit_node WHERE node_id=old_node_id_aux;
	SELECT dma_id INTO dma_id_aux FROM v_edit_node WHERE node_id=old_node_id_aux;
	SELECT state INTO state_aux FROM v_edit_node WHERE node_id=old_node_id_aux;
	SELECT state_type INTO state_type_aux FROM v_edit_node WHERE node_id=old_node_id_aux;
	SELECT the_geom INTO the_geom_aux FROM v_edit_node WHERE node_id=old_node_id_aux;
	SELECT expl_id INTO expl_id_aux FROM v_edit_node WHERE node_id=old_node_id_aux;


	-- Control of state(1)
	IF (state_aux=0 OR state_aux=2 OR state_aux IS NULL) THEN
		PERFORM audit_function(1070,2126,state_aux::text);
	ELSE

		-- node_id
		v_node_id := (SELECT nextval('SCHEMA_NAME.urn_id_seq'));

		-- code
		SELECT code_autofill INTO v_code_autofill FROM node_type WHERE id=nodetype_aux;
		IF v_code_autofill IS TRUE THEN
			v_code = v_node_id;
		END IF;

		-- inserting new feature on table node
		IF project_type_aux='WS' then
			INSERT INTO node (node_id, code, nodecat_id, epa_type, sector_id, dma_id, expl_id, state, state_type, the_geom) 
			VALUES (v_node_id, v_code, nodecat_aux, epa_type_aux, sector_id_aux, dma_id_aux, expl_id_aux,  
			0, state_type_aux, the_geom_aux);
		ELSE 
			INSERT INTO node (node_id, code, node_type, nodecat_id, epa_type, sector_id, dma_id, expl_id, state, state_type, the_geom) 
			VALUES (v_node_id, v_code, nodetype_aux, nodecat_aux, epa_type_aux, sector_id_aux, dma_id_aux, expl_id_aux, 
			0, state_type_aux, the_geom_aux);
		END IF;
		
		-- inserting new feature on table man_table
		SELECT man_table INTO man_table_aux FROM node_type WHERE id=nodetype_aux;
		query_string_insert='INSERT INTO '||man_table_aux||' VALUES ('||v_node_id||');';
		execute query_string_insert;
		
		-- inserting new feature on table epa_table
		SELECT epa_table INTO epa_table_aux FROM node_type WHERE id=nodetype_aux;		
		query_string_insert='INSERT INTO '||epa_table_aux||' VALUES ('||v_node_id||');';
		execute query_string_insert;
		

		-- updating values on table node from vaules of old feature		
		FOR column_aux IN select column_name    FROM information_schema.columns 
							where (table_schema='SCHEMA_NAME' and udt_name <> 'inet' and 
							table_name='node') and column_name!='node_id' and column_name!='the_geom' and column_name!='state'
							and column_name!='code' and column_name!='epa_type' and column_name!='state_type' and column_name!='nodecat_id'
							and column_name!='sector_id' and column_name!='dma_id' and column_name!='expl_id'
		LOOP
			query_string_select= 'SELECT '||column_aux||' FROM node where node_id='||quote_literal(old_node_id_aux)||';';
			IF query_string_select IS NOT NULL THEN
				EXECUTE query_string_select INTO value_aux;	
			END IF;
			
			query_string_update= 'UPDATE node set '||column_aux||'='||quote_literal(value_aux)||' where node_id='||quote_literal(v_node_id)||';';
			IF query_string_update IS NOT NULL THEN
				EXECUTE query_string_update; 
			END IF;
		END LOOP;


		-- updating values on table man_table from vaules of old feature
		FOR column_aux IN select column_name    FROM information_schema.columns 
							where (table_schema='SCHEMA_NAME' and udt_name <> 'inet' and 
							table_name=man_table_aux) and column_name!='node_id'
		LOOP
			query_string_select= 'SELECT '||column_aux||' FROM '||man_table_aux||' where node_id='||quote_literal(old_node_id_aux)||';';
			IF query_string_select IS NOT NULL THEN
				EXECUTE query_string_select INTO value_aux;	
			END IF;
			
			query_string_update= 'UPDATE '||man_table_aux||' set '||column_aux||'='||quote_literal(value_aux)||' where node_id='||quote_literal(v_node_id)||';';
			IF query_string_update IS NOT NULL THEN
				EXECUTE query_string_update; 
			END IF;
		END LOOP;

		-- updating values on table epa_table from vaules of old feature
		FOR column_aux IN select column_name    FROM information_schema.columns 
							where (table_schema='SCHEMA_NAME' and udt_name <> 'inet' and 
							table_name=epa_table_aux) and column_name!='node_id'
		LOOP
			query_string_select= 'SELECT '||column_aux||' FROM '||epa_table_aux||' where node_id='||quote_literal(old_node_id_aux)||';';
			IF query_string_select IS NOT NULL THEN
				EXECUTE query_string_select INTO value_aux;	
			END IF;
			
			query_string_update= 'UPDATE '||epa_table_aux||' set '||column_aux||'='||quote_literal(value_aux)||' where node_id='||quote_literal(v_node_id)||';';
			IF query_string_update IS NOT NULL THEN
				EXECUTE query_string_update; 
			END IF;
		END LOOP;


		-- taking values from old feature (from man_addfields table)
		INSERT INTO man_addfields_value (feature_id, parameter_id, value_param)
		SELECT 
		v_node_id,
		parameter_id,
		value_param
		FROM man_addfields_value WHERE feature_id=old_node_id_aux;


		--Moving elements from old node to new node
		IF keep_elements_bool IS TRUE THEN
			UPDATE element_x_node SET node_id=v_node_id WHERE node_id=old_node_id_aux;		
		END IF;
	
	
		-- reconnecting arcs
		-- Dissable config parameter arc_searchnodes
		UPDATE config SET arc_searchnodes_control=FALSE;
			
		FOR rec_arc IN SELECT arc_id FROM arc WHERE node_1=old_node_id_aux
		LOOP
			UPDATE arc SET node_1=v_node_id where arc_id=rec_arc.arc_id;
		END LOOP;
	
		FOR rec_arc IN SELECT arc_id FROM arc WHERE node_2=old_node_id_aux
		LOOP
			UPDATE arc SET node_2=v_node_id where arc_id=rec_arc.arc_id;
		END LOOP;
	
		-- upgrading and downgrading nodes
		UPDATE node SET state=0, workcat_id_end=workcat_id_end_aux, enddate=enddate_aux WHERE node_id=old_node_id_aux;
		UPDATE node SET state=1, workcat_id=workcat_id_end_aux, builtdate=enddate_aux, enddate=NULL WHERE node_id=v_node_id::text;
	
		-- enable config parameter arc_searchnodes
		UPDATE config SET arc_searchnodes_control=TRUE;
		
	END IF;
		
RETURN v_node_id;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION SCHEMA_NAME.gw_fct_node_replace(character varying, character varying, date, boolean)
  OWNER TO postgres;
