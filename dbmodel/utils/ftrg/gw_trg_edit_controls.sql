/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2718


DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_trg_edit_controls() CASCADE;
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_edit_controls()
  RETURNS trigger AS
$BODY$
DECLARE
v_featurefield varchar;
v_featurenew varchar;
v_featureold varchar;
v_projecttype text;
v_count integer;

BEGIN

  EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

  v_featurefield:= TG_ARGV[0];



  IF v_featurefield = 'inp_subcatchment' THEN
    IF TG_OP = 'UPDATE' THEN
      IF NEW.subc_id != OLD.subc_id THEN
        UPDATE inp_dscenario_lids SET subc_id=NEW.subc_id WHERE subc_id=OLD.subc_id;
        RETURN NEW;
      END IF;
    ELSIF TG_OP = 'DELETE' THEN
      DELETE FROM inp_dscenario_lids WHERE subc_id=OLD.subc_id;
      RETURN NULL;
    END IF;

  ELSIF v_featurefield = 'inp_dscenario_lids' THEN
    IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' THEN

      IF NEW.subc_id NOT IN (SELECT DISTINCT subc_id FROM inp_subcatchment) THEN
        EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
        "data":{"message":"3194", "function":"2718","parameters":{"subc_id":"'||NEW.subc_id||'"}}}$$);';
      END IF;
    END IF;

    RETURN NULL;
  ELSE
    IF TG_OP = 'UPDATE' AND (OLD.lock_level = 1 AND NEW.lock_level = 1) THEN
      EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
      "data":{"message":"3284", "function":"2718","parameters":{"lock_level":'||NEW.lock_level||'}}}$$);';
      RETURN NULL;
    ELSIF TG_OP = 'DELETE' AND (OLD.lock_level = 2) THEN
      EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
      "data":{"message":"3284", "function":"2718","parameters":{"lock_level":'||OLD.lock_level||'}}}$$);';
      RETURN NULL;
    ELSIF TG_OP = 'UPDATE' AND (OLD.lock_level = 3 AND NEW.lock_level = 3) THEN
      EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
      "data":{"message":"3284", "function":"2718","parameters":{"lock_level":'||NEW.lock_level||'}}}$$);';
      RETURN NULL;
    ELSIF TG_OP = 'DELETE' AND (OLD.lock_level = 3) THEN
      EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
      "data":{"message":"3284", "function":"2718","parameters":{"lock_level":'||OLD.lock_level||'}}}$$);';
      RETURN NULL;
    END IF;
  END IF;

	IF TG_OP = 'DELETE' THEN
		RETURN OLD;
	ELSE
		RETURN NEW;
	END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
