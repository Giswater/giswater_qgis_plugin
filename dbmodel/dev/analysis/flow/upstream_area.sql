/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;


CREATE OR REPLACE FUNCTION gw_fct_upstream_area()
  RETURNS void AS
$BODY$DECLARE
	node_id_var varchar(16);
	arc_id_var varchar(16);
	index_point integer;
	point_aux geometry;
	num_row integer = 0;
	area_node double precision;
	total_capacity double precision;
	arc_capacity double precision;
	rec_table record;
	num_pipes integer;
	num_wet_pipes integer;
	node_balance_var double precision;
	arcs_total_inflow double precision;
	arcs_total_outflow double precision;

BEGIN

SET search_path='SCHEMA_NAME',public;

--	Create table for node results
	DROP TABLE IF EXISTS node_drain_area CASCADE;
	CREATE TABLE node_drain_area
	(
		node_id character varying(16) NOT NULL,
		area numeric(12,4) DEFAULT -1.00,
		capacity numeric(12,4) DEFAULT 0.00,
		num_outlet integer DEFAULT 0,
		num_wet_outlet integer DEFAULT 0,
		node_balance numeric(12,8) DEFAULT 0.0,		
		CONSTRAINT node_area_pkey PRIMARY KEY (node_id),
		CONSTRAINT node_area_node_id_fkey FOREIGN KEY (node_id)
			REFERENCES node (node_id) MATCH SIMPLE
			ON UPDATE CASCADE ON DELETE CASCADE
	)
	WITH (
		OIDS=FALSE
	);

--	Create table for arc results
	DROP TABLE IF EXISTS arc_drain_area CASCADE;
	CREATE TABLE arc_drain_area
	(
		arc_id character varying(16) NOT NULL,
		area numeric(12,4) DEFAULT 0.00,
		capacity numeric(12,4) DEFAULT 0.00,
		CONSTRAINT arc_area_pkey PRIMARY KEY (arc_id),
		CONSTRAINT arc_area_arc_id_fkey FOREIGN KEY (arc_id)
			REFERENCES arc (arc_id) MATCH SIMPLE
			ON UPDATE CASCADE ON DELETE CASCADE
	)
	WITH (
		OIDS=FALSE
	);
	
--	Create the temporal table for computing
	DROP TABLE IF EXISTS temp_contributing_area CASCADE;
	CREATE TEMP TABLE temp_contributing_area
	(		
		node_id character varying(16) NOT NULL,
		first_track_id integer DEFAULT 0,
		total_capacity numeric(12,4) DEFAULT 0.00,
		CONSTRAINT temp_area_pkey PRIMARY KEY (node_id)
	);


--	Create the table to store cycles
	DROP TABLE IF EXISTS node_cycles CASCADE;
	CREATE TABLE node_cycles
	(		
		node_id character varying(16) NOT NULL,
		cycle_id integer DEFAULT 0,
		CONSTRAINT cycles_pkey PRIMARY KEY (node_id)
	);


--	Copy nodes into new area table
	FOR node_id_var IN SELECT node_id FROM node
	LOOP

--		Count number of pipes draining the node
		SELECT count(*) INTO num_pipes FROM arc WHERE node_1 = node_id_var;

--		Count number of pipes draining the node
		SELECT count(*) INTO num_wet_pipes FROM arc WHERE node_1 = node_id_var AND flow > 0.0;

--		Insert into nodes area table
		INSERT INTO node_drain_area VALUES(node_id_var, 0.0, 0.0, num_pipes, num_wet_pipes, 0.0);
		INSERT INTO node_cycles VALUES(node_id_var, 0);

--		Compute total capacity of the pipes exiting from the node
		SELECT sum(flow) INTO total_capacity FROM arc WHERE node_1 = node_id_var;
		INSERT INTO temp_contributing_area VALUES(node_id_var, 0, total_capacity);

--		Add the total capacity as a nodal variable		
		UPDATE node_drain_area SET capacity = total_capacity WHERE node_id = node_id_var;

	END LOOP;

--	Copy arcs into new area table
	FOR arc_id_var IN SELECT arc_id FROM arc
	LOOP

--		Insert into nodes area table
		INSERT INTO arc_drain_area VALUES(arc_id_var, 0.0, 0.0);

	END LOOP;


--	Compute the tributary area using DFS
	FOR node_id_var IN SELECT node_id FROM temp_contributing_area
	LOOP

--		Update index
		num_row = num_row + 1;

--		Call function
		area_node := gw_fct_upstream_recursive(node_id_var, num_row);

--		Fill node tables
		UPDATE node_drain_area SET area = area_node WHERE node_id = node_id_var;

	END LOOP;

--	Loop to compute mass balance
	FOR node_id_var IN SELECT node_id FROM temp_contributing_area
	LOOP

--		Compute node area
		SELECT area INTO area_node FROM subcatchment WHERE node_id = node_id_var;

--		Check existing subcatchment
		IF (area_node ISNULL) THEN
			area_node = 0.0;
		END IF;

--		Compute total outflow
		SELECT sum(area) INTO arcs_total_inflow FROM arc_drain_area WHERE arc_id IN (SELECT arc_id FROM arc WHERE node_2 = node_id_var);

--		Check existing subcatchment
		IF (arcs_total_inflow ISNULL) THEN
			arcs_total_inflow = 0.0;
		END IF;

--		Compute total outflow
		SELECT sum(area) INTO arcs_total_outflow FROM arc_drain_area WHERE arc_id IN (SELECT arc_id FROM arc WHERE node_1 = node_id_var);

--		Check existing subcatchment
		IF (arcs_total_outflow ISNULL) THEN
			arcs_total_outflow = 0.0;
		END IF;

--		Mass balance
		node_balance_var := area_node + arcs_total_inflow - arcs_total_outflow;

--		Fill node tables
		UPDATE node_drain_area SET node_balance = node_balance_var WHERE node_id = node_id_var;

	END LOOP;

		
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;