/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_audit_schema_data_integrity() RETURNS void AS $BODY$ 
DECLARE
value1_rec	integer;
value2_rec	integer;
count_rec	integer;    

BEGIN

    -- Search path
    SET search_path = "SCHEMA_NAME", public;

    --Delete previous
	
	DROP TABLE IF EXISTS audit_schema_data_integrity CASCADE;
	CREATE TABLE audit_schema_data_integrity (
		id serial NOT NULL,
		parameter_id character varying(50),
		value1 integer,
		value2 integer,
		count integer,
		CONSTRAINT audit_schema_data_integrity_pkey PRIMARY KEY (id)
	);


  --NODE-MAN_JUNCTION
   SELECT count(*) INTO value1_rec FROM node WHERE (node_type = ANY (SELECT id FROM node_type WHERE type = 'JUNCTION')) AND NOT EXISTS (SELECT node_id FROM man_junction WHERE node_id = node.node_id);
   SELECT count(*) INTO value2_rec FROM man_junction WHERE NOT EXISTS (SELECT node_id FROM node WHERE node_id = node.node_id);
   SELECT count(*) INTO count_rec FROM man_junction;
   INSERT INTO audit_schema_data_integrity (parameter_id, value1, value2, count) VALUES ('node-man_junction',value1_rec, value2_rec, count_rec);

  --NODE-MAN_VALVE
   SELECT count(*) INTO value1_rec FROM node WHERE (node_type = ANY (SELECT id FROM node_type WHERE type = 'VALVE')) AND NOT EXISTS (SELECT node_id FROM man_valve WHERE node_id = node.node_id);
   SELECT count(*) INTO value2_rec FROM man_valve WHERE NOT EXISTS (SELECT node_id FROM node WHERE node_id = node.node_id);
   SELECT count(*) INTO count_rec FROM man_valve;
   INSERT INTO audit_schema_data_integrity (parameter_id, value1, value2, count) VALUES ('node-man_valve',value1_rec, value2_rec, count_rec);

 --NODE-MAN_PUMP
   SELECT count(*) INTO value1_rec FROM node WHERE (node_type = ANY (SELECT id FROM node_type WHERE type = 'PUMP')) AND NOT EXISTS (SELECT node_id FROM man_pump WHERE node_id = node.node_id);
   SELECT count(*) INTO value2_rec FROM man_pump WHERE NOT EXISTS (SELECT node_id FROM node WHERE node_id = node.node_id);
   SELECT count(*) INTO count_rec FROM man_pump;
   INSERT INTO audit_schema_data_integrity (parameter_id, value1, value2, count) VALUES ('node-man_pump',value1_rec, value2_rec, count_rec);

 --NODE-MAN_FILTER
   SELECT count(*) INTO value1_rec FROM node WHERE (node_type = ANY (SELECT id FROM node_type WHERE type = 'FILTER')) AND NOT EXISTS (SELECT node_id FROM man_filter WHERE node_id = node.node_id);
   SELECT count(*) INTO value2_rec FROM man_filter WHERE NOT EXISTS (SELECT node_id FROM node WHERE node_id = node.node_id);
   SELECT count(*) INTO count_rec FROM man_filter;
   INSERT INTO audit_schema_data_integrity (parameter_id, value1, value2, count) VALUES ('node-man_filter',value1_rec, value2_rec, count_rec);
   
 --NODE-MAN_TANK
   SELECT count(*) INTO value1_rec FROM node WHERE (node_type = ANY (SELECT id FROM node_type WHERE type = 'TANK')) AND NOT EXISTS (SELECT node_id FROM man_tank WHERE node_id = node.node_id);
   SELECT count(*) INTO value2_rec FROM man_tank WHERE NOT EXISTS (SELECT node_id FROM node WHERE node_id = node.node_id);
   SELECT count(*) INTO count_rec FROM man_tank;
   INSERT INTO audit_schema_data_integrity (parameter_id, value1, value2, count) VALUES ('node-man_tank',value1_rec, value2_rec, count_rec);

 --NODE-MAN_HYDRANT
   SELECT count(*) INTO value1_rec FROM node WHERE (node_type = ANY (SELECT id FROM node_type WHERE type = 'HYDRANT')) AND NOT EXISTS (SELECT node_id FROM man_hydrant WHERE node_id = node.node_id);
   SELECT count(*) INTO value2_rec FROM man_hydrant WHERE NOT EXISTS (SELECT node_id FROM node WHERE node_id = node.node_id);
   SELECT count(*) INTO count_rec FROM man_hydrant;
   INSERT INTO audit_schema_data_integrity (parameter_id, value1, value2, count) VALUES ('node-man_hydrant',value1_rec, value2_rec, count_rec);

 --NODE-MAN_MEASURE_INSTRUMENT
   SELECT count(*) INTO value1_rec FROM node WHERE (node_type = ANY (SELECT id FROM node_type WHERE type = 'MEASURE_INSTRUMENT')) AND NOT EXISTS (SELECT node_id FROM man_meter WHERE node_id = node.node_id);
   SELECT count(*) INTO value2_rec FROM man_meter WHERE NOT EXISTS (SELECT node_id FROM node WHERE node_id = node.node_id);
   SELECT count(*) INTO count_rec FROM man_meter;
   INSERT INTO audit_schema_data_integrity (parameter_id, value1, value2, count) VALUES ('node-man_meter',value1_rec, value2_rec, count_rec);


 --NODE-INP_JUNCTION
   SELECT count(*) INTO value1_rec FROM node WHERE epa_type = 'JUNCTION' AND NOT EXISTS (SELECT node_id FROM inp_junction WHERE node_id = node.node_id);
   SELECT count(*) INTO value2_rec FROM inp_junction WHERE NOT EXISTS (SELECT node_id FROM node WHERE node_id = node.node_id);
   SELECT count(*) INTO count_rec FROM inp_junction;
   INSERT INTO audit_schema_data_integrity (parameter_id, value1, value2, count) VALUES ('node-inp_junction', value1_rec, value2_rec, count_rec);

 --NODE-INP_SHORTPIPE
   SELECT count(*) INTO value1_rec FROM node WHERE epa_type = 'SHORTPIPE' AND NOT EXISTS (SELECT node_id FROM inp_shortpipe WHERE node_id = node.node_id);
   SELECT count(*) INTO value2_rec FROM inp_shortpipe WHERE NOT EXISTS (SELECT node_id FROM node WHERE node_id = node.node_id);
   SELECT count(*) INTO count_rec FROM inp_shortpipe;
   INSERT INTO audit_schema_data_integrity (parameter_id, value1, value2, count) VALUES ('node-inp_shortpipe',value1_rec, value2_rec, count_rec);

 --NODE-INP_TANK
   SELECT count(*) INTO value1_rec FROM node WHERE epa_type = 'TANK' AND NOT EXISTS (SELECT node_id FROM inp_tank WHERE node_id = node.node_id);
   SELECT count(*) INTO value2_rec FROM inp_tank WHERE NOT EXISTS (SELECT node_id FROM node WHERE node_id = node.node_id);
   SELECT count(*) INTO count_rec FROM inp_tank;
   INSERT INTO audit_schema_data_integrity (parameter_id, value1, value2, count) VALUES ('node-inp_tank',value1_rec, value2_rec, count_rec);

