/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


-- SUPEREDITOR

--CREATE ROLE rol_supereditor NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION;

--GRANT ALL ON DATABASE "gis" TO "rol_supereditor" ;

GRANT ALL ON SCHEMA "gw_ses" TO "rol_supereditor";
GRANT ALL ON ALL TABLES IN SCHEMA "gw_ses" TO "rol_supereditor";
GRANT ALL ON ALL FUNCTIONS IN SCHEMA "gw_ses" TO "rol_supereditor";
GRANT ALL ON ALL SEQUENCES IN SCHEMA "gw_ses" TO "rol_supereditor";

GRANT ALL ON SCHEMA "gw_sdp" TO "rol_supereditor";
GRANT ALL ON ALL TABLES IN SCHEMA "gw_sdp" TO "rol_supereditor";
GRANT ALL ON ALL FUNCTIONS IN SCHEMA "gw_sdp" TO "rol_supereditor";
GRANT ALL ON ALL SEQUENCES IN SCHEMA "gw_sdp" TO "rol_supereditor";

GRANT ALL ON SCHEMA "gw_ses" TO "rol_supereditor";
GRANT ALL ON ALL TABLES IN SCHEMA "gw_saa" TO "rol_supereditor";
GRANT ALL ON ALL FUNCTIONS IN SCHEMA "gw_saa" TO "rol_supereditor";
GRANT ALL ON ALL SEQUENCES IN SCHEMA "gw_saa" TO "rol_supereditor";


