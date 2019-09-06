SELECT jsonb_build_object(
	'id', c.id,
	'organization', jsonb_build_object(
		'name', o.name,
		'contact', jsonb_build_object(
			'mail', o.contact_mail,
			'number', o.contact_number)),
	'videogame', v.name,
	'platform', p.name,
	'region', r.name,
	'game_mode', gm.name,
	'registration_date', c.registration_date,
	'registrations', (SELECT jsonb_agg(jsonb_build_object(
		'id', r.id,
		'name', r.name,
		'account', r.account))
	FROM competition_data.registration r
	WHERE r.competition = c.id),
	'competition_date', c.competition_date,
	'phases', (SELECT jsonb_agg(jsonb_build_object(
		'id', ph.id,
		'phase', ph.phase,
		'format', f.name,
		'bo', bo.name,
		'competitors', (SELECT jsonb_agg(jsonb_build_object(
			'id', co.id,
			'competitor', co.competitor,
			'registration', co.registration))
		FROM competition_data.competitor co
		WHERE co.phase = ph.id),
		'phase_date', ph.phase_date,
		'brackets', (SELECT jsonb_agg(jsonb_build_object(
			'id', b.id,
			'bracket', b.bracket,
			'slots', (SELECT jsonb_agg(jsonb_build_object(
				'id', s.id,
				'slot', s.slot,
				'competitor', s.competitor))
			FROM competition_data.slot s
			WHERE s.bracket = b.id),
			'rounds', (SELECT jsonb_agg(jsonb_build_object(
				'id', ro.id,
				'round', ro.round,
				'round_date', ro.round_date,
				'matches', (SELECT jsonb_agg(jsonb_build_object(
					'id', m.id,
					'match', m.match,
					'rivals', (SELECT jsonb_agg(jsonb_build_object(
						'id', ri.id,
						'rival', CASE ri.rival WHEN 1 THEN 'Local' WHEN 2 THEN 'Visitor' ELSE null END,
						'slot', ri.slot))
					FROM competition_data.rival ri
					WHERE ri.match = m.id),
					'match_date', m.match_date,
					'games', (SELECT jsonb_agg(jsonb_build_object(
						'id', g.id,
						'game', g.game,
						'game_date', g.game_date,
						'winner', g.winner))
					FROM competition_data.game g
					WHERE g.match = m.id)))
				FROM competition_data.match m
				WHERE m.round = ro.id)))
			FROM competition_data.round ro
			WHERE ro.bracket = b.id)))
		FROM competition_data.bracket b
		WHERE b.phase = ph.id)))
	FROM competition_data.phase ph
	JOIN master_data.format f
	ON ph.format = f.id
	JOIN master_data.bo bo
	ON ph.bo = bo.id
	WHERE ph.competition = c.id))
FROM competition_data.competition c
JOIN user_data.organization o
ON c.organization = o.id
JOIN master_data.videogame v
ON c.videogame = v.id
JOIN master_data.platform p
ON c.platform = p.id
JOIN master_data.region r
ON c.region = r.id
JOIN master_data.game_mode gm
ON c.game_mode = gm.id
WHERE c.id = 7;