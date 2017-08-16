/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_vnode_update() RETURNS trigger AS $BODY$
DECLARE
    connecPoint geometry;
    arcPoint geometry;
    linkrec record;
    arcrec record;
	rec record;


BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

    -- Update vnode
	SELECT * INTO rec FROM config;
    SELECT * INTO arcrec FROM arc WHERE ST_DWithin((NEW.the_geom), arc.the_geom, rec.vnode_update_tolerance) ORDER BY ST_Distance(arc.the_geom, (NEW.the_geom)) LIMIT 1;
     
    IF arcrec.arc_id IS NOT NULL THEN
        NEW.arc_id = arcrec.arc_id;
        NEW.the_geom = ST_ClosestPoint(arcrec.the_geom, NEW.the_geom);
    END IF;

    -- Select links with end on the updated vnode
    FOR linkrec IN SELECT * FROM link WHERE vnode_id = NEW.vnode_id
    LOOP
        -- Update link
        featurecat_aux := (SELECT featurecat_id FROM link WHERE vnode_id = linkrec.vnode_id);
                  
        IF (featurecat_aux = 'connec') THEN 
			connecPoint := (SELECT the_geom FROM connec WHERE connec_id IN (SELECT a.feature_id FROM link AS a WHERE a.vnode_id = linkrec.vnode_id));
			UPDATE link SET the_geom = ST_MakeLine(connecPoint, NEW.the_geom) WHERE link_id = linkrec.link_id;
		ELSE
			connecPoint := (SELECT the_geom FROM gully WHERE gully_id IN (SELECT a.feature_id FROM link AS a WHERE a.vnode_id = linkrec.vnode_id));
			UPDATE link SET the_geom = ST_MakeLine(connecPoint, NEW.the_geom) WHERE link_id = linkrec.link_id;
		END IF;
		
    END LOOP;

    RETURN NEW;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


  
DROP TRIGGER IF EXISTS gw_trg_vnode_update ON "SCHEMA_NAME"."vnode";
CREATE TRIGGER gw_trg_vnode_update BEFORE UPDATE OF the_geom ON "SCHEMA_NAME"."vnode"
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME"."gw_trg_vnode_update"();