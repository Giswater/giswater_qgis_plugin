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


