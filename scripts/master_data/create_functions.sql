/*Create Videogame*/
CREATE OR REPLACE FUNCTION master_data.create_videogame(
	p_name text)
    RETURNS integer
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE
AS $BODY$
declare
	v_id integer;
BEGIN
   SELECT nextval('master_data.VIDEOGAME_SEQ') into v_id;

   INSERT INTO master_data.VIDEOGAME (ID, NAME, ENABLED) VALUES
   (v_id, p_name, 'false');

   RETURN v_id;

   EXCEPTION
   WHEN OTHERS THEN
   RETURN -1;
END;
$BODY$;

/*Enable Videogame*/
CREATE OR REPLACE FUNCTION master_data.enable_videogame(
	p_id integer,
	p_enabled boolean)
    RETURNS integer
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE
AS $BODY$
BEGIN
   UPDATE master_data.VIDEOGAME
   SET ENABLED = p_enabled
   WHERE ID = p_id;

   RETURN 0;

   EXCEPTION
   WHEN OTHERS THEN
   RETURN -1;
END;
$BODY$;

/*Edit Videogame*/
CREATE OR REPLACE FUNCTION master_data.edit_videogame(
	p_id integer,
	p_name text)
    RETURNS integer
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE
AS $BODY$
BEGIN
   UPDATE master_data.VIDEOGAME
   SET name = p_name
   WHERE ID = p_id;

   RETURN 0;

   EXCEPTION
   WHEN OTHERS THEN
   RETURN -1;
END;
$BODY$;

/*Get Videogames*/
CREATE OR REPLACE FUNCTION master_data.get_videogames()
    RETURNS jsonb
    LANGUAGE 'plpgsql'

AS $BODY$
declare
	v_result jsonb;
BEGIN
   SELECT jsonb_agg(jsonb_build_object(
		'id', v.id,
		'name', v.name,
		'enabled', v.enabled
	)) into v_result
	FROM master_data.videogame v;

   RETURN v_result;
END;
$BODY$;

/*Create Platform*/
CREATE OR REPLACE FUNCTION master_data.create_platform(
	p_name text)
    RETURNS integer
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE
AS $BODY$
declare
	v_id integer;
BEGIN
   SELECT nextval('master_data.PLATFORM_SEQ') into v_id;

   INSERT INTO master_data.PLATFORM (ID, NAME, ENABLED) VALUES
   (v_id, p_name, 'false');

   RETURN v_id;

   EXCEPTION
   WHEN OTHERS THEN
   RETURN -1;
END;
$BODY$;

/*Enable Platform*/
CREATE OR REPLACE FUNCTION master_data.enable_platform(
	p_id integer,
	p_enabled boolean)
    RETURNS integer
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE
AS $BODY$
BEGIN
   UPDATE master_data.PLATFORM
   SET ENABLED = p_enabled
   WHERE ID = p_id;

   RETURN 0;

   EXCEPTION
   WHEN OTHERS THEN
   RETURN -1;
END;
$BODY$;

/*Edit Platform*/
CREATE OR REPLACE FUNCTION master_data.edit_platform(
	p_id integer,
	p_name text)
    RETURNS integer
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE
AS $BODY$
BEGIN
   UPDATE master_data.PLATFORM
   SET name = p_name
   WHERE ID = p_id;

   RETURN 0;

   EXCEPTION
   WHEN OTHERS THEN
   RETURN -1;
END;
$BODY$;

/*Get Platforms*/
CREATE OR REPLACE FUNCTION master_data.get_platforms()
    RETURNS jsonb
    LANGUAGE 'plpgsql'

AS $BODY$
declare
	v_result jsonb;
BEGIN
   SELECT jsonb_agg(jsonb_build_object(
		'id', p.id,
		'name', p.name,
		'enabled', p.enabled
	)) into v_result
	FROM master_data.platform p;

   RETURN v_result;
END;
$BODY$;

/*Create Region*/
CREATE OR REPLACE FUNCTION master_data.create_region(
	p_videogame integer,
	p_name text)
    RETURNS integer
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE
AS $BODY$
declare
	v_id integer;
BEGIN
   SELECT nextval('master_data.REGION_SEQ') into v_id;

   INSERT INTO master_data.REGION (ID, VIDEOGAME, NAME, ENABLED) VALUES
   (v_id, p_videogame, p_name, 'false');

   RETURN v_id;

   EXCEPTION
   WHEN OTHERS THEN
   RETURN -1;
END;
$BODY$;

