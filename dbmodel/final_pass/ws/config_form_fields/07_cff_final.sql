/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;


UPDATE config_form_fields SET iseditable = false where formname ilike 've_node_%' and columnname = 'state';
UPDATE config_form_fields SET iseditable = false where formname ilike 've_arc_%' and columnname = 'state';
UPDATE config_form_fields SET iseditable = false where formname ilike 've_connec_%' and columnname = 'state';
UPDATE config_form_fields SET iseditable = false where formname ilike 've_link_%' and columnname = 'state';

UPDATE config_form_fields SET hidden = TRUE WHERE formname = 've_node_pump' AND columnname = 'expl_visibility';

UPDATE config_form_fields SET layoutorder = 14 WHERE formname = 've_element' AND columnname = 'rotation';
UPDATE config_form_fields SET layoutorder = 15 WHERE formname = 've_element' AND columnname = 'model_id';

UPDATE config_form_fields SET dv_querytext='SELECT function_type as id, function_type as idval FROM man_type_function WHERE ((featurecat_id is null OR ''ELEMENT''=ANY(feature_type))) AND active IS TRUE' WHERE formname='ve_element' AND formtype='form_feature' AND columnname='function_type' AND tabname='tab_data';
UPDATE config_form_fields SET dv_querytext='SELECT function_type as id, function_type as idval FROM man_type_function WHERE ((featurecat_id is null OR ''ARC''=ANY(feature_type)) ) AND active IS TRUE' WHERE formname='ve_arc' AND formtype='form_feature' AND columnname='function_type' AND tabname='tab_data';
UPDATE config_form_fields SET dv_querytext='SELECT function_type as id, function_type as idval FROM man_type_function WHERE ((featurecat_id is null OR ''CONNEC''=ANY(feature_type)) ) AND active IS TRUE' WHERE formname='ve_connec' AND formtype='form_feature' AND columnname='function_type' AND tabname='tab_data';
UPDATE config_form_fields SET dv_querytext='SELECT function_type as id, function_type as idval FROM man_type_function WHERE ((featurecat_id is null OR ''NODE''=ANY(feature_type)) ) AND active IS TRUE' WHERE formname='ve_node' AND formtype='form_feature' AND columnname='function_type' AND tabname='tab_data';

UPDATE config_form_fields SET dv_querytext='SELECT category_type as id, category_type as idval FROM man_type_category WHERE ((featurecat_id is null OR ''ARC''=ANY(feature_type))) AND active IS TRUE ' WHERE formname='ve_arc' AND formtype='form_feature' AND columnname='category_type' AND tabname='tab_data';
UPDATE config_form_fields SET dv_querytext='SELECT category_type as id, category_type as idval FROM man_type_category WHERE ((featurecat_id is null OR ''CONNEC''=ANY(feature_type))) AND active IS TRUE ' WHERE formname='ve_connec' AND formtype='form_feature' AND columnname='category_type' AND tabname='tab_data';
UPDATE config_form_fields SET dv_querytext='SELECT category_type as id, category_type as idval FROM man_type_category WHERE ((featurecat_id is null OR ''ELEMENT''=ANY(feature_type))) AND active IS TRUE' WHERE formname='ve_element' AND formtype='form_feature' AND columnname='category_type' AND tabname='tab_data';
UPDATE config_form_fields SET dv_querytext='SELECT category_type as id, category_type as idval FROM man_type_category WHERE ((featurecat_id is null OR ''NODE''=ANY(feature_type))) AND active IS TRUE ' WHERE formname='ve_node' AND formtype='form_feature' AND columnname='category_type' AND tabname='tab_data';

UPDATE config_form_fields SET dv_querytext='SELECT location_type as id, location_type as idval FROM man_type_location WHERE ((featurecat_id is null OR ''ARC''=ANY(feature_type))) AND active IS TRUE ' WHERE formname='ve_arc' AND formtype='form_feature' AND columnname='location_type' AND tabname='tab_data';
UPDATE config_form_fields SET dv_querytext='SELECT location_type as id, location_type as idval FROM man_type_location WHERE ((featurecat_id is null OR ''CONNEC''=ANY(feature_type))) AND active IS TRUE ' WHERE formname='ve_connec' AND formtype='form_feature' AND columnname='location_type' AND tabname='tab_data';
UPDATE config_form_fields SET dv_querytext='SELECT location_type as id, location_type as idval FROM man_type_location WHERE ((featurecat_id is null OR ''ELEMENT''=ANY(feature_type))) AND active IS TRUE' WHERE formname='ve_element' AND formtype='form_feature' AND columnname='location_type' AND tabname='tab_data';
UPDATE config_form_fields SET dv_querytext='SELECT location_type as id, location_type as idval FROM man_type_location WHERE ((featurecat_id is null OR ''NODE''=ANY(feature_type))) AND active IS TRUE ' WHERE formname='ve_node' AND formtype='form_feature' AND columnname='location_type' AND tabname='tab_data';


ALTER TABLE config_form_fields ENABLE TRIGGER gw_trg_config_control;
