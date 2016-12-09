-- SUPEREDITOR

--CREATE ROLE rol_supereditor NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION;

GRANT ALL ON DATABASE "gis" TO "rol_supereditor" ;

GRANT ALL ON SCHEMA "gw_saa" TO "rol_supereditor";
GRANT ALL ON ALL TABLES IN SCHEMA "gw_saa" TO "rol_supereditor";
GRANT ALL ON ALL FUNCTIONS IN SCHEMA "gw_saa" TO "rol_supereditor";
GRANT ALL ON ALL SEQUENCES IN SCHEMA "gw_saa" TO "rol_supereditor";


GRANT ALL ON SCHEMA "gw_ses" TO "rol_supereditor";
GRANT ALL ON ALL TABLES IN SCHEMA "gw_ses" TO "rol_supereditor";
GRANT ALL ON ALL FUNCTIONS IN SCHEMA "gw_ses" TO "rol_supereditor";
GRANT ALL ON ALL SEQUENCES IN SCHEMA "gw_ses" TO "rol_supereditor";


GRANT ALL ON SCHEMA "gw_sdp" TO "rol_supereditor";
GRANT ALL ON ALL TABLES IN SCHEMA "gw_sdp" TO "rol_supereditor";
GRANT ALL ON ALL FUNCTIONS IN SCHEMA "gw_sdp" TO "rol_supereditor";
GRANT ALL ON ALL SEQUENCES IN SCHEMA "gw_sdp" TO "rol_supereditor";



-- EDITOR SAA

CREATE ROLE rol_editor_saa NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION;

GRANT ALL ON DATABASE "gis" TO "rol_editor_saa" ;

GRANT ALL ON SCHEMA "gw_saa" TO "rol_editor_saa";
GRANT ALL ON ALL TABLES IN SCHEMA "gw_saa" TO "rol_editor_saa";
GRANT ALL ON ALL FUNCTIONS IN SCHEMA "gw_saa" TO "rol_editor_saa";
GRANT ALL ON ALL SEQUENCES IN SCHEMA "gw_saa" TO "rol_editor_saa";

REVOKE ALL ON "gw_saa".arc FROM "rol_editor_saa";
GRANT ALL ("arc_id","node_1","node_2","arccat_id","epa_type" ,"sector_id" ,"state" ,"annotation","observ" ,"comment",
"custom_length","dma_id" ,"soilcat_id","category_type" ,"fluid_type" ,"location_type" ,"workcat_id" ,"buildercat_id",
"builtdate" ,"ownercat_id" ,"adress_01" ,"adress_02" ,"adress_03" ,"descript","rotation" ,"link" ,"the_geom" ,
"workcat_id_end" ,"label_x" ,"label_y" ,"label_rotation")  ON "gw_saa".arc TO "rol_editor_saa";

REVOKE ALL ON "gw_saa".node FROM "rol_editor_saa";
GRANT ALL ("node_id","elevation","depth","node_type","nodecat_id", "epa_type" ,"sector_id" ,"state" ,"annotation","observ" ,"comment",
"dma_id" ,"soilcat_id","category_type" ,"fluid_type" ,"location_type" ,"workcat_id" ,"buildercat_id",
"builtdate" ,"ownercat_id" ,"adress_01" ,"adress_02" ,"adress_03" ,"descript","rotation" ,"link" ,"the_geom" ,
"workcat_id_end" ,"label_x" ,"label_y" ,"label_rotation")  ON "gw_saa".node TO "rol_editor_saa";


REVOKE ALL ON "gw_saa".connec FROM "rol_editor_saa";
GRANT ALL ("connec_id" ,"elevation" ,"depth" ,"connecat_id" ,"sector_id" ,"code" ,"n_hydrometer" ,"demand" ,"state" ,"annotation","observ" ,"comment",
"dma_id" ,"soilcat_id","category_type" ,"fluid_type" ,"location_type" ,"workcat_id" ,"buildercat_id",
"builtdate" ,"ownercat_id" ,"adress_01" ,"adress_02" ,"adress_03" ,"descript","rotation" ,"link" ,"the_geom" ,
"workcat_id_end" ,"label_x" ,"label_y" ,"label_rotation")  ON "gw_saa".connec TO "rol_editor_saa";



