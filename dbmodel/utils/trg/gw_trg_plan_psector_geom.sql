CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_plan_arc_x_psector_geom() RETURNS trigger AS
$BODY$

DECLARE 
    
polygon_aux geometry;

epsg_val integer;
collect_aux geometry;

BEGIN 

    SET search_path = "SCHEMA_NAME", public;

	SELECT epsg INTO epsg_val FROM version LIMIT 1;

	IF TG_OP='INSERT' OR TG_OP='UPDATE' THEN

		--Calculate aggregated geom
		SELECT st_collect(f.the_geom) INTO collect_aux 
		FROM ( select the_geom from arc join plan_arc_x_psector ON plan_arc_x_psector.arc_id=arc.arc_id where psector_id=NEW.psector_id UNION
		select the_geom from node join plan_node_x_psector ON plan_node_x_psector.node_id=node.node_id where psector_id=NEW.psector_id) f;

		-- Calculate boundary box of aggregated geom
		polygon_aux=st_collect(ST_MakeEnvelope(st_xmax(collect_aux)+5,st_ymax(collect_aux)+5,st_xmin(collect_aux)-5,st_ymin(collect_aux)-5, epsg_val));

		-- Update geometry field
		UPDATE plan_psector SET the_geom=polygon_aux WHERE psector_id=NEW.psector_id;
	ELSE 

		--Calculate aggregated geom
		SELECT st_collect(f.the_geom) INTO collect_aux 
		FROM ( select the_geom from arc join plan_arc_x_psector ON plan_arc_x_psector.arc_id=arc.arc_id where psector_id=OLD.psector_id UNION
		select the_geom from node join plan_node_x_psector ON plan_node_x_psector.node_id=node.node_id where psector_id=OLD.psector_id) f;
		-- Calculate boundary box of aggregated geom
		polygon_aux=st_collect(ST_MakeEnvelope(st_xmax(collect_aux)+5,st_ymax(collect_aux)+5,st_xmin(collect_aux)-5,st_ymin(collect_aux)-5, epsg_val));

		-- Update geometry field
		UPDATE plan_psector SET the_geom=polygon_aux WHERE psector_id=OLD.psector_id;

	END IF;


	
RETURN NEW;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

DROP TRIGGER IF EXISTS gw_trg_plan_arc_x_psector_geom ON SCHEMA_NAME.plan_arc_x_psector;
 CREATE TRIGGER gw_trg_plan_arc_x_psector_geom  AFTER INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.plan_arc_x_psector
 FOR EACH ROW  EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_plan_arc_x_psector_geom();
 
 
 DROP TRIGGER IF EXISTS gw_trg_plan_node_x_psector_geom ON SCHEMA_NAME.plan_node_x_psector;
 CREATE TRIGGER gw_trg_plan_node_x_psector_geom  AFTER INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.plan_node_x_psector
 FOR EACH ROW  EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_plan_arc_x_psector_geom();