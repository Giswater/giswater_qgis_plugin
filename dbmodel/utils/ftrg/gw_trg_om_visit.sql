
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_om_visit()
  RETURNS trigger AS
$BODY$
DECLARE 

v_version text;
v_featuretype text;
v_id text;
v_lottable text;
v_featureid text;
v_visittable text;
v_querytext text;


BEGIN

   EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

   v_version = (SELECT giswater FROM version ORDER by 1 desc LIMIT 1);

   v_featuretype = (SELECT lower(feature_type) FROM om_visit_lot WHERE id = NEW.lot_id LIMIT 1);

   IF v_featuretype  = 'arc' THEN
    v_id = (SELECT arc_id FROM om_visit_x_arc WHERE visit_id=NEW.visit_id);
    v_visittable = 'om_visit_x_arc';
    v_lottable = 'om_visit_lot_x_arc';
    v_featureid = 'arc_id';

   ELSIF v_featuretype  = 'node' THEN

   ELSIF v_featuretype  = 'connec' THEN


   ELSIF v_featuretype  = 'gully' THEN
	v_id = (SELECT gully_id FROM om_visit_x_gully WHERE visit_id=NEW.id);
	v_visittable = 'om_visit_x_gully';
	v_lottable = 'om_visit_lot_x_gully';
	v_featureid = 'gully_id';

   END IF;
   
   IF TG_OP='INSERT' THEN
	
		-- automatic creation of workcat
		IF (SELECT (value::json->>'AutoNewWorkcat') FROM config_param_system WHERE parameter='om_visit_parameters') THEN
			INSERT INTO cat_work (id) VALUES (NEW.id);
		END IF;

		-- setting values of enddate
		IF NEW.status > 0 THEN 
			NEW.enddate=null;
		ELSIF NEW.status  = 0 THEN 
			v_querytext= 'UPDATE '||quote_ident(v_lottable) ||' SET status=0 WHERE lot_id::text=' || quote_literal (NEW.lot_id) ||' AND '||quote_ident(v_featureid)||'::text ='||quote_literal(v_id);
			IF v_querytext IS NOT NULL THEN
				EXECUTE v_querytext;
			END IF;
		END IF;	

		RETURN NEW;


    ELSIF TG_OP='UPDATE' THEN	

		-- setting values of enddate
		IF NEW.status > 0 THEN
			NEW.enddate=null;
		ELSIF NEW.status  = 0 THEN
			v_querytext= 'UPDATE '||quote_ident(v_lottable) ||' SET status=0 WHERE lot_id::text=' || quote_literal (NEW.lot_id) ||' AND '||quote_ident(v_featureid)||'::text ='||quote_literal(v_id);
			IF v_querytext IS NOT NULL THEN
				EXECUTE v_querytext; 
			END IF;
			
		END IF;	

		IF v_version > '3.2.019' THEN
			IF NEW.class_id != OLD.class_id THEN
				DELETE FROM om_visit_event WHERE visit_id=NEW.id;			
			END IF;
		END IF;

		RETURN NEW;
				
    ELSIF TG_OP='DELETE' THEN
	
    	-- automatic creation of workcat
		IF (SELECT (value::json->>'AutoNewWorkcat') FROM config_param_system WHERE parameter='om_visit_parameters') THEN
			DELETE FROM cat_work WHERE id=OLD.id::text;
		END IF;
		
		RETURN OLD;
		
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