REVOKE ALL ON "gw_saa".dma FROM "rol_editor_saa";
GRANT ALL ("dma_id","sector_id","presszonecat_id","descript","observ","the_geom")ON "gw_saa".dma TO "rol_editor_saa";


REVOKE ALL ON "gw_saa".sector FROM "rol_editor_saa";
GRANT ALL ("sector_id","descript","the_geom")ON "gw_saa".sector TO "rol_editor_saa";



REVOKE ALL ON "gw_saa".presszone FROM "rol_editor_saa";
GRANT ALL ("id","the_geom","presszonecat_id","sector","text") ON "gw_saa".presszone TO "rol_editor_saa";


REVOKE ALL ON "gw_saa".point FROM "rol_editor_saa";
GRANT ALL ("point_id","point_type","observ","text","the_geom") ON "gw_saa".point TO "rol_editor_saa";



-- EDITOR SES

--CREATE ROLE rol_editor_ses NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION;

GRANT ALL ON DATABASE "gis" TO "rol_editor_ses" ;

GRANT ALL ON SCHEMA "gw_ses" TO "rol_editor_ses";
GRANT ALL ON ALL TABLES IN SCHEMA "gw_ses" TO "rol_editor_ses";
GRANT ALL ON ALL FUNCTIONS IN SCHEMA "gw_ses" TO "rol_editor_ses";
GRANT ALL ON ALL SEQUENCES IN SCHEMA "gw_ses" TO "rol_editor_ses";

REVOKE ALL ON "gw_ses".arc FROM "rol_editor_ses";
GRANT ALL ("arc_id","node_1","node_2","y1","y2", "arc_type","arccat_id","epa_type" ,"sector_id" ,"state" ,"annotation","observ" ,"comment","inverted_slope",
"custom_length","dma_id" ,"soilcat_id","category_type" ,"fluid_type" ,"location_type" ,"workcat_id" ,"buildercat_id",
"builtdate" ,"ownercat_id" ,"adress_01" ,"adress_02" ,"adress_03" ,"descript","est_y1", "est_y2", "rotation" ,"link" ,"the_geom" ,
"workcat_id_end" ,"label_x" ,"label_y" ,"label_rotation")  ON "gw_ses".arc TO "rol_editor_ses";

REVOKE ALL ON "gw_ses".node FROM "rol_editor_ses";
GRANT ALL ("node_id","top_elev","ymax","sander","node_type","nodecat_id", "epa_type" ,"sector_id" ,"state" ,"annotation","observ" ,"comment",
"dma_id" ,"soilcat_id","category_type" ,"fluid_type" ,"location_type" ,"workcat_id" ,"buildercat_id",
"builtdate" ,"ownercat_id" ,"adress_01" ,"adress_02" ,"adress_03" ,"descript","est_top_elev", "est_ymax", "rotation" ,"link" ,"the_geom" ,
"workcat_id_end" ,"label_x" ,"label_y" ,"label_rotation")  ON "gw_ses".node TO "rol_editor_ses";


REVOKE ALL ON "gw_ses".connec FROM "rol_editor_ses";
GRANT ALL ("connec_id" ,"top_elev" ,"ymax" ,"connecat_id" ,"sector_id" ,"code" ,"n_hydrometer" ,"demand" ,"state" ,"annotation","observ" ,"comment",
"dma_id" ,"soilcat_id","category_type" ,"fluid_type" ,"location_type" ,"workcat_id" ,"buildercat_id",
"builtdate" ,"ownercat_id" ,"adress_01" ,"adress_02" ,"adress_03" ,"descript","rotation" ,"link" ,"the_geom" ,
"workcat_id_end","y1","y2","featurecat_id","feature_id","private_connecat_id","label_x" ,"label_y" ,"label_rotation")  ON "gw_ses".connec TO "rol_editor_ses";


