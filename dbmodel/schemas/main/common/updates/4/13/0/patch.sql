/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- include start in the message
UPDATE sys_message
SET error_message='There are no arcs without start/final nodes.'
WHERE id=3582;

UPDATE sys_message
SET error_message='There are %v_count_state1% arcs with state 1 without start/final nodes.'
WHERE id=3586;

UPDATE sys_message
SET error_message='There are %v_count_state2% arcs with state 2 without start/final nodes.'
WHERE id=3588;

DO $$ 

DECLARE
rec record;

BEGIN

    FOR rec IN SELECT lower(id) as id FROM sys_feature_type --arc/node/connec/link/etc
    LOOP

    EXECUTE format('ALTER TABLE %s ADD COLUMN IF NOT EXISTS dataquality INTEGER', rec.id);
    EXECUTE format('ALTER TABLE %s ADD COLUMN IF NOT EXISTS dataquality_obs _int4 DEFAULT ARRAY[0]', rec.id);

    END LOOP;

END $$;


INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) 
SELECT child_layer, 'form_feature', 'tab_data', 'dataquality', 'lyt_data_1', 56, 'integer', 'text', 'Dataquality', 'To indicate the number of closing-opening turns when operating the valve.', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL 
FROM cat_feature ON CONFLICT DO NOTHING;

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) 
SELECT child_layer, 'form_feature', 'tab_data', 'dataquality_obs', 'lyt_data_1', 58, 'text', 'text', 'Dataquality_obs', 'Observations supporting the assigned utility survey quality level.', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL 
FROM cat_feature ON CONFLICT DO NOTHING;
