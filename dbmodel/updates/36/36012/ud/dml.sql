/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

UPDATE sys_fprocess SET project_type = 'ud' where fid = 522;


UPDATE config_form_tabs
    SET orderby=1
    WHERE formname='v_edit_connec' AND tabname='tab_elements';

UPDATE config_form_tabs
    SET orderby=2
    WHERE formname='v_edit_connec' AND tabname='tab_hydrometer';

UPDATE config_form_tabs
    SET orderby=3
    WHERE formname='v_edit_connec' AND tabname='tab_hydrometer_val';

UPDATE config_form_tabs
    SET orderby=2
    WHERE formname='v_edit_node' AND tabname='tab_connections';

UPDATE config_form_tabs
    SET orderby=3
    WHERE formname='v_edit_gully' AND tabname='tab_documents';

UPDATE config_form_tabs
    SET orderby=4
    WHERE formname='v_edit_gully' AND tabname='tab_epa';

UPDATE config_form_tabs
    SET orderby=5
    WHERE formname='v_edit_gully' AND tabname='tab_event';
