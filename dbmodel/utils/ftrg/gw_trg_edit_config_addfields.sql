/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


--FUNCTION CODE: 2808

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_edit_config_addfields()
  RETURNS trigger AS
$BODY$
DECLARE 


BEGIN

	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

	-- config_form_fields table
	UPDATE config_form_fields SET 
	datatype = NEW.datatype,
	widgettype = NEW.widgettype,
	widgetdim = NEW.widgetdim,
	label = NEW.label,
	layoutname = NEW.layoutname,
	layout_order = NEW.layout_order,
	tooltip = NEW.tooltip,
	placeholder = NEW.placeholder,
	ismandatory = NEW.ismandatory,
	isparent = NEW.isparent,
	iseditable = NEW.iseditable,
	isautoupdate = NEW.isautoupdate,
	dv_querytext = NEW.dv_querytext,
	dv_orderby_id = NEW.dv_orderby_id,
	dv_isnullvalue = NEW.dv_isnullvalue,
	dv_parent_id = NEW.dv_parent_id,
	dv_querytext_filterc = NEW.dv_querytext_filterc,
	widgetfunction = NEW.widgetfunction,
	linkedaction = NEW.linkedaction,
	stylesheet = NEW.stylesheet,
	widgetcontrols = NEW.widgetcontrols,
	formname = NEW.formname
	WHERE formname = OLD.formname AND column_id=OLD.column_id;

	-- config_addfields_parameter table
	UPDATE config_addfields_parameter SET
	num_decimals = NEW.num_decimals,
	field_length = NEW.field_length,
	orderby = NEW.addfield_order,
	active = NEW.addfield_active
	WHERE param_id=OLD.param_id AND cat_feature_id=OLD.cat_feature_id;
		
    RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


