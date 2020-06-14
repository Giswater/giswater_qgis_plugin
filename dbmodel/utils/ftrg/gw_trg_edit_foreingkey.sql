/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2718

SET search_path= "SCHEMA_NAME", public, pg_catalog;

DROP FUNCTION IF EXISTS gw_trg_edit_foreignkey() CASCADE;
CREATE OR REPLACE FUNCTION gw_trg_edit_foreignkey()
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

	-- get project type
	SELECT project_type INTO v_projecttype FROM sys_version LIMIT 1;
	
    IF TG_OP ='UPDATE' THEN
	
		IF v_featurefield='node_id' THEN
			v_featurenew:= NEW.node_id;
			v_featureold:= OLD.node_id;	
		ELSIF v_featurefield='arc_id' THEN
			v_featurenew:= NEW.arc_id;
			v_featureold:= OLD.arc_id;
		ELSIF v_featurefield='connec_id' THEN
			v_featurenew:= NEW.connec_id;
			v_featureold:= OLD.connec_id;
		ELSIF v_featurefield='gully_id' THEN
			v_featurenew:= NEW.gully_id;
			v_featureold:= OLD.gully_id;
		END IF;
		

		-- man_addfields_value
    	UPDATE man_addfields_value SET feature_id=v_featurenew  WHERE feature_id=v_featureold;

		
    ELSIF TG_OP ='DELETE' THEN

    	IF v_featurefield='NODE' THEN
			v_featureold:= OLD.node_id;	
		ELSIF v_featurefield='ARC' THEN
			v_featureold:= OLD.arc_id;
		ELSIF v_featurefield='CONNEC' THEN
			v_featureold:= OLD.connec_id;
		ELSIF v_featurefield='GULLY' THEN
			v_featureold:= OLD.gully_id;
		END IF;
    
		DELETE FROM man_addfields_value WHERE feature_id=v_featureold;			

    END IF;

RETURN NEW;

END; 
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;




  