/*Enable Region*/
CREATE OR REPLACE FUNCTION master_data.enable_region(
	p_id integer,
	p_enabled boolean)
    RETURNS integer
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE
AS $BODY$
BEGIN
   UPDATE master_data.REGION
   SET ENABLED = p_enabled
   WHERE ID = p_id;

   RETURN 0;

   EXCEPTION
   WHEN OTHERS THEN
   RETURN -1;
END;
$BODY$;

/*Edit Region*/
CREATE OR REPLACE FUNCTION master_data.edit_region(
	p_id integer,
	p_name text)
    RETURNS integer
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE
AS $BODY$
BEGIN
   UPDATE master_data.REGION
   SET name = p_name
   WHERE ID = p_id;

   RETURN 0;

   EXCEPTION
   WHEN OTHERS THEN
   RETURN -1;
END;
$BODY$;

/*Get Regions*/
CREATE OR REPLACE FUNCTION master_data.get_regions()
    RETURNS jsonb
    LANGUAGE 'plpgsql'

AS $BODY$
declare
	v_result jsonb;
BEGIN
   SELECT jsonb_agg(jsonb_build_object(
		'id', r.id,
		'name', r.name,
		'videogame', jsonb_build_object(
			'id', v.id,
			'name', v.name),
		'enabled', r.enabled
	)) into v_result
	FROM master_data.region r
	JOIN master_data.videogame v ON r.videogame = v.id;

   RETURN v_result;
END;
$BODY$;

/*Create Game_Mode*/
CREATE OR REPLACE FUNCTION master_data.create_game_mode(
	p_videogame integer,
	p_name text)
    RETURNS integer
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE
AS $BODY$
declare
	v_id integer;
BEGIN
   SELECT nextval('master_data.GAME_MODE_SEQ') into v_id;

   INSERT INTO master_data.GAME_MODE (ID, VIDEOGAME, NAME, ENABLED) VALUES
   (v_id, p_videogame, p_name, 'false');

   RETURN v_id;

   EXCEPTION
   WHEN OTHERS THEN
   RETURN -1;
END;
$BODY$;

/*Enable Game Mode*/
CREATE OR REPLACE FUNCTION master_data.enable_game_mode(
	p_id integer,
	p_enabled boolean)
    RETURNS integer
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE
AS $BODY$
BEGIN
   UPDATE master_data.GAME_MODE
   SET ENABLED = p_enabled
   WHERE ID = p_id;

   RETURN 0;

   EXCEPTION
   WHEN OTHERS THEN
   RETURN -1;
END;
$BODY$;

/*Edit Game Mode*/
CREATE OR REPLACE FUNCTION master_data.edit_game_mode(
	p_id integer,
	p_name text)
    RETURNS integer
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE
AS $BODY$
BEGIN
   UPDATE master_data.GAME_MODE
   SET name = p_name
   WHERE ID = p_id;

   RETURN 0;

   EXCEPTION
   WHEN OTHERS THEN
   RETURN -1;
END;
$BODY$;

/*Get Game Modes*/
CREATE OR REPLACE FUNCTION master_data.get_game_modes()
    RETURNS jsonb
    LANGUAGE 'plpgsql'

AS $BODY$
declare
	v_result jsonb;
BEGIN
   SELECT jsonb_agg(jsonb_build_object(
		'id', g.id,
		'name', g.name,
		'videogame', jsonb_build_object(
			'id', v.id,
			'name', v.name),
		'enabled', g.enabled
	)) into v_result
	FROM master_data.game_mode g
	JOIN master_data.videogame v ON g.videogame = v.id;

   RETURN v_result;
END;
$BODY$;

/*Create Videogame-Platform*/
CREATE OR REPLACE FUNCTION master_data.create_videogame_platform(
	p_videogame integer,
	p_platform integer)
    RETURNS integer
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE
AS $BODY$
BEGIN
   INSERT INTO master_data.VIDEOGAME_PLATFORM (VIDEOGAME, PLATFORM, ENABLED) VALUES
   (p_videogame, p_platform, 'false');

   RETURN 0;

   EXCEPTION
   WHEN OTHERS THEN
   RETURN -1;
END;
$BODY$;

/*Enable Videogame-Platform*/
CREATE OR REPLACE FUNCTION master_data.enable_videogame_platform(
	p_videogame integer,
	p_platform integer,
	p_enabled boolean)
    RETURNS integer
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE
AS $BODY$
BEGIN
   UPDATE master_data.VIDEOGAME_PLATFORM
   SET ENABLED = p_enabled
   WHERE VIDEOGAME = p_videogame
   AND PLATFORM = p_platform;

   RETURN 0;

   EXCEPTION
   WHEN OTHERS THEN
   RETURN -1;
