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

/*Get Game Modes*/
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
	  'gamemodes', competition_data.get_game_modes(p_videogame)
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

/*Get Competitions*/
CREATE OR REPLACE FUNCTION competition_data.get_competitions(
	p_organization integer)
    RETURNS jsonb
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
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
END;
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
END;
$BODY$;

/*Get Registrations*/
CREATE OR REPLACE FUNCTION competition_data.get_registrations(
	p_competition integer)
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
		'name', r.name,
		'account', jsonb_build_object(
			'id', a.id,
			'name', a.name
		),
		'step', r.step
	)) into v_result
	FROM competition_data.registration r
	LEFT JOIN user_data.account a
	ON r.account = a.id
	WHERE r.competition = p_competition;
	
	RETURN v_result;
END;
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
END;
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
		'name', b.name,
	    'games', b.games
	)) into v_result
	FROM master_data.bo b
  WHERE b.enabled;

   RETURN v_result;
END;
$BODY$;

/*Get Phases*/
CREATE OR REPLACE FUNCTION competition_data.get_phases(
	p_competition integer)
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
		'phase', p.phase
	)) into v_result
	FROM competition_data.phase p
	WHERE p.competition = p_competition;

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
END;
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
END;
$BODY$;

/*Set Competitors*/
CREATE OR REPLACE FUNCTION competition_data.set_competitors(
	p_phase integer,
	p_competitors integer)
	RETURNS integer
	LANGUAGE 'plpgsql'
	
	COST 100
	VOLATILE
AS $BODY$
DECLARE v_result integer;
BEGIN
	FOR icompetitor IN 1..p_competitors LOOP
		v_result = competition_data.create_competitor(p_phase, icompetitor, null);
	END LOOP;
	
	return 0;

  EXCEPTION
  when others THEN
    return -1;
END;
$BODY$;

/*Get Competitors*/
CREATE OR REPLACE FUNCTION competition_data.get_competitors(
	p_phase integer)
	RETURNS jsonb
	LANGUAGE 'plpgsql'
	
	COST 100
	VOLATILE
AS $BODY$
declare
	v_result jsonb;
BEGIN
	SELECT jsonb_agg(jsonb_build_object(
		'id', c.id,
		'competitor', c.competitor,
		'registration', jsonb_build_object(
			'id', r.id,
			'name', r.name
		),
		'step', c.step
	)) into v_result
	FROM competition_data.competitor c
	LEFT JOIN competition_data.registration r
	ON c.registration = r.id
	WHERE c.phase = p_phase;
	
	RETURN v_result;
END;
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

/*Set Brackets*/
CREATE OR REPLACE FUNCTION competition_data.set_brackets(
	p_phase integer,
	p_brackets integer)
	RETURNS integer
	LANGUAGE 'plpgsql'
	
	COST 100
	VOLATILE
AS $BODY$
DECLARE v_result integer;
BEGIN
	FOR ibracket IN 1..p_brackets LOOP
		v_result = competition_data.create_bracket(p_phase, ibracket);
	END LOOP;
	
	return 0;

  EXCEPTION
  when others THEN
    return -1;
END;
$BODY$;

/*Get Brackets*/
CREATE OR REPLACE FUNCTION competition_data.get_brackets(
	p_phase integer)
    RETURNS jsonb
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
declare
	v_result jsonb;
BEGIN
	SELECT jsonb_agg(jsonb_build_object(
		'id', b.id,
		'bracket', b.bracket
	)) into v_result
	FROM competition_data.bracket b
	WHERE b.phase = p_phase;

	RETURN v_result;
END;
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

/*Set Slots*/
CREATE OR REPLACE FUNCTION competition_data.set_slots(
	p_bracket integer,
	p_slots integer)
	RETURNS integer
	LANGUAGE 'plpgsql'
	
	COST 100
	VOLATILE
AS $BODY$
DECLARE v_result integer;
BEGIN
	FOR islot IN 1..p_slots LOOP
		v_result = competition_data.create_slot(p_bracket, islot, null);
	END LOOP;
	
	return 0;

  EXCEPTION
  when others THEN
    return -1;
END;
$BODY$;

/*Get Slots*/
CREATE OR REPLACE FUNCTION competition_data.get_slots(
	p_bracket integer)
	RETURNS jsonb
	LANGUAGE 'plpgsql'
	
	COST 100
	VOLATILE
