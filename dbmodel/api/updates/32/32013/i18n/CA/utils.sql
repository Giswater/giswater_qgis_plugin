
/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

UPDATE config_api_form_tabs SET tabtext = 'Llista de documents' WHERE formname ilike 'v_edit_%' AND tabname = 'tab_documents';
UPDATE config_api_form_tabs SET tabtext = 'Llista de abonats' WHERE formname ilike 'v_edit_%' AND tabname = 'tab_hydrometer';
UPDATE config_api_form_tabs SET tabtext = 'Llista de eventos de l''element' WHERE formname ilike 'v_edit_%' AND tabname = 'tab_visit';
UPDATE config_api_form_tabs SET tabtext = 'Llista de eventos de l''element' WHERE formname ilike 'v_edit_%' AND tabname = 'tab_om';
UPDATE config_api_form_tabs SET tabtext = 'Valors de consum per abonat' WHERE formname ilike 'v_edit_%' AND tabname = 'tab_hydrometer_val';
UPDATE config_api_form_tabs SET tabtext = 'Partides de l''element' WHERE formname ilike 'v_edit_%' AND tabname = 'tab_plan';
UPDATE config_api_form_tabs SET tabtext = 'Llista d''elements relacionats' WHERE formname ilike 'v_edit_%' AND tabname = 'tab_elements';