REVOKE ALL ON "gw_ses".gully FROM "rol_editor_ses";
GRANT ALL ("gully_id" ,"top_elev","ymax" ,"sandbox","matcat_id" ,"gratecat_id" ,"units", "groove" , "arccat_id", "siphon","arc_id" ,"sector_id" ,"state" ,"annotation","observ" ,"comment",
"dma_id" ,"soilcat_id","category_type" ,"fluid_type" ,"location_type" ,"workcat_id" ,"buildercat_id",
"builtdate" ,"ownercat_id" ,"adress_01" ,"adress_02" ,"adress_03" ,"descript","rotation" ,"link" ,"the_geom" ,
"workcat_id_end" ,"label_x" ,"label_y" ,"label_rotation")  ON "gw_ses".gully TO "rol_editor_ses";


REVOKE ALL ON "gw_ses".dma FROM "rol_editor_ses";
GRANT ALL ("dma_id","sector_id","descript","observ","the_geom")ON "gw_ses".dma TO "rol_editor_ses";


REVOKE ALL ON "gw_ses".sector FROM "rol_editor_ses";
GRANT ALL ("sector_id","descript","the_geom")ON "gw_ses".sector TO "rol_editor_ses";

REVOKE ALL ON "gw_ses".catchment FROM "rol_editor_ses";
GRANT ALL ("catchment_id","descript","text","the_geom")ON "gw_ses".catchment TO "rol_editor_ses";

REVOKE ALL ON "gw_ses".polygon FROM "rol_editor_ses";
GRANT ALL ("pol_id", "text", "the_geom")ON "gw_ses".polygon TO "rol_editor_ses";

REVOKE ALL ON "gw_ses".point FROM "rol_editor_ses";
GRANT ALL ("point_id","point_type","observ","text","the_geom") ON "gw_ses".point TO "rol_editor_ses";




-- EDITOR SDP

--CREATE ROLE rol_editor_sdp NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION;
GRANT ALL ON DATABASE "gis" TO "rol_editor_sdp" ;

GRANT ALL ON SCHEMA "gw_sdp" TO "rol_editor_sdp";
GRANT ALL ON ALL TABLES IN SCHEMA "gw_sdp" TO "rol_editor_sdp";
GRANT ALL ON ALL FUNCTIONS IN SCHEMA "gw_sdp" TO "rol_editor_sdp";
GRANT ALL ON ALL SEQUENCES IN SCHEMA "gw_sdp" TO "rol_editor_sdp";

REVOKE ALL ON "gw_sdp".arc FROM "rol_editor_sdp";
GRANT ALL ("arc_id","node_1","node_2","y1","y2", "arc_type","arccat_id","epa_type" ,"sector_id" ,"state" ,"annotation","observ" ,"comment","inverted_slope",
"custom_length","dma_id" ,"soilcat_id","category_type" ,"fluid_type" ,"location_type" ,"workcat_id" ,"buildercat_id",
"builtdate" ,"ownercat_id" ,"adress_01" ,"adress_02" ,"adress_03" ,"descript","est_y1", "est_y2", "rotation" ,"link" ,"the_geom" ,
"workcat_id_end" ,"label_x" ,"label_y" ,"label_rotation")  ON "gw_sdp".arc TO "rol_editor_sdp";

REVOKE ALL ON "gw_sdp".node FROM "rol_editor_sdp";
GRANT ALL ("node_id","top_elev","ymax","sander","node_type","nodecat_id", "epa_type" ,"sector_id" ,"state" ,"annotation","observ" ,"comment",
"dma_id" ,"soilcat_id","category_type" ,"fluid_type" ,"location_type" ,"workcat_id" ,"buildercat_id",
"builtdate" ,"ownercat_id" ,"adress_01" ,"adress_02" ,"adress_03" ,"descript","est_top_elev", "est_ymax", "rotation" ,"link" ,"the_geom" ,
"workcat_id_end" ,"label_x" ,"label_y" ,"label_rotation")  ON "gw_sdp".node TO "rol_editor_sdp";


