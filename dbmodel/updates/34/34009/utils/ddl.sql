/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2020/05/09
ALTER TABLE sys_csv2pg_config RENAME TO config_csv_param;
ALTER TABLE sys_fprocess_cat RENAME TO sys_fprocess;
ALTER TABLE sys_typevalue_cat RENAME TO sys_typevalue;
ALTER TABLE sys_csv2pg_cat RENAME TO config_csv;
ALTER TABLE audit_cat_function RENAME TO sys_function;


CREATE TABLE config_toolbox (
id integer PRIMARY KEY,
alias text,
isparametric boolean,
functionparams json,
inputparams json,
observ text
);


INSERT INTO config_toolbox
SELECT id, alias, isparametric, input_params::json, return_type::json, context FROM sys_function WHERE istoolbox IS TRUE;


SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"sys_function", "column":"istoolbox"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"sys_function", "column":"isparametric"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"sys_function", "column":"context"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"sys_function", "column":"alias"}}$$);
