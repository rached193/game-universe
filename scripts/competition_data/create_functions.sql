/*Get Videogames*/
CREATE OR REPLACE FUNCTION competition_data.get_videogames()
    RETURNS jsonb
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
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

    COST 100
    VOLATILE 
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

    COST 100
    VOLATILE 
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
CREATE OR REPLACE FUNCTION competition_data.get_game_modes(
	p_videogame integer)
    RETURNS jsonb
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
declare
	v_result jsonb;
BEGIN
  SELECT jsonb_agg(jsonb_build_object(
		'id', g.id,
		'name', g.name
	)) into v_result
	FROM master_data.game_mode g
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

    COST 100
    VOLATILE 
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

    COST 100
    VOLATILE 
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
	p_game_mode integer,
	p_registration_date date,
	p_competition_date date,
	p_weak_cap integer,
	p_hard_cap integer)
    RETURNS integer
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
declare
	v_id integer;
  v_log text;
BEGIN
  select nextval('competition_data.competition_seq') into v_id;

  insert into competition_data.competition (id, organization, name, videogame, platform, region, game_mode, registration_date, competition_date, weak_cap, hard_cap, step) VALUES
    (v_id, p_organization, p_name, p_videogame, p_platform, p_region, p_game_mode, p_registration_date, p_competition_date, p_weak_cap, p_hard_cap, 1);

  RETURN v_id;

  EXCEPTION
  WHEN OTHERS THEN
    v_log = 'Error on function create_competition: '||SQLERRM;
    PERFORM log_data.create_log('E', v_log);
    RETURN -1;
  END;
$BODY$;

/*Edit Competition*/
CREATE OR REPLACE FUNCTION competition_data.edit_competition(
	p_id integer,
	p_name text,
	p_videogame integer,
	p_platform integer,
	p_region integer,
	p_game_mode integer,
	p_registration_date date,
	p_competition_date date,
	p_weak_cap integer,
	p_hard_cap integer)
    RETURNS integer
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
BEGIN
  update competition_data.competition set
    name = p_name,
    videogame = p_videogame,
    platform = p_platform,
    region = p_region,
    game_mode = p_game_mode,
    registration_date = p_registration_date,
    competition_date = p_competition_date,
    weak_cap = p_weak_cap,
    hard_cap = p_hard_cap
  where id = p_id;

  return 0;

  EXCEPTION
  when others THEN
    return -1;
  end;
$BODY$;

/*Edit Competition Step*/
CREATE OR REPLACE FUNCTION competition_data.update_competition_step(
	p_id integer,
	p_step integer)
    RETURNS integer
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
BEGIN
  update competition_data.competition set
    step = p_step
  where id = p_id;

  return 0;

  EXCEPTION
  when others THEN
    return -1;
  end;
$BODY$;

/*Create Registration*/
CREATE OR REPLACE FUNCTION competition_data.create_registration(
	p_competition integer,
	p_name text,
	p_account integer)
    RETURNS integer
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
declare
	v_id integer;
BEGIN
  select nextval('competition_data.registration_seq') into v_id;

  insert into competition_data.registration (id, competition, name, account, step) VALUES
    (v_id, p_competition, p_name, p_account, 1);

  RETURN v_id;

  EXCEPTION
  WHEN OTHERS THEN
    RETURN -1;
  END;
$BODY$;

/*Edit Registration*/
CREATE OR REPLACE FUNCTION competition_data.edit_registration(
	p_id integer,
	p_name text,
	p_account integer)
    RETURNS integer
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
BEGIN
  update competition_data.registration set
    name = p_name,
    account = p_account
  where id = p_id;

  return 0;

  EXCEPTION
  when others THEN
    return -1;
  end;
$BODY$;

/*Update Registration Step*/
CREATE OR REPLACE FUNCTION competition_data.update_registration_step(
	p_id integer,
	p_step integer)
    RETURNS integer
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
BEGIN
  update competition_data.registration set
    step = p_step
  where id = p_id;

  return 0;

  EXCEPTION
  when others THEN
    return -1;
  end;
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
		'name', b.name,
	    'games', b.games
	)) into v_result
	FROM master_data.bo b
  WHERE b.enabled;

   RETURN v_result;
END;
$BODY$;

/*Create Phase*/
CREATE OR REPLACE FUNCTION competition_data.create_phase(
	p_competition integer,
	p_phase integer,
	p_format integer,
	p_bo integer,
	p_phase_date date)
    RETURNS integer
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
declare
	v_id integer;
BEGIN
  select nextval('competition_data.phase_seq') into v_id;

  insert into competition_data.phase (id, competition, phase, format, bo, phase_date, step) VALUES
    (v_id, p_competition, p_phase, p_format, p_bo, p_phase_date, 1);

  RETURN v_id;

  EXCEPTION
  WHEN OTHERS THEN
    RETURN -1;
  END;
