

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_node_arc_divide()
  RETURNS trigger AS
$BODY$
DECLARE 

rec record;
arc_id_aux varchar;

BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
	

--  Only enabled on insert
	IF TG_OP = 'INSERT' THEN

		SELECT * INTO rec FROM config;
	
		SELECT arc_id INTO arc_id_aux FROM v_edit_arc WHERE ST_intersects((NEW.the_geom), St_buffer(v_edit_arc.the_geom,rec.node_proximity)) LIMIT 1;
		IF arc_id_aux IS NOT NULL THEN
			PERFORM gw_fct_node2arc(NEW.node_id);	
		END IF;	

   	END IF;

RETURN NEW;
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
  
  
DROP TRIGGER IF EXISTS gw_trg_node_arc_divide ON "SCHEMA_NAME".node;
CREATE TRIGGER gw_trg_node_arc_divide AFTER INSERT ON "SCHEMA_NAME".node FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_node_arc_divide();

