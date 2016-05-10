-- Function: "SCHEMA_NAME".gw_fct_flow_trace(character varying)

-- DROP FUNCTION "SCHEMA_NAME".gw_fct_flow_trace(character varying);

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_flow_trace(node_id_arg character varying)
  RETURNS json AS
$BODY$DECLARE

--	JSON variables
	Node_json json;
	Arc_json json;
	sql text;
 

BEGIN


--	Create the temporal table for computing nodes
	DROP TABLE IF EXISTS "SCHEMA_NAME".temp_flow_trace_node CASCADE;
	CREATE TABLE "SCHEMA_NAME".temp_flow_trace_node
	(		
		node_id character varying(16) NOT NULL,

--		Force indexed column (for performance)
		CONSTRAINT temp_flow_trace_node_pkey PRIMARY KEY (node_id)
	);


--	Create the temporal table for computing pipes
	DROP TABLE IF EXISTS "SCHEMA_NAME".temp_flow_trace_arc CASCADE;
	CREATE TABLE "SCHEMA_NAME".temp_flow_trace_arc
	(		
		arc_id character varying(16) NOT NULL,

--		Force indexed column (for performance)
		CONSTRAINT temp_flow_trace_arc_pkey PRIMARY KEY (arc_id)
	);



--	Compute the tributary area using DFS
	PERFORM "SCHEMA_NAME".gw_fct_flow_trace_recursive(node_id_arg);

--	Create JSON
	SELECT array_to_json(array_agg(node_id)) INTO Node_json FROM "SCHEMA_NAME".temp_flow_trace_node;
	SELECT array_to_json(array_agg(arc_id)) INTO Arc_json FROM "SCHEMA_NAME".temp_flow_trace_arc;

--	Delete auxiliar tables
	DROP TABLE IF EXISTS "SCHEMA_NAME".temp_flow_trace_node CASCADE;
	DROP TABLE IF EXISTS "SCHEMA_NAME".temp_flow_trace_arc CASCADE;

	sql := '{"Node": ' || Node_json || ', "Arc": ' || Arc_json || '}';
	RETURN sql::json;


		
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION SCHEMA_NAME.gw_fct_flow_trace(character varying)
  OWNER TO geoserver;











-- Function: "SCHEMA_NAME".gw_fct_flow_trace_recursive(character varying)

-- DROP FUNCTION "SCHEMA_NAME".gw_fct_flow_trace_recursive(character varying);

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_flow_trace_recursive(node_id_arg character varying)
  RETURNS void AS
$BODY$DECLARE
	exists_id character varying;
	rec_table record;


BEGIN

--	Check if the node is already computed
	SELECT node_id INTO exists_id FROM "SCHEMA_NAME".temp_flow_trace_node WHERE node_id = node_id_arg;

--	Compute proceed
	IF NOT FOUND THEN
	
--		Update value
		INSERT INTO "SCHEMA_NAME".temp_flow_trace_node VALUES(node_id_arg);
		
--		Loop for all the upstream nodes
		FOR rec_table IN SELECT arc_id, node_1 FROM "SCHEMA_NAME".arc WHERE node_2 = node_id_arg
		LOOP

--			Insert into tables
			INSERT INTO "SCHEMA_NAME".temp_flow_trace_arc VALUES(rec_table.arc_id);

--			Call recursive function weighting with the pipe capacity
			PERFORM "SCHEMA_NAME".gw_fct_flow_trace_recursive(rec_table.node_1);


		END LOOP;

	
	END IF;

	RETURN;

		
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION "SCHEMA_NAME".gw_fct_flow_trace_recursive(character varying)
  OWNER TO geoserver;