AS $BODY$
declare
	v_result jsonb;
BEGIN
	SELECT jsonb_agg(jsonb_build_object(
		'id', s.id,
		'slot', s.slot,
		'competitor', jsonb_build_object(
			'id', c.id,
			'competitor', c.competitor
		),
		'step', s.step
	)) into v_result
	FROM competition_data.slot s
	LEFT JOIN competition_data.competitor c
	ON s.competitor = c.id
	WHERE s.bracket = p_bracket;
	
	RETURN v_result;
END;
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

/*Set Rounds*/
CREATE OR REPLACE FUNCTION competition_data.set_rounds(
	p_bracket integer,
	p_rounds integer)
	RETURNS integer
	LANGUAGE 'plpgsql'
	
	COST 100
	VOLATILE
AS $BODY$
declare
	v_format integer;
	v_date date;
	v_slots integer;
	v_rounds integer;
	v_result integer;
BEGIN
	SELECT p.format, p.phase_date into v_format, v_date
	FROM competition_data.phase p
	JOIN competition_data.bracket b
	ON p.id = b.phase
	WHERE b.id = p_bracket;
	
	SELECT count(1) into v_slots
	FROM competition_data.slot s
	WHERE s.bracket = p_bracket;
	
	CASE v_format
		WHEN 1 THEN v_rounds = (v_slots+v_slots%2-1)*p_rounds;
		WHEN 2, 3 THEN v_rounds = ceiling(log(2, v_slots));
		ELSE v_rounds = 0;
	END CASE;
	
	FOR iround IN 1..v_rounds LOOP
		v_result = competition_data.create_round(p_bracket, iround, v_date);
	END LOOP;
	
	RETURN 0;
	
	EXCEPTION
  	when others THEN
    	return -1;
END;
$BODY$;

/*Get Rounds*/
CREATE OR REPLACE FUNCTION competition_data.get_rounds(
	p_bracket integer)
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
		'round', r.round
	)) into v_result
	FROM competition_data.round r
	WHERE r.bracket = p_bracket;

	RETURN v_result;
END;
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

/*Set Matches*/
CREATE OR REPLACE FUNCTION competition_data.set_matches(
	p_round integer)
	RETURNS integer
	LANGUAGE 'plpgsql'
	
	COST 100
	VOLATILE
AS $BODY$
declare
	v_format integer;
	v_slots integer;
	v_round integer;
	v_date date;
	v_matches integer;
	v_result integer;
BEGIN
	SELECT p.format, r.round, r.round_date into v_format, v_round, v_date
	FROM competition_data.phase p
	JOIN competition_data.bracket b
	ON p.id = b.phase
	JOIN competition_data.round r
	ON b.id = r.bracket
	WHERE r.id = p_round;
	
	SELECT count(1) into v_slots
	FROM competition_data.slot s
	JOIN competition_data.bracket b
	ON s.bracket = b.id
	JOIN competition_data.round r
	ON b.id = r.bracket
	WHERE r.id = p_round;
	
	CASE v_format
		WHEN 1, 2 THEN v_matches = v_slots/2;
		WHEN 3 THEN v_matches = (power(2,ceiling(log(2, v_slots))::integer)/(2^v_round))-(CASE WHEN v_round = 1 THEN (power(2,ceiling(log(2, v_slots))::integer)-v_slots) ELSE 0 END);
		ELSE v_matches = 0;
	END CASE;
	
	FOR imatch IN 1..v_matches LOOP
		v_result = competition_data.create_match(p_round, imatch, v_date);
	END LOOP;
	
	RETURN 0;
	
	EXCEPTION
  	when others THEN
    	return -1;
END;
$BODY$;

/*Get Matches*/
CREATE OR REPLACE FUNCTION competition_data.get_matches(
	p_round integer)
    RETURNS jsonb
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
declare
	v_result jsonb;
BEGIN
	SELECT jsonb_agg(jsonb_build_object(
		'id', m.id,
		'match', m.match
	)) into v_result
	FROM competition_data.match m
	WHERE m.round = p_round;

	RETURN v_result;
END;
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

/*Set Rivals*/
CREATE OR REPLACE FUNCTION competition_data.set_rivals(
	p_match integer)
	RETURNS integer
	LANGUAGE 'plpgsql'
	
	COST 100
	VOLATILE
