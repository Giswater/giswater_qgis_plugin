
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_node_replace(
    old_node_id_aux character varying,
    table_aux character varying)
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
	rec_arc record;	

BEGIN

	-- Search path
	SET search_path = 'SCHEMA_NAME', public;

	-- values
	SELECT the_geom INTO the_geom_aux FROM v_edit_node WHERE node_id=old_node_id_aux;
	SELECT state INTO state_aux FROM v_edit_node WHERE node_id=old_node_id_aux;

	-- Control of state(1)
	IF (state_aux=0 OR state_aux=2 OR state_aux IS NULL) THEN
		RAISE EXCEPTION 'The feature not have state(1) value to be replaced, state = %', state_aux;
	ELSE

		-- inserting new feature
		INSERT INTO v_edit_node (state, the_geom) VALUES (0, the_geom_aux) returning node_id into new_node_id_aux;
		raise notice 'new_node_id_aux %',new_node_id_aux;

		-- taking vaules from old feature (from table node)
		FOR column_aux IN select column_name    FROM information_schema.columns 
							where (table_schema='SCHEMA_NAME' and udt_name <> 'inet' and 
							table_name='node') and column_name!='node_id' and column_name!='the_geom' and column_name!='state'
		LOOP
			query_string_select= 'SELECT '||column_aux||' FROM node where node_id='||quote_literal(old_node_id_aux)||';';
			IF query_string_select IS NOT NULL THEN
				EXECUTE query_string_select INTO value_aux;	
				raise notice 'value_aux %',value_aux;
			END IF;
			
			query_string_update= 'UPDATE node set '||column_aux||'='||quote_literal(value_aux)||' where node_id='||quote_literal(new_node_id_aux)||';';
			IF query_string_update IS NOT NULL THEN
				raise notice 'query_string_update %',query_string_update;
				EXECUTE query_string_update; 
			END IF;
		END LOOP;




		
		-- taking values from old feature (from v_edit_man table)
		FOR column_aux IN select column_name    FROM information_schema.columns 
							where (table_schema='SCHEMA_NAME' and udt_name <> 'inet' and 
							table_name=table_aux) and column_name!='node_id' and column_name!='the_geom' and column_name!='state'
		LOOP
			query_string_select= 'SELECT '||column_aux||' FROM '||table_aux||' where node_id='||quote_literal(old_node_id_aux)||';';
			IF query_string_select IS NOT NULL THEN
				EXECUTE query_string_select INTO value_aux;	
				raise notice 'value_aux %',value_aux;
			END IF;
			
			query_string_update= 'UPDATE '||table_aux||' set '||column_aux||'='||quote_literal(value_aux)||' where node_id='||quote_literal(new_node_id_aux)||';';
			IF query_string_update IS NOT NULL THEN
				raise notice 'query_string_update %',query_string_update;
				EXECUTE query_string_update; 
			END IF;
		END LOOP;


	-- taking values from old feature (from man_addfields table)
	-- todo;
		
	
		-- reconnecting arcs
		-- Dissable config parameter arc_searchnodes
		UPDATE config SET arc_searchnodes_control=FALSE;
		RAISE NOTICE 'PERICO';

		
		FOR rec_arc IN SELECT arc_id FROM arc WHERE node_1=old_node_id_aux
		LOOP
			UPDATE arc SET node_1=new_node_id_aux where arc_id=rec_arc.arc_id;
		END LOOP;
	
		FOR rec_arc IN SELECT arc_id FROM arc WHERE node_2=old_node_id_aux
		LOOP
			UPDATE arc SET node_2=new_node_id_aux where arc_id=rec_arc.arc_id;
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
ALTER FUNCTION SCHEMA_NAME.gw_fct_node_replace(character varying, character varying)
  OWNER TO postgres;
