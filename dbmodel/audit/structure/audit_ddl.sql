/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

CREATE SCHEMA audit;

CREATE TABLE audit.log (
    id serial8 PRIMARY KEY,
    tstamp timestamp default now(),
    table_name text,
    id_name text,
    feature_id text,
    action text,
    query text,
    query_sql text NULL,
    olddata json,
    newdata json,
    user_name text,
    schema text
);
