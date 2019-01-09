-- Function: SCHEMA_NAME.gw_fct_utils_csv2pg_import_temp_data(integer, text)

-- DROP FUNCTION SCHEMA_NAME.gw_fct_utils_csv2pg_import_temp_data(integer, text);

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_utils_csv2pg_import_temp_data(
    csv2pgcat_id_aux integer,
    path_aux text)
  RETURNS integer AS
$BODY$
	DECLARE


	rec_column record;
	

	BEGIN

	--  Search path
		SET search_path = "SCHEMA_NAME", public;
			DELETE FROM temp_csv2pg WHERE csv2pgcat_id=csv2pgcat_id_aux AND user_name=current_user;

			EXECUTE 'COPY temp_csv2pg(csv1) FROM '''||path_aux||''' WITH (FORMAT text);';
			
			
			update temp_csv2pg set csv2pgcat_id=csv2pgcat_id_aux,csv1=split_part(trim(regexp_replace(csv1, '\s+', ' ', 'g')),' ',1),
			csv2=split_part(trim(regexp_replace(csv1, '\s+', ' ', 'g')),' ',2),csv3=split_part(trim(regexp_replace(csv1, '\s+', ' ', 'g')),' ',3),
			csv4=split_part(trim(regexp_replace(csv1, '\s+', ' ', 'g')),' ',4),csv5=split_part(trim(regexp_replace(csv1, '\s+', ' ', 'g')),' ',5),
			csv6=split_part(trim(regexp_replace(csv1, '\s+', ' ', 'g')),' ',6),csv7=split_part(trim(regexp_replace(csv1, '\s+', ' ', 'g')),' ',7),
			csv8=split_part(trim(regexp_replace(csv1, '\s+', ' ', 'g')),' ',8),csv9=split_part(trim(regexp_replace(csv1, '\s+', ' ', 'g')),' ',9),
			csv10=split_part(trim(regexp_replace(csv1, '\s+', ' ', 'g')),' ',10),csv11=split_part(trim(regexp_replace(csv1, '\s+', ' ', 'g')),' ',11),
			csv12=split_part(trim(regexp_replace(csv1, '\s+', ' ', 'g')),' ',12),csv13=split_part(trim(regexp_replace(csv1, '\s+', ' ', 'g')),' ',13),
			csv14=split_part(trim(regexp_replace(csv1, '\s+', ' ', 'g')),' ',14),csv15=split_part(trim(regexp_replace(csv1, '\s+', ' ', 'g')),' ',15),
			csv16=split_part(trim(regexp_replace(csv1, '\s+', ' ', 'g')),' ',16),csv17=split_part(trim(regexp_replace(csv1, '\s+', ' ', 'g')),' ',17),
			csv18=split_part(trim(regexp_replace(csv1, '\s+', ' ', 'g')),' ',18),csv19=split_part(trim(regexp_replace(csv1, '\s+', ' ', 'g')),' ',19),
			csv20=split_part(trim(regexp_replace(csv1, '\s+', ' ', 'g')),' ',20) WHERE csv2pgcat_id is null AND user_name=current_user;

			DELETE FROM temp_csv2pg WHERE csv1 ilike '-------%';
			DELETE FROM temp_csv2pg WHERE csv1 ilike '*%';
			FOR rec_column IN SELECT column_name FROM information_schema.columns WHERE table_schema = 'SCHEMA_NAME' AND table_name = 'temp_csv2pg' and (column_name ilike 'csv_' or column_name ilike 'csv__')
			LOOP
				EXECUTE 'UPDATE temp_csv2pg SET '||rec_column.column_name||'= NULL WHERE '||rec_column.column_name||'='''';';
				
			END LOOP;


	RETURN 0;
		
		
	END;
	$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION SCHEMA_NAME.gw_fct_utils_csv2pg_import_temp_data(integer, text)
  OWNER TO postgres;