REVOKE ALL ON "gw_sdp".connec FROM "rol_editor_sdp";
GRANT ALL ("connec_id" ,"top_elev" ,"ymax" ,"connecat_id" ,"sector_id" ,"code" ,"n_hydrometer" ,"demand" ,"state" ,"annotation","observ" ,"comment",
"dma_id" ,"soilcat_id","category_type" ,"fluid_type" ,"location_type" ,"workcat_id" ,"buildercat_id",
"builtdate" ,"ownercat_id" ,"adress_01" ,"adress_02" ,"adress_03" ,"descript","rotation" ,"link" ,"the_geom" ,
"workcat_id_end","y1","y2","featurecat_id","feature_id","private_connecat_id","label_x" ,"label_y" ,"label_rotation")  ON "gw_sdp".connec TO "rol_editor_sdp";


REVOKE ALL ON "gw_sdp".gully FROM "rol_editor_sdp";
GRANT ALL ("gully_id" ,"top_elev","ymax" ,"sandbox","matcat_id" ,"gratecat_id" ,"units", "groove" , "arccat_id", "siphon","arc_id" ,"sector_id" ,"state" ,"annotation","observ" ,"comment",
"dma_id" ,"soilcat_id","category_type" ,"fluid_type" ,"location_type" ,"workcat_id" ,"buildercat_id",
"builtdate" ,"ownercat_id" ,"adress_01" ,"adress_02" ,"adress_03" ,"descript","rotation" ,"link" ,"the_geom" ,
"workcat_id_end" ,"label_x" ,"label_y" ,"label_rotation")  ON "gw_sdp".gully TO "rol_editor_sdp";


REVOKE ALL ON "gw_sdp".dma FROM "rol_editor_sdp";
GRANT ALL ("dma_id","sector_id","descript","observ","the_geom")ON "gw_sdp".dma TO "rol_editor_sdp";


REVOKE ALL ON "gw_sdp".sector FROM "rol_editor_sdp";
GRANT ALL ("sector_id","descript","the_geom")ON "gw_sdp".sector TO "rol_editor_sdp";

REVOKE ALL ON "gw_sdp".catchment FROM "rol_editor_sdp";
GRANT ALL ("catchment_id","descript","text","the_geom")ON "gw_sdp".catchment TO "rol_editor_sdp";

REVOKE ALL ON "gw_sdp".polygon FROM "rol_editor_sdp";
GRANT ALL ("pol_id", "text", "the_geom")ON "gw_sdp".polygon TO "rol_editor_sdp";

REVOKE ALL ON "gw_sdp".point FROM "rol_editor_sdp";
GRANT ALL ("point_id","point_type","observ","text","the_geom") ON "gw_sdp".point TO "rol_editor_sdp";






-- CONSULTA


--CREATE ROLE rol_consulta NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION;

GRANT ALL ON DATABASE "gis" TO "rol_consulta" ;

