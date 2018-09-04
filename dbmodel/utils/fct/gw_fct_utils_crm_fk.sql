
/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/



--DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_utils_crm_fk();

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_utils_crm_fk() RETURNS void AS
$BODY$
DECLARE

crm_schema_aux varchar;
query_aux text;
project_type_aux varchar;

BEGIN
    -- Search path
    SET search_path = "SCHEMA_NAME", public;


    -- control of project type
    SELECT wsoftware INTO project_type_aux FROM version LIMIT 1;

    crm_schema_aux = (SELECT value FROM config_param_system WHERE parameter='crm_utils_schema');

    IF crm_schema_aux IS NOT NULL THEN
    	EXECUTE 'SELECT EXISTS (select * from pg_catalog.pg_namespace where nspname = '''||crm_schema_aux||''');'
    	INTO query_aux;
    END IF;


    IF  project_type_aux='WS' THEN

	    IF query_aux = 'true'  THEN
	    --DROP FK
	    EXECUTE 'ALTER TABLE inp_options DROP CONSTRAINT IF EXISTS inp_options_period_id_fkey;';
	    EXECUTE 'ALTER TABLE '|| crm_schema_aux||'.hydrometer_x_data DROP CONSTRAINT IF EXISTS hydrometer_x_data_hydrometer_id_fkey;';

	    --ADD FK
	    EXECUTE 'ALTER TABLE inp_options ADD CONSTRAINT "inp_options_period_id_fkey" FOREIGN KEY ("rtc_period_id") 
		REFERENCES '|| crm_schema_aux||'."hydro_cat_period" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;';

		EXECUTE 'ALTER TABLE '|| crm_schema_aux||'."hydrometer_x_data" ADD CONSTRAINT "hydrometer_x_data_hydrometer_id_fkey" 
	    FOREIGN KEY ("hydrometer_id") REFERENCES '|| crm_schema_aux||'."hydrometer" ("id") ON DELETE CASCADE ON UPDATE CASCADE;';
	    ELSE

	    --DROP FK
	    ALTER TABLE "inp_options" DROP CONSTRAINT IF EXISTS "inp_options_period_id_fkey";
		ALTER TABLE "ext_rtc_hydrometer_x_data" DROP CONSTRAINT IF EXISTS "ext_rtc_hydrometer_x_data_hydrometer_id_fkey";

	    --ADD FK
	    ALTER TABLE "inp_options" ADD CONSTRAINT "inp_options_period_id_fkey" 
	    FOREIGN KEY ("rtc_period_id") REFERENCES "ext_cat_period" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

	    ALTER TABLE "ext_hydrometer_x_data" ADD CONSTRAINT "ext_rtc_hydrometer_x_data_hydrometer_id_fkey" 
	    FOREIGN KEY ("hydrometer_id") REFERENCES "ext_rtc_hydrometer" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

	    END IF;
	END IF;

END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
