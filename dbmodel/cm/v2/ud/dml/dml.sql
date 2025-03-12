/*
Copyright © 2023 by BGEO. All rights reserved.
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


INSERT INTO sys_table VALUES ('om_visit_lot_x_gully', 'Table of gullys related to lots', 'role_om', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table VALUES ('ve_lot_x_gully', 'View that relates gullys and lots', 'role_om', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table VALUES ('ve_lot_x_gully_web', 'View to publish gullies related to lots on web', 'role_om', 0) ON CONFLICT (id) DO NOTHING;

UPDATE config_web_forms SET query_text='SELECT visit_id AS sys_id, visit_start AS "Date", config_visit_class.idval AS "Visit class", om_visit.user_name AS "Visit user"
FROM v_ui_om_visitman_x_gully
JOIN om_visit ON om_visit.id=v_ui_om_visitman_x_gully.visit_id
JOIN config_visit_class ON config_visit_class.id=om_visit.class_id' WHERE query_text='SELECT visit_id AS sys_id, visitcat_name, visit_start, visit_end, user_name FROM v_ui_om_visitman_x_gully'
AND table_id='gully_x_visit_manager';

INSERT INTO config_form_tabs VALUES ('v_edit_gully', 'tab_visit', 'Visit', 'List of visits', 'role_basic', NULL, NULL, 4) ON CONFLICT (formname, tabname, device) DO NOTHING;
