/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

DROP FUNCTION if exists SCHEMA_NAME.gw_fct_node_replace( varchar,  varchar,  varchar);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_node_replace(old_node_id_aux varchar, function_aux varchar, table_aux varchar)
  RETURNS integer AS
$BODY$
DECLARE

	the_geom_aux public.geometry;
	query_string_select text;
	query_string_update text;
	arc_id_aux varchar;
	new_node_id_aux varchar;
	column_aux varchar;
	value_aux text;
	state_aux integer;
	new_arc_id_aux varchar;
	query_string varchar;
	

BEGIN


	-- Search path
	SET search_path = "SCHEMA_NAME", public;

--	table_aux=quote_literal(table_aux_var);
	
	-- values
	query_string= ' SELECT the_geom FROM '||table_aux||' where node_id='||quote_literal(old_node_id_aux)||';';
	EXECUTE query_string INTO the_geom_aux;

	query_string= ' SELECT state FROM '||table_aux||' where node_id='||quote_literal(old_node_id_aux)||';';
	EXECUTE query_string INTO state_aux;	


IF function_aux='editor' THEN 

	-- Control of state(1)
	IF (state_aux=0 OR state_aux=2 OR state_aux IS NULL) THEN
		RAISE EXCEPTION 'The feature does not have state(1) value to be replaced, state = %', state_aux;
	ELSE

		-- inserting new feature
		query_string= ' INSERT INTO '||table_aux||' (state,the_geom) VALUES where node_id='||quote_literal(old_node_id_aux)||';';
		EXECUTE query_string INTO state_aux;	

		INSERT INTO table_aux (state, the_geom) VALUES (0, the_geom_aux) returning node_id into new_node_id_aux;
		
		-- taking values from old feature
		FOR column_aux IN select column_name   FROM information_schema.columns 
							where table_schema='SCHEMA_NAME' and udt_name <> 'inet' and 
							table_name=table_aux and column_name!='node_id' and column_name!='code' 	
							and column_name!='the_geom' and column_name!='state'
		LOOP
			query_string_select= 'SELECT '||column_aux||' FROM '||table_aux||' where node_id='||quote_literal(node_ori_aux)||';';
			IF value_aux IS NOT NULL THEN
				EXECUTE query_string_select INTO value_aux;	
			END IF;
	
			query_string_update= 'UPDATE '||table_aux||' set '||column_aux||'='||quote_literal(value_aux)||'::'||udt_name_aux||' where node_id='||quote_literal(node_desti_aux)||';';
			IF value_aux IS NOT NULL THEN
				EXECUTE query_string_update; 
			END IF;
		END LOOP;
	
		
		-- Dissable config parameter arc_searchnodes
		UPDATE config SET arc_searchnodes_control=FALSE;

		-- reconnecting arcs (node_id=node_1)
		FOR arc_id_aux IN SELECT arc_id FROM arc WHERE node_1=old_node_id_aux
		LOOP
			UPDATE arc SET node_1=new_node_id_aux;
		END LOOP;
		
		-- reconnecting arcs (node_id=node_2)
		FOR arc_id_aux IN SELECT arc_id FROM arc WHERE node_2=old_node_id_aux
		LOOP
			UPDATE arc SET node_2=new_node_id_aux;
		END LOOP;
	
		-- upgrading and downgrading nodes
		UPDATE node SET state=0 WHERE node_id=old_node_id_aux;
		UPDATE node SET state=1 WHERE node_id=new_node_id_aux;
	
		-- enable config parameter arc_searchnodes
		UPDATE config SET arc_searchnodes_control=TRUE;
		
	END IF;
	
ELSIF function_aux='master' THEN 

	-- Control of state(2)
	IF (state_aux=0 OR state_aux=1 OR state_aux IS NULL) THEN
		RAISE EXCEPTION 'The feature not have state(2) value to be replaced, state = %', state_aux;
	ELSE
		-- inserting new feature
		INSERT INTO table_aux (state, the_geom) VALUES (2, the_geom_aux) returning node_id into new_node_id_aux;
		
		-- taking values from old feature
		FOR column_aux IN select column_name   FROM information_schema.columns 
							where table_schema='SCHEMA_NAME' and udt_name <> 'inet' and 
							table_name=table_aux and column_name!='node_id' and column_name!='code' 	
							and column_name!='the_geom' and column_name!='state'
		LOOP
			query_string_select= 'SELECT '||column_aux||' FROM '||table_aux||' where node_id='||quote_literal(node_ori_aux)||';';
			IF value_aux IS NOT NULL THEN
				EXECUTE query_string_select INTO value_aux;	
			END IF;
	
			query_string_update= 'UPDATE '||table_aux||' set '||column_aux||'='||quote_literal(value_aux)||'::'||udt_name_aux||' where node_id='||quote_literal(node_desti_aux)||';';
			IF value_aux IS NOT NULL THEN
				EXECUTE query_string_update; 
			END IF;
		END LOOP;
		
		-- looking for arcs 		
		FOR arc_id_aux IN SELECT arc_id FROM arc WHERE node_1=old_node_id_aux OR node_2=old_node_id_aux AND state=1
		LOOP
			-- Looking for the table that belongs arc
			IF (SELECT wsoftware FROM version LIMIT 1)='WS' THEN
				SELECT man_table into table_aux FROM node_type JOIN cat_arc ON arctype_id=id JOIN arc ON arccat_id=id WHERE arc_id=arc_id_aux;
			ELSE
				SELECT man_table into table_aux FROM node_type JOIN arc ON arc_type="type" WHERE arc_id=arc_id_aux;
			END IF;
			
			-- Looking for geometry
			SELECT the_geom INTO the_geom_aux FROM arc WHERE arc_id=arc_id_aux;

			-- inserting new arc into table
			INSERT INTO table_aux (state, the_geom) VALUES (2, the_geom_aux) returning arc_id into new_arc_id_aux;
		
			-- taking values from old arc
			FOR column_aux IN select column_name   FROM information_schema.columns 
							where table_schema='SCHEMA_NAME' and udt_name <> 'inet' and 
							table_name=table_aux and column_name!='arc_id' and column_name!='code' 	
							and column_name!='the_geom' and column_name!='state'
			LOOP
				query_string_select= 'SELECT '||column_aux||' FROM '||table_aux||' where arc_id='||quote_literal(arc_id_aux)||';';
				IF value_aux IS NOT NULL THEN
					EXECUTE query_string_select INTO value_aux;	
				END IF;

				--Inserting values on new arc;
				query_string_update= 'UPDATE '||table_aux||' set '||column_aux||'='||quote_literal(value_aux)||'::'||udt_name_aux||' where arc_id='||quote_literal(new_arc_id_aux)||';';
				IF value_aux IS NOT NULL THEN
					EXECUTE query_string_update; 
				END IF;

				--Reconnecting new arcs;
				UPDATE arc SET node_1=new_arc_id_aux where node_1=old_arc_id_aux and arc_id=new_arc_id_aux;
				UPDATE arc SET node_2=new_arc_id_aux where node_2=old_arc_id_aux and arc_id=new_arc_id_aux;
				
			END LOOP;
		END LOOP;
	END IF;
END IF;
	
		
RETURN 1;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;