/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;
UPDATE config_toolbox AS t SET alias = v.alias, observ = v.observ FROM (
	VALUES
	(2102, 'Comprobar arcos sin nodo de inicio/fin', NULL),
    (2104, 'Comprobar arcos con el mismo nodo inicial/final', NULL),
    (2106, 'Comprobar conexiones duplicadas', NULL),
    (2108, 'Comprobar nodos duplicados', NULL),
    (2110, 'Comprobar nodos huérfanos', NULL),
    (2118, 'Construir nodos utilizando vértices de inicio y fin de arco', NULL),
    (2436, 'Comprobar los datos del plan', NULL),
    (2670, 'Comprobar los datos para el proceso o&m', NULL),
    (2760, 'Obtener valores de raster DEM', NULL),
    (2768, 'Análisis de Mapzones', NULL),
    (2772, 'Análisis de trazas de flujo', NULL),
    (2776, 'Comprobar la configuración del backend', NULL),
    (2826, 'Sistema de referencia lineal', NULL),
    (2890, 'Coste de reconstrucción y valores de amortización', NULL),
    (2922, 'Restablecer perfil de usuario', NULL),
    (2998, 'Datos de comprobación del usuario', NULL),
    (3008, 'Arco invertido', NULL),
    (3040, 'Comprobar arcos duplicados', NULL),
    (3042, 'Gestionar los valores de Dscenario', NULL),
    (3052, 'Arcos más cortos/más grandes que la longitud específica', NULL),
    (3080, 'Reparación de nodos duplicados (uno a uno)', NULL),
    (3130, 'Topocontrol para la migración de datos', NULL),
    (3134, 'Crear Dscenario vacío', NULL),
    (3156, 'Duplicar dscenario', NULL),
    (3172, 'Comprobar nodos T candidatos', NULL),
    (3198, 'Obtener valores de dirección a partir del número de calle más próximo', NULL),
    (3280, 'Actualización masiva de la rotación de nodos', NULL),
    (3284, 'Fusionar dos o más psectores en uno', NULL),
    (3336, 'Análisis macrosectorial', NULL),
    (3426, 'Integrar campaña a producción', NULL),
    (3482, 'Análisis de macromapzonas', NULL),
    (2302, 'Comprobar la coherencia topológica de los nodos', NULL),
    (2430, 'Comprobar los datos según las normas de la EPA', NULL),
    (2496, 'Reconectar los arcos con los nodos más cercanos', NULL),
    (2706, 'Análisis minsectorial', NULL),
    (2790, 'Comprobar los datos para el proceso de graphanalytics', NULL),
    (2970, 'Configurar zonas del mapa', NULL),
    (3108, 'Crear un escenario de red a partir de la TdC', NULL),
    (3110, 'Crear escenario de demanda desde CRM', NULL),
    (3112, 'Crear un escenario de demanda a partir de la TdC', NULL),
    (3142, 'Balance hídrico por explotación y periodo', NULL),
    (3158, 'Crear válvula dscenario de mincut', NULL),
    (3160, 'Calcular el alcance de los hidrantes', 'La función requiere datos de calles insertados en la tabla om_streetaxis, donde cada calle se divide en líneas cortas entre las intersecciones.'),
    (3236, 'Mostrar los minicortes actuales', NULL),
    (3256, 'Análisis del Netscenario de Mapzones', NULL),
    (3258, 'Establecer valores de patrón a petición dscenario', NULL),
    (3260, 'Crear un Netscenario vacío', NULL),
    (3262, 'Crear Netscenario a partir de TdC', NULL),
    (3264, 'Duplicar Netscenario', NULL),
    (3268, 'Establecer valores de nivel de entrada de la simulación ejecutada', NULL),
    (3308, 'Crear un escenario de red completo', NULL),
    (3322, 'Fijar el coste del material retirado en los psectores', NULL)
) AS v(id, alias, observ)
WHERE t.id = v.id;

