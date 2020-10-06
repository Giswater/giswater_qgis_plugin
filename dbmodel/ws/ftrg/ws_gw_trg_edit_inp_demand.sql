/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 1308


CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_inp_demand() RETURNS trigger LANGUAGE plpgsql AS $$
DECLARE 

    node_table varchar;
    man_table varchar;
    epa_type varchar;
    v_sql varchar;
    old_nodetype varchar;
    new_nodetype varchar;    
	
BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
   
	-- Control insertions ID
	IF TG_OP = 'INSERT' THEN

		-- overwrite id values (in case of user fill something)
		PERFORM setval('SCHEMA_NAME.inp_demand_id_seq',(SELECT max(id) FROM inp_demand), true);
		NEW.id=nextval('SCHEMA_NAME.inp_demand_id_seq'::regclass);
	
		INSERT INTO inp_demand (id, feature_id, demand, pattern_id, demand_type, dscenario_id, feature_type) 
		VALUES (NEW.id,NEW.feature_id, NEW.demand, NEW.pattern_id, NEW.demand_type, NEW.dscenario_id, NEW.feature_type);
		RETURN NEW;

	ELSIF TG_OP = 'UPDATE' THEN
		UPDATE inp_demand SET id=NEW.id, feature_id=NEW.feature_id, demand=NEW.demand, pattern_id=NEW.pattern_id, 
		demand_type=NEW.demand_type, dscenario_id=NEW.dscenario_id,  feature_type=NEW.feature_type
		WHERE id=OLD.id;
		RETURN NEW;
        
	ELSIF TG_OP = 'DELETE' THEN
		DELETE FROM inp_demand WHERE id=OLD.id;
		RETURN OLD;
   
	END IF;
       
END;
$$;
  