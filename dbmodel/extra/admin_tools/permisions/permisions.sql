--rol_admin
GRANT ALL ON DATABASE "gis" TO "rol_admin" ;
GRANT ALL ON SCHEMA "ws" TO "rol_admin";
GRANT ALL ON ALL TABLES IN SCHEMA "ud" TO "rol_admin";
GRANT ALL ON ALL SEQUENCES IN SCHEMA "ud" TO "rol_admin";
GRANT ALL ON ALL FUNCTIONS IN SCHEMA "ud" TO "rol_admin";


--rol_edit_plus
GRANT ALL ON DATABASE "gis" TO "rol_edit_plus" ;
GRANT ALL ON SCHEMA "ws" TO "rol_edit_plus";
GRANT ALL ON ALL TABLES IN SCHEMA "ws" TO "rol_edit_plus";
GRANT ALL ON ALL SEQUENCES IN SCHEMA "ws" TO "rol_edit_plus";
GRANT ALL ON ALL FUNCTIONS IN SCHEMA "ws" TO "rol_edit_plus";



--rol_basic
GRANT ALL ON DATABASE "gis" TO "rol_basic" ;
GRANT ALL ON SCHEMA "ud" TO "rol_basic";
GRANT SELECT ON ALL TABLES IN SCHEMA "ud" TO "rol_basic";
GRANT SELECT ON ALL FUNCTIONS IN SCHEMA "ud" TO "rol_basic";

