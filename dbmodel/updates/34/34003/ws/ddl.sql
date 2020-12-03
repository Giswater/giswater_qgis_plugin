/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_pump_importinp", "column":"to_arc", "dataType":"character varying(16)", "isUtils":"False"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"temp_go2epa", "column":"idmin", "dataType":"integer", "isUtils":"False"}}$$);

COMMENT ON VIEW v_ui_hydroval_x_connec IS 'This view can be modified by user, but connec_id, hydrometer_id and cat_period_id must remain in the definition without alias in order to use filters in QGIS. If you need to hide or use alias for these fields use config_client_forms';
