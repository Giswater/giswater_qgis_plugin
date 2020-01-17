/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2020/01/17

UPDATE config_api_form_fields SET label='Municipality' WHERE formname='search' and column_id='add_muni';
UPDATE config_api_form_fields SET label='Number' WHERE formname='search' and column_id='add_postnumber';
UPDATE config_api_form_fields SET label='Street' WHERE formname='search' and column_id='add_street';
UPDATE config_api_form_fields SET label='Search' WHERE formname='search' and column_id='generic_search';
UPDATE config_api_form_fields SET label='Exploitation' WHERE formname='search' and column_id='hydro_expl';
UPDATE config_api_form_fields SET label='Customer' WHERE formname='search' and column_id='hydro_search';
UPDATE config_api_form_fields SET label='Code' WHERE formname='search' and column_id='net_code';
UPDATE config_api_form_fields SET label='Type' WHERE formname='search' and column_id='net_type';
UPDATE config_api_form_fields SET label='Exploitation' WHERE formname='search' and column_id='psector_expl';
UPDATE config_api_form_fields SET label='Visit' WHERE formname='search' and column_id='visit_search';
UPDATE config_api_form_fields SET label='Work' WHERE formname='search' and column_id='workcat_search';