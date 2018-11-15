/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "crm", public, pg_catalog;


  
  -- ----------------------------
-- CRM MANAGEMENT
-- ----------------------------
 
--ROLE CREATION
CREATE ROLE role_crm NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION;
GRANT ALL ON DATABASE "gis" TO "role_crm" ;
GRANT ALL ON SCHEMA "crm" TO "role_crm";
GRANT ALL ON SCHEMA "crm" TO "role_basic";


-- ROLE PERMISSIONS
GRANT ALL ON ALL TABLES IN SCHEMA "crm" TO "role_crm";
GRANT ALL ON ALL SEQUENCES IN SCHEMA "crm" TO "role_crm";
GRANT ALL ON ALL FUNCTIONS IN SCHEMA "crm" TO "role_crm";


-- ROLE PERMISSIONS
GRANT SELECT ON ALL TABLES IN SCHEMA crm TO role_basic;

  



