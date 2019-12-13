/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--12/12/2019
UPDATE config_api_form_fields SET widgettype='typeahead',
typeahead='{"fieldToSearch": "id", "threshold": 3, "noresultsMsg": "No results", "loadingMsg": "Searching"}'
WHERE column_id in ('nodecat_id', 'arccat_id', 'connecat_id');


UPDATE config_api_form_fields SET isparent=TRUE WHERE column_id='node_type' AND formtype='feature';
UPDATE config_api_form_fields SET iseditable=FALSE WHERE column_id='node_type' AND formtype='feature';
UPDATE config_api_form_fields SET dv_parent_id='node_type', dv_querytext_filterc=' AND cat_node.node_type IS NULL OR cat_node.node_type=' WHERE column_id='nodecat_id' AND formtype='feature';

UPDATE config_api_form_fields SET isparent=TRUE WHERE column_id='arc_type' AND formtype='feature';
UPDATE config_api_form_fields SET iseditable=FALSE WHERE column_id='arc_type' AND formtype='feature';
UPDATE config_api_form_fields SET dv_parent_id='arc_type', dv_querytext_filterc=' AND cat_arc.arc_type IS NULL OR cat_arc.arc_type=' WHERE column_id='arccat_id' AND formtype='feature';

UPDATE config_api_form_fields SET isparent=TRUE WHERE column_id='connec_type' AND formtype='feature';
UPDATE config_api_form_fields SET iseditable=FALSE WHERE column_id='connec_type' AND formtype='feature';
UPDATE config_api_form_fields SET dv_parent_id='connec_type', dv_querytext_filterc=' AND cat_connec.connec_type IS NULL OR cat_connec.connec_type=' WHERE column_id='connecat_id' AND formtype='feature';

UPDATE config_api_form_fields SET isparent=TRUE WHERE column_id='gully_type' AND formtype='feature';
UPDATE config_api_form_fields SET iseditable=FALSE WHERE column_id='gully_type' AND formtype='feature';
UPDATE config_api_form_fields SET dv_parent_id='gully_type', dv_querytext_filterc=' AND cat_grate.gully_type IS NULL OR cat_grate.gully_type=' WHERE column_id='gratecat_id' AND formtype='feature';
