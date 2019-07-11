/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 1250

SET search_path= "SCHEMA_NAME", public, pg_catalog;

DROP FUNCTION IF EXISTS gw_trg_man_addfields_value_control() CASCADE;
CREATE OR REPLACE FUNCTION gw_trg_man_addfields_value_control()
  RETURNS trigger AS
$BODY$
DECLARE 
v_featuretype varchar;
v_featurenew varchar;
v_featureold varchar;
v_tablename varchar;
v_fieldname varchar;
    
BEGIN
    
    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

    v_featuretype:= TG_ARGV[0];
    v_tablename:= TG_ARGV[1];
	v_fieldname:= TG_ARGV[2];

    IF TG_OP ='UPDATE' THEN
	
		IF v_featuretype='NODE' THEN
			v_featurenew:= NEW.node_id;
			v_featureold:= OLD.node_id;	
		ELSIF v_featuretype='ARC' THEN
			v_featurenew:= NEW.arc_id;
			v_featureold:= OLD.arc_id;
		ELSIF v_featuretype='CONNEC' THEN
			v_featurenew:= NEW.connec_id;
			v_featureold:= OLD.connec_id;
		ELSIF v_featuretype='GULLY' THEN
			v_featurenew:= NEW.gully_id;
			v_featureold:= OLD.gully_id;
		END IF;

		EXECUTE 'UPDATE '||quote_ident(v_tablename)||' SET '||quote_ident(v_fieldname)||' = '||quote_literal(v_featureold)
				||'  WHERE '||quote_ident(v_fieldname)||' = '||quote_literal(v_featureold);

    ELSIF TG_OP ='DELETE' THEN

    	IF v_featuretype='NODE' THEN
			v_featureold:= OLD.node_id;	
		ELSIF v_featuretype='ARC' THEN
			v_featureold:= OLD.arc_id;
		ELSIF v_featuretype='CONNEC' THEN
			v_featureold:= OLD.connec_id;
		ELSIF v_featuretype='GULLY' THEN
			v_featureold:= OLD.gully_id;
		END IF;
    
		EXECUTE ' DELETE FROM '||quote_ident(v_tablename)||' WHERE '||quote_ident(v_fieldname)||' = '||quote_literal(v_featureold);	

    END IF;

RETURN NEW;

END; 
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;




  