$BODY$;

/*Edit Phase*/
CREATE OR REPLACE FUNCTION competition_data.edit_phase(
	p_id integer,
	p_format integer,
	p_bo integer,
	p_phase_date date)
    RETURNS integer
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
BEGIN
  update competition_data.phase set
    format = p_format,
    bo = p_bo,
    phase_date = p_phase_date
  where id = p_id;

  return 0;

  EXCEPTION
  when others THEN
    return -1;
  end;
$BODY$;

/*Update Phase Step*/
CREATE OR REPLACE FUNCTION competition_data.update_phase_step(
	p_id integer,
	p_step integer)
    RETURNS integer
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
BEGIN
  update competition_data.phase set
    step = p_step
  where id = p_id;

  return 0;

  EXCEPTION
  when others THEN
    return -1;
  end;
$BODY$;

/*Create Competitor*/
CREATE OR REPLACE FUNCTION competition_data.create_competitor(
	p_phase integer,
	p_competitor integer,
	p_registration integer)
    RETURNS integer
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
declare
	v_id integer;
BEGIN
  select nextval('competition_data.competitor_seq') into v_id;

  insert into competition_data.competitor (id, phase, competitor, registration, step) VALUES
    (v_id, p_phase, p_competitor, p_registration, 1);

  RETURN v_id;

  EXCEPTION
  WHEN OTHERS THEN
    RETURN -1;
  END;
$BODY$;

/*Edit Competitor*/
CREATE OR REPLACE FUNCTION competition_data.edit_competitor(
	p_id integer,
	p_registration integer)
    RETURNS integer
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
BEGIN
  update competition_data.competitor set
    registration = p_registration
  where id = p_id;

  return 0;

  EXCEPTION
  when others THEN
    return -1;
  end;
$BODY$;

/*Update Competitor Step*/
CREATE OR REPLACE FUNCTION competition_data.update_competitor_step(
	p_id integer,
	p_step integer)
    RETURNS integer
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
BEGIN
  update competition_data.competitor set
    step = p_step
  where id = p_id;

  return 0;

  EXCEPTION
  when others THEN
    return -1;
  end;
$BODY$;

/*Create Bracket*/
CREATE OR REPLACE FUNCTION competition_data.create_bracket(
	p_phase integer,
	p_bracket integer)
    RETURNS integer
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
declare
	v_id integer;
BEGIN
  select nextval('competition_data.bracket_seq') into v_id;

  insert into competition_data.bracket (id, phase, bracket, step) VALUES
    (v_id, p_phase, p_bracket, 1);

  RETURN v_id;

  EXCEPTION
  WHEN OTHERS THEN
    RETURN -1;
  END;
$BODY$;

/*Update Bracket Step*/
CREATE OR REPLACE FUNCTION competition_data.update_bracket_step(
	p_id integer,
	p_step integer)
    RETURNS integer
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
BEGIN
  update competition_data.bracket set
    step = p_step
  where id = p_id;

  return 0;

  EXCEPTION
  when others THEN
    return -1;
  end;
$BODY$;

/*Create Slot*/
CREATE OR REPLACE FUNCTION competition_data.create_slot(
	p_bracket integer,
	p_slot integer,
	p_competitor integer)
    RETURNS integer
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
declare
	v_id integer;
BEGIN
  select nextval('competition_data.slot_seq') into v_id;

  insert into competition_data.slot (id, bracket, slot, competitor, step) VALUES
    (v_id, p_bracket, p_slot, p_competitor, 1);

  RETURN v_id;

  EXCEPTION
  WHEN OTHERS THEN
    RETURN -1;
  END;
$BODY$;

/*Edit Slot*/
CREATE OR REPLACE FUNCTION competition_data.edit_slot(
	p_id integer,
	p_competitor integer)
    RETURNS integer
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
BEGIN
  update competition_data.slot set
    competitor = p_competitor
  where id = p_id;

  return 0;

  EXCEPTION
  when others THEN
    return -1;
  end;
$BODY$;

/*Update Slot Step*/
CREATE OR REPLACE FUNCTION competition_data.update_slot_step(
	p_id integer,
	p_step integer)
    RETURNS integer
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
BEGIN
  update competition_data.slot set
    step = p_step
  where id = p_id;

  return 0;

  EXCEPTION
  when others THEN
    return -1;
  end;
$BODY$;

/*Create Round*/
CREATE OR REPLACE FUNCTION competition_data.create_round(
	p_bracket integer,
	p_round integer,
	p_round_date date)
    RETURNS integer
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
declare
	v_id integer;
BEGIN
  select nextval('competition_data.round_seq') into v_id;

  insert into competition_data.round (id, bracket, round, round_date, step) VALUES
    (v_id, p_bracket, p_round, p_round_date, 1);

  RETURN v_id;

  EXCEPTION
  WHEN OTHERS THEN
    RETURN -1;
  END;
