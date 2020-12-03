/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--29/10/2019

UPDATE config_api_form_fields SET label = 'Elevación' where formtype = 'feature' AND column_id = 'elevation' ; 
UPDATE config_api_form_fields SET label = 'Profundidad' where formtype = 'feature' AND column_id = 'depth';
UPDATE config_api_form_fields SET label = 'Código' where formtype = 'feature' AND column_id = 'code';
UPDATE config_api_form_fields SET label = 'Verificado' where formtype = 'feature' AND column_id = 'verified';
UPDATE config_api_form_fields SET label = 'Estado' where formtype = 'feature' AND column_id = 'state';
UPDATE config_api_form_fields SET label = 'Tipo estado' where formtype = 'feature' AND column_id = 'state_type';
UPDATE config_api_form_fields SET label = 'Longitud GIS' where formtype = 'feature' AND column_id = 'gis_length';
UPDATE config_api_form_fields SET label = 'Longitud personalizada' where formtype = 'feature' AND column_id = 'custom_length';
UPDATE config_api_form_fields SET label = 'Expediente' where formtype = 'feature' AND column_id = 'workcat_id';
UPDATE config_api_form_fields SET label = 'Expediente baja' where formtype = 'feature' AND column_id = 'workcat_id_end';
UPDATE config_api_form_fields SET label = 'Fecha baja' where formtype = 'feature' AND column_id = 'enddate';
UPDATE config_api_form_fields SET label = 'Propietario' where formtype = 'feature' AND column_id = 'ownercat_id';
UPDATE config_api_form_fields SET label = 'Función' where formtype = 'feature' AND column_id = 'function_type';
UPDATE config_api_form_fields SET label = 'Categoría' where formtype = 'feature' AND column_id = 'category_type';
UPDATE config_api_form_fields SET label = 'Localización' where formtype = 'feature' AND column_id = 'location_type';
UPDATE config_api_form_fields SET label = 'Fluido' where formtype = 'feature' AND column_id = 'fluid_type';
UPDATE config_api_form_fields SET label = 'Código postal' where formtype = 'feature' AND column_id = 'postcode';
UPDATE config_api_form_fields SET label = 'Municipio' where formtype = 'feature' AND column_id = 'muni_id';
UPDATE config_api_form_fields SET label = 'Calle' where formtype = 'feature' AND column_id = 'streetaxis_id';
UPDATE config_api_form_fields SET label = 'Número' where formtype = 'feature' AND column_id = 'postnumber';
UPDATE config_api_form_fields SET label = 'Calle 2' where formtype = 'feature' AND column_id = 'streetaxis2_id';
UPDATE config_api_form_fields SET label = 'Número 2' where formtype = 'feature' AND column_id = 'postnumber2';
UPDATE config_api_form_fields SET label = 'Explotación' where formtype = 'feature' AND column_id = 'expl_id';
UPDATE config_api_form_fields SET label = 'Última modificación' where formtype = 'feature' AND column_id = 'lastupdate';
UPDATE config_api_form_fields SET label = 'Usuario modificación' where formtype = 'feature' AND column_id = 'lastupdate_user';
UPDATE config_api_form_fields SET label = 'Zona de presión' where formtype = 'feature' AND column_id = 'presszonecat_id';
UPDATE config_api_form_fields SET label = 'Diámetro nominal' where formtype = 'feature' AND column_id = 'cat_dnom';
UPDATE config_api_form_fields SET label = 'Material' where formtype = 'feature' AND column_id = 'cat_matcat_id';
UPDATE config_api_form_fields SET label = 'Constructor' where formtype = 'feature' AND column_id = 'buildercat_id';
UPDATE config_api_form_fields SET label = 'Rotación' where formtype = 'feature' AND column_id = 'rotation';
UPDATE config_api_form_fields SET label = 'Etiqueta x' where formtype = 'feature' AND column_id = 'label_x';
UPDATE config_api_form_fields SET label = 'Etiqueta y' where formtype = 'feature' AND column_id = 'label_y';
UPDATE config_api_form_fields SET label = 'Rotación etiqueta' where formtype = 'feature' AND column_id = 'label_rotation';
UPDATE config_api_form_fields SET label = 'Publicar' where formtype = 'feature' AND column_id = 'publish';
UPDATE config_api_form_fields SET label = 'Inventario' where formtype = 'feature' AND column_id = 'inventory';
UPDATE config_api_form_fields SET label = 'Valor numérico' where formtype = 'feature' AND column_id = 'num_value';
UPDATE config_api_form_fields SET label = 'Anotación' where formtype = 'feature' AND column_id = 'annotation';
UPDATE config_api_form_fields SET label = 'Comentario' where formtype = 'feature' AND column_id = 'comment';
UPDATE config_api_form_fields SET label = 'Observación' where formtype = 'feature' AND column_id = 'observ';
UPDATE config_api_form_fields SET label = 'Descripción' where formtype = 'feature' AND column_id = 'descript';
UPDATE config_api_form_fields SET label = 'Etiqueta' where formtype = 'feature' AND column_id = 'label';
UPDATE config_api_form_fields SET label = 'Fecha alta' where formtype = 'feature' AND column_id = 'builtdate';
UPDATE config_api_form_fields SET label = 'Presión nominal' where formtype = 'feature' AND column_id = 'cat_pnom';
UPDATE config_api_form_fields SET label = 'Presión estática' where formtype = 'feature' AND column_id = 'staticpressure';
UPDATE config_api_form_fields SET label = 'Enlace' where formtype = 'feature' AND column_id = 'link';
UPDATE config_api_form_fields SET label = 'Suelo' where formtype = 'feature' AND column_id = 'soilcat_id';
UPDATE config_api_form_fields SET label = 'Hemisferio' where formtype = 'feature' AND column_id = 'hemisphere';
UPDATE config_api_form_fields SET label = 'Tipo nodo' where formtype = 'feature' AND column_id = 'node_type';
UPDATE config_api_form_fields SET label = 'Catálogo nodo' where formtype = 'feature' AND column_id = 'nodecat_id';
UPDATE config_api_form_fields SET label = 'Tipo EPA' where formtype = 'feature' AND column_id = 'epa_type';
UPDATE config_api_form_fields SET label = 'ID nodo padre' where formtype = 'feature' AND column_id = 'parent_id';
UPDATE config_api_form_fields SET label = 'ID tramo ' where formtype = 'feature' AND column_id = 'arc_id';
UPDATE config_api_form_fields SET label = 'ID nodo ' where formtype = 'feature' AND column_id = 'node_id';
UPDATE config_api_form_fields SET label = 'Macrosector' where formtype = 'feature' AND column_id = 'macrosector_id';
UPDATE config_api_form_fields SET label = 'Sector' where formtype = 'feature' AND column_id = 'sector_id';
UPDATE config_api_form_fields SET label = 'Macrodma' where formtype = 'feature' AND column_id = 'macrodma_id';
UPDATE config_api_form_fields SET label = 'Minsector' where formtype = 'feature' AND column_id = 'minsector_id';
UPDATE config_api_form_fields SET label = 'DQA' where formtype = 'feature' AND column_id = 'dqa_id';
UPDATE config_api_form_fields SET label = 'Macrodqa' where formtype = 'feature' AND column_id = 'macrodqa_id';
UPDATE config_api_form_fields SET label = 'Complemento' where formtype = 'feature' AND column_id = 'postcomplement';
UPDATE config_api_form_fields SET label = 'Complemento 2' where formtype = 'feature' AND column_id = 'postcomplement2';
UPDATE config_api_form_fields SET label = 'No eliminable' where formtype = 'feature' AND column_id = 'undelete';
UPDATE config_api_form_fields SET label = 'Elemento conectado' where formtype = 'feature' AND column_id = 'featurecat_id';
UPDATE config_api_form_fields SET label = 'ID elemento conectado' where formtype = 'feature' AND column_id = 'feature_id';
UPDATE config_api_form_fields SET label = 'Tipo final conexión' where formtype = 'feature' AND column_id = 'pjoint_type';
UPDATE config_api_form_fields SET label = 'ID final conexión' where formtype = 'feature' AND column_id = 'pjoint_id';
UPDATE config_api_form_fields SET label = 'Usuario inserción' where formtype = 'feature' AND column_id = 'insert_user';
UPDATE config_api_form_fields SET label = 'Presión estática 1' where formtype = 'feature' AND column_id = 'staticpressure1';
UPDATE config_api_form_fields SET label = 'Presión estática 2' where formtype = 'feature' AND column_id = 'staticpressure2';
UPDATE config_api_form_fields SET label = 'Elevación 1' where formtype = 'feature' AND column_id = 'elevation1';
UPDATE config_api_form_fields SET label = 'Elevación 2' where formtype = 'feature' AND column_id = 'elevation2';
UPDATE config_api_form_fields SET label = 'Profundidad 2' where formtype = 'feature' AND column_id = 'depth2';
UPDATE config_api_form_fields SET label = 'Profundidad 1' where formtype = 'feature' AND column_id = 'depth1';
UPDATE config_api_form_fields SET label = 'Tipo tramo' where formtype = 'feature' AND column_id = 'arc_type';
UPDATE config_api_form_fields SET label = 'Catálogo tramo' where formtype = 'feature' AND column_id = 'arccat_id';
UPDATE config_api_form_fields SET label = 'Tipo nodo 1' where formtype = 'feature' AND column_id = 'nodetype_1';
UPDATE config_api_form_fields SET label = 'Tipo nodo 2' where formtype = 'feature' AND column_id = 'nodetype_2';
UPDATE config_api_form_fields SET label = 'ID nodo 1' where formtype = 'feature' AND column_id = 'node_1';
UPDATE config_api_form_fields SET label = 'ID nodo 2' where formtype = 'feature' AND column_id = 'node_2';
UPDATE config_api_form_fields SET label = 'Tipo acometida' where formtype = 'feature' AND column_id = 'connec_type';
UPDATE config_api_form_fields SET label = 'Catálogo acometida' where formtype = 'feature' AND column_id = 'connecat_id';
UPDATE config_api_form_fields SET label = 'Longitud acometida' where formtype = 'feature' AND column_id = 'connec_length';
UPDATE config_api_form_fields SET label = 'Número hidrómetros' where formtype = 'feature' AND column_id = 'n_hydrometer';
UPDATE config_api_form_fields SET label = 'Código cliente' where formtype = 'feature' AND column_id = 'customer_code';
UPDATE config_api_form_fields SET label = 'ID acometida' where formtype = 'feature' AND column_id = 'connec_id';


