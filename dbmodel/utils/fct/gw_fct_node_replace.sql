/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_node_replace(old_node_id_aux varchar, table_aux varchar)
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
	

BEGIN

	-- Search path
	SET search_path = "SCHEMA_NAME", public;

	-- values
	SELECT the_geom INTO the_geom_aux FROM v_edit_node WHERE node_id=old_node_id_aux;
	SELECT state INTO state_aux FROM v_edit_node WHERE node_id=old_node_id_aux;

	-- Control of state(1)
	IF (state_aux=0 OR state_aux=2 OR state_aux IS NULL) THEN
		RAISE EXCEPTION 'The feature not have state(1) value to be replaced, state = %', state_aux;
	ELSE

		-- inserting new feature
		INSERT INTO v_edit_node (state, the_geom) VALUES (0, the_geom_aux) returning node_id into new_node_id_aux;
		
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
	
		-- reconnecting arcs (node_id=node_1)
		
		-- Dissable config parameter arc_searchnodes
		UPDATE config SET arc_searchnodes_control=FALSE;
		
		FOR arc_id_aux IN SELECT arc_id FROM arc WHERE node_1=old_node_id_aux
		LOOP
		--	UPDATE arc SET state=0;
			UPDATE arc SET node_1=new_node_id_aux;
		END LOOP;
	
		-- downgrading and reconnecting arcs (node_id=node_2)
		FOR arc_id_aux IN SELECT arc_id FROM arc WHERE node_2=old_node_id_aux
		LOOP
		--	UPDATE arc SET state=0;
			UPDATE arc SET node_2=new_node_id_aux;
		END LOOP;
	
		-- upgrading and downgrading nodes
		UPDATE node SET state=0 WHERE node_id=old_node_id_aux;
		UPDATE node SET state=1 WHERE node_id=new_node_id_aux;
	
		-- enable config parameter arc_searchnodes
		UPDATE config SET arc_searchnodes_control=TRUE;
		
	END IF;
		
RETURN 1;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;