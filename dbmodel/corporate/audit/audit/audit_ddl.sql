/*
Copyright © 2023 by BGEO. All rights reserved.
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/



CREATE SCHEMA audit;


CREATE TABLE audit.log (
id serial8 PRIMARY KEY,
schema text, 
table_name text,
id_name text,
user_name text,
action text,
olddata json,
newdata json,
query text,
tstamp timestamp default now()
);
