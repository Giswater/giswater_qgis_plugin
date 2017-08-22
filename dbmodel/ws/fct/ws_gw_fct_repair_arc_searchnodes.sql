/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path="SCHEMA_NAME",public;

/*
DROP FUNCTION IF EXISTS gw_fct_topo_arc_searchnodes();
CREATE OR REPLACE FUNCTION gw_fct_topo_arc_searchnodes() RETURNS void AS
$BODY$
DECLARE 
    arcrec Record;
    nodeRecord1 Record; 
    nodeRecord2 Record;
    optionsRecord Record;
    rec Record;

BEGIN 

   SET search_path= 'SCHEMA_NAME','public';

    -- Get data from config table
    SELECT * INTO rec FROM config;    

	-- Starting loop process
    FOR arcrec IN SELECT * FROM arc
    LOOP
    
	SELECT * INTO nodeRecord1 FROM node WHERE ST_DWithin(ST_startpoint(arcrec.the_geom), node.the_geom, rec.arc_searchnodes)
	ORDER BY ST_Distance(node.the_geom, ST_startpoint(arcrec.the_geom)) LIMIT 1;

	SELECT * INTO nodeRecord2 FROM node WHERE ST_DWithin(ST_endpoint(arcrec.the_geom), node.the_geom, rec.arc_searchnodes)
	ORDER BY ST_Distance(node.the_geom, ST_endpoint(arcrec.the_geom)) LIMIT 1;

    SELECT * INTO optionsRecord FROM inp_options LIMIT 1;


	--insert into a1 values (arcrec.arc_id, nodeRecord1.node_id, nodeRecord2.node_id);

    -- Control of start/end node
    IF (nodeRecord1.node_id IS NOT NULL) AND (nodeRecord2.node_id IS NOT NULL) THEN	

        -- Control de lineas de longitud 0
        IF (nodeRecord1.node_id = nodeRecord2.node_id) AND (rec.samenode_init_end_control IS TRUE) THEN
		    
        ELSE
        
	        -- Update coordinates
            arcrec.the_geom := ST_SetPoint(arcrec.the_geom, 0, nodeRecord1.the_geom);
            arcrec.the_geom := ST_SetPoint(arcrec.the_geom, ST_NumPoints(arcrec.the_geom) - 1, nodeRecord2.the_geom);
 
            UPDATE arc 
			SET the_geom=arcrec.the_geom, y1=arcrec.y1, y2=arcrec.y2, 
            node_1=arcrec.nodeRecord1.node_id, node_2=nodeRecord2.node_id where arc_id=arcrec.arc_id;    

            END IF;  
            
	    END IF;

    END IF;

    END LOOP;

  RETURN;
    	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
  
    */