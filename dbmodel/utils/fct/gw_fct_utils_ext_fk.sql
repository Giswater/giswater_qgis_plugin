
--select SCHEMA_NAME.gw_fct_utils_ext_fk() 


CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_utils_ext_fk() RETURNS void AS
$BODY$
DECLARE

project_type_aux varchar;
ext_utils_schema_aux varchar;
query_aux text;
alter_query_aux text;

BEGIN
    -- Search path
    SET search_path = "SCHEMA_NAME", public;

    -- control of project type
    SELECT wsoftware INTO project_type_aux FROM version LIMIT 1;

    ext_utils_schema_aux = (SELECT value FROM config_param_system WHERE parameter='ext_utils_schema');

    query_aux='(select * from pg_catalog.pg_namespace where nspname = '''||ext_utils_schema_aux||''');';

	IF query_aux IS NOT NULL THEN

		--LOCAL search_path = 'testschema'
		alter_query_aux:='ALTER TABLE '|| ext_utils_schema_aux||'.ext_streetaxis DROP CONSTRAINT IF EXISTS ext_streetaxis_exploitation_id_fkey;';
		EXECUTE alter_query_aux;
		alter_query_aux:='ALTER TABLE '|| ext_utils_schema_aux||'.ext_streetaxis DROP CONSTRAINT IF EXISTS ext_streetaxis_muni_id_fkey;';
		EXECUTE alter_query_aux;
		alter_query_aux:='ALTER TABLE '|| ext_utils_schema_aux||'.ext_streetaxis DROP CONSTRAINT IF EXISTS ext_streetaxis_type_street_fkey;';
		EXECUTE alter_query_aux;



		alter_query_aux:='ALTER TABLE '|| ext_utils_schema_aux||'.ext_address DROP CONSTRAINT IF EXISTS ext_address_exploitation_id_fkey;';
		EXECUTE alter_query_aux;
		alter_query_aux:='ALTER TABLE '|| ext_utils_schema_aux||'.ext_address DROP CONSTRAINT IF EXISTS ext_address_muni_id_fkey;';
		EXECUTE alter_query_aux;
		alter_query_aux:='ALTER TABLE '|| ext_utils_schema_aux||'.ext_address DROP CONSTRAINT IF EXISTS ext_address_streetaxis_id_fkey;';
		EXECUTE alter_query_aux;
		alter_query_aux:='ALTER TABLE '|| ext_utils_schema_aux||'.ext_address DROP CONSTRAINT IF EXISTS ext_address_plot_id_fkey;';
		EXECUTE alter_query_aux;


		alter_query_aux:='ALTER TABLE '|| ext_utils_schema_aux||'.ext_plot DROP CONSTRAINT IF EXISTS ext_plot_exploitation_id_fkey;';
		EXECUTE alter_query_aux;
		alter_query_aux:='ALTER TABLE '|| ext_utils_schema_aux||'.ext_plot DROP CONSTRAINT IF EXISTS ext_plot_muni_id_fkey;';
		EXECUTE alter_query_aux;
		alter_query_aux:='ALTER TABLE '|| ext_utils_schema_aux||'.ext_plot DROP CONSTRAINT IF EXISTS ext_plot_streetaxis_id_fkey;';
		EXECUTE alter_query_aux;

		--FOREIGN KEY ON UTILS
		--ALTER TABLE ext_utils_schema_aux."ext_streetaxis" ADD CONSTRAINT "ext_streetaxis_exploitation_id_fkey" FOREIGN KEY ("expl_id") 
		--REFERENCES '|| ext_utils_schema_aux||'."exploitation" ("expl_id") ON DELETE RESTRICT ON UPDATE CASCADE;
		
		alter_query_aux:='ALTER TABLE '|| ext_utils_schema_aux||'.ext_streetaxis ADD CONSTRAINT "ext_streetaxis_muni_id_fkey" FOREIGN KEY ("muni_id") 
		REFERENCES '|| ext_utils_schema_aux||'."ext_municipality" ("muni_id") ON DELETE RESTRICT ON UPDATE CASCADE;';
		EXECUTE alter_query_aux;

		alter_query_aux:='ALTER TABLE '|| ext_utils_schema_aux||'.ext_streetaxis ADD CONSTRAINT "ext_streetaxis_type_street_fkey" FOREIGN KEY ("type") 
		REFERENCES '|| ext_utils_schema_aux||'."ext_type_street" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;';
		EXECUTE alter_query_aux;


		--ALTER TABLE ext_utils_schema_aux."ext_address" ADD CONSTRAINT "ext_address_exploitation_id_fkey" FOREIGN KEY ("expl_id") 
		--REFERENCES '|| ext_utils_schema_aux||'."exploitation" ("expl_id") ON DELETE RESTRICT ON UPDATE CASCADE;
		
		alter_query_aux:='ALTER TABLE '|| ext_utils_schema_aux||'.ext_address ADD CONSTRAINT "ext_address_muni_id_fkey" FOREIGN KEY ("muni_id") 
		REFERENCES '|| ext_utils_schema_aux||'."ext_municipality" ("muni_id") ON DELETE RESTRICT ON UPDATE CASCADE;';
		EXECUTE alter_query_aux;
		alter_query_aux:='ALTER TABLE '|| ext_utils_schema_aux||'.ext_address ADD CONSTRAINT "ext_address_streetaxis_id_fkey" FOREIGN KEY ("streetaxis_id") 
		REFERENCES '|| ext_utils_schema_aux||'."ext_streetaxis" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;';
		EXECUTE alter_query_aux;
		alter_query_aux:='ALTER TABLE '|| ext_utils_schema_aux||'.ext_address ADD CONSTRAINT "ext_address_plot_id_fkey" FOREIGN KEY ("plot_id") 
		REFERENCES '|| ext_utils_schema_aux||'."ext_plot" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;';
		EXECUTE alter_query_aux;


		--ALTER TABLE ext_utils_schema_aux."ext_plot" ADD CONSTRAINT "ext_plot_exploitation_id_fkey" FOREIGN KEY ("expl_id") 
		--REFERENCES '|| ext_utils_schema_aux||'."exploitation" ("expl_id") ON DELETE RESTRICT ON UPDATE CASCADE;
		alter_query_aux:='ALTER TABLE '|| ext_utils_schema_aux||'.ext_plot ADD CONSTRAINT "ext_plot_muni_id_fkey" FOREIGN KEY ("muni_id") 
		REFERENCES '|| ext_utils_schema_aux||'."ext_municipality" ("muni_id") ON DELETE RESTRICT ON UPDATE CASCADE;';
		EXECUTE alter_query_aux;
		alter_query_aux:='ALTER TABLE '|| ext_utils_schema_aux||'.ext_plot ADD CONSTRAINT "ext_plot_streetaxis_id_fkey" FOREIGN KEY ("streetaxis_id") 
		REFERENCES '|| ext_utils_schema_aux||'."ext_streetaxis" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;';
		EXECUTE alter_query_aux;

		--FOREIGN KEY
		
		alter_query_aux:='ALTER TABLE node ADD CONSTRAINT "node_muni_id_fkey" FOREIGN KEY ("muni_id") 
		REFERENCES '|| ext_utils_schema_aux||'."ext_municipality" ("muni_id") ON DELETE RESTRICT ON UPDATE CASCADE;';
		EXECUTE alter_query_aux;
		alter_query_aux:='ALTER TABLE node ADD CONSTRAINT "node_streetaxis_id_fkey" FOREIGN KEY ("streetaxis_id") 
		REFERENCES '|| ext_utils_schema_aux||'."ext_streetaxis" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;';
		EXECUTE alter_query_aux;
		alter_query_aux:='ALTER TABLE node ADD CONSTRAINT "node_streetaxis2_id_fkey" FOREIGN KEY ("streetaxis2_id") 
		REFERENCES '|| ext_utils_schema_aux||'."ext_streetaxis" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;';
		EXECUTE alter_query_aux;

		alter_query_aux:='ALTER TABLE arc ADD CONSTRAINT "arc_muni_id_fkey" FOREIGN KEY ("muni_id") 
		REFERENCES '|| ext_utils_schema_aux||'."ext_municipality" ("muni_id") ON DELETE RESTRICT ON UPDATE CASCADE;';
		EXECUTE alter_query_aux;
		alter_query_aux:='ALTER TABLE arc ADD CONSTRAINT "arc_streetaxis_id_fkey" FOREIGN KEY ("streetaxis_id") 
		REFERENCES '|| ext_utils_schema_aux||'."ext_streetaxis" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;';
		EXECUTE alter_query_aux;
		alter_query_aux:='ALTER TABLE arc ADD CONSTRAINT "arc_streetaxis2_id_fkey" FOREIGN KEY ("streetaxis2_id") 
		REFERENCES '|| ext_utils_schema_aux||'."ext_streetaxis" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;';
		EXECUTE alter_query_aux;

		alter_query_aux:='ALTER TABLE connec ADD CONSTRAINT "connec_muni_id_fkey" FOREIGN KEY ("muni_id") 
		REFERENCES '|| ext_utils_schema_aux||'."ext_municipality" ("muni_id") ON DELETE RESTRICT ON UPDATE CASCADE;';
		EXECUTE alter_query_aux;
		alter_query_aux:='ALTER TABLE connec ADD CONSTRAINT "connec_streetaxis_id_fkey" FOREIGN KEY ("streetaxis_id") 
		REFERENCES '|| ext_utils_schema_aux||'."ext_streetaxis" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;';
		EXECUTE alter_query_aux;
		alter_query_aux:='ALTER TABLE connec ADD CONSTRAINT "connec_streetaxis2_id_fkey" FOREIGN KEY ("streetaxis2_id") 
		REFERENCES '|| ext_utils_schema_aux||'."ext_streetaxis" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;';
		EXECUTE alter_query_aux;

		alter_query_aux:='ALTER TABLE samplepoint ADD CONSTRAINT "samplepoint_streetaxis_id_fkey" FOREIGN KEY ("streetaxis_id") 
		REFERENCES '|| ext_utils_schema_aux||'."ext_streetaxis" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;';
		EXECUTE alter_query_aux;
		alter_query_aux:='ALTER TABLE samplepoint ADD CONSTRAINT "samplepoint_streetaxis2_id_fkey" FOREIGN KEY ("streetaxis2_id") 
		REFERENCES '|| ext_utils_schema_aux||'."ext_streetaxis" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;';
		EXECUTE alter_query_aux;
		alter_query_aux:='ALTER TABLE samplepoint ADD CONSTRAINT "samplepoint_streetaxis_muni_id_fkey" FOREIGN KEY ("muni_id") 
		REFERENCES '|| ext_utils_schema_aux||'."ext_municipality" ("muni_id") ON DELETE RESTRICT ON UPDATE CASCADE;';
		EXECUTE alter_query_aux;
		
		IF project_type_aux='UD' THEN
			alter_query_aux:='ALTER TABLE gully ADD CONSTRAINT "gully_muni_id_fkey" FOREIGN KEY ("muni_id") 
			REFERENCES '|| ext_utils_schema_aux||'."ext_municipality" ("muni_id") ON DELETE RESTRICT ON UPDATE CASCADE;';
			EXECUTE alter_query_aux;
			alter_query_aux:='ALTER TABLE gully ADD CONSTRAINT "gully_streetaxis_id_fkey" FOREIGN KEY ("streetaxis_id") 
			REFERENCES '|| ext_utils_schema_aux||'."ext_streetaxis" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;';
			EXECUTE alter_query_aux;
			alter_query_aux:='ALTER TABLE gully ADD CONSTRAINT "gully_streetaxis2_id_fkey" FOREIGN KEY ("streetaxis2_id") 
			REFERENCES '|| ext_utils_schema_aux||'."ext_streetaxis" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;';
			EXECUTE alter_query_aux;
		END IF;

	ELSE


		ALTER TABLE "node" ADD CONSTRAINT "node_muni_id_fkey" FOREIGN KEY ("muni_id") 
		REFERENCES "ext_municipality" ("muni_id") ON DELETE RESTRICT ON UPDATE CASCADE;
		ALTER TABLE "node" ADD CONSTRAINT "node_streetaxis_id_fkey" FOREIGN KEY ("streetaxis_id") 
		REFERENCES "ext_streetaxis" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
		ALTER TABLE "node" ADD CONSTRAINT "node_streetaxis2_id_fkey" FOREIGN KEY ("streetaxis2_id") 
		REFERENCES "ext_streetaxis" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

		ALTER TABLE "arc" ADD CONSTRAINT "arc_muni_id_fkey" FOREIGN KEY ("muni_id") 
		REFERENCES "ext_municipality" ("muni_id") ON DELETE RESTRICT ON UPDATE CASCADE;
		ALTER TABLE "arc" ADD CONSTRAINT "arc_streetaxis_id_fkey" FOREIGN KEY ("streetaxis_id") 
		REFERENCES "ext_streetaxis" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
		ALTER TABLE "arc" ADD CONSTRAINT "arc_streetaxis2_id_fkey" FOREIGN KEY ("streetaxis2_id") 
		REFERENCES "ext_streetaxis" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

		ALTER TABLE "connec" ADD CONSTRAINT "connec_muni_id_fkey" FOREIGN KEY ("muni_id") 
		REFERENCES "ext_municipality" ("muni_id") ON DELETE RESTRICT ON UPDATE CASCADE;
		ALTER TABLE "connec" ADD CONSTRAINT "connec_streetaxis_id_fkey" FOREIGN KEY ("streetaxis_id") 
		REFERENCES "ext_streetaxis" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
		ALTER TABLE "connec" ADD CONSTRAINT "connec_streetaxis2_id_fkey" FOREIGN KEY ("streetaxis2_id") 
		REFERENCES "ext_streetaxis" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

		ALTER TABLE "samplepoint" ADD CONSTRAINT "samplepoint_streetaxis_id_fkey" FOREIGN KEY ("streetaxis_id") 
		REFERENCES "ext_streetaxis" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
		ALTER TABLE "samplepoint" ADD CONSTRAINT "samplepoint_streetaxis2_id_fkey" FOREIGN KEY ("streetaxis2_id") 
		REFERENCES "ext_streetaxis" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
		ALTER TABLE "samplepoint" ADD CONSTRAINT "samplepoint_streetaxis_muni_id_fkey" FOREIGN KEY ("muni_id") 
		REFERENCES "ext_municipality" ("muni_id") ON DELETE RESTRICT ON UPDATE CASCADE;

		IF project_type_aux='UD' THEN
			ALTER TABLE "gully" ADD CONSTRAINT "gully_muni_id_fkey" FOREIGN KEY ("muni_id") 
			REFERENCES "ext_municipality" ("muni_id") ON DELETE RESTRICT ON UPDATE CASCADE;
			ALTER TABLE "gully" ADD CONSTRAINT "gully_streetaxis_id_fkey" FOREIGN KEY ("streetaxis_id") 
			REFERENCES "ext_streetaxis" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
			ALTER TABLE "gully" ADD CONSTRAINT "gully_streetaxis2_id_fkey" FOREIGN KEY ("streetaxis2_id") 
			REFERENCES "ext_streetaxis" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
		END IF;
	END IF;



END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
