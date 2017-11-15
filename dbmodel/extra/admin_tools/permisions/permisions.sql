--rol_admin
GRANT ALL ON DATABASE "gis" TO "rol_admin" ;
GRANT ALL ON SCHEMA "ws" TO "rol_admin";
GRANT ALL ON ALL TABLES IN SCHEMA "ws" TO "rol_admin";
GRANT ALL ON ALL SEQUENCES IN SCHEMA "ws" TO "rol_admin";
GRANT ALL ON ALL FUNCTIONS IN SCHEMA "ws" TO "rol_admin";


--rol_edit_plus
GRANT ALL ON DATABASE "gis" TO "rol_edit_plus" ;
GRANT ALL ON SCHEMA "ws" TO "rol_edit_plus";
GRANT ALL ON ALL TABLES IN SCHEMA "ws" TO "rol_edit_plus";
GRANT ALL ON ALL SEQUENCES IN SCHEMA "ws" TO "rol_edit_plus";
GRANT ALL ON ALL FUNCTIONS IN SCHEMA "ws" TO "rol_edit_plus";

--rol_dev
GRANT ALL ON DATABASE "gis" TO "rol_dev" ;
GRANT ALL ON SCHEMA "SCHEMA_NAME" TO "rol_dev";
GRANT ALL ON ALL TABLES IN SCHEMA "SCHEMA_NAME" TO "rol_dev";
GRANT ALL ON ALL SEQUENCES IN SCHEMA "SCHEMA_NAME" TO "rol_dev";
GRANT ALL ON ALL FUNCTIONS IN SCHEMA "SCHEMA_NAME" TO "rol_dev";




--rol_basic
GRANT ALL ON DATABASE "gis" TO "rol_basic" ;
GRANT ALL ON SCHEMA "ud" TO "rol_basic";
GRANT SELECT ON ALL TABLES IN SCHEMA "ud" TO "rol_basic";
GRANT SELECT ON ALL FUNCTIONS IN SCHEMA "ud" TO "rol_basic";

