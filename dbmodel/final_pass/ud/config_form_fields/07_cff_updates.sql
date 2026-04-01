/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;

UPDATE config_form_fields SET dv_querytext = replace(dv_querytext, 'v_ext_municipality', 've_municipality') WHERE dv_querytext LIKE '%v_ext_municipality%';
UPDATE config_form_fields SET dv_querytext = replace(dv_querytext, 'v_ext_streetaxis', 've_streetaxis') WHERE dv_querytext LIKE '%v_ext_streetaxis%';
UPDATE config_form_fields SET dv_querytext = replace(dv_querytext, 'ext_municipality', 'v_municipality') WHERE dv_querytext LIKE '%ext_municipality%';
UPDATE config_form_fields SET dv_querytext = replace(dv_querytext, 'ext_streetaxis', 'v_streetaxis') WHERE dv_querytext LIKE '%ext_streetaxis%';
UPDATE config_form_fields SET dv_querytext = replace(dv_querytext, 'ext_address', 'v_address') WHERE dv_querytext LIKE '%ext_address%';
UPDATE config_form_fields SET dv_querytext = replace(dv_querytext, 'ext_region', 'v_region') WHERE dv_querytext LIKE '%ext_region%';
UPDATE config_form_fields SET dv_querytext = replace(dv_querytext, 'ext_province', 'v_province') WHERE dv_querytext LIKE '%ext_province%';
UPDATE config_form_fields SET dv_querytext = replace(dv_querytext, 'ext_district', 'v_district') WHERE dv_querytext LIKE '%ext_district%';
