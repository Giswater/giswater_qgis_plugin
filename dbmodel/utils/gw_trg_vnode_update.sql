
CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_vnode_update()
  RETURNS trigger AS
$BODY$

DECLARE

    connecPoint geometry;
    arcPoint geometry;
    linkrec record;
	arcrec record;

BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

    -- Select links with end on the updated vnode
    FOR linkrec IN SELECT * FROM link WHERE vnode_id = NEW.vnode_id
    LOOP
        -- Update link
        connecPoint := (SELECT the_geom FROM connec WHERE connec_id = linkrec.connec_id);
        UPDATE link 
		SET the_geom = ST_MakeLine(connecPoint, NEW.the_geom) WHERE link_id = linkrec.link_id;

        -- Update vnode
	--	SELECT * INTO arcrec FROM arc WHERE ST_DWithin((NEW.the_geom), arc.the_geom, rec.arc_searchnodes) ORDER BY ST_Distance(arc.the_geom, (NEW.the_geom)) LIMIT 1;
	--	UPDATE vnode
	--	SET arc_id = arcrec WHERE vnode_id = NEW.vnode_id, 


    END LOOP;

    RETURN OLD;
END;

$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


CREATE TRIGGER gw_trg_vnode_update AFTER UPDATE ON "SCHEMA_NAME"."vnode"
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME"."gw_trg_vnode_update"();