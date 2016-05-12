/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/



--------------------------------------------------------------------------------
-- Function created to repair wrong cad files with errors in the topology arc-node
----------------------------------------------------------------------------------

-- To use:
-- 1. Replace TOLERANCE_METERS by value of your tolerance (in meters)
-- 2. Load using SQL FILE LAUNCHER of Giswater
----------------------------------------------------------------------------------



CREATE OR REPLACE FUNCTION sample_ud.update_topo1() RETURNS INT AS $$

DECLARE

arcRecord Record;
nodeRecord1 Record;
nodeRecord2 Record;
optionsRecord Record;
z1 double precision;
z2 double precision;
y_aux double precision;
node_1 varchar (16);
node_2 varchar (16);



BEGIN

	SELECT * INTO arcRecord FROM "sample_ud"."arc" LIMIT 1;

    SELECT * INTO nodeRecord1 FROM "sample_ud"."node" WHERE node.the_geom && ST_Expand(ST_startpoint(arcRecord.the_geom), _PARAMTOLERANCE_)
	ORDER BY ST_Distance(node.the_geom, ST_startpoint(arcRecord.the_geom)) LIMIT 1;

    SELECT * INTO nodeRecord2 FROM "sample_ud"."node" WHERE node.the_geom && ST_Expand(ST_endpoint(arcRecord.the_geom), _PARAMTOLERANCE_)
    ORDER BY ST_Distance(node.the_geom, ST_endpoint(arcRecord.the_geom)) LIMIT 1;

    SELECT * INTO optionsRecord FROM sample_ud.inp_options LIMIT 1;


--  Control de lineas de longitud 0
    IF (nodeRecord1.node_id IS NOT NULL) AND (nodeRecord2.node_id IS NOT NULL) THEN

--  Update coordinates

	UPDATE "sample_ud"."arc" SET the_geom = ST_SetPoint(arcRecord.the_geom, 0, nodeRecord1.the_geom) WHERE arc_id=arcRecord.arc_id;
    UPDATE "sample_ud"."arc" SET the_geom = ST_SetPoint(arc.the_geom, ST_NumPoints(arcRecord.the_geom) - 1, nodeRecord2.the_geom) WHERE arc_id=arcRecord.arc_id;  

		IF (optionsRecord.link_offsets = 'DEPTH') THEN
        z1 = (nodeRecord1.top_elev - arcRecord.y1);
		z2 = (nodeRecord2.top_elev - arcRecord.y2); 
        ELSE
		z1 = arcRecord.y1;
		z2 = arcRecord.y2;
		
		END IF;

		IF (z1 > z2) THEN
        UPDATE "sample_ud"."arc" SET node_1 = nodeRecord1.node_id WHERE arc_id=arcRecord.arc_id;
		UPDATE "sample_ud"."arc" SET node_2 = nodeRecord2.node_id WHERE arc_id=arcRecord.arc_id;
        ELSE
--  Update conduit direction
		UPDATE "sample_ud"."arc" SET the_geom = ST_reverse(arcRecord.the_geom) WHERE arc_id=arcRecord.arc_id;
		y_aux = arcRecord.y1;
		UPDATE "sample_ud"."arc" SET y1 =arcRecord.y2 WHERE arc_id=arcRecord.arc_id;
		UPDATE "sample_ud"."arc" SET y2 =y_aux WHERE arc_id=arcRecord.arc_id;

--  Update topology info
		UPDATE "sample_ud"."arc" SET node_1 = nodeRecord2.node_id WHERE arc_id=arcRecord.arc_id;
		UPDATE "sample_ud"."arc" SET node_2 = nodeRecord1.node_id WHERE arc_id=arcRecord.arc_id;
		END IF;
        RETURN 1;
	ELSE
    RETURN NULL;
    END IF;
RETURN 1;
END; 
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION sample_ud.update_topo2() RETURNS INT AS $$
DECLARE 
	countrecord integer;
  
BEGIN
SELECT COUNT(*) INTO countrecord FROM sample_ud.arc;
FOR i IN 1..countrecord
LOOP
PERFORM sample_ud.update_topo1();
END LOOP;
RETURN 1;
END; 
$$ LANGUAGE plpgsql;

select sample_ud.update_topo2();