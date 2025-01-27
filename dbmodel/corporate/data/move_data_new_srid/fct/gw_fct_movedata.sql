/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_movedata()
 RETURNS integer
 LANGUAGE plpgsql
AS $function$
DECLARE
mytables RECORD;
v_column_array text;
BEGIN
  FOR mytables IN SELECT distinct table_name FROM information_schema.tables t
join pg_class c on t.table_name=c.relname 
WHERE t.table_schema='SCHEMA_NAME' and table_type='BASE TABLE' and table_name not in ('temp_table','audit_psector_connec_traceability','ext_raster_dem', 'ext_district', 'ext_municipality', 'ext_region_x_province', 'ext_rtc_hydrometer', 'om_mincut')
  LOOP
		IF mytables.table_name IN (SELECT distinct c.table_name FROM information_schema.columns c
		join information_schema.tables t on t.table_name=c.table_name and t.table_schema='SCHEMA_NAME'
		WHERE udt_name='geometry' and column_name='the_geom' and c.table_schema='SCHEMA_NAME' and table_type='BASE TABLE') THEN
			
			-- get the string_agg of every column for tables with geomery. Use ST_transform to replace with the new srid
			select replace(string_agg(column_name,','), 'the_geom', 'ST_transform(the_geom, SRID_VALUE)') into v_column_array from 
			(select column_name from information_schema.columns c
			join information_schema.tables t on t.table_name=c.table_name and t.table_schema='SCHEMA_NAME'
			WHERE c.table_schema='SCHEMA_NAME' and table_type='BASE TABLE' and c.table_name=mytables.table_name order by c.ordinal_position)a;

			raise notice 'Geom table --> %', mytables.table_name;
      		EXECUTE 'INSERT INTO SCHEMA_NAME.' || mytables.table_name || ' SELECT '|| v_column_array ||' FROM OLD_SCHEMA_NAME.' || mytables.table_name || '';
		ELSE
			raise notice 'Non geom table --> %', mytables.table_name;
			EXECUTE 'INSERT INTO SCHEMA_NAME.' || mytables.table_name || ' SELECT * FROM OLD_SCHEMA_NAME.' || mytables.table_name || '';
		END IF;
  END LOOP;
  
  -- set new epsg
  UPDATE sys_version SET epsg=SRID_VALUE;

  RETURN 1;

END;
$function$
;


