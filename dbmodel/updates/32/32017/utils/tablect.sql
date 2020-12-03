/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


ALTER TABLE _om_psector_selector_ DROP CONSTRAINT IF EXISTS om_psector_selector_psector_id_fkey;
ALTER TABLE _om_psector_x_arc_ DROP CONSTRAINT IF EXISTS om_psector_x_arc_psector_id_fkey;
ALTER TABLE _om_psector_x_node_ DROP CONSTRAINT IF EXISTS om_psector_x_node_psector_id_fkey;
ALTER TABLE _om_psector_x_other_ DROP CONSTRAINT IF EXISTS om_psector_x_other_psector_id_fkey;

ALTER TABLE man_addfields_parameter DROP CONSTRAINT IF EXISTS man_addfields_parameter_datetype_id_fkey;
ALTER TABLE man_addfields_parameter DROP CONSTRAINT IF EXISTS man_addfields_parameter_widgettype_id_fkey;
