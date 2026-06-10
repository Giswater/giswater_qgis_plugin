/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

UPDATE config_form_fields SET dv_querytext = replace(dv_querytext, 'vf_exploitation', 've_exploitation')
WHERE dv_querytext ILIKE '%vf_exploitation%' AND dv_querytext_filterc ilike '%macroexpl_id%';
