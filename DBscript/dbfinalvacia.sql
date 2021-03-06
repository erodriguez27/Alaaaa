PGDMP     %                    x            dbfinalvacia    10.3    10.3 �   �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                       false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                       false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                       false            �           1262    136251    dbfinalvacia    DATABASE     �   CREATE DATABASE dbfinalvacia WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'Spanish_Venezuela.1252' LC_CTYPE = 'Spanish_Venezuela.1252';
    DROP DATABASE dbfinalvacia;
             postgres    false                        2615    2200    public    SCHEMA        CREATE SCHEMA public;
    DROP SCHEMA public;
             postgres    false            �           0    0    SCHEMA public    COMMENT     6   COMMENT ON SCHEMA public IS 'standard public schema';
                  postgres    false    3                        3079    12924    plpgsql 	   EXTENSION     ?   CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;
    DROP EXTENSION plpgsql;
                  false            �           0    0    EXTENSION plpgsql    COMMENT     @   COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';
                       false    1            �           1255    136252    delete_broiler_cascade(integer)    FUNCTION     �  CREATE FUNCTION public.delete_broiler_cascade(lot_b integer, OUT deleted boolean) RETURNS boolean
    LANGUAGE plpgsql
    AS $$

DECLARE
allowed boolean DEFAULT false;
BEGIN

SELECT COALESCE(sum(CASE WHEN gg.synchronized is true THEN 1 ELSE 0 END),0)=0 INTO allowed FROM (SELECT distinct eng_detail.slbroiler_detail_id, eng_detail.synchronized FROM sltxbroiler_detail eng_detail 
WHERE lot::integer = lot_b) as gg;

IF allowed is false THEN
deleted = false;
RETURN;
END IF;

UPDATE sltxbroiler_detail SET sl_disable = true where lot::integer = lot_b;

UPDATE sltxbroiler_lot bl SET sl_disable = true FROM (SELECT distinct eng_lt.slbroiler_lot_id FROM sltxbroiler_detail eng_detail
LEFT JOIN sltxbroiler_lot eng_lt on eng_detail.slbroiler_detail_id = eng_lt.slbroiler_detail_id 
WHERE eng_detail.lot::integer=lot_b ) as bro_l WHERE bl.slbroiler_lot_id = bro_l.slbroiler_lot_id;

deleted = true
RETURN;

END;

$$;
 Q   DROP FUNCTION public.delete_broiler_cascade(lot_b integer, OUT deleted boolean);
       public       postgres    false    1    3            �           1255    136253 #   delete_buy_chicken_cascade(integer)    FUNCTION     9  CREATE FUNCTION public.delete_buy_chicken_cascade(buy_id integer, OUT deleted boolean) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
    
	DECLARE
      allowed boolean DEFAULT false;
    BEGIN
	  
	SELECT COALESCE(sum(CASE WHEN gg.synchronized is true THEN 1 ELSE 0 END),0)=0 INTO allowed 
	FROM (SELECT distinct eng_detail.slbroiler_detail_id, eng_detail.synchronized FROM sltxsellspurchase sells
			LEFT JOIN sltxbroiler_lot eng_lot on sells.slsellspurchase_id = eng_lot.slsellspurchase_id 
			LEFT JOIN sltxbroiler_detail eng_detail on eng_lot.slbroiler_detail_id = eng_detail.slbroiler_detail_id 
		WHERE sells.slsellspurchase_id=buy_id) as gg;
     
     IF allowed is false THEN
	 	deleted = false;
        RETURN;
     END IF;
	 
		UPDATE sltxbroiler_detail b SET sl_disable = true FROM (SELECT distinct eng_detail.slbroiler_detail_id FROM sltxsellspurchase sells
			LEFT JOIN sltxbroiler_lot eng_lot on sells.slsellspurchase_id = eng_lot.slsellspurchase_id 
			LEFT JOIN sltxbroiler_detail eng_detail on eng_lot.slbroiler_detail_id = eng_detail.slbroiler_detail_id 
	WHERE sells.slsellspurchase_id=buy_id) as bro_d where b.slbroiler_detail_id = bro_d.slbroiler_detail_id;


		UPDATE sltxbroiler_lot bl SET sl_disable = true FROM (SELECT distinct eg_lot.slbroiler_lot_id FROM sltxsellspurchase sells
			LEFT JOIN sltxbroiler_lot eng_lot on sells.slsellspurchase_id = eng_lot.slsellspurchase_id 
			LEFT JOIN sltxbroiler_detail eng_detail on eng_lot.slbroiler_detail_id = eng_detail.slbroiler_detail_id 
			LEFT JOIN sltxbroiler_lot eg_lot on eng_detail.slbroiler_detail_id = eg_lot.slbroiler_detail_id 
	WHERE sells.slsellspurchase_id=buy_id) as bro_l WHERE bl.slbroiler_lot_id = bro_l.slbroiler_lot_id;
	
	UPDATE sltxsellspurchase SET sl_disable = true where slsellspurchase_id = buy_id;

	deleted = true
     RETURN;
     
    END;
	
$$;
 V   DROP FUNCTION public.delete_buy_chicken_cascade(buy_id integer, OUT deleted boolean);
       public       postgres    false    1    3            �           1255    136254    delete_buy_egg_cascade(integer)    FUNCTION     �  CREATE FUNCTION public.delete_buy_egg_cascade(buy_id integer, OUT deleted boolean) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
    
	DECLARE
      allowed boolean DEFAULT false;
    BEGIN
	  
	SELECT COALESCE(sum(CASE WHEN gg.synchronized is true THEN 1 ELSE 0 END),0)=0 INTO allowed 
	FROM (SELECT distinct eng_detail.slbroiler_detail_id, eng_detail.synchronized FROM sltxsellspurchase sells
			LEFT JOIN sltxincubator_lot inc_lot on sells.slsellspurchase_id  = inc_lot.slsellspurchase_id
	  		LEFT JOIN sltxincubator_detail inc_detail on inc_lot.slincubator_detail_id = inc_detail.slincubator_detail_id
			LEFT JOIN sltxbroiler engorde on inc_detail.slincubator_detail_id = engorde.slincubator_detail_id 
			LEFT JOIN sltxbroiler_lot eng_lot on engorde.slbroiler_id = eng_lot.slbroiler_id 
			LEFT JOIN sltxbroiler_detail eng_detail on eng_lot.slbroiler_detail_id = eng_detail.slbroiler_detail_id
		WHERE sells.slsellspurchase_id=buy_id) as gg;
     
     IF allowed is false THEN
	 	deleted = false;
        RETURN;
     END IF;
	 
		UPDATE sltxbroiler_detail b SET sl_disable = true FROM (SELECT distinct eng_detail.slbroiler_detail_id FROM sltxsellspurchase sells
			LEFT JOIN sltxincubator_lot inc_lot on sells.slsellspurchase_id  = inc_lot.slsellspurchase_id
	  		LEFT JOIN sltxincubator_detail inc_detail on inc_lot.slincubator_detail_id = inc_detail.slincubator_detail_id
			LEFT JOIN sltxbroiler engorde on inc_detail.slincubator_detail_id = engorde.slincubator_detail_id 
			LEFT JOIN sltxbroiler_lot eng_lot on engorde.slbroiler_id = eng_lot.slbroiler_id 
			LEFT JOIN sltxbroiler_detail eng_detail on eng_lot.slbroiler_detail_id = eng_detail.slbroiler_detail_id 
		WHERE sells.slsellspurchase_id=buy_id) as bro_d where b.slbroiler_detail_id = bro_d.slbroiler_detail_id;


		UPDATE sltxbroiler_lot bl SET sl_disable = true FROM (SELECT distinct g_lot.slbroiler_lot_id FROM sltxsellspurchase sells
			LEFT JOIN sltxincubator_lot inc_lot on sells.slsellspurchase_id  = inc_lot.slsellspurchase_id
	  		LEFT JOIN sltxincubator_detail inc_detail on inc_lot.slincubator_detail_id = inc_detail.slincubator_detail_id
			LEFT JOIN sltxbroiler engorde on inc_detail.slincubator_detail_id = engorde.slincubator_detail_id 
			LEFT JOIN sltxbroiler_lot eng_lot on engorde.slbroiler_id = eng_lot.slbroiler_id  
			LEFT JOIN sltxbroiler_detail eng_detail on eng_lot.slbroiler_detail_id = eng_detail.slbroiler_detail_id
			LEFT JOIN sltxbroiler_lot g_lot on eng_detail.slbroiler_detail_id = g_lot.slbroiler_detail_id  											
		WHERE sells.slsellspurchase_id=37) as bro_l WHERE bl.slbroiler_lot_id = bro_l.slbroiler_lot_id;
	
		UPDATE sltxbroiler  br SET sl_disable = true FROM (SELECT distinct engorde.slbroiler_id FROM sltxsellspurchase sells
			LEFT JOIN sltxincubator_lot inc_lot on sells.slsellspurchase_id  = inc_lot.slsellspurchase_id
	  		LEFT JOIN sltxincubator_detail inc_detail on inc_lot.slincubator_detail_id = inc_detail.slincubator_detail_id
			LEFT JOIN sltxbroiler engorde on inc_detail.slincubator_detail_id = engorde.slincubator_detail_id 
		WHERE sells.slsellspurchase_id=buy_id) as bro where br.slbroiler_id = bro.slbroiler_id;

		UPDATE sltxincubator_detail ind SET sl_disable = true FROM (SELECT distinct inc_detail.slincubator_detail_id FROM sltxsellspurchase sells
			LEFT JOIN sltxincubator_lot inc_lot on sells.slsellspurchase_id  = inc_lot.slsellspurchase_id
	  		LEFT JOIN sltxincubator_detail inc_detail on inc_lot.slincubator_detail_id = inc_detail.slincubator_detail_id
		WHERE sells.slsellspurchase_id=buy_id) as det where ind.slincubator_detail_id = det.slincubator_detail_id;

		UPDATE sltxincubator_lot icl SET sl_disable = true FROM (SELECT distinct ic_lot.slincubator_lot_id FROM sltxsellspurchase sells
			LEFT JOIN sltxincubator_lot inc_lot on sells.slsellspurchase_id  = inc_lot.slsellspurchase_id
			LEFT JOIN sltxincubator_detail inc_detail on inc_lot.slincubator_detail_id = inc_detail.slincubator_detail_id
			LEFT JOIN sltxincubator_lot ic_lot on inc_detail.slincubator_detail_id  = ic_lot.slincubator_detail_id
		WHERE sells.slsellspurchase_id=buy_id) as inc_l where icl.slincubator_lot_id = inc_l.slincubator_lot_id;

		UPDATE sltxsellspurchase SET sl_disable = true where slsellspurchase_id = buy_id;

		deleted = true
     	RETURN;
     
    END;
	
$$;
 R   DROP FUNCTION public.delete_buy_egg_cascade(buy_id integer, OUT deleted boolean);
       public       postgres    false    3    1            �           1255    136255 !   delete_incubator_cascade(integer)    FUNCTION     �  CREATE FUNCTION public.delete_incubator_cascade(inc_id integer, OUT deleted boolean) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
    DECLARE
      allowed boolean DEFAULT false;
    BEGIN
	  
	 SELECT COALESCE(sum(CASE WHEN gg.synchronized is true THEN 1 ELSE 0 END),0)=0 INTO allowed FROM (SELECT distinct eng_detail.slbroiler_detail_id, eng_detail.synchronized FROM sltxincubator_detail inc_detail
			LEFT JOIN sltxincubator_lot inc_lot on inc_detail.slincubator_detail_id  = inc_lot.slincubator_detail_id
			LEFT JOIN sltxbroiler engorde on inc_detail.slincubator_detail_id = engorde.slincubator_detail_id 
			LEFT JOIN sltxbroiler_lot eng_lot on engorde.slbroiler_id = eng_lot.slbroiler_id 
			LEFT JOIN sltxbroiler_detail eng_detail on eng_lot.slbroiler_detail_id = eng_detail.slbroiler_detail_id 
	WHERE inc_detail.slincubator_detail_id=inc_id) as gg;
     
     IF allowed is false THEN
	 	deleted = false;
        RETURN;
     END IF;
	
	

		UPDATE sltxbroiler_detail b SET sl_disable = true FROM (SELECT distinct eng_detail.slbroiler_detail_id FROM sltxincubator_detail inc_detail
			LEFT JOIN sltxincubator_lot inc_lot on inc_detail.slincubator_detail_id  = inc_lot.slincubator_detail_id
			LEFT JOIN sltxbroiler engorde on inc_detail.slincubator_detail_id = engorde.slincubator_detail_id 
			LEFT JOIN sltxbroiler_lot eng_lot on engorde.slbroiler_id = eng_lot.slbroiler_id 
			LEFT JOIN sltxbroiler_detail eng_detail on eng_lot.slbroiler_detail_id = eng_detail.slbroiler_detail_id 
	WHERE inc_detail.slincubator_detail_id=inc_id) as bro_d where b.slbroiler_detail_id = bro_d.slbroiler_detail_id;


		UPDATE sltxbroiler_lot bl SET sl_disable = true FROM (SELECT distinct eng_lt.slbroiler_lot_id FROM sltxincubator_detail inc_detail
			LEFT JOIN sltxincubator_lot inc_lot on inc_detail.slincubator_detail_id  = inc_lot.slincubator_detail_id
			LEFT JOIN sltxbroiler engorde on inc_detail.slincubator_detail_id = engorde.slincubator_detail_id 
			LEFT JOIN sltxbroiler_lot eng_lot on engorde.slbroiler_id = eng_lot.slbroiler_id 
			LEFT JOIN sltxbroiler_detail eng_detail on eng_lot.slbroiler_detail_id = eng_detail.slbroiler_detail_id 
			LEFT JOIN sltxbroiler_lot eng_lt on eng_detail.slbroiler_detail_id  = eng_lt.slbroiler_detail_id 												
	WHERE inc_detail.slincubator_detail_id=inc_id ) as bro_l WHERE bl.slbroiler_lot_id = bro_l.slbroiler_lot_id;


		UPDATE sltxbroiler  br SET sl_disable = true FROM (SELECT distinct engorde.slbroiler_id FROM sltxincubator_detail inc_detail
			LEFT JOIN sltxincubator_lot inc_lot on inc_detail.slincubator_detail_id  = inc_lot.slincubator_detail_id
			LEFT JOIN sltxbroiler engorde on inc_detail.slincubator_detail_id = engorde.slincubator_detail_id 
	WHERE inc_detail.slincubator_detail_id=inc_id) as bro where br.slbroiler_id = bro.slbroiler_id;


		UPDATE sltxincubator_lot icl SET sl_disable = true FROM (SELECT distinct inc_lot.slincubator_lot_id FROM sltxincubator_detail inc_detail
			LEFT JOIN sltxincubator_lot inc_lot on inc_detail.slincubator_detail_id  = inc_lot.slincubator_detail_id
	WHERE inc_detail.slincubator_detail_id=inc_id) as inc_l where icl.slincubator_lot_id = inc_l.slincubator_lot_id;


		UPDATE sltxincubator_detail SET sl_disable = true where slincubator_detail_id = inc_id;


	
	
	deleted = true
     RETURN;
     
    END;
$$;
 T   DROP FUNCTION public.delete_incubator_cascade(inc_id integer, OUT deleted boolean);
       public       postgres    false    3    1            �           1255    136256 "   delete_production_cascade(integer)    FUNCTION     R  CREATE FUNCTION public.delete_production_cascade(produccion_id integer, OUT deleted boolean) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
    
	DECLARE
      allowed boolean DEFAULT false;
    BEGIN
	  
	 SELECT COALESCE(sum(CASE WHEN gg.synchronized is true THEN 1 ELSE 0 END),0)=0 INTO allowed FROM (SELECT distinct eng_detail.slbroiler_detail_id, eng_detail.synchronized FROM sltxbreeding produccion
			LEFT JOIN sltxposturecurve curva on produccion.slbreeding_id = curva.slbreeding_id 
			LEFT JOIN sltxincubator_curve ic on curva.slposturecurve_id = ic.slposturecurve_id 																						
			LEFT JOIN sltxincubator incubadora on incubadora.slincubator = ic.slincubator_id
			LEFT JOIN sltxincubator_lot inc_lot on ic.slincubator_curve_id  = inc_lot.slincubator_curve_id 
			LEFT JOIN sltxincubator_detail inc_detail on inc_lot.slincubator_detail_id = inc_detail.slincubator_detail_id 
			LEFT JOIN sltxbroiler engorde on inc_detail.slincubator_detail_id = engorde.slincubator_detail_id 
			LEFT JOIN sltxbroiler_lot eng_lot on engorde.slbroiler_id = eng_lot.slbroiler_id 
			LEFT JOIN sltxbroiler_detail eng_detail on eng_lot.slbroiler_detail_id = eng_detail.slbroiler_detail_id 
	WHERE produccion.slbreeding_id=produccion_id) as gg;
     
     IF allowed is false THEN
	 	deleted = false;
        RETURN;
     END IF;
	
	

		UPDATE sltxbroiler_detail b SET sl_disable = true FROM (SELECT distinct eng_detail.slbroiler_detail_id FROM sltxbreeding produccion
				LEFT JOIN sltxposturecurve curva on produccion.slbreeding_id = curva.slbreeding_id 
																
																
				LEFT JOIN sltxincubator_curve ic on curva.slposturecurve_id = ic.slposturecurve_id 																						
				LEFT JOIN sltxincubator incubadora on incubadora.slincubator = ic.slincubator_id
																
																
				LEFT JOIN sltxincubator_lot inc_lot on ic.slincubator_curve_id  = inc_lot.slincubator_curve_id 
				LEFT JOIN sltxincubator_detail inc_detail on inc_lot.slincubator_detail_id = inc_detail.slincubator_detail_id 
				LEFT JOIN sltxbroiler engorde on inc_detail.slincubator_detail_id = engorde.slincubator_detail_id 
				LEFT JOIN sltxbroiler_lot eng_lot on engorde.slbroiler_id = eng_lot.slbroiler_id 
				LEFT JOIN sltxbroiler_detail eng_detail on eng_lot.slbroiler_detail_id = eng_detail.slbroiler_detail_id 
		WHERE produccion.slbreeding_id=produccion_id ) as bro_d where b.slbroiler_detail_id = bro_d.slbroiler_detail_id;


		UPDATE sltxbroiler_lot bl SET sl_disable = true FROM (SELECT distinct eng_lt.slbroiler_lot_id FROM sltxbreeding produccion
				LEFT JOIN sltxposturecurve curva on produccion.slbreeding_id = curva.slbreeding_id 
				LEFT JOIN sltxincubator_curve ic on curva.slposturecurve_id = ic.slposturecurve_id 																						
				LEFT JOIN sltxincubator incubadora on incubadora.slincubator = ic.slincubator_id
				LEFT JOIN sltxincubator_lot inc_lot on ic.slincubator_curve_id  = inc_lot.slincubator_curve_id  
				LEFT JOIN sltxincubator_detail inc_detail on inc_lot.slincubator_detail_id = inc_detail.slincubator_detail_id 
				LEFT JOIN sltxbroiler engorde on inc_detail.slincubator_detail_id = engorde.slincubator_detail_id 
				LEFT JOIN sltxbroiler_lot eng_lot on engorde.slbroiler_id = eng_lot.slbroiler_id 
				LEFT JOIN sltxbroiler_detail eng_detail on eng_lot.slbroiler_detail_id = eng_detail.slbroiler_detail_id 
				LEFT JOIN sltxbroiler_lot eng_lt on eng_detail.slbroiler_detail_id  = eng_lt.slbroiler_detail_id
		WHERE produccion.slbreeding_id=produccion_id ) as bro_l WHERE bl.slbroiler_lot_id = bro_l.slbroiler_lot_id;


		UPDATE sltxbroiler  br SET sl_disable = true FROM (SELECT distinct engorde.slbroiler_id FROM sltxbreeding produccion
				LEFT JOIN sltxposturecurve curva on produccion.slbreeding_id = curva.slbreeding_id 
				LEFT JOIN sltxincubator_curve ic on curva.slposturecurve_id = ic.slposturecurve_id 																						
				LEFT JOIN sltxincubator incubadora on incubadora.slincubator = ic.slincubator_id 
				LEFT JOIN sltxincubator_lot inc_lot on ic.slincubator_curve_id  = inc_lot.slincubator_curve_id 
				LEFT JOIN sltxincubator_detail inc_detail on inc_lot.slincubator_detail_id = inc_detail.slincubator_detail_id 
				LEFT JOIN sltxbroiler engorde on inc_detail.slincubator_detail_id = engorde.slincubator_detail_id 
		WHERE produccion.slbreeding_id=produccion_id ) as bro where br.slbroiler_id = bro.slbroiler_id;


		UPDATE sltxincubator_detail icd SET sl_disable = true FROM (SELECT distinct inc_detail.slincubator_detail_id FROM sltxbreeding produccion
				LEFT JOIN sltxposturecurve curva on produccion.slbreeding_id = curva.slbreeding_id 
				LEFT JOIN sltxincubator_curve ic on curva.slposturecurve_id = ic.slposturecurve_id 																						
				LEFT JOIN sltxincubator incubadora on incubadora.slincubator = ic.slincubator_id
				LEFT JOIN sltxincubator_lot inc_lot on ic.slincubator_curve_id  = inc_lot.slincubator_curve_id 
				LEFT JOIN sltxincubator_detail inc_detail on inc_lot.slincubator_detail_id = inc_detail.slincubator_detail_id 
		WHERE produccion.slbreeding_id=produccion_id ) as inc_d where icd.slincubator_detail_id = inc_d.slincubator_detail_id;



		UPDATE sltxincubator_lot icl SET sl_disable = true FROM (SELECT distinct inc_lt.slincubator_lot_id FROM sltxbreeding produccion
				LEFT JOIN sltxposturecurve curva on produccion.slbreeding_id = curva.slbreeding_id 
				LEFT JOIN sltxincubator_curve ic on curva.slposturecurve_id = ic.slposturecurve_id 																						
				LEFT JOIN sltxincubator incubadora on incubadora.slincubator = ic.slincubator_id 
				LEFT JOIN sltxincubator_lot inc_lot on ic.slincubator_curve_id  = inc_lot.slincubator_curve_id 
				LEFT JOIN sltxincubator_detail inc_detail on inc_lot.slincubator_detail_id = inc_detail.slincubator_detail_id 
				LEFT JOIN sltxincubator_lot inc_lt on inc_detail.slincubator_detail_id  = inc_lt.slincubator_detail_id 
		WHERE produccion.slbreeding_id=produccion_id ) as inc_l where icl.slincubator_lot_id = inc_l.slincubator_lot_id;


		UPDATE sltxincubator_curve i SET sl_disable = true FROM (SELECT distinct ic.slincubator_curve_id FROM sltxbreeding produccion
				LEFT JOIN sltxposturecurve curva on produccion.slbreeding_id = curva.slbreeding_id 
				LEFT JOIN sltxincubator_curve ic on curva.slposturecurve_id = ic.slposturecurve_id
		WHERE produccion.slbreeding_id=produccion_id ) as inc_curv where i.slincubator_curve_id = inc_curv.slincubator_curve_id;

		UPDATE sltxposturecurve cp SET sl_disable = true FROM (SELECT distinct curva.slposturecurve_id FROM sltxbreeding produccion
				LEFT JOIN sltxposturecurve curva on produccion.slbreeding_id = curva.slbreeding_id 
		WHERE produccion.slbreeding_id=produccion_id ) as bc where cp.slposturecurve_id = bc.slposturecurve_id;

		UPDATE sltxbreeding SET sl_disable = true WHERE slbreeding_id = produccion_id;
		
		UPDATE sltxliftbreeding SET sl_disable = true WHERE slbreeding_id = produccion_id;

	
	
	deleted = true
     RETURN;
     
    END;
$$;
 \   DROP FUNCTION public.delete_production_cascade(produccion_id integer, OUT deleted boolean);
       public       postgres    false    3    1            �            1259    136257    abaTimeUnit_id_seq    SEQUENCE     �   CREATE SEQUENCE public."abaTimeUnit_id_seq"
    START WITH 2
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1;
 +   DROP SEQUENCE public."abaTimeUnit_id_seq";
       public       postgres    false    3            �            1259    136259    aba_breeds_and_stages_id_seq    SEQUENCE     �   CREATE SEQUENCE public.aba_breeds_and_stages_id_seq
    START WITH 8
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1;
 3   DROP SEQUENCE public.aba_breeds_and_stages_id_seq;
       public       postgres    false    3            �            1259    136261    aba_breeds_and_stages    TABLE     "  CREATE TABLE public.aba_breeds_and_stages (
    id integer DEFAULT nextval('public.aba_breeds_and_stages_id_seq'::regclass) NOT NULL,
    code character varying(100),
    name character varying(100),
    id_aba_consumption_and_mortality integer NOT NULL,
    id_process integer NOT NULL
);
 )   DROP TABLE public.aba_breeds_and_stages;
       public         postgres    false    197    3            �           0    0    TABLE aba_breeds_and_stages    COMMENT     o   COMMENT ON TABLE public.aba_breeds_and_stages IS 'Relaciona los procesos de ARP con el consumo y mortalidad ';
            public       postgres    false    198            �           0    0    COLUMN aba_breeds_and_stages.id    COMMENT     o   COMMENT ON COLUMN public.aba_breeds_and_stages.id IS 'ID de la relación entre proceso, consumo y mortalidad';
            public       postgres    false    198            �           0    0 !   COLUMN aba_breeds_and_stages.code    COMMENT     v   COMMENT ON COLUMN public.aba_breeds_and_stages.code IS 'Código de la relación entre proceso, consumo y mortalidad';
            public       postgres    false    198                        0    0 !   COLUMN aba_breeds_and_stages.name    COMMENT     v   COMMENT ON COLUMN public.aba_breeds_and_stages.name IS 'Nombre de la relación entre proceso y consumo y mortalidad';
            public       postgres    false    198                       0    0 =   COLUMN aba_breeds_and_stages.id_aba_consumption_and_mortality    COMMENT     �   COMMENT ON COLUMN public.aba_breeds_and_stages.id_aba_consumption_and_mortality IS 'ID referente al consumo de las aves y la mortalidad por semana';
            public       postgres    false    198                       0    0 '   COLUMN aba_breeds_and_stages.id_process    COMMENT     l   COMMENT ON COLUMN public.aba_breeds_and_stages.id_process IS 'ID de referenica a los procesos del sistema';
            public       postgres    false    198            �            1259    136265 $   aba_consumption_and_mortality_id_seq    SEQUENCE     �   CREATE SEQUENCE public.aba_consumption_and_mortality_id_seq
    START WITH 8
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1;
 ;   DROP SEQUENCE public.aba_consumption_and_mortality_id_seq;
       public       postgres    false    3            �            1259    136267    aba_consumption_and_mortality    TABLE     ?  CREATE TABLE public.aba_consumption_and_mortality (
    id integer DEFAULT nextval('public.aba_consumption_and_mortality_id_seq'::regclass) NOT NULL,
    code character varying(100),
    name character varying(100),
    id_breed integer NOT NULL,
    id_stage integer NOT NULL,
    id_aba_time_unit integer NOT NULL
);
 1   DROP TABLE public.aba_consumption_and_mortality;
       public         postgres    false    199    3                       0    0 #   TABLE aba_consumption_and_mortality    COMMENT     �   COMMENT ON TABLE public.aba_consumption_and_mortality IS 'Almacena la información del consumo y mortalidad asociados a la combinación de raza y etapa';
            public       postgres    false    200                       0    0 '   COLUMN aba_consumption_and_mortality.id    COMMENT     �   COMMENT ON COLUMN public.aba_consumption_and_mortality.id IS 'ID de los datos de consumo y mortalidad asociados a una raza y una etapa';
            public       postgres    false    200                       0    0 )   COLUMN aba_consumption_and_mortality.code    COMMENT     �   COMMENT ON COLUMN public.aba_consumption_and_mortality.code IS 'Código de los datos de consumo y mortalidad asociados a una raza y una etapa ';
            public       postgres    false    200                       0    0 )   COLUMN aba_consumption_and_mortality.name    COMMENT     �   COMMENT ON COLUMN public.aba_consumption_and_mortality.name IS 'Nombre de los datos de consumo y mortalidad asociados a una raza y una etapa';
            public       postgres    false    200                       0    0 -   COLUMN aba_consumption_and_mortality.id_breed    COMMENT     �   COMMENT ON COLUMN public.aba_consumption_and_mortality.id_breed IS 'ID de la raza asociada a los datos de consumo y mortalidad';
            public       postgres    false    200                       0    0 -   COLUMN aba_consumption_and_mortality.id_stage    COMMENT     �   COMMENT ON COLUMN public.aba_consumption_and_mortality.id_stage IS 'ID de la etapa en la que se encuentran los datos de consumo y mortalidad ';
            public       postgres    false    200            	           0    0 5   COLUMN aba_consumption_and_mortality.id_aba_time_unit    COMMENT     �   COMMENT ON COLUMN public.aba_consumption_and_mortality.id_aba_time_unit IS 'ID de la unidad de tiempo utilizada en los datos cargados en consumo y mortalidad';
            public       postgres    false    200            �            1259    136271 +   aba_consumption_and_mortality_detail_id_seq    SEQUENCE     �   CREATE SEQUENCE public.aba_consumption_and_mortality_detail_id_seq
    START WITH 203
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1;
 B   DROP SEQUENCE public.aba_consumption_and_mortality_detail_id_seq;
       public       postgres    false    3            �            1259    136273 $   aba_consumption_and_mortality_detail    TABLE     =  CREATE TABLE public.aba_consumption_and_mortality_detail (
    id integer DEFAULT nextval('public.aba_consumption_and_mortality_detail_id_seq'::regclass) NOT NULL,
    id_aba_consumption_and_mortality integer NOT NULL,
    time_unit_number integer,
    consumption double precision,
    mortality double precision
);
 8   DROP TABLE public.aba_consumption_and_mortality_detail;
       public         postgres    false    201    3            
           0    0 *   TABLE aba_consumption_and_mortality_detail    COMMENT     �   COMMENT ON TABLE public.aba_consumption_and_mortality_detail IS 'Almacena los detalles para la unidad de tiempo asociada a una determinada agrupación de consumo y mortalidad ';
            public       postgres    false    202                       0    0 .   COLUMN aba_consumption_and_mortality_detail.id    COMMENT     �   COMMENT ON COLUMN public.aba_consumption_and_mortality_detail.id IS 'ID de los detalles para la unidad de tiempo asociada a una determinada agrupación de consumo y mortalidad ';
            public       postgres    false    202                       0    0 L   COLUMN aba_consumption_and_mortality_detail.id_aba_consumption_and_mortality    COMMENT     �   COMMENT ON COLUMN public.aba_consumption_and_mortality_detail.id_aba_consumption_and_mortality IS 'ID de la agrupación de consumo y mortalidad asociada';
            public       postgres    false    202                       0    0 <   COLUMN aba_consumption_and_mortality_detail.time_unit_number    COMMENT     �   COMMENT ON COLUMN public.aba_consumption_and_mortality_detail.time_unit_number IS 'Indica la unidad de tiempo asociada a la agrupacion de consumo y mortalidad';
            public       postgres    false    202                       0    0 7   COLUMN aba_consumption_and_mortality_detail.consumption    COMMENT     �   COMMENT ON COLUMN public.aba_consumption_and_mortality_detail.consumption IS 'Indica el consumo asociado a una determinada agrupación de consumo y mortalidad ';
            public       postgres    false    202                       0    0 5   COLUMN aba_consumption_and_mortality_detail.mortality    COMMENT     �   COMMENT ON COLUMN public.aba_consumption_and_mortality_detail.mortality IS 'Indica la mortalidad asociada a una determinada agrupación de consumo y mortalidad ';
            public       postgres    false    202            �            1259    136277    aba_elements_id_seq    SEQUENCE     �   CREATE SEQUENCE public.aba_elements_id_seq
    START WITH 22
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1;
 *   DROP SEQUENCE public.aba_elements_id_seq;
       public       postgres    false    3            �            1259    136279    aba_elements    TABLE       CREATE TABLE public.aba_elements (
    id integer DEFAULT nextval('public.aba_elements_id_seq'::regclass) NOT NULL,
    code character varying(100),
    name character varying(100),
    id_aba_element_property integer NOT NULL,
    equivalent_quantity double precision
);
     DROP TABLE public.aba_elements;
       public         postgres    false    203    3                       0    0    TABLE aba_elements    COMMENT     T   COMMENT ON TABLE public.aba_elements IS 'Almacena los datos de los macroelementos';
            public       postgres    false    204                       0    0    COLUMN aba_elements.id    COMMENT     D   COMMENT ON COLUMN public.aba_elements.id IS 'ID del macroelemento';
            public       postgres    false    204                       0    0    COLUMN aba_elements.code    COMMENT     K   COMMENT ON COLUMN public.aba_elements.code IS 'Código del macroelemento';
            public       postgres    false    204                       0    0    COLUMN aba_elements.name    COMMENT     J   COMMENT ON COLUMN public.aba_elements.name IS 'Nombre del macroelemento';
            public       postgres    false    204                       0    0 +   COLUMN aba_elements.id_aba_element_property    COMMENT     q   COMMENT ON COLUMN public.aba_elements.id_aba_element_property IS 'ID de la propiedad asociada al macroelemento';
            public       postgres    false    204                       0    0 '   COLUMN aba_elements.equivalent_quantity    COMMENT     �   COMMENT ON COLUMN public.aba_elements.equivalent_quantity IS 'Cantidad de la propiedad asociada al macroelemento con el fin de realizar equivalencias';
            public       postgres    false    204            �            1259    136283 &   aba_elements_and_concentrations_id_seq    SEQUENCE     �   CREATE SEQUENCE public.aba_elements_and_concentrations_id_seq
    START WITH 105
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1;
 =   DROP SEQUENCE public.aba_elements_and_concentrations_id_seq;
       public       postgres    false    3            �            1259    136285    aba_elements_and_concentrations    TABLE     }  CREATE TABLE public.aba_elements_and_concentrations (
    id integer DEFAULT nextval('public.aba_elements_and_concentrations_id_seq'::regclass) NOT NULL,
    id_aba_element integer NOT NULL,
    id_aba_formulation integer NOT NULL,
    proportion double precision,
    id_element_equivalent integer,
    id_aba_element_property integer,
    equivalent_quantity double precision
);
 3   DROP TABLE public.aba_elements_and_concentrations;
       public         postgres    false    205    3                       0    0 %   TABLE aba_elements_and_concentrations    COMMENT     y   COMMENT ON TABLE public.aba_elements_and_concentrations IS 'Asocia una fórmula con los macroelementos que la componen';
            public       postgres    false    206                       0    0 )   COLUMN aba_elements_and_concentrations.id    COMMENT     �   COMMENT ON COLUMN public.aba_elements_and_concentrations.id IS 'Id de la asociación entre una formula con los macroelementos que la componen';
            public       postgres    false    206                       0    0 5   COLUMN aba_elements_and_concentrations.id_aba_element    COMMENT     g   COMMENT ON COLUMN public.aba_elements_and_concentrations.id_aba_element IS 'Id del elemento asociado';
            public       postgres    false    206                       0    0 9   COLUMN aba_elements_and_concentrations.id_aba_formulation    COMMENT     l   COMMENT ON COLUMN public.aba_elements_and_concentrations.id_aba_formulation IS 'Id de la formula asociado';
            public       postgres    false    206                       0    0 1   COLUMN aba_elements_and_concentrations.proportion    COMMENT     x   COMMENT ON COLUMN public.aba_elements_and_concentrations.proportion IS 'Proporción del elemento dentro de la formula';
            public       postgres    false    206            �            1259    136289    aba_elements_properties_id_seq    SEQUENCE     �   CREATE SEQUENCE public.aba_elements_properties_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1;
 5   DROP SEQUENCE public.aba_elements_properties_id_seq;
       public       postgres    false    3            �            1259    136291    aba_elements_properties    TABLE     �   CREATE TABLE public.aba_elements_properties (
    id integer DEFAULT nextval('public.aba_elements_properties_id_seq'::regclass) NOT NULL,
    code character varying(100),
    name character varying(100)
);
 +   DROP TABLE public.aba_elements_properties;
       public         postgres    false    207    3                       0    0    TABLE aba_elements_properties    COMMENT     �   COMMENT ON TABLE public.aba_elements_properties IS 'Almacena las propiedades que pueden llegar a tener los macroelementos para realizar la equivalencia';
            public       postgres    false    208                       0    0 !   COLUMN aba_elements_properties.id    COMMENT     Z   COMMENT ON COLUMN public.aba_elements_properties.id IS 'Id de la propiedad del elemento';
            public       postgres    false    208                       0    0 #   COLUMN aba_elements_properties.code    COMMENT     _   COMMENT ON COLUMN public.aba_elements_properties.code IS 'Codigode la propiedad del elemento';
            public       postgres    false    208                       0    0 #   COLUMN aba_elements_properties.name    COMMENT     `   COMMENT ON COLUMN public.aba_elements_properties.name IS 'Nombre de la propiedad del elemento';
            public       postgres    false    208            �            1259    136295    aba_formulation_id_seq    SEQUENCE     �   CREATE SEQUENCE public.aba_formulation_id_seq
    START WITH 68
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1;
 -   DROP SEQUENCE public.aba_formulation_id_seq;
       public       postgres    false    3            �            1259    136297    aba_formulation    TABLE     �   CREATE TABLE public.aba_formulation (
    id integer DEFAULT nextval('public.aba_formulation_id_seq'::regclass) NOT NULL,
    code character varying(100),
    name character varying(100)
);
 #   DROP TABLE public.aba_formulation;
       public         postgres    false    209    3                       0    0    TABLE aba_formulation    COMMENT     g   COMMENT ON TABLE public.aba_formulation IS 'Almacena los datos del alimento balanceado para animales';
            public       postgres    false    210                        0    0    COLUMN aba_formulation.id    COMMENT     [   COMMENT ON COLUMN public.aba_formulation.id IS 'Id del alimento balanceado para animales';
            public       postgres    false    210            !           0    0    COLUMN aba_formulation.code    COMMENT     a   COMMENT ON COLUMN public.aba_formulation.code IS 'Codigo del alimento balanceado para animales';
            public       postgres    false    210            "           0    0    COLUMN aba_formulation.name    COMMENT     a   COMMENT ON COLUMN public.aba_formulation.name IS 'Nombre del alimento balanceado para animales';
            public       postgres    false    210            �            1259    136301    aba_results_id_seq    SEQUENCE     �   CREATE SEQUENCE public.aba_results_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1;
 )   DROP SEQUENCE public.aba_results_id_seq;
       public       postgres    false    3            �            1259    136303 &   aba_stages_of_breeds_and_stages_id_seq    SEQUENCE     �   CREATE SEQUENCE public.aba_stages_of_breeds_and_stages_id_seq
    START WITH 24
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1;
 =   DROP SEQUENCE public.aba_stages_of_breeds_and_stages_id_seq;
       public       postgres    false    3            �            1259    136305    aba_stages_of_breeds_and_stages    TABLE     '  CREATE TABLE public.aba_stages_of_breeds_and_stages (
    id integer DEFAULT nextval('public.aba_stages_of_breeds_and_stages_id_seq'::regclass) NOT NULL,
    id_aba_breeds_and_stages integer NOT NULL,
    id_formulation integer NOT NULL,
    name character varying(100),
    duration integer
);
 3   DROP TABLE public.aba_stages_of_breeds_and_stages;
       public         postgres    false    212    3            #           0    0 %   TABLE aba_stages_of_breeds_and_stages    COMMENT     �   COMMENT ON TABLE public.aba_stages_of_breeds_and_stages IS 'Almacena las fases asociadas a los animales considerados en la tabla de consumo y mortalidad y asocia el alimento a ser proporcionado en dicha fase';
            public       postgres    false    213            $           0    0 )   COLUMN aba_stages_of_breeds_and_stages.id    COMMENT     �   COMMENT ON COLUMN public.aba_stages_of_breeds_and_stages.id IS 'Id de la fase asociadas a los animales considerados en la tabla de consumo y mortalidad ';
            public       postgres    false    213            %           0    0 ?   COLUMN aba_stages_of_breeds_and_stages.id_aba_breeds_and_stages    COMMENT     �   COMMENT ON COLUMN public.aba_stages_of_breeds_and_stages.id_aba_breeds_and_stages IS 'Id de la tabla que almacena la relacion entre proceso y consumo y mortalidad';
            public       postgres    false    213            &           0    0 5   COLUMN aba_stages_of_breeds_and_stages.id_formulation    COMMENT     �   COMMENT ON COLUMN public.aba_stages_of_breeds_and_stages.id_formulation IS 'Id del alimento balanceado para animales asociado a la fase';
            public       postgres    false    213            '           0    0 +   COLUMN aba_stages_of_breeds_and_stages.name    COMMENT     �   COMMENT ON COLUMN public.aba_stages_of_breeds_and_stages.name IS 'Nombre de la fase asociadas a los animales considerados en la tabla de consumo y mortalidad ';
            public       postgres    false    213            (           0    0 /   COLUMN aba_stages_of_breeds_and_stages.duration    COMMENT     �   COMMENT ON COLUMN public.aba_stages_of_breeds_and_stages.duration IS 'Duracion de la fase asociadas a los animales considerados en la tabla de consumo y mortalidad ';
            public       postgres    false    213            �            1259    136309    aba_time_unit    TABLE     �   CREATE TABLE public.aba_time_unit (
    id integer DEFAULT nextval('public."abaTimeUnit_id_seq"'::regclass) NOT NULL,
    singular_name character varying(100),
    plural_name character varying(100)
);
 !   DROP TABLE public.aba_time_unit;
       public         postgres    false    196    3            )           0    0    TABLE aba_time_unit    COMMENT     L   COMMENT ON TABLE public.aba_time_unit IS 'Almacena las unidades de tiempo';
            public       postgres    false    214            *           0    0    COLUMN aba_time_unit.id    COMMENT     K   COMMENT ON COLUMN public.aba_time_unit.id IS 'Id de la unidad de tiempo
';
            public       postgres    false    214            +           0    0 "   COLUMN aba_time_unit.singular_name    COMMENT     e   COMMENT ON COLUMN public.aba_time_unit.singular_name IS 'Nombre en singular de la unidad de tiempo';
            public       postgres    false    214            ,           0    0     COLUMN aba_time_unit.plural_name    COMMENT     a   COMMENT ON COLUMN public.aba_time_unit.plural_name IS 'Nombre en plural de la unidad de tiempo';
            public       postgres    false    214            �            1259    136313    availability_shed_id_seq    SEQUENCE     �   CREATE SEQUENCE public.availability_shed_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.availability_shed_id_seq;
       public       postgres    false    3            �            1259    136315    base_day_id_seq    SEQUENCE     x   CREATE SEQUENCE public.base_day_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.base_day_id_seq;
       public       postgres    false    3            �            1259    136317    breed_id_seq    SEQUENCE     u   CREATE SEQUENCE public.breed_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.breed_id_seq;
       public       postgres    false    3            �            1259    136319    broiler_detail_id_seq    SEQUENCE     ~   CREATE SEQUENCE public.broiler_detail_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.broiler_detail_id_seq;
       public       postgres    false    3            �            1259    136321    broiler_id_seq    SEQUENCE     w   CREATE SEQUENCE public.broiler_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.broiler_id_seq;
       public       postgres    false    3            �            1259    136323    broiler_product_detail_id_seq    SEQUENCE     �   CREATE SEQUENCE public.broiler_product_detail_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 4   DROP SEQUENCE public.broiler_product_detail_id_seq;
       public       postgres    false    3            �            1259    136325    broiler_product_id_seq    SEQUENCE        CREATE SEQUENCE public.broiler_product_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.broiler_product_id_seq;
       public       postgres    false    3            �            1259    136327    broilereviction_detail_id_seq    SEQUENCE     �   CREATE SEQUENCE public.broilereviction_detail_id_seq
    START WITH 124
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 4   DROP SEQUENCE public.broilereviction_detail_id_seq;
       public       postgres    false    3            �            1259    136329    broilereviction_id_seq    SEQUENCE     �   CREATE SEQUENCE public.broilereviction_id_seq
    START WITH 70
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.broilereviction_id_seq;
       public       postgres    false    3            �            1259    136331    brooder_id_seq    SEQUENCE     w   CREATE SEQUENCE public.brooder_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.brooder_id_seq;
       public       postgres    false    3            �            1259    136333    brooder_machines_id_seq    SEQUENCE     �   CREATE SEQUENCE public.brooder_machines_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.brooder_machines_id_seq;
       public       postgres    false    3            �            1259    136335    calendar_day_id_seq    SEQUENCE     |   CREATE SEQUENCE public.calendar_day_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.calendar_day_id_seq;
       public       postgres    false    3            �            1259    136337    calendar_id_seq    SEQUENCE     x   CREATE SEQUENCE public.calendar_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.calendar_id_seq;
       public       postgres    false    3            �            1259    136339    center_id_seq    SEQUENCE     v   CREATE SEQUENCE public.center_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.center_id_seq;
       public       postgres    false    3            �            1259    136341    egg_planning_id_seq    SEQUENCE     |   CREATE SEQUENCE public.egg_planning_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.egg_planning_id_seq;
       public       postgres    false    3            �            1259    136343    egg_required_id_seq    SEQUENCE     |   CREATE SEQUENCE public.egg_required_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.egg_required_id_seq;
       public       postgres    false    3            �            1259    136345    eggs_storage_id_seq    SEQUENCE     |   CREATE SEQUENCE public.eggs_storage_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.eggs_storage_id_seq;
       public       postgres    false    3            �            1259    136347    farm_id_seq    SEQUENCE     t   CREATE SEQUENCE public.farm_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 "   DROP SEQUENCE public.farm_id_seq;
       public       postgres    false    3            �            1259    136349    farm_type_id_seq    SEQUENCE     y   CREATE SEQUENCE public.farm_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.farm_type_id_seq;
       public       postgres    false    3            �            1259    136351    holiday_id_seq    SEQUENCE     w   CREATE SEQUENCE public.holiday_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.holiday_id_seq;
       public       postgres    false    3            �            1259    136353    housing_way_detail_id_seq    SEQUENCE     �   CREATE SEQUENCE public.housing_way_detail_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.housing_way_detail_id_seq;
       public       postgres    false    3            �            1259    136355    housing_way_id_seq    SEQUENCE     {   CREATE SEQUENCE public.housing_way_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.housing_way_id_seq;
       public       postgres    false    3            �            1259    136357    incubator_id_seq    SEQUENCE     y   CREATE SEQUENCE public.incubator_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.incubator_id_seq;
       public       postgres    false    3            �            1259    136359    incubator_plant_id_seq    SEQUENCE        CREATE SEQUENCE public.incubator_plant_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.incubator_plant_id_seq;
       public       postgres    false    3            �            1259    136361    industry_id_seq    SEQUENCE     x   CREATE SEQUENCE public.industry_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.industry_id_seq;
       public       postgres    false    3            �            1259    136363    line_id_seq    SEQUENCE     t   CREATE SEQUENCE public.line_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 "   DROP SEQUENCE public.line_id_seq;
       public       postgres    false    3            �            1259    136365    lot_eggs_id_seq    SEQUENCE     x   CREATE SEQUENCE public.lot_eggs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.lot_eggs_id_seq;
       public       postgres    false    3            �            1259    136367    lot_fattening_id_seq    SEQUENCE     }   CREATE SEQUENCE public.lot_fattening_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.lot_fattening_id_seq;
       public       postgres    false    3            �            1259    136369 
   lot_id_seq    SEQUENCE     s   CREATE SEQUENCE public.lot_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 !   DROP SEQUENCE public.lot_id_seq;
       public       postgres    false    3            �            1259    136371    lot_liftbreeding_id_seq    SEQUENCE     �   CREATE SEQUENCE public.lot_liftbreeding_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.lot_liftbreeding_id_seq;
       public       postgres    false    3            �            1259    136373    md_optimizer_parameter    TABLE       CREATE TABLE public.md_optimizer_parameter (
    optimizerparameter_id integer NOT NULL,
    breed_id integer NOT NULL,
    max_housing integer NOT NULL,
    min_housing integer NOT NULL,
    difference double precision NOT NULL,
    active boolean NOT NULL
);
 *   DROP TABLE public.md_optimizer_parameter;
       public         postgres    false    3            �            1259    136376 0   md_optimizer_parameter_optimizerparameter_id_seq    SEQUENCE     �   CREATE SEQUENCE public.md_optimizer_parameter_optimizerparameter_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 G   DROP SEQUENCE public.md_optimizer_parameter_optimizerparameter_id_seq;
       public       postgres    false    3    245            -           0    0 0   md_optimizer_parameter_optimizerparameter_id_seq    SEQUENCE OWNED BY     �   ALTER SEQUENCE public.md_optimizer_parameter_optimizerparameter_id_seq OWNED BY public.md_optimizer_parameter.optimizerparameter_id;
            public       postgres    false    246            �            1259    136378    mdadjustment    TABLE     �   CREATE TABLE public.mdadjustment (
    adjustment_id integer NOT NULL,
    type character varying NOT NULL,
    prefix character varying,
    description character varying NOT NULL
);
     DROP TABLE public.mdadjustment;
       public         postgres    false    3            �            1259    136384    mdadjustment_adjustment_id_seq    SEQUENCE     �   CREATE SEQUENCE public.mdadjustment_adjustment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 5   DROP SEQUENCE public.mdadjustment_adjustment_id_seq;
       public       postgres    false    247    3            .           0    0    mdadjustment_adjustment_id_seq    SEQUENCE OWNED BY     a   ALTER SEQUENCE public.mdadjustment_adjustment_id_seq OWNED BY public.mdadjustment.adjustment_id;
            public       postgres    false    248            �            1259    136386     mdapplication_application_id_seq    SEQUENCE     �   CREATE SEQUENCE public.mdapplication_application_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 999999999999999
    CACHE 1;
 7   DROP SEQUENCE public.mdapplication_application_id_seq;
       public       postgres    false    3            �            1259    136388    mdapplication    TABLE     �   CREATE TABLE public.mdapplication (
    application_id integer DEFAULT nextval('public.mdapplication_application_id_seq'::regclass) NOT NULL,
    application_name character varying(30) NOT NULL,
    type character varying(20)
);
 !   DROP TABLE public.mdapplication;
       public         postgres    false    249    3            /           0    0    TABLE mdapplication    COMMENT     X   COMMENT ON TABLE public.mdapplication IS 'Almacena la informacion de las aplicaciones';
            public       postgres    false    250            0           0    0 #   COLUMN mdapplication.application_id    COMMENT     P   COMMENT ON COLUMN public.mdapplication.application_id IS 'Id de la aplicació';
            public       postgres    false    250            1           0    0 %   COLUMN mdapplication.application_name    COMMENT     W   COMMENT ON COLUMN public.mdapplication.application_name IS 'Nombre de la aplicación';
            public       postgres    false    250            2           0    0    COLUMN mdapplication.type    COMMENT     W   COMMENT ON COLUMN public.mdapplication.type IS 'A qué tipo pertenece la aplicación';
            public       postgres    false    250            �            1259    136392    mdapplication_rol_id_seq    SEQUENCE     �   CREATE SEQUENCE public.mdapplication_rol_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 9999999999999
    CACHE 1;
 /   DROP SEQUENCE public.mdapplication_rol_id_seq;
       public       postgres    false    3            �            1259    136394    mdapplication_rol    TABLE     �   CREATE TABLE public.mdapplication_rol (
    id integer DEFAULT nextval('public.mdapplication_rol_id_seq'::regclass) NOT NULL,
    application_id integer NOT NULL,
    rol_id integer NOT NULL
);
 %   DROP TABLE public.mdapplication_rol;
       public         postgres    false    251    3            3           0    0    TABLE mdapplication_rol    COMMENT     _   COMMENT ON TABLE public.mdapplication_rol IS 'Contiene los id de aplicación y los id de rol';
            public       postgres    false    252            4           0    0    COLUMN mdapplication_rol.id    COMMENT     \   COMMENT ON COLUMN public.mdapplication_rol.id IS 'Id la combinacion de aplicación y rol ';
            public       postgres    false    252            5           0    0 '   COLUMN mdapplication_rol.application_id    COMMENT     `   COMMENT ON COLUMN public.mdapplication_rol.application_id IS 'Identificador de la aplicación';
            public       postgres    false    252            6           0    0    COLUMN mdapplication_rol.rol_id    COMMENT     N   COMMENT ON COLUMN public.mdapplication_rol.rol_id IS 'Identificador del rol';
            public       postgres    false    252            �            1259    136398    mdbreed    TABLE     �   CREATE TABLE public.mdbreed (
    breed_id integer DEFAULT nextval('public.breed_id_seq'::regclass) NOT NULL,
    code character varying(20) NOT NULL,
    name character varying(45) NOT NULL
);
    DROP TABLE public.mdbreed;
       public         postgres    false    217    3            7           0    0    TABLE mdbreed    COMMENT     U   COMMENT ON TABLE public.mdbreed IS 'Tabla donde se almacenan las razas de las aves';
            public       postgres    false    253            8           0    0    COLUMN mdbreed.breed_id    COMMENT     >   COMMENT ON COLUMN public.mdbreed.breed_id IS 'Id de la raza';
            public       postgres    false    253            9           0    0    COLUMN mdbreed.code    COMMENT     >   COMMENT ON COLUMN public.mdbreed.code IS 'Codigo de la raza';
            public       postgres    false    253            :           0    0    COLUMN mdbreed.name    COMMENT     >   COMMENT ON COLUMN public.mdbreed.name IS 'Nombre de la Raza';
            public       postgres    false    253            �            1259    136402    mdbroiler_product    TABLE     �  CREATE TABLE public.mdbroiler_product (
    broiler_product_id integer DEFAULT nextval('public.broiler_product_id_seq'::regclass) NOT NULL,
    name character varying(45) NOT NULL,
    days_eviction integer,
    weight double precision,
    code character varying(20),
    breed_id integer NOT NULL,
    gender "char" NOT NULL,
    min_days_eviction integer,
    conversion_percentage double precision,
    type_bird "char",
    initial_product integer
);
 %   DROP TABLE public.mdbroiler_product;
       public         postgres    false    221    3            ;           0    0    TABLE mdbroiler_product    COMMENT     w   COMMENT ON TABLE public.mdbroiler_product IS 'Almacena los productos de salida de la etapa de engorda hacia desalojo';
            public       postgres    false    254            <           0    0 +   COLUMN mdbroiler_product.broiler_product_id    COMMENT     ^   COMMENT ON COLUMN public.mdbroiler_product.broiler_product_id IS 'Id de producto de engorde';
            public       postgres    false    254            =           0    0    COLUMN mdbroiler_product.name    COMMENT     T   COMMENT ON COLUMN public.mdbroiler_product.name IS 'Nombre de producto de engorde';
            public       postgres    false    254            >           0    0 &   COLUMN mdbroiler_product.days_eviction    COMMENT     y   COMMENT ON COLUMN public.mdbroiler_product.days_eviction IS 'Días necesarios para el desalojo del producto de engorde';
            public       postgres    false    254            ?           0    0    COLUMN mdbroiler_product.weight    COMMENT     b   COMMENT ON COLUMN public.mdbroiler_product.weight IS 'Peso estimado del producto para su salida';
            public       postgres    false    254            �            1259    136406    mdequivalenceproduct    TABLE     �   CREATE TABLE public.mdequivalenceproduct (
    equivalenceproduct_id integer NOT NULL,
    product_code character varying(20),
    equivalence_code character varying(20),
    breed_id integer
);
 (   DROP TABLE public.mdequivalenceproduct;
       public         postgres    false    3                        1259    136409 .   mdequivalenceproduct_equivalenceproduct_id_seq    SEQUENCE     �   CREATE SEQUENCE public.mdequivalenceproduct_equivalenceproduct_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 E   DROP SEQUENCE public.mdequivalenceproduct_equivalenceproduct_id_seq;
       public       postgres    false    255    3            @           0    0 .   mdequivalenceproduct_equivalenceproduct_id_seq    SEQUENCE OWNED BY     �   ALTER SEQUENCE public.mdequivalenceproduct_equivalenceproduct_id_seq OWNED BY public.mdequivalenceproduct.equivalenceproduct_id;
            public       postgres    false    256                       1259    136411 
   mdfarmtype    TABLE     �   CREATE TABLE public.mdfarmtype (
    farm_type_id integer DEFAULT nextval('public.farm_type_id_seq'::regclass) NOT NULL,
    name character varying(45) NOT NULL
);
    DROP TABLE public.mdfarmtype;
       public         postgres    false    233    3            A           0    0    TABLE mdfarmtype    COMMENT     D   COMMENT ON TABLE public.mdfarmtype IS 'Define los tipos de granja';
            public       postgres    false    257            B           0    0    COLUMN mdfarmtype.farm_type_id    COMMENT     L   COMMENT ON COLUMN public.mdfarmtype.farm_type_id IS 'Id de tipo de granja';
            public       postgres    false    257            C           0    0    COLUMN mdfarmtype.name    COMMENT     O   COMMENT ON COLUMN public.mdfarmtype.name IS 'Nombre de la etapa de la granja';
            public       postgres    false    257                       1259    136415    measure_id_seq    SEQUENCE     w   CREATE SEQUENCE public.measure_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.measure_id_seq;
       public       postgres    false    3                       1259    136417 	   mdmeasure    TABLE     -  CREATE TABLE public.mdmeasure (
    measure_id integer DEFAULT nextval('public.measure_id_seq'::regclass) NOT NULL,
    name character varying(10) NOT NULL,
    abbreviation character varying(5) NOT NULL,
    originvalue double precision NOT NULL,
    valuekg double precision,
    is_unit boolean
);
    DROP TABLE public.mdmeasure;
       public         postgres    false    258    3            D           0    0    TABLE mdmeasure    COMMENT     _   COMMENT ON TABLE public.mdmeasure IS 'Almacena las medidas a utilizar en las planificaciones';
            public       postgres    false    259            E           0    0    COLUMN mdmeasure.measure_id    COMMENT     D   COMMENT ON COLUMN public.mdmeasure.measure_id IS 'Id de la medida';
            public       postgres    false    259            F           0    0    COLUMN mdmeasure.name    COMMENT     B   COMMENT ON COLUMN public.mdmeasure.name IS 'Nombre de la medida';
            public       postgres    false    259            G           0    0    COLUMN mdmeasure.abbreviation    COMMENT     O   COMMENT ON COLUMN public.mdmeasure.abbreviation IS 'Abreviatura de la medida';
            public       postgres    false    259            H           0    0    COLUMN mdmeasure.originvalue    COMMENT     Q   COMMENT ON COLUMN public.mdmeasure.originvalue IS 'Valor original de la medida';
            public       postgres    false    259            I           0    0    COLUMN mdmeasure.valuekg    COMMENT     R   COMMENT ON COLUMN public.mdmeasure.valuekg IS 'Valor en Kilogramos de la medida';
            public       postgres    false    259                       1259    136421    parameter_id_seq    SEQUENCE     y   CREATE SEQUENCE public.parameter_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.parameter_id_seq;
       public       postgres    false    3                       1259    136423    mdparameter    TABLE     9  CREATE TABLE public.mdparameter (
    parameter_id integer DEFAULT nextval('public.parameter_id_seq'::regclass) NOT NULL,
    description character varying(250) NOT NULL,
    type character varying(10),
    measure_id integer NOT NULL,
    process_id integer NOT NULL,
    name character varying(250) NOT NULL
);
    DROP TABLE public.mdparameter;
       public         postgres    false    260    3            J           0    0    TABLE mdparameter    COMMENT     �   COMMENT ON TABLE public.mdparameter IS 'Almacena la definición de los parámetros a utilizar en la planificación regresiva junto a sus respectivas características';
            public       postgres    false    261            K           0    0    COLUMN mdparameter.parameter_id    COMMENT     N   COMMENT ON COLUMN public.mdparameter.parameter_id IS 'Id de los parámetros';
            public       postgres    false    261            L           0    0    COLUMN mdparameter.description    COMMENT     W   COMMENT ON COLUMN public.mdparameter.description IS 'Descripción de los parámetros';
            public       postgres    false    261            M           0    0    COLUMN mdparameter.type    COMMENT     D   COMMENT ON COLUMN public.mdparameter.type IS 'Tipo de parámetros';
            public       postgres    false    261            N           0    0    COLUMN mdparameter.measure_id    COMMENT     F   COMMENT ON COLUMN public.mdparameter.measure_id IS 'Id de la medida';
            public       postgres    false    261            O           0    0    COLUMN mdparameter.process_id    COMMENT     E   COMMENT ON COLUMN public.mdparameter.process_id IS 'Id del proceso';
            public       postgres    false    261            P           0    0    COLUMN mdparameter.name    COMMENT     F   COMMENT ON COLUMN public.mdparameter.name IS 'Nombre del parámetro';
            public       postgres    false    261                       1259    136430    process_id_seq    SEQUENCE     w   CREATE SEQUENCE public.process_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.process_id_seq;
       public       postgres    false    3                       1259    136432 	   mdprocess    TABLE     =  CREATE TABLE public.mdprocess (
    process_id integer DEFAULT nextval('public.process_id_seq'::regclass) NOT NULL,
    process_order integer NOT NULL,
    product_id integer NOT NULL,
    stage_id integer NOT NULL,
    historical_decrease double precision NOT NULL,
    theoretical_decrease double precision NOT NULL,
    historical_weight double precision NOT NULL,
    theoretical_weight double precision NOT NULL,
    historical_duration integer NOT NULL,
    theoretical_duration integer NOT NULL,
    visible boolean,
    name character varying(250) NOT NULL,
    predecessor_id integer,
    capacity integer NOT NULL,
    breed_id integer NOT NULL,
    gender character varying(30),
    fattening_goal double precision,
    type_posture character varying(30),
    biological_active boolean,
    sync_considered boolean
);
    DROP TABLE public.mdprocess;
       public         postgres    false    262    3            Q           0    0    TABLE mdprocess    COMMENT     �   COMMENT ON TABLE public.mdprocess IS 'Almacena los procesos definidos para la planificación progresiva junto a sus respectivas características';
            public       postgres    false    263            R           0    0    COLUMN mdprocess.process_id    COMMENT     G   COMMENT ON COLUMN public.mdprocess.process_id IS 'Id de los procesos';
            public       postgres    false    263            S           0    0    COLUMN mdprocess.process_order    COMMENT     M   COMMENT ON COLUMN public.mdprocess.process_order IS 'Orden de los procesos';
            public       postgres    false    263            T           0    0    COLUMN mdprocess.product_id    COMMENT     D   COMMENT ON COLUMN public.mdprocess.product_id IS 'Id del producto';
            public       postgres    false    263            U           0    0    COLUMN mdprocess.stage_id    COMMENT     >   COMMENT ON COLUMN public.mdprocess.stage_id IS 'Id de etapa';
            public       postgres    false    263            V           0    0 $   COLUMN mdprocess.historical_decrease    COMMENT     Y   COMMENT ON COLUMN public.mdprocess.historical_decrease IS 'Merma historica del proceso';
            public       postgres    false    263            W           0    0 %   COLUMN mdprocess.theoretical_decrease    COMMENT     Y   COMMENT ON COLUMN public.mdprocess.theoretical_decrease IS 'Merma teórica del proceso';
            public       postgres    false    263            X           0    0 "   COLUMN mdprocess.historical_weight    COMMENT     V   COMMENT ON COLUMN public.mdprocess.historical_weight IS 'Peso historico del proceso';
            public       postgres    false    263            Y           0    0 #   COLUMN mdprocess.theoretical_weight    COMMENT     V   COMMENT ON COLUMN public.mdprocess.theoretical_weight IS 'Peso teórico del proceso';
            public       postgres    false    263            Z           0    0 $   COLUMN mdprocess.historical_duration    COMMENT     ^   COMMENT ON COLUMN public.mdprocess.historical_duration IS 'Duración histórica del proceso';
            public       postgres    false    263            [           0    0 %   COLUMN mdprocess.theoretical_duration    COMMENT     ]   COMMENT ON COLUMN public.mdprocess.theoretical_duration IS 'Duración teórica del proceso';
            public       postgres    false    263            \           0    0    COLUMN mdprocess.visible    COMMENT     I   COMMENT ON COLUMN public.mdprocess.visible IS 'Visibilidad del proceso';
            public       postgres    false    263            ]           0    0    COLUMN mdprocess.name    COMMENT     A   COMMENT ON COLUMN public.mdprocess.name IS 'Nombre del proceso';
            public       postgres    false    263            ^           0    0    COLUMN mdprocess.predecessor_id    COMMENT     J   COMMENT ON COLUMN public.mdprocess.predecessor_id IS 'Id del predecesor';
            public       postgres    false    263            _           0    0    COLUMN mdprocess.capacity    COMMENT     X   COMMENT ON COLUMN public.mdprocess.capacity IS 'Capacidad semanal asociada al proceso';
            public       postgres    false    263            `           0    0    COLUMN mdprocess.breed_id    COMMENT     @   COMMENT ON COLUMN public.mdprocess.breed_id IS 'Id de la raza';
            public       postgres    false    263            a           0    0    COLUMN mdprocess.gender    COMMENT     N   COMMENT ON COLUMN public.mdprocess.gender IS 'Genero del producto de salida';
            public       postgres    false    263            b           0    0    COLUMN mdprocess.fattening_goal    COMMENT     H   COMMENT ON COLUMN public.mdprocess.fattening_goal IS 'Meta de engorde';
            public       postgres    false    263            c           0    0    COLUMN mdprocess.type_posture    COMMENT     s   COMMENT ON COLUMN public.mdprocess.type_posture IS 'Define el tipo de postura de acuerdo a la edad de la gallina';
            public       postgres    false    263            d           0    0 "   COLUMN mdprocess.biological_active    COMMENT     h   COMMENT ON COLUMN public.mdprocess.biological_active IS 'Define si el proceso es un activo biológico';
            public       postgres    false    263                       1259    136436    product_id_seq    SEQUENCE     w   CREATE SEQUENCE public.product_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.product_id_seq;
       public       postgres    false    3            	           1259    136438 	   mdproduct    TABLE       CREATE TABLE public.mdproduct (
    product_id integer DEFAULT nextval('public.product_id_seq'::regclass) NOT NULL,
    code character varying(20) NOT NULL,
    name character varying(45) NOT NULL,
    breed_id integer NOT NULL,
    stage_id integer NOT NULL
);
    DROP TABLE public.mdproduct;
       public         postgres    false    264    3            e           0    0    TABLE mdproduct    COMMENT     Z   COMMENT ON TABLE public.mdproduct IS 'Almacena los productos utilizados en los procesos';
            public       postgres    false    265            f           0    0    COLUMN mdproduct.product_id    COMMENT     D   COMMENT ON COLUMN public.mdproduct.product_id IS 'Id del producto';
            public       postgres    false    265            g           0    0    COLUMN mdproduct.code    COMMENT     B   COMMENT ON COLUMN public.mdproduct.code IS 'Codigo del producto';
            public       postgres    false    265            h           0    0    COLUMN mdproduct.name    COMMENT     B   COMMENT ON COLUMN public.mdproduct.name IS 'Nombre del producto';
            public       postgres    false    265            
           1259    136442    mdrol_rol_id_seq    SEQUENCE        CREATE SEQUENCE public.mdrol_rol_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 10000000
    CACHE 1;
 '   DROP SEQUENCE public.mdrol_rol_id_seq;
       public       postgres    false    3                       1259    136444    mdrol    TABLE     �   CREATE TABLE public.mdrol (
    rol_id integer DEFAULT nextval('public.mdrol_rol_id_seq'::regclass) NOT NULL,
    rol_name character varying(80) NOT NULL,
    admin_user_creator integer NOT NULL,
    creation_date timestamp with time zone NOT NULL
);
    DROP TABLE public.mdrol;
       public         postgres    false    266    3            i           0    0    TABLE mdrol    COMMENT     O   COMMENT ON TABLE public.mdrol IS 'Almacena los datos de los diferentes roles';
            public       postgres    false    267            j           0    0    COLUMN mdrol.rol_id    COMMENT     7   COMMENT ON COLUMN public.mdrol.rol_id IS 'Id del rol';
            public       postgres    false    267            k           0    0    COLUMN mdrol.rol_name    COMMENT     =   COMMENT ON COLUMN public.mdrol.rol_name IS 'Nombre del rol';
            public       postgres    false    267            l           0    0    COLUMN mdrol.admin_user_creator    COMMENT     [   COMMENT ON COLUMN public.mdrol.admin_user_creator IS 'Especifica que usuario creo el rol';
            public       postgres    false    267            m           0    0    COLUMN mdrol.creation_date    COMMENT     N   COMMENT ON COLUMN public.mdrol.creation_date IS 'Fecha de creación del rol';
            public       postgres    false    267                       1259    136448    scenario_id_seq    SEQUENCE     x   CREATE SEQUENCE public.scenario_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.scenario_id_seq;
       public       postgres    false    3                       1259    136450 
   mdscenario    TABLE     ]  CREATE TABLE public.mdscenario (
    scenario_id integer DEFAULT nextval('public.scenario_id_seq'::regclass) NOT NULL,
    description character varying(250) NOT NULL,
    date_start timestamp with time zone NOT NULL,
    date_end timestamp with time zone NOT NULL,
    name character varying(250) NOT NULL,
    status integer DEFAULT 0 NOT NULL
);
    DROP TABLE public.mdscenario;
       public         postgres    false    268    3            n           0    0    TABLE mdscenario    COMMENT     [   COMMENT ON TABLE public.mdscenario IS 'Almacena información de los distintos escenarios';
            public       postgres    false    269            o           0    0    COLUMN mdscenario.scenario_id    COMMENT     G   COMMENT ON COLUMN public.mdscenario.scenario_id IS 'Id del escenario';
            public       postgres    false    269            p           0    0    COLUMN mdscenario.description    COMMENT     P   COMMENT ON COLUMN public.mdscenario.description IS 'Descripcion del escenario';
            public       postgres    false    269            q           0    0    COLUMN mdscenario.date_start    COMMENT     S   COMMENT ON COLUMN public.mdscenario.date_start IS 'Fecha de inicio del escenario';
            public       postgres    false    269            r           0    0    COLUMN mdscenario.date_end    COMMENT     N   COMMENT ON COLUMN public.mdscenario.date_end IS 'Fecha de fin del escenario';
            public       postgres    false    269            s           0    0    COLUMN mdscenario.name    COMMENT     D   COMMENT ON COLUMN public.mdscenario.name IS 'Nombre del escenario';
            public       postgres    false    269            t           0    0    COLUMN mdscenario.status    COMMENT     F   COMMENT ON COLUMN public.mdscenario.status IS 'Estado del escenario';
            public       postgres    false    269                       1259    136458    status_shed_id_seq    SEQUENCE     {   CREATE SEQUENCE public.status_shed_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.status_shed_id_seq;
       public       postgres    false    3                       1259    136460    mdshedstatus    TABLE     �   CREATE TABLE public.mdshedstatus (
    shed_status_id integer DEFAULT nextval('public.status_shed_id_seq'::regclass) NOT NULL,
    name character varying(50) NOT NULL,
    description character varying(250) NOT NULL
);
     DROP TABLE public.mdshedstatus;
       public         postgres    false    270    3            u           0    0    TABLE mdshedstatus    COMMENT     b   COMMENT ON TABLE public.mdshedstatus IS 'Almaceno los estatus de disponibilidad de los galpones';
            public       postgres    false    271            v           0    0 "   COLUMN mdshedstatus.shed_status_id    COMMENT     T   COMMENT ON COLUMN public.mdshedstatus.shed_status_id IS 'Id del estado del galpon';
            public       postgres    false    271            w           0    0    COLUMN mdshedstatus.name    COMMENT     a   COMMENT ON COLUMN public.mdshedstatus.name IS 'Nombre del estado en que se encuentra el galpon';
            public       postgres    false    271            x           0    0    COLUMN mdshedstatus.description    COMMENT     [   COMMENT ON COLUMN public.mdshedstatus.description IS 'Descripcion del estado del galpon
';
            public       postgres    false    271                       1259    136464    stage_id_seq    SEQUENCE     u   CREATE SEQUENCE public.stage_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.stage_id_seq;
       public       postgres    false    3                       1259    136466    mdstage    TABLE     �   CREATE TABLE public.mdstage (
    stage_id integer DEFAULT nextval('public.stage_id_seq'::regclass) NOT NULL,
    order_ integer NOT NULL,
    name character varying(250) NOT NULL
);
    DROP TABLE public.mdstage;
       public         postgres    false    272    3            y           0    0    TABLE mdstage    COMMENT     d   COMMENT ON TABLE public.mdstage IS 'Almacena las etapas a utilizar en el proceso de planificacion';
            public       postgres    false    273            z           0    0    COLUMN mdstage.stage_id    COMMENT     ?   COMMENT ON COLUMN public.mdstage.stage_id IS 'Id de la etapa';
            public       postgres    false    273            {           0    0    COLUMN mdstage.order_    COMMENT     U   COMMENT ON COLUMN public.mdstage.order_ IS 'Orden en el que se muestras las etapas';
            public       postgres    false    273            |           0    0    COLUMN mdstage.name    COMMENT     ?   COMMENT ON COLUMN public.mdstage.name IS 'Nombre de la etapa';
            public       postgres    false    273                       1259    136470    mduser_user_id_seq    SEQUENCE     �   CREATE SEQUENCE public.mduser_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 9999999999
    CACHE 1;
 )   DROP SEQUENCE public.mduser_user_id_seq;
       public       postgres    false    3                       1259    136472    mduser    TABLE     �  CREATE TABLE public.mduser (
    user_id integer DEFAULT nextval('public.mduser_user_id_seq'::regclass) NOT NULL,
    username character varying(80) NOT NULL,
    password character varying(10000000) NOT NULL,
    name character varying(80) NOT NULL,
    lastname character varying(80) NOT NULL,
    active boolean NOT NULL,
    admi_user_creator integer NOT NULL,
    rol_id integer NOT NULL,
    creation_date timestamp with time zone NOT NULL
);
    DROP TABLE public.mduser;
       public         postgres    false    274    3                       1259    136479    osadjustmentscontrol    TABLE     �   CREATE TABLE public.osadjustmentscontrol (
    adjustmentscontrol_id integer NOT NULL,
    username character varying NOT NULL,
    adjustment_date date NOT NULL,
    os_type character varying NOT NULL,
    os_id integer NOT NULL
);
 (   DROP TABLE public.osadjustmentscontrol;
       public         postgres    false    3                       1259    136485 .   osadjustmentscontrol_adjustmentscontrol_id_seq    SEQUENCE     �   CREATE SEQUENCE public.osadjustmentscontrol_adjustmentscontrol_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 E   DROP SEQUENCE public.osadjustmentscontrol_adjustmentscontrol_id_seq;
       public       postgres    false    3    276            }           0    0 .   osadjustmentscontrol_adjustmentscontrol_id_seq    SEQUENCE OWNED BY     �   ALTER SEQUENCE public.osadjustmentscontrol_adjustmentscontrol_id_seq OWNED BY public.osadjustmentscontrol.adjustmentscontrol_id;
            public       postgres    false    277                       1259    136487    oscenter    TABLE     5  CREATE TABLE public.oscenter (
    center_id integer DEFAULT nextval('public.center_id_seq'::regclass) NOT NULL,
    partnership_id integer NOT NULL,
    farm_id integer NOT NULL,
    name character varying(45) NOT NULL,
    code character varying(20) NOT NULL,
    "order" integer,
    os_disable boolean
);
    DROP TABLE public.oscenter;
       public         postgres    false    228    3            ~           0    0    TABLE oscenter    COMMENT     S   COMMENT ON TABLE public.oscenter IS 'Almacena los datos referentes a los nucleos';
            public       postgres    false    278                       0    0    COLUMN oscenter.center_id    COMMENT     @   COMMENT ON COLUMN public.oscenter.center_id IS 'Id del nucleo';
            public       postgres    false    278            �           0    0    COLUMN oscenter.partnership_id    COMMENT     H   COMMENT ON COLUMN public.oscenter.partnership_id IS 'Id de la empresa';
            public       postgres    false    278            �           0    0    COLUMN oscenter.farm_id    COMMENT     @   COMMENT ON COLUMN public.oscenter.farm_id IS 'Id de la granja';
            public       postgres    false    278            �           0    0    COLUMN oscenter.name    COMMENT     @   COMMENT ON COLUMN public.oscenter.name IS 'Nombre del nucleo
';
            public       postgres    false    278            �           0    0    COLUMN oscenter.code    COMMENT     ?   COMMENT ON COLUMN public.oscenter.code IS 'Codigo del nucleo';
            public       postgres    false    278                       1259    136491    osfarm    TABLE     3  CREATE TABLE public.osfarm (
    farm_id integer DEFAULT nextval('public.farm_id_seq'::regclass) NOT NULL,
    partnership_id integer NOT NULL,
    code character varying(20) NOT NULL,
    name character varying(45) NOT NULL,
    farm_type_id integer NOT NULL,
    _order integer,
    os_disable boolean
);
    DROP TABLE public.osfarm;
       public         postgres    false    232    3            �           0    0    TABLE osfarm    COMMENT     p   COMMENT ON TABLE public.osfarm IS 'Almacena la información de la granja con sus respectivas características';
            public       postgres    false    279            �           0    0    COLUMN osfarm.farm_id    COMMENT     >   COMMENT ON COLUMN public.osfarm.farm_id IS 'Id de la granja';
            public       postgres    false    279            �           0    0    COLUMN osfarm.partnership_id    COMMENT     F   COMMENT ON COLUMN public.osfarm.partnership_id IS 'Id de la empresa';
            public       postgres    false    279            �           0    0    COLUMN osfarm.code    COMMENT     ?   COMMENT ON COLUMN public.osfarm.code IS 'Codigo de la granja';
            public       postgres    false    279            �           0    0    COLUMN osfarm.name    COMMENT     ?   COMMENT ON COLUMN public.osfarm.name IS 'Nombre de la granja';
            public       postgres    false    279            �           0    0    COLUMN osfarm.farm_type_id    COMMENT     I   COMMENT ON COLUMN public.osfarm.farm_type_id IS 'Id del tipo de granja';
            public       postgres    false    279                       1259    136495    osincubator    TABLE       CREATE TABLE public.osincubator (
    incubator_id integer DEFAULT nextval('public.incubator_id_seq'::regclass) NOT NULL,
    incubator_plant_id integer NOT NULL,
    name character varying(45) NOT NULL,
    code character varying(20) NOT NULL,
    description character varying(250) NOT NULL,
    capacity integer,
    sunday integer,
    monday integer,
    tuesday integer,
    wednesday integer,
    thursday integer,
    friday integer,
    saturday integer,
    available integer,
    os_disable boolean,
    _order integer
);
    DROP TABLE public.osincubator;
       public         postgres    false    237    3            �           0    0    TABLE osincubator    COMMENT     y   COMMENT ON TABLE public.osincubator IS 'Almacena las máquinas de incubación pertenecientes a cada una de las plantas';
            public       postgres    false    280            �           0    0    COLUMN osincubator.incubator_id    COMMENT     L   COMMENT ON COLUMN public.osincubator.incubator_id IS 'Id de la incubadora';
            public       postgres    false    280            �           0    0 %   COLUMN osincubator.incubator_plant_id    COMMENT     Y   COMMENT ON COLUMN public.osincubator.incubator_plant_id IS 'Id de la planta incubadora';
            public       postgres    false    280            �           0    0    COLUMN osincubator.name    COMMENT     H   COMMENT ON COLUMN public.osincubator.name IS 'Nombre de la incubadora';
            public       postgres    false    280            �           0    0    COLUMN osincubator.code    COMMENT     H   COMMENT ON COLUMN public.osincubator.code IS 'Codigo de la incubadora';
            public       postgres    false    280            �           0    0    COLUMN osincubator.description    COMMENT     T   COMMENT ON COLUMN public.osincubator.description IS 'Descripcion de la incubadora';
            public       postgres    false    280            �           0    0    COLUMN osincubator.capacity    COMMENT     O   COMMENT ON COLUMN public.osincubator.capacity IS 'Capacidad de la incubadora';
            public       postgres    false    280            �           0    0    COLUMN osincubator.sunday    COMMENT     ]   COMMENT ON COLUMN public.osincubator.sunday IS 'Marca los dias de trabajo de la incubadora';
            public       postgres    false    280            �           0    0    COLUMN osincubator.monday    COMMENT     ^   COMMENT ON COLUMN public.osincubator.monday IS 'Marca los días de trabajo de la incubadora';
            public       postgres    false    280            �           0    0    COLUMN osincubator.tuesday    COMMENT     _   COMMENT ON COLUMN public.osincubator.tuesday IS 'Marca los días de trabajo de la incubadora';
            public       postgres    false    280            �           0    0    COLUMN osincubator.wednesday    COMMENT     a   COMMENT ON COLUMN public.osincubator.wednesday IS 'Marca los días de trabajo de la incubadora';
            public       postgres    false    280            �           0    0    COLUMN osincubator.thursday    COMMENT     `   COMMENT ON COLUMN public.osincubator.thursday IS 'Marca los días de trabajo de la incubadora';
            public       postgres    false    280            �           0    0    COLUMN osincubator.friday    COMMENT     ^   COMMENT ON COLUMN public.osincubator.friday IS 'Marca los días de trabajo de la incubadora';
            public       postgres    false    280            �           0    0    COLUMN osincubator.saturday    COMMENT     `   COMMENT ON COLUMN public.osincubator.saturday IS 'Marca los días de trabajo de la incubadora';
            public       postgres    false    280                       1259    136499    osincubatorplant    TABLE     �  CREATE TABLE public.osincubatorplant (
    incubator_plant_id integer DEFAULT nextval('public.incubator_plant_id_seq'::regclass) NOT NULL,
    name character varying(45) NOT NULL,
    code character varying(20) NOT NULL,
    description character varying(250),
    partnership_id integer NOT NULL,
    max_storage integer,
    min_storage integer,
    acclimatized boolean,
    suitable boolean,
    expired boolean,
    os_disable boolean
);
 $   DROP TABLE public.osincubatorplant;
       public         postgres    false    238    3            �           0    0    TABLE osincubatorplant    COMMENT     }   COMMENT ON TABLE public.osincubatorplant IS 'Almacena la información de la planta incubadora perteneciente a cada empresa';
            public       postgres    false    281            �           0    0 *   COLUMN osincubatorplant.incubator_plant_id    COMMENT     ^   COMMENT ON COLUMN public.osincubatorplant.incubator_plant_id IS 'Id de la planta incubadora';
            public       postgres    false    281            �           0    0    COLUMN osincubatorplant.name    COMMENT     T   COMMENT ON COLUMN public.osincubatorplant.name IS 'Nombre de la planta incubadora';
            public       postgres    false    281            �           0    0    COLUMN osincubatorplant.code    COMMENT     T   COMMENT ON COLUMN public.osincubatorplant.code IS 'Codigo de la planta incubadora';
            public       postgres    false    281            �           0    0 #   COLUMN osincubatorplant.description    COMMENT     a   COMMENT ON COLUMN public.osincubatorplant.description IS 'Descripción de la planta incubadora';
            public       postgres    false    281            �           0    0 &   COLUMN osincubatorplant.partnership_id    COMMENT     P   COMMENT ON COLUMN public.osincubatorplant.partnership_id IS 'Id de la empresa';
            public       postgres    false    281            �           0    0 #   COLUMN osincubatorplant.max_storage    COMMENT     ]   COMMENT ON COLUMN public.osincubatorplant.max_storage IS 'Numero máximo de almacenamiento';
            public       postgres    false    281            �           0    0 #   COLUMN osincubatorplant.min_storage    COMMENT     \   COMMENT ON COLUMN public.osincubatorplant.min_storage IS 'Numero minimo de almacenamiento';
            public       postgres    false    281                       1259    136503    partnership_id_seq    SEQUENCE     {   CREATE SEQUENCE public.partnership_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.partnership_id_seq;
       public       postgres    false    3                       1259    136505    ospartnership    TABLE     J  CREATE TABLE public.ospartnership (
    partnership_id integer DEFAULT nextval('public.partnership_id_seq'::regclass) NOT NULL,
    name character varying(45) NOT NULL,
    address character varying(250) NOT NULL,
    description character varying(250) NOT NULL,
    code character varying(20) NOT NULL,
    os_disable boolean
);
 !   DROP TABLE public.ospartnership;
       public         postgres    false    282    3            �           0    0    TABLE ospartnership    COMMENT     j   COMMENT ON TABLE public.ospartnership IS 'Almacena la información referente a las empresas registradas';
            public       postgres    false    283            �           0    0 #   COLUMN ospartnership.partnership_id    COMMENT     M   COMMENT ON COLUMN public.ospartnership.partnership_id IS 'Id de la empresa';
            public       postgres    false    283            �           0    0    COLUMN ospartnership.name    COMMENT     G   COMMENT ON COLUMN public.ospartnership.name IS 'Nombre de la empresa';
            public       postgres    false    283            �           0    0    COLUMN ospartnership.address    COMMENT     M   COMMENT ON COLUMN public.ospartnership.address IS 'Direccion de la empresa';
            public       postgres    false    283            �           0    0     COLUMN ospartnership.description    COMMENT     T   COMMENT ON COLUMN public.ospartnership.description IS 'Descripción de la empresa';
            public       postgres    false    283            �           0    0    COLUMN ospartnership.code    COMMENT     G   COMMENT ON COLUMN public.ospartnership.code IS 'Codigo de la empresa';
            public       postgres    false    283                       1259    136512    shed_id_seq    SEQUENCE     t   CREATE SEQUENCE public.shed_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 "   DROP SEQUENCE public.shed_id_seq;
       public       postgres    false    3                       1259    136514    osshed    TABLE     n  CREATE TABLE public.osshed (
    shed_id integer DEFAULT nextval('public.shed_id_seq'::regclass) NOT NULL,
    partnership_id integer NOT NULL,
    farm_id integer NOT NULL,
    center_id integer NOT NULL,
    code character varying(20) NOT NULL,
    statusshed_id integer,
    type_id integer,
    building_date date,
    stall_width double precision NOT NULL,
    stall_height double precision NOT NULL,
    capacity_min double precision NOT NULL,
    capacity_max double precision NOT NULL,
    environment_id integer,
    rotation_days integer DEFAULT 0 NOT NULL,
    nests_quantity integer DEFAULT 0 NOT NULL,
    cages_quantity integer DEFAULT 0 NOT NULL,
    birds_quantity integer DEFAULT 0 NOT NULL,
    capacity_theoretical integer DEFAULT 0 NOT NULL,
    avaliable_date date,
    _order integer,
    breed_id integer,
    os_disable boolean,
    rehousing boolean
);
    DROP TABLE public.osshed;
       public         postgres    false    284    3            �           0    0    TABLE osshed    COMMENT     d   COMMENT ON TABLE public.osshed IS 'Almacena la informacion de los galpones asociados a la empresa';
            public       postgres    false    285            �           0    0    COLUMN osshed.shed_id    COMMENT     <   COMMENT ON COLUMN public.osshed.shed_id IS 'Id del galpon';
            public       postgres    false    285            �           0    0    COLUMN osshed.partnership_id    COMMENT     F   COMMENT ON COLUMN public.osshed.partnership_id IS 'Id de la empresa';
            public       postgres    false    285            �           0    0    COLUMN osshed.farm_id    COMMENT     >   COMMENT ON COLUMN public.osshed.farm_id IS 'Id de la granja';
            public       postgres    false    285            �           0    0    COLUMN osshed.center_id    COMMENT     >   COMMENT ON COLUMN public.osshed.center_id IS 'Id del nucleo';
            public       postgres    false    285            �           0    0    COLUMN osshed.code    COMMENT     =   COMMENT ON COLUMN public.osshed.code IS 'Codigo del galpon';
            public       postgres    false    285            �           0    0    COLUMN osshed.statusshed_id    COMMENT     _   COMMENT ON COLUMN public.osshed.statusshed_id IS 'Identificador del estado actual del galpon';
            public       postgres    false    285            �           0    0    COLUMN osshed.type_id    COMMENT     D   COMMENT ON COLUMN public.osshed.type_id IS 'Id del tipo de galpon';
            public       postgres    false    285            �           0    0    COLUMN osshed.building_date    COMMENT     c   COMMENT ON COLUMN public.osshed.building_date IS 'Almacena la fecha de construccion del edificio';
            public       postgres    false    285            �           0    0    COLUMN osshed.stall_width    COMMENT     M   COMMENT ON COLUMN public.osshed.stall_width IS 'Indica el ancho del galpon';
            public       postgres    false    285            �           0    0    COLUMN osshed.stall_height    COMMENT     M   COMMENT ON COLUMN public.osshed.stall_height IS 'Indica el alto del galpon';
            public       postgres    false    285            �           0    0    COLUMN osshed.capacity_min    COMMENT     D   COMMENT ON COLUMN public.osshed.capacity_min IS 'Capacidad minima';
            public       postgres    false    285            �           0    0    COLUMN osshed.capacity_max    COMMENT     F   COMMENT ON COLUMN public.osshed.capacity_max IS 'Capacidad máxima ';
            public       postgres    false    285            �           0    0    COLUMN osshed.environment_id    COMMENT     E   COMMENT ON COLUMN public.osshed.environment_id IS 'Id del ambiente';
            public       postgres    false    285            �           0    0    COLUMN osshed.rotation_days    COMMENT     H   COMMENT ON COLUMN public.osshed.rotation_days IS 'Días de rotación
';
            public       postgres    false    285            �           0    0    COLUMN osshed.nests_quantity    COMMENT     I   COMMENT ON COLUMN public.osshed.nests_quantity IS 'Cantidad de nidales';
            public       postgres    false    285            �           0    0    COLUMN osshed.cages_quantity    COMMENT     H   COMMENT ON COLUMN public.osshed.cages_quantity IS 'Cantidad de jaulas';
            public       postgres    false    285            �           0    0    COLUMN osshed.birds_quantity    COMMENT     F   COMMENT ON COLUMN public.osshed.birds_quantity IS 'Cantidad de aves';
            public       postgres    false    285            �           0    0 "   COLUMN osshed.capacity_theoretical    COMMENT     O   COMMENT ON COLUMN public.osshed.capacity_theoretical IS '	Capacidad teórica';
            public       postgres    false    285                       1259    136523    slaughterhouse_id_seq    SEQUENCE        CREATE SEQUENCE public.slaughterhouse_id_seq
    START WITH 33
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.slaughterhouse_id_seq;
       public       postgres    false    3                       1259    136525    osslaughterhouse    TABLE     r  CREATE TABLE public.osslaughterhouse (
    slaughterhouse_id integer DEFAULT nextval('public.slaughterhouse_id_seq'::regclass) NOT NULL,
    name character varying(45) NOT NULL,
    address character varying(250) NOT NULL,
    description character varying(250) NOT NULL,
    code character varying(20) NOT NULL,
    capacity double precision,
    os_disable boolean
);
 $   DROP TABLE public.osslaughterhouse;
       public         postgres    false    286    3                        1259    136532    posture_curve_id_seq    SEQUENCE     }   CREATE SEQUENCE public.posture_curve_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.posture_curve_id_seq;
       public       postgres    false    3            !           1259    136534    predecessor_id_seq    SEQUENCE     {   CREATE SEQUENCE public.predecessor_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.predecessor_id_seq;
       public       postgres    false    3            "           1259    136536    process_class_id_seq    SEQUENCE     }   CREATE SEQUENCE public.process_class_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.process_class_id_seq;
       public       postgres    false    3            #           1259    136538    programmed_eggs_id_seq    SEQUENCE        CREATE SEQUENCE public.programmed_eggs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.programmed_eggs_id_seq;
       public       postgres    false    3            $           1259    136540    raspberry_id_seq    SEQUENCE     y   CREATE SEQUENCE public.raspberry_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.raspberry_id_seq;
       public       postgres    false    3            %           1259    136542    scenario_formula_id_seq    SEQUENCE     �   CREATE SEQUENCE public.scenario_formula_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.scenario_formula_id_seq;
       public       postgres    false    3            &           1259    136544    scenario_parameter_day_seq    SEQUENCE     �   CREATE SEQUENCE public.scenario_parameter_day_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public.scenario_parameter_day_seq;
       public       postgres    false    3            '           1259    136546    scenario_parameter_id_seq    SEQUENCE     �   CREATE SEQUENCE public.scenario_parameter_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.scenario_parameter_id_seq;
       public       postgres    false    3            (           1259    136548    scenario_posture_id_seq    SEQUENCE     �   CREATE SEQUENCE public.scenario_posture_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.scenario_posture_id_seq;
       public       postgres    false    3            )           1259    136550    scenario_process_id_seq    SEQUENCE     �   CREATE SEQUENCE public.scenario_process_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.scenario_process_id_seq;
       public       postgres    false    3            *           1259    136552    silo_id_seq    SEQUENCE     t   CREATE SEQUENCE public.silo_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 "   DROP SEQUENCE public.silo_id_seq;
       public       postgres    false    3            +           1259    136554 0   slmdevictionpartition_slevictionpartition_id_seq    SEQUENCE     �   CREATE SEQUENCE public.slmdevictionpartition_slevictionpartition_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1;
 G   DROP SEQUENCE public.slmdevictionpartition_slevictionpartition_id_seq;
       public       postgres    false    3            ,           1259    136556    slmdevictionpartition    TABLE     �  CREATE TABLE public.slmdevictionpartition (
    slevictionpartition_id integer DEFAULT nextval('public.slmdevictionpartition_slevictionpartition_id_seq'::regclass) NOT NULL,
    youngmale double precision NOT NULL,
    oldmale double precision NOT NULL,
    peasantmale double precision NOT NULL,
    youngfemale double precision NOT NULL,
    oldfemale double precision NOT NULL,
    active boolean,
    sl_disable boolean,
    name character varying NOT NULL
);
 )   DROP TABLE public.slmdevictionpartition;
       public         postgres    false    299    3            -           1259    136563    slmdgenderclassification    TABLE     G  CREATE TABLE public.slmdgenderclassification (
    slgenderclassification_id integer NOT NULL,
    name character varying NOT NULL,
    gender "char" NOT NULL,
    breed_id integer NOT NULL,
    weight_gain double precision NOT NULL,
    age integer NOT NULL,
    mortality double precision NOT NULL,
    sl_disable boolean
);
 ,   DROP TABLE public.slmdgenderclassification;
       public         postgres    false    3            .           1259    136569 6   slmdgenderclassification_slgenderclassification_id_seq    SEQUENCE     �   CREATE SEQUENCE public.slmdgenderclassification_slgenderclassification_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 M   DROP SEQUENCE public.slmdgenderclassification_slgenderclassification_id_seq;
       public       postgres    false    301    3            �           0    0 6   slmdgenderclassification_slgenderclassification_id_seq    SEQUENCE OWNED BY     �   ALTER SEQUENCE public.slmdgenderclassification_slgenderclassification_id_seq OWNED BY public.slmdgenderclassification.slgenderclassification_id;
            public       postgres    false    302            /           1259    136571 &   slmdmachinegroup_slmachinegroup_id_seq    SEQUENCE     �   CREATE SEQUENCE public.slmdmachinegroup_slmachinegroup_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1;
 =   DROP SEQUENCE public.slmdmachinegroup_slmachinegroup_id_seq;
       public       postgres    false    3            0           1259    136573    slmdmachinegroup    TABLE       CREATE TABLE public.slmdmachinegroup (
    slmachinegroup_id integer DEFAULT nextval('public.slmdmachinegroup_slmachinegroup_id_seq'::regclass) NOT NULL,
    incubatorplant_id integer NOT NULL,
    amount_of_charge integer NOT NULL,
    charges integer NOT NULL,
    sunday boolean,
    monday boolean,
    tuesday boolean,
    wednesday boolean,
    thursday boolean,
    friday boolean,
    saturday boolean,
    sl_disable boolean,
    name character varying NOT NULL,
    description character varying NOT NULL
);
 $   DROP TABLE public.slmdmachinegroup;
       public         postgres    false    303    3            1           1259    136580    slmdprocess    TABLE     .  CREATE TABLE public.slmdprocess (
    slprocess_id integer NOT NULL,
    stage_id integer NOT NULL,
    breed_id integer NOT NULL,
    decrease double precision NOT NULL,
    duration_process integer NOT NULL,
    sync_considered boolean,
    sl_disable boolean,
    name character varying NOT NULL
);
    DROP TABLE public.slmdprocess;
       public         postgres    false    3            2           1259    136586    slmdprocess_slprocess_id_seq    SEQUENCE     �   CREATE SEQUENCE public.slmdprocess_slprocess_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public.slmdprocess_slprocess_id_seq;
       public       postgres    false    305    3            �           0    0    slmdprocess_slprocess_id_seq    SEQUENCE OWNED BY     ]   ALTER SEQUENCE public.slmdprocess_slprocess_id_seq OWNED BY public.slmdprocess.slprocess_id;
            public       postgres    false    306            3           1259    136588 
   sltxb_shed    TABLE     �   CREATE TABLE public.sltxb_shed (
    slb_shed_id integer NOT NULL,
    slbreeding_id integer NOT NULL,
    center_id integer NOT NULL,
    shed_id integer NOT NULL
);
    DROP TABLE public.sltxb_shed;
       public         postgres    false    3            4           1259    136591    sltxb_shed_slb_shed_id_seq    SEQUENCE     �   CREATE SEQUENCE public.sltxb_shed_slb_shed_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public.sltxb_shed_slb_shed_id_seq;
       public       postgres    false    3    307            �           0    0    sltxb_shed_slb_shed_id_seq    SEQUENCE OWNED BY     Y   ALTER SEQUENCE public.sltxb_shed_slb_shed_id_seq OWNED BY public.sltxb_shed.slb_shed_id;
            public       postgres    false    308            5           1259    136593    sltxbr_shed    TABLE     �   CREATE TABLE public.sltxbr_shed (
    slbr_shed_id integer NOT NULL,
    slbroiler_detail_id integer NOT NULL,
    center_id integer NOT NULL,
    shed_id integer NOT NULL,
    lot character varying
);
    DROP TABLE public.sltxbr_shed;
       public         postgres    false    3            6           1259    136599    sltxbr_shed_slbr_shed_id_seq    SEQUENCE     �   CREATE SEQUENCE public.sltxbr_shed_slbr_shed_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public.sltxbr_shed_slbr_shed_id_seq;
       public       postgres    false    3    309            �           0    0    sltxbr_shed_slbr_shed_id_seq    SEQUENCE OWNED BY     ]   ALTER SEQUENCE public.sltxbr_shed_slbr_shed_id_seq OWNED BY public.sltxbr_shed.slbr_shed_id;
            public       postgres    false    310            7           1259    136601    sltxbreeding    TABLE     ,  CREATE TABLE public.sltxbreeding (
    slbreeding_id integer NOT NULL,
    stage_id integer NOT NULL,
    scenario_id integer NOT NULL,
    partnership_id integer NOT NULL,
    breed_id integer NOT NULL,
    farm_id integer NOT NULL,
    programmed_quantity integer NOT NULL,
    execution_quantity integer,
    housing_date date NOT NULL,
    execution_date date,
    start_posture_date date,
    mortality double precision,
    lot character varying,
    associated integer,
    decrease double precision,
    duration integer,
    sl_disable boolean
);
     DROP TABLE public.sltxbreeding;
       public         postgres    false    3            8           1259    136607    sltxbreeding_slbreeding_id_seq    SEQUENCE     �   CREATE SEQUENCE public.sltxbreeding_slbreeding_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 5   DROP SEQUENCE public.sltxbreeding_slbreeding_id_seq;
       public       postgres    false    311    3            �           0    0    sltxbreeding_slbreeding_id_seq    SEQUENCE OWNED BY     a   ALTER SEQUENCE public.sltxbreeding_slbreeding_id_seq OWNED BY public.sltxbreeding.slbreeding_id;
            public       postgres    false    312            9           1259    136609    sltxbroiler    TABLE     5  CREATE TABLE public.sltxbroiler (
    slbroiler_id integer NOT NULL,
    scheduled_date date NOT NULL,
    scheduled_quantity integer NOT NULL,
    real_quantity integer,
    gender "char" NOT NULL,
    incubatorplant_id integer NOT NULL,
    sl_disable boolean,
    slincubator_detail_id integer NOT NULL
);
    DROP TABLE public.sltxbroiler;
       public         postgres    false    3            :           1259    136612 *   sltxbroiler_detail_slbroiler_detail_id_seq    SEQUENCE     �   CREATE SEQUENCE public.sltxbroiler_detail_slbroiler_detail_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1;
 A   DROP SEQUENCE public.sltxbroiler_detail_slbroiler_detail_id_seq;
       public       postgres    false    3            ;           1259    136614    sltxbroiler_detail    TABLE     �  CREATE TABLE public.sltxbroiler_detail (
    slbroiler_detail_id integer DEFAULT nextval('public.sltxbroiler_detail_slbroiler_detail_id_seq'::regclass) NOT NULL,
    farm_id integer NOT NULL,
    housing_date date NOT NULL,
    housing_quantity integer NOT NULL,
    eviction_date date,
    eviction_quantity integer,
    category integer,
    age integer,
    weightgain double precision,
    youngmale integer,
    oldmale integer,
    youngfemale integer,
    oldfemale integer,
    synchronized boolean,
    lot character varying,
    order_p character varying,
    executed boolean,
    sl_disable boolean,
    slbroiler_id integer,
    peasantmale integer
);
 &   DROP TABLE public.sltxbroiler_detail;
       public         postgres    false    314    3            <           1259    136621    sltxbroiler_lot    TABLE       CREATE TABLE public.sltxbroiler_lot (
    slbroiler_lot_id integer NOT NULL,
    slbroiler_detail_id integer NOT NULL,
    slbroiler_id integer,
    quantity integer NOT NULL,
    sl_disable boolean,
    slsellspurchase_id integer,
    gender "char" NOT NULL
);
 #   DROP TABLE public.sltxbroiler_lot;
       public         postgres    false    3            =           1259    136624 $   sltxbroiler_lot_slbroiler_lot_id_seq    SEQUENCE     �   CREATE SEQUENCE public.sltxbroiler_lot_slbroiler_lot_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ;   DROP SEQUENCE public.sltxbroiler_lot_slbroiler_lot_id_seq;
       public       postgres    false    3    316            �           0    0 $   sltxbroiler_lot_slbroiler_lot_id_seq    SEQUENCE OWNED BY     m   ALTER SEQUENCE public.sltxbroiler_lot_slbroiler_lot_id_seq OWNED BY public.sltxbroiler_lot.slbroiler_lot_id;
            public       postgres    false    317            >           1259    136626    sltxbroiler_slbroiler_id_seq    SEQUENCE     �   CREATE SEQUENCE public.sltxbroiler_slbroiler_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public.sltxbroiler_slbroiler_id_seq;
       public       postgres    false    3    313            �           0    0    sltxbroiler_slbroiler_id_seq    SEQUENCE OWNED BY     ]   ALTER SEQUENCE public.sltxbroiler_slbroiler_id_seq OWNED BY public.sltxbroiler.slbroiler_id;
            public       postgres    false    318            ?           1259    136628    sltxincubator_slincubator_seq    SEQUENCE     �   CREATE SEQUENCE public.sltxincubator_slincubator_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1;
 4   DROP SEQUENCE public.sltxincubator_slincubator_seq;
       public       postgres    false    3            @           1259    136630    sltxincubator    TABLE     Q  CREATE TABLE public.sltxincubator (
    slincubator integer DEFAULT nextval('public.sltxincubator_slincubator_seq'::regclass) NOT NULL,
    scenario_id integer NOT NULL,
    incubatorplant_id integer NOT NULL,
    scheduled_date date NOT NULL,
    scheduled_quantity integer,
    eggsrequired integer NOT NULL,
    sl_disable boolean
);
 !   DROP TABLE public.sltxincubator;
       public         postgres    false    319    3            A           1259    136634    sltxincubator_curve    TABLE     �   CREATE TABLE public.sltxincubator_curve (
    slincubator_curve_id integer NOT NULL,
    slposturecurve_id integer NOT NULL,
    slincubator_id integer NOT NULL,
    quantity integer NOT NULL,
    sl_disable boolean
);
 '   DROP TABLE public.sltxincubator_curve;
       public         postgres    false    3            B           1259    136637 ,   sltxincubator_curve_slincubator_curve_id_seq    SEQUENCE     �   CREATE SEQUENCE public.sltxincubator_curve_slincubator_curve_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 C   DROP SEQUENCE public.sltxincubator_curve_slincubator_curve_id_seq;
       public       postgres    false    3    321            �           0    0 ,   sltxincubator_curve_slincubator_curve_id_seq    SEQUENCE OWNED BY     }   ALTER SEQUENCE public.sltxincubator_curve_slincubator_curve_id_seq OWNED BY public.sltxincubator_curve.slincubator_curve_id;
            public       postgres    false    322            C           1259    136639 .   sltxincubator_detail_slincubator_detail_id_seq    SEQUENCE     �   CREATE SEQUENCE public.sltxincubator_detail_slincubator_detail_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1;
 E   DROP SEQUENCE public.sltxincubator_detail_slincubator_detail_id_seq;
       public       postgres    false    3            D           1259    136641    sltxincubator_detail    TABLE     �  CREATE TABLE public.sltxincubator_detail (
    slincubator_detail_id integer DEFAULT nextval('public.sltxincubator_detail_slincubator_detail_id_seq'::regclass) NOT NULL,
    incubator_id integer NOT NULL,
    programmed_date date NOT NULL,
    slmachinegroup_id integer NOT NULL,
    programmed_quantity integer NOT NULL,
    associated integer,
    decrease double precision,
    real_decrease double precision,
    duration integer,
    sl_disable boolean,
    identifier character varying NOT NULL
);
 (   DROP TABLE public.sltxincubator_detail;
       public         postgres    false    323    3            E           1259    136648    sltxincubator_lot    TABLE     �   CREATE TABLE public.sltxincubator_lot (
    slincubator_lot_id integer NOT NULL,
    slincubator_detail_id integer NOT NULL,
    slincubator_curve_id integer,
    quantity integer NOT NULL,
    sl_disable boolean,
    slsellspurchase_id integer
);
 %   DROP TABLE public.sltxincubator_lot;
       public         postgres    false    3            F           1259    136651 (   sltxincubator_lot_slincubator_lot_id_seq    SEQUENCE     �   CREATE SEQUENCE public.sltxincubator_lot_slincubator_lot_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ?   DROP SEQUENCE public.sltxincubator_lot_slincubator_lot_id_seq;
       public       postgres    false    3    325            �           0    0 (   sltxincubator_lot_slincubator_lot_id_seq    SEQUENCE OWNED BY     u   ALTER SEQUENCE public.sltxincubator_lot_slincubator_lot_id_seq OWNED BY public.sltxincubator_lot.slincubator_lot_id;
            public       postgres    false    326            G           1259    136653    sltxinventory    TABLE     �   CREATE TABLE public.sltxinventory (
    slinventory_id integer NOT NULL,
    scenario_id integer NOT NULL,
    week_date date NOT NULL,
    execution_eggs integer,
    execution_plexus_eggs integer
);
 !   DROP TABLE public.sltxinventory;
       public         postgres    false    3            H           1259    136656     sltxinventory_slinventory_id_seq    SEQUENCE     �   CREATE SEQUENCE public.sltxinventory_slinventory_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 7   DROP SEQUENCE public.sltxinventory_slinventory_id_seq;
       public       postgres    false    3    327            �           0    0     sltxinventory_slinventory_id_seq    SEQUENCE OWNED BY     e   ALTER SEQUENCE public.sltxinventory_slinventory_id_seq OWNED BY public.sltxinventory.slinventory_id;
            public       postgres    false    328            I           1259    136658    sltxlb_shed    TABLE     �   CREATE TABLE public.sltxlb_shed (
    sllb_shed_id integer NOT NULL,
    slliftbreeding_id integer NOT NULL,
    center_id integer NOT NULL,
    shed_id integer NOT NULL
);
    DROP TABLE public.sltxlb_shed;
       public         postgres    false    3            J           1259    136661    sltxlb_shed_sllb_shed_id_seq    SEQUENCE     �   CREATE SEQUENCE public.sltxlb_shed_sllb_shed_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public.sltxlb_shed_sllb_shed_id_seq;
       public       postgres    false    3    329            �           0    0    sltxlb_shed_sllb_shed_id_seq    SEQUENCE OWNED BY     ]   ALTER SEQUENCE public.sltxlb_shed_sllb_shed_id_seq OWNED BY public.sltxlb_shed.sllb_shed_id;
            public       postgres    false    330            K           1259    136663    sltxliftbreeding    TABLE     �  CREATE TABLE public.sltxliftbreeding (
    slliftbreeding_id integer NOT NULL,
    stage_id integer NOT NULL,
    scenario_id integer NOT NULL,
    partnership_id integer NOT NULL,
    breed_id integer NOT NULL,
    farm_id integer NOT NULL,
    scheduled_date date NOT NULL,
    execution_date date,
    demand_birds integer,
    received_birds integer,
    associated integer,
    decrease double precision,
    duration integer,
    sl_disable boolean,
    slbreeding_id integer NOT NULL
);
 $   DROP TABLE public.sltxliftbreeding;
       public         postgres    false    3            L           1259    136666 &   sltxliftbreeding_slliftbreeding_id_seq    SEQUENCE     �   CREATE SEQUENCE public.sltxliftbreeding_slliftbreeding_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 =   DROP SEQUENCE public.sltxliftbreeding_slliftbreeding_id_seq;
       public       postgres    false    3    331            �           0    0 &   sltxliftbreeding_slliftbreeding_id_seq    SEQUENCE OWNED BY     q   ALTER SEQUENCE public.sltxliftbreeding_slliftbreeding_id_seq OWNED BY public.sltxliftbreeding.slliftbreeding_id;
            public       postgres    false    332            M           1259    136668    sltxposturecurve    TABLE     Y  CREATE TABLE public.sltxposturecurve (
    slposturecurve_id integer NOT NULL,
    scenario_id integer NOT NULL,
    breed_id integer NOT NULL,
    weekly_curve double precision NOT NULL,
    posture_date date NOT NULL,
    posture_quantity integer NOT NULL,
    associated integer,
    sl_disable boolean,
    slbreeding_id integer NOT NULL
);
 $   DROP TABLE public.sltxposturecurve;
       public         postgres    false    3            N           1259    136671 &   sltxposturecurve_slposturecurve_id_seq    SEQUENCE     �   CREATE SEQUENCE public.sltxposturecurve_slposturecurve_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 =   DROP SEQUENCE public.sltxposturecurve_slposturecurve_id_seq;
       public       postgres    false    3    333            �           0    0 &   sltxposturecurve_slposturecurve_id_seq    SEQUENCE OWNED BY     q   ALTER SEQUENCE public.sltxposturecurve_slposturecurve_id_seq OWNED BY public.sltxposturecurve.slposturecurve_id;
            public       postgres    false    334            O           1259    136673    sltxsellspurchase    TABLE     �  CREATE TABLE public.sltxsellspurchase (
    slsellspurchase_id integer NOT NULL,
    scenario_id integer NOT NULL,
    programmed_date date NOT NULL,
    concept character varying NOT NULL,
    quantity integer NOT NULL,
    type character varying NOT NULL,
    breed_id integer NOT NULL,
    description character varying NOT NULL,
    sl_disable boolean,
    lot character varying
);
 %   DROP TABLE public.sltxsellspurchase;
       public         postgres    false    3            P           1259    136679 (   sltxsellspurchase_slsellspurchase_id_seq    SEQUENCE     �   CREATE SEQUENCE public.sltxsellspurchase_slsellspurchase_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ?   DROP SEQUENCE public.sltxsellspurchase_slsellspurchase_id_seq;
       public       postgres    false    335    3            �           0    0 (   sltxsellspurchase_slsellspurchase_id_seq    SEQUENCE OWNED BY     u   ALTER SEQUENCE public.sltxsellspurchase_slsellspurchase_id_seq OWNED BY public.sltxsellspurchase.slsellspurchase_id;
            public       postgres    false    336            Q           1259    136681    txadjustmentscontrol    TABLE     �   CREATE TABLE public.txadjustmentscontrol (
    adjustmentscontrol_id integer NOT NULL,
    username character varying(250) NOT NULL,
    adjustment_date date NOT NULL,
    lot_arp character varying NOT NULL,
    description character varying
);
 (   DROP TABLE public.txadjustmentscontrol;
       public         postgres    false    3            R           1259    136687 .   txadjustmentscontrol_adjustmentscontrol_id_seq    SEQUENCE     �   CREATE SEQUENCE public.txadjustmentscontrol_adjustmentscontrol_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 E   DROP SEQUENCE public.txadjustmentscontrol_adjustmentscontrol_id_seq;
       public       postgres    false    337    3            �           0    0 .   txadjustmentscontrol_adjustmentscontrol_id_seq    SEQUENCE OWNED BY     �   ALTER SEQUENCE public.txadjustmentscontrol_adjustmentscontrol_id_seq OWNED BY public.txadjustmentscontrol.adjustmentscontrol_id;
            public       postgres    false    338            S           1259    136689    txavailabilitysheds    TABLE       CREATE TABLE public.txavailabilitysheds (
    availability_shed_id integer DEFAULT nextval('public.availability_shed_id_seq'::regclass) NOT NULL,
    shed_id integer NOT NULL,
    init_date date,
    end_date date,
    lot_code character varying(20) NOT NULL
);
 '   DROP TABLE public.txavailabilitysheds;
       public         postgres    false    215    3            �           0    0    TABLE txavailabilitysheds    COMMENT     �   COMMENT ON TABLE public.txavailabilitysheds IS 'Almacena la disponibilidad en fechas de los galpones de acuerdo a la programación establecida';
            public       postgres    false    339            �           0    0 /   COLUMN txavailabilitysheds.availability_shed_id    COMMENT     �   COMMENT ON COLUMN public.txavailabilitysheds.availability_shed_id IS 'Id de la disponibilidad del almacen, indicando si este esta disponible';
            public       postgres    false    339            �           0    0 "   COLUMN txavailabilitysheds.shed_id    COMMENT     I   COMMENT ON COLUMN public.txavailabilitysheds.shed_id IS 'Id del galpon';
            public       postgres    false    339            �           0    0 $   COLUMN txavailabilitysheds.init_date    COMMENT     r   COMMENT ON COLUMN public.txavailabilitysheds.init_date IS 'Fecha de inicio de la programacion de uso del galpon';
            public       postgres    false    339            �           0    0 #   COLUMN txavailabilitysheds.end_date    COMMENT     r   COMMENT ON COLUMN public.txavailabilitysheds.end_date IS 'Fecha de cerrado de la programacion de uso del galpon';
            public       postgres    false    339            �           0    0 #   COLUMN txavailabilitysheds.lot_code    COMMENT     W   COMMENT ON COLUMN public.txavailabilitysheds.lot_code IS 'codigo del lote del galpon';
            public       postgres    false    339            T           1259    136693 	   txbroiler    TABLE     �  CREATE TABLE public.txbroiler (
    broiler_id integer DEFAULT nextval('public.broiler_id_seq'::regclass) NOT NULL,
    projected_date date,
    projected_quantity integer,
    partnership_id integer NOT NULL,
    scenario_id integer NOT NULL,
    breed_id integer NOT NULL,
    lot_incubator character varying(45) NOT NULL,
    programmed_eggs_id integer NOT NULL,
    evictionprojected boolean
);
    DROP TABLE public.txbroiler;
       public         postgres    false    219    3            �           0    0    TABLE txbroiler    COMMENT     c   COMMENT ON TABLE public.txbroiler IS 'Almacena la proyeccion realizada para el modulo de engorde';
            public       postgres    false    340            �           0    0    COLUMN txbroiler.broiler_id    COMMENT     U   COMMENT ON COLUMN public.txbroiler.broiler_id IS 'Id de la programacion de engorde';
            public       postgres    false    340            �           0    0    COLUMN txbroiler.projected_date    COMMENT     X   COMMENT ON COLUMN public.txbroiler.projected_date IS 'Fecha de proyección de engorde';
            public       postgres    false    340            �           0    0 #   COLUMN txbroiler.projected_quantity    COMMENT     `   COMMENT ON COLUMN public.txbroiler.projected_quantity IS 'Cantidad proyectada para el engorde';
            public       postgres    false    340            �           0    0    COLUMN txbroiler.partnership_id    COMMENT     I   COMMENT ON COLUMN public.txbroiler.partnership_id IS 'Id de la empresa';
            public       postgres    false    340            �           0    0    COLUMN txbroiler.scenario_id    COMMENT     G   COMMENT ON COLUMN public.txbroiler.scenario_id IS 'Id edl escenario ';
            public       postgres    false    340            �           0    0    COLUMN txbroiler.breed_id    COMMENT     K   COMMENT ON COLUMN public.txbroiler.breed_id IS 'Id de la raza a engordar';
            public       postgres    false    340            �           0    0    COLUMN txbroiler.lot_incubator    COMMENT     u   COMMENT ON COLUMN public.txbroiler.lot_incubator IS 'Lote de incubación de donde provienen los huevos proyectados';
            public       postgres    false    340            �           0    0 #   COLUMN txbroiler.programmed_eggs_id    COMMENT     Y   COMMENT ON COLUMN public.txbroiler.programmed_eggs_id IS 'Id de los huevos programados';
            public       postgres    false    340            U           1259    136697    txbroiler_detail    TABLE     �  CREATE TABLE public.txbroiler_detail (
    broiler_detail_id integer DEFAULT nextval('public.broiler_detail_id_seq'::regclass) NOT NULL,
    broiler_id integer NOT NULL,
    scheduled_date date,
    scheduled_quantity integer,
    farm_id integer NOT NULL,
    shed_id integer NOT NULL,
    confirm integer,
    execution_date date,
    execution_quantity integer,
    lot character varying(25) NOT NULL,
    broiler_product_id integer,
    center_id integer NOT NULL,
    executionfarm_id integer,
    executioncenter_id integer,
    executionshed_id integer,
    programmed_disable boolean,
    synchronized boolean,
    order_p character varying,
    lot_sap character varying,
    tight boolean,
    eviction boolean,
    closed_lot boolean
);
 $   DROP TABLE public.txbroiler_detail;
       public         postgres    false    218    3            �           0    0    TABLE txbroiler_detail    COMMENT     l   COMMENT ON TABLE public.txbroiler_detail IS 'Almacena la programacion y ejecuccion del proceso de engorde';
            public       postgres    false    341            �           0    0 )   COLUMN txbroiler_detail.broiler_detail_id    COMMENT     `   COMMENT ON COLUMN public.txbroiler_detail.broiler_detail_id IS 'Id de los detalles de engorde';
            public       postgres    false    341            �           0    0 "   COLUMN txbroiler_detail.broiler_id    COMMENT     \   COMMENT ON COLUMN public.txbroiler_detail.broiler_id IS 'Id de la programacion de engorde';
            public       postgres    false    341            �           0    0 &   COLUMN txbroiler_detail.scheduled_date    COMMENT     k   COMMENT ON COLUMN public.txbroiler_detail.scheduled_date IS 'Fecha programada para el proceso de engorde';
            public       postgres    false    341            �           0    0 *   COLUMN txbroiler_detail.scheduled_quantity    COMMENT     r   COMMENT ON COLUMN public.txbroiler_detail.scheduled_quantity IS 'Cantidad programada para el proceso de engorde';
            public       postgres    false    341            �           0    0    COLUMN txbroiler_detail.farm_id    COMMENT     H   COMMENT ON COLUMN public.txbroiler_detail.farm_id IS 'Id de la granja';
            public       postgres    false    341            �           0    0    COLUMN txbroiler_detail.shed_id    COMMENT     F   COMMENT ON COLUMN public.txbroiler_detail.shed_id IS 'Id del galpon';
            public       postgres    false    341            �           0    0    COLUMN txbroiler_detail.confirm    COMMENT     E   COMMENT ON COLUMN public.txbroiler_detail.confirm IS 'Confirmacion';
            public       postgres    false    341            �           0    0 &   COLUMN txbroiler_detail.execution_date    COMMENT     p   COMMENT ON COLUMN public.txbroiler_detail.execution_date IS 'Fecha de ejeccion de la planificacion de engorde';
            public       postgres    false    341            �           0    0 *   COLUMN txbroiler_detail.execution_quantity    COMMENT     u   COMMENT ON COLUMN public.txbroiler_detail.execution_quantity IS 'Cantidad ejecutada de la programación de engorde';
            public       postgres    false    341            �           0    0    COLUMN txbroiler_detail.lot    COMMENT     D   COMMENT ON COLUMN public.txbroiler_detail.lot IS 'Lote de engorde';
            public       postgres    false    341            �           0    0 *   COLUMN txbroiler_detail.broiler_product_id    COMMENT     ^   COMMENT ON COLUMN public.txbroiler_detail.broiler_product_id IS 'Id del producto de engorde';
            public       postgres    false    341            V           1259    136704    txbroiler_lot    TABLE     �   CREATE TABLE public.txbroiler_lot (
    broiler_lot_id integer NOT NULL,
    broiler_detail_id integer NOT NULL,
    broiler_id integer NOT NULL,
    quantity integer NOT NULL
);
 !   DROP TABLE public.txbroiler_lot;
       public         postgres    false    3            W           1259    136707     txbroiler_lot_broiler_lot_id_seq    SEQUENCE     �   CREATE SEQUENCE public.txbroiler_lot_broiler_lot_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 7   DROP SEQUENCE public.txbroiler_lot_broiler_lot_id_seq;
       public       postgres    false    342    3            �           0    0     txbroiler_lot_broiler_lot_id_seq    SEQUENCE OWNED BY     e   ALTER SEQUENCE public.txbroiler_lot_broiler_lot_id_seq OWNED BY public.txbroiler_lot.broiler_lot_id;
            public       postgres    false    343            X           1259    136709    txbroilereviction    TABLE     �  CREATE TABLE public.txbroilereviction (
    broilereviction_id integer DEFAULT nextval('public.broilereviction_id_seq'::regclass) NOT NULL,
    projected_date date,
    projected_quantity integer,
    partnership_id integer NOT NULL,
    scenario_id integer NOT NULL,
    breed_id integer NOT NULL,
    lot_incubator character varying(45) NOT NULL,
    broiler_detail_id integer,
    evictionprojected boolean,
    broiler_heavy_detail_id integer
);
 %   DROP TABLE public.txbroilereviction;
       public         postgres    false    223    3            �           0    0    TABLE txbroilereviction    COMMENT     _   COMMENT ON TABLE public.txbroilereviction IS 'Almacena las proyeccion del modula de desalojo';
            public       postgres    false    344            �           0    0 +   COLUMN txbroilereviction.broilereviction_id    COMMENT     ^   COMMENT ON COLUMN public.txbroilereviction.broilereviction_id IS 'Id del modulo de desalojo';
            public       postgres    false    344            �           0    0 '   COLUMN txbroilereviction.projected_date    COMMENT     b   COMMENT ON COLUMN public.txbroilereviction.projected_date IS 'Fecha proyectada para el desalojo';
            public       postgres    false    344            �           0    0 +   COLUMN txbroilereviction.projected_quantity    COMMENT     i   COMMENT ON COLUMN public.txbroilereviction.projected_quantity IS 'Cantidad proyectada para el desalojo';
            public       postgres    false    344            �           0    0 '   COLUMN txbroilereviction.partnership_id    COMMENT     Q   COMMENT ON COLUMN public.txbroilereviction.partnership_id IS 'Id de la empresa';
            public       postgres    false    344            �           0    0 $   COLUMN txbroilereviction.scenario_id    COMMENT     N   COMMENT ON COLUMN public.txbroilereviction.scenario_id IS 'Id del escenario';
            public       postgres    false    344            �           0    0 !   COLUMN txbroilereviction.breed_id    COMMENT     H   COMMENT ON COLUMN public.txbroilereviction.breed_id IS 'Id de la raza';
            public       postgres    false    344            �           0    0 &   COLUMN txbroilereviction.lot_incubator    COMMENT     R   COMMENT ON COLUMN public.txbroilereviction.lot_incubator IS 'Lote de incubacion';
            public       postgres    false    344            Y           1259    136713    txbroilereviction_detail    TABLE     �  CREATE TABLE public.txbroilereviction_detail (
    broilereviction_detail_id integer DEFAULT nextval('public.broilereviction_detail_id_seq'::regclass) NOT NULL,
    broilereviction_id integer NOT NULL,
    scheduled_date date,
    scheduled_quantity integer,
    farm_id integer NOT NULL,
    shed_id integer NOT NULL,
    confirm integer,
    execution_date date,
    execution_quantity integer,
    lot character varying NOT NULL,
    broiler_product_id integer NOT NULL,
    slaughterhouse_id integer NOT NULL,
    center_id integer,
    executionslaughterhouse_id integer,
    programmed_disable boolean,
    synchronized boolean,
    order_p character varying(25),
    eviction boolean,
    closed_lot boolean
);
 ,   DROP TABLE public.txbroilereviction_detail;
       public         postgres    false    222    3            �           0    0    TABLE txbroilereviction_detail    COMMENT     v   COMMENT ON TABLE public.txbroilereviction_detail IS 'Almacena la programación y ejecución del módulo de desalojo';
            public       postgres    false    345            �           0    0 9   COLUMN txbroilereviction_detail.broilereviction_detail_id    COMMENT     ~   COMMENT ON COLUMN public.txbroilereviction_detail.broilereviction_detail_id IS 'Id de los detalles del modulo de desarrollo';
            public       postgres    false    345            �           0    0 2   COLUMN txbroilereviction_detail.broilereviction_id    COMMENT     e   COMMENT ON COLUMN public.txbroilereviction_detail.broilereviction_id IS 'Id del modulo de desalojo';
            public       postgres    false    345            �           0    0 .   COLUMN txbroilereviction_detail.scheduled_date    COMMENT     i   COMMENT ON COLUMN public.txbroilereviction_detail.scheduled_date IS 'Fecha programada para el desalojo';
            public       postgres    false    345            �           0    0 2   COLUMN txbroilereviction_detail.scheduled_quantity    COMMENT     p   COMMENT ON COLUMN public.txbroilereviction_detail.scheduled_quantity IS 'Cantidad programada para el desalojo';
            public       postgres    false    345            �           0    0 '   COLUMN txbroilereviction_detail.farm_id    COMMENT     P   COMMENT ON COLUMN public.txbroilereviction_detail.farm_id IS 'Id de la granja';
            public       postgres    false    345            �           0    0 '   COLUMN txbroilereviction_detail.shed_id    COMMENT     N   COMMENT ON COLUMN public.txbroilereviction_detail.shed_id IS 'Id del galpon';
            public       postgres    false    345            �           0    0 '   COLUMN txbroilereviction_detail.confirm    COMMENT     M   COMMENT ON COLUMN public.txbroilereviction_detail.confirm IS 'Confirmacion';
            public       postgres    false    345            �           0    0 .   COLUMN txbroilereviction_detail.execution_date    COMMENT     \   COMMENT ON COLUMN public.txbroilereviction_detail.execution_date IS 'Fecha de ejecución ';
            public       postgres    false    345            �           0    0 2   COLUMN txbroilereviction_detail.execution_quantity    COMMENT     c   COMMENT ON COLUMN public.txbroilereviction_detail.execution_quantity IS 'Cantidad de ejecución ';
            public       postgres    false    345            �           0    0 #   COLUMN txbroilereviction_detail.lot    COMMENT     X   COMMENT ON COLUMN public.txbroilereviction_detail.lot IS 'Lote del modulo de desalojo';
            public       postgres    false    345            �           0    0 2   COLUMN txbroilereviction_detail.broiler_product_id    COMMENT     f   COMMENT ON COLUMN public.txbroilereviction_detail.broiler_product_id IS 'Id del producto de engorde';
            public       postgres    false    345            �           0    0 1   COLUMN txbroilereviction_detail.slaughterhouse_id    COMMENT     g   COMMENT ON COLUMN public.txbroilereviction_detail.slaughterhouse_id IS 'Id de la planta de beneficio';
            public       postgres    false    345            Z           1259    136720    txbroilerheavy_detail    TABLE       CREATE TABLE public.txbroilerheavy_detail (
    broiler_heavy_detail_id integer NOT NULL,
    programmed_date date NOT NULL,
    programmed_quantity integer NOT NULL,
    broiler_detail_id integer NOT NULL,
    broiler_product_id integer NOT NULL,
    lot character varying NOT NULL,
    execution_date date,
    execution_quantity integer,
    tight boolean,
    closed_lot boolean,
    programmed_disable boolean,
    synchronized boolean,
    order_p character varying,
    lot_sap character varying,
    eviction boolean
);
 )   DROP TABLE public.txbroilerheavy_detail;
       public         postgres    false    3            [           1259    136726 1   txbroilerheavy_detail_broiler_heavy_detail_id_seq    SEQUENCE     �   CREATE SEQUENCE public.txbroilerheavy_detail_broiler_heavy_detail_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 H   DROP SEQUENCE public.txbroilerheavy_detail_broiler_heavy_detail_id_seq;
       public       postgres    false    346    3            �           0    0 1   txbroilerheavy_detail_broiler_heavy_detail_id_seq    SEQUENCE OWNED BY     �   ALTER SEQUENCE public.txbroilerheavy_detail_broiler_heavy_detail_id_seq OWNED BY public.txbroilerheavy_detail.broiler_heavy_detail_id;
            public       postgres    false    347            \           1259    136728    txbroilerproduct_detail    TABLE     �   CREATE TABLE public.txbroilerproduct_detail (
    broilerproduct_detail_id integer DEFAULT nextval('public.broiler_product_detail_id_seq'::regclass) NOT NULL,
    broiler_detail integer NOT NULL,
    broiler_product_id integer,
    quantity integer
);
 +   DROP TABLE public.txbroilerproduct_detail;
       public         postgres    false    220    3            �           0    0    TABLE txbroilerproduct_detail    COMMENT     h   COMMENT ON TABLE public.txbroilerproduct_detail IS 'Almacena los detalles de la produccion de engorde';
            public       postgres    false    348            �           0    0 7   COLUMN txbroilerproduct_detail.broilerproduct_detail_id    COMMENT     |   COMMENT ON COLUMN public.txbroilerproduct_detail.broilerproduct_detail_id IS 'Id de los detalles de produccion de engorde';
            public       postgres    false    348            �           0    0 -   COLUMN txbroilerproduct_detail.broiler_detail    COMMENT     Z   COMMENT ON COLUMN public.txbroilerproduct_detail.broiler_detail IS 'Detalles de engorde';
            public       postgres    false    348            �           0    0 1   COLUMN txbroilerproduct_detail.broiler_product_id    COMMENT     e   COMMENT ON COLUMN public.txbroilerproduct_detail.broiler_product_id IS 'Id del producto de engorde';
            public       postgres    false    348            �           0    0 '   COLUMN txbroilerproduct_detail.quantity    COMMENT     `   COMMENT ON COLUMN public.txbroilerproduct_detail.quantity IS 'Cantidad de producto de engorde';
            public       postgres    false    348            ]           1259    136732    txbroodermachine    TABLE     �  CREATE TABLE public.txbroodermachine (
    brooder_machine_id_seq integer DEFAULT nextval('public.brooder_machines_id_seq'::regclass) NOT NULL,
    partnership_id integer NOT NULL,
    farm_id integer NOT NULL,
    capacity integer,
    sunday integer,
    monday integer,
    tuesday integer,
    wednesday integer,
    thursday integer,
    friday integer,
    saturday integer,
    name character varying(250)
);
 $   DROP TABLE public.txbroodermachine;
       public         postgres    false    225    3            �           0    0    TABLE txbroodermachine    COMMENT     ]   COMMENT ON TABLE public.txbroodermachine IS 'Almacena los datos de las maquinas de engorde';
            public       postgres    false    349                        0    0 .   COLUMN txbroodermachine.brooder_machine_id_seq    COMMENT     c   COMMENT ON COLUMN public.txbroodermachine.brooder_machine_id_seq IS 'Id de la maquina de engorde';
            public       postgres    false    349                       0    0 &   COLUMN txbroodermachine.partnership_id    COMMENT     P   COMMENT ON COLUMN public.txbroodermachine.partnership_id IS 'Id de la empresa';
            public       postgres    false    349                       0    0    COLUMN txbroodermachine.farm_id    COMMENT     H   COMMENT ON COLUMN public.txbroodermachine.farm_id IS 'Id de la granja';
            public       postgres    false    349                       0    0     COLUMN txbroodermachine.capacity    COMMENT     Q   COMMENT ON COLUMN public.txbroodermachine.capacity IS 'Capacidad de la maquina';
            public       postgres    false    349                       0    0    COLUMN txbroodermachine.sunday    COMMENT     ?   COMMENT ON COLUMN public.txbroodermachine.sunday IS 'Domingo';
            public       postgres    false    349                       0    0    COLUMN txbroodermachine.monday    COMMENT     =   COMMENT ON COLUMN public.txbroodermachine.monday IS 'Lunes';
            public       postgres    false    349                       0    0    COLUMN txbroodermachine.tuesday    COMMENT     ?   COMMENT ON COLUMN public.txbroodermachine.tuesday IS 'Martes';
            public       postgres    false    349                       0    0 !   COLUMN txbroodermachine.wednesday    COMMENT     D   COMMENT ON COLUMN public.txbroodermachine.wednesday IS 'Miercoles';
            public       postgres    false    349                       0    0     COLUMN txbroodermachine.thursday    COMMENT     @   COMMENT ON COLUMN public.txbroodermachine.thursday IS 'Jueves';
            public       postgres    false    349            	           0    0    COLUMN txbroodermachine.friday    COMMENT     ?   COMMENT ON COLUMN public.txbroodermachine.friday IS 'Viernes';
            public       postgres    false    349            
           0    0     COLUMN txbroodermachine.saturday    COMMENT     @   COMMENT ON COLUMN public.txbroodermachine.saturday IS 'Sabado';
            public       postgres    false    349                       0    0    COLUMN txbroodermachine.name    COMMENT     J   COMMENT ON COLUMN public.txbroodermachine.name IS 'Nombre de la maquina';
            public       postgres    false    349            ^           1259    136744    txeggs_movements_id_seq    SEQUENCE     �   CREATE SEQUENCE public.txeggs_movements_id_seq
    START WITH 170
    INCREMENT BY 2041
    NO MINVALUE
    MAXVALUE 9999999999999999
    CACHE 1;
 .   DROP SEQUENCE public.txeggs_movements_id_seq;
       public       postgres    false    3            _           1259    136746    txeggs_movements    TABLE     �  CREATE TABLE public.txeggs_movements (
    eggs_movements_id integer DEFAULT nextval('public.txeggs_movements_id_seq'::regclass) NOT NULL,
    fecha_movements date NOT NULL,
    lot character varying(25) NOT NULL,
    quantity integer NOT NULL,
    type_movements character varying NOT NULL,
    eggs_storage_id integer NOT NULL,
    description_adjustment character varying,
    justification character varying,
    programmed_eggs_id integer,
    programmed_disable boolean
);
 $   DROP TABLE public.txeggs_movements;
       public         postgres    false    350    3            `           1259    136753    txeggs_planning    TABLE       CREATE TABLE public.txeggs_planning (
    egg_planning_id integer DEFAULT nextval('public.egg_planning_id_seq'::regclass) NOT NULL,
    month_planning integer,
    year_planning integer,
    scenario_id integer NOT NULL,
    planned double precision,
    breed_id integer NOT NULL
);
 #   DROP TABLE public.txeggs_planning;
       public         postgres    false    229    3                       0    0    TABLE txeggs_planning    COMMENT     g   COMMENT ON TABLE public.txeggs_planning IS 'Almacena los detalles de la planificación de los huevos';
            public       postgres    false    352                       0    0 &   COLUMN txeggs_planning.egg_planning_id    COMMENT     [   COMMENT ON COLUMN public.txeggs_planning.egg_planning_id IS 'Id de planeación de huevos';
            public       postgres    false    352                       0    0 %   COLUMN txeggs_planning.month_planning    COMMENT     c   COMMENT ON COLUMN public.txeggs_planning.month_planning IS 'Mes de planificación de los huevos
';
            public       postgres    false    352                       0    0 $   COLUMN txeggs_planning.year_planning    COMMENT     b   COMMENT ON COLUMN public.txeggs_planning.year_planning IS 'Año de planificación de los huevos';
            public       postgres    false    352                       0    0 "   COLUMN txeggs_planning.scenario_id    COMMENT     p   COMMENT ON COLUMN public.txeggs_planning.scenario_id IS 'Escenario al cual pertenecen los huevos planificados';
            public       postgres    false    352                       0    0    COLUMN txeggs_planning.planned    COMMENT     X   COMMENT ON COLUMN public.txeggs_planning.planned IS 'Cantidad de huevos planificados
';
            public       postgres    false    352                       0    0    COLUMN txeggs_planning.breed_id    COMMENT     T   COMMENT ON COLUMN public.txeggs_planning.breed_id IS 'Id de la raza de los huevos';
            public       postgres    false    352            a           1259    136757    txeggs_required    TABLE     
  CREATE TABLE public.txeggs_required (
    egg_required_id integer DEFAULT nextval('public.egg_required_id_seq'::regclass) NOT NULL,
    use_month integer,
    use_year integer,
    scenario_id integer NOT NULL,
    required double precision,
    breed_id integer
);
 #   DROP TABLE public.txeggs_required;
       public         postgres    false    230    3                       0    0    TABLE txeggs_required    COMMENT     V   COMMENT ON TABLE public.txeggs_required IS 'Almacena los datos de huevos requeridos';
            public       postgres    false    353                       0    0 &   COLUMN txeggs_required.egg_required_id    COMMENT     [   COMMENT ON COLUMN public.txeggs_required.egg_required_id IS 'Id de los huevos requeridos';
            public       postgres    false    353                       0    0     COLUMN txeggs_required.use_month    COMMENT     =   COMMENT ON COLUMN public.txeggs_required.use_month IS 'Mes';
            public       postgres    false    353                       0    0    COLUMN txeggs_required.use_year    COMMENT     =   COMMENT ON COLUMN public.txeggs_required.use_year IS 'Año';
            public       postgres    false    353                       0    0 "   COLUMN txeggs_required.scenario_id    COMMENT     L   COMMENT ON COLUMN public.txeggs_required.scenario_id IS 'Id del escenario';
            public       postgres    false    353                       0    0    COLUMN txeggs_required.required    COMMENT     K   COMMENT ON COLUMN public.txeggs_required.required IS 'Cantidad requerida';
            public       postgres    false    353                       0    0    COLUMN txeggs_required.breed_id    COMMENT     F   COMMENT ON COLUMN public.txeggs_required.breed_id IS 'Id de la raza';
            public       postgres    false    353            b           1259    136761    txeggs_storage    TABLE     �  CREATE TABLE public.txeggs_storage (
    eggs_storage_id integer DEFAULT nextval('public.eggs_storage_id_seq'::regclass) NOT NULL,
    incubator_plant_id integer NOT NULL,
    scenario_id integer NOT NULL,
    breed_id integer NOT NULL,
    init_date date,
    end_date date,
    lot character varying(45),
    eggs integer,
    eggs_executed integer,
    origin integer,
    synchronized boolean,
    lot_sap character varying,
    evictionprojected boolean
);
 "   DROP TABLE public.txeggs_storage;
       public         postgres    false    231    3                       0    0    TABLE txeggs_storage    COMMENT     ~   COMMENT ON TABLE public.txeggs_storage IS 'Guarda la informacion de almacenamiento de los huevos en las plantas incubadoras';
            public       postgres    false    354                       0    0 %   COLUMN txeggs_storage.eggs_storage_id    COMMENT     W   COMMENT ON COLUMN public.txeggs_storage.eggs_storage_id IS 'Id del almacen de huevos';
            public       postgres    false    354                       0    0 (   COLUMN txeggs_storage.incubator_plant_id    COMMENT     Y   COMMENT ON COLUMN public.txeggs_storage.incubator_plant_id IS 'Id de planta incubadora';
            public       postgres    false    354                       0    0 !   COLUMN txeggs_storage.scenario_id    COMMENT     K   COMMENT ON COLUMN public.txeggs_storage.scenario_id IS 'Id del escenario';
            public       postgres    false    354                       0    0    COLUMN txeggs_storage.breed_id    COMMENT     E   COMMENT ON COLUMN public.txeggs_storage.breed_id IS 'Id de la raza';
            public       postgres    false    354                       0    0    COLUMN txeggs_storage.init_date    COMMENT     H   COMMENT ON COLUMN public.txeggs_storage.init_date IS 'Fecha de inicio';
            public       postgres    false    354                        0    0    COLUMN txeggs_storage.end_date    COMMENT     J   COMMENT ON COLUMN public.txeggs_storage.end_date IS 'Fecha de terminado';
            public       postgres    false    354            !           0    0    COLUMN txeggs_storage.lot    COMMENT     7   COMMENT ON COLUMN public.txeggs_storage.lot IS 'Lote';
            public       postgres    false    354            "           0    0    COLUMN txeggs_storage.eggs    COMMENT     F   COMMENT ON COLUMN public.txeggs_storage.eggs IS 'Cantidad de huevos';
            public       postgres    false    354            c           1259    136768    txgoals_erp    TABLE     �   CREATE TABLE public.txgoals_erp (
    goals_erp_id bigint NOT NULL,
    use_week date,
    use_value integer,
    product_id integer NOT NULL,
    code character varying(10),
    scenario_id integer NOT NULL
);
    DROP TABLE public.txgoals_erp;
       public         postgres    false    3            #           0    0    TABLE txgoals_erp    COMMENT     �   COMMENT ON TABLE public.txgoals_erp IS 'Almacena los datos generados de las metas de producción de la planificación regresiva para ser enviados al ERP';
            public       postgres    false    355            $           0    0    COLUMN txgoals_erp.goals_erp_id    COMMENT     N   COMMENT ON COLUMN public.txgoals_erp.goals_erp_id IS 'Id de la meta del ERP';
            public       postgres    false    355            %           0    0    COLUMN txgoals_erp.use_week    COMMENT     ;   COMMENT ON COLUMN public.txgoals_erp.use_week IS 'Semana';
            public       postgres    false    355            &           0    0    COLUMN txgoals_erp.use_value    COMMENT     D   COMMENT ON COLUMN public.txgoals_erp.use_value IS 'Valor objetivo';
            public       postgres    false    355            '           0    0    COLUMN txgoals_erp.product_id    COMMENT     F   COMMENT ON COLUMN public.txgoals_erp.product_id IS 'Id del producto';
            public       postgres    false    355            (           0    0    COLUMN txgoals_erp.code    COMMENT     D   COMMENT ON COLUMN public.txgoals_erp.code IS 'Codigo del producto';
            public       postgres    false    355            )           0    0    COLUMN txgoals_erp.scenario_id    COMMENT     H   COMMENT ON COLUMN public.txgoals_erp.scenario_id IS 'Id del escenario';
            public       postgres    false    355            d           1259    136771    txgoals_erp_goals_erp_id_seq    SEQUENCE     �   CREATE SEQUENCE public.txgoals_erp_goals_erp_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public.txgoals_erp_goals_erp_id_seq;
       public       postgres    false    3    355            *           0    0    txgoals_erp_goals_erp_id_seq    SEQUENCE OWNED BY     ]   ALTER SEQUENCE public.txgoals_erp_goals_erp_id_seq OWNED BY public.txgoals_erp.goals_erp_id;
            public       postgres    false    356            e           1259    136773    txhousingway    TABLE     �  CREATE TABLE public.txhousingway (
    housing_way_id integer DEFAULT nextval('public.housing_way_id_seq'::regclass) NOT NULL,
    projected_quantity integer,
    projected_date date,
    stage_id integer NOT NULL,
    partnership_id integer NOT NULL,
    scenario_id integer NOT NULL,
    breed_id integer NOT NULL,
    predecessor_id integer NOT NULL,
    projected_disable boolean,
    evictionprojected boolean
);
     DROP TABLE public.txhousingway;
       public         postgres    false    236    3            +           0    0    TABLE txhousingway    COMMENT     t   COMMENT ON TABLE public.txhousingway IS 'Almacena la proyección de los módulos de levante, cría y reproductora';
            public       postgres    false    357            ,           0    0 "   COLUMN txhousingway.housing_way_id    COMMENT     �   COMMENT ON COLUMN public.txhousingway.housing_way_id IS 'Id de las proyecciones  de los módulos de levante, cría y reproductora';
            public       postgres    false    357            -           0    0 &   COLUMN txhousingway.projected_quantity    COMMENT     S   COMMENT ON COLUMN public.txhousingway.projected_quantity IS 'Cantidad proyectada';
            public       postgres    false    357            .           0    0 "   COLUMN txhousingway.projected_date    COMMENT     L   COMMENT ON COLUMN public.txhousingway.projected_date IS 'Fecha proyectada';
            public       postgres    false    357            /           0    0    COLUMN txhousingway.stage_id    COMMENT     D   COMMENT ON COLUMN public.txhousingway.stage_id IS 'Id de la etapa';
            public       postgres    false    357            0           0    0 "   COLUMN txhousingway.partnership_id    COMMENT     L   COMMENT ON COLUMN public.txhousingway.partnership_id IS 'Id de la empresa';
            public       postgres    false    357            1           0    0    COLUMN txhousingway.breed_id    COMMENT     C   COMMENT ON COLUMN public.txhousingway.breed_id IS 'Id de la raza';
            public       postgres    false    357            2           0    0 "   COLUMN txhousingway.predecessor_id    COMMENT     N   COMMENT ON COLUMN public.txhousingway.predecessor_id IS 'Id del predecesor ';
            public       postgres    false    357            f           1259    136777    txhousingway_detail    TABLE     �  CREATE TABLE public.txhousingway_detail (
    housingway_detail_id integer DEFAULT nextval('public.housing_way_detail_id_seq'::regclass) NOT NULL,
    housing_way_id integer NOT NULL,
    scheduled_date date,
    scheduled_quantity integer,
    farm_id integer NOT NULL,
    shed_id integer NOT NULL,
    confirm integer,
    execution_date date,
    execution_quantity integer,
    lot character varying(45),
    incubator_plant_id integer,
    center_id integer,
    executionfarm_id integer,
    executioncenter_id integer,
    executionshed_id integer,
    executionincubatorplant_id integer,
    programmed_disable boolean,
    synchronized boolean,
    order_p character varying,
    lot_sap character varying,
    tight boolean,
    eviction boolean
);
 '   DROP TABLE public.txhousingway_detail;
       public         postgres    false    235    3            3           0    0    TABLE txhousingway_detail    COMMENT     �   COMMENT ON TABLE public.txhousingway_detail IS 'Almacena la programación y la ejecución de los módulos de levante y cría y reproductora';
            public       postgres    false    358            4           0    0 /   COLUMN txhousingway_detail.housingway_detail_id    COMMENT     �   COMMENT ON COLUMN public.txhousingway_detail.housingway_detail_id IS 'Id de la programación y ejecución de los modelos de levante y cría y reproductora';
            public       postgres    false    358            5           0    0 )   COLUMN txhousingway_detail.housing_way_id    COMMENT     �   COMMENT ON COLUMN public.txhousingway_detail.housing_way_id IS 'Id de las proyecciones  de los módulos de levante, cría y reproductora';
            public       postgres    false    358            6           0    0 )   COLUMN txhousingway_detail.scheduled_date    COMMENT     S   COMMENT ON COLUMN public.txhousingway_detail.scheduled_date IS 'Fecha programada';
            public       postgres    false    358            7           0    0 -   COLUMN txhousingway_detail.scheduled_quantity    COMMENT     Z   COMMENT ON COLUMN public.txhousingway_detail.scheduled_quantity IS 'Cantidad programada';
            public       postgres    false    358            8           0    0 "   COLUMN txhousingway_detail.farm_id    COMMENT     K   COMMENT ON COLUMN public.txhousingway_detail.farm_id IS 'Id de la granja';
            public       postgres    false    358            9           0    0 "   COLUMN txhousingway_detail.shed_id    COMMENT     S   COMMENT ON COLUMN public.txhousingway_detail.shed_id IS 'Id del galpon utilizado';
            public       postgres    false    358            :           0    0 "   COLUMN txhousingway_detail.confirm    COMMENT     [   COMMENT ON COLUMN public.txhousingway_detail.confirm IS 'Confirmacion de sincronizacion ';
            public       postgres    false    358            ;           0    0 )   COLUMN txhousingway_detail.execution_date    COMMENT     V   COMMENT ON COLUMN public.txhousingway_detail.execution_date IS 'Fecha de ejecución';
            public       postgres    false    358            <           0    0 -   COLUMN txhousingway_detail.execution_quantity    COMMENT     Z   COMMENT ON COLUMN public.txhousingway_detail.execution_quantity IS 'Cantidad a ejecutar';
            public       postgres    false    358            =           0    0    COLUMN txhousingway_detail.lot    COMMENT     I   COMMENT ON COLUMN public.txhousingway_detail.lot IS 'Lote seleccionado';
            public       postgres    false    358            >           0    0 -   COLUMN txhousingway_detail.incubator_plant_id    COMMENT     a   COMMENT ON COLUMN public.txhousingway_detail.incubator_plant_id IS 'Id de la planta incubadora';
            public       postgres    false    358            g           1259    136784    txhousingway_lot    TABLE     �   CREATE TABLE public.txhousingway_lot (
    housingway_lot_id integer NOT NULL,
    production_id integer NOT NULL,
    housingway_id integer NOT NULL,
    quantity integer,
    stage_id integer
);
 $   DROP TABLE public.txhousingway_lot;
       public         postgres    false    3            h           1259    136787 %   txhousingway_lot_txhousingway_lot_seq    SEQUENCE     �   CREATE SEQUENCE public.txhousingway_lot_txhousingway_lot_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 <   DROP SEQUENCE public.txhousingway_lot_txhousingway_lot_seq;
       public       postgres    false    359    3            ?           0    0 %   txhousingway_lot_txhousingway_lot_seq    SEQUENCE OWNED BY     p   ALTER SEQUENCE public.txhousingway_lot_txhousingway_lot_seq OWNED BY public.txhousingway_lot.housingway_lot_id;
            public       postgres    false    360            i           1259    136789    txincubator_lot    TABLE     �   CREATE TABLE public.txincubator_lot (
    incubator_lot_id integer NOT NULL,
    programmed_eggs_id integer NOT NULL,
    eggs_movements_id integer NOT NULL,
    quantity integer NOT NULL
);
 #   DROP TABLE public.txincubator_lot;
       public         postgres    false    3            j           1259    136792 $   txincubator_lot_incubator_lot_id_seq    SEQUENCE     �   CREATE SEQUENCE public.txincubator_lot_incubator_lot_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ;   DROP SEQUENCE public.txincubator_lot_incubator_lot_id_seq;
       public       postgres    false    3    361            @           0    0 $   txincubator_lot_incubator_lot_id_seq    SEQUENCE OWNED BY     m   ALTER SEQUENCE public.txincubator_lot_incubator_lot_id_seq OWNED BY public.txincubator_lot.incubator_lot_id;
            public       postgres    false    362            k           1259    136794    txincubator_sales    TABLE       CREATE TABLE public.txincubator_sales (
    incubator_sales_id integer NOT NULL,
    date_sale date NOT NULL,
    quantity integer NOT NULL,
    gender "char" NOT NULL,
    incubator_plant_id integer NOT NULL,
    programmed_disable boolean,
    breed_id integer NOT NULL
);
 %   DROP TABLE public.txincubator_sales;
       public         postgres    false    3            l           1259    136797 (   txincubator_sales_incubator_sales_id_seq    SEQUENCE     �   CREATE SEQUENCE public.txincubator_sales_incubator_sales_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ?   DROP SEQUENCE public.txincubator_sales_incubator_sales_id_seq;
       public       postgres    false    363    3            A           0    0 (   txincubator_sales_incubator_sales_id_seq    SEQUENCE OWNED BY     u   ALTER SEQUENCE public.txincubator_sales_incubator_sales_id_seq OWNED BY public.txincubator_sales.incubator_sales_id;
            public       postgres    false    364            m           1259    136799    txlot    TABLE     n  CREATE TABLE public.txlot (
    lot_id integer DEFAULT nextval('public.lot_id_seq'::regclass) NOT NULL,
    lot_code character varying(20) NOT NULL,
    lot_origin character varying(150),
    status integer,
    proyected_date date,
    sheduled_date date,
    proyected_quantity integer,
    sheduled_quantity integer,
    released_quantity integer,
    product_id integer NOT NULL,
    breed_id integer NOT NULL,
    gender character varying(30),
    type_posture character varying(30),
    shed_id integer NOT NULL,
    origin character varying(30),
    farm_id integer NOT NULL,
    housing_way_id integer NOT NULL
);
    DROP TABLE public.txlot;
       public         postgres    false    243    3            B           0    0    TABLE txlot    COMMENT     T   COMMENT ON TABLE public.txlot IS 'Almacena la informacion de los diferentes lotes';
            public       postgres    false    365            C           0    0    COLUMN txlot.lot_id    COMMENT     8   COMMENT ON COLUMN public.txlot.lot_id IS 'Id del lote';
            public       postgres    false    365            D           0    0    COLUMN txlot.lot_code    COMMENT     >   COMMENT ON COLUMN public.txlot.lot_code IS 'Codigo del lote';
            public       postgres    false    365            E           0    0    COLUMN txlot.lot_origin    COMMENT     @   COMMENT ON COLUMN public.txlot.lot_origin IS 'Origen del lote';
            public       postgres    false    365            F           0    0    COLUMN txlot.status    COMMENT     <   COMMENT ON COLUMN public.txlot.status IS 'Estado del lote';
            public       postgres    false    365            G           0    0    COLUMN txlot.proyected_date    COMMENT     E   COMMENT ON COLUMN public.txlot.proyected_date IS 'Fecha proyectada';
            public       postgres    false    365            H           0    0    COLUMN txlot.sheduled_date    COMMENT     D   COMMENT ON COLUMN public.txlot.sheduled_date IS 'Fecha programada';
            public       postgres    false    365            I           0    0    COLUMN txlot.proyected_quantity    COMMENT     L   COMMENT ON COLUMN public.txlot.proyected_quantity IS 'Cantidad proyectada';
            public       postgres    false    365            J           0    0    COLUMN txlot.sheduled_quantity    COMMENT     K   COMMENT ON COLUMN public.txlot.sheduled_quantity IS 'Cantidad programada';
            public       postgres    false    365            K           0    0    COLUMN txlot.released_quantity    COMMENT     I   COMMENT ON COLUMN public.txlot.released_quantity IS 'Cantidad liberada';
            public       postgres    false    365            L           0    0    COLUMN txlot.product_id    COMMENT     @   COMMENT ON COLUMN public.txlot.product_id IS 'Id del producto';
            public       postgres    false    365            M           0    0    COLUMN txlot.breed_id    COMMENT     <   COMMENT ON COLUMN public.txlot.breed_id IS 'Id de la raza';
            public       postgres    false    365            N           0    0    COLUMN txlot.gender    COMMENT     <   COMMENT ON COLUMN public.txlot.gender IS 'Genero del lote';
            public       postgres    false    365            O           0    0    COLUMN txlot.type_posture    COMMENT     B   COMMENT ON COLUMN public.txlot.type_posture IS 'Tipo de postura';
            public       postgres    false    365            P           0    0    COLUMN txlot.shed_id    COMMENT     ;   COMMENT ON COLUMN public.txlot.shed_id IS 'Id del galpon';
            public       postgres    false    365            Q           0    0    COLUMN txlot.origin    COMMENT     3   COMMENT ON COLUMN public.txlot.origin IS 'Origen';
            public       postgres    false    365            R           0    0    COLUMN txlot.farm_id    COMMENT     =   COMMENT ON COLUMN public.txlot.farm_id IS 'Id de la granja';
            public       postgres    false    365            S           0    0    COLUMN txlot.housing_way_id    COMMENT     ~   COMMENT ON COLUMN public.txlot.housing_way_id IS 'Id del almacenamientos de la proyecciones de levante, cria y reproductora';
            public       postgres    false    365            n           1259    136803 
   txlot_eggs    TABLE     �   CREATE TABLE public.txlot_eggs (
    lot_eggs_id integer DEFAULT nextval('public.lot_eggs_id_seq'::regclass) NOT NULL,
    theorical_performance double precision,
    week_date date,
    week integer
);
    DROP TABLE public.txlot_eggs;
       public         postgres    false    241    3            T           0    0    TABLE txlot_eggs    COMMENT     S   COMMENT ON TABLE public.txlot_eggs IS 'Almacena los datos de los lotes de huevos';
            public       postgres    false    366            U           0    0    COLUMN txlot_eggs.lot_eggs_id    COMMENT     L   COMMENT ON COLUMN public.txlot_eggs.lot_eggs_id IS 'Id del lote de huevos';
            public       postgres    false    366            V           0    0 '   COLUMN txlot_eggs.theorical_performance    COMMENT     T   COMMENT ON COLUMN public.txlot_eggs.theorical_performance IS 'Rendimiento teorico';
            public       postgres    false    366            W           0    0    COLUMN txlot_eggs.week_date    COMMENT     G   COMMENT ON COLUMN public.txlot_eggs.week_date IS 'Fecha de la semana';
            public       postgres    false    366            X           0    0    COLUMN txlot_eggs.week    COMMENT     6   COMMENT ON COLUMN public.txlot_eggs.week IS 'Semana';
            public       postgres    false    366            o           1259    136807    txposturecurve    TABLE     �  CREATE TABLE public.txposturecurve (
    posture_curve_id integer DEFAULT nextval('public.posture_curve_id_seq'::regclass) NOT NULL,
    week integer NOT NULL,
    breed_id integer NOT NULL,
    theorical_performance double precision NOT NULL,
    historical_performance double precision,
    theorical_accum_mortality integer,
    historical_accum_mortality integer,
    theorical_uniformity double precision,
    historical_uniformity double precision,
    type_posture character varying(30) NOT NULL
);
 "   DROP TABLE public.txposturecurve;
       public         postgres    false    288    3            Y           0    0    TABLE txposturecurve    COMMENT        COMMENT ON TABLE public.txposturecurve IS 'Almacena la información de la curva de postura por cada raza separada por semana';
            public       postgres    false    367            Z           0    0 &   COLUMN txposturecurve.posture_curve_id    COMMENT     Y   COMMENT ON COLUMN public.txposturecurve.posture_curve_id IS 'Id de la curva de postura';
            public       postgres    false    367            [           0    0    COLUMN txposturecurve.week    COMMENT     _   COMMENT ON COLUMN public.txposturecurve.week IS 'Semana en la que inicia la curva de postura';
            public       postgres    false    367            \           0    0    COLUMN txposturecurve.breed_id    COMMENT     P   COMMENT ON COLUMN public.txposturecurve.breed_id IS 'Identificador de la raza';
            public       postgres    false    367            ]           0    0 +   COLUMN txposturecurve.theorical_performance    COMMENT     X   COMMENT ON COLUMN public.txposturecurve.theorical_performance IS 'Desempeño teórico';
            public       postgres    false    367            ^           0    0 ,   COLUMN txposturecurve.historical_performance    COMMENT     [   COMMENT ON COLUMN public.txposturecurve.historical_performance IS 'Desempeño histórico';
            public       postgres    false    367            _           0    0 /   COLUMN txposturecurve.theorical_accum_mortality    COMMENT     h   COMMENT ON COLUMN public.txposturecurve.theorical_accum_mortality IS 'Acumulado de mortalidad teorico';
            public       postgres    false    367            `           0    0 0   COLUMN txposturecurve.historical_accum_mortality    COMMENT     k   COMMENT ON COLUMN public.txposturecurve.historical_accum_mortality IS 'Acumulado de mortalidad historico';
            public       postgres    false    367            a           0    0 *   COLUMN txposturecurve.theorical_uniformity    COMMENT     W   COMMENT ON COLUMN public.txposturecurve.theorical_uniformity IS 'Uniformidad teorica';
            public       postgres    false    367            b           0    0 +   COLUMN txposturecurve.historical_uniformity    COMMENT     Z   COMMENT ON COLUMN public.txposturecurve.historical_uniformity IS 'Uniformidad historica';
            public       postgres    false    367            c           0    0 "   COLUMN txposturecurve.type_posture    COMMENT     K   COMMENT ON COLUMN public.txposturecurve.type_posture IS 'Tipo de postura';
            public       postgres    false    367            p           1259    136811    txprogrammed_eggs    TABLE     �  CREATE TABLE public.txprogrammed_eggs (
    programmed_eggs_id integer DEFAULT nextval('public.programmed_eggs_id_seq'::regclass) NOT NULL,
    incubator_id integer NOT NULL,
    lot_breed character varying(45),
    lot_incubator character varying(45),
    use_date date,
    eggs integer,
    breed_id integer NOT NULL,
    execution_quantity integer,
    eggs_storage_id integer NOT NULL,
    confirm integer,
    released boolean,
    eggs_movements_id integer,
    disable boolean,
    synchronized boolean,
    order_p character varying,
    lot_sap character varying,
    end_lot boolean,
    diff_days integer,
    programmed_disable boolean
);
 %   DROP TABLE public.txprogrammed_eggs;
       public         postgres    false    291    3            d           0    0    TABLE txprogrammed_eggs    COMMENT        COMMENT ON TABLE public.txprogrammed_eggs IS 'Almacena la proyección, programación y ejecución del módulo de incubadoras';
            public       postgres    false    368            e           0    0 +   COLUMN txprogrammed_eggs.programmed_eggs_id    COMMENT     j   COMMENT ON COLUMN public.txprogrammed_eggs.programmed_eggs_id IS 'Id de las programacion de incubadoras';
            public       postgres    false    368            f           0    0 %   COLUMN txprogrammed_eggs.incubator_id    COMMENT     O   COMMENT ON COLUMN public.txprogrammed_eggs.incubator_id IS 'Id de incubadora';
            public       postgres    false    368            g           0    0 "   COLUMN txprogrammed_eggs.lot_breed    COMMENT     I   COMMENT ON COLUMN public.txprogrammed_eggs.lot_breed IS 'Lote por raza';
            public       postgres    false    368            h           0    0 &   COLUMN txprogrammed_eggs.lot_incubator    COMMENT     S   COMMENT ON COLUMN public.txprogrammed_eggs.lot_incubator IS 'Lote de incubadoras';
            public       postgres    false    368            i           0    0    COLUMN txprogrammed_eggs.eggs    COMMENT     I   COMMENT ON COLUMN public.txprogrammed_eggs.eggs IS 'Cantidad de huevos';
            public       postgres    false    368            j           0    0 !   COLUMN txprogrammed_eggs.breed_id    COMMENT     E   COMMENT ON COLUMN public.txprogrammed_eggs.breed_id IS 'Id de raza';
            public       postgres    false    368            k           0    0 +   COLUMN txprogrammed_eggs.execution_quantity    COMMENT     [   COMMENT ON COLUMN public.txprogrammed_eggs.execution_quantity IS 'Cantidad de ejecución';
            public       postgres    false    368            q           1259    136818    txscenarioformula    TABLE     y  CREATE TABLE public.txscenarioformula (
    scenario_formula_id integer DEFAULT nextval('public.scenario_formula_id_seq'::regclass) NOT NULL,
    process_id integer NOT NULL,
    predecessor_id integer,
    parameter_id integer NOT NULL,
    sign integer,
    divider double precision,
    duration integer,
    scenario_id integer NOT NULL,
    measure_id integer NOT NULL
);
 %   DROP TABLE public.txscenarioformula;
       public         postgres    false    293    3            l           0    0    TABLE txscenarioformula    COMMENT     �   COMMENT ON TABLE public.txscenarioformula IS 'Almacena los datos para la formulación de salida de la planificación regresiva';
            public       postgres    false    369            m           0    0 ,   COLUMN txscenarioformula.scenario_formula_id    COMMENT     d   COMMENT ON COLUMN public.txscenarioformula.scenario_formula_id IS 'Id de la formula del escenario';
            public       postgres    false    369            n           0    0 #   COLUMN txscenarioformula.process_id    COMMENT     K   COMMENT ON COLUMN public.txscenarioformula.process_id IS 'Id del proceso';
            public       postgres    false    369            o           0    0 '   COLUMN txscenarioformula.predecessor_id    COMMENT     R   COMMENT ON COLUMN public.txscenarioformula.predecessor_id IS 'Id del predecesor';
            public       postgres    false    369            p           0    0 %   COLUMN txscenarioformula.parameter_id    COMMENT     O   COMMENT ON COLUMN public.txscenarioformula.parameter_id IS 'Id del parametro';
            public       postgres    false    369            q           0    0    COLUMN txscenarioformula.sign    COMMENT     E   COMMENT ON COLUMN public.txscenarioformula.sign IS 'Firma de datos';
            public       postgres    false    369            r           0    0     COLUMN txscenarioformula.divider    COMMENT     J   COMMENT ON COLUMN public.txscenarioformula.divider IS 'divisor de datos';
            public       postgres    false    369            s           0    0 !   COLUMN txscenarioformula.duration    COMMENT     Q   COMMENT ON COLUMN public.txscenarioformula.duration IS 'Duracion de la formula';
            public       postgres    false    369            t           0    0 $   COLUMN txscenarioformula.scenario_id    COMMENT     N   COMMENT ON COLUMN public.txscenarioformula.scenario_id IS 'Id del escenario';
            public       postgres    false    369            u           0    0 #   COLUMN txscenarioformula.measure_id    COMMENT     M   COMMENT ON COLUMN public.txscenarioformula.measure_id IS 'Id de la medida
';
            public       postgres    false    369            r           1259    136822    txscenarioparameter    TABLE     l  CREATE TABLE public.txscenarioparameter (
    scenario_parameter_id integer DEFAULT nextval('public.scenario_parameter_id_seq'::regclass) NOT NULL,
    process_id integer NOT NULL,
    parameter_id integer NOT NULL,
    use_year integer,
    use_month integer,
    use_value integer,
    scenario_id integer NOT NULL,
    value_units integer DEFAULT 0 NOT NULL
);
 '   DROP TABLE public.txscenarioparameter;
       public         postgres    false    295    3            v           0    0    TABLE txscenarioparameter    COMMENT     s   COMMENT ON TABLE public.txscenarioparameter IS 'Almacena las metas de producción ingresadas para los escenarios';
            public       postgres    false    370            w           0    0 0   COLUMN txscenarioparameter.scenario_parameter_id    COMMENT     l   COMMENT ON COLUMN public.txscenarioparameter.scenario_parameter_id IS 'Id de los parametros del escenario';
            public       postgres    false    370            x           0    0 %   COLUMN txscenarioparameter.process_id    COMMENT     M   COMMENT ON COLUMN public.txscenarioparameter.process_id IS 'Id del proceso';
            public       postgres    false    370            y           0    0 '   COLUMN txscenarioparameter.parameter_id    COMMENT     Q   COMMENT ON COLUMN public.txscenarioparameter.parameter_id IS 'Id del parametro';
            public       postgres    false    370            z           0    0 #   COLUMN txscenarioparameter.use_year    COMMENT     O   COMMENT ON COLUMN public.txscenarioparameter.use_year IS 'Año del parametro';
            public       postgres    false    370            {           0    0 $   COLUMN txscenarioparameter.use_month    COMMENT     O   COMMENT ON COLUMN public.txscenarioparameter.use_month IS 'Mes del parametro';
            public       postgres    false    370            |           0    0 $   COLUMN txscenarioparameter.use_value    COMMENT     Q   COMMENT ON COLUMN public.txscenarioparameter.use_value IS 'Valor del parametro';
            public       postgres    false    370            }           0    0 &   COLUMN txscenarioparameter.scenario_id    COMMENT     P   COMMENT ON COLUMN public.txscenarioparameter.scenario_id IS 'Id del escenario';
            public       postgres    false    370            ~           0    0 &   COLUMN txscenarioparameter.value_units    COMMENT     U   COMMENT ON COLUMN public.txscenarioparameter.value_units IS 'Valor de las unidades';
            public       postgres    false    370            s           1259    136827    txscenarioparameterday    TABLE     {  CREATE TABLE public.txscenarioparameterday (
    scenario_parameter_day_id integer DEFAULT nextval('public.scenario_parameter_day_seq'::regclass) NOT NULL,
    use_day integer,
    parameter_id integer NOT NULL,
    units_day integer,
    scenario_id integer NOT NULL,
    sequence integer,
    use_month integer,
    use_year integer,
    week_day integer,
    use_week date
);
 *   DROP TABLE public.txscenarioparameterday;
       public         postgres    false    294    3                       0    0    TABLE txscenarioparameterday    COMMENT     V   COMMENT ON TABLE public.txscenarioparameterday IS 'Almcacena los parametros por dia';
            public       postgres    false    371            �           0    0 7   COLUMN txscenarioparameterday.scenario_parameter_day_id    COMMENT     m   COMMENT ON COLUMN public.txscenarioparameterday.scenario_parameter_day_id IS 'Id de los parametros del dia';
            public       postgres    false    371            �           0    0 %   COLUMN txscenarioparameterday.use_day    COMMENT     B   COMMENT ON COLUMN public.txscenarioparameterday.use_day IS 'Dia';
            public       postgres    false    371            �           0    0 *   COLUMN txscenarioparameterday.parameter_id    COMMENT     c   COMMENT ON COLUMN public.txscenarioparameterday.parameter_id IS 'Id de los parametros necesarios';
            public       postgres    false    371            �           0    0 '   COLUMN txscenarioparameterday.units_day    COMMENT     U   COMMENT ON COLUMN public.txscenarioparameterday.units_day IS 'Cantidad de material';
            public       postgres    false    371            �           0    0 )   COLUMN txscenarioparameterday.scenario_id    COMMENT     u   COMMENT ON COLUMN public.txscenarioparameterday.scenario_id IS 'Escenario al cual pertenece el scanrioparameterday';
            public       postgres    false    371            �           0    0 &   COLUMN txscenarioparameterday.sequence    COMMENT     R   COMMENT ON COLUMN public.txscenarioparameterday.sequence IS 'Secuencia del dia
';
            public       postgres    false    371            �           0    0 '   COLUMN txscenarioparameterday.use_month    COMMENT     ]   COMMENT ON COLUMN public.txscenarioparameterday.use_month IS 'Mes en que se ubica el día ';
            public       postgres    false    371            �           0    0 &   COLUMN txscenarioparameterday.use_year    COMMENT     ]   COMMENT ON COLUMN public.txscenarioparameterday.use_year IS 'Año en que se ubica el día ';
            public       postgres    false    371            �           0    0 &   COLUMN txscenarioparameterday.week_day    COMMENT     P   COMMENT ON COLUMN public.txscenarioparameterday.week_day IS 'Dia de la semana';
            public       postgres    false    371            �           0    0 &   COLUMN txscenarioparameterday.use_week    COMMENT     F   COMMENT ON COLUMN public.txscenarioparameterday.use_week IS 'Semana';
            public       postgres    false    371            t           1259    136831    txscenarioposturecurve    TABLE     3  CREATE TABLE public.txscenarioposturecurve (
    scenario_posture_id integer DEFAULT nextval('public.scenario_posture_id_seq'::regclass) NOT NULL,
    posture_date date,
    eggs double precision,
    scenario_id integer NOT NULL,
    housingway_detail_id integer NOT NULL,
    breed_id integer NOT NULL
);
 *   DROP TABLE public.txscenarioposturecurve;
       public         postgres    false    296    3            �           0    0    TABLE txscenarioposturecurve    COMMENT     o   COMMENT ON TABLE public.txscenarioposturecurve IS 'Almacena los datos que se utilizan en la curva de postura';
            public       postgres    false    372            �           0    0 1   COLUMN txscenarioposturecurve.scenario_posture_id    COMMENT     i   COMMENT ON COLUMN public.txscenarioposturecurve.scenario_posture_id IS 'Id de la postura del escenario';
            public       postgres    false    372            �           0    0 *   COLUMN txscenarioposturecurve.posture_date    COMMENT     W   COMMENT ON COLUMN public.txscenarioposturecurve.posture_date IS 'Fecha de la postura';
            public       postgres    false    372            �           0    0 "   COLUMN txscenarioposturecurve.eggs    COMMENT     N   COMMENT ON COLUMN public.txscenarioposturecurve.eggs IS 'Cantidad de huevos';
            public       postgres    false    372            �           0    0 )   COLUMN txscenarioposturecurve.scenario_id    COMMENT     R   COMMENT ON COLUMN public.txscenarioposturecurve.scenario_id IS 'Id del scenario';
            public       postgres    false    372            �           0    0 2   COLUMN txscenarioposturecurve.housingway_detail_id    COMMENT     �   COMMENT ON COLUMN public.txscenarioposturecurve.housingway_detail_id IS 'Id de la programación y ejecución de los modelos de levante y cría y reproductora';
            public       postgres    false    372            �           0    0 &   COLUMN txscenarioposturecurve.breed_id    COMMENT     M   COMMENT ON COLUMN public.txscenarioposturecurve.breed_id IS 'Id de la raza';
            public       postgres    false    372            u           1259    136835    txscenarioprocess    TABLE     4  CREATE TABLE public.txscenarioprocess (
    scenario_process_id integer DEFAULT nextval('public.scenario_process_id_seq'::regclass) NOT NULL,
    process_id integer NOT NULL,
    decrease_goal double precision,
    weight_goal double precision,
    duration_goal integer,
    scenario_id integer NOT NULL
);
 %   DROP TABLE public.txscenarioprocess;
       public         postgres    false    297    3            �           0    0    TABLE txscenarioprocess    COMMENT     m   COMMENT ON TABLE public.txscenarioprocess IS 'Almacena los procesos asociados a cada uno de los escenarios';
            public       postgres    false    373            �           0    0 ,   COLUMN txscenarioprocess.scenario_process_id    COMMENT     a   COMMENT ON COLUMN public.txscenarioprocess.scenario_process_id IS 'Id del proceso de escenario';
            public       postgres    false    373            �           0    0 #   COLUMN txscenarioprocess.process_id    COMMENT     V   COMMENT ON COLUMN public.txscenarioprocess.process_id IS 'Id del proceso a utilizar';
            public       postgres    false    373            �           0    0 &   COLUMN txscenarioprocess.decrease_goal    COMMENT     v   COMMENT ON COLUMN public.txscenarioprocess.decrease_goal IS 'Guarda los datos de la merma historia en dicho proceso';
            public       postgres    false    373            �           0    0 $   COLUMN txscenarioprocess.weight_goal    COMMENT     q   COMMENT ON COLUMN public.txscenarioprocess.weight_goal IS 'Guarda los datos del peso historio en dicho proceso';
            public       postgres    false    373            �           0    0 &   COLUMN txscenarioprocess.duration_goal    COMMENT     y   COMMENT ON COLUMN public.txscenarioprocess.duration_goal IS 'Guarda los datos de la duracion historia en dicho proceso';
            public       postgres    false    373            �           0    0 $   COLUMN txscenarioprocess.scenario_id    COMMENT     X   COMMENT ON COLUMN public.txscenarioprocess.scenario_id IS 'Id del escenario utilizado';
            public       postgres    false    373            v           1259    136839    txsync    TABLE     +  CREATE TABLE public.txsync (
    sync_id integer NOT NULL,
    lot character varying NOT NULL,
    scheduled_date date,
    scheduled_quantity integer,
    farm_code character varying,
    shed_code character varying,
    execution_date date,
    execution_quantity integer,
    is_error boolean
);
    DROP TABLE public.txsync;
       public         postgres    false    3            w           1259    136845    txsync_sync_id_seq    SEQUENCE     �   CREATE SEQUENCE public.txsync_sync_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.txsync_sync_id_seq;
       public       postgres    false    374    3            �           0    0    txsync_sync_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.txsync_sync_id_seq OWNED BY public.txsync.sync_id;
            public       postgres    false    375            x           1259    136847 #   user_application_application_id_seq    SEQUENCE     �   CREATE SEQUENCE public.user_application_application_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1;
 :   DROP SEQUENCE public.user_application_application_id_seq;
       public       postgres    false    3            y           1259    136849     user_application_user_app_id_seq    SEQUENCE     �   CREATE SEQUENCE public.user_application_user_app_id_seq
    START WITH 215
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1;
 7   DROP SEQUENCE public.user_application_user_app_id_seq;
       public       postgres    false    3            z           1259    136851    user_application_user_id_seq    SEQUENCE     �   CREATE SEQUENCE public.user_application_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1;
 3   DROP SEQUENCE public.user_application_user_id_seq;
       public       postgres    false    3            {           1259    136853    warehouse_id_seq    SEQUENCE     y   CREATE SEQUENCE public.warehouse_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.warehouse_id_seq;
       public       postgres    false    3            �           2604    136855 ,   md_optimizer_parameter optimizerparameter_id    DEFAULT     �   ALTER TABLE ONLY public.md_optimizer_parameter ALTER COLUMN optimizerparameter_id SET DEFAULT nextval('public.md_optimizer_parameter_optimizerparameter_id_seq'::regclass);
 [   ALTER TABLE public.md_optimizer_parameter ALTER COLUMN optimizerparameter_id DROP DEFAULT;
       public       postgres    false    246    245            �           2604    136856    mdadjustment adjustment_id    DEFAULT     �   ALTER TABLE ONLY public.mdadjustment ALTER COLUMN adjustment_id SET DEFAULT nextval('public.mdadjustment_adjustment_id_seq'::regclass);
 I   ALTER TABLE public.mdadjustment ALTER COLUMN adjustment_id DROP DEFAULT;
       public       postgres    false    248    247            �           2604    136857 *   mdequivalenceproduct equivalenceproduct_id    DEFAULT     �   ALTER TABLE ONLY public.mdequivalenceproduct ALTER COLUMN equivalenceproduct_id SET DEFAULT nextval('public.mdequivalenceproduct_equivalenceproduct_id_seq'::regclass);
 Y   ALTER TABLE public.mdequivalenceproduct ALTER COLUMN equivalenceproduct_id DROP DEFAULT;
       public       postgres    false    256    255            �           2604    136858 *   osadjustmentscontrol adjustmentscontrol_id    DEFAULT     �   ALTER TABLE ONLY public.osadjustmentscontrol ALTER COLUMN adjustmentscontrol_id SET DEFAULT nextval('public.osadjustmentscontrol_adjustmentscontrol_id_seq'::regclass);
 Y   ALTER TABLE public.osadjustmentscontrol ALTER COLUMN adjustmentscontrol_id DROP DEFAULT;
       public       postgres    false    277    276            �           2604    136859 2   slmdgenderclassification slgenderclassification_id    DEFAULT     �   ALTER TABLE ONLY public.slmdgenderclassification ALTER COLUMN slgenderclassification_id SET DEFAULT nextval('public.slmdgenderclassification_slgenderclassification_id_seq'::regclass);
 a   ALTER TABLE public.slmdgenderclassification ALTER COLUMN slgenderclassification_id DROP DEFAULT;
       public       postgres    false    302    301            �           2604    136860    slmdprocess slprocess_id    DEFAULT     �   ALTER TABLE ONLY public.slmdprocess ALTER COLUMN slprocess_id SET DEFAULT nextval('public.slmdprocess_slprocess_id_seq'::regclass);
 G   ALTER TABLE public.slmdprocess ALTER COLUMN slprocess_id DROP DEFAULT;
       public       postgres    false    306    305            �           2604    136861    sltxb_shed slb_shed_id    DEFAULT     �   ALTER TABLE ONLY public.sltxb_shed ALTER COLUMN slb_shed_id SET DEFAULT nextval('public.sltxb_shed_slb_shed_id_seq'::regclass);
 E   ALTER TABLE public.sltxb_shed ALTER COLUMN slb_shed_id DROP DEFAULT;
       public       postgres    false    308    307            �           2604    136862    sltxbr_shed slbr_shed_id    DEFAULT     �   ALTER TABLE ONLY public.sltxbr_shed ALTER COLUMN slbr_shed_id SET DEFAULT nextval('public.sltxbr_shed_slbr_shed_id_seq'::regclass);
 G   ALTER TABLE public.sltxbr_shed ALTER COLUMN slbr_shed_id DROP DEFAULT;
       public       postgres    false    310    309            �           2604    136863    sltxbreeding slbreeding_id    DEFAULT     �   ALTER TABLE ONLY public.sltxbreeding ALTER COLUMN slbreeding_id SET DEFAULT nextval('public.sltxbreeding_slbreeding_id_seq'::regclass);
 I   ALTER TABLE public.sltxbreeding ALTER COLUMN slbreeding_id DROP DEFAULT;
       public       postgres    false    312    311            �           2604    136864    sltxbroiler slbroiler_id    DEFAULT     �   ALTER TABLE ONLY public.sltxbroiler ALTER COLUMN slbroiler_id SET DEFAULT nextval('public.sltxbroiler_slbroiler_id_seq'::regclass);
 G   ALTER TABLE public.sltxbroiler ALTER COLUMN slbroiler_id DROP DEFAULT;
       public       postgres    false    318    313            �           2604    136865     sltxbroiler_lot slbroiler_lot_id    DEFAULT     �   ALTER TABLE ONLY public.sltxbroiler_lot ALTER COLUMN slbroiler_lot_id SET DEFAULT nextval('public.sltxbroiler_lot_slbroiler_lot_id_seq'::regclass);
 O   ALTER TABLE public.sltxbroiler_lot ALTER COLUMN slbroiler_lot_id DROP DEFAULT;
       public       postgres    false    317    316            �           2604    136866 (   sltxincubator_curve slincubator_curve_id    DEFAULT     �   ALTER TABLE ONLY public.sltxincubator_curve ALTER COLUMN slincubator_curve_id SET DEFAULT nextval('public.sltxincubator_curve_slincubator_curve_id_seq'::regclass);
 W   ALTER TABLE public.sltxincubator_curve ALTER COLUMN slincubator_curve_id DROP DEFAULT;
       public       postgres    false    322    321            �           2604    136867 $   sltxincubator_lot slincubator_lot_id    DEFAULT     �   ALTER TABLE ONLY public.sltxincubator_lot ALTER COLUMN slincubator_lot_id SET DEFAULT nextval('public.sltxincubator_lot_slincubator_lot_id_seq'::regclass);
 S   ALTER TABLE public.sltxincubator_lot ALTER COLUMN slincubator_lot_id DROP DEFAULT;
       public       postgres    false    326    325            �           2604    136868    sltxinventory slinventory_id    DEFAULT     �   ALTER TABLE ONLY public.sltxinventory ALTER COLUMN slinventory_id SET DEFAULT nextval('public.sltxinventory_slinventory_id_seq'::regclass);
 K   ALTER TABLE public.sltxinventory ALTER COLUMN slinventory_id DROP DEFAULT;
       public       postgres    false    328    327            �           2604    136869    sltxlb_shed sllb_shed_id    DEFAULT     �   ALTER TABLE ONLY public.sltxlb_shed ALTER COLUMN sllb_shed_id SET DEFAULT nextval('public.sltxlb_shed_sllb_shed_id_seq'::regclass);
 G   ALTER TABLE public.sltxlb_shed ALTER COLUMN sllb_shed_id DROP DEFAULT;
       public       postgres    false    330    329            �           2604    136870 "   sltxliftbreeding slliftbreeding_id    DEFAULT     �   ALTER TABLE ONLY public.sltxliftbreeding ALTER COLUMN slliftbreeding_id SET DEFAULT nextval('public.sltxliftbreeding_slliftbreeding_id_seq'::regclass);
 Q   ALTER TABLE public.sltxliftbreeding ALTER COLUMN slliftbreeding_id DROP DEFAULT;
       public       postgres    false    332    331            �           2604    136871 "   sltxposturecurve slposturecurve_id    DEFAULT     �   ALTER TABLE ONLY public.sltxposturecurve ALTER COLUMN slposturecurve_id SET DEFAULT nextval('public.sltxposturecurve_slposturecurve_id_seq'::regclass);
 Q   ALTER TABLE public.sltxposturecurve ALTER COLUMN slposturecurve_id DROP DEFAULT;
       public       postgres    false    334    333            �           2604    136872 $   sltxsellspurchase slsellspurchase_id    DEFAULT     �   ALTER TABLE ONLY public.sltxsellspurchase ALTER COLUMN slsellspurchase_id SET DEFAULT nextval('public.sltxsellspurchase_slsellspurchase_id_seq'::regclass);
 S   ALTER TABLE public.sltxsellspurchase ALTER COLUMN slsellspurchase_id DROP DEFAULT;
       public       postgres    false    336    335            �           2604    136873 *   txadjustmentscontrol adjustmentscontrol_id    DEFAULT     �   ALTER TABLE ONLY public.txadjustmentscontrol ALTER COLUMN adjustmentscontrol_id SET DEFAULT nextval('public.txadjustmentscontrol_adjustmentscontrol_id_seq'::regclass);
 Y   ALTER TABLE public.txadjustmentscontrol ALTER COLUMN adjustmentscontrol_id DROP DEFAULT;
       public       postgres    false    338    337            �           2604    136874    txbroiler_lot broiler_lot_id    DEFAULT     �   ALTER TABLE ONLY public.txbroiler_lot ALTER COLUMN broiler_lot_id SET DEFAULT nextval('public.txbroiler_lot_broiler_lot_id_seq'::regclass);
 K   ALTER TABLE public.txbroiler_lot ALTER COLUMN broiler_lot_id DROP DEFAULT;
       public       postgres    false    343    342            �           2604    136875 -   txbroilerheavy_detail broiler_heavy_detail_id    DEFAULT     �   ALTER TABLE ONLY public.txbroilerheavy_detail ALTER COLUMN broiler_heavy_detail_id SET DEFAULT nextval('public.txbroilerheavy_detail_broiler_heavy_detail_id_seq'::regclass);
 \   ALTER TABLE public.txbroilerheavy_detail ALTER COLUMN broiler_heavy_detail_id DROP DEFAULT;
       public       postgres    false    347    346            �           2604    136876    txgoals_erp goals_erp_id    DEFAULT     �   ALTER TABLE ONLY public.txgoals_erp ALTER COLUMN goals_erp_id SET DEFAULT nextval('public.txgoals_erp_goals_erp_id_seq'::regclass);
 G   ALTER TABLE public.txgoals_erp ALTER COLUMN goals_erp_id DROP DEFAULT;
       public       postgres    false    356    355            �           2604    136877 "   txhousingway_lot housingway_lot_id    DEFAULT     �   ALTER TABLE ONLY public.txhousingway_lot ALTER COLUMN housingway_lot_id SET DEFAULT nextval('public.txhousingway_lot_txhousingway_lot_seq'::regclass);
 Q   ALTER TABLE public.txhousingway_lot ALTER COLUMN housingway_lot_id DROP DEFAULT;
       public       postgres    false    360    359            �           2604    136878     txincubator_lot incubator_lot_id    DEFAULT     �   ALTER TABLE ONLY public.txincubator_lot ALTER COLUMN incubator_lot_id SET DEFAULT nextval('public.txincubator_lot_incubator_lot_id_seq'::regclass);
 O   ALTER TABLE public.txincubator_lot ALTER COLUMN incubator_lot_id DROP DEFAULT;
       public       postgres    false    362    361            �           2604    136879 $   txincubator_sales incubator_sales_id    DEFAULT     �   ALTER TABLE ONLY public.txincubator_sales ALTER COLUMN incubator_sales_id SET DEFAULT nextval('public.txincubator_sales_incubator_sales_id_seq'::regclass);
 S   ALTER TABLE public.txincubator_sales ALTER COLUMN incubator_sales_id DROP DEFAULT;
       public       postgres    false    364    363            �           2604    136880    txsync sync_id    DEFAULT     p   ALTER TABLE ONLY public.txsync ALTER COLUMN sync_id SET DEFAULT nextval('public.txsync_sync_id_seq'::regclass);
 =   ALTER TABLE public.txsync ALTER COLUMN sync_id DROP DEFAULT;
       public       postgres    false    375    374            ?          0    136261    aba_breeds_and_stages 
   TABLE DATA               m   COPY public.aba_breeds_and_stages (id, code, name, id_aba_consumption_and_mortality, id_process) FROM stdin;
    public       postgres    false    198         A          0    136267    aba_consumption_and_mortality 
   TABLE DATA               m   COPY public.aba_consumption_and_mortality (id, code, name, id_breed, id_stage, id_aba_time_unit) FROM stdin;
    public       postgres    false    200   8      C          0    136273 $   aba_consumption_and_mortality_detail 
   TABLE DATA               �   COPY public.aba_consumption_and_mortality_detail (id, id_aba_consumption_and_mortality, time_unit_number, consumption, mortality) FROM stdin;
    public       postgres    false    202   U      E          0    136279    aba_elements 
   TABLE DATA               d   COPY public.aba_elements (id, code, name, id_aba_element_property, equivalent_quantity) FROM stdin;
    public       postgres    false    204   r      G          0    136285    aba_elements_and_concentrations 
   TABLE DATA               �   COPY public.aba_elements_and_concentrations (id, id_aba_element, id_aba_formulation, proportion, id_element_equivalent, id_aba_element_property, equivalent_quantity) FROM stdin;
    public       postgres    false    206   �      I          0    136291    aba_elements_properties 
   TABLE DATA               A   COPY public.aba_elements_properties (id, code, name) FROM stdin;
    public       postgres    false    208   �      K          0    136297    aba_formulation 
   TABLE DATA               9   COPY public.aba_formulation (id, code, name) FROM stdin;
    public       postgres    false    210   �      N          0    136305    aba_stages_of_breeds_and_stages 
   TABLE DATA               w   COPY public.aba_stages_of_breeds_and_stages (id, id_aba_breeds_and_stages, id_formulation, name, duration) FROM stdin;
    public       postgres    false    213   �      O          0    136309    aba_time_unit 
   TABLE DATA               G   COPY public.aba_time_unit (id, singular_name, plural_name) FROM stdin;
    public       postgres    false    214         n          0    136373    md_optimizer_parameter 
   TABLE DATA                  COPY public.md_optimizer_parameter (optimizerparameter_id, breed_id, max_housing, min_housing, difference, active) FROM stdin;
    public       postgres    false    245          p          0    136378    mdadjustment 
   TABLE DATA               P   COPY public.mdadjustment (adjustment_id, type, prefix, description) FROM stdin;
    public       postgres    false    247   =      s          0    136388    mdapplication 
   TABLE DATA               O   COPY public.mdapplication (application_id, application_name, type) FROM stdin;
    public       postgres    false    250   Z      u          0    136394    mdapplication_rol 
   TABLE DATA               G   COPY public.mdapplication_rol (id, application_id, rol_id) FROM stdin;
    public       postgres    false    252   w      v          0    136398    mdbreed 
   TABLE DATA               7   COPY public.mdbreed (breed_id, code, name) FROM stdin;
    public       postgres    false    253   �      w          0    136402    mdbroiler_product 
   TABLE DATA               �   COPY public.mdbroiler_product (broiler_product_id, name, days_eviction, weight, code, breed_id, gender, min_days_eviction, conversion_percentage, type_bird, initial_product) FROM stdin;
    public       postgres    false    254   �      x          0    136406    mdequivalenceproduct 
   TABLE DATA               o   COPY public.mdequivalenceproduct (equivalenceproduct_id, product_code, equivalence_code, breed_id) FROM stdin;
    public       postgres    false    255   �      z          0    136411 
   mdfarmtype 
   TABLE DATA               8   COPY public.mdfarmtype (farm_type_id, name) FROM stdin;
    public       postgres    false    257   �      |          0    136417 	   mdmeasure 
   TABLE DATA               b   COPY public.mdmeasure (measure_id, name, abbreviation, originvalue, valuekg, is_unit) FROM stdin;
    public       postgres    false    259         ~          0    136423    mdparameter 
   TABLE DATA               d   COPY public.mdparameter (parameter_id, description, type, measure_id, process_id, name) FROM stdin;
    public       postgres    false    261   %      �          0    136432 	   mdprocess 
   TABLE DATA               N  COPY public.mdprocess (process_id, process_order, product_id, stage_id, historical_decrease, theoretical_decrease, historical_weight, theoretical_weight, historical_duration, theoretical_duration, visible, name, predecessor_id, capacity, breed_id, gender, fattening_goal, type_posture, biological_active, sync_considered) FROM stdin;
    public       postgres    false    263   B      �          0    136438 	   mdproduct 
   TABLE DATA               O   COPY public.mdproduct (product_id, code, name, breed_id, stage_id) FROM stdin;
    public       postgres    false    265   _      �          0    136444    mdrol 
   TABLE DATA               T   COPY public.mdrol (rol_id, rol_name, admin_user_creator, creation_date) FROM stdin;
    public       postgres    false    267   |      �          0    136450 
   mdscenario 
   TABLE DATA               b   COPY public.mdscenario (scenario_id, description, date_start, date_end, name, status) FROM stdin;
    public       postgres    false    269   �      �          0    136460    mdshedstatus 
   TABLE DATA               I   COPY public.mdshedstatus (shed_status_id, name, description) FROM stdin;
    public       postgres    false    271   �      �          0    136466    mdstage 
   TABLE DATA               9   COPY public.mdstage (stage_id, order_, name) FROM stdin;
    public       postgres    false    273   �      �          0    136472    mduser 
   TABLE DATA                  COPY public.mduser (user_id, username, password, name, lastname, active, admi_user_creator, rol_id, creation_date) FROM stdin;
    public       postgres    false    275   0      �          0    136479    osadjustmentscontrol 
   TABLE DATA               p   COPY public.osadjustmentscontrol (adjustmentscontrol_id, username, adjustment_date, os_type, os_id) FROM stdin;
    public       postgres    false    276   M      �          0    136487    oscenter 
   TABLE DATA               g   COPY public.oscenter (center_id, partnership_id, farm_id, name, code, "order", os_disable) FROM stdin;
    public       postgres    false    278   j      �          0    136491    osfarm 
   TABLE DATA               g   COPY public.osfarm (farm_id, partnership_id, code, name, farm_type_id, _order, os_disable) FROM stdin;
    public       postgres    false    279   �      �          0    136495    osincubator 
   TABLE DATA               �   COPY public.osincubator (incubator_id, incubator_plant_id, name, code, description, capacity, sunday, monday, tuesday, wednesday, thursday, friday, saturday, available, os_disable, _order) FROM stdin;
    public       postgres    false    280   �      �          0    136499    osincubatorplant 
   TABLE DATA               �   COPY public.osincubatorplant (incubator_plant_id, name, code, description, partnership_id, max_storage, min_storage, acclimatized, suitable, expired, os_disable) FROM stdin;
    public       postgres    false    281   �      �          0    136505    ospartnership 
   TABLE DATA               e   COPY public.ospartnership (partnership_id, name, address, description, code, os_disable) FROM stdin;
    public       postgres    false    283   �      �          0    136514    osshed 
   TABLE DATA               O  COPY public.osshed (shed_id, partnership_id, farm_id, center_id, code, statusshed_id, type_id, building_date, stall_width, stall_height, capacity_min, capacity_max, environment_id, rotation_days, nests_quantity, cages_quantity, birds_quantity, capacity_theoretical, avaliable_date, _order, breed_id, os_disable, rehousing) FROM stdin;
    public       postgres    false    285   �      �          0    136525    osslaughterhouse 
   TABLE DATA               u   COPY public.osslaughterhouse (slaughterhouse_id, name, address, description, code, capacity, os_disable) FROM stdin;
    public       postgres    false    287         �          0    136556    slmdevictionpartition 
   TABLE DATA               �   COPY public.slmdevictionpartition (slevictionpartition_id, youngmale, oldmale, peasantmale, youngfemale, oldfemale, active, sl_disable, name) FROM stdin;
    public       postgres    false    300   5      �          0    136563    slmdgenderclassification 
   TABLE DATA               �   COPY public.slmdgenderclassification (slgenderclassification_id, name, gender, breed_id, weight_gain, age, mortality, sl_disable) FROM stdin;
    public       postgres    false    301   R      �          0    136573    slmdmachinegroup 
   TABLE DATA               �   COPY public.slmdmachinegroup (slmachinegroup_id, incubatorplant_id, amount_of_charge, charges, sunday, monday, tuesday, wednesday, thursday, friday, saturday, sl_disable, name, description) FROM stdin;
    public       postgres    false    304   o      �          0    136580    slmdprocess 
   TABLE DATA               �   COPY public.slmdprocess (slprocess_id, stage_id, breed_id, decrease, duration_process, sync_considered, sl_disable, name) FROM stdin;
    public       postgres    false    305   �      �          0    136588 
   sltxb_shed 
   TABLE DATA               T   COPY public.sltxb_shed (slb_shed_id, slbreeding_id, center_id, shed_id) FROM stdin;
    public       postgres    false    307   �      �          0    136593    sltxbr_shed 
   TABLE DATA               a   COPY public.sltxbr_shed (slbr_shed_id, slbroiler_detail_id, center_id, shed_id, lot) FROM stdin;
    public       postgres    false    309   �      �          0    136601    sltxbreeding 
   TABLE DATA                 COPY public.sltxbreeding (slbreeding_id, stage_id, scenario_id, partnership_id, breed_id, farm_id, programmed_quantity, execution_quantity, housing_date, execution_date, start_posture_date, mortality, lot, associated, decrease, duration, sl_disable) FROM stdin;
    public       postgres    false    311   �      �          0    136609    sltxbroiler 
   TABLE DATA               �   COPY public.sltxbroiler (slbroiler_id, scheduled_date, scheduled_quantity, real_quantity, gender, incubatorplant_id, sl_disable, slincubator_detail_id) FROM stdin;
    public       postgres    false    313          �          0    136614    sltxbroiler_detail 
   TABLE DATA                  COPY public.sltxbroiler_detail (slbroiler_detail_id, farm_id, housing_date, housing_quantity, eviction_date, eviction_quantity, category, age, weightgain, youngmale, oldmale, youngfemale, oldfemale, synchronized, lot, order_p, executed, sl_disable, slbroiler_id, peasantmale) FROM stdin;
    public       postgres    false    315         �          0    136621    sltxbroiler_lot 
   TABLE DATA               �   COPY public.sltxbroiler_lot (slbroiler_lot_id, slbroiler_detail_id, slbroiler_id, quantity, sl_disable, slsellspurchase_id, gender) FROM stdin;
    public       postgres    false    316   :      �          0    136630    sltxincubator 
   TABLE DATA               �   COPY public.sltxincubator (slincubator, scenario_id, incubatorplant_id, scheduled_date, scheduled_quantity, eggsrequired, sl_disable) FROM stdin;
    public       postgres    false    320   W      �          0    136634    sltxincubator_curve 
   TABLE DATA               |   COPY public.sltxincubator_curve (slincubator_curve_id, slposturecurve_id, slincubator_id, quantity, sl_disable) FROM stdin;
    public       postgres    false    321   t      �          0    136641    sltxincubator_detail 
   TABLE DATA               �   COPY public.sltxincubator_detail (slincubator_detail_id, incubator_id, programmed_date, slmachinegroup_id, programmed_quantity, associated, decrease, real_decrease, duration, sl_disable, identifier) FROM stdin;
    public       postgres    false    324   �      �          0    136648    sltxincubator_lot 
   TABLE DATA               �   COPY public.sltxincubator_lot (slincubator_lot_id, slincubator_detail_id, slincubator_curve_id, quantity, sl_disable, slsellspurchase_id) FROM stdin;
    public       postgres    false    325   �      �          0    136653    sltxinventory 
   TABLE DATA               v   COPY public.sltxinventory (slinventory_id, scenario_id, week_date, execution_eggs, execution_plexus_eggs) FROM stdin;
    public       postgres    false    327   �      �          0    136658    sltxlb_shed 
   TABLE DATA               Z   COPY public.sltxlb_shed (sllb_shed_id, slliftbreeding_id, center_id, shed_id) FROM stdin;
    public       postgres    false    329   �      �          0    136663    sltxliftbreeding 
   TABLE DATA               �   COPY public.sltxliftbreeding (slliftbreeding_id, stage_id, scenario_id, partnership_id, breed_id, farm_id, scheduled_date, execution_date, demand_birds, received_birds, associated, decrease, duration, sl_disable, slbreeding_id) FROM stdin;
    public       postgres    false    331         �          0    136668    sltxposturecurve 
   TABLE DATA               �   COPY public.sltxposturecurve (slposturecurve_id, scenario_id, breed_id, weekly_curve, posture_date, posture_quantity, associated, sl_disable, slbreeding_id) FROM stdin;
    public       postgres    false    333   "      �          0    136673    sltxsellspurchase 
   TABLE DATA               �   COPY public.sltxsellspurchase (slsellspurchase_id, scenario_id, programmed_date, concept, quantity, type, breed_id, description, sl_disable, lot) FROM stdin;
    public       postgres    false    335   ?      �          0    136681    txadjustmentscontrol 
   TABLE DATA               v   COPY public.txadjustmentscontrol (adjustmentscontrol_id, username, adjustment_date, lot_arp, description) FROM stdin;
    public       postgres    false    337   \      �          0    136689    txavailabilitysheds 
   TABLE DATA               k   COPY public.txavailabilitysheds (availability_shed_id, shed_id, init_date, end_date, lot_code) FROM stdin;
    public       postgres    false    339   y      �          0    136693 	   txbroiler 
   TABLE DATA               �   COPY public.txbroiler (broiler_id, projected_date, projected_quantity, partnership_id, scenario_id, breed_id, lot_incubator, programmed_eggs_id, evictionprojected) FROM stdin;
    public       postgres    false    340   �      �          0    136697    txbroiler_detail 
   TABLE DATA               Y  COPY public.txbroiler_detail (broiler_detail_id, broiler_id, scheduled_date, scheduled_quantity, farm_id, shed_id, confirm, execution_date, execution_quantity, lot, broiler_product_id, center_id, executionfarm_id, executioncenter_id, executionshed_id, programmed_disable, synchronized, order_p, lot_sap, tight, eviction, closed_lot) FROM stdin;
    public       postgres    false    341   �      �          0    136704    txbroiler_lot 
   TABLE DATA               `   COPY public.txbroiler_lot (broiler_lot_id, broiler_detail_id, broiler_id, quantity) FROM stdin;
    public       postgres    false    342   �      �          0    136709    txbroilereviction 
   TABLE DATA               �   COPY public.txbroilereviction (broilereviction_id, projected_date, projected_quantity, partnership_id, scenario_id, breed_id, lot_incubator, broiler_detail_id, evictionprojected, broiler_heavy_detail_id) FROM stdin;
    public       postgres    false    344   �      �          0    136713    txbroilereviction_detail 
   TABLE DATA               X  COPY public.txbroilereviction_detail (broilereviction_detail_id, broilereviction_id, scheduled_date, scheduled_quantity, farm_id, shed_id, confirm, execution_date, execution_quantity, lot, broiler_product_id, slaughterhouse_id, center_id, executionslaughterhouse_id, programmed_disable, synchronized, order_p, eviction, closed_lot) FROM stdin;
    public       postgres    false    345   
      �          0    136720    txbroilerheavy_detail 
   TABLE DATA                 COPY public.txbroilerheavy_detail (broiler_heavy_detail_id, programmed_date, programmed_quantity, broiler_detail_id, broiler_product_id, lot, execution_date, execution_quantity, tight, closed_lot, programmed_disable, synchronized, order_p, lot_sap, eviction) FROM stdin;
    public       postgres    false    346   '      �          0    136728    txbroilerproduct_detail 
   TABLE DATA               y   COPY public.txbroilerproduct_detail (broilerproduct_detail_id, broiler_detail, broiler_product_id, quantity) FROM stdin;
    public       postgres    false    348   D      �          0    136732    txbroodermachine 
   TABLE DATA               �   COPY public.txbroodermachine (brooder_machine_id_seq, partnership_id, farm_id, capacity, sunday, monday, tuesday, wednesday, thursday, friday, saturday, name) FROM stdin;
    public       postgres    false    349   a      �          0    136746    txeggs_movements 
   TABLE DATA               �   COPY public.txeggs_movements (eggs_movements_id, fecha_movements, lot, quantity, type_movements, eggs_storage_id, description_adjustment, justification, programmed_eggs_id, programmed_disable) FROM stdin;
    public       postgres    false    351   ~      �          0    136753    txeggs_planning 
   TABLE DATA               y   COPY public.txeggs_planning (egg_planning_id, month_planning, year_planning, scenario_id, planned, breed_id) FROM stdin;
    public       postgres    false    352   �      �          0    136757    txeggs_required 
   TABLE DATA               p   COPY public.txeggs_required (egg_required_id, use_month, use_year, scenario_id, required, breed_id) FROM stdin;
    public       postgres    false    353   �      �          0    136761    txeggs_storage 
   TABLE DATA               �   COPY public.txeggs_storage (eggs_storage_id, incubator_plant_id, scenario_id, breed_id, init_date, end_date, lot, eggs, eggs_executed, origin, synchronized, lot_sap, evictionprojected) FROM stdin;
    public       postgres    false    354   �      �          0    136768    txgoals_erp 
   TABLE DATA               g   COPY public.txgoals_erp (goals_erp_id, use_week, use_value, product_id, code, scenario_id) FROM stdin;
    public       postgres    false    355   �      �          0    136773    txhousingway 
   TABLE DATA               �   COPY public.txhousingway (housing_way_id, projected_quantity, projected_date, stage_id, partnership_id, scenario_id, breed_id, predecessor_id, projected_disable, evictionprojected) FROM stdin;
    public       postgres    false    357         �          0    136777    txhousingway_detail 
   TABLE DATA               s  COPY public.txhousingway_detail (housingway_detail_id, housing_way_id, scheduled_date, scheduled_quantity, farm_id, shed_id, confirm, execution_date, execution_quantity, lot, incubator_plant_id, center_id, executionfarm_id, executioncenter_id, executionshed_id, executionincubatorplant_id, programmed_disable, synchronized, order_p, lot_sap, tight, eviction) FROM stdin;
    public       postgres    false    358   ,      �          0    136784    txhousingway_lot 
   TABLE DATA               o   COPY public.txhousingway_lot (housingway_lot_id, production_id, housingway_id, quantity, stage_id) FROM stdin;
    public       postgres    false    359   I      �          0    136789    txincubator_lot 
   TABLE DATA               l   COPY public.txincubator_lot (incubator_lot_id, programmed_eggs_id, eggs_movements_id, quantity) FROM stdin;
    public       postgres    false    361   f      �          0    136794    txincubator_sales 
   TABLE DATA               �   COPY public.txincubator_sales (incubator_sales_id, date_sale, quantity, gender, incubator_plant_id, programmed_disable, breed_id) FROM stdin;
    public       postgres    false    363   �      �          0    136799    txlot 
   TABLE DATA               �   COPY public.txlot (lot_id, lot_code, lot_origin, status, proyected_date, sheduled_date, proyected_quantity, sheduled_quantity, released_quantity, product_id, breed_id, gender, type_posture, shed_id, origin, farm_id, housing_way_id) FROM stdin;
    public       postgres    false    365   �      �          0    136803 
   txlot_eggs 
   TABLE DATA               Y   COPY public.txlot_eggs (lot_eggs_id, theorical_performance, week_date, week) FROM stdin;
    public       postgres    false    366   �      �          0    136807    txposturecurve 
   TABLE DATA               �   COPY public.txposturecurve (posture_curve_id, week, breed_id, theorical_performance, historical_performance, theorical_accum_mortality, historical_accum_mortality, theorical_uniformity, historical_uniformity, type_posture) FROM stdin;
    public       postgres    false    367   �      �          0    136811    txprogrammed_eggs 
   TABLE DATA                 COPY public.txprogrammed_eggs (programmed_eggs_id, incubator_id, lot_breed, lot_incubator, use_date, eggs, breed_id, execution_quantity, eggs_storage_id, confirm, released, eggs_movements_id, disable, synchronized, order_p, lot_sap, end_lot, diff_days, programmed_disable) FROM stdin;
    public       postgres    false    368   �      �          0    136818    txscenarioformula 
   TABLE DATA               �   COPY public.txscenarioformula (scenario_formula_id, process_id, predecessor_id, parameter_id, sign, divider, duration, scenario_id, measure_id) FROM stdin;
    public       postgres    false    369         �          0    136822    txscenarioparameter 
   TABLE DATA               �   COPY public.txscenarioparameter (scenario_parameter_id, process_id, parameter_id, use_year, use_month, use_value, scenario_id, value_units) FROM stdin;
    public       postgres    false    370   1      �          0    136827    txscenarioparameterday 
   TABLE DATA               �   COPY public.txscenarioparameterday (scenario_parameter_day_id, use_day, parameter_id, units_day, scenario_id, sequence, use_month, use_year, week_day, use_week) FROM stdin;
    public       postgres    false    371   N      �          0    136831    txscenarioposturecurve 
   TABLE DATA               �   COPY public.txscenarioposturecurve (scenario_posture_id, posture_date, eggs, scenario_id, housingway_detail_id, breed_id) FROM stdin;
    public       postgres    false    372   k      �          0    136835    txscenarioprocess 
   TABLE DATA               �   COPY public.txscenarioprocess (scenario_process_id, process_id, decrease_goal, weight_goal, duration_goal, scenario_id) FROM stdin;
    public       postgres    false    373   �      �          0    136839    txsync 
   TABLE DATA               �   COPY public.txsync (sync_id, lot, scheduled_date, scheduled_quantity, farm_code, shed_code, execution_date, execution_quantity, is_error) FROM stdin;
    public       postgres    false    374   �      �           0    0    abaTimeUnit_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public."abaTimeUnit_id_seq"', 1, true);
            public       postgres    false    196            �           0    0    aba_breeds_and_stages_id_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('public.aba_breeds_and_stages_id_seq', 1, true);
            public       postgres    false    197            �           0    0 +   aba_consumption_and_mortality_detail_id_seq    SEQUENCE SET     Y   SELECT pg_catalog.setval('public.aba_consumption_and_mortality_detail_id_seq', 1, true);
            public       postgres    false    201            �           0    0 $   aba_consumption_and_mortality_id_seq    SEQUENCE SET     R   SELECT pg_catalog.setval('public.aba_consumption_and_mortality_id_seq', 1, true);
            public       postgres    false    199            �           0    0 &   aba_elements_and_concentrations_id_seq    SEQUENCE SET     T   SELECT pg_catalog.setval('public.aba_elements_and_concentrations_id_seq', 1, true);
            public       postgres    false    205            �           0    0    aba_elements_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.aba_elements_id_seq', 1, true);
            public       postgres    false    203            �           0    0    aba_elements_properties_id_seq    SEQUENCE SET     M   SELECT pg_catalog.setval('public.aba_elements_properties_id_seq', 1, false);
            public       postgres    false    207            �           0    0    aba_formulation_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.aba_formulation_id_seq', 1, true);
            public       postgres    false    209            �           0    0    aba_results_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.aba_results_id_seq', 1, false);
            public       postgres    false    211            �           0    0 &   aba_stages_of_breeds_and_stages_id_seq    SEQUENCE SET     T   SELECT pg_catalog.setval('public.aba_stages_of_breeds_and_stages_id_seq', 1, true);
            public       postgres    false    212            �           0    0    availability_shed_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.availability_shed_id_seq', 1, false);
            public       postgres    false    215            �           0    0    base_day_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.base_day_id_seq', 1, false);
            public       postgres    false    216            �           0    0    breed_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.breed_id_seq', 1, false);
            public       postgres    false    217            �           0    0    broiler_detail_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.broiler_detail_id_seq', 1, false);
            public       postgres    false    218            �           0    0    broiler_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.broiler_id_seq', 1, false);
            public       postgres    false    219            �           0    0    broiler_product_detail_id_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('public.broiler_product_detail_id_seq', 1, false);
            public       postgres    false    220            �           0    0    broiler_product_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.broiler_product_id_seq', 1, false);
            public       postgres    false    221            �           0    0    broilereviction_detail_id_seq    SEQUENCE SET     N   SELECT pg_catalog.setval('public.broilereviction_detail_id_seq', 124, false);
            public       postgres    false    222            �           0    0    broilereviction_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.broilereviction_id_seq', 70, false);
            public       postgres    false    223            �           0    0    brooder_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.brooder_id_seq', 1, false);
            public       postgres    false    224            �           0    0    brooder_machines_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.brooder_machines_id_seq', 1, false);
            public       postgres    false    225            �           0    0    calendar_day_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.calendar_day_id_seq', 1, false);
            public       postgres    false    226            �           0    0    calendar_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.calendar_id_seq', 1, false);
            public       postgres    false    227            �           0    0    center_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.center_id_seq', 1, false);
            public       postgres    false    228            �           0    0    egg_planning_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.egg_planning_id_seq', 1, false);
            public       postgres    false    229            �           0    0    egg_required_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.egg_required_id_seq', 1, false);
            public       postgres    false    230            �           0    0    eggs_storage_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.eggs_storage_id_seq', 1, false);
            public       postgres    false    231            �           0    0    farm_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.farm_id_seq', 1, false);
            public       postgres    false    232            �           0    0    farm_type_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.farm_type_id_seq', 1, false);
            public       postgres    false    233            �           0    0    holiday_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.holiday_id_seq', 1, false);
            public       postgres    false    234            �           0    0    housing_way_detail_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.housing_way_detail_id_seq', 1, false);
            public       postgres    false    235            �           0    0    housing_way_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.housing_way_id_seq', 1, false);
            public       postgres    false    236            �           0    0    incubator_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.incubator_id_seq', 1, false);
            public       postgres    false    237            �           0    0    incubator_plant_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.incubator_plant_id_seq', 1, false);
            public       postgres    false    238            �           0    0    industry_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.industry_id_seq', 1, false);
            public       postgres    false    239            �           0    0    line_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.line_id_seq', 1, false);
            public       postgres    false    240            �           0    0    lot_eggs_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.lot_eggs_id_seq', 1, false);
            public       postgres    false    241            �           0    0    lot_fattening_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.lot_fattening_id_seq', 1, false);
            public       postgres    false    242            �           0    0 
   lot_id_seq    SEQUENCE SET     9   SELECT pg_catalog.setval('public.lot_id_seq', 1, false);
            public       postgres    false    243            �           0    0    lot_liftbreeding_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.lot_liftbreeding_id_seq', 1, false);
            public       postgres    false    244            �           0    0 0   md_optimizer_parameter_optimizerparameter_id_seq    SEQUENCE SET     _   SELECT pg_catalog.setval('public.md_optimizer_parameter_optimizerparameter_id_seq', 1, false);
            public       postgres    false    246            �           0    0    mdadjustment_adjustment_id_seq    SEQUENCE SET     M   SELECT pg_catalog.setval('public.mdadjustment_adjustment_id_seq', 1, false);
            public       postgres    false    248            �           0    0     mdapplication_application_id_seq    SEQUENCE SET     O   SELECT pg_catalog.setval('public.mdapplication_application_id_seq', 1, false);
            public       postgres    false    249            �           0    0    mdapplication_rol_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.mdapplication_rol_id_seq', 1, false);
            public       postgres    false    251            �           0    0 .   mdequivalenceproduct_equivalenceproduct_id_seq    SEQUENCE SET     ]   SELECT pg_catalog.setval('public.mdequivalenceproduct_equivalenceproduct_id_seq', 1, false);
            public       postgres    false    256            �           0    0    mdrol_rol_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.mdrol_rol_id_seq', 1, false);
            public       postgres    false    266            �           0    0    mduser_user_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.mduser_user_id_seq', 1, false);
            public       postgres    false    274            �           0    0    measure_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.measure_id_seq', 1, false);
            public       postgres    false    258            �           0    0 .   osadjustmentscontrol_adjustmentscontrol_id_seq    SEQUENCE SET     ]   SELECT pg_catalog.setval('public.osadjustmentscontrol_adjustmentscontrol_id_seq', 1, false);
            public       postgres    false    277            �           0    0    parameter_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.parameter_id_seq', 1, false);
            public       postgres    false    260            �           0    0    partnership_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.partnership_id_seq', 1, false);
            public       postgres    false    282            �           0    0    posture_curve_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.posture_curve_id_seq', 1, false);
            public       postgres    false    288            �           0    0    predecessor_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.predecessor_id_seq', 1, false);
            public       postgres    false    289            �           0    0    process_class_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.process_class_id_seq', 1, false);
            public       postgres    false    290            �           0    0    process_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.process_id_seq', 1, false);
            public       postgres    false    262            �           0    0    product_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.product_id_seq', 1, false);
            public       postgres    false    264            �           0    0    programmed_eggs_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.programmed_eggs_id_seq', 1, false);
            public       postgres    false    291            �           0    0    raspberry_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.raspberry_id_seq', 1, false);
            public       postgres    false    292            �           0    0    scenario_formula_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.scenario_formula_id_seq', 1, false);
            public       postgres    false    293            �           0    0    scenario_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.scenario_id_seq', 1, false);
            public       postgres    false    268            �           0    0    scenario_parameter_day_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public.scenario_parameter_day_seq', 1, false);
            public       postgres    false    294            �           0    0    scenario_parameter_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.scenario_parameter_id_seq', 1, false);
            public       postgres    false    295            �           0    0    scenario_posture_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.scenario_posture_id_seq', 1, false);
            public       postgres    false    296            �           0    0    scenario_process_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.scenario_process_id_seq', 1, false);
            public       postgres    false    297            �           0    0    shed_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.shed_id_seq', 1, false);
            public       postgres    false    284            �           0    0    silo_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.silo_id_seq', 1, false);
            public       postgres    false    298            �           0    0    slaughterhouse_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.slaughterhouse_id_seq', 33, false);
            public       postgres    false    286            �           0    0 0   slmdevictionpartition_slevictionpartition_id_seq    SEQUENCE SET     _   SELECT pg_catalog.setval('public.slmdevictionpartition_slevictionpartition_id_seq', 1, false);
            public       postgres    false    299            �           0    0 6   slmdgenderclassification_slgenderclassification_id_seq    SEQUENCE SET     e   SELECT pg_catalog.setval('public.slmdgenderclassification_slgenderclassification_id_seq', 1, false);
            public       postgres    false    302            �           0    0 &   slmdmachinegroup_slmachinegroup_id_seq    SEQUENCE SET     U   SELECT pg_catalog.setval('public.slmdmachinegroup_slmachinegroup_id_seq', 1, false);
            public       postgres    false    303            �           0    0    slmdprocess_slprocess_id_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public.slmdprocess_slprocess_id_seq', 1, false);
            public       postgres    false    306            �           0    0    sltxb_shed_slb_shed_id_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public.sltxb_shed_slb_shed_id_seq', 1, false);
            public       postgres    false    308            �           0    0    sltxbr_shed_slbr_shed_id_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public.sltxbr_shed_slbr_shed_id_seq', 1, false);
            public       postgres    false    310            �           0    0    sltxbreeding_slbreeding_id_seq    SEQUENCE SET     M   SELECT pg_catalog.setval('public.sltxbreeding_slbreeding_id_seq', 1, false);
            public       postgres    false    312            �           0    0 *   sltxbroiler_detail_slbroiler_detail_id_seq    SEQUENCE SET     Y   SELECT pg_catalog.setval('public.sltxbroiler_detail_slbroiler_detail_id_seq', 1, false);
            public       postgres    false    314            �           0    0 $   sltxbroiler_lot_slbroiler_lot_id_seq    SEQUENCE SET     S   SELECT pg_catalog.setval('public.sltxbroiler_lot_slbroiler_lot_id_seq', 1, false);
            public       postgres    false    317            �           0    0    sltxbroiler_slbroiler_id_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public.sltxbroiler_slbroiler_id_seq', 1, false);
            public       postgres    false    318            �           0    0 ,   sltxincubator_curve_slincubator_curve_id_seq    SEQUENCE SET     [   SELECT pg_catalog.setval('public.sltxincubator_curve_slincubator_curve_id_seq', 1, false);
            public       postgres    false    322            �           0    0 .   sltxincubator_detail_slincubator_detail_id_seq    SEQUENCE SET     ]   SELECT pg_catalog.setval('public.sltxincubator_detail_slincubator_detail_id_seq', 1, false);
            public       postgres    false    323            �           0    0 (   sltxincubator_lot_slincubator_lot_id_seq    SEQUENCE SET     W   SELECT pg_catalog.setval('public.sltxincubator_lot_slincubator_lot_id_seq', 1, false);
            public       postgres    false    326            �           0    0    sltxincubator_slincubator_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('public.sltxincubator_slincubator_seq', 1, false);
            public       postgres    false    319            �           0    0     sltxinventory_slinventory_id_seq    SEQUENCE SET     O   SELECT pg_catalog.setval('public.sltxinventory_slinventory_id_seq', 1, false);
            public       postgres    false    328            �           0    0    sltxlb_shed_sllb_shed_id_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public.sltxlb_shed_sllb_shed_id_seq', 1, false);
            public       postgres    false    330            �           0    0 &   sltxliftbreeding_slliftbreeding_id_seq    SEQUENCE SET     U   SELECT pg_catalog.setval('public.sltxliftbreeding_slliftbreeding_id_seq', 1, false);
            public       postgres    false    332            �           0    0 &   sltxposturecurve_slposturecurve_id_seq    SEQUENCE SET     U   SELECT pg_catalog.setval('public.sltxposturecurve_slposturecurve_id_seq', 1, false);
            public       postgres    false    334            �           0    0 (   sltxsellspurchase_slsellspurchase_id_seq    SEQUENCE SET     W   SELECT pg_catalog.setval('public.sltxsellspurchase_slsellspurchase_id_seq', 1, false);
            public       postgres    false    336            �           0    0    stage_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.stage_id_seq', 5, true);
            public       postgres    false    272            �           0    0    status_shed_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.status_shed_id_seq', 1, false);
            public       postgres    false    270            �           0    0 .   txadjustmentscontrol_adjustmentscontrol_id_seq    SEQUENCE SET     ]   SELECT pg_catalog.setval('public.txadjustmentscontrol_adjustmentscontrol_id_seq', 1, false);
            public       postgres    false    338            �           0    0     txbroiler_lot_broiler_lot_id_seq    SEQUENCE SET     O   SELECT pg_catalog.setval('public.txbroiler_lot_broiler_lot_id_seq', 1, false);
            public       postgres    false    343            �           0    0 1   txbroilerheavy_detail_broiler_heavy_detail_id_seq    SEQUENCE SET     `   SELECT pg_catalog.setval('public.txbroilerheavy_detail_broiler_heavy_detail_id_seq', 1, false);
            public       postgres    false    347            �           0    0    txeggs_movements_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.txeggs_movements_id_seq', 170, false);
            public       postgres    false    350            �           0    0    txgoals_erp_goals_erp_id_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public.txgoals_erp_goals_erp_id_seq', 1, false);
            public       postgres    false    356            �           0    0 %   txhousingway_lot_txhousingway_lot_seq    SEQUENCE SET     T   SELECT pg_catalog.setval('public.txhousingway_lot_txhousingway_lot_seq', 1, false);
            public       postgres    false    360            �           0    0 $   txincubator_lot_incubator_lot_id_seq    SEQUENCE SET     S   SELECT pg_catalog.setval('public.txincubator_lot_incubator_lot_id_seq', 1, false);
            public       postgres    false    362            �           0    0 (   txincubator_sales_incubator_sales_id_seq    SEQUENCE SET     W   SELECT pg_catalog.setval('public.txincubator_sales_incubator_sales_id_seq', 1, false);
            public       postgres    false    364            �           0    0    txsync_sync_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.txsync_sync_id_seq', 1, false);
            public       postgres    false    375            �           0    0 #   user_application_application_id_seq    SEQUENCE SET     R   SELECT pg_catalog.setval('public.user_application_application_id_seq', 1, false);
            public       postgres    false    376            �           0    0     user_application_user_app_id_seq    SEQUENCE SET     Q   SELECT pg_catalog.setval('public.user_application_user_app_id_seq', 215, false);
            public       postgres    false    377            �           0    0    user_application_user_id_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public.user_application_user_id_seq', 1, false);
            public       postgres    false    378            �           0    0    warehouse_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.warehouse_id_seq', 1, false);
            public       postgres    false    379                       2606    136882    aba_time_unit abaTimeUnit_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public.aba_time_unit
    ADD CONSTRAINT "abaTimeUnit_pkey" PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.aba_time_unit DROP CONSTRAINT "abaTimeUnit_pkey";
       public         postgres    false    214            �           2606    136884 0   aba_breeds_and_stages aba_breeds_and_stages_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY public.aba_breeds_and_stages
    ADD CONSTRAINT aba_breeds_and_stages_pkey PRIMARY KEY (id);
 Z   ALTER TABLE ONLY public.aba_breeds_and_stages DROP CONSTRAINT aba_breeds_and_stages_pkey;
       public         postgres    false    198                        2606    136886 N   aba_consumption_and_mortality_detail aba_consumption_and_mortality_detail_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.aba_consumption_and_mortality_detail
    ADD CONSTRAINT aba_consumption_and_mortality_detail_pkey PRIMARY KEY (id);
 x   ALTER TABLE ONLY public.aba_consumption_and_mortality_detail DROP CONSTRAINT aba_consumption_and_mortality_detail_pkey;
       public         postgres    false    202            �           2606    136888 @   aba_consumption_and_mortality aba_consumption_and_mortality_pkey 
   CONSTRAINT     ~   ALTER TABLE ONLY public.aba_consumption_and_mortality
    ADD CONSTRAINT aba_consumption_and_mortality_pkey PRIMARY KEY (id);
 j   ALTER TABLE ONLY public.aba_consumption_and_mortality DROP CONSTRAINT aba_consumption_and_mortality_pkey;
       public         postgres    false    200                       2606    136890 D   aba_elements_and_concentrations aba_elements_and_concentrations_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.aba_elements_and_concentrations
    ADD CONSTRAINT aba_elements_and_concentrations_pkey PRIMARY KEY (id);
 n   ALTER TABLE ONLY public.aba_elements_and_concentrations DROP CONSTRAINT aba_elements_and_concentrations_pkey;
       public         postgres    false    206                       2606    136892    aba_elements aba_elements_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.aba_elements
    ADD CONSTRAINT aba_elements_pkey PRIMARY KEY (id);
 H   ALTER TABLE ONLY public.aba_elements DROP CONSTRAINT aba_elements_pkey;
       public         postgres    false    204            	           2606    136894 4   aba_elements_properties aba_elements_properties_pkey 
   CONSTRAINT     r   ALTER TABLE ONLY public.aba_elements_properties
    ADD CONSTRAINT aba_elements_properties_pkey PRIMARY KEY (id);
 ^   ALTER TABLE ONLY public.aba_elements_properties DROP CONSTRAINT aba_elements_properties_pkey;
       public         postgres    false    208                       2606    136896 $   aba_formulation aba_formulation_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public.aba_formulation
    ADD CONSTRAINT aba_formulation_pkey PRIMARY KEY (id);
 N   ALTER TABLE ONLY public.aba_formulation DROP CONSTRAINT aba_formulation_pkey;
       public         postgres    false    210                       2606    136898 D   aba_stages_of_breeds_and_stages aba_stages_of_breeds_and_stages_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.aba_stages_of_breeds_and_stages
    ADD CONSTRAINT aba_stages_of_breeds_and_stages_pkey PRIMARY KEY (id);
 n   ALTER TABLE ONLY public.aba_stages_of_breeds_and_stages DROP CONSTRAINT aba_stages_of_breeds_and_stages_pkey;
       public         postgres    false    213                       2606    136900    mdapplication application_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY public.mdapplication
    ADD CONSTRAINT application_pkey PRIMARY KEY (application_id);
 H   ALTER TABLE ONLY public.mdapplication DROP CONSTRAINT application_pkey;
       public         postgres    false    250                       2606    136902 2   md_optimizer_parameter md_optimizer_parameter_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.md_optimizer_parameter
    ADD CONSTRAINT md_optimizer_parameter_pkey PRIMARY KEY (optimizerparameter_id);
 \   ALTER TABLE ONLY public.md_optimizer_parameter DROP CONSTRAINT md_optimizer_parameter_pkey;
       public         postgres    false    245                       2606    136904 (   mdapplication_rol mdapplication_rol_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY public.mdapplication_rol
    ADD CONSTRAINT mdapplication_rol_pkey PRIMARY KEY (id);
 R   ALTER TABLE ONLY public.mdapplication_rol DROP CONSTRAINT mdapplication_rol_pkey;
       public         postgres    false    252                       2606    136906    mdbreed mdbreed_code_key 
   CONSTRAINT     S   ALTER TABLE ONLY public.mdbreed
    ADD CONSTRAINT mdbreed_code_key UNIQUE (code);
 B   ALTER TABLE ONLY public.mdbreed DROP CONSTRAINT mdbreed_code_key;
       public         postgres    false    253                       2606    136908    mdbreed mdbreed_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.mdbreed
    ADD CONSTRAINT mdbreed_pkey PRIMARY KEY (breed_id);
 >   ALTER TABLE ONLY public.mdbreed DROP CONSTRAINT mdbreed_pkey;
       public         postgres    false    253                       2606    136910 (   mdbroiler_product mdbroiler_product_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY public.mdbroiler_product
    ADD CONSTRAINT mdbroiler_product_pkey PRIMARY KEY (broiler_product_id);
 R   ALTER TABLE ONLY public.mdbroiler_product DROP CONSTRAINT mdbroiler_product_pkey;
       public         postgres    false    254            !           2606    136912    mdfarmtype mdfarmtype_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public.mdfarmtype
    ADD CONSTRAINT mdfarmtype_pkey PRIMARY KEY (farm_type_id);
 D   ALTER TABLE ONLY public.mdfarmtype DROP CONSTRAINT mdfarmtype_pkey;
       public         postgres    false    257            #           2606    136914    mdmeasure mdmeasure_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public.mdmeasure
    ADD CONSTRAINT mdmeasure_pkey PRIMARY KEY (measure_id);
 B   ALTER TABLE ONLY public.mdmeasure DROP CONSTRAINT mdmeasure_pkey;
       public         postgres    false    259            '           2606    136916    mdparameter mdparameter_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public.mdparameter
    ADD CONSTRAINT mdparameter_pkey PRIMARY KEY (parameter_id);
 F   ALTER TABLE ONLY public.mdparameter DROP CONSTRAINT mdparameter_pkey;
       public         postgres    false    261            ,           2606    136918    mdprocess mdprocess_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public.mdprocess
    ADD CONSTRAINT mdprocess_pkey PRIMARY KEY (process_id);
 B   ALTER TABLE ONLY public.mdprocess DROP CONSTRAINT mdprocess_pkey;
       public         postgres    false    263            .           2606    136920    mdproduct mdproduct_code_unique 
   CONSTRAINT     Z   ALTER TABLE ONLY public.mdproduct
    ADD CONSTRAINT mdproduct_code_unique UNIQUE (code);
 I   ALTER TABLE ONLY public.mdproduct DROP CONSTRAINT mdproduct_code_unique;
       public         postgres    false    265            0           2606    136922    mdproduct mdproduct_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public.mdproduct
    ADD CONSTRAINT mdproduct_pkey PRIMARY KEY (product_id);
 B   ALTER TABLE ONLY public.mdproduct DROP CONSTRAINT mdproduct_pkey;
       public         postgres    false    265            6           2606    136924 !   mdscenario mdscenario_name_unique 
   CONSTRAINT     \   ALTER TABLE ONLY public.mdscenario
    ADD CONSTRAINT mdscenario_name_unique UNIQUE (name);
 K   ALTER TABLE ONLY public.mdscenario DROP CONSTRAINT mdscenario_name_unique;
       public         postgres    false    269            8           2606    136926    mdscenario mdscenario_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY public.mdscenario
    ADD CONSTRAINT mdscenario_pkey PRIMARY KEY (scenario_id);
 D   ALTER TABLE ONLY public.mdscenario DROP CONSTRAINT mdscenario_pkey;
       public         postgres    false    269            :           2606    136928    mdshedstatus mdshedstatus_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY public.mdshedstatus
    ADD CONSTRAINT mdshedstatus_pkey PRIMARY KEY (shed_status_id);
 H   ALTER TABLE ONLY public.mdshedstatus DROP CONSTRAINT mdshedstatus_pkey;
       public         postgres    false    271            <           2606    136930    mdstage mdstage_name_unique 
   CONSTRAINT     V   ALTER TABLE ONLY public.mdstage
    ADD CONSTRAINT mdstage_name_unique UNIQUE (name);
 E   ALTER TABLE ONLY public.mdstage DROP CONSTRAINT mdstage_name_unique;
       public         postgres    false    273            >           2606    136932    mdstage mdstage_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.mdstage
    ADD CONSTRAINT mdstage_pkey PRIMARY KEY (stage_id);
 >   ALTER TABLE ONLY public.mdstage DROP CONSTRAINT mdstage_pkey;
       public         postgres    false    273            A           2606    136934    mduser mduser_user_id_pkey 
   CONSTRAINT     ]   ALTER TABLE ONLY public.mduser
    ADD CONSTRAINT mduser_user_id_pkey PRIMARY KEY (user_id);
 D   ALTER TABLE ONLY public.mduser DROP CONSTRAINT mduser_user_id_pkey;
       public         postgres    false    275            C           2606    136936    mduser mduser_username_unique 
   CONSTRAINT     \   ALTER TABLE ONLY public.mduser
    ADD CONSTRAINT mduser_username_unique UNIQUE (username);
 G   ALTER TABLE ONLY public.mduser DROP CONSTRAINT mduser_username_unique;
       public         postgres    false    275            E           2606    136938 .   osadjustmentscontrol osadjustmentscontrol_pkey 
   CONSTRAINT        ALTER TABLE ONLY public.osadjustmentscontrol
    ADD CONSTRAINT osadjustmentscontrol_pkey PRIMARY KEY (adjustmentscontrol_id);
 X   ALTER TABLE ONLY public.osadjustmentscontrol DROP CONSTRAINT osadjustmentscontrol_pkey;
       public         postgres    false    276            I           2606    136940 "   oscenter oscenter_code_farm_id_key 
   CONSTRAINT     f   ALTER TABLE ONLY public.oscenter
    ADD CONSTRAINT oscenter_code_farm_id_key UNIQUE (code, farm_id);
 L   ALTER TABLE ONLY public.oscenter DROP CONSTRAINT oscenter_code_farm_id_key;
       public         postgres    false    278    278            K           2606    136942 #   oscenter oscenter_code_farm_id_key1 
   CONSTRAINT     g   ALTER TABLE ONLY public.oscenter
    ADD CONSTRAINT oscenter_code_farm_id_key1 UNIQUE (code, farm_id);
 M   ALTER TABLE ONLY public.oscenter DROP CONSTRAINT oscenter_code_farm_id_key1;
       public         postgres    false    278    278            M           2606    136944 .   oscenter oscenter_partnership_farm_code_unique 
   CONSTRAINT     �   ALTER TABLE ONLY public.oscenter
    ADD CONSTRAINT oscenter_partnership_farm_code_unique UNIQUE (partnership_id, farm_id, code);
 X   ALTER TABLE ONLY public.oscenter DROP CONSTRAINT oscenter_partnership_farm_code_unique;
       public         postgres    false    278    278    278            O           2606    136946    oscenter oscenter_pkey 
   CONSTRAINT     [   ALTER TABLE ONLY public.oscenter
    ADD CONSTRAINT oscenter_pkey PRIMARY KEY (center_id);
 @   ALTER TABLE ONLY public.oscenter DROP CONSTRAINT oscenter_pkey;
       public         postgres    false    278            S           2606    136948 %   osfarm osfarm_code_partnership_id_key 
   CONSTRAINT     p   ALTER TABLE ONLY public.osfarm
    ADD CONSTRAINT osfarm_code_partnership_id_key UNIQUE (code, partnership_id);
 O   ALTER TABLE ONLY public.osfarm DROP CONSTRAINT osfarm_code_partnership_id_key;
       public         postgres    false    279    279            U           2606    136950 &   osfarm osfarm_code_partnership_id_key1 
   CONSTRAINT     q   ALTER TABLE ONLY public.osfarm
    ADD CONSTRAINT osfarm_code_partnership_id_key1 UNIQUE (code, partnership_id);
 P   ALTER TABLE ONLY public.osfarm DROP CONSTRAINT osfarm_code_partnership_id_key1;
       public         postgres    false    279    279            W           2606    136952 %   osfarm osfarm_partnership_code_unique 
   CONSTRAINT     p   ALTER TABLE ONLY public.osfarm
    ADD CONSTRAINT osfarm_partnership_code_unique UNIQUE (partnership_id, code);
 O   ALTER TABLE ONLY public.osfarm DROP CONSTRAINT osfarm_partnership_code_unique;
       public         postgres    false    279    279            Y           2606    136954    osfarm osfarm_pkey 
   CONSTRAINT     U   ALTER TABLE ONLY public.osfarm
    ADD CONSTRAINT osfarm_pkey PRIMARY KEY (farm_id);
 <   ALTER TABLE ONLY public.osfarm DROP CONSTRAINT osfarm_pkey;
       public         postgres    false    279            u           2606    136956    osshed oshed_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.osshed
    ADD CONSTRAINT oshed_pkey PRIMARY KEY (shed_id);
 ;   ALTER TABLE ONLY public.osshed DROP CONSTRAINT oshed_pkey;
       public         postgres    false    285            \           2606    136958 2   osincubator osincubator_incubatorplant_code_unique 
   CONSTRAINT     �   ALTER TABLE ONLY public.osincubator
    ADD CONSTRAINT osincubator_incubatorplant_code_unique UNIQUE (incubator_plant_id, code);
 \   ALTER TABLE ONLY public.osincubator DROP CONSTRAINT osincubator_incubatorplant_code_unique;
       public         postgres    false    280    280            ^           2606    136960    osincubator osincubator_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public.osincubator
    ADD CONSTRAINT osincubator_pkey PRIMARY KEY (incubator_id);
 F   ALTER TABLE ONLY public.osincubator DROP CONSTRAINT osincubator_pkey;
       public         postgres    false    280            a           2606    136962 9   osincubatorplant osincubatorplant_code_partnership_id_key 
   CONSTRAINT     �   ALTER TABLE ONLY public.osincubatorplant
    ADD CONSTRAINT osincubatorplant_code_partnership_id_key UNIQUE (code, partnership_id);
 c   ALTER TABLE ONLY public.osincubatorplant DROP CONSTRAINT osincubatorplant_code_partnership_id_key;
       public         postgres    false    281    281            c           2606    136964 :   osincubatorplant osincubatorplant_code_partnership_id_key1 
   CONSTRAINT     �   ALTER TABLE ONLY public.osincubatorplant
    ADD CONSTRAINT osincubatorplant_code_partnership_id_key1 UNIQUE (code, partnership_id);
 d   ALTER TABLE ONLY public.osincubatorplant DROP CONSTRAINT osincubatorplant_code_partnership_id_key1;
       public         postgres    false    281    281            e           2606    136966 9   osincubatorplant osincubatorplant_partnership_code_unique 
   CONSTRAINT     �   ALTER TABLE ONLY public.osincubatorplant
    ADD CONSTRAINT osincubatorplant_partnership_code_unique UNIQUE (partnership_id, code);
 c   ALTER TABLE ONLY public.osincubatorplant DROP CONSTRAINT osincubatorplant_partnership_code_unique;
       public         postgres    false    281    281            g           2606    136968 &   osincubatorplant osincubatorplant_pkey 
   CONSTRAINT     t   ALTER TABLE ONLY public.osincubatorplant
    ADD CONSTRAINT osincubatorplant_pkey PRIMARY KEY (incubator_plant_id);
 P   ALTER TABLE ONLY public.osincubatorplant DROP CONSTRAINT osincubatorplant_pkey;
       public         postgres    false    281            i           2606    136970 $   ospartnership ospartnership_code_key 
   CONSTRAINT     _   ALTER TABLE ONLY public.ospartnership
    ADD CONSTRAINT ospartnership_code_key UNIQUE (code);
 N   ALTER TABLE ONLY public.ospartnership DROP CONSTRAINT ospartnership_code_key;
       public         postgres    false    283            k           2606    136972 %   ospartnership ospartnership_code_key1 
   CONSTRAINT     `   ALTER TABLE ONLY public.ospartnership
    ADD CONSTRAINT ospartnership_code_key1 UNIQUE (code);
 O   ALTER TABLE ONLY public.ospartnership DROP CONSTRAINT ospartnership_code_key1;
       public         postgres    false    283            m           2606    136974 '   ospartnership ospartnership_code_unique 
   CONSTRAINT     b   ALTER TABLE ONLY public.ospartnership
    ADD CONSTRAINT ospartnership_code_unique UNIQUE (code);
 Q   ALTER TABLE ONLY public.ospartnership DROP CONSTRAINT ospartnership_code_unique;
       public         postgres    false    283            o           2606    136976     ospartnership ospartnership_pkey 
   CONSTRAINT     j   ALTER TABLE ONLY public.ospartnership
    ADD CONSTRAINT ospartnership_pkey PRIMARY KEY (partnership_id);
 J   ALTER TABLE ONLY public.ospartnership DROP CONSTRAINT ospartnership_pkey;
       public         postgres    false    283            w           2606    136978     osshed osshed_code_center_id_key 
   CONSTRAINT     f   ALTER TABLE ONLY public.osshed
    ADD CONSTRAINT osshed_code_center_id_key UNIQUE (code, center_id);
 J   ALTER TABLE ONLY public.osshed DROP CONSTRAINT osshed_code_center_id_key;
       public         postgres    false    285    285            y           2606    136980 !   osshed osshed_code_center_id_key1 
   CONSTRAINT     g   ALTER TABLE ONLY public.osshed
    ADD CONSTRAINT osshed_code_center_id_key1 UNIQUE (code, center_id);
 K   ALTER TABLE ONLY public.osshed DROP CONSTRAINT osshed_code_center_id_key1;
       public         postgres    false    285    285            {           2606    136982 1   osshed osshed_partnership_farm_center_code_unique 
   CONSTRAINT     �   ALTER TABLE ONLY public.osshed
    ADD CONSTRAINT osshed_partnership_farm_center_code_unique UNIQUE (partnership_id, farm_id, center_id, code);
 [   ALTER TABLE ONLY public.osshed DROP CONSTRAINT osshed_partnership_farm_center_code_unique;
       public         postgres    false    285    285    285    285            }           2606    136984 &   osslaughterhouse osslaughterhouse_pkey 
   CONSTRAINT     s   ALTER TABLE ONLY public.osslaughterhouse
    ADD CONSTRAINT osslaughterhouse_pkey PRIMARY KEY (slaughterhouse_id);
 P   ALTER TABLE ONLY public.osslaughterhouse DROP CONSTRAINT osslaughterhouse_pkey;
       public         postgres    false    287            2           2606    136986    mdrol rol_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public.mdrol
    ADD CONSTRAINT rol_pkey PRIMARY KEY (rol_id);
 8   ALTER TABLE ONLY public.mdrol DROP CONSTRAINT rol_pkey;
       public         postgres    false    267                       2606    136988 0   slmdevictionpartition slmdevictionpartition_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.slmdevictionpartition
    ADD CONSTRAINT slmdevictionpartition_pkey PRIMARY KEY (slevictionpartition_id);
 Z   ALTER TABLE ONLY public.slmdevictionpartition DROP CONSTRAINT slmdevictionpartition_pkey;
       public         postgres    false    300            �           2606    136990 6   slmdgenderclassification slmdgenderclassification_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.slmdgenderclassification
    ADD CONSTRAINT slmdgenderclassification_pkey PRIMARY KEY (slgenderclassification_id);
 `   ALTER TABLE ONLY public.slmdgenderclassification DROP CONSTRAINT slmdgenderclassification_pkey;
       public         postgres    false    301            �           2606    136992 &   slmdmachinegroup slmdmachinegroup_pkey 
   CONSTRAINT     s   ALTER TABLE ONLY public.slmdmachinegroup
    ADD CONSTRAINT slmdmachinegroup_pkey PRIMARY KEY (slmachinegroup_id);
 P   ALTER TABLE ONLY public.slmdmachinegroup DROP CONSTRAINT slmdmachinegroup_pkey;
       public         postgres    false    304            �           2606    136994    slmdprocess slmdprocess_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public.slmdprocess
    ADD CONSTRAINT slmdprocess_pkey PRIMARY KEY (slprocess_id);
 F   ALTER TABLE ONLY public.slmdprocess DROP CONSTRAINT slmdprocess_pkey;
       public         postgres    false    305            �           2606    136996    sltxb_shed sltxb_shed_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY public.sltxb_shed
    ADD CONSTRAINT sltxb_shed_pkey PRIMARY KEY (slb_shed_id);
 D   ALTER TABLE ONLY public.sltxb_shed DROP CONSTRAINT sltxb_shed_pkey;
       public         postgres    false    307            �           2606    136998    sltxbr_shed sltxbr_shed_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public.sltxbr_shed
    ADD CONSTRAINT sltxbr_shed_pkey PRIMARY KEY (slbr_shed_id);
 F   ALTER TABLE ONLY public.sltxbr_shed DROP CONSTRAINT sltxbr_shed_pkey;
       public         postgres    false    309            �           2606    137000    sltxbreeding sltxbreeding_pkey 
   CONSTRAINT     g   ALTER TABLE ONLY public.sltxbreeding
    ADD CONSTRAINT sltxbreeding_pkey PRIMARY KEY (slbreeding_id);
 H   ALTER TABLE ONLY public.sltxbreeding DROP CONSTRAINT sltxbreeding_pkey;
       public         postgres    false    311            �           2606    137002 *   sltxbroiler_detail sltxbroiler_detail_pkey 
   CONSTRAINT     y   ALTER TABLE ONLY public.sltxbroiler_detail
    ADD CONSTRAINT sltxbroiler_detail_pkey PRIMARY KEY (slbroiler_detail_id);
 T   ALTER TABLE ONLY public.sltxbroiler_detail DROP CONSTRAINT sltxbroiler_detail_pkey;
       public         postgres    false    315            �           2606    137004 $   sltxbroiler_lot sltxbroiler_lot_pkey 
   CONSTRAINT     p   ALTER TABLE ONLY public.sltxbroiler_lot
    ADD CONSTRAINT sltxbroiler_lot_pkey PRIMARY KEY (slbroiler_lot_id);
 N   ALTER TABLE ONLY public.sltxbroiler_lot DROP CONSTRAINT sltxbroiler_lot_pkey;
       public         postgres    false    316            �           2606    137006    sltxbroiler sltxbroiler_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public.sltxbroiler
    ADD CONSTRAINT sltxbroiler_pkey PRIMARY KEY (slbroiler_id);
 F   ALTER TABLE ONLY public.sltxbroiler DROP CONSTRAINT sltxbroiler_pkey;
       public         postgres    false    313            �           2606    137008 ,   sltxincubator_curve sltxincubator_curve_pkey 
   CONSTRAINT     |   ALTER TABLE ONLY public.sltxincubator_curve
    ADD CONSTRAINT sltxincubator_curve_pkey PRIMARY KEY (slincubator_curve_id);
 V   ALTER TABLE ONLY public.sltxincubator_curve DROP CONSTRAINT sltxincubator_curve_pkey;
       public         postgres    false    321            �           2606    137010 .   sltxincubator_detail sltxincubator_detail_pkey 
   CONSTRAINT        ALTER TABLE ONLY public.sltxincubator_detail
    ADD CONSTRAINT sltxincubator_detail_pkey PRIMARY KEY (slincubator_detail_id);
 X   ALTER TABLE ONLY public.sltxincubator_detail DROP CONSTRAINT sltxincubator_detail_pkey;
       public         postgres    false    324            �           2606    137012 (   sltxincubator_lot sltxincubator_lot_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY public.sltxincubator_lot
    ADD CONSTRAINT sltxincubator_lot_pkey PRIMARY KEY (slincubator_lot_id);
 R   ALTER TABLE ONLY public.sltxincubator_lot DROP CONSTRAINT sltxincubator_lot_pkey;
       public         postgres    false    325            �           2606    137014     sltxincubator sltxincubator_pkey 
   CONSTRAINT     g   ALTER TABLE ONLY public.sltxincubator
    ADD CONSTRAINT sltxincubator_pkey PRIMARY KEY (slincubator);
 J   ALTER TABLE ONLY public.sltxincubator DROP CONSTRAINT sltxincubator_pkey;
       public         postgres    false    320            �           2606    137016     sltxinventory sltxinventory_pkey 
   CONSTRAINT     j   ALTER TABLE ONLY public.sltxinventory
    ADD CONSTRAINT sltxinventory_pkey PRIMARY KEY (slinventory_id);
 J   ALTER TABLE ONLY public.sltxinventory DROP CONSTRAINT sltxinventory_pkey;
       public         postgres    false    327            �           2606    137018    sltxlb_shed sltxlb_shed_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public.sltxlb_shed
    ADD CONSTRAINT sltxlb_shed_pkey PRIMARY KEY (sllb_shed_id);
 F   ALTER TABLE ONLY public.sltxlb_shed DROP CONSTRAINT sltxlb_shed_pkey;
       public         postgres    false    329            �           2606    137020 &   sltxliftbreeding sltxliftbreeding_pkey 
   CONSTRAINT     s   ALTER TABLE ONLY public.sltxliftbreeding
    ADD CONSTRAINT sltxliftbreeding_pkey PRIMARY KEY (slliftbreeding_id);
 P   ALTER TABLE ONLY public.sltxliftbreeding DROP CONSTRAINT sltxliftbreeding_pkey;
       public         postgres    false    331            �           2606    137022 &   sltxposturecurve sltxposturecurve_pkey 
   CONSTRAINT     s   ALTER TABLE ONLY public.sltxposturecurve
    ADD CONSTRAINT sltxposturecurve_pkey PRIMARY KEY (slposturecurve_id);
 P   ALTER TABLE ONLY public.sltxposturecurve DROP CONSTRAINT sltxposturecurve_pkey;
       public         postgres    false    333            �           2606    137024 (   sltxsellspurchase sltxsellspurchase_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY public.sltxsellspurchase
    ADD CONSTRAINT sltxsellspurchase_pkey PRIMARY KEY (slsellspurchase_id);
 R   ALTER TABLE ONLY public.sltxsellspurchase DROP CONSTRAINT sltxsellspurchase_pkey;
       public         postgres    false    335            �           2606    137026 .   txadjustmentscontrol txadjustmentscontrol_pkey 
   CONSTRAINT        ALTER TABLE ONLY public.txadjustmentscontrol
    ADD CONSTRAINT txadjustmentscontrol_pkey PRIMARY KEY (adjustmentscontrol_id);
 X   ALTER TABLE ONLY public.txadjustmentscontrol DROP CONSTRAINT txadjustmentscontrol_pkey;
       public         postgres    false    337            �           2606    137028 ,   txavailabilitysheds txavailabilitysheds_pkey 
   CONSTRAINT     |   ALTER TABLE ONLY public.txavailabilitysheds
    ADD CONSTRAINT txavailabilitysheds_pkey PRIMARY KEY (availability_shed_id);
 V   ALTER TABLE ONLY public.txavailabilitysheds DROP CONSTRAINT txavailabilitysheds_pkey;
       public         postgres    false    339            �           2606    137030 &   txbroiler_detail txbroiler_detail_pkey 
   CONSTRAINT     s   ALTER TABLE ONLY public.txbroiler_detail
    ADD CONSTRAINT txbroiler_detail_pkey PRIMARY KEY (broiler_detail_id);
 P   ALTER TABLE ONLY public.txbroiler_detail DROP CONSTRAINT txbroiler_detail_pkey;
       public         postgres    false    341            �           2606    137032     txbroiler_lot txbroiler_lot_pkey 
   CONSTRAINT     j   ALTER TABLE ONLY public.txbroiler_lot
    ADD CONSTRAINT txbroiler_lot_pkey PRIMARY KEY (broiler_lot_id);
 J   ALTER TABLE ONLY public.txbroiler_lot DROP CONSTRAINT txbroiler_lot_pkey;
       public         postgres    false    342            �           2606    137034    txbroiler txbroiler_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public.txbroiler
    ADD CONSTRAINT txbroiler_pkey PRIMARY KEY (broiler_id);
 B   ALTER TABLE ONLY public.txbroiler DROP CONSTRAINT txbroiler_pkey;
       public         postgres    false    340            �           2606    137036 6   txbroilereviction_detail txbroilereviction_detail_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.txbroilereviction_detail
    ADD CONSTRAINT txbroilereviction_detail_pkey PRIMARY KEY (broilereviction_detail_id);
 `   ALTER TABLE ONLY public.txbroilereviction_detail DROP CONSTRAINT txbroilereviction_detail_pkey;
       public         postgres    false    345            �           2606    137038 (   txbroilereviction txbroilereviction_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY public.txbroilereviction
    ADD CONSTRAINT txbroilereviction_pkey PRIMARY KEY (broilereviction_id);
 R   ALTER TABLE ONLY public.txbroilereviction DROP CONSTRAINT txbroilereviction_pkey;
       public         postgres    false    344            �           2606    137040 0   txbroilerheavy_detail txbroilerheavy_detail_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.txbroilerheavy_detail
    ADD CONSTRAINT txbroilerheavy_detail_pkey PRIMARY KEY (broiler_heavy_detail_id);
 Z   ALTER TABLE ONLY public.txbroilerheavy_detail DROP CONSTRAINT txbroilerheavy_detail_pkey;
       public         postgres    false    346            �           2606    137042 4   txbroilerproduct_detail txbroilerproduct_detail_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.txbroilerproduct_detail
    ADD CONSTRAINT txbroilerproduct_detail_pkey PRIMARY KEY (broilerproduct_detail_id);
 ^   ALTER TABLE ONLY public.txbroilerproduct_detail DROP CONSTRAINT txbroilerproduct_detail_pkey;
       public         postgres    false    348            �           2606    137044 &   txbroodermachine txbroodermachine_pkey 
   CONSTRAINT     x   ALTER TABLE ONLY public.txbroodermachine
    ADD CONSTRAINT txbroodermachine_pkey PRIMARY KEY (brooder_machine_id_seq);
 P   ALTER TABLE ONLY public.txbroodermachine DROP CONSTRAINT txbroodermachine_pkey;
       public         postgres    false    349            �           2606    137050 &   txeggs_movements txeggs_movements_pkey 
   CONSTRAINT     s   ALTER TABLE ONLY public.txeggs_movements
    ADD CONSTRAINT txeggs_movements_pkey PRIMARY KEY (eggs_movements_id);
 P   ALTER TABLE ONLY public.txeggs_movements DROP CONSTRAINT txeggs_movements_pkey;
       public         postgres    false    351            �           2606    137052 $   txeggs_planning txeggs_planning_pkey 
   CONSTRAINT     o   ALTER TABLE ONLY public.txeggs_planning
    ADD CONSTRAINT txeggs_planning_pkey PRIMARY KEY (egg_planning_id);
 N   ALTER TABLE ONLY public.txeggs_planning DROP CONSTRAINT txeggs_planning_pkey;
       public         postgres    false    352            �           2606    137054 $   txeggs_required txeggs_required_pkey 
   CONSTRAINT     o   ALTER TABLE ONLY public.txeggs_required
    ADD CONSTRAINT txeggs_required_pkey PRIMARY KEY (egg_required_id);
 N   ALTER TABLE ONLY public.txeggs_required DROP CONSTRAINT txeggs_required_pkey;
       public         postgres    false    353            �           2606    137056 "   txeggs_storage txeggs_storage_pkey 
   CONSTRAINT     m   ALTER TABLE ONLY public.txeggs_storage
    ADD CONSTRAINT txeggs_storage_pkey PRIMARY KEY (eggs_storage_id);
 L   ALTER TABLE ONLY public.txeggs_storage DROP CONSTRAINT txeggs_storage_pkey;
       public         postgres    false    354            �           2606    137058    txgoals_erp txgoals_erp_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public.txgoals_erp
    ADD CONSTRAINT txgoals_erp_pkey PRIMARY KEY (goals_erp_id);
 F   ALTER TABLE ONLY public.txgoals_erp DROP CONSTRAINT txgoals_erp_pkey;
       public         postgres    false    355            �           2606    137060 ,   txhousingway_detail txhousingway_detail_pkey 
   CONSTRAINT     |   ALTER TABLE ONLY public.txhousingway_detail
    ADD CONSTRAINT txhousingway_detail_pkey PRIMARY KEY (housingway_detail_id);
 V   ALTER TABLE ONLY public.txhousingway_detail DROP CONSTRAINT txhousingway_detail_pkey;
       public         postgres    false    358            �           2606    137062 &   txhousingway_lot txhousingway_lot_pkey 
   CONSTRAINT     s   ALTER TABLE ONLY public.txhousingway_lot
    ADD CONSTRAINT txhousingway_lot_pkey PRIMARY KEY (housingway_lot_id);
 P   ALTER TABLE ONLY public.txhousingway_lot DROP CONSTRAINT txhousingway_lot_pkey;
       public         postgres    false    359            �           2606    137064    txhousingway txhousingway_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY public.txhousingway
    ADD CONSTRAINT txhousingway_pkey PRIMARY KEY (housing_way_id);
 H   ALTER TABLE ONLY public.txhousingway DROP CONSTRAINT txhousingway_pkey;
       public         postgres    false    357            �           2606    137066 $   txincubator_lot txincubator_lot_pkey 
   CONSTRAINT     p   ALTER TABLE ONLY public.txincubator_lot
    ADD CONSTRAINT txincubator_lot_pkey PRIMARY KEY (incubator_lot_id);
 N   ALTER TABLE ONLY public.txincubator_lot DROP CONSTRAINT txincubator_lot_pkey;
       public         postgres    false    361            �           2606    137068 (   txincubator_sales txincubator_sales_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY public.txincubator_sales
    ADD CONSTRAINT txincubator_sales_pkey PRIMARY KEY (incubator_sales_id);
 R   ALTER TABLE ONLY public.txincubator_sales DROP CONSTRAINT txincubator_sales_pkey;
       public         postgres    false    363            �           2606    137070    txlot_eggs txlot_eggs_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY public.txlot_eggs
    ADD CONSTRAINT txlot_eggs_pkey PRIMARY KEY (lot_eggs_id);
 D   ALTER TABLE ONLY public.txlot_eggs DROP CONSTRAINT txlot_eggs_pkey;
       public         postgres    false    366            �           2606    137072    txlot txlot_lot_code_key 
   CONSTRAINT     W   ALTER TABLE ONLY public.txlot
    ADD CONSTRAINT txlot_lot_code_key UNIQUE (lot_code);
 B   ALTER TABLE ONLY public.txlot DROP CONSTRAINT txlot_lot_code_key;
       public         postgres    false    365            �           2606    137074    txlot txlot_pkey 
   CONSTRAINT     R   ALTER TABLE ONLY public.txlot
    ADD CONSTRAINT txlot_pkey PRIMARY KEY (lot_id);
 :   ALTER TABLE ONLY public.txlot DROP CONSTRAINT txlot_pkey;
       public         postgres    false    365            �           2606    137076 "   txposturecurve txposturecurve_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY public.txposturecurve
    ADD CONSTRAINT txposturecurve_pkey PRIMARY KEY (posture_curve_id);
 L   ALTER TABLE ONLY public.txposturecurve DROP CONSTRAINT txposturecurve_pkey;
       public         postgres    false    367                       2606    137078 (   txprogrammed_eggs txprogrammed_eggs_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY public.txprogrammed_eggs
    ADD CONSTRAINT txprogrammed_eggs_pkey PRIMARY KEY (programmed_eggs_id);
 R   ALTER TABLE ONLY public.txprogrammed_eggs DROP CONSTRAINT txprogrammed_eggs_pkey;
       public         postgres    false    368            	           2606    137080 (   txscenarioformula txscenarioformula_pkey 
   CONSTRAINT     w   ALTER TABLE ONLY public.txscenarioformula
    ADD CONSTRAINT txscenarioformula_pkey PRIMARY KEY (scenario_formula_id);
 R   ALTER TABLE ONLY public.txscenarioformula DROP CONSTRAINT txscenarioformula_pkey;
       public         postgres    false    369                       2606    137082 ,   txscenarioparameter txscenarioparameter_pkey 
   CONSTRAINT     }   ALTER TABLE ONLY public.txscenarioparameter
    ADD CONSTRAINT txscenarioparameter_pkey PRIMARY KEY (scenario_parameter_id);
 V   ALTER TABLE ONLY public.txscenarioparameter DROP CONSTRAINT txscenarioparameter_pkey;
       public         postgres    false    370                       2606    137084 2   txscenarioparameterday txscenarioparameterday_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.txscenarioparameterday
    ADD CONSTRAINT txscenarioparameterday_pkey PRIMARY KEY (scenario_parameter_day_id);
 \   ALTER TABLE ONLY public.txscenarioparameterday DROP CONSTRAINT txscenarioparameterday_pkey;
       public         postgres    false    371                       2606    137086 2   txscenarioposturecurve txscenarioposturecurve_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.txscenarioposturecurve
    ADD CONSTRAINT txscenarioposturecurve_pkey PRIMARY KEY (scenario_posture_id);
 \   ALTER TABLE ONLY public.txscenarioposturecurve DROP CONSTRAINT txscenarioposturecurve_pkey;
       public         postgres    false    372                       2606    137088 (   txscenarioprocess txscenarioprocess_pkey 
   CONSTRAINT     w   ALTER TABLE ONLY public.txscenarioprocess
    ADD CONSTRAINT txscenarioprocess_pkey PRIMARY KEY (scenario_process_id);
 R   ALTER TABLE ONLY public.txscenarioprocess DROP CONSTRAINT txscenarioprocess_pkey;
       public         postgres    false    373                       2606    137090    txsync txsync_pkey 
   CONSTRAINT     U   ALTER TABLE ONLY public.txsync
    ADD CONSTRAINT txsync_pkey PRIMARY KEY (sync_id);
 <   ALTER TABLE ONLY public.txsync DROP CONSTRAINT txsync_pkey;
       public         postgres    false    374            4           2606    137092    mdrol uniqueRolName 
   CONSTRAINT     T   ALTER TABLE ONLY public.mdrol
    ADD CONSTRAINT "uniqueRolName" UNIQUE (rol_name);
 ?   ALTER TABLE ONLY public.mdrol DROP CONSTRAINT "uniqueRolName";
       public         postgres    false    267            �           1259    137097    fki_FK_ id_aba_time_unit    INDEX     p   CREATE INDEX "fki_FK_ id_aba_time_unit" ON public.aba_consumption_and_mortality USING btree (id_aba_time_unit);
 .   DROP INDEX public."fki_FK_ id_aba_time_unit";
       public         postgres    false    200                       1259    137098    fki_FK_id_aba_breeds_and_stages    INDEX     �   CREATE INDEX "fki_FK_id_aba_breeds_and_stages" ON public.aba_stages_of_breeds_and_stages USING btree (id_aba_breeds_and_stages);
 5   DROP INDEX public."fki_FK_id_aba_breeds_and_stages";
       public         postgres    false    213            �           1259    137099 '   fki_FK_id_aba_consumption_and_mortality    INDEX     �   CREATE INDEX "fki_FK_id_aba_consumption_and_mortality" ON public.aba_breeds_and_stages USING btree (id_aba_consumption_and_mortality);
 =   DROP INDEX public."fki_FK_id_aba_consumption_and_mortality";
       public         postgres    false    198                       1259    137100 (   fki_FK_id_aba_consumption_and_mortality2    INDEX     �   CREATE INDEX "fki_FK_id_aba_consumption_and_mortality2" ON public.aba_consumption_and_mortality_detail USING btree (id_aba_consumption_and_mortality);
 >   DROP INDEX public."fki_FK_id_aba_consumption_and_mortality2";
       public         postgres    false    202                       1259    137101    fki_FK_id_aba_element    INDEX     m   CREATE INDEX "fki_FK_id_aba_element" ON public.aba_elements_and_concentrations USING btree (id_aba_element);
 +   DROP INDEX public."fki_FK_id_aba_element";
       public         postgres    false    206                       1259    137102    fki_FK_id_aba_formulation    INDEX     u   CREATE INDEX "fki_FK_id_aba_formulation" ON public.aba_elements_and_concentrations USING btree (id_aba_formulation);
 /   DROP INDEX public."fki_FK_id_aba_formulation";
       public         postgres    false    206            �           1259    137103    fki_FK_id_breed    INDEX     _   CREATE INDEX "fki_FK_id_breed" ON public.aba_consumption_and_mortality USING btree (id_breed);
 %   DROP INDEX public."fki_FK_id_breed";
       public         postgres    false    200                       1259    137104    fki_FK_id_formulation    INDEX     m   CREATE INDEX "fki_FK_id_formulation" ON public.aba_stages_of_breeds_and_stages USING btree (id_formulation);
 +   DROP INDEX public."fki_FK_id_formulation";
       public         postgres    false    213            �           1259    137105    fki_FK_id_process    INDEX     [   CREATE INDEX "fki_FK_id_process" ON public.aba_breeds_and_stages USING btree (id_process);
 '   DROP INDEX public."fki_FK_id_process";
       public         postgres    false    198            �           1259    137106    fki_FK_id_stage    INDEX     _   CREATE INDEX "fki_FK_id_stage" ON public.aba_consumption_and_mortality USING btree (id_stage);
 %   DROP INDEX public."fki_FK_id_stage";
       public         postgres    false    200                       1259    137107 )   fki_mdapplication_rol_application_id_fkey    INDEX     q   CREATE INDEX fki_mdapplication_rol_application_id_fkey ON public.mdapplication_rol USING btree (application_id);
 =   DROP INDEX public.fki_mdapplication_rol_application_id_fkey;
       public         postgres    false    252                       1259    137108 !   fki_mdapplication_rol_rol_id_fkey    INDEX     a   CREATE INDEX fki_mdapplication_rol_rol_id_fkey ON public.mdapplication_rol USING btree (rol_id);
 5   DROP INDEX public.fki_mdapplication_rol_rol_id_fkey;
       public         postgres    false    252            $           1259    137109    fki_mdparameter_measure_id_fkey    INDEX     ]   CREATE INDEX fki_mdparameter_measure_id_fkey ON public.mdparameter USING btree (measure_id);
 3   DROP INDEX public.fki_mdparameter_measure_id_fkey;
       public         postgres    false    261            %           1259    137110    fki_mdparameter_process_id_fkey    INDEX     ]   CREATE INDEX fki_mdparameter_process_id_fkey ON public.mdparameter USING btree (process_id);
 3   DROP INDEX public.fki_mdparameter_process_id_fkey;
       public         postgres    false    261            (           1259    137111    fki_mdprocess_breed_id_fkey    INDEX     U   CREATE INDEX fki_mdprocess_breed_id_fkey ON public.mdprocess USING btree (breed_id);
 /   DROP INDEX public.fki_mdprocess_breed_id_fkey;
       public         postgres    false    263            ?           1259    137113    fki_mduser_rol_id_fkey    INDEX     K   CREATE INDEX fki_mduser_rol_id_fkey ON public.mduser USING btree (rol_id);
 *   DROP INDEX public.fki_mduser_rol_id_fkey;
       public         postgres    false    275            F           1259    137114    fki_oscenter_farm_id_fkey    INDEX     Q   CREATE INDEX fki_oscenter_farm_id_fkey ON public.oscenter USING btree (farm_id);
 -   DROP INDEX public.fki_oscenter_farm_id_fkey;
       public         postgres    false    278            G           1259    137115     fki_oscenter_partnership_id_fkey    INDEX     _   CREATE INDEX fki_oscenter_partnership_id_fkey ON public.oscenter USING btree (partnership_id);
 4   DROP INDEX public.fki_oscenter_partnership_id_fkey;
       public         postgres    false    278            P           1259    137116    fki_osfarm_farm_type_id_fkey    INDEX     W   CREATE INDEX fki_osfarm_farm_type_id_fkey ON public.osfarm USING btree (farm_type_id);
 0   DROP INDEX public.fki_osfarm_farm_type_id_fkey;
       public         postgres    false    279            Q           1259    137117    fki_osfarm_partnership_id_fkey    INDEX     [   CREATE INDEX fki_osfarm_partnership_id_fkey ON public.osfarm USING btree (partnership_id);
 2   DROP INDEX public.fki_osfarm_partnership_id_fkey;
       public         postgres    false    279            Z           1259    137118 '   fki_osincubator_incubator_plant_id_fkey    INDEX     m   CREATE INDEX fki_osincubator_incubator_plant_id_fkey ON public.osincubator USING btree (incubator_plant_id);
 ;   DROP INDEX public.fki_osincubator_incubator_plant_id_fkey;
       public         postgres    false    280            _           1259    137119 (   fki_osincubatorplant_partnership_id_fkey    INDEX     o   CREATE INDEX fki_osincubatorplant_partnership_id_fkey ON public.osincubatorplant USING btree (partnership_id);
 <   DROP INDEX public.fki_osincubatorplant_partnership_id_fkey;
       public         postgres    false    281            p           1259    137120    fki_osshed_center_id_fkey    INDEX     Q   CREATE INDEX fki_osshed_center_id_fkey ON public.osshed USING btree (center_id);
 -   DROP INDEX public.fki_osshed_center_id_fkey;
       public         postgres    false    285            q           1259    137121    fki_osshed_farm_id_fkey    INDEX     M   CREATE INDEX fki_osshed_farm_id_fkey ON public.osshed USING btree (farm_id);
 +   DROP INDEX public.fki_osshed_farm_id_fkey;
       public         postgres    false    285            r           1259    137122    fki_osshed_partnership_id_fkey    INDEX     [   CREATE INDEX fki_osshed_partnership_id_fkey ON public.osshed USING btree (partnership_id);
 2   DROP INDEX public.fki_osshed_partnership_id_fkey;
       public         postgres    false    285            s           1259    137123    fki_osshed_statusshed_id_fkey    INDEX     Y   CREATE INDEX fki_osshed_statusshed_id_fkey ON public.osshed USING btree (statusshed_id);
 1   DROP INDEX public.fki_osshed_statusshed_id_fkey;
       public         postgres    false    285            )           1259    137124    fki_process_product_id_fkey    INDEX     W   CREATE INDEX fki_process_product_id_fkey ON public.mdprocess USING btree (product_id);
 /   DROP INDEX public.fki_process_product_id_fkey;
       public         postgres    false    263            *           1259    137125    fki_process_stage_id_fkey    INDEX     S   CREATE INDEX fki_process_stage_id_fkey ON public.mdprocess USING btree (stage_id);
 -   DROP INDEX public.fki_process_stage_id_fkey;
       public         postgres    false    263            �           1259    137126 %   fki_txavailabilitysheds_lot_code_fkey    INDEX     i   CREATE INDEX fki_txavailabilitysheds_lot_code_fkey ON public.txavailabilitysheds USING btree (lot_code);
 9   DROP INDEX public.fki_txavailabilitysheds_lot_code_fkey;
       public         postgres    false    339            �           1259    137127 $   fki_txavailabilitysheds_shed_id_fkey    INDEX     g   CREATE INDEX fki_txavailabilitysheds_shed_id_fkey ON public.txavailabilitysheds USING btree (shed_id);
 8   DROP INDEX public.fki_txavailabilitysheds_shed_id_fkey;
       public         postgres    false    339            �           1259    137128 $   fki_txbroiler_detail_broiler_id_fkey    INDEX     g   CREATE INDEX fki_txbroiler_detail_broiler_id_fkey ON public.txbroiler_detail USING btree (broiler_id);
 8   DROP INDEX public.fki_txbroiler_detail_broiler_id_fkey;
       public         postgres    false    341            �           1259    137129 !   fki_txbroiler_detail_farm_id_fkey    INDEX     a   CREATE INDEX fki_txbroiler_detail_farm_id_fkey ON public.txbroiler_detail USING btree (farm_id);
 5   DROP INDEX public.fki_txbroiler_detail_farm_id_fkey;
       public         postgres    false    341            �           1259    137130 !   fki_txbroiler_detail_shed_id_fkey    INDEX     a   CREATE INDEX fki_txbroiler_detail_shed_id_fkey ON public.txbroiler_detail USING btree (shed_id);
 5   DROP INDEX public.fki_txbroiler_detail_shed_id_fkey;
       public         postgres    false    341            �           1259    137131 %   fki_txbroiler_programmed_eggs_id_fkey    INDEX     i   CREATE INDEX fki_txbroiler_programmed_eggs_id_fkey ON public.txbroiler USING btree (programmed_eggs_id);
 9   DROP INDEX public.fki_txbroiler_programmed_eggs_id_fkey;
       public         postgres    false    340            �           1259    137132 #   fki_txbroilereviction_breed_id_fkey    INDEX     e   CREATE INDEX fki_txbroilereviction_breed_id_fkey ON public.txbroilereviction USING btree (breed_id);
 7   DROP INDEX public.fki_txbroilereviction_breed_id_fkey;
       public         postgres    false    344            �           1259    137133 ,   fki_txbroilereviction_detail_broiler_id_fkey    INDEX        CREATE INDEX fki_txbroilereviction_detail_broiler_id_fkey ON public.txbroilereviction_detail USING btree (broilereviction_id);
 @   DROP INDEX public.fki_txbroilereviction_detail_broiler_id_fkey;
       public         postgres    false    345            �           1259    137134 4   fki_txbroilereviction_detail_broiler_product_id_fkey    INDEX     �   CREATE INDEX fki_txbroilereviction_detail_broiler_product_id_fkey ON public.txbroilereviction_detail USING btree (broiler_product_id);
 H   DROP INDEX public.fki_txbroilereviction_detail_broiler_product_id_fkey;
       public         postgres    false    345            �           1259    137135 )   fki_txbroilereviction_detail_farm_id_fkey    INDEX     q   CREATE INDEX fki_txbroilereviction_detail_farm_id_fkey ON public.txbroilereviction_detail USING btree (farm_id);
 =   DROP INDEX public.fki_txbroilereviction_detail_farm_id_fkey;
       public         postgres    false    345            �           1259    137136 )   fki_txbroilereviction_detail_shed_id_fkey    INDEX     q   CREATE INDEX fki_txbroilereviction_detail_shed_id_fkey ON public.txbroilereviction_detail USING btree (shed_id);
 =   DROP INDEX public.fki_txbroilereviction_detail_shed_id_fkey;
       public         postgres    false    345            �           1259    137137 3   fki_txbroilereviction_detail_slaughterhouse_id_fkey    INDEX     �   CREATE INDEX fki_txbroilereviction_detail_slaughterhouse_id_fkey ON public.txbroilereviction_detail USING btree (slaughterhouse_id);
 G   DROP INDEX public.fki_txbroilereviction_detail_slaughterhouse_id_fkey;
       public         postgres    false    345            �           1259    137138 )   fki_txbroilereviction_partnership_id_fkey    INDEX     q   CREATE INDEX fki_txbroilereviction_partnership_id_fkey ON public.txbroilereviction USING btree (partnership_id);
 =   DROP INDEX public.fki_txbroilereviction_partnership_id_fkey;
       public         postgres    false    344            �           1259    137139 &   fki_txbroilereviction_scenario_id_fkey    INDEX     k   CREATE INDEX fki_txbroilereviction_scenario_id_fkey ON public.txbroilereviction USING btree (scenario_id);
 :   DROP INDEX public.fki_txbroilereviction_scenario_id_fkey;
       public         postgres    false    344            �           1259    137140 /   fki_txbroilerproduct_detail_broiler_detail_fkey    INDEX     }   CREATE INDEX fki_txbroilerproduct_detail_broiler_detail_fkey ON public.txbroilerproduct_detail USING btree (broiler_detail);
 C   DROP INDEX public.fki_txbroilerproduct_detail_broiler_detail_fkey;
       public         postgres    false    348            �           1259    137141 "   fki_txbroodermachines_farm_id_fkey    INDEX     b   CREATE INDEX fki_txbroodermachines_farm_id_fkey ON public.txbroodermachine USING btree (farm_id);
 6   DROP INDEX public.fki_txbroodermachines_farm_id_fkey;
       public         postgres    false    349            �           1259    137142 )   fki_txbroodermachines_partnership_id_fkey    INDEX     p   CREATE INDEX fki_txbroodermachines_partnership_id_fkey ON public.txbroodermachine USING btree (partnership_id);
 =   DROP INDEX public.fki_txbroodermachines_partnership_id_fkey;
       public         postgres    false    349            �           1259    137143 !   fki_txeggs_planning_breed_id_fkey    INDEX     a   CREATE INDEX fki_txeggs_planning_breed_id_fkey ON public.txeggs_planning USING btree (breed_id);
 5   DROP INDEX public.fki_txeggs_planning_breed_id_fkey;
       public         postgres    false    352            �           1259    137144 $   fki_txeggs_planning_scenario_id_fkey    INDEX     g   CREATE INDEX fki_txeggs_planning_scenario_id_fkey ON public.txeggs_planning USING btree (scenario_id);
 8   DROP INDEX public.fki_txeggs_planning_scenario_id_fkey;
       public         postgres    false    352            �           1259    137145 !   fki_txeggs_required_breed_id_fkey    INDEX     a   CREATE INDEX fki_txeggs_required_breed_id_fkey ON public.txeggs_required USING btree (breed_id);
 5   DROP INDEX public.fki_txeggs_required_breed_id_fkey;
       public         postgres    false    353            �           1259    137146 $   fki_txeggs_required_scenario_id_fkey    INDEX     g   CREATE INDEX fki_txeggs_required_scenario_id_fkey ON public.txeggs_required USING btree (scenario_id);
 8   DROP INDEX public.fki_txeggs_required_scenario_id_fkey;
       public         postgres    false    353            �           1259    137147     fki_txeggs_storage_breed_id_fkey    INDEX     _   CREATE INDEX fki_txeggs_storage_breed_id_fkey ON public.txeggs_storage USING btree (breed_id);
 4   DROP INDEX public.fki_txeggs_storage_breed_id_fkey;
       public         postgres    false    354            �           1259    137148 *   fki_txeggs_storage_incubator_plant_id_fkey    INDEX     s   CREATE INDEX fki_txeggs_storage_incubator_plant_id_fkey ON public.txeggs_storage USING btree (incubator_plant_id);
 >   DROP INDEX public.fki_txeggs_storage_incubator_plant_id_fkey;
       public         postgres    false    354            �           1259    137149 #   fki_txeggs_storage_scenario_id_fkey    INDEX     e   CREATE INDEX fki_txeggs_storage_scenario_id_fkey ON public.txeggs_storage USING btree (scenario_id);
 7   DROP INDEX public.fki_txeggs_storage_scenario_id_fkey;
       public         postgres    false    354            �           1259    137150    fki_txfattening_breed_id_fkey    INDEX     W   CREATE INDEX fki_txfattening_breed_id_fkey ON public.txbroiler USING btree (breed_id);
 1   DROP INDEX public.fki_txfattening_breed_id_fkey;
       public         postgres    false    340            �           1259    137151 #   fki_txfattening_partnership_id_fkey    INDEX     c   CREATE INDEX fki_txfattening_partnership_id_fkey ON public.txbroiler USING btree (partnership_id);
 7   DROP INDEX public.fki_txfattening_partnership_id_fkey;
       public         postgres    false    340            �           1259    137152     fki_txfattening_scenario_id_fkey    INDEX     ]   CREATE INDEX fki_txfattening_scenario_id_fkey ON public.txbroiler USING btree (scenario_id);
 4   DROP INDEX public.fki_txfattening_scenario_id_fkey;
       public         postgres    false    340            �           1259    137153    fki_txgoals_erp_product_id_fkey    INDEX     ]   CREATE INDEX fki_txgoals_erp_product_id_fkey ON public.txgoals_erp USING btree (product_id);
 3   DROP INDEX public.fki_txgoals_erp_product_id_fkey;
       public         postgres    false    355            �           1259    137154     fki_txgoals_erp_scenario_id_fkey    INDEX     _   CREATE INDEX fki_txgoals_erp_scenario_id_fkey ON public.txgoals_erp USING btree (scenario_id);
 4   DROP INDEX public.fki_txgoals_erp_scenario_id_fkey;
       public         postgres    false    355            �           1259    137155    fki_txhousingway_breed_id_fkey    INDEX     [   CREATE INDEX fki_txhousingway_breed_id_fkey ON public.txhousingway USING btree (breed_id);
 2   DROP INDEX public.fki_txhousingway_breed_id_fkey;
       public         postgres    false    357            �           1259    137156 $   fki_txhousingway_detail_farm_id_fkey    INDEX     g   CREATE INDEX fki_txhousingway_detail_farm_id_fkey ON public.txhousingway_detail USING btree (farm_id);
 8   DROP INDEX public.fki_txhousingway_detail_farm_id_fkey;
       public         postgres    false    358            �           1259    137157 +   fki_txhousingway_detail_housing_way_id_fkey    INDEX     u   CREATE INDEX fki_txhousingway_detail_housing_way_id_fkey ON public.txhousingway_detail USING btree (housing_way_id);
 ?   DROP INDEX public.fki_txhousingway_detail_housing_way_id_fkey;
       public         postgres    false    358            �           1259    137158 /   fki_txhousingway_detail_incubator_plant_id_fkey    INDEX     }   CREATE INDEX fki_txhousingway_detail_incubator_plant_id_fkey ON public.txhousingway_detail USING btree (incubator_plant_id);
 C   DROP INDEX public.fki_txhousingway_detail_incubator_plant_id_fkey;
       public         postgres    false    358            �           1259    137159 $   fki_txhousingway_detail_shed_id_fkey    INDEX     g   CREATE INDEX fki_txhousingway_detail_shed_id_fkey ON public.txhousingway_detail USING btree (shed_id);
 8   DROP INDEX public.fki_txhousingway_detail_shed_id_fkey;
       public         postgres    false    358            �           1259    137160 $   fki_txhousingway_partnership_id_fkey    INDEX     g   CREATE INDEX fki_txhousingway_partnership_id_fkey ON public.txhousingway USING btree (partnership_id);
 8   DROP INDEX public.fki_txhousingway_partnership_id_fkey;
       public         postgres    false    357            �           1259    137161 !   fki_txhousingway_scenario_id_fkey    INDEX     a   CREATE INDEX fki_txhousingway_scenario_id_fkey ON public.txhousingway USING btree (scenario_id);
 5   DROP INDEX public.fki_txhousingway_scenario_id_fkey;
       public         postgres    false    357            �           1259    137162    fki_txhousingway_stage_id_fkey    INDEX     [   CREATE INDEX fki_txhousingway_stage_id_fkey ON public.txhousingway USING btree (stage_id);
 2   DROP INDEX public.fki_txhousingway_stage_id_fkey;
       public         postgres    false    357            �           1259    137163    fki_txlot_breed_id_fkey    INDEX     M   CREATE INDEX fki_txlot_breed_id_fkey ON public.txlot USING btree (breed_id);
 +   DROP INDEX public.fki_txlot_breed_id_fkey;
       public         postgres    false    365            �           1259    137164    fki_txlot_farm_id_fkey    INDEX     K   CREATE INDEX fki_txlot_farm_id_fkey ON public.txlot USING btree (farm_id);
 *   DROP INDEX public.fki_txlot_farm_id_fkey;
       public         postgres    false    365            �           1259    137165    fki_txlot_housin_way_id_fkey    INDEX     X   CREATE INDEX fki_txlot_housin_way_id_fkey ON public.txlot USING btree (housing_way_id);
 0   DROP INDEX public.fki_txlot_housin_way_id_fkey;
       public         postgres    false    365            �           1259    137166    fki_txlot_product_id_fkey    INDEX     Q   CREATE INDEX fki_txlot_product_id_fkey ON public.txlot USING btree (product_id);
 -   DROP INDEX public.fki_txlot_product_id_fkey;
       public         postgres    false    365            �           1259    137167    fki_txlot_shed_id_fkey    INDEX     K   CREATE INDEX fki_txlot_shed_id_fkey ON public.txlot USING btree (shed_id);
 *   DROP INDEX public.fki_txlot_shed_id_fkey;
       public         postgres    false    365            �           1259    137168     fki_txposturecurve_breed_id_fkey    INDEX     _   CREATE INDEX fki_txposturecurve_breed_id_fkey ON public.txposturecurve USING btree (breed_id);
 4   DROP INDEX public.fki_txposturecurve_breed_id_fkey;
       public         postgres    false    367            �           1259    137169 #   fki_txprogrammed_eggs_breed_id_fkey    INDEX     e   CREATE INDEX fki_txprogrammed_eggs_breed_id_fkey ON public.txprogrammed_eggs USING btree (breed_id);
 7   DROP INDEX public.fki_txprogrammed_eggs_breed_id_fkey;
       public         postgres    false    368                        1259    137170 *   fki_txprogrammed_eggs_eggs_storage_id_fkey    INDEX     s   CREATE INDEX fki_txprogrammed_eggs_eggs_storage_id_fkey ON public.txprogrammed_eggs USING btree (eggs_storage_id);
 >   DROP INDEX public.fki_txprogrammed_eggs_eggs_storage_id_fkey;
       public         postgres    false    368                       1259    137171 '   fki_txprogrammed_eggs_incubator_id_fkey    INDEX     m   CREATE INDEX fki_txprogrammed_eggs_incubator_id_fkey ON public.txprogrammed_eggs USING btree (incubator_id);
 ;   DROP INDEX public.fki_txprogrammed_eggs_incubator_id_fkey;
       public         postgres    false    368                       1259    137172 %   fki_txscenarioformula_measure_id_fkey    INDEX     i   CREATE INDEX fki_txscenarioformula_measure_id_fkey ON public.txscenarioformula USING btree (measure_id);
 9   DROP INDEX public.fki_txscenarioformula_measure_id_fkey;
       public         postgres    false    369                       1259    137173 '   fki_txscenarioformula_parameter_id_fkey    INDEX     m   CREATE INDEX fki_txscenarioformula_parameter_id_fkey ON public.txscenarioformula USING btree (parameter_id);
 ;   DROP INDEX public.fki_txscenarioformula_parameter_id_fkey;
       public         postgres    false    369                       1259    137174 %   fki_txscenarioformula_process_id_fkey    INDEX     i   CREATE INDEX fki_txscenarioformula_process_id_fkey ON public.txscenarioformula USING btree (process_id);
 9   DROP INDEX public.fki_txscenarioformula_process_id_fkey;
       public         postgres    false    369                       1259    137175 &   fki_txscenarioformula_scenario_id_fkey    INDEX     k   CREATE INDEX fki_txscenarioformula_scenario_id_fkey ON public.txscenarioformula USING btree (scenario_id);
 :   DROP INDEX public.fki_txscenarioformula_scenario_id_fkey;
       public         postgres    false    369            
           1259    137176 )   fki_txscenarioparameter_parameter_id_fkey    INDEX     q   CREATE INDEX fki_txscenarioparameter_parameter_id_fkey ON public.txscenarioparameter USING btree (parameter_id);
 =   DROP INDEX public.fki_txscenarioparameter_parameter_id_fkey;
       public         postgres    false    370                       1259    137177 '   fki_txscenarioparameter_process_id_fkey    INDEX     m   CREATE INDEX fki_txscenarioparameter_process_id_fkey ON public.txscenarioparameter USING btree (process_id);
 ;   DROP INDEX public.fki_txscenarioparameter_process_id_fkey;
       public         postgres    false    370                       1259    137178 (   fki_txscenarioparameter_scenario_id_fkey    INDEX     o   CREATE INDEX fki_txscenarioparameter_scenario_id_fkey ON public.txscenarioparameter USING btree (scenario_id);
 <   DROP INDEX public.fki_txscenarioparameter_scenario_id_fkey;
       public         postgres    false    370                       1259    137179 ,   fki_txscenarioparameterday_parameter_id_fkey    INDEX     w   CREATE INDEX fki_txscenarioparameterday_parameter_id_fkey ON public.txscenarioparameterday USING btree (parameter_id);
 @   DROP INDEX public.fki_txscenarioparameterday_parameter_id_fkey;
       public         postgres    false    371                       1259    137180 +   fki_txscenarioparameterday_scenario_id_fkey    INDEX     u   CREATE INDEX fki_txscenarioparameterday_scenario_id_fkey ON public.txscenarioparameterday USING btree (scenario_id);
 ?   DROP INDEX public.fki_txscenarioparameterday_scenario_id_fkey;
       public         postgres    false    371                       1259    137181 (   fki_txscenarioposturecurve_breed_id_fkey    INDEX     o   CREATE INDEX fki_txscenarioposturecurve_breed_id_fkey ON public.txscenarioposturecurve USING btree (breed_id);
 <   DROP INDEX public.fki_txscenarioposturecurve_breed_id_fkey;
       public         postgres    false    372                       1259    137182 4   fki_txscenarioposturecurve_housingway_detail_id_fkey    INDEX     �   CREATE INDEX fki_txscenarioposturecurve_housingway_detail_id_fkey ON public.txscenarioposturecurve USING btree (housingway_detail_id);
 H   DROP INDEX public.fki_txscenarioposturecurve_housingway_detail_id_fkey;
       public         postgres    false    372                       1259    137183 +   fki_txscenarioposturecurve_scenario_id_fkey    INDEX     u   CREATE INDEX fki_txscenarioposturecurve_scenario_id_fkey ON public.txscenarioposturecurve USING btree (scenario_id);
 ?   DROP INDEX public.fki_txscenarioposturecurve_scenario_id_fkey;
       public         postgres    false    372                       1259    137184 %   fki_txscenarioprocess_process_id_fkey    INDEX     i   CREATE INDEX fki_txscenarioprocess_process_id_fkey ON public.txscenarioprocess USING btree (process_id);
 9   DROP INDEX public.fki_txscenarioprocess_process_id_fkey;
       public         postgres    false    373                       1259    137185 &   fki_txscenarioprocess_scenario_id_fkey    INDEX     k   CREATE INDEX fki_txscenarioprocess_scenario_id_fkey ON public.txscenarioprocess USING btree (scenario_id);
 :   DROP INDEX public.fki_txscenarioprocess_scenario_id_fkey;
       public         postgres    false    373                       1259    137186    posturedate_index    INDEX     [   CREATE INDEX posturedate_index ON public.txscenarioposturecurve USING hash (posture_date);
 %   DROP INDEX public.posturedate_index;
       public         postgres    false    372            (           2606    137188 ;   aba_stages_of_breeds_and_stages FK_id_aba_breeds_and_stages    FK CONSTRAINT     �   ALTER TABLE ONLY public.aba_stages_of_breeds_and_stages
    ADD CONSTRAINT "FK_id_aba_breeds_and_stages" FOREIGN KEY (id_aba_breeds_and_stages) REFERENCES public.aba_breeds_and_stages(id) ON DELETE CASCADE;
 g   ALTER TABLE ONLY public.aba_stages_of_breeds_and_stages DROP CONSTRAINT "FK_id_aba_breeds_and_stages";
       public       postgres    false    198    213    3319                       2606    137193 9   aba_breeds_and_stages FK_id_aba_consumption_and_mortality    FK CONSTRAINT     �   ALTER TABLE ONLY public.aba_breeds_and_stages
    ADD CONSTRAINT "FK_id_aba_consumption_and_mortality" FOREIGN KEY (id_aba_consumption_and_mortality) REFERENCES public.aba_consumption_and_mortality(id);
 e   ALTER TABLE ONLY public.aba_breeds_and_stages DROP CONSTRAINT "FK_id_aba_consumption_and_mortality";
       public       postgres    false    3323    198    200            $           2606    137198 I   aba_consumption_and_mortality_detail FK_id_aba_consumption_and_mortality2    FK CONSTRAINT     �   ALTER TABLE ONLY public.aba_consumption_and_mortality_detail
    ADD CONSTRAINT "FK_id_aba_consumption_and_mortality2" FOREIGN KEY (id_aba_consumption_and_mortality) REFERENCES public.aba_consumption_and_mortality(id) ON DELETE CASCADE;
 u   ALTER TABLE ONLY public.aba_consumption_and_mortality_detail DROP CONSTRAINT "FK_id_aba_consumption_and_mortality2";
       public       postgres    false    200    3323    202            &           2606    137203 1   aba_elements_and_concentrations FK_id_aba_element    FK CONSTRAINT     �   ALTER TABLE ONLY public.aba_elements_and_concentrations
    ADD CONSTRAINT "FK_id_aba_element" FOREIGN KEY (id_aba_element) REFERENCES public.aba_elements(id);
 ]   ALTER TABLE ONLY public.aba_elements_and_concentrations DROP CONSTRAINT "FK_id_aba_element";
       public       postgres    false    206    204    3331            '           2606    137208 5   aba_elements_and_concentrations FK_id_aba_formulation    FK CONSTRAINT     �   ALTER TABLE ONLY public.aba_elements_and_concentrations
    ADD CONSTRAINT "FK_id_aba_formulation" FOREIGN KEY (id_aba_formulation) REFERENCES public.aba_formulation(id) ON DELETE CASCADE;
 a   ALTER TABLE ONLY public.aba_elements_and_concentrations DROP CONSTRAINT "FK_id_aba_formulation";
       public       postgres    false    210    206    3339            !           2606    137213 1   aba_consumption_and_mortality FK_id_aba_time_unit    FK CONSTRAINT     �   ALTER TABLE ONLY public.aba_consumption_and_mortality
    ADD CONSTRAINT "FK_id_aba_time_unit" FOREIGN KEY (id_aba_time_unit) REFERENCES public.aba_time_unit(id);
 ]   ALTER TABLE ONLY public.aba_consumption_and_mortality DROP CONSTRAINT "FK_id_aba_time_unit";
       public       postgres    false    214    200    3345            "           2606    137218 )   aba_consumption_and_mortality FK_id_breed    FK CONSTRAINT     �   ALTER TABLE ONLY public.aba_consumption_and_mortality
    ADD CONSTRAINT "FK_id_breed" FOREIGN KEY (id_breed) REFERENCES public.mdbreed(breed_id);
 U   ALTER TABLE ONLY public.aba_consumption_and_mortality DROP CONSTRAINT "FK_id_breed";
       public       postgres    false    253    3357    200            )           2606    137223 1   aba_stages_of_breeds_and_stages FK_id_formulation    FK CONSTRAINT     �   ALTER TABLE ONLY public.aba_stages_of_breeds_and_stages
    ADD CONSTRAINT "FK_id_formulation" FOREIGN KEY (id_formulation) REFERENCES public.aba_formulation(id);
 ]   ALTER TABLE ONLY public.aba_stages_of_breeds_and_stages DROP CONSTRAINT "FK_id_formulation";
       public       postgres    false    210    213    3339                        2606    137228 #   aba_breeds_and_stages FK_id_process    FK CONSTRAINT     �   ALTER TABLE ONLY public.aba_breeds_and_stages
    ADD CONSTRAINT "FK_id_process" FOREIGN KEY (id_process) REFERENCES public.mdprocess(process_id);
 O   ALTER TABLE ONLY public.aba_breeds_and_stages DROP CONSTRAINT "FK_id_process";
       public       postgres    false    3372    263    198            #           2606    137233 )   aba_consumption_and_mortality FK_id_stage    FK CONSTRAINT     �   ALTER TABLE ONLY public.aba_consumption_and_mortality
    ADD CONSTRAINT "FK_id_stage" FOREIGN KEY (id_stage) REFERENCES public.mdstage(stage_id);
 U   ALTER TABLE ONLY public.aba_consumption_and_mortality DROP CONSTRAINT "FK_id_stage";
       public       postgres    false    3390    200    273            %           2606    137238 6   aba_elements aba_elements_id_aba_element_property_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.aba_elements
    ADD CONSTRAINT aba_elements_id_aba_element_property_fkey FOREIGN KEY (id_aba_element_property) REFERENCES public.aba_elements_properties(id);
 `   ALTER TABLE ONLY public.aba_elements DROP CONSTRAINT aba_elements_id_aba_element_property_fkey;
       public       postgres    false    3337    204    208            h           2606    137243    sltxliftbreeding breed_id_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.sltxliftbreeding
    ADD CONSTRAINT breed_id_fk FOREIGN KEY (breed_id) REFERENCES public.mdbreed(breed_id);
 F   ALTER TABLE ONLY public.sltxliftbreeding DROP CONSTRAINT breed_id_fk;
       public       postgres    false    3357    331    253            P           2606    137248    sltxbreeding breed_id_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.sltxbreeding
    ADD CONSTRAINT breed_id_fk FOREIGN KEY (breed_id) REFERENCES public.mdbreed(breed_id);
 B   ALTER TABLE ONLY public.sltxbreeding DROP CONSTRAINT breed_id_fk;
       public       postgres    false    3357    311    253            m           2606    137253    sltxposturecurve breed_id_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.sltxposturecurve
    ADD CONSTRAINT breed_id_fk FOREIGN KEY (breed_id) REFERENCES public.mdbreed(breed_id);
 F   ALTER TABLE ONLY public.sltxposturecurve DROP CONSTRAINT breed_id_fk;
       public       postgres    false    333    253    3357            p           2606    137258    sltxsellspurchase breed_id_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.sltxsellspurchase
    ADD CONSTRAINT breed_id_fk FOREIGN KEY (breed_id) REFERENCES public.mdbreed(breed_id);
 G   ALTER TABLE ONLY public.sltxsellspurchase DROP CONSTRAINT breed_id_fk;
       public       postgres    false    3357    335    253            H           2606    137263    slmdprocess breed_id_fk    FK CONSTRAINT        ALTER TABLE ONLY public.slmdprocess
    ADD CONSTRAINT breed_id_fk FOREIGN KEY (breed_id) REFERENCES public.mdbreed(breed_id);
 A   ALTER TABLE ONLY public.slmdprocess DROP CONSTRAINT breed_id_fk;
       public       postgres    false    3357    305    253            F           2606    137268 $   slmdgenderclassification breed_id_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.slmdgenderclassification
    ADD CONSTRAINT breed_id_fk FOREIGN KEY (breed_id) REFERENCES public.mdbreed(breed_id);
 N   ALTER TABLE ONLY public.slmdgenderclassification DROP CONSTRAINT breed_id_fk;
       public       postgres    false    3357    253    301            �           2606    137273    txincubator_sales breed_id_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.txincubator_sales
    ADD CONSTRAINT breed_id_fk FOREIGN KEY (breed_id) REFERENCES public.mdbreed(breed_id);
 G   ALTER TABLE ONLY public.txincubator_sales DROP CONSTRAINT breed_id_fk;
       public       postgres    false    3357    363    253            V           2606    137278    sltxbroiler_detail category_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.sltxbroiler_detail
    ADD CONSTRAINT category_fk FOREIGN KEY (category) REFERENCES public.slmdgenderclassification(slgenderclassification_id);
 H   ALTER TABLE ONLY public.sltxbroiler_detail DROP CONSTRAINT category_fk;
       public       postgres    false    3457    315    301            e           2606    137283    sltxlb_shed center_id_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.sltxlb_shed
    ADD CONSTRAINT center_id_fk FOREIGN KEY (center_id) REFERENCES public.oscenter(center_id);
 B   ALTER TABLE ONLY public.sltxlb_shed DROP CONSTRAINT center_id_fk;
       public       postgres    false    3407    329    278            J           2606    137288    sltxb_shed center_id_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.sltxb_shed
    ADD CONSTRAINT center_id_fk FOREIGN KEY (center_id) REFERENCES public.oscenter(center_id);
 A   ALTER TABLE ONLY public.sltxb_shed DROP CONSTRAINT center_id_fk;
       public       postgres    false    3407    307    278            M           2606    137293    sltxbr_shed center_id_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.sltxbr_shed
    ADD CONSTRAINT center_id_fk FOREIGN KEY (center_id) REFERENCES public.oscenter(center_id);
 B   ALTER TABLE ONLY public.sltxbr_shed DROP CONSTRAINT center_id_fk;
       public       postgres    false    309    278    3407            �           2606    137298 *   txeggs_movements eggs_movements_storage_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.txeggs_movements
    ADD CONSTRAINT eggs_movements_storage_id FOREIGN KEY (eggs_storage_id) REFERENCES public.txeggs_storage(eggs_storage_id);
 T   ALTER TABLE ONLY public.txeggs_movements DROP CONSTRAINT eggs_movements_storage_id;
       public       postgres    false    3546    351    354            i           2606    137303    sltxliftbreeding farm_id_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.sltxliftbreeding
    ADD CONSTRAINT farm_id_fk FOREIGN KEY (farm_id) REFERENCES public.osfarm(farm_id);
 E   ALTER TABLE ONLY public.sltxliftbreeding DROP CONSTRAINT farm_id_fk;
       public       postgres    false    3417    279    331            Q           2606    137308    sltxbreeding farm_id_fk    FK CONSTRAINT     |   ALTER TABLE ONLY public.sltxbreeding
    ADD CONSTRAINT farm_id_fk FOREIGN KEY (farm_id) REFERENCES public.osfarm(farm_id);
 A   ALTER TABLE ONLY public.sltxbreeding DROP CONSTRAINT farm_id_fk;
       public       postgres    false    3417    311    279            W           2606    137313    sltxbroiler_detail farm_id_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.sltxbroiler_detail
    ADD CONSTRAINT farm_id_fk FOREIGN KEY (farm_id) REFERENCES public.osfarm(farm_id);
 G   ALTER TABLE ONLY public.sltxbroiler_detail DROP CONSTRAINT farm_id_fk;
       public       postgres    false    3417    315    279            _           2606    137318 $   sltxincubator_detail incubator_id_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.sltxincubator_detail
    ADD CONSTRAINT incubator_id_fk FOREIGN KEY (incubator_id) REFERENCES public.sltxincubator(slincubator);
 N   ALTER TABLE ONLY public.sltxincubator_detail DROP CONSTRAINT incubator_id_fk;
       public       postgres    false    3475    324    320            �           2606    137323 '   txincubator_sales incubator_plant_id_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.txincubator_sales
    ADD CONSTRAINT incubator_plant_id_fk FOREIGN KEY (incubator_plant_id) REFERENCES public.osincubatorplant(incubator_plant_id);
 Q   ALTER TABLE ONLY public.txincubator_sales DROP CONSTRAINT incubator_plant_id_fk;
       public       postgres    false    3431    363    281            G           2606    137328 %   slmdmachinegroup incubatorplant_id_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.slmdmachinegroup
    ADD CONSTRAINT incubatorplant_id_fk FOREIGN KEY (incubatorplant_id) REFERENCES public.osincubatorplant(incubator_plant_id);
 O   ALTER TABLE ONLY public.slmdmachinegroup DROP CONSTRAINT incubatorplant_id_fk;
       public       postgres    false    304    281    3431            \           2606    137333 "   sltxincubator incubatorplant_id_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.sltxincubator
    ADD CONSTRAINT incubatorplant_id_fk FOREIGN KEY (incubatorplant_id) REFERENCES public.osincubatorplant(incubator_plant_id);
 L   ALTER TABLE ONLY public.sltxincubator DROP CONSTRAINT incubatorplant_id_fk;
       public       postgres    false    3431    320    281            T           2606    137338     sltxbroiler incubatorplant_id_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.sltxbroiler
    ADD CONSTRAINT incubatorplant_id_fk FOREIGN KEY (incubatorplant_id) REFERENCES public.osincubatorplant(incubator_plant_id);
 J   ALTER TABLE ONLY public.sltxbroiler DROP CONSTRAINT incubatorplant_id_fk;
       public       postgres    false    313    3431    281            *           2606    137343 ;   md_optimizer_parameter md_optimizer_parameter_breed_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.md_optimizer_parameter
    ADD CONSTRAINT md_optimizer_parameter_breed_id_fkey FOREIGN KEY (breed_id) REFERENCES public.mdbreed(breed_id);
 e   ALTER TABLE ONLY public.md_optimizer_parameter DROP CONSTRAINT md_optimizer_parameter_breed_id_fkey;
       public       postgres    false    253    3357    245            +           2606    137348 7   mdapplication_rol mdapplication_rol_application_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.mdapplication_rol
    ADD CONSTRAINT mdapplication_rol_application_id_fkey FOREIGN KEY (application_id) REFERENCES public.mdapplication(application_id);
 a   ALTER TABLE ONLY public.mdapplication_rol DROP CONSTRAINT mdapplication_rol_application_id_fkey;
       public       postgres    false    3349    252    250            ,           2606    137353 /   mdapplication_rol mdapplication_rol_rol_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.mdapplication_rol
    ADD CONSTRAINT mdapplication_rol_rol_id_fkey FOREIGN KEY (rol_id) REFERENCES public.mdrol(rol_id);
 Y   ALTER TABLE ONLY public.mdapplication_rol DROP CONSTRAINT mdapplication_rol_rol_id_fkey;
       public       postgres    false    3378    252    267            -           2606    137358 1   mdbroiler_product mdbroiler_product_breed_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.mdbroiler_product
    ADD CONSTRAINT mdbroiler_product_breed_id_fkey FOREIGN KEY (breed_id) REFERENCES public.mdbreed(breed_id);
 [   ALTER TABLE ONLY public.mdbroiler_product DROP CONSTRAINT mdbroiler_product_breed_id_fkey;
       public       postgres    false    3357    254    253            .           2606    137363 8   mdbroiler_product mdbroiler_product_initial_product_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.mdbroiler_product
    ADD CONSTRAINT mdbroiler_product_initial_product_fkey FOREIGN KEY (initial_product) REFERENCES public.mdbroiler_product(broiler_product_id);
 b   ALTER TABLE ONLY public.mdbroiler_product DROP CONSTRAINT mdbroiler_product_initial_product_fkey;
       public       postgres    false    3359    254    254            /           2606    137368 7   mdequivalenceproduct mdequivalenceproduct_breed_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.mdequivalenceproduct
    ADD CONSTRAINT mdequivalenceproduct_breed_id_fkey FOREIGN KEY (breed_id) REFERENCES public.mdbreed(breed_id);
 a   ALTER TABLE ONLY public.mdequivalenceproduct DROP CONSTRAINT mdequivalenceproduct_breed_id_fkey;
       public       postgres    false    255    253    3357            0           2606    137373 '   mdparameter mdparameter_measure_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.mdparameter
    ADD CONSTRAINT mdparameter_measure_id_fkey FOREIGN KEY (measure_id) REFERENCES public.mdmeasure(measure_id) ON UPDATE CASCADE ON DELETE CASCADE;
 Q   ALTER TABLE ONLY public.mdparameter DROP CONSTRAINT mdparameter_measure_id_fkey;
       public       postgres    false    261    259    3363            1           2606    137378 '   mdparameter mdparameter_process_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.mdparameter
    ADD CONSTRAINT mdparameter_process_id_fkey FOREIGN KEY (process_id) REFERENCES public.mdprocess(process_id) ON UPDATE CASCADE ON DELETE CASCADE;
 Q   ALTER TABLE ONLY public.mdparameter DROP CONSTRAINT mdparameter_process_id_fkey;
       public       postgres    false    3372    261    263            2           2606    137383 !   mdprocess mdprocess_breed_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.mdprocess
    ADD CONSTRAINT mdprocess_breed_id_fkey FOREIGN KEY (breed_id) REFERENCES public.mdbreed(breed_id) ON UPDATE CASCADE ON DELETE CASCADE;
 K   ALTER TABLE ONLY public.mdprocess DROP CONSTRAINT mdprocess_breed_id_fkey;
       public       postgres    false    253    3357    263            3           2606    137393 '   mdprocess mdprocess_predecessor_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.mdprocess
    ADD CONSTRAINT mdprocess_predecessor_id_fkey FOREIGN KEY (predecessor_id) REFERENCES public.mdprocess(process_id);
 Q   ALTER TABLE ONLY public.mdprocess DROP CONSTRAINT mdprocess_predecessor_id_fkey;
       public       postgres    false    3372    263    263            4           2606    137398 #   mdprocess mdprocess_product_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.mdprocess
    ADD CONSTRAINT mdprocess_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.mdproduct(product_id) ON UPDATE CASCADE ON DELETE CASCADE;
 M   ALTER TABLE ONLY public.mdprocess DROP CONSTRAINT mdprocess_product_id_fkey;
       public       postgres    false    263    265    3376            5           2606    137403 !   mdprocess mdprocess_stage_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.mdprocess
    ADD CONSTRAINT mdprocess_stage_id_fkey FOREIGN KEY (stage_id) REFERENCES public.mdstage(stage_id) ON UPDATE CASCADE ON DELETE CASCADE;
 K   ALTER TABLE ONLY public.mdprocess DROP CONSTRAINT mdprocess_stage_id_fkey;
       public       postgres    false    263    273    3390            6           2606    137408 !   mdproduct mdproduct_breed_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.mdproduct
    ADD CONSTRAINT mdproduct_breed_id_fkey FOREIGN KEY (breed_id) REFERENCES public.mdbreed(breed_id);
 K   ALTER TABLE ONLY public.mdproduct DROP CONSTRAINT mdproduct_breed_id_fkey;
       public       postgres    false    265    253    3357            7           2606    137413 !   mdproduct mdproduct_stage_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.mdproduct
    ADD CONSTRAINT mdproduct_stage_id_fkey FOREIGN KEY (stage_id) REFERENCES public.mdstage(stage_id);
 K   ALTER TABLE ONLY public.mdproduct DROP CONSTRAINT mdproduct_stage_id_fkey;
       public       postgres    false    265    273    3390            8           2606    137418 #   mdrol mdrol_admin_user_creator_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.mdrol
    ADD CONSTRAINT mdrol_admin_user_creator_fkey FOREIGN KEY (admin_user_creator) REFERENCES public.mduser(user_id);
 M   ALTER TABLE ONLY public.mdrol DROP CONSTRAINT mdrol_admin_user_creator_fkey;
       public       postgres    false    267    275    3393            9           2606    137428 $   mduser mduser_admi_user_creator_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.mduser
    ADD CONSTRAINT mduser_admi_user_creator_fkey FOREIGN KEY (admi_user_creator) REFERENCES public.mduser(user_id);
 N   ALTER TABLE ONLY public.mduser DROP CONSTRAINT mduser_admi_user_creator_fkey;
       public       postgres    false    275    275    3393            :           2606    137433    mduser mduser_rol_id_fkey    FK CONSTRAINT     {   ALTER TABLE ONLY public.mduser
    ADD CONSTRAINT mduser_rol_id_fkey FOREIGN KEY (rol_id) REFERENCES public.mdrol(rol_id);
 C   ALTER TABLE ONLY public.mduser DROP CONSTRAINT mduser_rol_id_fkey;
       public       postgres    false    275    267    3378            ;           2606    137438    oscenter oscenter_farm_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.oscenter
    ADD CONSTRAINT oscenter_farm_id_fkey FOREIGN KEY (farm_id) REFERENCES public.osfarm(farm_id) ON UPDATE CASCADE ON DELETE CASCADE;
 H   ALTER TABLE ONLY public.oscenter DROP CONSTRAINT oscenter_farm_id_fkey;
       public       postgres    false    278    279    3417            <           2606    137443 %   oscenter oscenter_partnership_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.oscenter
    ADD CONSTRAINT oscenter_partnership_id_fkey FOREIGN KEY (partnership_id) REFERENCES public.ospartnership(partnership_id) ON UPDATE CASCADE ON DELETE CASCADE;
 O   ALTER TABLE ONLY public.oscenter DROP CONSTRAINT oscenter_partnership_id_fkey;
       public       postgres    false    278    283    3439            =           2606    137448    osfarm osfarm_farm_type_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.osfarm
    ADD CONSTRAINT osfarm_farm_type_id_fkey FOREIGN KEY (farm_type_id) REFERENCES public.mdfarmtype(farm_type_id) ON UPDATE CASCADE ON DELETE CASCADE;
 I   ALTER TABLE ONLY public.osfarm DROP CONSTRAINT osfarm_farm_type_id_fkey;
       public       postgres    false    279    257    3361            >           2606    137453 !   osfarm osfarm_partnership_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.osfarm
    ADD CONSTRAINT osfarm_partnership_id_fkey FOREIGN KEY (partnership_id) REFERENCES public.ospartnership(partnership_id) ON UPDATE CASCADE ON DELETE CASCADE;
 K   ALTER TABLE ONLY public.osfarm DROP CONSTRAINT osfarm_partnership_id_fkey;
       public       postgres    false    3439    279    283            ?           2606    137458 /   osincubator osincubator_incubator_plant_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.osincubator
    ADD CONSTRAINT osincubator_incubator_plant_id_fkey FOREIGN KEY (incubator_plant_id) REFERENCES public.osincubatorplant(incubator_plant_id) ON UPDATE CASCADE ON DELETE CASCADE;
 Y   ALTER TABLE ONLY public.osincubator DROP CONSTRAINT osincubator_incubator_plant_id_fkey;
       public       postgres    false    280    281    3431            @           2606    137463 5   osincubatorplant osincubatorplant_partnership_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.osincubatorplant
    ADD CONSTRAINT osincubatorplant_partnership_id_fkey FOREIGN KEY (partnership_id) REFERENCES public.ospartnership(partnership_id) ON UPDATE CASCADE ON DELETE CASCADE;
 _   ALTER TABLE ONLY public.osincubatorplant DROP CONSTRAINT osincubatorplant_partnership_id_fkey;
       public       postgres    false    281    283    3439            A           2606    137468    osshed osshed_breed_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.osshed
    ADD CONSTRAINT osshed_breed_id_fkey FOREIGN KEY (breed_id) REFERENCES public.mdbreed(breed_id);
 E   ALTER TABLE ONLY public.osshed DROP CONSTRAINT osshed_breed_id_fkey;
       public       postgres    false    285    253    3357            B           2606    137473    osshed osshed_center_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.osshed
    ADD CONSTRAINT osshed_center_id_fkey FOREIGN KEY (center_id) REFERENCES public.oscenter(center_id) ON UPDATE CASCADE ON DELETE CASCADE;
 F   ALTER TABLE ONLY public.osshed DROP CONSTRAINT osshed_center_id_fkey;
       public       postgres    false    278    3407    285            C           2606    137478    osshed osshed_farm_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.osshed
    ADD CONSTRAINT osshed_farm_id_fkey FOREIGN KEY (farm_id) REFERENCES public.osfarm(farm_id) ON UPDATE CASCADE ON DELETE CASCADE;
 D   ALTER TABLE ONLY public.osshed DROP CONSTRAINT osshed_farm_id_fkey;
       public       postgres    false    285    279    3417            D           2606    137483 !   osshed osshed_partnership_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.osshed
    ADD CONSTRAINT osshed_partnership_id_fkey FOREIGN KEY (partnership_id) REFERENCES public.ospartnership(partnership_id) ON UPDATE CASCADE ON DELETE CASCADE;
 K   ALTER TABLE ONLY public.osshed DROP CONSTRAINT osshed_partnership_id_fkey;
       public       postgres    false    3439    283    285            E           2606    137488     osshed osshed_statusshed_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.osshed
    ADD CONSTRAINT osshed_statusshed_id_fkey FOREIGN KEY (statusshed_id) REFERENCES public.mdshedstatus(shed_status_id) ON UPDATE CASCADE ON DELETE CASCADE;
 J   ALTER TABLE ONLY public.osshed DROP CONSTRAINT osshed_statusshed_id_fkey;
       public       postgres    false    285    3386    271            j           2606    137493 "   sltxliftbreeding partnership_id_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.sltxliftbreeding
    ADD CONSTRAINT partnership_id_fk FOREIGN KEY (partnership_id) REFERENCES public.ospartnership(partnership_id);
 L   ALTER TABLE ONLY public.sltxliftbreeding DROP CONSTRAINT partnership_id_fk;
       public       postgres    false    3439    283    331            R           2606    137498    sltxbreeding partnership_id_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.sltxbreeding
    ADD CONSTRAINT partnership_id_fk FOREIGN KEY (partnership_id) REFERENCES public.ospartnership(partnership_id);
 H   ALTER TABLE ONLY public.sltxbreeding DROP CONSTRAINT partnership_id_fk;
       public       postgres    false    311    3439    283            �           2606    137503 &   txeggs_movements programmed_eggs_id_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.txeggs_movements
    ADD CONSTRAINT programmed_eggs_id_fk FOREIGN KEY (programmed_eggs_id) REFERENCES public.txprogrammed_eggs(programmed_eggs_id);
 P   ALTER TABLE ONLY public.txeggs_movements DROP CONSTRAINT programmed_eggs_id_fk;
       public       postgres    false    3587    368    351            f           2606    137508    sltxlb_shed shed_id_fk    FK CONSTRAINT     {   ALTER TABLE ONLY public.sltxlb_shed
    ADD CONSTRAINT shed_id_fk FOREIGN KEY (shed_id) REFERENCES public.osshed(shed_id);
 @   ALTER TABLE ONLY public.sltxlb_shed DROP CONSTRAINT shed_id_fk;
       public       postgres    false    3445    285    329            K           2606    137513    sltxb_shed shed_id_fk    FK CONSTRAINT     z   ALTER TABLE ONLY public.sltxb_shed
    ADD CONSTRAINT shed_id_fk FOREIGN KEY (shed_id) REFERENCES public.osshed(shed_id);
 ?   ALTER TABLE ONLY public.sltxb_shed DROP CONSTRAINT shed_id_fk;
       public       postgres    false    3445    285    307            N           2606    137518    sltxbr_shed shed_id_fk    FK CONSTRAINT     {   ALTER TABLE ONLY public.sltxbr_shed
    ADD CONSTRAINT shed_id_fk FOREIGN KEY (shed_id) REFERENCES public.osshed(shed_id);
 @   ALTER TABLE ONLY public.sltxbr_shed DROP CONSTRAINT shed_id_fk;
       public       postgres    false    3445    285    309            L           2606    137523    sltxb_shed slbreeding_id_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.sltxb_shed
    ADD CONSTRAINT slbreeding_id_fk FOREIGN KEY (slbreeding_id) REFERENCES public.sltxbreeding(slbreeding_id);
 E   ALTER TABLE ONLY public.sltxb_shed DROP CONSTRAINT slbreeding_id_fk;
       public       postgres    false    307    3467    311            k           2606    137528 !   sltxliftbreeding slbreeding_id_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.sltxliftbreeding
    ADD CONSTRAINT slbreeding_id_fk FOREIGN KEY (slbreeding_id) REFERENCES public.sltxbreeding(slbreeding_id);
 K   ALTER TABLE ONLY public.sltxliftbreeding DROP CONSTRAINT slbreeding_id_fk;
       public       postgres    false    3467    331    311            n           2606    137533 !   sltxposturecurve slbreeding_id_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.sltxposturecurve
    ADD CONSTRAINT slbreeding_id_fk FOREIGN KEY (slbreeding_id) REFERENCES public.sltxbreeding(slbreeding_id);
 K   ALTER TABLE ONLY public.sltxposturecurve DROP CONSTRAINT slbreeding_id_fk;
       public       postgres    false    333    3467    311            O           2606    137538 "   sltxbr_shed slbroiler_detail_id_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.sltxbr_shed
    ADD CONSTRAINT slbroiler_detail_id_fk FOREIGN KEY (slbroiler_detail_id) REFERENCES public.sltxbroiler_detail(slbroiler_detail_id);
 L   ALTER TABLE ONLY public.sltxbr_shed DROP CONSTRAINT slbroiler_detail_id_fk;
       public       postgres    false    309    315    3471            X           2606    137543 "   sltxbroiler_detail slbroiler_id_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.sltxbroiler_detail
    ADD CONSTRAINT slbroiler_id_fk FOREIGN KEY (slbroiler_id) REFERENCES public.sltxbroiler(slbroiler_id);
 L   ALTER TABLE ONLY public.sltxbroiler_detail DROP CONSTRAINT slbroiler_id_fk;
       public       postgres    false    315    313    3469            g           2606    137548     sltxlb_shed slliftbreeding_id_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.sltxlb_shed
    ADD CONSTRAINT slliftbreeding_id_fk FOREIGN KEY (slliftbreeding_id) REFERENCES public.sltxliftbreeding(slliftbreeding_id);
 J   ALTER TABLE ONLY public.sltxlb_shed DROP CONSTRAINT slliftbreeding_id_fk;
       public       postgres    false    329    331    3487            `           2606    137553 )   sltxincubator_detail slmachinegroup_id_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.sltxincubator_detail
    ADD CONSTRAINT slmachinegroup_id_fk FOREIGN KEY (slmachinegroup_id) REFERENCES public.slmdmachinegroup(slmachinegroup_id);
 S   ALTER TABLE ONLY public.sltxincubator_detail DROP CONSTRAINT slmachinegroup_id_fk;
       public       postgres    false    324    3459    304            Y           2606    137558 8   sltxbroiler_lot sltxbroiler_lot_slbroiler_detail_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.sltxbroiler_lot
    ADD CONSTRAINT sltxbroiler_lot_slbroiler_detail_id_fkey FOREIGN KEY (slbroiler_detail_id) REFERENCES public.sltxbroiler_detail(slbroiler_detail_id);
 b   ALTER TABLE ONLY public.sltxbroiler_lot DROP CONSTRAINT sltxbroiler_lot_slbroiler_detail_id_fkey;
       public       postgres    false    315    316    3471            Z           2606    137563 1   sltxbroiler_lot sltxbroiler_lot_slbroiler_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.sltxbroiler_lot
    ADD CONSTRAINT sltxbroiler_lot_slbroiler_id_fkey FOREIGN KEY (slbroiler_id) REFERENCES public.sltxbroiler(slbroiler_id);
 [   ALTER TABLE ONLY public.sltxbroiler_lot DROP CONSTRAINT sltxbroiler_lot_slbroiler_id_fkey;
       public       postgres    false    316    313    3469            [           2606    137568 7   sltxbroiler_lot sltxbroiler_lot_slsellspurchase_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.sltxbroiler_lot
    ADD CONSTRAINT sltxbroiler_lot_slsellspurchase_id_fkey FOREIGN KEY (slsellspurchase_id) REFERENCES public.sltxsellspurchase(slsellspurchase_id);
 a   ALTER TABLE ONLY public.sltxbroiler_lot DROP CONSTRAINT sltxbroiler_lot_slsellspurchase_id_fkey;
       public       postgres    false    316    335    3491            U           2606    137573 2   sltxbroiler sltxbroiler_slincubator_detail_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.sltxbroiler
    ADD CONSTRAINT sltxbroiler_slincubator_detail_id_fkey FOREIGN KEY (slincubator_detail_id) REFERENCES public.sltxincubator_detail(slincubator_detail_id);
 \   ALTER TABLE ONLY public.sltxbroiler DROP CONSTRAINT sltxbroiler_slincubator_detail_id_fkey;
       public       postgres    false    313    324    3479            ]           2606    137578 ;   sltxincubator_curve sltxincubator_curve_slincubator_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.sltxincubator_curve
    ADD CONSTRAINT sltxincubator_curve_slincubator_id_fkey FOREIGN KEY (slincubator_id) REFERENCES public.sltxincubator(slincubator);
 e   ALTER TABLE ONLY public.sltxincubator_curve DROP CONSTRAINT sltxincubator_curve_slincubator_id_fkey;
       public       postgres    false    321    320    3475            ^           2606    137583 >   sltxincubator_curve sltxincubator_curve_slposturecurve_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.sltxincubator_curve
    ADD CONSTRAINT sltxincubator_curve_slposturecurve_id_fkey FOREIGN KEY (slposturecurve_id) REFERENCES public.sltxposturecurve(slposturecurve_id);
 h   ALTER TABLE ONLY public.sltxincubator_curve DROP CONSTRAINT sltxincubator_curve_slposturecurve_id_fkey;
       public       postgres    false    321    333    3489            a           2606    137588 =   sltxincubator_lot sltxincubator_lot_slincubator_curve_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.sltxincubator_lot
    ADD CONSTRAINT sltxincubator_lot_slincubator_curve_id_fkey FOREIGN KEY (slincubator_curve_id) REFERENCES public.sltxincubator_curve(slincubator_curve_id);
 g   ALTER TABLE ONLY public.sltxincubator_lot DROP CONSTRAINT sltxincubator_lot_slincubator_curve_id_fkey;
       public       postgres    false    325    321    3477            b           2606    137593 >   sltxincubator_lot sltxincubator_lot_slincubator_detail_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.sltxincubator_lot
    ADD CONSTRAINT sltxincubator_lot_slincubator_detail_id_fkey FOREIGN KEY (slincubator_detail_id) REFERENCES public.sltxincubator_detail(slincubator_detail_id);
 h   ALTER TABLE ONLY public.sltxincubator_lot DROP CONSTRAINT sltxincubator_lot_slincubator_detail_id_fkey;
       public       postgres    false    325    324    3479            c           2606    137598 ;   sltxincubator_lot sltxincubator_lot_slsellspurchase_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.sltxincubator_lot
    ADD CONSTRAINT sltxincubator_lot_slsellspurchase_id_fkey FOREIGN KEY (slsellspurchase_id) REFERENCES public.sltxsellspurchase(slsellspurchase_id);
 e   ALTER TABLE ONLY public.sltxincubator_lot DROP CONSTRAINT sltxincubator_lot_slsellspurchase_id_fkey;
       public       postgres    false    325    335    3491            d           2606    137603 ,   sltxinventory sltxinventory_scenario_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.sltxinventory
    ADD CONSTRAINT sltxinventory_scenario_id_fkey FOREIGN KEY (scenario_id) REFERENCES public.mdscenario(scenario_id);
 V   ALTER TABLE ONLY public.sltxinventory DROP CONSTRAINT sltxinventory_scenario_id_fkey;
       public       postgres    false    327    269    3384            o           2606    137608 2   sltxposturecurve sltxposturecurve_scenario_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.sltxposturecurve
    ADD CONSTRAINT sltxposturecurve_scenario_id_fkey FOREIGN KEY (scenario_id) REFERENCES public.mdscenario(scenario_id);
 \   ALTER TABLE ONLY public.sltxposturecurve DROP CONSTRAINT sltxposturecurve_scenario_id_fkey;
       public       postgres    false    333    269    3384            q           2606    137613 4   sltxsellspurchase sltxsellspurchase_scenario_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.sltxsellspurchase
    ADD CONSTRAINT sltxsellspurchase_scenario_id_fkey FOREIGN KEY (scenario_id) REFERENCES public.mdscenario(scenario_id);
 ^   ALTER TABLE ONLY public.sltxsellspurchase DROP CONSTRAINT sltxsellspurchase_scenario_id_fkey;
       public       postgres    false    335    269    3384            l           2606    137618    sltxliftbreeding stage_id_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.sltxliftbreeding
    ADD CONSTRAINT stage_id_fk FOREIGN KEY (stage_id) REFERENCES public.mdstage(stage_id);
 F   ALTER TABLE ONLY public.sltxliftbreeding DROP CONSTRAINT stage_id_fk;
       public       postgres    false    331    273    3390            S           2606    137623    sltxbreeding stage_id_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.sltxbreeding
    ADD CONSTRAINT stage_id_fk FOREIGN KEY (stage_id) REFERENCES public.mdstage(stage_id);
 B   ALTER TABLE ONLY public.sltxbreeding DROP CONSTRAINT stage_id_fk;
       public       postgres    false    311    273    3390            I           2606    137628    slmdprocess stage_id_fk    FK CONSTRAINT        ALTER TABLE ONLY public.slmdprocess
    ADD CONSTRAINT stage_id_fk FOREIGN KEY (stage_id) REFERENCES public.mdstage(stage_id);
 A   ALTER TABLE ONLY public.slmdprocess DROP CONSTRAINT stage_id_fk;
       public       postgres    false    305    273    3390            r           2606    137633 5   txavailabilitysheds txavailabilitysheds_lot_code_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.txavailabilitysheds
    ADD CONSTRAINT txavailabilitysheds_lot_code_fkey FOREIGN KEY (lot_code) REFERENCES public.txlot(lot_code) ON UPDATE CASCADE ON DELETE CASCADE;
 _   ALTER TABLE ONLY public.txavailabilitysheds DROP CONSTRAINT txavailabilitysheds_lot_code_fkey;
       public       postgres    false    339    365    3575            s           2606    137638 4   txavailabilitysheds txavailabilitysheds_shed_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.txavailabilitysheds
    ADD CONSTRAINT txavailabilitysheds_shed_id_fkey FOREIGN KEY (shed_id) REFERENCES public.osshed(shed_id) ON UPDATE CASCADE ON DELETE CASCADE;
 ^   ALTER TABLE ONLY public.txavailabilitysheds DROP CONSTRAINT txavailabilitysheds_shed_id_fkey;
       public       postgres    false    339    285    3445            t           2606    137643 !   txbroiler txbroiler_breed_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.txbroiler
    ADD CONSTRAINT txbroiler_breed_id_fkey FOREIGN KEY (breed_id) REFERENCES public.mdbreed(breed_id) ON UPDATE CASCADE ON DELETE CASCADE;
 K   ALTER TABLE ONLY public.txbroiler DROP CONSTRAINT txbroiler_breed_id_fkey;
       public       postgres    false    340    253    3357            x           2606    137648 1   txbroiler_detail txbroiler_detail_broiler_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.txbroiler_detail
    ADD CONSTRAINT txbroiler_detail_broiler_id_fkey FOREIGN KEY (broiler_id) REFERENCES public.txbroiler(broiler_id) ON UPDATE CASCADE ON DELETE CASCADE;
 [   ALTER TABLE ONLY public.txbroiler_detail DROP CONSTRAINT txbroiler_detail_broiler_id_fkey;
       public       postgres    false    341    340    3503            y           2606    137653 9   txbroiler_detail txbroiler_detail_broiler_product_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.txbroiler_detail
    ADD CONSTRAINT txbroiler_detail_broiler_product_id_fkey FOREIGN KEY (broiler_product_id) REFERENCES public.mdbroiler_product(broiler_product_id);
 c   ALTER TABLE ONLY public.txbroiler_detail DROP CONSTRAINT txbroiler_detail_broiler_product_id_fkey;
       public       postgres    false    341    254    3359            z           2606    137658 0   txbroiler_detail txbroiler_detail_center_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.txbroiler_detail
    ADD CONSTRAINT txbroiler_detail_center_id_fkey FOREIGN KEY (center_id) REFERENCES public.oscenter(center_id);
 Z   ALTER TABLE ONLY public.txbroiler_detail DROP CONSTRAINT txbroiler_detail_center_id_fkey;
       public       postgres    false    278    341    3407            {           2606    137663 9   txbroiler_detail txbroiler_detail_executioncenter_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.txbroiler_detail
    ADD CONSTRAINT txbroiler_detail_executioncenter_id_fkey FOREIGN KEY (executioncenter_id) REFERENCES public.oscenter(center_id);
 c   ALTER TABLE ONLY public.txbroiler_detail DROP CONSTRAINT txbroiler_detail_executioncenter_id_fkey;
       public       postgres    false    3407    341    278            |           2606    137668 7   txbroiler_detail txbroiler_detail_executionfarm_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.txbroiler_detail
    ADD CONSTRAINT txbroiler_detail_executionfarm_id_fkey FOREIGN KEY (executionfarm_id) REFERENCES public.osfarm(farm_id);
 a   ALTER TABLE ONLY public.txbroiler_detail DROP CONSTRAINT txbroiler_detail_executionfarm_id_fkey;
       public       postgres    false    341    279    3417            }           2606    137673 7   txbroiler_detail txbroiler_detail_executionshed_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.txbroiler_detail
    ADD CONSTRAINT txbroiler_detail_executionshed_id_fkey FOREIGN KEY (executionshed_id) REFERENCES public.osshed(shed_id);
 a   ALTER TABLE ONLY public.txbroiler_detail DROP CONSTRAINT txbroiler_detail_executionshed_id_fkey;
       public       postgres    false    341    285    3445            ~           2606    137678 .   txbroiler_detail txbroiler_detail_farm_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.txbroiler_detail
    ADD CONSTRAINT txbroiler_detail_farm_id_fkey FOREIGN KEY (farm_id) REFERENCES public.osfarm(farm_id) ON UPDATE CASCADE ON DELETE CASCADE;
 X   ALTER TABLE ONLY public.txbroiler_detail DROP CONSTRAINT txbroiler_detail_farm_id_fkey;
       public       postgres    false    341    279    3417                       2606    137683 .   txbroiler_detail txbroiler_detail_shed_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.txbroiler_detail
    ADD CONSTRAINT txbroiler_detail_shed_id_fkey FOREIGN KEY (shed_id) REFERENCES public.osshed(shed_id) ON UPDATE CASCADE ON DELETE CASCADE;
 X   ALTER TABLE ONLY public.txbroiler_detail DROP CONSTRAINT txbroiler_detail_shed_id_fkey;
       public       postgres    false    341    285    3445            u           2606    137688 '   txbroiler txbroiler_partnership_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.txbroiler
    ADD CONSTRAINT txbroiler_partnership_id_fkey FOREIGN KEY (partnership_id) REFERENCES public.ospartnership(partnership_id) ON UPDATE CASCADE ON DELETE CASCADE;
 Q   ALTER TABLE ONLY public.txbroiler DROP CONSTRAINT txbroiler_partnership_id_fkey;
       public       postgres    false    283    340    3439            v           2606    137693 +   txbroiler txbroiler_programmed_eggs_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.txbroiler
    ADD CONSTRAINT txbroiler_programmed_eggs_id_fkey FOREIGN KEY (programmed_eggs_id) REFERENCES public.txprogrammed_eggs(programmed_eggs_id) ON UPDATE CASCADE ON DELETE CASCADE;
 U   ALTER TABLE ONLY public.txbroiler DROP CONSTRAINT txbroiler_programmed_eggs_id_fkey;
       public       postgres    false    340    368    3587            w           2606    137698 $   txbroiler txbroiler_scenario_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.txbroiler
    ADD CONSTRAINT txbroiler_scenario_id_fkey FOREIGN KEY (scenario_id) REFERENCES public.mdscenario(scenario_id) ON UPDATE CASCADE ON DELETE CASCADE;
 N   ALTER TABLE ONLY public.txbroiler DROP CONSTRAINT txbroiler_scenario_id_fkey;
       public       postgres    false    340    269    3384            �           2606    137703 1   txbroilereviction txbroilereviction_breed_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.txbroilereviction
    ADD CONSTRAINT txbroilereviction_breed_id_fkey FOREIGN KEY (breed_id) REFERENCES public.mdbreed(breed_id) ON UPDATE CASCADE ON DELETE CASCADE;
 [   ALTER TABLE ONLY public.txbroilereviction DROP CONSTRAINT txbroilereviction_breed_id_fkey;
       public       postgres    false    344    253    3357            �           2606    137708 :   txbroilereviction txbroilereviction_broiler_detail_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.txbroilereviction
    ADD CONSTRAINT txbroilereviction_broiler_detail_id_fkey FOREIGN KEY (broiler_detail_id) REFERENCES public.txbroiler_detail(broiler_detail_id);
 d   ALTER TABLE ONLY public.txbroilereviction DROP CONSTRAINT txbroilereviction_broiler_detail_id_fkey;
       public       postgres    false    344    341    3508            �           2606    137713 @   txbroilereviction txbroilereviction_broiler_heavy_detail_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.txbroilereviction
    ADD CONSTRAINT txbroilereviction_broiler_heavy_detail_id_fkey FOREIGN KEY (broiler_heavy_detail_id) REFERENCES public.txbroilerheavy_detail(broiler_heavy_detail_id);
 j   ALTER TABLE ONLY public.txbroilereviction DROP CONSTRAINT txbroilereviction_broiler_heavy_detail_id_fkey;
       public       postgres    false    3524    344    346            �           2606    137718 A   txbroilereviction_detail txbroilereviction_detail_broiler_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.txbroilereviction_detail
    ADD CONSTRAINT txbroilereviction_detail_broiler_id_fkey FOREIGN KEY (broilereviction_id) REFERENCES public.txbroilereviction(broilereviction_id) ON UPDATE CASCADE ON DELETE CASCADE;
 k   ALTER TABLE ONLY public.txbroilereviction_detail DROP CONSTRAINT txbroilereviction_detail_broiler_id_fkey;
       public       postgres    false    3515    344    345            �           2606    137723 I   txbroilereviction_detail txbroilereviction_detail_broiler_product_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.txbroilereviction_detail
    ADD CONSTRAINT txbroilereviction_detail_broiler_product_id_fkey FOREIGN KEY (broiler_product_id) REFERENCES public.mdbroiler_product(broiler_product_id) ON UPDATE CASCADE ON DELETE CASCADE;
 s   ALTER TABLE ONLY public.txbroilereviction_detail DROP CONSTRAINT txbroilereviction_detail_broiler_product_id_fkey;
       public       postgres    false    345    254    3359            �           2606    137728 @   txbroilereviction_detail txbroilereviction_detail_center_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.txbroilereviction_detail
    ADD CONSTRAINT txbroilereviction_detail_center_id_fkey FOREIGN KEY (center_id) REFERENCES public.oscenter(center_id);
 j   ALTER TABLE ONLY public.txbroilereviction_detail DROP CONSTRAINT txbroilereviction_detail_center_id_fkey;
       public       postgres    false    345    278    3407            �           2606    137733 M   txbroilereviction_detail txbroilereviction_detail_execution_slaughterhouse_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.txbroilereviction_detail
    ADD CONSTRAINT txbroilereviction_detail_execution_slaughterhouse_id FOREIGN KEY (executionslaughterhouse_id) REFERENCES public.osslaughterhouse(slaughterhouse_id);
 w   ALTER TABLE ONLY public.txbroilereviction_detail DROP CONSTRAINT txbroilereviction_detail_execution_slaughterhouse_id;
       public       postgres    false    345    287    3453            �           2606    137738 >   txbroilereviction_detail txbroilereviction_detail_farm_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.txbroilereviction_detail
    ADD CONSTRAINT txbroilereviction_detail_farm_id_fkey FOREIGN KEY (farm_id) REFERENCES public.osfarm(farm_id) ON UPDATE CASCADE ON DELETE CASCADE;
 h   ALTER TABLE ONLY public.txbroilereviction_detail DROP CONSTRAINT txbroilereviction_detail_farm_id_fkey;
       public       postgres    false    345    279    3417            �           2606    137743 >   txbroilereviction_detail txbroilereviction_detail_shed_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.txbroilereviction_detail
    ADD CONSTRAINT txbroilereviction_detail_shed_id_fkey FOREIGN KEY (shed_id) REFERENCES public.osshed(shed_id) ON UPDATE CASCADE ON DELETE CASCADE;
 h   ALTER TABLE ONLY public.txbroilereviction_detail DROP CONSTRAINT txbroilereviction_detail_shed_id_fkey;
       public       postgres    false    345    285    3445            �           2606    137748 H   txbroilereviction_detail txbroilereviction_detail_slaughterhouse_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.txbroilereviction_detail
    ADD CONSTRAINT txbroilereviction_detail_slaughterhouse_id_fkey FOREIGN KEY (slaughterhouse_id) REFERENCES public.osslaughterhouse(slaughterhouse_id) ON UPDATE CASCADE ON DELETE CASCADE;
 r   ALTER TABLE ONLY public.txbroilereviction_detail DROP CONSTRAINT txbroilereviction_detail_slaughterhouse_id_fkey;
       public       postgres    false    345    287    3453            �           2606    137753 7   txbroilereviction txbroilereviction_partnership_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.txbroilereviction
    ADD CONSTRAINT txbroilereviction_partnership_id_fkey FOREIGN KEY (partnership_id) REFERENCES public.ospartnership(partnership_id) ON UPDATE CASCADE ON DELETE CASCADE;
 a   ALTER TABLE ONLY public.txbroilereviction DROP CONSTRAINT txbroilereviction_partnership_id_fkey;
       public       postgres    false    344    283    3439            �           2606    137758 4   txbroilereviction txbroilereviction_scenario_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.txbroilereviction
    ADD CONSTRAINT txbroilereviction_scenario_id_fkey FOREIGN KEY (scenario_id) REFERENCES public.mdscenario(scenario_id) ON UPDATE CASCADE ON DELETE CASCADE;
 ^   ALTER TABLE ONLY public.txbroilereviction DROP CONSTRAINT txbroilereviction_scenario_id_fkey;
       public       postgres    false    344    269    3384            �           2606    137763 B   txbroilerheavy_detail txbroilerheavy_detail_broiler_detail_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.txbroilerheavy_detail
    ADD CONSTRAINT txbroilerheavy_detail_broiler_detail_id_fkey FOREIGN KEY (broiler_detail_id) REFERENCES public.txbroiler_detail(broiler_detail_id);
 l   ALTER TABLE ONLY public.txbroilerheavy_detail DROP CONSTRAINT txbroilerheavy_detail_broiler_detail_id_fkey;
       public       postgres    false    341    346    3508            �           2606    137768 C   txbroilerheavy_detail txbroilerheavy_detail_broiler_product_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.txbroilerheavy_detail
    ADD CONSTRAINT txbroilerheavy_detail_broiler_product_id_fkey FOREIGN KEY (broiler_product_id) REFERENCES public.mdbroiler_product(broiler_product_id);
 m   ALTER TABLE ONLY public.txbroilerheavy_detail DROP CONSTRAINT txbroilerheavy_detail_broiler_product_id_fkey;
       public       postgres    false    346    254    3359            �           2606    137773 C   txbroilerproduct_detail txbroilerproduct_detail_broiler_detail_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.txbroilerproduct_detail
    ADD CONSTRAINT txbroilerproduct_detail_broiler_detail_fkey FOREIGN KEY (broiler_detail) REFERENCES public.txbroiler_detail(broiler_detail_id) ON UPDATE CASCADE ON DELETE CASCADE;
 m   ALTER TABLE ONLY public.txbroilerproduct_detail DROP CONSTRAINT txbroilerproduct_detail_broiler_detail_fkey;
       public       postgres    false    348    341    3508            �           2606    137778 .   txbroodermachine txbroodermachine_farm_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.txbroodermachine
    ADD CONSTRAINT txbroodermachine_farm_id_fkey FOREIGN KEY (farm_id) REFERENCES public.osfarm(farm_id) ON UPDATE CASCADE ON DELETE CASCADE;
 X   ALTER TABLE ONLY public.txbroodermachine DROP CONSTRAINT txbroodermachine_farm_id_fkey;
       public       postgres    false    349    279    3417            �           2606    137783 5   txbroodermachine txbroodermachine_partnership_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.txbroodermachine
    ADD CONSTRAINT txbroodermachine_partnership_id_fkey FOREIGN KEY (partnership_id) REFERENCES public.ospartnership(partnership_id) ON UPDATE CASCADE ON DELETE CASCADE;
 _   ALTER TABLE ONLY public.txbroodermachine DROP CONSTRAINT txbroodermachine_partnership_id_fkey;
       public       postgres    false    349    283    3439            �           2606    137793 -   txeggs_planning txeggs_planning_breed_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.txeggs_planning
    ADD CONSTRAINT txeggs_planning_breed_id_fkey FOREIGN KEY (breed_id) REFERENCES public.mdbreed(breed_id) ON UPDATE CASCADE ON DELETE CASCADE;
 W   ALTER TABLE ONLY public.txeggs_planning DROP CONSTRAINT txeggs_planning_breed_id_fkey;
       public       postgres    false    352    253    3357            �           2606    137798 0   txeggs_planning txeggs_planning_scenario_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.txeggs_planning
    ADD CONSTRAINT txeggs_planning_scenario_id_fkey FOREIGN KEY (scenario_id) REFERENCES public.mdscenario(scenario_id);
 Z   ALTER TABLE ONLY public.txeggs_planning DROP CONSTRAINT txeggs_planning_scenario_id_fkey;
       public       postgres    false    352    269    3384            �           2606    137803 -   txeggs_required txeggs_required_breed_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.txeggs_required
    ADD CONSTRAINT txeggs_required_breed_id_fkey FOREIGN KEY (breed_id) REFERENCES public.mdbreed(breed_id);
 W   ALTER TABLE ONLY public.txeggs_required DROP CONSTRAINT txeggs_required_breed_id_fkey;
       public       postgres    false    353    253    3357            �           2606    137808 0   txeggs_required txeggs_required_scenario_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.txeggs_required
    ADD CONSTRAINT txeggs_required_scenario_id_fkey FOREIGN KEY (scenario_id) REFERENCES public.mdscenario(scenario_id);
 Z   ALTER TABLE ONLY public.txeggs_required DROP CONSTRAINT txeggs_required_scenario_id_fkey;
       public       postgres    false    353    269    3384            �           2606    137813 +   txeggs_storage txeggs_storage_breed_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.txeggs_storage
    ADD CONSTRAINT txeggs_storage_breed_id_fkey FOREIGN KEY (breed_id) REFERENCES public.mdbreed(breed_id);
 U   ALTER TABLE ONLY public.txeggs_storage DROP CONSTRAINT txeggs_storage_breed_id_fkey;
       public       postgres    false    354    253    3357            �           2606    137818 5   txeggs_storage txeggs_storage_incubator_plant_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.txeggs_storage
    ADD CONSTRAINT txeggs_storage_incubator_plant_id_fkey FOREIGN KEY (incubator_plant_id) REFERENCES public.osincubatorplant(incubator_plant_id);
 _   ALTER TABLE ONLY public.txeggs_storage DROP CONSTRAINT txeggs_storage_incubator_plant_id_fkey;
       public       postgres    false    354    281    3431            �           2606    137823 .   txeggs_storage txeggs_storage_scenario_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.txeggs_storage
    ADD CONSTRAINT txeggs_storage_scenario_id_fkey FOREIGN KEY (scenario_id) REFERENCES public.mdscenario(scenario_id);
 X   ALTER TABLE ONLY public.txeggs_storage DROP CONSTRAINT txeggs_storage_scenario_id_fkey;
       public       postgres    false    354    269    3384            �           2606    137828 '   txgoals_erp txgoals_erp_product_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.txgoals_erp
    ADD CONSTRAINT txgoals_erp_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.mdproduct(product_id);
 Q   ALTER TABLE ONLY public.txgoals_erp DROP CONSTRAINT txgoals_erp_product_id_fkey;
       public       postgres    false    355    265    3376            �           2606    137833 (   txgoals_erp txgoals_erp_scenario_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.txgoals_erp
    ADD CONSTRAINT txgoals_erp_scenario_id_fkey FOREIGN KEY (scenario_id) REFERENCES public.mdscenario(scenario_id);
 R   ALTER TABLE ONLY public.txgoals_erp DROP CONSTRAINT txgoals_erp_scenario_id_fkey;
       public       postgres    false    355    269    3384            �           2606    137838 '   txhousingway txhousingway_breed_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.txhousingway
    ADD CONSTRAINT txhousingway_breed_id_fkey FOREIGN KEY (breed_id) REFERENCES public.mdbreed(breed_id) ON UPDATE CASCADE ON DELETE CASCADE;
 Q   ALTER TABLE ONLY public.txhousingway DROP CONSTRAINT txhousingway_breed_id_fkey;
       public       postgres    false    357    253    3357            �           2606    137843 6   txhousingway_detail txhousingway_detail_center_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.txhousingway_detail
    ADD CONSTRAINT txhousingway_detail_center_id_fkey FOREIGN KEY (center_id) REFERENCES public.oscenter(center_id);
 `   ALTER TABLE ONLY public.txhousingway_detail DROP CONSTRAINT txhousingway_detail_center_id_fkey;
       public       postgres    false    358    278    3407            �           2606    137848 @   txhousingway_detail txhousingway_detail_execution_center_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.txhousingway_detail
    ADD CONSTRAINT txhousingway_detail_execution_center_id_fkey FOREIGN KEY (executioncenter_id) REFERENCES public.oscenter(center_id);
 j   ALTER TABLE ONLY public.txhousingway_detail DROP CONSTRAINT txhousingway_detail_execution_center_id_fkey;
       public       postgres    false    358    278    3407            �           2606    137853 >   txhousingway_detail txhousingway_detail_execution_farm_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.txhousingway_detail
    ADD CONSTRAINT txhousingway_detail_execution_farm_id_fkey FOREIGN KEY (executionfarm_id) REFERENCES public.osfarm(farm_id);
 h   ALTER TABLE ONLY public.txhousingway_detail DROP CONSTRAINT txhousingway_detail_execution_farm_id_fkey;
       public       postgres    false    358    279    3417            �           2606    137858 >   txhousingway_detail txhousingway_detail_execution_shed_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.txhousingway_detail
    ADD CONSTRAINT txhousingway_detail_execution_shed_id_fkey FOREIGN KEY (executionshed_id) REFERENCES public.osshed(shed_id);
 h   ALTER TABLE ONLY public.txhousingway_detail DROP CONSTRAINT txhousingway_detail_execution_shed_id_fkey;
       public       postgres    false    358    285    3445            �           2606    137863 G   txhousingway_detail txhousingway_detail_executionincubatorplant_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.txhousingway_detail
    ADD CONSTRAINT txhousingway_detail_executionincubatorplant_id_fkey FOREIGN KEY (executionincubatorplant_id) REFERENCES public.osincubatorplant(incubator_plant_id);
 q   ALTER TABLE ONLY public.txhousingway_detail DROP CONSTRAINT txhousingway_detail_executionincubatorplant_id_fkey;
       public       postgres    false    358    281    3431            �           2606    137868 4   txhousingway_detail txhousingway_detail_farm_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.txhousingway_detail
    ADD CONSTRAINT txhousingway_detail_farm_id_fkey FOREIGN KEY (farm_id) REFERENCES public.osfarm(farm_id) ON UPDATE CASCADE ON DELETE CASCADE;
 ^   ALTER TABLE ONLY public.txhousingway_detail DROP CONSTRAINT txhousingway_detail_farm_id_fkey;
       public       postgres    false    3417    279    358            �           2606    137873 ;   txhousingway_detail txhousingway_detail_housing_way_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.txhousingway_detail
    ADD CONSTRAINT txhousingway_detail_housing_way_id_fkey FOREIGN KEY (housing_way_id) REFERENCES public.txhousingway(housing_way_id) ON UPDATE CASCADE ON DELETE CASCADE;
 e   ALTER TABLE ONLY public.txhousingway_detail DROP CONSTRAINT txhousingway_detail_housing_way_id_fkey;
       public       postgres    false    357    358    3556            �           2606    137878 4   txhousingway_detail txhousingway_detail_shed_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.txhousingway_detail
    ADD CONSTRAINT txhousingway_detail_shed_id_fkey FOREIGN KEY (shed_id) REFERENCES public.osshed(shed_id) ON UPDATE CASCADE ON DELETE CASCADE;
 ^   ALTER TABLE ONLY public.txhousingway_detail DROP CONSTRAINT txhousingway_detail_shed_id_fkey;
       public       postgres    false    358    285    3445            �           2606    137883 -   txhousingway txhousingway_partnership_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.txhousingway
    ADD CONSTRAINT txhousingway_partnership_id_fkey FOREIGN KEY (partnership_id) REFERENCES public.ospartnership(partnership_id) ON UPDATE CASCADE ON DELETE CASCADE;
 W   ALTER TABLE ONLY public.txhousingway DROP CONSTRAINT txhousingway_partnership_id_fkey;
       public       postgres    false    357    283    3439            �           2606    137888 *   txhousingway txhousingway_scenario_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.txhousingway
    ADD CONSTRAINT txhousingway_scenario_id_fkey FOREIGN KEY (scenario_id) REFERENCES public.mdscenario(scenario_id) ON UPDATE CASCADE ON DELETE CASCADE;
 T   ALTER TABLE ONLY public.txhousingway DROP CONSTRAINT txhousingway_scenario_id_fkey;
       public       postgres    false    357    269    3384            �           2606    137893 '   txhousingway txhousingway_stage_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.txhousingway
    ADD CONSTRAINT txhousingway_stage_id_fkey FOREIGN KEY (stage_id) REFERENCES public.mdstage(stage_id);
 Q   ALTER TABLE ONLY public.txhousingway DROP CONSTRAINT txhousingway_stage_id_fkey;
       public       postgres    false    357    273    3390            �           2606    137898 6   txincubator_lot txincubator_lot_eggs_movements_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.txincubator_lot
    ADD CONSTRAINT txincubator_lot_eggs_movements_id_fkey FOREIGN KEY (eggs_movements_id) REFERENCES public.txeggs_movements(eggs_movements_id);
 `   ALTER TABLE ONLY public.txincubator_lot DROP CONSTRAINT txincubator_lot_eggs_movements_id_fkey;
       public       postgres    false    361    351    3533            �           2606    137903 7   txincubator_lot txincubator_lot_programmed_eggs_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.txincubator_lot
    ADD CONSTRAINT txincubator_lot_programmed_eggs_id_fkey FOREIGN KEY (programmed_eggs_id) REFERENCES public.txprogrammed_eggs(programmed_eggs_id);
 a   ALTER TABLE ONLY public.txincubator_lot DROP CONSTRAINT txincubator_lot_programmed_eggs_id_fkey;
       public       postgres    false    361    368    3587            �           2606    137908    txlot txlot_breed_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.txlot
    ADD CONSTRAINT txlot_breed_id_fkey FOREIGN KEY (breed_id) REFERENCES public.mdbreed(breed_id);
 C   ALTER TABLE ONLY public.txlot DROP CONSTRAINT txlot_breed_id_fkey;
       public       postgres    false    365    253    3357            �           2606    137913    txlot txlot_farm_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.txlot
    ADD CONSTRAINT txlot_farm_id_fkey FOREIGN KEY (farm_id) REFERENCES public.osfarm(farm_id) ON UPDATE CASCADE ON DELETE CASCADE;
 B   ALTER TABLE ONLY public.txlot DROP CONSTRAINT txlot_farm_id_fkey;
       public       postgres    false    365    279    3417            �           2606    137918    txlot txlot_housing_way_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.txlot
    ADD CONSTRAINT txlot_housing_way_id_fkey FOREIGN KEY (housing_way_id) REFERENCES public.txhousingway(housing_way_id) ON UPDATE CASCADE ON DELETE CASCADE;
 I   ALTER TABLE ONLY public.txlot DROP CONSTRAINT txlot_housing_way_id_fkey;
       public       postgres    false    357    365    3556            �           2606    137923    txlot txlot_product_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.txlot
    ADD CONSTRAINT txlot_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.mdproduct(product_id);
 E   ALTER TABLE ONLY public.txlot DROP CONSTRAINT txlot_product_id_fkey;
       public       postgres    false    365    265    3376            �           2606    137928    txlot txlot_shed_id_fkey    FK CONSTRAINT     }   ALTER TABLE ONLY public.txlot
    ADD CONSTRAINT txlot_shed_id_fkey FOREIGN KEY (shed_id) REFERENCES public.osshed(shed_id);
 B   ALTER TABLE ONLY public.txlot DROP CONSTRAINT txlot_shed_id_fkey;
       public       postgres    false    365    285    3445            �           2606    137933 +   txposturecurve txposturecurve_breed_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.txposturecurve
    ADD CONSTRAINT txposturecurve_breed_id_fkey FOREIGN KEY (breed_id) REFERENCES public.mdbreed(breed_id) ON UPDATE CASCADE ON DELETE CASCADE;
 U   ALTER TABLE ONLY public.txposturecurve DROP CONSTRAINT txposturecurve_breed_id_fkey;
       public       postgres    false    367    253    3357            �           2606    137938 1   txprogrammed_eggs txprogrammed_eggs_breed_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.txprogrammed_eggs
    ADD CONSTRAINT txprogrammed_eggs_breed_id_fkey FOREIGN KEY (breed_id) REFERENCES public.mdbreed(breed_id) ON UPDATE CASCADE ON DELETE CASCADE;
 [   ALTER TABLE ONLY public.txprogrammed_eggs DROP CONSTRAINT txprogrammed_eggs_breed_id_fkey;
       public       postgres    false    368    253    3357            �           2606    137943 5   txprogrammed_eggs txprogrammed_eggs_eggs_movements_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.txprogrammed_eggs
    ADD CONSTRAINT txprogrammed_eggs_eggs_movements_id FOREIGN KEY (eggs_movements_id) REFERENCES public.txeggs_movements(eggs_movements_id);
 _   ALTER TABLE ONLY public.txprogrammed_eggs DROP CONSTRAINT txprogrammed_eggs_eggs_movements_id;
       public       postgres    false    368    351    3533            �           2606    137948 8   txprogrammed_eggs txprogrammed_eggs_eggs_storage_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.txprogrammed_eggs
    ADD CONSTRAINT txprogrammed_eggs_eggs_storage_id_fkey FOREIGN KEY (eggs_storage_id) REFERENCES public.txeggs_storage(eggs_storage_id) ON UPDATE CASCADE ON DELETE CASCADE;
 b   ALTER TABLE ONLY public.txprogrammed_eggs DROP CONSTRAINT txprogrammed_eggs_eggs_storage_id_fkey;
       public       postgres    false    368    354    3546            �           2606    137953 5   txprogrammed_eggs txprogrammed_eggs_incubator_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.txprogrammed_eggs
    ADD CONSTRAINT txprogrammed_eggs_incubator_id_fkey FOREIGN KEY (incubator_id) REFERENCES public.osincubator(incubator_id) ON UPDATE CASCADE ON DELETE CASCADE;
 _   ALTER TABLE ONLY public.txprogrammed_eggs DROP CONSTRAINT txprogrammed_eggs_incubator_id_fkey;
       public       postgres    false    368    280    3422            �           2606    137958 3   txscenarioformula txscenarioformula_measure_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.txscenarioformula
    ADD CONSTRAINT txscenarioformula_measure_id_fkey FOREIGN KEY (measure_id) REFERENCES public.mdmeasure(measure_id) ON UPDATE CASCADE ON DELETE CASCADE;
 ]   ALTER TABLE ONLY public.txscenarioformula DROP CONSTRAINT txscenarioformula_measure_id_fkey;
       public       postgres    false    369    259    3363            �           2606    137963 5   txscenarioformula txscenarioformula_parameter_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.txscenarioformula
    ADD CONSTRAINT txscenarioformula_parameter_id_fkey FOREIGN KEY (parameter_id) REFERENCES public.mdparameter(parameter_id) ON UPDATE CASCADE ON DELETE CASCADE;
 _   ALTER TABLE ONLY public.txscenarioformula DROP CONSTRAINT txscenarioformula_parameter_id_fkey;
       public       postgres    false    369    3367    261            �           2606    137968 3   txscenarioformula txscenarioformula_process_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.txscenarioformula
    ADD CONSTRAINT txscenarioformula_process_id_fkey FOREIGN KEY (process_id) REFERENCES public.mdprocess(process_id) ON UPDATE CASCADE;
 ]   ALTER TABLE ONLY public.txscenarioformula DROP CONSTRAINT txscenarioformula_process_id_fkey;
       public       postgres    false    369    263    3372            �           2606    137973 4   txscenarioformula txscenarioformula_scenario_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.txscenarioformula
    ADD CONSTRAINT txscenarioformula_scenario_id_fkey FOREIGN KEY (scenario_id) REFERENCES public.mdscenario(scenario_id) ON UPDATE CASCADE ON DELETE CASCADE;
 ^   ALTER TABLE ONLY public.txscenarioformula DROP CONSTRAINT txscenarioformula_scenario_id_fkey;
       public       postgres    false    3384    369    269            �           2606    137978 9   txscenarioparameter txscenarioparameter_parameter_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.txscenarioparameter
    ADD CONSTRAINT txscenarioparameter_parameter_id_fkey FOREIGN KEY (parameter_id) REFERENCES public.mdparameter(parameter_id) ON UPDATE CASCADE ON DELETE CASCADE;
 c   ALTER TABLE ONLY public.txscenarioparameter DROP CONSTRAINT txscenarioparameter_parameter_id_fkey;
       public       postgres    false    3367    370    261            �           2606    137983 7   txscenarioparameter txscenarioparameter_process_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.txscenarioparameter
    ADD CONSTRAINT txscenarioparameter_process_id_fkey FOREIGN KEY (process_id) REFERENCES public.mdprocess(process_id) ON UPDATE CASCADE ON DELETE CASCADE;
 a   ALTER TABLE ONLY public.txscenarioparameter DROP CONSTRAINT txscenarioparameter_process_id_fkey;
       public       postgres    false    370    263    3372            �           2606    137988 8   txscenarioparameter txscenarioparameter_scenario_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.txscenarioparameter
    ADD CONSTRAINT txscenarioparameter_scenario_id_fkey FOREIGN KEY (scenario_id) REFERENCES public.mdscenario(scenario_id) ON UPDATE CASCADE ON DELETE CASCADE;
 b   ALTER TABLE ONLY public.txscenarioparameter DROP CONSTRAINT txscenarioparameter_scenario_id_fkey;
       public       postgres    false    269    3384    370            �           2606    137993 ?   txscenarioparameterday txscenarioparameterday_parameter_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.txscenarioparameterday
    ADD CONSTRAINT txscenarioparameterday_parameter_id_fkey FOREIGN KEY (parameter_id) REFERENCES public.mdparameter(parameter_id);
 i   ALTER TABLE ONLY public.txscenarioparameterday DROP CONSTRAINT txscenarioparameterday_parameter_id_fkey;
       public       postgres    false    261    3367    371            �           2606    137998 >   txscenarioparameterday txscenarioparameterday_scenario_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.txscenarioparameterday
    ADD CONSTRAINT txscenarioparameterday_scenario_id_fkey FOREIGN KEY (scenario_id) REFERENCES public.mdscenario(scenario_id);
 h   ALTER TABLE ONLY public.txscenarioparameterday DROP CONSTRAINT txscenarioparameterday_scenario_id_fkey;
       public       postgres    false    3384    269    371            �           2606    138003 ;   txscenarioposturecurve txscenarioposturecurve_breed_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.txscenarioposturecurve
    ADD CONSTRAINT txscenarioposturecurve_breed_id_fkey FOREIGN KEY (breed_id) REFERENCES public.mdbreed(breed_id) ON UPDATE CASCADE ON DELETE CASCADE;
 e   ALTER TABLE ONLY public.txscenarioposturecurve DROP CONSTRAINT txscenarioposturecurve_breed_id_fkey;
       public       postgres    false    372    3357    253            �           2606    138008 G   txscenarioposturecurve txscenarioposturecurve_housingway_detail_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.txscenarioposturecurve
    ADD CONSTRAINT txscenarioposturecurve_housingway_detail_id_fkey FOREIGN KEY (housingway_detail_id) REFERENCES public.txhousingway_detail(housingway_detail_id) ON UPDATE CASCADE ON DELETE CASCADE;
 q   ALTER TABLE ONLY public.txscenarioposturecurve DROP CONSTRAINT txscenarioposturecurve_housingway_detail_id_fkey;
       public       postgres    false    3562    358    372            �           2606    138013 >   txscenarioposturecurve txscenarioposturecurve_scenario_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.txscenarioposturecurve
    ADD CONSTRAINT txscenarioposturecurve_scenario_id_fkey FOREIGN KEY (scenario_id) REFERENCES public.mdscenario(scenario_id) ON UPDATE CASCADE ON DELETE CASCADE;
 h   ALTER TABLE ONLY public.txscenarioposturecurve DROP CONSTRAINT txscenarioposturecurve_scenario_id_fkey;
       public       postgres    false    372    3384    269            �           2606    138018 3   txscenarioprocess txscenarioprocess_process_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.txscenarioprocess
    ADD CONSTRAINT txscenarioprocess_process_id_fkey FOREIGN KEY (process_id) REFERENCES public.mdprocess(process_id) ON UPDATE CASCADE ON DELETE CASCADE;
 ]   ALTER TABLE ONLY public.txscenarioprocess DROP CONSTRAINT txscenarioprocess_process_id_fkey;
       public       postgres    false    3372    373    263            �           2606    138023 4   txscenarioprocess txscenarioprocess_scenario_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.txscenarioprocess
    ADD CONSTRAINT txscenarioprocess_scenario_id_fkey FOREIGN KEY (scenario_id) REFERENCES public.mdscenario(scenario_id) ON UPDATE CASCADE ON DELETE CASCADE;
 ^   ALTER TABLE ONLY public.txscenarioprocess DROP CONSTRAINT txscenarioprocess_scenario_id_fkey;
       public       postgres    false    373    3384    269            ?      x������ � �      A      x������ � �      C      x������ � �      E      x������ � �      G      x������ � �      I      x������ � �      K      x������ � �      N      x������ � �      O      x������ � �      n      x������ � �      p      x������ � �      s      x������ � �      u      x������ � �      v      x������ � �      w      x������ � �      x      x������ � �      z      x������ � �      |      x������ � �      ~      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �   M   x�3�4�t�K�/JI�2�4���K.MJL����2�4�J-(�O)M.�/J,�2�4�t.�LT�T�I-K�+I����� �q�      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �     