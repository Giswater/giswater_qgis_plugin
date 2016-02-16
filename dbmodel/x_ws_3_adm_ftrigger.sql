/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/



 
CREATE OR REPLACE FUNCTION SCHEMA_NAME.adm_log_node() RETURNS trigger AS
$BODY$BEGIN

	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
	
      IF TG_OP = 'INSERT' THEN
        INSERT INTO adm_log_node VALUES( nextval('log_node_seq'::regclass),NEW.node_id, NEW.elevation, NEW.enet_type, NEW.sector_id, NEW.the_geom, NEW.node_type, NEW."depth", NEW.link, NEW."state", NEW.annotation, NEW.observ, NEW.event, 'INSERT', user, CURRENT_TIMESTAMP);
        RETURN NEW;

      ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO adm_log_node VALUES( nextval('log_node_seq'::regclass),OLD.node_id, OLD.elevation, OLD.enet_type, OLD.sector_id, OLD.the_geom, OLD.node_type, OLD."depth", OLD.link, OLD."state", OLD.annotation, OLD.observ, OLD.event, 'UPDATE', user, CURRENT_TIMESTAMP);
       RETURN NEW;

      ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO adm_log_node VALUES( nextval('log_node_seq'::regclass),OLD.node_id, OLD.elevation, OLD.enet_type, OLD.sector_id, OLD.the_geom, OLD.node_type, OLD."depth", OLD.link, OLD."state", OLD.annotation, OLD.observ, OLD.event, 'DELETE', user, CURRENT_TIMESTAMP);
       RETURN NULL;
      END IF;
     RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

 

  
CREATE OR REPLACE FUNCTION SCHEMA_NAME.adm_log_arc() RETURNS trigger AS
$BODY$BEGIN

	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

	IF TG_OP = 'INSERT' THEN
        INSERT INTO adm_log_arc VALUES( nextval('log_arc_seq'::regclass),NEW.arc_id, NEW.arccat_id, NEW.enet_type, NEW.sector_id, NEW.the_geom, NEW.arc_type, NEW.link, NEW."state", NEW.annotation, NEW.observ, NEW.event, 'INSERT', user, CURRENT_TIMESTAMP);
        RETURN NEW;

      ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO adm_log_arc VALUES( nextval('log_arc_seq'::regclass),OLD.arc_id, OLD.arccat_id, OLD.enet_type, OLD.sector_id, OLD.the_geom, OLD.arc_type, OLD.link, OLD."state", OLD.annotation, OLD.observ, OLD.event, 'UPDATE', user, CURRENT_TIMESTAMP);
       RETURN NEW;

      ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO adm_log_arc VALUES( nextval('log_arc_seq'::regclass),OLD.arc_id, OLD.arccat_id, OLD.enet_type, OLD.sector_id, OLD.the_geom, OLD.arc_type, OLD.link, OLD."state", OLD.annotation, OLD.observ, OLD.event, 'DELETE', user, CURRENT_TIMESTAMP);
       RETURN NULL;
      END IF;
     RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;



CREATE TRIGGER adm_log_node  AFTER INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.node FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.adm_log_node();
  
CREATE TRIGGER adm_log_arc  AFTER INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.arc FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.adm_log_arc();
 