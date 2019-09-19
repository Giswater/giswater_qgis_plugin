/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


--FUNCTION CODE: 2742

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_edit_config_sys_fields()
  RETURNS trigger AS
$BODY$
DECLARE 


BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

    UPDATE config_api_form_fields SET label = NEW.label, widgetcontrols = NEW.widgetcontrols,
    isenabled = NEW.isenabled, iseditable = NEW.iseditable, ismandatory = NEW.ismandatory, 
    tooltip = NEW.tooltip, widgetdim = NEW.widgetdim, placeholder = NEW.placeholder, 
    editability = NEW.editability, stylesheet = NEW.stylesheet, hidden = NEW.hidden
    WHERE formname = OLD.formname AND column_id=OLD.column_id;

    RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


