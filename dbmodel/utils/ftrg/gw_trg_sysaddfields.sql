/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

-- FUNCTION CODE: 3138


CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_sysaddfields() RETURNS trigger AS $BODY$
DECLARE 
    
BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
    IF NEW.active IS FALSE THEN
        IF NEW.cat_feature_id IS NULL THEN
            EXECUTE 'SELECT gw_fct_admin_manage_addfields($${
            "client":{"lang":"ES"}, 
            "feature":{"catFeature":"HYDRANT"},
            "data":{"action":"DEACTIVATE", "multiCreate":"true", "parameters":{"columnname":"'||NEW.param_name||'", "istrg":"true"}}}$$)';

        ELSE
            EXECUTE 'SELECT gw_fct_admin_manage_addfields($${
            "client":{"lang":"ES"}, 
            "feature":{"catFeature":"'||NEW.cat_feature_id||'"},
            "data":{"action":"DEACTIVATE", "multiCreate":"false", "parameters":{"columnname":"'||NEW.param_name||'", "istrg":"true"}}}$$)';
        END IF;
    ELSIF  NEW.active IS TRUE THEN
        IF NEW.cat_feature_id IS NULL THEN
            EXECUTE 'SELECT gw_fct_admin_manage_addfields($${
            "client":{"lang":"ES"}, 
            "feature":{"catFeature":"HYDRANT"},
            "data":{"action":"ACTIVATE", "multiCreate":"true", "parameters":{"columnname":"'||NEW.param_name||'", "istrg":"true"}}}$$)';

        ELSE
            EXECUTE 'SELECT gw_fct_admin_manage_addfields($${
            "client":{"lang":"ES"}, 
            "feature":{"catFeature":"'||NEW.cat_feature_id||'"},
            "data":{"action":"ACTIVATE", "multiCreate":"false", "parameters":{"columnname":"'||NEW.param_name||'", "istrg":"true"}}}$$)';
        END IF;
    END IF;
    RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
