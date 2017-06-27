/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_arc_state_update()  RETURNS trigger AS $BODY$

DECLARE
    querystring Varchar;
    node1_rec record;
    node2_rec record;
    nodeRecord Record;
    check_aux boolean;

BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

    SELECT arc_topocoh INTO check_aux FROM value_state where NEW.state=id;

    SELECT * INTO node1_rec FROM node WHERE node.node_id=NEW.node_1;
    SELECT * INTO node2_rec FROM node WHERE node.node_id=NEW.node_2;
   
        IF (((node1_rec.state=NEW.state) AND (check_aux IS true)) OR ((node2_rec.state=NEW.state) AND (check_aux IS true))  OR check_aux IS false) THEN
        ELSE
        RAISE EXCEPTION 'Error message';
        END IF;

    RETURN NEW;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


  
DROP TRIGGER IF EXISTS gw_trg_arc_state_update ON SCHEMA_NAME."arc";
CREATE TRIGGER gw_trg_arc_state_update AFTER UPDATE OF state ON SCHEMA_NAME."arc" FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME."gw_trg_arc_state_update"();