--NODE-INP_RESERVOIR
   SELECT count(*) INTO value1_rec FROM node WHERE epa_type = 'RESERVOIR' AND NOT EXISTS (SELECT node_id FROM inp_reservoir WHERE node_id = node.node_id);
   SELECT count(*) INTO value2_rec FROM inp_reservoir WHERE NOT EXISTS (SELECT node_id FROM node WHERE node_id = node.node_id);
   SELECT count(*) INTO count_rec FROM inp_reservoir;
   INSERT INTO audit_schema_data_integrity (parameter_id, value1, value2, count) VALUES ('node-inp_reservoir',value1_rec, value2_rec, count_rec);




 --ARC-MAN_PIPE
   SELECT count(*) INTO value1_rec FROM arc WHERE NOT EXISTS (SELECT arc_id FROM man_pipe WHERE arc_id = arc.arc_id);
   SELECT count(*) INTO value2_rec FROM man_pipe WHERE NOT EXISTS (SELECT arc_id FROM arc WHERE arc_id = arc.arc_id);
   SELECT count(*) INTO count_rec FROM man_pipe;
   INSERT INTO audit_schema_data_integrity (parameter_id, value1, value2, count) VALUES ('arc-man_pipe',value1_rec, value2_rec, count_rec);

 --ARC-INP_PIPE
   SELECT count(*) INTO value1_rec FROM arc WHERE epa_type = 'PIPE' AND NOT EXISTS (SELECT arc_id FROM inp_pipe WHERE arc_id = arc.arc_id);
   SELECT count(*) INTO value2_rec FROM inp_pipe WHERE NOT EXISTS (SELECT arc_id FROM arc WHERE arc_id = arc.arc_id);
   SELECT count(*) INTO count_rec FROM inp_pipe;
   INSERT INTO audit_schema_data_integrity (parameter_id, value1, value2, count) VALUES ('arc-inp_pipe',value1_rec, value2_rec, count_rec); 

 --ARC-INP_VALVE
   SELECT count(*) INTO value1_rec FROM arc WHERE epa_type = 'VALVE' AND NOT EXISTS (SELECT arc_id FROM inp_valve WHERE arc_id = arc.arc_id);
   SELECT count(*) INTO value2_rec FROM inp_valve WHERE NOT EXISTS (SELECT arc_id FROM arc WHERE arc_id = arc.arc_id);
   SELECT count(*) INTO count_rec FROM inp_valve;
   INSERT INTO audit_schema_data_integrity (parameter_id, value1, value2, count) VALUES ('arc-inp_valve',value1_rec, value2_rec, count_rec); 

 --ARC-INP_PUMP
   SELECT count(*) INTO value1_rec FROM arc WHERE epa_type = 'PUMP' AND NOT EXISTS (SELECT arc_id FROM inp_pump WHERE arc_id = arc.arc_id);
   SELECT count(*) INTO value2_rec FROM inp_pump WHERE NOT EXISTS (SELECT arc_id FROM arc WHERE arc_id = arc.arc_id);
   SELECT count(*) INTO count_rec FROM inp_pump;
   INSERT INTO audit_schema_data_integrity (parameter_id, value1, value2, count) VALUES ('arc-inp_pump',value1_rec, value2_rec, count_rec); 



DROP VIEW IF EXISTS v_audit_schema_data_node_integrity CASCADE;
create view v_audit_schema_data_node_integrity as
select
	a.node_id,
	a.type
	from ( 
	select node_id, 'man_junction' as type from man_junction union
	select node_id, 'man_valve' as type from man_valve union
	select node_id, 'man_meter' as type from man_meter union
	select node_id, 'man_hydrant' as type from man_hydrant union
	select node_id, 'man_filter' as type from man_filter union
	select node_id, 'man_pump' as type from man_pump union
	select node_id, 'man_tank' as type from man_tank)a
	where node_id not in (select node_id from node)
union
	select
	b.node_id,
	b.type
	from ( 
	select node_id, 'inp_junction' as type from inp_junction union
	select node_id, 'inp_valve' as type from inp_valve union
	select node_id, 'inp_shortpipe' as type from inp_shortpipe union
	select node_id, 'inp_pump' as type from inp_pump union
	select node_id, 'inp_reservoir' as type from inp_reservoir union
	select node_id, 'inp_tank' as type from inp_tank)b
	where node_id not in (select node_id from node);



   RETURN;
       
END;
$BODY$
LANGUAGE plpgsql VOLATILE
COST 100;

