/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_arc_toporepair() RETURNS void AS
$BODY$
DECLARE 
    arcrec record;
    nodeRecord1 record; 
    nodeRecord2 record; 
    rec record;  
    vnoderec record;
    newPoint public.geometry;    
    connecPoint public.geometry;
    check_aux boolean;

BEGIN 

    SET search_path = "SCHEMA_NAME",public;
    
    -- Get data from config table
    SELECT * INTO rec FROM config;  
	--SELECT arc_topocoh INTO check_aux FROM value_state where arcrec.state=id;
	
	FOR arcrec IN SELECT * FROM arc
		LOOP
	
		SELECT * INTO nodeRecord1 FROM node WHERE (ST_DWithin(ST_startpoint(arcrec.the_geom), node.the_geom, rec.arc_searchnodes) )
		--AND ((check_aux IS true AND arcrec.state=node.state) OR check_aux IS false))	
		ORDER BY ST_Distance(node.the_geom, ST_startpoint(arcrec.the_geom)) LIMIT 1;
	
		SELECT * INTO nodeRecord2 FROM node WHERE (ST_DWithin(ST_endpoint(arcrec.the_geom), node.the_geom, rec.arc_searchnodes) )
		--AND ((check_aux IS true AND arcrec.state=node.state) OR check_aux IS false))
		ORDER BY ST_Distance(node.the_geom, ST_endpoint(arcrec.the_geom)) LIMIT 1;
   

	-- Control of length line
	IF (nodeRecord1.node_id IS NOT NULL) AND (nodeRecord2.node_id IS NOT NULL) THEN
    
        -- Control of same node initial and final
     --   IF (nodeRecord1.node_id = nodeRecord2.node_id) AND (rec.samenode_init_end_control IS TRUE) THEN
    --        RETURN audit_function (180,330);
        
    --    ELSE
            -- Update coordinates
            UPDATE arc SET the_geom= ST_SetPoint(arcrec.the_geom, 0, nodeRecord1.the_geom) WHERE arc_id=arcrec.arc_id;
            UPDATE arc SET the_geom= ST_SetPoint(arcrec.the_geom, ST_NumPoints(arcrec.the_geom) - 1, nodeRecord2.the_geom) WHERE arc_id=arcrec.arc_id;
            UPDATE arc SET node_1= nodeRecord1.node_id WHERE arc_id=arcrec.arc_id; 
            UPDATE arc SET node_2= nodeRecord2.node_id WHERE arc_id=arcrec.arc_id;
            
	END IF;
	END LOOP;

RETURN;

END; 
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

