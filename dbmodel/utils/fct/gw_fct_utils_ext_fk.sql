
--select SCHEMA_NAME.gw_fct_utils_ext_fk() 


CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_utils_ext_fk() RETURNS void AS
$BODY$
DECLARE

project_type_aux varchar;
ext_utils_schema_aux varchar;
query_aux text;
ws_current_schema_aux text;
ud_current_schema_aux text;

BEGIN
    -- Search path
    SET search_path = "SCHEMA_NAME", public;

    -- control of project type
    SELECT wsoftware INTO project_type_aux FROM version LIMIT 1;

    ext_utils_schema_aux = (SELECT value FROM config_param_system WHERE parameter='ext_utils_schema');

    IF ext_utils_schema_aux IS NOT NULL THEN
    	EXECUTE 'SELECT EXISTS (select * from pg_catalog.pg_namespace where nspname = '''||ext_utils_schema_aux||''');'
    	INTO query_aux;
    END IF;

	IF query_aux = 'true' THEN

		--DROP FK

		EXECUTE 'ALTER TABLE '|| ext_utils_schema_aux||'.streetaxis DROP CONSTRAINT IF EXISTS streetaxis_ws_exploitation_id_fkey;';
		EXECUTE 'ALTER TABLE '|| ext_utils_schema_aux||'.streetaxis DROP CONSTRAINT IF EXISTS streetaxis_ud_exploitation_id_fkey;';
		EXECUTE 'ALTER TABLE '|| ext_utils_schema_aux||'.streetaxis DROP CONSTRAINT IF EXISTS streetaxis_muni_id_fkey;';
		EXECUTE 'ALTER TABLE '|| ext_utils_schema_aux||'.streetaxis DROP CONSTRAINT IF EXISTS streetaxis_type_street_fkey;';
		

		EXECUTE 'ALTER TABLE '|| ext_utils_schema_aux||'.address DROP CONSTRAINT IF EXISTS address_ws_exploitation_id_fkey;';
		EXECUTE 'ALTER TABLE '|| ext_utils_schema_aux||'.address DROP CONSTRAINT IF EXISTS address_ud_exploitation_id_fkey;';
		EXECUTE 'ALTER TABLE '|| ext_utils_schema_aux||'.address DROP CONSTRAINT IF EXISTS address_muni_id_fkey;';
		EXECUTE 'ALTER TABLE '|| ext_utils_schema_aux||'.address DROP CONSTRAINT IF EXISTS address_streetaxis_id_fkey;';
		EXECUTE 'ALTER TABLE '|| ext_utils_schema_aux||'.address DROP CONSTRAINT IF EXISTS address_plot_id_fkey;';
		

		EXECUTE 'ALTER TABLE '|| ext_utils_schema_aux||'.plot DROP CONSTRAINT IF EXISTS plot_ws_exploitation_id_fkey;';
		EXECUTE 'ALTER TABLE '|| ext_utils_schema_aux||'.plot DROP CONSTRAINT IF EXISTS plot_ud_exploitation_id_fkey;';
		EXECUTE 'ALTER TABLE '|| ext_utils_schema_aux||'.plot DROP CONSTRAINT IF EXISTS plot_muni_id_fkey;';
		EXECUTE 'ALTER TABLE '|| ext_utils_schema_aux||'.plot DROP CONSTRAINT IF EXISTS plot_streetaxis_id_fkey;';


		ALTER TABLE node DROP CONSTRAINT IF EXISTS "node_muni_id_fkey"; 
		ALTER TABLE node DROP CONSTRAINT IF EXISTS "node_streetaxis_id_fkey"; 
		ALTER TABLE node DROP CONSTRAINT IF EXISTS "node_streetaxis2_id_fkey"; 
		ALTER TABLE arc DROP CONSTRAINT IF EXISTS "arc_muni_id_fkey"; 
		ALTER TABLE arc DROP CONSTRAINT IF EXISTS "arc_streetaxis_id_fkey"; 
		ALTER TABLE arc DROP CONSTRAINT IF EXISTS "arc_streetaxis2_id_fkey"; 
		ALTER TABLE connec DROP CONSTRAINT IF EXISTS "connec_muni_id_fkey"; 
		ALTER TABLE connec DROP CONSTRAINT IF EXISTS "connec_streetaxis_id_fkey"; 
		ALTER TABLE connec DROP CONSTRAINT IF EXISTS "connec_streetaxis2_id_fkey"; 
		ALTER TABLE samplepoint DROP CONSTRAINT IF EXISTS "samplepoint_streetaxis_id_fkey"; 
		ALTER TABLE samplepoint DROP CONSTRAINT IF EXISTS "samplepoint_streetaxis2_id_fkey"; 
		ALTER TABLE samplepoint DROP CONSTRAINT IF EXISTS "samplepoint_streetaxis_muni_id_fkey"; 

		--FOREIGN KEY ON UTILS

		EXECUTE 'ALTER TABLE '|| ext_utils_schema_aux||'.streetaxis ADD CONSTRAINT "streetaxis_muni_id_fkey" FOREIGN KEY ("muni_id") 
		REFERENCES '|| ext_utils_schema_aux||'."municipality" ("muni_id") ON DELETE RESTRICT ON UPDATE CASCADE;';
		EXECUTE 'ALTER TABLE '|| ext_utils_schema_aux||'.streetaxis ADD CONSTRAINT "streetaxis_type_street_fkey" FOREIGN KEY ("type") 
		REFERENCES '|| ext_utils_schema_aux||'."type_street" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;';


		EXECUTE 'ALTER TABLE '|| ext_utils_schema_aux||'.address ADD CONSTRAINT "address_muni_id_fkey" FOREIGN KEY ("muni_id") 
		REFERENCES '|| ext_utils_schema_aux||'."municipality" ("muni_id") ON DELETE RESTRICT ON UPDATE CASCADE;';
		EXECUTE 'ALTER TABLE '|| ext_utils_schema_aux||'.address ADD CONSTRAINT "address_streetaxis_id_fkey" FOREIGN KEY ("streetaxis_id") 
		REFERENCES '|| ext_utils_schema_aux||'."streetaxis" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;';
		EXECUTE 'ALTER TABLE '|| ext_utils_schema_aux||'.address ADD CONSTRAINT "address_plot_id_fkey" FOREIGN KEY ("plot_id") 
		REFERENCES '|| ext_utils_schema_aux||'."plot" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;';


		EXECUTE 'ALTER TABLE '|| ext_utils_schema_aux||'.plot ADD CONSTRAINT "plot_muni_id_fkey" FOREIGN KEY ("muni_id") 
		REFERENCES '|| ext_utils_schema_aux||'."municipality" ("muni_id") ON DELETE RESTRICT ON UPDATE CASCADE;';
		EXECUTE 'ALTER TABLE '|| ext_utils_schema_aux||'.plot ADD CONSTRAINT "plot_streetaxis_id_fkey" FOREIGN KEY ("streetaxis_id") 
		REFERENCES '|| ext_utils_schema_aux||'."streetaxis" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;';


		--DOUBLE EXPLOITATION FK

		EXECUTE 'SELECT value FROM '|| ext_utils_schema_aux ||'.config_param_system WHERE parameter=''ws_current_schema'';'
		INTO ws_current_schema_aux;

		IF ws_current_schema_aux is not null  THEN
			
			EXECUTE 'ALTER TABLE '|| ext_utils_schema_aux||'.streetaxis ADD CONSTRAINT "streetaxis_ws_exploitation_id_fkey" 
			FOREIGN KEY ("ws_expl_id") REFERENCES '|| ws_current_schema_aux||'."exploitation" ("expl_id") ON DELETE RESTRICT ON UPDATE CASCADE;';

			EXECUTE 'ALTER TABLE '|| ext_utils_schema_aux||'.address ADD CONSTRAINT "address_ws_exploitation_id_fkey" 
			FOREIGN KEY ("ws_expl_id") REFERENCES '|| ws_current_schema_aux||'."exploitation" ("expl_id") ON DELETE RESTRICT ON UPDATE CASCADE;';

			EXECUTE 'ALTER TABLE '|| ext_utils_schema_aux||'.plot ADD CONSTRAINT "plot_ws_exploitation_id_fkey" 
			FOREIGN KEY ("ws_expl_id") REFERENCES '|| ws_current_schema_aux||'."exploitation" ("expl_id") ON DELETE RESTRICT ON UPDATE CASCADE;';

		END IF;

		EXECUTE 'SELECT value FROM '|| ext_utils_schema_aux ||'.config_param_system WHERE parameter=''ud_current_schema'';'
		INTO ud_current_schema_aux;

		IF ud_current_schema_aux is not null THEN
			
			EXECUTE 'ALTER TABLE '|| ext_utils_schema_aux||'.streetaxis ADD CONSTRAINT "streetaxis_ud_exploitation_id_fkey" 
			FOREIGN KEY ("ud_expl_id") REFERENCES '|| ud_current_schema_aux||'."exploitation" ("expl_id") ON DELETE RESTRICT ON UPDATE CASCADE;';

			EXECUTE 'ALTER TABLE '|| ext_utils_schema_aux||'.address ADD CONSTRAINT "address_ud_exploitation_id_fkey" 
			FOREIGN KEY ("ud_expl_id") REFERENCES '|| ud_current_schema_aux||'."exploitation" ("expl_id") ON DELETE RESTRICT ON UPDATE CASCADE;';

			EXECUTE 'ALTER TABLE '|| ext_utils_schema_aux||'.plot ADD CONSTRAINT "plot_ud_exploitation_id_fkey" 
			FOREIGN KEY ("ud_expl_id") REFERENCES '|| ud_current_schema_aux||'."exploitation" ("expl_id") ON DELETE RESTRICT ON UPDATE CASCADE;';
			
		END IF;

		--FOREIGN KEY
		
			EXECUTE 'ALTER TABLE node ADD CONSTRAINT "node_muni_id_fkey" FOREIGN KEY ("muni_id") 
			REFERENCES '|| ext_utils_schema_aux||'."municipality" ("muni_id") ON DELETE RESTRICT ON UPDATE CASCADE;';
			
			EXECUTE 'ALTER TABLE node ADD CONSTRAINT "node_streetaxis_id_fkey" FOREIGN KEY ("streetaxis_id") 
			REFERENCES '|| ext_utils_schema_aux||'."streetaxis" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;';
			
			EXECUTE 'ALTER TABLE node ADD CONSTRAINT "node_streetaxis2_id_fkey" FOREIGN KEY ("streetaxis2_id") 
			REFERENCES '|| ext_utils_schema_aux||'."streetaxis" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;';
			

			EXECUTE 'ALTER TABLE arc ADD CONSTRAINT "arc_muni_id_fkey" FOREIGN KEY ("muni_id") 
			REFERENCES '|| ext_utils_schema_aux||'."municipality" ("muni_id") ON DELETE RESTRICT ON UPDATE CASCADE;';
			
			EXECUTE 'ALTER TABLE arc ADD CONSTRAINT "arc_streetaxis_id_fkey" FOREIGN KEY ("streetaxis_id") 
			REFERENCES '|| ext_utils_schema_aux||'."streetaxis" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;';
			
			EXECUTE 'ALTER TABLE arc ADD CONSTRAINT "arc_streetaxis2_id_fkey" FOREIGN KEY ("streetaxis2_id") 
			REFERENCES '|| ext_utils_schema_aux||'."streetaxis" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;';
			

			EXECUTE 'ALTER TABLE connec ADD CONSTRAINT "connec_muni_id_fkey" FOREIGN KEY ("muni_id") 
			REFERENCES '|| ext_utils_schema_aux||'."municipality" ("muni_id") ON DELETE RESTRICT ON UPDATE CASCADE;';
			
			EXECUTE 'ALTER TABLE connec ADD CONSTRAINT "connec_streetaxis_id_fkey" FOREIGN KEY ("streetaxis_id") 
			REFERENCES '|| ext_utils_schema_aux||'."streetaxis" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;';
			
			EXECUTE 'ALTER TABLE connec ADD CONSTRAINT "connec_streetaxis2_id_fkey" FOREIGN KEY ("streetaxis2_id") 
			REFERENCES '|| ext_utils_schema_aux||'."streetaxis" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;';
			

			EXECUTE 'ALTER TABLE samplepoint ADD CONSTRAINT "samplepoint_streetaxis_id_fkey" FOREIGN KEY ("streetaxis_id") 
			REFERENCES '|| ext_utils_schema_aux||'."streetaxis" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;';
			
			EXECUTE 'ALTER TABLE samplepoint ADD CONSTRAINT "samplepoint_streetaxis2_id_fkey" FOREIGN KEY ("streetaxis2_id") 
			REFERENCES '|| ext_utils_schema_aux||'."streetaxis" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;';
			
			EXECUTE 'ALTER TABLE samplepoint ADD CONSTRAINT "samplepoint_streetaxis_muni_id_fkey" FOREIGN KEY ("muni_id") 
			REFERENCES '|| ext_utils_schema_aux||'."municipality" ("muni_id") ON DELETE RESTRICT ON UPDATE CASCADE;';
			
		
		IF project_type_aux='UD' THEN


			ALTER TABLE gully DROP CONSTRAINT IF EXISTS "gully_muni_id_fkey"; 
			ALTER TABLE gully DROP CONSTRAINT IF EXISTS "gully_streetaxis_id_fkey"; 
			ALTER TABLE gully DROP CONSTRAINT IF EXISTS "gully_streetaxis2_id_fkey"; 

			EXECUTE 'ALTER TABLE gully ADD CONSTRAINT "gully_muni_id_fkey" FOREIGN KEY ("muni_id") 
			REFERENCES '|| ext_utils_schema_aux||'."municipality" ("muni_id") ON DELETE RESTRICT ON UPDATE CASCADE;';

			EXECUTE 'ALTER TABLE gully ADD CONSTRAINT "gully_streetaxis_id_fkey" FOREIGN KEY ("streetaxis_id") 
			REFERENCES '|| ext_utils_schema_aux||'."streetaxis" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;';

			EXECUTE 'ALTER TABLE gully ADD CONSTRAINT "gully_streetaxis2_id_fkey" FOREIGN KEY ("streetaxis2_id") 
			REFERENCES '|| ext_utils_schema_aux||'."streetaxis" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;';
			
		END IF;

	ELSE


		--DROP FK

		ALTER TABLE node DROP CONSTRAINT IF EXISTS "node_muni_id_fkey"; 
		ALTER TABLE node DROP CONSTRAINT IF EXISTS "node_streetaxis_id_fkey"; 
		ALTER TABLE node DROP CONSTRAINT IF EXISTS "node_streetaxis2_id_fkey"; 
		ALTER TABLE arc DROP CONSTRAINT IF EXISTS "arc_muni_id_fkey"; 
		ALTER TABLE arc DROP CONSTRAINT IF EXISTS "arc_streetaxis_id_fkey"; 
		ALTER TABLE arc DROP CONSTRAINT IF EXISTS "arc_streetaxis2_id_fkey"; 
		ALTER TABLE connec DROP CONSTRAINT IF EXISTS "connec_muni_id_fkey"; 
		ALTER TABLE connec DROP CONSTRAINT IF EXISTS "connec_streetaxis_id_fkey"; 
		ALTER TABLE connec DROP CONSTRAINT IF EXISTS "connec_streetaxis2_id_fkey"; 
		ALTER TABLE samplepoint DROP CONSTRAINT IF EXISTS "samplepoint_streetaxis_id_fkey"; 
		ALTER TABLE samplepoint DROP CONSTRAINT IF EXISTS "samplepoint_streetaxis2_id_fkey"; 
		ALTER TABLE samplepoint DROP CONSTRAINT IF EXISTS "samplepoint_streetaxis_muni_id_fkey"; 

		--ADD FK

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
			ALTER TABLE gully DROP CONSTRAINT IF EXISTS "gully_muni_id_fkey"; 
			ALTER TABLE gully DROP CONSTRAINT IF EXISTS "gully_streetaxis_id_fkey"; 
			ALTER TABLE gully DROP CONSTRAINT IF EXISTS "gully_streetaxis2_id_fkey"; 

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
