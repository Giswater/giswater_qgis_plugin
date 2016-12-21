CREATE  TABLE vw_daecom_cadastro
  (cod_dae integer NOT NULL,
    inscr_iptu character varying(10) ,
    cod_categoria integer ,
    lote integer ,
    quadra integer ,
    zona integer ,
    cod_rua integer ,
    qtd_economias integer ,
    grupoleitura integer ,
    classe character varying(10) ,
    ulmc integer,
    CONSTRAINT vw_daecom_cadastro_pkey PRIMARY KEY (cod_dae) );
    

CREATE TABLE vw_daecom_categorias
   (cod_categoria integer NOT NULL,
    categoria character varying(100),
    CONSTRAINT vw_daecom_categorias_pkey PRIMARY KEY (cod_categoria) )
;

CREATE  TABLE vw_daecom_consumo
   (cod_dae integer NOT NULL,
    mes_exercicio integer ,
    ano_exercicio integer ,
    consumo real ,
    mediaconsumo real ,
    cod_categoria integer,
    CONSTRAINT vw_daecom_consumo_pkey PRIMARY KEY (cod_dae) ) ;
   


CREATE  TABLE vw_daecom_endereco
   (cod_dae integer NOT NULL,
    nome text ,
    telefone text ,
    tipologr text ,
    logr text ,
    numero integer ,
    complemento text ,
    cod_rua integer,
    CONSTRAINT vw_daecom_endereco_pkey PRIMARY KEY (cod_dae) );


CREATE  TABLE vw_daecom_hidrometro
   (cod_hidrometro integer NOT NULL,
    marca character varying(30) ,
    classe character varying(10) ,
    ulmc integer ,
    vazaovoltman real ,
    vazaounimultijato real ,
    diametromm real,
    CONSTRAINT vw_daecom_hidrometro_pkey PRIMARY KEY (cod_hidrometro) );



CREATE  TABLE vw_daecom_ligacao
   (cod_dae integer NOT NULL,
    inscr_iptu character varying(10) ,
    cod_categoria integer ,
    qtd_economias integer ,
    num_caderno character varying(20) ,
    cod_hidrometro integer ,
    num_hidrometro character varying(20) ,
    cnpjcpf character varying(20),
    CONSTRAINT vw_daecom_ligacao_pkey PRIMARY KEY (cod_dae) );


CREATE  TABLE vw_daecom_logradouro
   (cod_rua integer NOT NULL,
    tipologr text ,
    logr text,
    CONSTRAINT vw_daecom_logradouro_pkey PRIMARY KEY (cod_rua) );


CREATE  TABLE vw_daescom_grupos
   (cod_dae integer NOT NULL,
    grupo integer,
    CONSTRAINT vw_daescom_grupos_pkey PRIMARY KEY (cod_dae) );