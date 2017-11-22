/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;


--	Create table for arc results
--	DROP TABLE IF EXISTS arc_maxflow CASCADE;
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
	
	
	
--	Create table for node results
--	DROP TABLE IF EXISTS node_drain_area CASCADE;
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
--	DROP TABLE IF EXISTS arc_drain_area CASCADE;
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
	

--	Create the table to store cycles
--	DROP TABLE IF EXISTS node_cycles CASCADE;
	CREATE TABLE node_cycles
	(		
		node_id character varying(16) NOT NULL,
		cycle_id integer DEFAULT 0,
		CONSTRAINT cycles_pkey PRIMARY KEY (node_id)
	);


-- ARC TABLE
ALTER TABLE arc ADD COLUMN flow numeric(12,4); 					-- flow max on conduit, applying swmm manning's equation. Filled by gw_fct_flow_swmm2pg
ALTER TABLE arc ADD COLUMN drain_parea numeric(12,4);  			-- drain podended area (using parea of subcathcment) of conduit. Filled by gw_fct_flow_upstream_area
ALTER TABLE arc ADD COLUMN cflow numeric(12,4);  				-- coherent flow. Filled by gw_fct_flow_max

ALTER TABLE arc ADD COLUMN ofd numeric(12,4);					-- Optimum flow design (Q=CIA/3.6) I=(Id,Tcd) usually=T=10years & Tc=10minuts. Filled by hand
ALTER TABLE arc ADD COLUMN oad numeric(12,4);					-- Optimun conduit area design (to support ofd with circular geometry). Filled by hand
ALTER TABLE arc ADD COLUMN cf_t2 numeric(12,4);					-- coherent flow on conduit for t=2. Filled by hand
ALTER TABLE arc ADD COLUMN cf_t5 numeric(12,4);					-- coherent flow on conduit for t=5. Filled by hand
ALTER TABLE arc ADD COLUMN cf_t10 numeric(12,4);				-- coherent flow on conduit for t=10. Filled by hand
ALTER TABLE arc ADD COLUMN cf_t20 numeric(12,4);				-- coherent flow on conduit for t=20. Filled by hand

ALTER TABLE arc ADD COLUMN nflow numeric(12,4);  				-- flow max on conduit, applying manning's equation. Filled by gw_fct_flow_manning

--ALTER TABLE arc ADD COLUMN tc numeric(12,4);  				-- Concentration time, applying formula of urban tc
--ALTER TABLE arc ADD COLUMN tc_reclass character varying(30); 	-- minimun 10
--ALTER TABLE arc ADD COLUMN sdi numeric(12,4);					-- supported intensity (Q=CIA/3.6 with intensity as a variable)
--ALTER TABLE arc ADD COLUMN sdt numeric(12,4);					-- supported return period (return period in f() intensity)
--ALTER TABLE arc ADD COLUMN slope numeric(12,4);				-- slope of the conduit
--ALTER TABLE arc ADD COLUMN slope_type character varying(30);	-- type of slope (supossed, real)
--ALTER TABLE arc ADD COLUMN wet_per numeric(12,4);				-- wet_perimeter
--ALTER TABLE arc ADD COLUMN cond_area numeric(12,4);			-- conduit area
--ALTER TABLE arc ADD COLUMN rh numeric(12,4);					-- hidraulic radius


-- SUBCATCHMENT TABLE
ALTER TABLE subcatchment ADD COLUMN parea numeric(12,6);

