/*Competitions*/
SELECT jsonb_build_object(
    'id', c.id,
    'organization', jsonb_build_object(
      'id', o.id,
      'name', o.name,
      'logo', o.logo,
      'contact', jsonb_build_object(
        'mail', o.contact_mail,
        'number', o.contact_number
      )
    ),
    'name', c.name,
    'videogame', jsonb_build_object(
      'id', v.id,
      'name', v.name
    ),
    'platform', jsonb_build_object(
      'id', p.id,
      'name', p.name
    ),
    'region', jsonb_build_object(
      'id', r.id,
      'name', r.name
    ),
    'game_mode', jsonb_build_object(
      'id', gm.id,
      'name', gm.name
    ),
    'phases', (SELECT jsonb_agg(jsonb_build_object(
      'id', p.id,
      'phase', p.phase,
      'format', jsonb_build_object(
        'id', f.id,
        'name', f.name
      ),
      'bo', jsonb_build_object(
        'id', b.id,
        'name', b.name,
        'games', b.games
      ),
      'nr_groups', p.groups,
      'nr_participants', p.participants,
      'participants', (SELECT jsonb_agg(jsonb_build_object(
        'id', pa.id,
        'participant', pa.participant,
        'account', CASE WHEN pa.account IS NOT NULL THEN jsonb_build_object(
          'id', a.id,
          'name', a.name
        ) ELSE null END,
        'name', pa.name,
        'group', pa.ngroup
      ) ORDER BY pa.participant) as data
    FROM competition_data.participant pa
    LEFT JOIN user_data.account a ON pa.account = a.id
    WHERE pa.phase = p.id),
      'rounds', (SELECT jsonb_agg(jsonb_build_object(
        'id', r.id,
        'round', r.round,
        'matches', (SELECT jsonb_agg(jsonb_build_object(
          'id', m.id,
          'match', m.match,
          'participants', jsonb_build_array(
            CASE WHEN m.participant1 IS NOT NULL THEN jsonb_build_object(
              'id', p1.id,
              'name', p1.name
            ) ELSE null END,
            CASE WHEN m.participant2 IS NOT NULL THEN jsonb_build_object(
              'id', p2.id,
              'name', p2.name
            ) ELSE null END
          ),
          'games', (SELECT jsonb_agg(jsonb_build_object(
            'id', g.id,
            'game', g.game,
            'winner', CASE WHEN g.winner IS NOT NULL THEN jsonb_build_object(
                'id', pw.id,
                'name', pw.name
              ) ELSE null END
          ) ORDER BY g.game) as data
        FROM competition_data.game g
        LEFT JOIN competition_data.participant pw ON g.winner = pw.id
        WHERE g.game = m.id)
        ) ORDER BY m.match) as data
      FROM competition_data.match m
      LEFT JOIN competition_data.participant p1 ON m.participant1 = p1.id
      LEFT JOIN competition_data.participant p2 ON m.participant2 =p2.id
      WHERE m.round = r.id)
      ) ORDER BY r.round) as data
    FROM competition_data.round r
    WHERE r.phase = p.id)
    ) ORDER BY p.phase) as data
  FROM competition_data.phase p
  JOIN master_data.format f ON p.format = f.id
  JOIN master_data.bo b ON p.bo = b.id
  WHERE p.competition = c.id)
  ) as data
FROM competition_data.competition c
JOIN user_data.organization o ON c.organization = o.id
JOIN master_data.videogame v ON c.videogame = v.id
JOIN master_data.platform p ON c.platform = p.id
JOIN master_data.region r ON c.region = r.id
JOIN master_data.gamemode gm ON c.gamemode = gm.id;

/*Phases*/
(SELECT jsonb_agg(jsonb_build_object(
    'id', p.id,
    'phase', p.phase,
    'format', jsonb_build_object(
      'id', f.id,
      'name', f.name
    ),
    'bo', jsonb_build_object(
      'id', b.id,
      'name', b.name,
      'games', b.games
    ),
    'nr_groups', p.groups,
    'nr_participants', p.participants,
    'participants', (SELECT jsonb_agg(jsonb_build_object(
      'id', pa.id,
      'participant', pa.participant,
      'account', CASE WHEN pa.account IS NOT NULL THEN jsonb_build_object(
        'id', a.id,
        'name', a.name
      ) ELSE null END,
      'name', pa.name,
      'group', pa.ngroup
    ) ORDER BY pa.participant) as data
  FROM competition_data.participant pa
  LEFT JOIN user_data.account a ON pa.account = a.id
  WHERE pa.phase = p.id),
    'rounds', (SELECT jsonb_agg(jsonb_build_object(
      'id', r.id,
      'round', r.round,
      'matches', (SELECT jsonb_agg(jsonb_build_object(
        'id', m.id,
        'match', m.match,
        'participants', jsonb_build_array(
          CASE WHEN m.participant1 IS NOT NULL THEN jsonb_build_object(
            'id', p1.id,
            'name', p1.name
          ) ELSE null END,
          CASE WHEN m.participant2 IS NOT NULL THEN jsonb_build_object(
            'id', p2.id,
            'name', p2.name
          ) ELSE null END
        ),
        'games', (SELECT jsonb_agg(jsonb_build_object(
          'id', g.id,
          'game', g.game,
          'winner', CASE WHEN g.winner IS NOT NULL THEN jsonb_build_object(
              'id', pw.id,
              'name', pw.name
            ) ELSE null END
        ) ORDER BY g.game) as data
      FROM competition_data.game g
      LEFT JOIN competition_data.participant pw ON g.winner = pw.id
      WHERE g.game = m.id)
      ) ORDER BY m.match) as data
    FROM competition_data.match m
    LEFT JOIN competition_data.participant p1 ON m.participant1 = p1.id
    LEFT JOIN competition_data.participant p2 ON m.participant2 =p2.id
    WHERE m.round = r.id)
    ) ORDER BY r.round) as data
  FROM competition_data.round r
  WHERE r.phase = p.id)
  ) ORDER BY p.phase) as data
FROM competition_data.phase p
JOIN master_data.format f ON p.format = f.id
JOIN master_data.bo b ON p.bo = b.id
WHERE p.competition = c.id);

