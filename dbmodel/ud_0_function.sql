/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


-- ------------------------------------------------------------
-- Clone
-- schema
-- ------------------------------------------------------------

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".clone_schema(source_schema text, dest_schema text) RETURNS void LANGUAGE plpgsql AS $$
 
DECLARE
	rec_view record;
	rec_fk record;
	rec_table text;
	tablename text;
	default_ text;
	column_ text;
	msg text;
BEGIN

	-- Create destination schema
	EXECUTE 'CREATE SCHEMA ' || dest_schema ;
	 
	-- Sequences
	FOR rec_table IN
		SELECT sequence_name FROM information_schema.SEQUENCES WHERE sequence_schema = source_schema
	LOOP
		EXECUTE 'CREATE SEQUENCE ' || dest_schema || '.' || rec_table;
	END LOOP;
	 
	-- Tables
	FOR rec_table IN
		SELECT table_name FROM information_schema.TABLES WHERE table_schema = source_schema AND table_type = 'BASE TABLE' ORDER BY table_name
	LOOP
	  
	  	-- Create table in destination schema
		tablename := dest_schema || '.' || rec_table;
		EXECUTE 'CREATE TABLE ' || tablename || ' (LIKE ' || source_schema || '.' || rec_table || ' INCLUDING CONSTRAINTS INCLUDING INDEXES INCLUDING DEFAULTS)';
		
		-- Set contraints
		FOR column_, default_ IN
			SELECT column_name, REPLACE(column_default, source_schema, dest_schema) 
			FROM information_schema.COLUMNS 
			WHERE table_schema = dest_schema AND table_name = rec_table AND column_default LIKE 'nextval(%' || source_schema || '%::regclass)'
		LOOP
			EXECUTE 'ALTER TABLE ' || tablename || ' ALTER COLUMN ' || column_ || ' SET DEFAULT ' || default_;
		END LOOP;
		
		-- Copy table contents to destination schema
		EXECUTE 'INSERT INTO ' || tablename || ' SELECT * FROM ' || source_schema || '.' || rec_table; 	
		
	END LOOP;
	  
	-- Loop again trough tables in order to set Foreign Keys
	FOR rec_table IN
		SELECT table_name FROM information_schema.TABLES WHERE table_schema = source_schema AND table_type = 'BASE TABLE' ORDER BY table_name
	LOOP	  
	  
		tablename := dest_schema || '.' || rec_table;	  
		FOR rec_fk IN
			SELECT tc.constraint_name, tc.constraint_schema, tc.table_name, kcu.column_name,
			ccu.table_name AS parent_table, ccu.column_name AS parent_column,
			rc.update_rule AS on_update, rc.delete_rule AS on_delete
			FROM information_schema.table_constraints tc
				LEFT JOIN information_schema.key_column_usage kcu
				ON tc.constraint_catalog = kcu.constraint_catalog
				AND tc.constraint_schema = kcu.constraint_schema
				AND tc.constraint_name = kcu.constraint_name
			LEFT JOIN information_schema.referential_constraints rc
				ON tc.constraint_catalog = rc.constraint_catalog
				AND tc.constraint_schema = rc.constraint_schema
				AND tc.constraint_name = rc.constraint_name
			LEFT JOIN information_schema.constraint_column_usage ccu
				ON rc.unique_constraint_catalog = ccu.constraint_catalog
				AND rc.unique_constraint_schema = ccu.constraint_schema
				AND rc.unique_constraint_name = ccu.constraint_name
			WHERE tc.constraint_type = 'FOREIGN KEY' AND tc.constraint_schema = source_schema AND tc.table_name = rec_table
		LOOP
			msg:= 'ALTER TABLE '||tablename||' ADD CONSTRAINT '||rec_fk.constraint_name||' FOREIGN KEY('||rec_fk.column_name||') 
				REFERENCES '||dest_schema||'.'||rec_fk.parent_table||'('||rec_fk.parent_column||') ON DELETE '||rec_fk.on_delete||' ON UPDATE '||rec_fk.on_update;
			EXECUTE msg;
		END LOOP;		
		
	END LOOP;			
		
	-- Views
	FOR rec_view IN
		SELECT table_name, REPLACE(view_definition, source_schema, dest_schema) as definition FROM information_schema.VIEWS WHERE table_schema = source_schema
	LOOP
		EXECUTE 'CREATE VIEW ' || dest_schema || '.' || rec_view.table_name || ' AS ' || rec_view.definition;
	END LOOP;
 
END;
$$;
   
  

-- ------------------------------------------------------------
-- FLOW
-- TRACE
-- ------------------------------------------------------------


-- Function:  sanejament.flow_trace(character varying)

