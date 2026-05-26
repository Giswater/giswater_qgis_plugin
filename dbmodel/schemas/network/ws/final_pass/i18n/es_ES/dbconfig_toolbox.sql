/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;
UPDATE config_toolbox AS t SET alias = v.alias, observ = v.observ FROM (
	VALUES
	(2102, 'Comprobar arcos sin nodo inicial/final', NULL),
    (2104, 'Comprobar arcos con el mismo nodo inicial/final', NULL),
    (2106, 'Comprobar acometidas duplicadas', NULL),
    (2108, 'Comprobar nodos duplicados', NULL),
    (2110, 'Comprobar nodos huérfanos', NULL),
    (2118, 'Construir nodos utilizando inicio arco y vértices de final', NULL),
    (2436, 'Comprobar los datos del plan', NULL),
    (2670, 'Comprobar los datos para el proceso o&m', NULL),
    (2760, 'Obtener valores de raster DEM', NULL),
    (2772, 'Análisis de trazas de flujo', NULL),
    (2776, 'Comprobar la configuración del backend', NULL),
    (2826, 'Sistema de referencia lineal', NULL),
    (2890, 'Coste de reconstrucción y valores de amortización', NULL),
    (2922, 'Restablecer perfil de usuario', NULL),
    (2998, 'Datos de comprobación del usuario', NULL),
    (3008, 'Invertir arco', NULL),
    (3040, 'Comprobar arcos duplicados', NULL),
    (3042, 'Gestionar los valores de Dscenario', NULL),
    (3052, 'Arcos más cortos/largos que la longitud específica', NULL),
    (3080, 'Reparación de nodos duplicados (uno a uno)', NULL),
    (3130, 'Topocontrol para la migración de datos', NULL),
    (3134, 'Crear Dscenario vacío', NULL),
    (3156, 'Duplicar dscenario', NULL),
    (3172, 'Comprobar nodos candidatos en T', NULL),
    (3198, 'Obtener valores de dirección a partir del número de calle más próximo', NULL),
    (3280, 'Actualización masiva de la rotación de nodos', NULL),
    (3284, 'Fusionar dos o más psectores en uno', NULL),
    (3336, 'Análisis macrominsector', NULL),
    (3426, 'Integrar campaña a producción', NULL),
    (3482, 'Análisis de macromapzonas', NULL),
    (2302, 'Comprobar la coherencia topológica de los nodos', NULL),
    (2430, 'Comprobar los datos según las normas EPA', NULL),
    (2496, 'Reconectar los arcos con los nodos más cercanos', NULL),
    (2706, 'Análisis minsector', NULL),
    (2768, 'Análisis de Mapzones', NULL),
    (2790, 'Comprobar los datos para el proceso de graphanalytics', NULL),
    (2970, 'Configurar mapzones', NULL),
    (3108, 'Crear un escenario de red a partir de la ToC', NULL),
    (3110, 'Crear escenario de demanda desde CRM', NULL),
    (3112, 'Crear un escenario de demanda a partir de la ToC', NULL),
    (3142, 'Balance hídrico por explotación y período', NULL),
    (3158, 'Crear válvula dscenario desde mincut', NULL),
    (3160, 'Calcular el alcance de los hidrantes', 'La función requiere datos de ejes de calle en la tabla om_streetaxis, donde cada calle se divide en segmentos entre intersecciones.'),
    (3236, 'Mostrar los mincuts actuales', NULL),
    (3256, 'Análisis del Netscenario de Mapzones', NULL),
    (3258, 'Asignar valores de patrón al escenario de demanda', NULL),
    (3260, 'Crear un Netscenario vacío', NULL),
    (3262, 'Crear Netscenario a partir de  ToC', NULL),
    (3264, 'Duplicar Netscenario', NULL),
    (3268, 'Asignar valores de nivel inicial desde la simulación ejecutada', NULL),
    (3308, 'Crear un escenario de red completo', NULL),
    (3322, 'Fijar el coste del material retirado en los psectores', NULL)
) AS v(id, alias, observ)
WHERE t.id = v.id;

