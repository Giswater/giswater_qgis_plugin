/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/



CREATE SEQUENCE "SCHEMA_NAME"."node_flow_trace_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;
  
CREATE SEQUENCE "SCHEMA_NAME"."arc_flow_trace_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;
  


CREATE OR REPLACE FUNCTION  ws.flow_trace(node_id_arg character varying) RETURNS void AS $BODY$
DECLARE
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

 
    -- Create table for node results
    DROP TABLE IF EXISTS ws.node_flow_trace CASCADE;
    CREATE TABLE ws.node_flow_trace
    (
        node_id character varying(16) NOT NULL,
        flow_trace numeric(12,4) DEFAULT 0.00,
        CONSTRAINT node_flow_trace_id_fkey FOREIGN KEY (node_id)
        REFERENCES ws.node (node_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE
    );

    -- Create table for arc results
    DROP TABLE IF EXISTS ws.arc_flow_trace CASCADE;
    CREATE TABLE ws.arc_flow_trace
    (
        arc_id character varying(16) NOT NULL,
        flow_trace numeric(12,4) DEFAULT 0.00,  
        CONSTRAINT arc_flow_trace_id_fkey FOREIGN KEY (arc_id)
        REFERENCES ws.arc (arc_id) MATCH SIMPLE
        ON UPDATE CASCADE ON DELETE CASCADE
    );
    
    --  Create the temporal table for computing
    DROP TABLE IF EXISTS temp_flow_trace CASCADE;
    CREATE TEMP TABLE temp_flow_trace
    (                             
        node_id character varying(16) NOT NULL,
        first_track_id integer DEFAULT 0,
        CONSTRAINT temp_flow_trace_pkey PRIMARY KEY (node_id)
    );


    -- Insert into node in table
    INSERT INTO ws.node_flow_trace VALUES(node_id_arg,1.0);

    -- Copy nodes into temp flow trace table
    FOR node_id_var IN SELECT node_id FROM ws.node
    LOOP
        INSERT INTO temp_flow_trace VALUES(node_id_var, 0);
    END LOOP;

    -- Compute the tributary area using DFS
    PERFORM ws.flow_trace_recursive(node_id_arg, 1);
                             
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;



-- Function:  ws.flow_trace_recursive(character varying, integer)
-- DROP FUNCTION  ws.flow_trace_recursive(character varying, integer);

CREATE OR REPLACE FUNCTION  ws.flow_trace_recursive(node_id_arg character varying, num_row integer) RETURNS void AS $BODY$
DECLARE
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
                                FOR rec_table IN SELECT arc_id, node_1 FROM ws.arc WHERE node_2 = node_id_arg
                                LOOP
 
--                                             Insert into tables
                                                INSERT INTO ws.node_flow_trace VALUES(rec_table.node_1,1.0);
                                                INSERT INTO ws.arc_flow_trace VALUES(rec_table.arc_id,1.0);
 
--                                             Call recursive function weighting with the pipe capacity
                                                PERFORM ws.flow_trace_recursive(rec_table.node_1, num_row);
                                END LOOP;
               
                END IF;
                 RETURN;
                               
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
  

