/*Get Videogames*/
CREATE OR REPLACE FUNCTION competition_data.get_videogames()
    RETURNS jsonb
    LANGUAGE 'plpgsql'

AS $BODY$
declare
	v_result jsonb;
BEGIN
   SELECT jsonb_agg(jsonb_build_object(
		'id', v.id,
		'name', v.name
	)) into v_result
	FROM master_data.videogame v
  WHERE v.enabled;

   RETURN v_result;
END;
$BODY$;

/*Get Platforms*/
CREATE OR REPLACE FUNCTION competition_data.get_platforms(
  p_videogame integer)
    RETURNS jsonb
    LANGUAGE 'plpgsql'

AS $BODY$
declare
	v_result jsonb;
BEGIN
  SELECT jsonb_agg(jsonb_build_object(
		'id', p.id,
		'name', p.name
	)) into v_result
	FROM master_data.platform p
  WHERE p.enabled
  AND p.id IN(
    SELECT vp.platform
		FROM master_data.videogame_platform vp
		WHERE vp.enabled
		AND vp.videogame = p_videogame);

   RETURN v_result;
END;
$BODY$;

/*Get Regions*/
CREATE OR REPLACE FUNCTION competition_data.get_regions(
  p_videogame integer)
    RETURNS jsonb
    LANGUAGE 'plpgsql'

AS $BODY$
declare
	v_result jsonb;
BEGIN
  SELECT jsonb_agg(jsonb_build_object(
		'id', r.id,
		'name', r.name
	)) into v_result
	FROM master_data.region r
  WHERE r.enabled
  AND r.videogame = p_videogame;

   RETURN v_result;
END;
$BODY$;

/*Get GameModes*/
CREATE OR REPLACE FUNCTION competition_data.get_gamemodes(
  p_videogame integer)
    RETURNS jsonb
    LANGUAGE 'plpgsql'

AS $BODY$
declare
	v_result jsonb;
BEGIN
  SELECT jsonb_agg(jsonb_build_object(
		'id', g.id,
		'name', g.name
	)) into v_result
	FROM master_data.gamemode g
  WHERE g.enabled
  AND g.videogame = p_videogame;

   RETURN v_result;
END;
$BODY$;

/*Create Competition*/
CREATE OR REPLACE FUNCTION competition_data.create_competition(
	p_organization integer,
	p_name text,
	p_videogame integer,
	p_platform integer,
	p_region integer,
	p_gamemode integer)
    RETURNS integer
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE
AS $BODY$
declare
	v_id integer;
BEGIN
   SELECT nextval('competition_data.COMPETITION_SEQ') into v_id;

   INSERT INTO competition_data.COMPETITION (ID, ORGANIZATION, NAME, VIDEOGAME, PLATFORM, REGION, GAMEMODE, ENABLED) VALUES
   (v_id, p_organization, p_name, p_videogame, p_platform, p_region, p_gamemode, 'false');

   RETURN v_id;

   EXCEPTION
   WHEN OTHERS THEN
   PERFORM setval('competition_data.COMPETITION_SEQ', currval('competition_data.COMPETITION_SEQ') - 1);
   RETURN -1;
END;
$BODY$;