$BODY$;

/*Edit Round*/
CREATE OR REPLACE FUNCTION competition_data.edit_round(
	p_id integer,
	p_round_date date)
    RETURNS integer
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
BEGIN
  update competition_data.round set
    round_date = p_round_date
  where id = p_id;

  return 0;

  EXCEPTION
  when others THEN
    return -1;
  end;
$BODY$;

/*Update Round Step*/
CREATE OR REPLACE FUNCTION competition_data.update_round_step(
	p_id integer,
	p_step integer)
    RETURNS integer
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
BEGIN
  update competition_data.round set
    step = p_step
  where id = p_id;

  return 0;

  EXCEPTION
  when others THEN
    return -1;
  end;
$BODY$;

/*Create Match*/
CREATE OR REPLACE FUNCTION competition_data.create_match(
	p_round integer,
	p_match integer,
	p_match_date date)
    RETURNS integer
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
declare
	v_id integer;
BEGIN
  select nextval('competition_data.match_seq') into v_id;

  insert into competition_data.match (id, round, match, match_date, step) VALUES
    (v_id, p_round, p_match, p_match_date, 1);

  RETURN v_id;

  EXCEPTION
  WHEN OTHERS THEN
    RETURN -1;
  END;
$BODY$;

/*Edit Match*/
CREATE OR REPLACE FUNCTION competition_data.edit_match(
	p_id integer,
	p_match_date date)
    RETURNS integer
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
BEGIN
  update competition_data.match set
    match_date = p_match_date
  where id = p_id;

  return 0;

  EXCEPTION
  when others THEN
    return -1;
  end;
$BODY$;

/*Update Match Step*/
CREATE OR REPLACE FUNCTION competition_data.update_match_step(
	p_id integer,
	p_step integer)
    RETURNS integer
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
BEGIN
  update competition_data.match set
    step = p_step
  where id = p_id;

  return 0;

  EXCEPTION
  when others THEN
    return -1;
  end;
$BODY$;

/*Create Rival*/
CREATE OR REPLACE FUNCTION competition_data.create_rival(
	p_match integer,
	p_rival integer,
	p_slot integer)
    RETURNS integer
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
declare
	v_id integer;
BEGIN
  select nextval('competition_data.rival_seq') into v_id;

  insert into competition_data.rival (id, match, rival, slot, step) VALUES
    (v_id, p_match, p_rival, p_slot, 1);

  RETURN v_id;

  EXCEPTION
  WHEN OTHERS THEN
    RETURN -1;
  END;
$BODY$;

/*Edit Rival*/
CREATE OR REPLACE FUNCTION competition_data.edit_rival(
	p_id integer,
	p_slot integer)
    RETURNS integer
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
BEGIN
  update competition_data.rival set
    slot = p_slot
  where id = p_id;

  return 0;

  EXCEPTION
  when others THEN
    return -1;
  end;
$BODY$;

/*Update Rival Step*/
CREATE OR REPLACE FUNCTION competition_data.update_rival_step(
	p_id integer,
	p_step integer)
    RETURNS integer
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
BEGIN
  update competition_data.rival set
    step = p_step
  where id = p_id;

  return 0;

  EXCEPTION
  when others THEN
    return -1;
  end;
$BODY$;

/*Create Game*/
CREATE OR REPLACE FUNCTION competition_data.create_game(
	p_match integer,
	p_game integer,
	p_game_date date)
    RETURNS integer
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
declare
	v_id integer;
BEGIN
  select nextval('competition_data.game_seq') into v_id;

  insert into competition_data.game (id, match, game, game_date, step) VALUES
    (v_id, p_match, p_game, p_game_date, 1);

  RETURN v_id;

  EXCEPTION
  WHEN OTHERS THEN
    RETURN -1;
  END;
$BODY$;

/*Edit Game*/
CREATE OR REPLACE FUNCTION competition_data.edit_game(
	p_id integer,
	p_game_date date)
    RETURNS integer
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
BEGIN
  update competition_data.game set
    game_date = p_game_date
  where id = p_id;

  return 0;

  EXCEPTION
  when others THEN
    return -1;
  end;
$BODY$;

/*Update Game Step*/
CREATE OR REPLACE FUNCTION competition_data.update_game_step(
	p_id integer,
	p_step integer)
    RETURNS integer
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
BEGIN
  update competition_data.game set
    step = p_step
  where id = p_id;

  return 0;

  EXCEPTION
  when others THEN
    return -1;
  end;
$BODY$;

/*Edit Winner*/
CREATE OR REPLACE FUNCTION competition_data.edit_winner(
	p_id integer,
	p_winner integer)
    RETURNS integer
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
BEGIN
  update competition_data.game set
    winner = p_winner
  where id = p_id;

  return 0;

  EXCEPTION
  when others THEN
    return -1;
  end;
$BODY$;