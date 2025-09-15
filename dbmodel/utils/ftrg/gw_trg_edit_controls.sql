/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 2718


DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_trg_edit_controls() CASCADE;
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_edit_controls()
  RETURNS trigger AS
$BODY$
DECLARE
v_featurefield varchar;
v_mapzone_id_value_old integer;
v_mapzone_id_value_new integer;
v_featurenew varchar;
v_featureold varchar;
v_projecttype text;
v_count integer;

v_disable_locklevel json;
v_automatic_disable_locklevel json;

BEGIN

  EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

  v_featurefield:= TG_ARGV[0];

  -- Get user variable for disabling lock level
  SELECT value::json INTO v_disable_locklevel FROM config_param_user
  WHERE parameter = 'edit_disable_locklevel' AND cur_user = current_user;

  -- Check if automatic disable is enabled in system config
  SELECT value::json INTO v_automatic_disable_locklevel FROM config_param_system
  WHERE parameter = 'edit_automatic_disable_locklevel';

  IF v_featurefield = 'inp_subcatchment' THEN
    IF TG_OP = 'UPDATE' THEN
      IF NEW.subc_id != OLD.subc_id THEN
        UPDATE inp_dscenario_lid_usage SET subc_id=NEW.subc_id WHERE subc_id=OLD.subc_id;
        RETURN NEW;
      END IF;
    ELSIF TG_OP = 'DELETE' THEN
      DELETE FROM inp_dscenario_lid_usage WHERE subc_id=OLD.subc_id;
      RETURN NULL;
    END IF;

  ELSIF v_featurefield = 'inp_dscenario_lid_usage' THEN
    IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' THEN

      IF NEW.subc_id NOT IN (SELECT DISTINCT subc_id FROM inp_subcatchment) THEN
        EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
        "data":{"message":"3194", "function":"2718","parameters":{"subc_id":"'||NEW.subc_id||'"}}}$$);';
      END IF;
    END IF;

    RETURN NULL;
  ELSE
    -- Protect system records with id 0 or -1 from deletion on mapzones
    IF v_featurefield IN ('expl_id', 'dwfzone_id', 'drainzone_id', 'sector_id', 'presszone_id', 'dqa_id', 
    'supplyzone_id', 'omzone_id', 'macrosector_id', 'macroomzone_id', 'macrodqa_id', 'macrodma_id', 'macroexpl_id') THEN
      EXECUTE format('SELECT ($1).%I', v_featurefield) INTO v_mapzone_id_value_old USING OLD;
      EXECUTE format('SELECT ($1).%I', v_featurefield) INTO v_mapzone_id_value_new USING NEW;
      IF TG_OP = 'DELETE' AND v_mapzone_id_value_old = -1 THEN
        EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
        "data":{"message":"4356", "function":"2718","parameters":{"id": '||v_mapzone_id_value_old||'}}}$$);';
        RETURN NULL;
      ELSIF TG_OP = 'UPDATE' AND (
        (v_mapzone_id_value_old = 0 AND v_mapzone_id_value_new <> 0) OR 
        (v_mapzone_id_value_old = -1 AND v_mapzone_id_value_new <> -1)
      ) THEN
        -- Do nothing it cannot be updated
        RETURN NULL; 
      END IF;
    END IF;

    -- Lock level control behavior based on system and user variables:
    --
    -- CASE 1: Both system and user variables disabled
    -- v_automatic_disable_locklevel = {"update":false,"delete":false}
    -- v_disable_locklevel = {"update":false, "delete":false}
    -- RESULT: Lock level control IS applied (most restrictive)
    --
    -- CASE 2: System variable disabled, user variable enabled
    -- v_automatic_disable_locklevel = {"update":false,"delete":false}
    -- v_disable_locklevel = {"update":true, "delete":true}
    -- RESULT: Lock level control is NOT applied (user override)
    --
    -- CASE 3: System variable enabled (regardless of user variable)
    -- v_automatic_disable_locklevel = {"update":true,"delete":true}
    -- v_disable_locklevel = {"update":false, "delete":true}
    -- RESULT: Lock level control is NOT applied (system override)

    IF v_automatic_disable_locklevel->>'update' = 'false' AND (v_disable_locklevel->>'update' = 'false' OR v_disable_locklevel IS NULL) THEN
      IF TG_OP = 'UPDATE' AND (OLD.lock_level = 1 AND NEW.lock_level = 1) THEN
        EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
        "data":{"message":"3284", "function":"2718","parameters":{"lock_level":'||NEW.lock_level||'}}}$$);';
        RETURN NULL;
      ELSEIF TG_OP = 'UPDATE' AND (OLD.lock_level = 3 AND NEW.lock_level = 3) THEN
        EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
        "data":{"message":"3284", "function":"2718","parameters":{"lock_level":'||NEW.lock_level||'}}}$$);';
        RETURN NULL;
      END IF;
    END IF;

    IF v_automatic_disable_locklevel->>'delete' = 'false' AND (v_disable_locklevel->>'delete' = 'false' OR v_disable_locklevel IS NULL) THEN
      IF TG_OP = 'DELETE' AND (OLD.lock_level = 2) THEN
        EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
        "data":{"message":"3284", "function":"2718","parameters":{"lock_level":'||OLD.lock_level||'}}}$$);';
        RETURN NULL;
      ELSEIF TG_OP = 'DELETE' AND (OLD.lock_level = 3) THEN
        EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
        "data":{"message":"3284", "function":"2718","parameters":{"lock_level":'||OLD.lock_level||'}}}$$);';
        RETURN NULL;
      END IF;
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
