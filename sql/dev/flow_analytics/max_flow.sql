/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;

CREATE OR REPLACE FUNCTION gw_fct_maxflow(    intensity double precision,    runoff_coeff double precision)  RETURNS void AS
  
$BODY$

DECLARE
	node_id_var varchar(16);
	arc_id_var varchar(16);
	index_point integer;
	point_aux geometry;
	num_row integer = 0;
	flow_node double precision;
	total_capacity double precision;
	arc_capacity double precision;
	rec_table record;
	num_pipes integer;
	num_wet_pipes integer;


BEGIN

SET search_path='SCHEMA_NAME',public;

--	Create table for arc results
	DROP TABLE IF EXISTS arc_maxflow CASCADE;
	CREATE TABLE arc_maxflow
	(
		arc_id character varying(16) NOT NULL,
		maxflow numeric(12,4) DEFAULT 0.00,
		CONSTRAINT arc_maxflow_pkey PRIMARY KEY (arc_id),
		CONSTRAINT arc_maxflow_arc_id_fkey FOREIGN KEY (arc_id)
			REFERENCES arc (arc_id) MATCH SIMPLE
			ON UPDATE CASCADE ON DELETE CASCADE
	)
	WITH (
		OIDS=FALSE
	);
	
--	Create the temporal table for computing
	DROP TABLE IF EXISTS temp_maxflow CASCADE;
	CREATE TEMP TABLE temp_maxflow
	(		
		node_id character varying(16) NOT NULL,
		maxflow numeric(12,4) DEFAULT 0.00,
		first_track_id integer DEFAULT 0,
		total_capacity numeric(12,4) DEFAULT 0.00,
		num_outlet integer DEFAULT 0,
		num_wet_outlet integer DEFAULT 0,
		CONSTRAINT temp_maxflow_pkey PRIMARY KEY (node_id)
	);


--	Copy nodes into new area table
	FOR node_id_var IN SELECT node_id FROM node
	LOOP

--		Count number of pipes draining the node
		SELECT count(*) INTO num_pipes FROM arc WHERE node_1 = node_id_var;

--		Count number of pipes draining the node
		SELECT count(*) INTO num_wet_pipes FROM arc WHERE node_1 = node_id_var AND flow > 0.0;

--		Compute total capacity of the pipes exiting from the node
		SELECT sum(flow) INTO total_capacity FROM arc WHERE node_1 = node_id_var;

--		Compute total capacity of the pipes exiting from the node
		SELECT sum(flow) INTO total_capacity FROM arc WHERE node_1 = node_id_var;
		INSERT INTO temp_maxflow VALUES(node_id_var, 0.0, 0, total_capacity, num_pipes, num_wet_pipes);

	END LOOP;

--	Copy arcs into new area table
	FOR arc_id_var IN SELECT arc_id FROM arc
	LOOP

--		Insert into nodes area table
		INSERT INTO arc_maxflow VALUES(arc_id_var, 0.0);

	END LOOP;


--	Compute the tributary area using DFS
	FOR node_id_var IN SELECT node_id FROM temp_maxflow
	LOOP
		num_row = num_row + 1;

--		Call function
		flow_node := gw_fct_maxflow_recursive(node_id_var, num_row, intensity, runoff_coeff);

	END LOOP;
		
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