CREATE OR REPLACE FUNCTION  sanejament.flow_trace(node_id_arg character varying)
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
                max_length_var double precision;
                max_elev_var double precision;
                area_node_var double precision;
                record_var record;
BEGIN

 
--             Create table for node results
                DROP TABLE IF EXISTS sanejament.node_flow_trace CASCADE;
                CREATE TABLE sanejament.node_flow_trace
                (
--								id int4 DEFAULT nextval('node_flow_trace_seq'::regclass) NOT NULL,
                                node_id character varying(16) NOT NULL,
                                flow_trace numeric(12,4) DEFAULT 0.00,
--								the_geom public.geometry (POINT, SRID_VALUE),
--                              CONSTRAINT node_flow_trace_pkey PRIMARY KEY (id),
                                CONSTRAINT node_flow_trace_id_fkey FOREIGN KEY (node_id)
                                                REFERENCES sanejament.node (node_id) MATCH SIMPLE
                                                ON UPDATE CASCADE ON DELETE CASCADE
                )

                WITH (
                                OIDS=FALSE
                );


--             Create table for arc results
                DROP TABLE IF EXISTS sanejament.arc_flow_trace CASCADE;
                CREATE TABLE sanejament.arc_flow_trace
                (
--								id int4 DEFAULT nextval('arc_flow_trace_seq'::regclass) NOT NULL,
                                arc_id character varying(16) NOT NULL,
                                flow_trace numeric(12,4) DEFAULT 0.00,    								
--                              CONSTRAINT arc_flow_trace_pkey PRIMARY KEY (id),
                                CONSTRAINT arc_flow_trace_id_fkey FOREIGN KEY (arc_id)
                                                REFERENCES sanejament.arc (arc_id) MATCH SIMPLE
                                                ON UPDATE CASCADE ON DELETE CASCADE
                )
                WITH (
                                OIDS=FALSE
                );
               
--             Create the temporal table for computing
                DROP TABLE IF EXISTS temp_flow_trace CASCADE;
                CREATE TEMP TABLE temp_flow_trace
                (                             
                                node_id character varying(16) NOT NULL,
                                first_track_id integer DEFAULT 0,
                                CONSTRAINT temp_flow_trace_pkey PRIMARY KEY (node_id)
                );
 
 
--             Insert into node in table
                INSERT INTO sanejament.node_flow_trace VALUES(node_id_arg,1.0);
 
--             Copy nodes into temp flow trace table
                FOR node_id_var IN SELECT node_id FROM sanejament.node
                LOOP
 
                               INSERT INTO temp_flow_trace VALUES(node_id_var, 0);
                END LOOP;
 

 --             Compute the tributary area using DFS
                PERFORM sanejament.flow_trace_recursive(node_id_arg, 1);
                             

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;



-- Function:  sanejament.flow_trace_recursive(character varying, integer)
-- DROP FUNCTION  sanejament.flow_trace_recursive(character varying, integer);

CREATE OR REPLACE FUNCTION  sanejament.flow_trace_recursive(node_id_arg character varying, num_row integer)
  RETURNS void AS
$BODY$DECLARE
                first_track_id_var integer = 0;
                area_node double precision = 0.0;
                total_capacity_var double precision;
                arc_capacity double precision;
                rec_table record;
                arc_area double precision = 0.0;
                num_arcs integer;
                num_wet_arcs integer;
                max_length_var double precision;
                max_elev_var double precision;
                arc_length double precision;
                node_elev double precision;
                area_node_var double precision;
                record_var record;
 
BEGIN


--             Check if the node is already computed
                SELECT first_track_id INTO first_track_id_var FROM temp_flow_trace WHERE node_id = node_id_arg;
 
 
--             Compute area
                IF (first_track_id_var = 0) THEN
 
               
--                             Update value
                                UPDATE temp_flow_trace SET first_track_id = num_row WHERE node_id = node_id_arg;
                               
--                             Loop for all the upstream nodes
                                FOR rec_table IN SELECT arc_id, node_1 FROM sanejament.arc WHERE node_2 = node_id_arg
                                LOOP
 
--                                             Insert into tables
                                                INSERT INTO sanejament.node_flow_trace VALUES(rec_table.node_1,1.0);
                                                INSERT INTO sanejament.arc_flow_trace VALUES(rec_table.arc_id,1.0);
 
--                                             Call recursive function weighting with the pipe capacity
                                                PERFORM sanejament.flow_trace_recursive(rec_table.node_1, num_row);
                                END LOOP;
               
                END IF;
                 RETURN;
                               
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
  


-- Function:  sanejament.flow_exit(character varying)
-- DROP FUNCTION  sanejament.flow_exit(character varying);

