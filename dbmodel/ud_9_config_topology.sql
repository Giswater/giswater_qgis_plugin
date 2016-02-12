/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/




CREATE OR REPLACE FUNCTION "SCHEMA_NAME".update_t_inp_arc_insert() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE 
	nodeRecord1 Record; 
	nodeRecord2 Record;
	optionsRecord Record;
	z1 double precision;
	z2 double precision;
	z_aux double precision;
	
BEGIN 
	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
	
	SELECT * INTO nodeRecord1 FROM node WHERE node.the_geom && ST_Expand(ST_startpoint(NEW.the_geom), 0.5)
		ORDER BY ST_Distance(node.the_geom, ST_startpoint(NEW.the_geom)) LIMIT 1;

	SELECT * INTO nodeRecord2 FROM node WHERE node.the_geom && ST_Expand(ST_endpoint(NEW.the_geom), 0.5)
		ORDER BY ST_Distance(node.the_geom, ST_endpoint(NEW.the_geom)) LIMIT 1;

	SELECT * INTO optionsRecord FROM inp_options LIMIT 1;

	
--	Control de lineas de longitud 0
	IF (nodeRecord1.node_id IS NOT NULL) AND (nodeRecord2.node_id IS NOT NULL) THEN
	
--  Control of same node initial and final
    IF (nodeRecord1.node_id = nodeRecord2.node_id) THEN
	RAISE EXCEPTION 'One or more features has the same Node as Node1 and Node2. Please check your project and repair it!';
	ELSE

--  Update coordinates
    NEW.the_geom := ST_SetPoint(NEW.the_geom, 0, nodeRecord1.the_geom);
    NEW.the_geom := ST_SetPoint(NEW.the_geom, ST_NumPoints(NEW.the_geom) - 1, nodeRecord2.the_geom);
		
		IF (optionsRecord.link_offsets = 'DEPTH') THEN
			z1 := (nodeRecord1.top_elev - NEW.y1);
			z2 := (nodeRecord2.top_elev - NEW.y2);
		ELSE
			z1 := NEW.y1;
			z2 := NEW.y2;	
		END IF;

		IF ((z1 > z2) AND NEW.direction = 'D') OR ((z1 < z2) AND NEW.direction = 'I') THEN

			NEW.node_1 := nodeRecord1.node_id; 
			NEW.node_2 := nodeRecord2.node_id;

		ELSE 

--			Update conduit direction
			NEW.the_geom := ST_reverse(NEW.the_geom);
			z_aux := NEW.y1;
			NEW.y1 := NEW.y2;
			NEW.y2 := z_aux;

--  Update topology info
			NEW.node_1 := nodeRecord2.node_id;
			NEW.node_2 := nodeRecord1.node_id;
		END IF;
        RETURN NEW;
	END IF;
	ELSE
    RETURN NULL;
    END IF;
END; 
$$;









CREATE OR REPLACE FUNCTION SCHEMA_NAME.update_t_inp_node_update() RETURNS trigger
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





CREATE OR REPLACE FUNCTION "SCHEMA_NAME".update_t_inp_node_delete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$ --Function created modifying "tgg_functionborralinea" developed by Jose C. Martinez Llario
--in "PostGIS 2 Analisis Espacial Avanzado" 
 
DECLARE 
	querystring Varchar; 
	arcrec Record; 
	nodosactualizados Integer; 

BEGIN 

	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
	
	nodosactualizados := 0; 
 
	querystring := 'SELECT arc.arc_id AS arc_id FROM arc WHERE arc.node_1 = ' || quote_literal(OLD.node_id) || ' OR arc.node_2 = ' || quote_literal(OLD.node_id); 

	FOR arcrec IN EXECUTE querystring
	LOOP
		EXECUTE 'DELETE FROM arc WHERE arc_id = ' || quote_literal(arcrec."arc_id"); 

	END LOOP; 

	RETURN OLD; 
END; 
$$;



CREATE TRIGGER update_t_inp_insert_arc BEFORE INSERT OR UPDATE ON "SCHEMA_NAME"."arc" FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME"."update_t_inp_arc_insert"();
CREATE TRIGGER update_t_inp_update_node AFTER UPDATE ON "SCHEMA_NAME"."node" FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME"."update_t_inp_node_update"();
CREATE TRIGGER update_t_inp_delete_node BEFORE DELETE ON "SCHEMA_NAME"."node" FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME"."update_t_inp_node_delete"();



