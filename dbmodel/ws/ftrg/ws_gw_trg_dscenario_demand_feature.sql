/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 3232

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_dscenario_demand_feature()  RETURNS trigger AS
$BODY$

DECLARE 

BEGIN

	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

	IF NEW.feature_type='NODE' THEN
		IF (SELECT count(node_id) FROM node WHERE node_id=NEW.feature_id) = 0 THEN
			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
	        "data":{"message":"3230", "function":"3232","debug_msg": "(node_id='||NEW.feature_id||')"}}$$);';
		END IF;
	ELSIF NEW.feature_type='CONNEC' THEN
		IF (SELECT count(connec_id) FROM connec WHERE connec_id=NEW.feature_id) = 0 THEN
			--RAISE EXCEPTION 'HERE222';
			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
	        "data":{"message":"3230", "function":"3232","debug_msg": "(connec_id='||NEW.feature_id||')"}}$$);';
		END IF;
	END IF;
	
	RETURN NEW;
	
END;
	
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;



