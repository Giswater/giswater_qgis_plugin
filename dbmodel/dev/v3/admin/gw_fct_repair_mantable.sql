/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_repair_man_table(p_data json)
RETURNS json AS
$BODY$

/*
 SELECT  SCHEMA_NAME.gw_fct_repair_man_table('{}')
*/

DECLARE
v_record record;
v_rows integer;
v_querytext text;

BEGIN

	SET search_path = SCHEMA_NAME, public;
	
	FOR v_record IN SELECT * FROM cat_feature where feature_type in ('ARC', 'NODE')
	LOOP
		v_querytext = 'INSERT INTO man_'||lower(v_record.system_id)||' SELECT '||lower(v_record.feature_type)||'_id FROM '||lower(v_record.feature_type)||
		' JOIN cat_'||lower(v_record.feature_type)||' ON '||lower(v_record.feature_type)||'cat_id = id WHERE '||lower(v_record.feature_type)||
		'type_id = '''||v_record.id||''' ON CONFLICT ('||lower(v_record.feature_type)||'_id) DO NOTHING';
		
		execute v_querytext;
	
		get diagnostics v_rows = ROW_COUNT;

		raise notice ' % - %', v_record.id, v_rows;
		
	END LOOP;
	
	FOR v_record IN SELECT * FROM cat_feature where feature_type in ('CONNEC')
	LOOP
		v_querytext = 'INSERT INTO man_'||lower(v_record.system_id)||' SELECT '||lower(v_record.feature_type)||'_id FROM '||lower(v_record.feature_type)||
		' JOIN cat_'||lower(v_record.feature_type)||' ON '||lower(v_record.feature_type)||'at_id = id WHERE '||lower(v_record.feature_type)||
		'type_id = '''||v_record.id||''' ON CONFLICT ('||lower(v_record.feature_type)||'_id) DO NOTHING';
	
		execute v_querytext;
	
		get diagnostics v_rows = ROW_COUNT;
		
		raise notice ' % - %', v_record.id, v_rows;
		
	END LOOP;

	return '{}';

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;