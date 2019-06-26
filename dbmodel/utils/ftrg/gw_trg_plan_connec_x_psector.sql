/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


CREATE OR REPLACE FUNCTION gw_trg_plan_psector_x_connec()
  RETURNS trigger AS
$BODY$
DECLARE 
    featurecat_aux text;
    psector_vdefault_var integer;
    insert_into_psector_aux integer;
    connec_1_aux varchar;
    connec_2_aux varchar;
    connec_geom_aux public.geometry;
    state_aux smallint;
    is_doable_aux boolean;
	

BEGIN 

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

	SELECT connec.state INTO state_aux FROM connec WHERE connec_id=NEW.connec_id;
		IF state_aux=1	THEN 
			NEW.state=0;
			NEW.doable=false;
		ELSIF state_aux=2 THEN
			NEW.state=1;
			NEW.doable=true;
		END IF;

RETURN NEW;

END;  
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
