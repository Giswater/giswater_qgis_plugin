
/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


GRANT ALL ON DATABASE "db_name" TO "user_name" ;
GRANT ALL ON SCHEMA "schema_name" TO "user_name";

--en función del que queramos:
GRANT ALL ON ALL TABLES IN SCHEMA "schema_name" TO "user_name";
GRANT ALL ON ALL SEQUENCES IN SCHEMA "schema_name" TO "user_name";
GRANT ALL ON ALL FUNCTIONS IN SCHEMA "schema_name" TO "user_name";