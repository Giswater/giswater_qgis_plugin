/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


--rol_admin
GRANT ALL ON DATABASE "DB_NAME" TO "rol_admin" ;
GRANT ALL ON SCHEMA "SCHEMA_NAME" TO "rol_admin";
GRANT ALL ON ALL TABLES IN SCHEMA "SCHEMA_NAME" TO "rol_admin";
GRANT ALL ON ALL SEQUENCES IN SCHEMA "SCHEMA_NAME" TO "rol_admin";
GRANT ALL ON ALL FUNCTIONS IN SCHEMA "SCHEMA_NAME" TO "rol_admin";


--rol_edit_plus
GRANT ALL ON DATABASE "DB_NAME" TO "rol_edit_plus" ;
GRANT ALL ON SCHEMA "SCHEMA_NAME" TO "rol_edit_plus";
GRANT ALL ON ALL TABLES IN SCHEMA "SCHEMA_NAME" TO "rol_edit_plus";
GRANT ALL ON ALL SEQUENCES IN SCHEMA "SCHEMA_NAME" TO "rol_edit_plus";
GRANT ALL ON ALL FUNCTIONS IN SCHEMA "SCHEMA_NAME" TO "rol_edit_plus";

--rol_dev
GRANT ALL ON DATABASE "DB_NAME" TO "rol_dev" ;
GRANT ALL ON SCHEMA "SCHEMA_NAME" TO "rol_dev";
GRANT ALL ON ALL TABLES IN SCHEMA "SCHEMA_NAME" TO "rol_dev";
GRANT ALL ON ALL SEQUENCES IN SCHEMA "SCHEMA_NAME" TO "rol_dev";
GRANT ALL ON ALL FUNCTIONS IN SCHEMA "SCHEMA_NAME" TO "rol_dev";




--rol_basic
GRANT ALL ON DATABASE "DB_NAME" TO "rol_basic" ;
GRANT ALL ON SCHEMA "SCHEMA_NAME" TO "rol_basic";
GRANT SELECT ON ALL TABLES IN SCHEMA "SCHEMA_NAME" TO "rol_basic";
GRANT SELECT ON ALL FUNCTIONS IN SCHEMA "SCHEMA_NAME" TO "rol_basic";

