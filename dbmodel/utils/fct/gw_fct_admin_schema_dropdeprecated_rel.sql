-- Function: aa1.gw_fct_admin_updateschema_drops()

-- DROP FUNCTION aa1.gw_fct_admin_updateschema_drops();

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_admin_schema_dropdeprecated_rel()
  RETURNS void AS
$BODY$


DECLARE
	v_schemaname text;
	v_tablerecord record;
	v_query_text text;
BEGIN
	-- search path
	SET search_path = "SCHEMA_NAME", public;
	v_schemaname = 'SCHEMA_NAME';

	-- Drop sequences
	FOR v_tablerecord IN SELECT * FROM audit_cat_table WHERE isdeprecated IS TRUE
	LOOP
		v_query_text:= 'DROP VIEW IF EXISTS '||v_tablerecord.id||';';
		EXECUTE v_query_text;
	END LOOP;

	-- Drop views and tables
	FOR v_tablerecord IN SELECT * FROM audit_cat_table WHERE isdeprecated IS TRUE
	LOOP
		IF v_tablerecord.id IN (SELECT tablename FROM information_schema.views WHERE table_schema=v_schemaname) THEN
			v_query_text:= 'DROP VIEW IF EXISTS '||v_tablerecord.id||';';
			EXECUTE v_query_text;
		ELSE
	
		v_query_text:= 'DROP TABLE IF EXISTS '||v_tablerecord.id||';';
		EXECUTE v_query_text;
		END IF;
	END LOOP;
	-- Drop functions
	FOR v_tablerecord IN SELECT * FROM audit_cat_function WHERE isdeprecated IS TRUE
	LOOP
		v_query_text:= 'DROP FUNCTION IF EXISTS '||v_tablerecord.id||';';
		EXECUTE v_query_text;
	END LOOP;
		
RETURN;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION SCHEMA_NAME.gw_fct_admin_updateschema_drops()
  OWNER TO postgres;