AS $BODY$
DECLARE v_result integer;
BEGIN
	FOR irival IN 1..2 LOOP
		v_result = competition_data.create_rival(p_match, irival, null);
	END LOOP;
	
	return 0;

  EXCEPTION
  when others THEN
    return -1;
END;
$BODY$;

/*Get Rivals*/
CREATE OR REPLACE FUNCTION competition_data.get_rivals(
	p_match integer)
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
		'rival', r.rival,
		'slot', jsonb_build_object(
			'id', s.id,
			'slot', s.slot
		),
		'step', r.step
	)) into v_result
	FROM competition_data.rival r
	LEFT JOIN competition_data.slot s
	ON r.slot = s.id
	WHERE r.match = p_match;
	
	RETURN v_result;
END;
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

/*Set Games*/
CREATE OR REPLACE FUNCTION competition_data.set_games(
	p_match integer)
	RETURNS integer
	LANGUAGE 'plpgsql'
	
	COST 100
	VOLATILE
AS $BODY$
DECLARE
	v_games integer;
	v_date date;
	v_result integer;
BEGIN
	SELECT bo.games, m.match_date into v_games, v_date
	FROM master_data.bo bo
	JOIN competition_data.phase p
	ON bo.id = p.bo
	JOIN competition_data.bracket b
	ON p.id = b.phase
	JOIN competition_data.round r
	ON b.id = r.bracket
	JOIN competition_data.match m
	ON r.id = m.round
	WHERE m.id = p_match;
	
	FOR igame IN 1..v_games LOOP
		v_result = competition_data.create_game(p_match, igame, v_date);
	END LOOP;
	
	return 0;

  EXCEPTION
  when others THEN
    return -1;
END;
$BODY$;

/*Get Games*/
CREATE OR REPLACE FUNCTION competition_data.get_games(
	p_match integer)
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
		'game', g.game
	)) into v_result
	FROM competition_data.game g
	WHERE g.match = p_match;

	RETURN v_result;
END;
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

/*Set League Matches*/
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

/*Assign Slots*/
CREATE OR REPLACE FUNCTION competition_data.assign_slots(
  p_phase integer)
    RETURNS integer
    LANGUAGE 'plpgsql'
    
    COST 100
    VOLATILE
AS $BODY$
DECLARE
  v_competitors integer;
  v_competitor integer[];
  v_slot integer[];
  v_aux integer;

  v_result integer;
BEGIN
  SELECT count(1) into v_competitors
  FROM competition_data.competitor c
  WHERE c.phase = p_phase;
  raise notice 'Competitors: %', v_competitors;

  SELECT array_agg(c.id) into v_competitor
  FROM competition_data.competitor c
  WHERE c.phase = p_phase;
  raise notice 'Competitors Array: %', v_competitor;

  SELECT array_agg(s.id) into v_slot
  FROM competition_data.slot s
  JOIN competition_data.bracket b
  ON s.bracket = b.id
  WHERE b.phase = p_phase;
  raise notice 'Slots Array: %', v_slot;

  FOR icompetitor IN 1..v_competitors LOOP
    v_aux = floor(random()* ((v_competitors-(icompetitor-1))-(1) + 1) + (1));
    raise notice 'Aux: %', v_aux;
    v_result = competition_data.edit_slot(v_slot[v_aux], v_competitor[icompetitor]);
    raise notice 'Competitor: %, Slot: %', v_competitor[icompetitor], v_slot[v_aux];
    v_slot = array_remove(v_slot, v_slot[v_aux]);
  END LOOP;

  return 0;

  EXCEPTION
  when others THEN
    return -1;
END;
$BODY$

/*Set League Pairings*/
CREATE OR REPLACE FUNCTION competition_data.set_league_pairings(
  p_bracket integer)
    RETURNS integer
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE
AS $BODY$
DECLARE
	v_rounds integer;
  v_reps integer;
  v_slots integer;
  v_slot integer[];
  v_matches integer;
  v_rival integer[];
  v_order integer[];
  v_order_inverso integer[];
  v_aux1 integer[];
  v_aux2 integer[];
  v_aux3 integer[];
  v_aux integer;

  v_result integer;
