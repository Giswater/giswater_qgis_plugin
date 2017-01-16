/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_audit_schema_data_repair() RETURNS void AS $BODY$ 
DECLARE
   
BEGIN

    -- Search path
    SET search_path = "SCHEMA_NAME", public;

    -- DELETE node_id on derivated tables that not exists on node table
	DELETE FROM man_junction WHERE node_id NOT IN (SELECT node_id FROM node);
	DELETE FROM man_valve WHERE node_id NOT IN (SELECT node_id FROM node);
	DELETE FROM man_hydrant WHERE node_id NOT IN (SELECT node_id FROM node);
	DELETE FROM man_meter WHERE node_id NOT IN (SELECT node_id FROM node);
	DELETE FROM man_filter WHERE node_id NOT IN (SELECT node_id FROM node);
	DELETE FROM man_pump WHERE node_id NOT IN (SELECT node_id FROM node);
	DELETE FROM man_tank WHERE node_id NOT IN (SELECT node_id FROM node);
	DELETE FROM inp_junction WHERE node_id NOT IN (SELECT node_id FROM node);
	DELETE FROM inp_shortpipe WHERE node_id NOT IN (SELECT node_id FROM node);
	DELETE FROM inp_pump WHERE node_id NOT IN (SELECT node_id FROM node);
	DELETE FROM inp_reservoir WHERE node_id NOT IN (SELECT node_id FROM node);
	DELETE FROM inp_tank WHERE node_id NOT IN (SELECT node_id FROM node);
	DELETE FROM inp_valve WHERE node_id NOT IN (SELECT node_id FROM node);

    -- DELETE arc_id on derivated tables not defined on arc table
	DELETE FROM inp_pipe WHERE arc_id NOT IN (SELECT arc_id FROM arc);

	-- INSERT node_id on derivated tables that not exists on derivated tables
	INSERT INTO man_junction SELECT node_id FROM node 
	WHERE (node_type = ANY (SELECT id FROM node_type WHERE type = 'JUNCTION')) AND NOT EXISTS (SELECT node_id FROM man_junction WHERE node_id = node.node_id);
	INSERT INTO man_valve SELECT node_id FROM node 
	WHERE (node_type = ANY (SELECT id FROM node_type WHERE type = 'VALVE')) AND NOT EXISTS (SELECT node_id FROM man_valve WHERE node_id = node.node_id);
	INSERT INTO man_tank SELECT node_id FROM node 
	WHERE (node_type = ANY (SELECT id FROM node_type WHERE type = 'TANK')) AND NOT EXISTS (SELECT node_id FROM man_tank WHERE node_id = node.node_id);
	INSERT INTO man_meter SELECT node_id FROM node 
	WHERE (node_type = ANY (SELECT id FROM node_type WHERE type = 'MEASURE INSTRUMENT')) AND NOT EXISTS (SELECT node_id FROM man_meter WHERE node_id = node.node_id);
	INSERT INTO man_hydrant SELECT node_id FROM node 
	WHERE (node_type = ANY (SELECT id FROM node_type WHERE type = 'HYDRANT')) AND NOT EXISTS (SELECT node_id FROM man_hydrant WHERE node_id = node.node_id);
	INSERT INTO man_pump SELECT node_id FROM node 
	WHERE (node_type = ANY (SELECT id FROM node_type WHERE type = 'PUMP')) AND NOT EXISTS (SELECT node_id FROM man_pump WHERE node_id = node.node_id);
	INSERT INTO man_filter SELECT node_id FROM node 
	WHERE (node_type = ANY (SELECT id FROM node_type WHERE type = 'FILTER')) AND NOT EXISTS (SELECT node_id FROM man_filter WHERE node_id = node.node_id);

	INSERT INTO inp_junction SELECT node_id FROM node WHERE epa_type='JUNCTION' AND NOT EXISTS (SELECT node_id FROM inp_junction WHERE node_id = node.node_id);
	INSERT INTO inp_valve SELECT node_id FROM node WHERE epa_type='VALVE' AND NOT EXISTS (SELECT node_id FROM inp_valve WHERE node_id = node.node_id);
	INSERT INTO inp_tank SELECT node_id FROM node WHERE epa_type='TANK' AND NOT EXISTS (SELECT node_id FROM inp_tank WHERE node_id = node.node_id);
	INSERT INTO inp_pump SELECT node_id FROM node WHERE epa_type='PUMP' AND NOT EXISTS (SELECT node_id FROM inp_pump WHERE node_id = node.node_id);
	INSERT INTO inp_reservoir SELECT node_id FROM node WHERE epa_type='RESERVOIR' AND NOT EXISTS (SELECT node_id FROM inp_reservoir WHERE node_id = node.node_id);
	INSERT INTO inp_shortpipe SELECT node_id FROM node WHERE epa_type='SHORTPIPE' AND NOT EXISTS (SELECT node_id FROM inp_shortpipe WHERE node_id = node.node_id);	


-- INSERT arc_id on derivated tables that not exists on derivated tables
	INSERT INTO inp_pipe SELECT arc_id FROM arc WHERE NOT EXISTS (SELECT arc_id FROM inp_pipe WHERE arc_id = arc.arc_id);	
	INSERT INTO man_pipe SELECT arc_id FROM arc WHERE NOT EXISTS (SELECT arc_id FROM man_pipe WHERE arc_id = arc.arc_id);	
   RETURN;
       
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

