/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

INSERT INTO audit_cat_param_user VALUES ('inp_options_dwfscenario', 'epaoptions', 'Variable to manage diferent scenarios for dry weather flows', 'role_epa', NULL, NULL, 'DWF scenario:', 'SELECT id, idval FROM cat_dwf_scenario WHERE id IS not null',
NULL, true, 9, 1, 'ud', false, NULL, NULL, NULL, false, 'string', 'combo', true, NULL, '1', 'grl_crm_9', NULL, NULL, NULL, NULL, NULL, NULL, false, '{"from":"5.0.022", "to":null,"language":"english"}');

UPDATE audit_cat_param_user SET layout_order=2 WHERE id='inp_options_rtc_period_id';
