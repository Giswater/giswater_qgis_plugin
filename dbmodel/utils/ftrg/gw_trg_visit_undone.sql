/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION "SCHEMA_NAME"."trg_visit_undone"() RETURNS pg_catalog.trigger AS $BODY$
DECLARE 
visit_aux record;

BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

 IF TG_OP = 'INSERT' THEN

         SELECT * INTO visit_aux FROM om_visit JOIN om_visit_event ON om_visit.id=om_visit_event.visit_id WHERE om_visit_event.id=NEW.id;

         UPDATE om_visit SET is_done=FALSE WHERE id=visit_aux.id;
         RETURN NULL;

 ELSIF TG_OP = 'UPDATE' THEN 
         SELECT * INTO visit_aux FROM om_visit JOIN om_visit_event ON om_visit.id=om_visit_event.visit_id WHERE om_visit_event.id=NEW.id;
         UPDATE om_visit SET is_done=FALSE WHERE id=visit_aux.id;
         RETURN NULL;

ELSIF TG_OP = 'DELETE' THEN

         UPDATE om_visit SET is_done=FALSE WHERE id=OLD.id;
         RETURN NULL;

END IF;
END;
$BODY$
LANGUAGE 'plpgsql' VOLATILE COST 100;

