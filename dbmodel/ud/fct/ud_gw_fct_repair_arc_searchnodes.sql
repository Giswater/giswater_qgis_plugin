/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2230

DROP FUNCTION IF EXISTS "SCHEMA_NAME".gw_fct_repair_arc_searchnodes();
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_repair_arc_searchnodes() RETURNS void AS

$BODY$
DECLARE 
    arcrec Record;
    nodeRecord1 Record; 
    nodeRecord2 Record;
    optionsRecord Record;
    rec Record;
    z1 double precision;
    z2 double precision;
    z_aux double precision;
    value1 boolean;
    value2 boolean;

BEGIN 

   SET search_path= 'SCHEMA_NAME','public';

    -- Init variables
    value1:= true;
    value2:= true;
    
    -- Get data from config table
    SELECT * INTO rec FROM config;    

	-- Starting loop process
    FOR arcrec IN SELECT * FROM arc
    LOOP
    
	SELECT * INTO nodeRecord1 FROM node WHERE ST_DWithin(ST_startpoint(arcrec.the_geom), node.the_geom, rec.arc_searchnodes) AND node.unconnected IS NOT TRUE
	ORDER BY ST_Distance(node.the_geom, ST_startpoint(arcrec.the_geom)), state desc LIMIT 1;

	SELECT * INTO nodeRecord2 FROM node WHERE ST_DWithin(ST_endpoint(arcrec.the_geom), node.the_geom, rec.arc_searchnodes)  AND node.unconnected IS NOT TRUE
	ORDER BY ST_Distance(node.the_geom, ST_endpoint(arcrec.the_geom)) , state desc LIMIT 1;

    SELECT * INTO optionsRecord FROM inp_options LIMIT 1;

    IF arcrec.y1 IS NULL then 
		arcrec.y1=0;
		value1:=false;
    END IF;
	
    IF arcrec.y2 IS NULL then 
		arcrec.y2=0;
		value2:=false;
    END IF;

	--insert into a1 values (arcrec.arc_id, nodeRecord1.node_id, nodeRecord2.node_id);

    -- Control of start/end node
    IF (nodeRecord1.node_id IS NOT NULL) AND (nodeRecord2.node_id IS NOT NULL) THEN	

        -- Control de lineas de longitud 0
        IF (nodeRecord1.node_id = nodeRecord2.node_id) AND (rec.samenode_init_end_control IS TRUE) THEN
		    
        ELSE
        
	        -- Update coordinates
            arcrec.the_geom := ST_SetPoint(arcrec.the_geom, 0, nodeRecord1.the_geom);
            arcrec.the_geom := ST_SetPoint(arcrec.the_geom, ST_NumPoints(arcrec.the_geom) - 1, nodeRecord2.the_geom);
        
            IF (optionsRecord.link_offsets = 'DEPTH') THEN
                z1 := (nodeRecord1.top_elev - arcrec.y1);
                z2 := (nodeRecord2.top_elev - arcrec.y2);
                ELSE
                    z1 := arcrec.y1;
                    z2 := arcrec.y2;
            END IF;

            IF value1 is false then arcrec.y1:= null; 
            END IF;
                
            IF value2 is false then arcrec.y2:= null; 
            END IF;


            IF ((z1 > z2) AND arcrec.inverted_slope is not true) OR ((z1 < z2) AND arcrec.inverted_slope is true) THEN
                arcrec.node_1 := nodeRecord1.node_id; 
                arcrec.node_2 := nodeRecord2.node_id;             

                UPDATE arc SET the_geom=arcrec.the_geom, y1=arcrec.y1, y2=arcrec.y2, 
				node_1=arcrec.node_1, node_2=arcrec.node_2 where arc_id=arcrec.arc_id;    

            ELSE 

                -- Update conduit direction
                arcrec.the_geom := ST_reverse(arcrec.the_geom);
                z_aux := arcrec.y1;
                arcrec.y1 := arcrec.y2;
                arcrec.y2 := z_aux;
                arcrec.node_1 := nodeRecord2.node_id;
                arcrec.node_2 := nodeRecord1.node_id;                             

                UPDATE arc SET the_geom=arcrec.the_geom, y1=arcrec.y1, y2=arcrec.y2, 
                node_1=arcrec.node_1, node_2=arcrec.node_2 where arc_id=arcrec.arc_id;    

            END IF;  
            
		END IF;

      END IF;

    END LOOP;

  RETURN;
    
END;  
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;