-- man tables

UPDATE config_api_form_fields SET label = 'ID polígono' where formtype = 'feature' AND column_id = 'pol_id';
UPDATE config_api_form_fields SET label = 'Acometida relacionada' where formtype = 'feature' AND column_id = 'linked_connec';
UPDATE config_api_form_fields SET label = 'Capacidad máxima' where formtype = 'feature' AND column_id = 'vmax';
UPDATE config_api_form_fields SET label = 'Capacidad total' where formtype = 'feature' AND column_id = 'vtotal';
UPDATE config_api_form_fields SET label = 'Número envases' where formtype = 'feature' AND column_id = 'container_number';
UPDATE config_api_form_fields SET label = 'Número bombas' where formtype = 'feature' AND column_id = 'pump_number';
UPDATE config_api_form_fields SET label = 'Potencia' where formtype = 'feature' AND column_id = 'power';
UPDATE config_api_form_fields SET label = 'Tanque regulador' where formtype = 'feature' AND column_id = 'regulation_tank';
UPDATE config_api_form_fields SET label = 'Clorador' where formtype = 'feature' AND column_id = 'chlorinator';
UPDATE config_api_form_fields SET label = 'Patrimonio arquitectónico' where formtype = 'feature' AND column_id = 'arq_patrimony';
UPDATE config_api_form_fields SET label = 'Nombre' where formtype = 'feature' AND column_id = 'name';
UPDATE config_api_form_fields SET label = 'Código bomberos' where formtype = 'feature' AND column_id = 'fire_code';
UPDATE config_api_form_fields SET label = 'Comunicación' where formtype = 'feature' AND column_id = 'communication';
UPDATE config_api_form_fields SET label = 'Catálogo válvula' where formtype = 'feature' AND column_id = 'valve';
UPDATE config_api_form_fields SET label = 'Número serie' where formtype = 'feature' AND column_id = 'serial_number';
UPDATE config_api_form_fields SET label = 'Código laboratorio' where formtype = 'feature' AND column_id = 'lab_code';
UPDATE config_api_form_fields SET label = 'Piso' where formtype = 'feature' AND column_id = 'top_floor';
UPDATE config_api_form_fields SET label = 'Catálogo válvula' where formtype = 'feature' AND column_id = 'cat_valve';
UPDATE config_api_form_fields SET label = 'Flujo máximo' where formtype = 'feature' AND column_id = 'max_flow';
UPDATE config_api_form_fields SET label = 'Flujo mínimo' where formtype = 'feature' AND column_id = 'min_flow';
UPDATE config_api_form_fields SET label = 'Flujo nominal' where formtype = 'feature' AND column_id = 'nom_flow';
UPDATE config_api_form_fields SET label = 'Presión' where formtype = 'feature' AND column_id = 'pressure';
UPDATE config_api_form_fields SET label = 'Altura elevación' where formtype = 'feature' AND column_id = 'elev_height';
UPDATE config_api_form_fields SET label = 'Diámetro inicial' where formtype = 'feature' AND column_id = 'diam1';
UPDATE config_api_form_fields SET label = 'Diámetro final' where formtype = 'feature' AND column_id = 'diam2';
UPDATE config_api_form_fields SET label = 'Superficie' where formtype = 'feature' AND column_id = 'area';
UPDATE config_api_form_fields SET label = 'Capacidad útil' where formtype = 'feature' AND column_id = 'vutil';
UPDATE config_api_form_fields SET label = 'Cloración' where formtype = 'feature' AND column_id = 'chlorination';
UPDATE config_api_form_fields SET label = 'Diámetro desagüe' where formtype = 'feature' AND column_id = 'drain_diam';
UPDATE config_api_form_fields SET label = 'Final desagüe' where formtype = 'feature' AND column_id = 'drain_exit';
UPDATE config_api_form_fields SET label = 'Sumidero desagüe' where formtype = 'feature' AND column_id = 'drain_gully';
UPDATE config_api_form_fields SET label = 'Distancia desagüe' where formtype = 'feature' AND column_id = 'drain_distance';
UPDATE config_api_form_fields SET label = 'Estado comunicación' where formtype = 'feature' AND column_id = 'com_state'; 
UPDATE config_api_form_fields SET label = 'Cerrada' where formtype = 'feature' AND column_id = 'closed';
UPDATE config_api_form_fields SET label = 'Rota' where formtype = 'feature' AND column_id = 'broken';
UPDATE config_api_form_fields SET label = 'Enterrada' where formtype = 'feature' AND column_id = 'buried';
UPDATE config_api_form_fields SET label = 'Indicador riego' where formtype = 'feature' AND column_id = 'irrigation_indicator';
UPDATE config_api_form_fields SET label = 'Presión entrada' where formtype = 'feature' AND column_id = 'pression_entry';
UPDATE config_api_form_fields SET label = 'Presión salida' where formtype = 'feature' AND column_id = 'pression_exit';
UPDATE config_api_form_fields SET label = 'Profundidad eje válvula' where formtype = 'feature' AND column_id = 'depth_valveshaft';
UPDATE config_api_form_fields SET label = 'Situación regulador' where formtype = 'feature' AND column_id = 'regulator_situation';
UPDATE config_api_form_fields SET label = 'Localización regulador' where formtype = 'feature' AND column_id = 'regulator_location';
UPDATE config_api_form_fields SET label = 'Observación regulador' where formtype = 'feature' AND column_id = 'regulator_observ';
UPDATE config_api_form_fields SET label = 'Metros lineales' where formtype = 'feature' AND column_id = 'lin_meters';
UPDATE config_api_form_fields SET label = 'Tipo salida' where formtype = 'feature' AND column_id = 'exit_type';
UPDATE config_api_form_fields SET label = 'Código salida' where formtype = 'feature' AND column_id = 'exit_code';
UPDATE config_api_form_fields SET label = 'Tipo derivación' where formtype = 'feature' AND column_id = 'drive_type';
UPDATE config_api_form_fields SET label = 'Catálogo válvula' where formtype = 'feature' AND column_id = 'cat_valve2';

