/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2019/12/23
UPDATE config_api_form_fields SET isreload=TRUE, isautoupdate=TRUE WHERE column_id IN ('y1', 'y2', 'custom_y1', 'custom_y2', 'elev1', 'elev2', 'custom_elev1', 'custom_elev2') AND formname LIKE 've_arc%';
UPDATE config_api_form_fields SET isreload=TRUE, isautoupdate=TRUE WHERE column_id IN ('top_elev','custom_top_elev', 'ymax', 'custom_ymax', 'elev', 'custom_elev') AND formname LIKE 've_node%';

UPDATE SCHEMA_NAME.config_api_form_fields SET iseditable=false where column_id='gully_id' AND formname LIKE 've_gully%';