BEGIN
  SELECT count(1) into v_slots
  FROM competition_data.slot s
  WHERE s.bracket = p_bracket;
  --raise notice 'Slots: %', v_slots;

  SELECT array_agg(id) into v_slot
  FROM competition_data.slot s
  WHERE s.bracket = p_bracket;
  --raise notice 'Slot Array: %', v_slot;

  SELECT array_agg(id ORDER BY rival, round, match) into v_rival
  FROM (SELECT rr.id, rr.rival, r.round, m.match
  FROM competition_data.round r
  JOIN competition_data.match m
  ON r.id = m.round
  JOIN competition_data.rival rr
  ON m.id = rr.match
  WHERE r.bracket = p_bracket
  UNION ALL
  SELECT null, 1, r.round, 0
  FROM competition_data.round r
  WHERE r.bracket = p_bracket
  AND v_slots%2 = 1
  UNION ALL
  SELECT null, 2, r.round, 0
  FROM competition_data.round r
  WHERE r.bracket = p_bracket
  AND v_slots%2 = 1) sq;
  --raise notice 'Rival Ids: %', v_rival;

  v_matches = v_slots/2;
  --raise notice 'Matches: %', v_matches;

  v_rounds = (v_slots+v_slots%2-1);
  --raise notice 'Rounds: %', v_rounds;
  SELECT count(1)/v_rounds into v_reps
  FROM competition_data.round r
  WHERE r.bracket = p_bracket;
  --raise notice 'Reps: %', v_reps;

  FOR islot IN 1..(v_slots-1+(v_slots%2)) LOOP
    v_aux = floor(random()* ((v_slots-(islot-1))-(1) + 1) + (1));
    --raise notice 'Aux: %', v_aux;
    v_order = array_append(v_order, v_slot[v_aux]);
    --raise notice 'Order Array: %', v_order;
    v_order_inverso[v_slots+(v_slots%2)-islot] = v_slot[v_aux];
    --raise notice 'Order Inverso Array: %', v_order_inverso;
    v_slot = array_remove(v_slot, v_slot[v_aux]);
    --raise notice 'Left Slots: %', v_slot;
  END LOOP;

  FOR imatch IN 1..v_matches+(v_slots%2) LOOP
    v_aux1 = array_cat(v_aux1, v_order);
    IF imatch < v_matches+(v_slots%2)
      THEN v_aux3 = array_cat(v_aux3, v_order_inverso);
    END IF;
  END LOOP;
  --raise notice 'Aux1 Slots: %', v_aux1;
  --raise notice 'Aux3 Slots: %', v_aux3;

  FOR iround IN 1..v_rounds LOOP
    FOR imatch IN 1.. v_matches+(v_slots%2) LOOP
      IF imatch = 1
        THEN v_aux2 = array_append(v_aux2, v_slot[1]);
        ELSE v_aux2 = array_append(v_aux2, v_aux3[(imatch-1)+(v_matches+(v_slots%2)-1)*(iround-1)]);
      END IF;
    END LOOP;
  END LOOP;
  --raise notice 'Aux2 Slots: %', v_aux2;

  raise notice 'Rival Ids: %', v_rival;
  raise notice 'Aux1 Slots: %', v_aux1;
  raise notice 'Aux2 Slots: %', v_aux2;

  FOR irep IN 1..v_reps LOOP
    raise notice 'Iteracion: %', irep;
    FOR iround IN 1..v_rounds LOOP
      FOR imatch IN 1..v_matches+(v_slots%2) LOOP
        IF (imatch = 1 AND iround%2 = 0)
          THEN
            IF irep%2 = 1
              THEN
                v_result = competition_data.edit_rival(v_rival[imatch+(v_matches+(v_slots%2))*(iround-1)+v_rounds*(v_matches+(v_slots%2))*(irep-1)], v_aux2[imatch+(v_matches+(v_slots%2))*(iround-1)]);
                raise notice 'Round %, Match %, Local %, id %', iround, imatch, v_aux2[imatch+(v_matches+(v_slots%2))*(iround-1)], v_rival[imatch+(v_matches+(v_slots%2))*(iround-1)+v_rounds*(v_matches+(v_slots%2))*(irep-1)];
                v_result = competition_data.edit_rival(v_rival[imatch+(v_matches+(v_slots%2))*(iround-1)+v_rounds*(v_matches+(v_slots%2))*v_reps+v_rounds*(v_matches+(v_slots%2))*(irep-1)], v_aux1[imatch+(v_matches+(v_slots%2))*(iround-1)]);
                raise notice 'Round %, Match %, Visitor %2, id %', iround, imatch, v_aux1[imatch+(v_matches+(v_slots%2))*(iround-1)], v_rival[imatch+(v_matches+(v_slots%2))*(iround-1)+v_rounds*(v_matches+(v_slots%2))*v_reps+v_rounds*(v_matches+(v_slots%2))*(irep-1)];
              ELSE
                v_result = competition_data.edit_rival(v_rival[imatch+(v_matches+(v_slots%2))*(iround-1)+v_rounds*(v_matches+(v_slots%2))*(irep-1)], v_aux1[imatch+(v_matches+(v_slots%2))*(iround-1)]);
                raise notice 'Round %, Match %, Local %, id %', iround, imatch, v_aux1[imatch+(v_matches+(v_slots%2))*(iround-1)], v_rival[imatch+(v_matches+(v_slots%2))*(iround-1)+v_rounds*(v_matches+(v_slots%2))*(irep-1)];
                v_result = competition_data.edit_rival(v_rival[imatch+(v_matches+(v_slots%2))*(iround-1)+v_rounds*(v_matches+(v_slots%2))*v_reps+v_rounds*(v_matches+(v_slots%2))*(irep-1)], v_aux2[imatch+(v_matches+(v_slots%2))*(iround-1)]);
                raise notice 'Round %, Match %, Visitor %, id %', iround, imatch, v_aux2[imatch+(v_matches+(v_slots%2))*(iround-1)], v_rival[imatch+(v_matches+(v_slots%2))*(iround-1)+v_rounds*(v_matches+(v_slots%2))*v_reps+v_rounds*(v_matches+(v_slots%2))*(irep-1)];
            END IF;
          ELSE
            IF irep%2 = 1
              THEN
                v_result = competition_data.edit_rival(v_rival[imatch+(v_matches+(v_slots%2))*(iround-1)+v_rounds*(v_matches+(v_slots%2))*(irep-1)], v_aux1[imatch+(v_matches+(v_slots%2))*(iround-1)]);
                raise notice 'Round %, Match %, Local %, id %', iround, imatch, v_aux1[imatch+(v_matches+(v_slots%2))*(iround-1)], v_rival[imatch+(v_matches+(v_slots%2))*(iround-1)+v_rounds*(v_matches+(v_slots%2))*(irep-1)];
                v_result = competition_data.edit_rival(v_rival[imatch+(v_matches+(v_slots%2))*(iround-1)+v_rounds*(v_matches+(v_slots%2))*v_reps+v_rounds*(v_matches+(v_slots%2))*(irep-1)], v_aux2[imatch+(v_matches+(v_slots%2))*(iround-1)]);
                raise notice 'Round %, Match %, Visitor %, id %', iround, imatch, v_aux2[imatch+(v_matches+(v_slots%2))*(iround-1)], v_rival[imatch+(v_matches+(v_slots%2))*(iround-1)+v_rounds*(v_matches+(v_slots%2))*v_reps+v_rounds*(v_matches+(v_slots%2))*(irep-1)];
              ELSE
                v_result = competition_data.edit_rival(v_rival[imatch+(v_matches+(v_slots%2))*(iround-1)+v_rounds*(v_matches+(v_slots%2))*(irep-1)], v_aux2[imatch+(v_matches+(v_slots%2))*(iround-1)]);
                raise notice 'Round %, Match %, Local %, id %', iround, imatch, v_aux2[imatch+(v_matches+(v_slots%2))*(iround-1)], v_rival[imatch+(v_matches+(v_slots%2))*(iround-1)+v_rounds*(v_matches+(v_slots%2))*(irep-1)];
                v_result = competition_data.edit_rival(v_rival[imatch+(v_matches+(v_slots%2))*(iround-1)+v_rounds*(v_matches+(v_slots%2))*v_reps+v_rounds*(v_matches+(v_slots%2))*(irep-1)], v_aux1[imatch+(v_matches+(v_slots%2))*(iround-1)]);
                raise notice 'Round %, Match %, Visitor %, id %', iround, imatch, v_aux1[imatch+(v_matches+(v_slots%2))*(iround-1)], v_rival[imatch+(v_matches+(v_slots%2))*(iround-1)+v_rounds*(v_matches+(v_slots%2))*v_reps+v_rounds*(v_matches+(v_slots%2))*(irep-1)];
            END IF;
        END IF;
      END LOOP;
    END LOOP;
  END LOOP;

  return 0;

  EXCEPTION
  when others THEN
    return -1;
END;
$BODY$