CREATE OR REPLACE FUNCTION  sanejament.flow_exit(node_id_arg character varying)
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
                max_length_var double precision;
                max_elev_var double precision;
                area_node_var double precision;
                record_var record;
BEGIN
 
--             Create table for node results
                DROP TABLE IF EXISTS sanejament.node_flow_exit CASCADE;
                CREATE TABLE sanejament.node_flow_exit
                (
--								id int4 DEFAULT nextval('node_flow_exit_seq'::regclass) NOT NULL,
                                node_id character varying(16) NOT NULL,
                                flow_exit numeric(12,4) DEFAULT 0.00,
--								the_geom public.geometry (POINT, SRID_VALUE),
--                              CONSTRAINT node_flow_exit_pkey PRIMARY KEY (id),
                                CONSTRAINT node_flow_exit_id_fkey FOREIGN KEY (node_id)
                                                REFERENCES sanejament.node (node_id) MATCH SIMPLE
                                                ON UPDATE CASCADE ON DELETE CASCADE
                )
                WITH (
                                OIDS=FALSE
                );


--             Create table for arc results
                DROP TABLE IF EXISTS sanejament.arc_flow_exit CASCADE;
                CREATE TABLE sanejament.arc_flow_exit
                (
--								id int4 DEFAULT nextval('arc_flow_exit_seq'::regclass) NOT NULL,
                                arc_id character varying(16) NOT NULL,
                                flow_exit numeric(12,4) DEFAULT 0.00, 
--								the_geom public.geometry (LINESTRING, SRID_VALUE),
--								CONSTRAINT arc_flow_exit_pkey PRIMARY KEY (id),
                                CONSTRAINT arc_flow_exit_id_fkey FOREIGN KEY (arc_id)
                                                REFERENCES sanejament.arc (arc_id) MATCH SIMPLE
                                                ON UPDATE CASCADE ON DELETE CASCADE
                )
                WITH (
                                OIDS=FALSE
                );
               
--             Create the temporal table for computing
                DROP TABLE IF EXISTS temp_flow_exit CASCADE;
                CREATE TEMP TABLE temp_flow_exit
                (                             
                                node_id character varying(16) NOT NULL,
                                first_track_id integer DEFAULT 0
--                               , CONSTRAINT temp_flow_exit_pkey PRIMARY KEY (node_id)
                );
 
 
--             Insert into node in table
                INSERT INTO sanejament.node_flow_exit VALUES(node_id_arg,1.0);
 
--             Copy nodes into temp flow trace table
                FOR node_id_var IN SELECT node_id FROM sanejament.node
                LOOP
 
                                INSERT INTO temp_flow_exit VALUES(node_id_var, 0);
 
                END LOOP;
 
 
--             Compute the tributary area using DFS
                PERFORM sanejament.flow_exit_recursive(node_id_arg, 1);
 
 
                               
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
 
 
  
 
-- Function:  sanejament.flow_exit_recursive(character varying, integer)
 
-- DROP FUNCTION  sanejament.flow_exit_recursive(character varying, integer);
 
CREATE OR REPLACE FUNCTION  sanejament.flow_exit_recursive(node_id_arg character varying, num_row integer)
  RETURNS void AS
$BODY$DECLARE
                first_track_id_var integer = 0;
                area_node double precision = 0.0;
                total_capacity_var double precision;
                arc_capacity double precision;
                rec_table record;
                arc_area double precision = 0.0;
                num_arcs integer;
                num_wet_arcs integer;
                max_length_var double precision;
                max_elev_var double precision;
                arc_length double precision;
                node_elev double precision;
                area_node_var double precision;
                record_var record;
 
BEGIN
 
--             Check if the node is already computed
                SELECT first_track_id INTO first_track_id_var FROM temp_flow_exit WHERE node_id = node_id_arg;
 
 
--             Compute area
                IF (first_track_id_var = 0) THEN
 
               
--                             Update value
                                UPDATE temp_flow_exit SET first_track_id = num_row WHERE node_id = node_id_arg;
                               
--                             Loop for all the upstream nodes
                                FOR rec_table IN SELECT arc_id, node_2 FROM sanejament.arc WHERE node_1 = node_id_arg
                                LOOP
 
--                                             Insert into tables
                                                INSERT INTO sanejament.node_flow_exit VALUES(rec_table.node_2,1.0);
                                                INSERT INTO sanejament.arc_flow_exit VALUES(rec_table.arc_id,1.0);
 
--                                             Call recursive function weighting with the pipe capacity
                                                PERFORM sanejament.flow_exit_recursive(rec_table.node_2, num_row);
 
 
                                END LOOP;
 
               
                END IF;
 
                RETURN;
 
                               
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
   
   
   