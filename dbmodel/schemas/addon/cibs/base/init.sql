/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET ROLE role_system;

CREATE SCHEMA IF NOT EXISTS cibs AUTHORIZATION role_system;

GRANT ALL ON SCHEMA cibs TO role_system;
GRANT ALL ON SCHEMA cibs TO role_basic;
ALTER DEFAULT PRIVILEGES IN SCHEMA cibs GRANT SELECT ON TABLES TO role_basic;
