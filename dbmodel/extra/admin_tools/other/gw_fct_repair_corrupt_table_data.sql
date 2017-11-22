/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_repair_corrupt_table_data()
  RETURNS void AS
$BODY$
DECLARE 

arcrec record;
arc_id_rec text;
arctype_aux text;

noderec record;
node_id_rec text;
nodetype_aux text;

epatype_aux text;
project_type_aux text;
man_table_aux text;
inp_table_aux text;
sql_query text;

connecrec record;
connec_id_rec text;
connectype_aux text;



BEGIN 

	SET search_path= 'SCHEMA_NAME','public';

	SELECT wsoftware INTO project_type_aux FROM version LIMIT 1; 


	-- Start procces for arc table
	FOR arcrec IN SELECT * FROM arc
	
	LOOP

		-- man tables
		IF project_type_aux='WS' then
			SELECT man_table INTO arctype_aux FROM arc_type JOIN cat_arc ON arctype_id=cat_arc.id JOIN arc ON cat_arc.id=arccat_id WHERE arc_id=arcrec.arc_id;		
		ELSE 
			SELECT man_table INTO arctype_aux FROM arc_type JOIN arc ON arc_type=id WHERE arc_id=arcrec.arc_id;
		END IF;

		SELECT epa_table INTO epatype_aux FROM arc_type JOIN arc ON epa_type=epa_default WHERE arc_id=arcrec.arc_id;
						
		--propagation values from arc table to man table
		FOR man_table_aux IN SELECT man_table FROM arc_type 
		LOOP
			--RAISE NOTICE ' A %, B %, C %',arcrec.arc_id, man_table_aux, arctype_aux;
			IF man_table_aux != arctype_aux THEN
				sql_query='DELETE FROM '||man_table_aux||' WHERE arc_id='||arcrec.arc_id||'::text;';
			--	RAISE NOTICE ' execute_query %', sql_query;
				execute sql_query;
			ELSE 		
				sql_query='select arc_id FROM '||man_table_aux||' where arc_id='||arcrec.arc_id||'::text;';
				execute sql_query INTO arc_id_rec;
				IF arc_id_rec != arcrec.arc_id THEN
					sql_query= 'INSERT INTO '||man_table_aux||' VALUES ('||arcrec.arc_id||'::text);';
			--		RAISE NOTICE ' execute_query %', sql_query;
					execute sql_query;
				END IF;
			END IF;	
		END LOOP;	

		--propagation values from arc table to inp table		
		FOR inp_table_aux IN SELECT epa_table FROM arc_type 
		LOOP
			IF inp_table_aux != epatype_aux THEN
				sql_query='DELETE FROM '||inp_table_aux||' WHERE arc_id='||arcrec.arc_id||'::text;';
			--	RAISE NOTICE ' execute_query %', sql_query;
				execute sql_query;
			ELSE 		
				sql_query='select arc_id FROM '||inp_table_aux||' where arc_id='||arcrec.arc_id||'::text;';
				execute sql_query INTO arc_id_rec;
				IF arc_id_rec != arcrec.arc_id THEN
					sql_query= 'INSERT INTO '||inp_table_aux||' VALUES ('||arcrec.arc_id||'::text);';
			--		RAISE NOTICE ' execute_query %', sql_query;
					execute sql_query;
				END IF;
			END IF;	
		
		END LOOP;		

	END LOOP;

	--delete registres on man_table not presents on arc table
	FOR man_table_aux IN SELECT DISTINCT man_table FROM arc_type 
	LOOP	
		sql_query='DELETE FROM '||man_table_aux||' WHERE arc_id NOT IN (SELECT arc_id FROM arc);';
		raise notice 'sql_query %', sql_query;
		execute sql_query;
	END LOOP;


	--delete registres on inp_table not presents on arc table
	FOR inp_table_aux IN SELECT DISTINCT epa_table FROM arc_type 
	LOOP	
		sql_query='DELETE FROM '||inp_table_aux||' WHERE arc_id NOT IN (SELECT arc_id FROM arc);';
		raise notice 'sql_query %', sql_query;
		execute sql_query;
	END LOOP;




	-- Start procces for node table
	FOR noderec IN SELECT * FROM node
	LOOP

		-- man tables
		IF project_type_aux='WS' then
			SELECT man_table INTO nodetype_aux FROM node_type JOIN cat_node ON nodetype_id=cat_node.id JOIN node ON cat_node.id=nodecat_id WHERE node_id=noderec.node_id;		
		ELSE 
			SELECT man_table INTO nodetype_aux FROM node_type JOIN node ON node_type=id WHERE node_id=noderec.node_id;
		END IF;

		SELECT epa_table INTO epatype_aux FROM node_type JOIN node ON epa_type=epa_default WHERE node_id=noderec.node_id;
						
		--propagation values from node table to man table
		FOR man_table_aux IN SELECT man_table FROM node_type 
		LOOP
			--RAISE NOTICE ' A %, B %, C %',noderec.node_id, man_table_aux, nodetype_aux;
			IF man_table_aux != nodetype_aux THEN
				sql_query='DELETE FROM '||man_table_aux||' WHERE node_id='||noderec.node_id||'::text;';
			--	RAISE NOTICE ' execute_query %', sql_query;
				execute sql_query;
			ELSE 		
				sql_query='select node_id FROM '||man_table_aux||' where node_id='||noderec.node_id||'::text;';
				execute sql_query INTO node_id_rec;
				IF node_id_rec != noderec.node_id THEN
					sql_query= 'INSERT INTO '||man_table_aux||' VALUES ('||noderec.node_id||'::text);';
			--		RAISE NOTICE ' execute_query %', sql_query;
					execute sql_query;
				END IF;
			END IF;	
		END LOOP;	

		--propagation values from node table to inp table		
		FOR inp_table_aux IN SELECT epa_table FROM node_type 
		LOOP
			IF inp_table_aux != epatype_aux THEN
				sql_query='DELETE FROM '||inp_table_aux||' WHERE node_id='||noderec.node_id||'::text;';
			--	RAISE NOTICE ' execute_query %', sql_query;
				execute sql_query;
			ELSE 		
				sql_query='select node_id FROM '||inp_table_aux||' where node_id='||noderec.node_id||'::text;';
				execute sql_query INTO node_id_rec;
				IF node_id_rec != noderec.node_id THEN
					sql_query= 'INSERT INTO '||inp_table_aux||' VALUES ('||noderec.node_id||'::text);';
			--		RAISE NOTICE ' execute_query %', sql_query;
					execute sql_query;
				END IF;
			END IF;	
		
		END LOOP;		

	END LOOP;

	--delete registres on man_table not presents on node table
	FOR man_table_aux IN SELECT DISTINCT man_table FROM node_type 
	LOOP	
		sql_query='DELETE FROM '||man_table_aux||' WHERE node_id NOT IN (SELECT node_id FROM node);';
		raise notice 'sql_query %', sql_query;
		execute sql_query;
	END LOOP;


	--delete registres on inp_table not presents on node table
	FOR inp_table_aux IN SELECT DISTINCT epa_table FROM node_type 
	LOOP	
		sql_query='DELETE FROM '||inp_table_aux||' WHERE node_id NOT IN (SELECT node_id FROM node);';
		raise notice 'sql_query %', sql_query;
		execute sql_query;
	END LOOP;





	-- Start procces for connec table
	FOR connecrec IN SELECT * FROM connec
	LOOP

		-- man tables
		IF project_type_aux='WS' then
			SELECT man_table INTO connectype_aux FROM connec_type JOIN cat_connec ON connectype_id=cat_connec.id JOIN connec ON cat_connec.id=connecat_id WHERE connec_id=connecrec.connec_id;		
		ELSE 
			SELECT man_table INTO connectype_aux FROM connec_type JOIN connec ON connec_type=id WHERE connec_id=connecrec.connec_id;
		END IF;		
						
		--propagation values from connec table to man table
		FOR man_table_aux IN SELECT man_table FROM connec_type 
		LOOP
			--RAISE NOTICE ' A %, B %, C %',connecrec.connec_id, man_table_aux, connectype_aux;
			IF man_table_aux != connectype_aux THEN
				sql_query='DELETE FROM '||man_table_aux||' WHERE connec_id='||connecrec.connec_id||'::text;';
			--	RAISE NOTICE ' execute_query %', sql_query;
				execute sql_query;
			ELSE 		
				sql_query='select connec_id FROM '||man_table_aux||' where connec_id='||connecrec.connec_id||'::text;';
				execute sql_query INTO connec_id_rec;
				IF connec_id_rec != connecrec.connec_id THEN
					sql_query= 'INSERT INTO '||man_table_aux||' VALUES ('||connecrec.connec_id||'::text);';
			--		RAISE NOTICE ' execute_query %', sql_query;
					execute sql_query;
				END IF;
			END IF;	
		END LOOP;	

	END LOOP;

	--delete registres on man_table not presents on connec table
	FOR man_table_aux IN SELECT DISTINCT man_table FROM connec_type 
	LOOP	
		sql_query='DELETE FROM '||man_table_aux||' WHERE connec_id NOT IN (SELECT connec_id FROM connec);';
		raise notice 'sql_query %', sql_query;
		execute sql_query;
	END LOOP;






	
  RETURN;
    
END;  
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

