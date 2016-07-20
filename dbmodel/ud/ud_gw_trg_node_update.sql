/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/




CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_node_update() RETURNS trigger
LANGUAGE plpgsql AS $$

DECLARE 
	querystring Varchar; 
	arcrec Record; 
	nodeRecord1 Record; 
	nodeRecord2 Record; 
	optionsRecord Record;
	z1 double precision;
	z2 double precision;

BEGIN 

	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

--	Select options
	SELECT * INTO optionsRecord FROM inp_options LIMIT 1;

--	Select arcs with start-end on the updated node
	querystring := 'SELECT * FROM "arc" WHERE arc.node_1 = ' || quote_literal(NEW.node_id) || ' OR arc.node_2 = ' || quote_literal(NEW.node_id); 

	FOR arcrec IN EXECUTE querystring
	LOOP


--		Initial and final node of the arc
		SELECT * INTO nodeRecord1 FROM node WHERE node.node_id = arcrec.node_1;
		SELECT * INTO nodeRecord2 FROM node WHERE node.node_id = arcrec.node_2;


--		Control de lineas de longitud 0
		IF (nodeRecord1.node_id IS NOT NULL) AND (nodeRecord2.node_id IS NOT NULL) THEN


--			Update arc node coordinates, node_id and direction
			IF (nodeRecord1.node_id = NEW.node_id) THEN


--				Coordinates
				EXECUTE 'UPDATE arc SET the_geom = ST_SetPoint($1, 0, $2) WHERE arc_id = ' || quote_literal(arcrec."arc_id") USING arcrec.the_geom, NEW.the_geom; 


--				Search the upstream node
				IF (optionsRecord.link_offsets = 'DEPTH') THEN
					z1 = (NEW.top_elev - arcrec.y1);
					z2 = (nodeRecord2.top_elev - arcrec.y2);

--					Update direction if necessary
					IF ((z2 > z1) AND arcrec.direction = 'D') OR ((z2 < z1) AND arcrec.direction = 'I') THEN
						EXECUTE 'UPDATE arc SET node_1 = ' || quote_literal(nodeRecord2.node_id) || ', node_2 = ' || quote_literal(NEW.node_id) || ' WHERE arc_id = ' || quote_literal(arcrec."arc_id"); 
						EXECUTE 'UPDATE arc SET y1 = ' || arcrec.y2 || ', y2 = ' || arcrec.y1 || ' WHERE arc_id = ' || quote_literal(arcrec."arc_id"); 
						EXECUTE 'UPDATE arc SET the_geom = ST_reverse($1) WHERE arc_id = ' || quote_literal(arcrec."arc_id") USING arcrec.the_geom;
					END IF;

				END IF;
				
			ELSE


--				Coordinates
				EXECUTE 'UPDATE arc SET the_geom = ST_SetPoint($1, ST_NumPoints($1) - 1, $2) WHERE arc_id = ' || quote_literal(arcrec."arc_id") USING arcrec.the_geom, NEW.the_geom; 


--				Search the upstream node
				IF (optionsRecord.link_offsets = 'DEPTH') THEN
					z1 = (nodeRecord1.top_elev - arcrec.y1);
					z2 = (NEW.top_elev - arcrec.y2);

--					Update direction if necessary
					IF (z2 > z1) THEN
						EXECUTE 'UPDATE arc SET node_1 = ' || quote_literal(NEW.node_id) || ', node_2 = ' || quote_literal(nodeRecord1.node_id) || ' WHERE arc_id = ' || quote_literal(arcrec."arc_id"); 
						EXECUTE 'UPDATE arc SET y1 = ' || arcrec.y2 || ', y2 = ' || arcrec.y1 || ' WHERE arc_id = ' || quote_literal(arcrec."arc_id"); 
						EXECUTE 'UPDATE arc SET the_geom = ST_reverse($1) WHERE arc_id = ' || quote_literal(arcrec."arc_id") USING arcrec.the_geom;
					END IF;

				END IF;

			END IF;

		END IF;

	END LOOP; 

	RETURN NEW;

END; 
$$;



-- CREATE TRIGGER gw_trg_node_update AFTER UPDATE ON "SCHEMA_NAME"."node" 
-- FOR EACH ROW WHEN (((old.the_geom IS DISTINCT FROM new.the_geom)) OR ((old.top_elev IS DISTINCT FROM new.top_elev)) OR ((old.ymax IS DISTINCT FROM new.ymax))) EXECUTE PROCEDURE "SCHEMA_NAME"."gw_trg_node_update"();

CREATE TRIGGER gw_trg_node_update AFTER UPDATE ON "SCHEMA_NAME"."node" 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME"."gw_trg_node_update"();

