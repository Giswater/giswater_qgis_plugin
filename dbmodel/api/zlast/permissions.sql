
/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


--qgisserver
GRANT ALL ON DATABASE "gis" TO "qgisserver" ;

GRANT ALL ON SCHEMA "ws" TO "qgisserver";
GRANT SELECT ON ALL TABLES IN SCHEMA "ws" TO "qgisserver";
GRANT ALL ON ALL SEQUENCES IN SCHEMA "ws" TO "qgisserver";
GRANT ALL ON ALL FUNCTIONS IN SCHEMA "ws" TO "qgisserver";

GRANT ALL ON SCHEMA "ud" TO "qgisserver";
GRANT SELECT ON ALL TABLES IN SCHEMA "ud" TO "qgisserver";
GRANT ALL ON ALL SEQUENCES IN SCHEMA "ud" TO "qgisserver";
GRANT ALL ON ALL FUNCTIONS IN SCHEMA "ud" TO "qgisserver";



--role_basic (ampliación de permisos con las nuevas tablas y vistas de la API
GRANT ALL ON ALL TABLES IN SCHEMA "ud" TO "role_basic";
GRANT ALL ON ALL TABLES IN SCHEMA "ws" TO "role_basic";