GRANT ALL ON SCHEMA "gw_saa" TO "rol_consulta";
GRANT SELECT ON ALL TABLES IN SCHEMA "gw_saa" TO "rol_consulta";
GRANT ALL ON FUNCTION "gw_saa".gw_fct_mincut(varchar,varchar) TO "rol_consulta";
GRANT ALL ON FUNCTION "gw_saa".gw_fct_mincut_recursive(varchar) TO "rol_consulta";
GRANT ALL ON FUNCTION "gw_saa".gw_fct_mincut_result_catalog() TO "rol_consulta";
GRANT ALL ON FUNCTION "gw_saa".gw_fct_valveanalytics() TO "rol_consulta";
GRANT ALL ON FUNCTION "gw_saa".gw_fct_valveanalytics_recursive(varchar) TO "rol_consulta";
GRANT ALL ON "gw_saa".anl_mincut_arc TO "rol_consulta";
GRANT ALL ON "gw_saa".anl_mincut_node TO "rol_consulta";
GRANT ALL ON "gw_saa".anl_mincut_polygon TO "rol_consulta";
GRANT ALL ON "gw_saa".anl_mincut_result_arc TO "rol_consulta";
GRANT ALL ON "gw_saa".anl_mincut_result_cat TO "rol_consulta";
GRANT ALL ON "gw_saa".anl_mincut_result_connec TO "rol_consulta";
GRANT ALL ON "gw_saa".anl_mincut_result_hydrometer TO "rol_consulta";
GRANT ALL ON "gw_saa".anl_mincut_result_polygon TO "rol_consulta";
GRANT ALL ON "gw_saa".anl_mincut_result_selector TO "rol_consulta";
GRANT ALL ON "gw_saa".anl_mincut_result_selector_compare TO "rol_consulta";
GRANT ALL ON "gw_saa".anl_mincut_result_valve TO "rol_consulta";
GRANT ALL ON "gw_saa".anl_mincut_valve TO "rol_consulta";
GRANT SELECT ON ALL SEQUENCES IN SCHEMA "gw_saa" TO "rol_consulta";


GRANT ALL ON SCHEMA "gw_sdp" TO "rol_consulta";
GRANT SELECT ON ALL TABLES IN SCHEMA "gw_sdp" TO "rol_consulta";
GRANT ALL ON FUNCTION "gw_sdp".gw_fct_flow_trace(varchar) TO "rol_consulta";
GRANT ALL ON FUNCTION "gw_sdp".gw_fct_flow_trace_recursive(varchar) TO "rol_consulta";
GRANT ALL ON FUNCTION "gw_sdp".gw_fct_flow_exit(varchar) TO "rol_consulta";
GRANT ALL ON FUNCTION "gw_sdp".gw_fct_flow_exit_recursive(varchar) TO "rol_consulta";
GRANT ALL ON "gw_sdp".anl_flow_exit_arc TO "rol_consulta";
GRANT ALL ON "gw_sdp".anl_flow_exit_node TO "rol_consulta";
GRANT ALL ON "gw_sdp".anl_flow_trace_arc TO "rol_consulta";
GRANT ALL ON "gw_sdp".anl_flow_trace_node TO "rol_consulta";
GRANT SELECT ON ALL SEQUENCES IN SCHEMA "gw_sdp" TO "rol_consulta";


GRANT ALL ON SCHEMA "gw_ses" TO "rol_consulta";
GRANT SELECT ON ALL TABLES IN SCHEMA "gw_ses" TO "rol_consulta";
GRANT ALL ON FUNCTION "gw_ses".gw_fct_flow_trace(varchar) TO "rol_consulta";
GRANT ALL ON FUNCTION "gw_ses".gw_fct_flow_trace_recursive(varchar) TO "rol_consulta";
GRANT ALL ON FUNCTION "gw_ses".gw_fct_flow_exit(varchar) TO "rol_consulta";
GRANT ALL ON FUNCTION "gw_ses".gw_fct_flow_exit_recursive(varchar) TO "rol_consulta";
GRANT ALL ON "gw_ses".anl_flow_exit_arc TO "rol_consulta";
GRANT ALL ON "gw_ses".anl_flow_exit_node TO "rol_consulta";
GRANT ALL ON "gw_ses".anl_flow_trace_arc TO "rol_consulta";
GRANT ALL ON "gw_ses".anl_flow_trace_node TO "rol_consulta";
GRANT SELECT ON ALL SEQUENCES IN SCHEMA "gw_ses" TO "rol_consulta";






--USUARIOS (DEMO usuario_gabi com rol de supereditor)

CREATE ROLE usuario_gabi LOGIN
  ENCRYPTED PASSWORD 'md508c6ce3f8970cac739950b4ad0308e68'
  NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION;
  GRANT rol_supereditor TO usuario_gabi;
