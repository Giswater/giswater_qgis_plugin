
CREATE TABLE drainzone
(
  drainzone_id serial PRIMARY KEY,
  name character varying(30),
  expl_id integer,
  macrodma_id integer,
  descript text,
  undelete boolean,
  the_geom geometry(MultiPolygon,25831),
  minc double precision,
  maxc double precision,
  effc double precision,
  pattern_id character varying(16),
  link text,
  graphconfig json,
  stylesheet json,
  active boolean DEFAULT true,
  avg_press numeric);

  ALTER TABLE arc ADD COLUMN drainzone_id integer; 
  ALTER TABLE node ADD COLUMN drainzone_id integer; 
  ALTER TABLE connec ADD COLUMN drainzone_id integer; 
  ALTER TABLE gully ADD COLUMN drainzone_id integer; 
  
  
  
  CREATE OR REPLACE VIEW v_anl_graphanalytics_mapzones AS 
 SELECT temp_anlgraph.arc_id,
    temp_anlgraph.node_1,
    temp_anlgraph.node_2,
    temp_anlgraph.flag,
    a2.flag AS flagi,
    a2.value,
    a2.trace
   FROM temp_anlgraph
     JOIN ( SELECT temp_anlgraph_1.arc_id,
            temp_anlgraph_1.node_1,
            temp_anlgraph_1.node_2,
            temp_anlgraph_1.water,
            temp_anlgraph_1.flag,
            temp_anlgraph_1.checkf,
            temp_anlgraph_1.value,
            temp_anlgraph_1.trace
           FROM temp_anlgraph temp_anlgraph_1
          WHERE temp_anlgraph_1.water = 1) a2 ON temp_anlgraph.node_1::text = a2.node_2::text
  WHERE temp_anlgraph.flag < 2 AND temp_anlgraph.water = 0 AND a2.flag = 0;

ALTER TABLE v_anl_graphanalytics_mapzones
  OWNER TO role_admin;
GRANT ALL ON TABLE v_anl_graphanalytics_mapzones TO role_admin;
GRANT SELECT ON TABLE v_anl_graphanalytics_mapzones TO role_basic;
GRANT ALL ON TABLE v_anl_graphanalytics_mapzones TO role_epa;