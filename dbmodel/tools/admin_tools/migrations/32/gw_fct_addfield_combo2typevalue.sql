
--select SCHEMA_NAME.gw_fct_addfield_combo2typevalue();
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_addfield_combo2typevalue()
  RETURNS void AS
$BODY$
DECLARE 
	v_typevalue text;
	v_formname text;
	rec record;
	v_query text;
	rec_child record;
BEGIN

	SET search_path=SCHEMA_NAME, public;

	--insert values from man_addfields_cat_combo into edit_typevalue
	INSERT INTO edit_typevalue( typevalue, id, idval, descript)
	SELECT CASE WHEN cat_feature_id IS NOT NULL THEN lower(concat(param_name,'_',cat_feature_id))
	ELSE lower(param_name) END,
	man_addfields_cat_combo.value,man_addfields_cat_combo.value, man_addfields_cat_combo.descript
	FROM sys_addfields JOIN man_addfields_cat_combo ON sys_addfields.id = man_addfields_cat_combo.parameter_id;
	
	--create fk config
	INSERT INTO typevalue_fk( typevalue_table, typevalue_name, target_table, target_field, parameter_id)
	SELECT DISTINCT 'edit_typevalue',CASE WHEN cat_feature_id IS NOT NULL THEN lower(concat(param_name,'_',cat_feature_id))
	ELSE lower(param_name) END, 'man_addfields_value', 'value_param', parameter_id 
	FROM sys_addfields JOIN man_addfields_cat_combo ON sys_addfields.id = man_addfields_cat_combo.parameter_id;

	--modify querytext in config_api_form_fields and audit_cat_param_user
	FOR rec IN SELECT * FROM sys_addfields WHERE id IN (SELECT parameter_id FROM man_addfields_cat_combo) LOOP
		IF rec.cat_feature_id IS NOT NULL THEN
			v_typevalue = lower(concat(rec.param_name,'_',rec.cat_feature_id));
		ELSE
			v_typevalue = lower(rec.param_name);
		END IF;

		v_query ='SELECT id, idval FROM edit_typevalue WHERE typevalue='''''||v_typevalue||'''''';
		EXECUTE 'UPDATE audit_cat_param_user SET dv_querytext = '''||v_query||''' WHERE formname = ''config'' AND id = '''||v_typevalue||'_vdefault'';';

		IF rec.cat_feature_id IS NOT NULL THEN
			EXECUTE 'SELECT child_layer FROM cat_feature WHERE id = '''||rec.cat_feature_id||''';'
			INTO v_formname;
		
			EXECUTE 'UPDATE config_api_form_fields SET dv_querytext = '''||v_query||''' WHERE formname = '''||v_formname||''' AND formtype = ''feature'' AND
			column_id = '''||rec.param_name||''';';
		ELSE

			EXECUTE 'UPDATE config_api_form_fields SET dv_querytext = '''||v_query||''' WHERE  formtype = ''feature'' AND
			column_id = '''||rec.param_name||''' AND formname IN (SELECT child_layer FROM cat_feature);';

		END IF;
		
	END LOOP;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;