/*Participants*/
(SELECT jsonb_agg(jsonb_build_object(
    'id', pa.id,
    'participant', pa.participant,
    'account', CASE WHEN pa.account IS NOT NULL THEN jsonb_build_object(
      'id', a.id,
      'name', a.name
    ) ELSE null END,
    'name', pa.name,
    'group', pa.ngroup
  ) ORDER BY pa.participant), as data
FROM competition_data.participant pa
LEFT JOIN user_data.account a ON pa.account = a.id
WHERE pa.phase = p.id);

/*Rounds*/
(SELECT jsonb_agg(jsonb_build_object(
    'id', r.id,
    'round', r.round,
    'matches', (SELECT jsonb_agg(jsonb_build_object(
      'id', m.id,
      'match', m.match,
      'participants', jsonb_build_array(
        CASE WHEN m.participant1 IS NOT NULL THEN jsonb_build_object(
          'id', p1.id,
          'name', p1.name
        ) ELSE null END,
        CASE WHEN m.participant2 IS NOT NULL THEN jsonb_build_object(
          'id', p2.id,
          'name', p2.name
        ) ELSE null END
      ),
      'games', (SELECT jsonb_agg(jsonb_build_object(
        'id', g.id,
        'game', g.game,
        'winner', CASE WHEN g.winner IS NOT NULL THEN jsonb_build_object(
            'id', pw.id,
            'name', pw.name
          ) ELSE null END
      ) ORDER BY g.game) as data
    FROM competition_data.game g
    LEFT JOIN competition_data.participant pw ON g.winner = pw.id
    WHERE g.game = m.id)
    ) ORDER BY m.match) as data
  FROM competition_data.match m
  LEFT JOIN competition_data.participant p1 ON m.participant1 = p1.id
  LEFT JOIN competition_data.participant p2 ON m.participant2 =p2.id
  WHERE m.round = r.id)
  ) ORDER BY r.round) as data
FROM competition_data.round r
WHERE r.phase = p.id);

/*Matches*/
(SELECT jsonb_agg(jsonb_build_object(
    'id', m.id,
    'match', m.match,
    'participants', jsonb_build_array(
      CASE WHEN m.participant1 IS NOT NULL THEN jsonb_build_object(
        'id', p1.id,
        'name', p1.name
      ) ELSE null END,
      CASE WHEN m.participant2 IS NOT NULL THEN jsonb_build_object(
        'id', p2.id,
        'name', p2.name
      ) ELSE null END
    ),
    'games', (SELECT jsonb_agg(jsonb_build_object(
      'id', g.id,
      'game', g.game,
      'winner', CASE WHEN g.winner IS NOT NULL THEN jsonb_build_object(
          'id', pw.id,
          'name', pw.name
        ) ELSE null END
    ) ORDER BY g.game) as data
  FROM competition_data.game g
  LEFT JOIN competition_data.participant pw ON g.winner = pw.id
  WHERE g.game = m.id)
  ) ORDER BY m.match) as data
FROM competition_data.match m
LEFT JOIN competition_data.participant p1 ON m.participant1 = p1.id
LEFT JOIN competition_data.participant p2 ON m.participant2 =p2.id
WHERE m.round = r.id);

/*Games*/
(SELECT jsonb_agg(jsonb_build_object(
    'id', g.id,
    'game', g.game,
    'winner', CASE WHEN g.winner IS NOT NULL THEN jsonb_build_object(
        'id', pw.id,
        'name', pw.name
      ) ELSE null END
  ) ORDER BY g.game) as data
FROM competition_data.game g
LEFT JOIN competition_data.participant pw ON g.winner = pw.id
WHERE g.game = m.id);
