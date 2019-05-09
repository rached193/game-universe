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

/*Get Competition Filters*/
CREATE OR REPLACE FUNCTION competition_data.get_competition_filters(
  p_videogame integer)
    RETURNS jsonb
    LANGUAGE 'plpgsql'

AS $BODY$
declare
	v_result jsonb;
BEGIN
  SELECT jsonb_build_object(
	  'platforms', competition_data.get_platforms(p_videogame),
	  'regions', competition_data.get_regions(p_videogame),
	  'gamemodes', competition_data.get_gamemodes(p_videogame)
  ) into v_result;

  RETURN v_result;
END;
$BODY$;

/*Get Organizations*/
CREATE OR REPLACE FUNCTION competition_data.get_organizations(
  p_account integer)
    RETURNS jsonb
    LANGUAGE 'plpgsql'

AS $BODY$
declare
	v_result jsonb;
BEGIN
  SELECT jsonb_agg(jsonb_build_object(
    'id', o.id,
    'name', o.name
  )) into v_result
  FROM user_data.organization o
  WHERE o.enabled
  AND o.id IN(
	  SELECT a.organization
	  FROM user_data.administration a
	  WHERE a.account = p_account
    AND a.enabled);

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
   RETURN -1;
END;
$BODY$;

/*Enable Competition*/
CREATE OR REPLACE FUNCTION competition_data.enable_competition(
	p_id integer,
	p_enabled boolean)
    RETURNS integer
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE
AS $BODY$
BEGIN
   UPDATE competition_data.competition
   SET ENABLED = p_enabled
   WHERE ID = p_id;

   RETURN 0;

   EXCEPTION
   WHEN OTHERS THEN
   RETURN -1;
END;
$BODY$;

/*Get Competition*/
CREATE OR REPLACE FUNCTION competition_data.get_competition(
  p_id integer)
    RETURNS jsonb
    LANGUAGE 'plpgsql'

AS $BODY$
declare
	v_result jsonb;
BEGIN
  SELECT jsonb_build_object(
    'id', c.id,
    'organization', o.name,
    'name', c.name,
    'videogame', v.name,
    'platform', p.name,
    'region', r.name,
    'gamemode', g.name,
    'enabled', c.enabled
  ) into v_result
  FROM competition_data.competition c
  JOIN user_data.organization o ON c.organization = o.id
  JOIN master_data.videogame v ON c.videogame = v.id
  JOIN master_data.platform p ON c.platform = p.id
  JOIN master_data.region r ON c.region = r.id
  JOIN master_data.gamemode g ON c.gamemode = g.id
  WHERE c.id = p_id;

  RETURN v_result;
END;
$BODY$;

/*Get Competitions*/
CREATE OR REPLACE FUNCTION competition_data.get_competitions(
  p_organization integer)
    RETURNS jsonb
    LANGUAGE 'plpgsql'

AS $BODY$
declare
	v_result jsonb;
BEGIN
  SELECT jsonb_agg(jsonb_build_object(
    'id', c.id,
    'name', c.name
  )) into v_result
  FROM competition_data.competition c
  WHERE c.organization = p_organization;

   RETURN v_result;
END;
$BODY$;

/*Get Formats*/
CREATE OR REPLACE FUNCTION competition_data.get_formats()
    RETURNS jsonb
    LANGUAGE 'plpgsql'

AS $BODY$
declare
	v_result jsonb;
BEGIN
   SELECT jsonb_agg(jsonb_build_object(
		'id', f.id,
		'name', f.name
	)) into v_result
	FROM master_data.format f
  WHERE f.enabled;

   RETURN v_result;
END;
$BODY$;

/*Get Bos*/
CREATE OR REPLACE FUNCTION competition_data.get_bos()
    RETURNS jsonb
    LANGUAGE 'plpgsql'

AS $BODY$
declare
	v_result jsonb;
BEGIN
   SELECT jsonb_agg(jsonb_build_object(
		'id', b.id,
		'name', b.name
	)) into v_result
	FROM master_data.bo b
  WHERE b.enabled;

   RETURN v_result;
END;
$BODY$;

/*Next Phase*/
CREATE OR REPLACE FUNCTION competition_data.get_next_phase(
	p_competition integer)
    RETURNS integer
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE
AS $BODY$
declare
	v_phase integer;
BEGIN
    SELECT coalesce(max(phase),0)+1 into v_phase
    FROM competition_data.phase p
    WHERE p.competition = p_competition;

    RETURN v_phase;
END;
$BODY$;

/*Create Phase*/
CREATE OR REPLACE FUNCTION competition_data.create_phase(
	p_competition integer,
	p_format integer,
	p_bo integer,
	p_groups integer,
	p_participants integer)
    RETURNS integer
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE
AS $BODY$
declare
	v_id integer;
BEGIN
   SELECT nextval('competition_data.PHASE_SEQ') into v_id;

   INSERT INTO competition_data.PHASE (ID, COMPETITION, PHASE, FORMAT, BO, GROUPS, PARTICIPANTS, ENABLED) VALUES
   (v_id, p_competition, competition_data.get_next_phase(p_competition), p_format, p_bo, p_groups, p_participants, 'false');

   RETURN v_id;

   EXCEPTION
   WHEN OTHERS THEN
   RETURN -1;
