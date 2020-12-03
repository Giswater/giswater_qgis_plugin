/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 1104


CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_arc_orphannode_delete() RETURNS trigger LANGUAGE plpgsql AS $$
DECLARE 
    v_orphannode_delete boolean;
    numArcs integer;
    
BEGIN 

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
    
    -- Get snapping_tolerance from config table
    SELECT value::boolean INTO v_orphannode_delete FROM config_param_system WHERE parameter='edit_arc_orphannode_delete';

    -- Delete orphan nodes
    IF v_orphannode_delete THEN
    
        SELECT count(*) INTO numArcs FROM arc WHERE node_1 = OLD.node_1 OR node_2 = OLD.node_1;
        IF numArcs = 0 THEN
            DELETE FROM node WHERE node_id = OLD.node_1;
        END IF;

        SELECT count(*) INTO numArcs FROM arc WHERE node_1 = OLD.node_2 OR node_2 = OLD.node_2;
        IF numArcs = 0 THEN
            DELETE FROM node WHERE node_id = OLD.node_2;
        END IF;

    END IF;
     
    RETURN OLD;

END;
$$;