END;
$BODY$;

/*Get Videogames Platforms*/
CREATE OR REPLACE FUNCTION master_data.get_videogames_platforms()
    RETURNS jsonb
    LANGUAGE 'plpgsql'

AS $BODY$
declare
	v_result jsonb;
BEGIN
   SELECT jsonb_agg(jsonb_build_object(
		'videogame', jsonb_build_object(
			'id', vp.videogame,
			'name', v.name),
		'platform', jsonb_build_object(
			'id', vp.platform,
			'name', p.name),
		'enabled', vp.enabled
	)) into v_result
	FROM master_data.videogame_platform vp
	JOIN master_data.videogame v ON vp.videogame = v.id
	JOIN master_data.platform p ON vp.platform = p.id;

   RETURN v_result;
END;
$BODY$;

/*Create Format*/
CREATE OR REPLACE FUNCTION master_data.create_format(
	p_name text)
    RETURNS integer
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE
AS $BODY$
declare
	v_id integer;
BEGIN
   SELECT nextval('master_data.FORMAT_SEQ') into v_id;

   INSERT INTO master_data.FORMAT (ID, NAME, ENABLED) VALUES
   (v_id, p_name, 'false');

   RETURN v_id;

   EXCEPTION
   WHEN OTHERS THEN
   RETURN -1;
END;
$BODY$;

/*Enable Format*/
CREATE OR REPLACE FUNCTION master_data.enable_format(
	p_id integer,
	p_enabled boolean)
    RETURNS integer
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE
AS $BODY$
BEGIN
   UPDATE master_data.FORMAT
   SET ENABLED = p_enabled
   WHERE ID = p_id;

   RETURN 0;

   EXCEPTION
   WHEN OTHERS THEN
   RETURN -1;
END;
$BODY$;

/*Edit Format*/
CREATE OR REPLACE FUNCTION master_data.edit_format(
	p_id integer,
	p_name text)
    RETURNS integer
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE
AS $BODY$
BEGIN
   UPDATE master_data.FORMAT
   SET name = p_name
   WHERE ID = p_id;

   RETURN 0;

   EXCEPTION
   WHEN OTHERS THEN
   RETURN -1;
END;
$BODY$;

/*Get Formats*/
CREATE OR REPLACE FUNCTION master_data.get_formats()
    RETURNS jsonb
    LANGUAGE 'plpgsql'

AS $BODY$
declare
	v_result jsonb;
BEGIN
   SELECT jsonb_agg(jsonb_build_object(
		'id', f.id,
		'name', f.name,
		'enabled', f.enabled
	)) into v_result
	FROM master_data.format f;

   RETURN v_result;
END;
$BODY$;

/*Create Bo*/
CREATE OR REPLACE FUNCTION master_data.create_bo(
	p_name text,
	p_games integer)
    RETURNS integer
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE
AS $BODY$
declare
	v_id integer;
BEGIN
   SELECT nextval('master_data.BO_SEQ') into v_id;

   INSERT INTO master_data.BO (ID, NAME, GAMES, ENABLED) VALUES
   (v_id, p_name, p_games, 'false');

   RETURN v_id;

   EXCEPTION
   WHEN OTHERS THEN
   RETURN -1;
END;
$BODY$;

/*Enable Bo*/
CREATE OR REPLACE FUNCTION master_data.enable_bo(
	p_id integer,
	p_enabled boolean)
    RETURNS integer
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE
AS $BODY$
BEGIN
   UPDATE master_data.BO
   SET ENABLED = p_enabled
   WHERE ID = p_id;

   RETURN 0;

   EXCEPTION
   WHEN OTHERS THEN
   RETURN -1;
END;
$BODY$;

/*Edit Bo*/
CREATE OR REPLACE FUNCTION master_data.edit_bo(
	p_id integer,
	p_name text,
  p_games integer)
    RETURNS integer
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE
AS $BODY$
BEGIN
   UPDATE master_data.BO
   SET name = p_name, games = p_games
   WHERE ID = p_id;

   RETURN 0;

   EXCEPTION
   WHEN OTHERS THEN
   RETURN -1;
END;
$BODY$;

/*Get Bos*/
CREATE OR REPLACE FUNCTION master_data.get_bos()
    RETURNS jsonb
    LANGUAGE 'plpgsql'

AS $BODY$
declare
	v_result jsonb;
BEGIN
   SELECT jsonb_agg(jsonb_build_object(
		'id', b.id,
		'name', b.name,
		'games', b.games,
		'enabled', b.enabled
	)) into v_result
	FROM master_data.bo b;

   RETURN v_result;
END;
$BODY$;
