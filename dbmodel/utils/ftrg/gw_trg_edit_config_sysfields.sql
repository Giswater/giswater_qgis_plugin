/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


--FUNCTION CODE: 2742

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_edit_config_sysfields()
  RETURNS trigger AS
$BODY$
DECLARE 


BEGIN

	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
	 
	UPDATE config_api_form_fields SET
	formname = NEW.formname,
	formtype = NEW.formtype,
	column_id = NEW.column_id,
	label = NEW.label,
	hidden = NEW.hidden,
	layoutname = NEW.layoutname,
	layout_order = NEW.layout_order,
	iseditable = NEW.iseditable,
	ismandatory = NEW.ismandatory,
	tooltip = NEW.tooltip,
	placeholder = NEW.placeholder,
	stylesheet = NEW.stylesheet,
	datatype = NEW.datatype,
	widgettype = NEW.widgettype,
	widgetdim = NEW.widgetdim,
	isparent = NEW.isparent,
	isautoupdate = NEW.isautoupdate,
	dv_querytext = NEW.dv_querytext,
	dv_orderby_id = NEW.dv_orderby_id,
	dv_isnullvalue = NEW.dv_isnullvalue,
	dv_parent_id = NEW.dv_parent_id,
	dv_querytext_filterc = NEW.dv_querytext_filterc,
	widgetcontrols = NEW.widgetcontrols,
	widgetfunction = NEW.widgetfunction,
	linkedaction = NEW.linkedaction	
	WHERE formname = OLD.formname AND column_id=OLD.column_id;

	RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