END;
$BODY$;

/*Enable Phase*/
CREATE OR REPLACE FUNCTION competition_data.enable_phase(
	p_id integer,
	p_enabled boolean)
    RETURNS integer
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE
AS $BODY$
BEGIN
   UPDATE competition_data.phase
   SET ENABLED = p_enabled
   WHERE ID = p_id;

   RETURN 0;

   EXCEPTION
   WHEN OTHERS THEN
   RETURN -1;
END;
$BODY$;

/*Get Phases*/
CREATE OR REPLACE FUNCTION competition_data.get_phases(
  p_competition integer)
    RETURNS jsonb
    LANGUAGE 'plpgsql'

AS $BODY$
declare
	v_result jsonb;
BEGIN
  SELECT jsonb_agg(jsonb_build_object(
    'id', p.id,
    'phase', p.phase
  )) into v_result
  FROM competition_data.phase p
  WHERE p.competition = p_competition;

   RETURN v_result;
END;
$BODY$;

/*Get Phase*/
CREATE OR REPLACE FUNCTION competition_data.get_phase(
  p_id integer)
    RETURNS jsonb
    LANGUAGE 'plpgsql'

AS $BODY$
declare
	v_result jsonb;
BEGIN
  SELECT jsonb_build_object(
    'id', c.id,
    'competition', c.name,
    'phase', p.phase,
    'format', f.name,
    'bo', b.name,
    'groups', p.groups,
    'participants', p.participants,
    'enabled', p.enabled
  ) into v_result
  FROM competition_data.phase p
  JOIN competition_data.competition c ON p.competition = c.id
  JOIN master_data.format f ON p.format = f.id
  JOIN master_data.bo b ON p.bo = b.id
  WHERE p.id = p_id;

  RETURN v_result;
END;
$BODY$;

/*Get Participants*/
CREATE OR REPLACE FUNCTION competition_data.get_participants(
  p_phase integer)
    RETURNS jsonb
    LANGUAGE 'plpgsql'

AS $BODY$
declare
	v_result jsonb;
BEGIN
  SELECT jsonb_agg(jsonb_build_object(
    'id', p.id,
    'account', jsonb_build_object(
      'id', a.id,
      'name', a.name),
    'group', p.ngroup,
    'confirmed', p.confirmed
  )) into v_result
  FROM competition_data.participant p
  JOIN user_data.account a ON p.account = a.id
  WHERE p.phase = p_phase;

   RETURN v_result;
END;
$BODY$;

/*Create Participant*/
CREATE OR REPLACE FUNCTION competition_data.create_participant(
	p_phase integer,
	p_account integer)
    RETURNS integer
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE
AS $BODY$
declare
	v_id integer;
BEGIN
   SELECT nextval('competition_data.PARTICIPANT_SEQ') into v_id;

   INSERT INTO competition_data.PARTICIPANT (ID, PHASE, ACCOUNT) VALUES
   (v_id, p_phase, p_account);

   RETURN v_id;

   EXCEPTION
   WHEN OTHERS THEN
   RETURN -1;
END;
$BODY$;

/*Confirm Participant*/
CREATE OR REPLACE FUNCTION competition_data.confirm_participant(
	p_id integer,
	p_confirmed boolean)
    RETURNS integer
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE
AS $BODY$
BEGIN
  IF p_confirmed THEN
    UPDATE competition_data.participant
    SET CONFIRMED = p_confirmed
    WHERE ID = p_id;
  ELSE
    DELETE FROM competition_data.participant
    WHERE ID = p_id;
  END IF;

   RETURN 0;

   EXCEPTION
   WHEN OTHERS THEN
   RETURN -1;
END;
$BODY$;

/*Set Groups*/
CREATE OR REPLACE FUNCTION competition_data.set_groups(
	p_phase integer)
    RETURNS integer
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE
AS $BODY$
declare
  v_groups integer;
  v_participants integer;
  v_total integer;
  v_group integer[];
  v_participant integer[];
  v_aux integer;
BEGIN
  SELECT groups, participants into v_groups, v_participants
  FROM competition_data.phase p
  WHERE p.id = p_phase;

  IF v_groups = 1 THEN
    UPDATE competition_data.participant
    SET ngroup = 1
    WHERE phase = p_phase;
  ELSE
    v_total = v_groups*v_participants;

    SELECT array_agg(p.id) into v_participant
    FROM competition_data.participant p
    WHERE p.phase = p_phase;

    FOR g IN 1..v_groups LOOP
      FOR p IN 1..v_participants LOOP
        SELECT array_append(v_group, g) into v_group;
      END LOOP;
    END LOOP;

    FOR a IN 1..(v_total) LOOP
      SELECT v_participant[(random()*(v_total-a))::int+1] into v_aux;

      UPDATE competition_data.participant
      SET ngroup = v_group[a]
      WHERE id = v_aux;

      SELECT array_remove(v_participant, v_aux) into v_participant;
    END LOOP;
  END IF;

  RETURN 0;

   EXCEPTION
   WHEN OTHERS THEN
   RETURN -1;
END;
$BODY$;
