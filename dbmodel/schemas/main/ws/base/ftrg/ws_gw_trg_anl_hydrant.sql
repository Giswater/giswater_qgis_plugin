/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3164

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_anl_hydrant()  RETURNS trigger AS
$BODY$

DECLARE 

BEGIN

	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
	
	IF TG_OP = 'INSERT' THEN
		
		-- expl_id		
		IF NEW.the_geom IS NOT NULL THEN
			IF NEW.expl_id IS NULL THEN
				NEW.expl_id := (SELECT expl_id FROM ve_arc WHERE ST_DWithin(NEW.the_geom, ve_arc.the_geom, 50)  ORDER BY ST_Distance(NEW.the_geom, ve_arc.the_geom) ASC LIMIT 1);
			END IF;
		END IF;

		NEW.node_id=nextval('SCHEMA_NAME.urn_id_seq'::regclass);

		INSERT INTO anl_node (node_id, nodecat_id, expl_id, the_geom, fid)
		VALUES (NEW.node_id, 'PROPOSED HYDRANT', NEW.expl_id, NEW.the_geom, 468);

		RETURN NEW;
		
	ELSIF TG_OP = 'UPDATE' THEN
   	
		UPDATE anl_node 
		SET node_id=NEW.node_id, nodecat_id=NEW.nodecat_id, expl_id=NEW.expl_id, the_geom=NEW.the_geom
		WHERE node_id=OLD.node_id AND fid=468 and cur_user=current_user;
		
		RETURN NEW;
		
	ELSIF TG_OP = 'DELETE' THEN  
	 
		DELETE FROM anl_node WHERE node_id=OLD.node_id AND fid=468 and cur_user=current_user;
		RETURN NULL;
	END IF;
END;
	
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


