/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;
UPDATE config_toolbox AS t SET alias = v.alias, observ = v.observ FROM (
	VALUES
	(2202, 'Comprobar arcos intersectados', NULL),
    (2204, 'Comprobar arcos con pendiente invertida', NULL),
    (2206, 'Comprobar buscar-nodos arcos-salida sobre arcos-entrada', NULL),
    (2208, 'Comprobar nodos con más de una salida', NULL),
    (2210, 'Comprobar nodos como salida', NULL),
    (2212, 'Comprobar la coherencia topológica de los nodos', NULL),
    (2431, 'Comprobar los datos según las normas EPA', NULL),
    (2496, 'Reparación del arco', NULL),
    (2768, 'Análisis de Mapzones', NULL),
    (2986, 'Consistencia de la pendiente', NULL),
    (3064, 'Comprobar los valores de elevación de los nodos', NULL),
    (3066, 'Comprobar los valores de elevación de los arcos', NULL),
    (3100, 'Gestionar los valores hidrológicos', NULL),
    (3102, 'Gestionar valores Dwf', NULL),
    (3118, 'Crear Dscenario con valores de ToC', NULL),
    (3176, 'Secciones de control de conductos', NULL),
    (3186, 'Definir nodos como salida', NULL),
    (3242, 'Asignar salida óptima a las subcuencas', NULL),
    (3290, 'Crear escenario hidrológico vacío', NULL),
    (3292, 'Crear escenario DWF vacío', NULL),
    (3294, 'Duplicar escenario hidrológico', NULL),
    (3296, 'Duplicar escenario DWF', NULL),
    (3326, 'Calcular el rendimiento hidráulico para un resultado específico', NULL),
    (3360, 'Crear subcuencas Thyssen', NULL),
    (3424, 'Análisis del tipo de flujo', NULL),
    (3492, 'Análisis de Omunit', NULL),
    (3522, 'Análisis de tipos de tratamiento', NULL),
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
    (3482, 'Análisis de macromapzonas', NULL)
) AS v(id, alias, observ)
WHERE t.id = v.id;

