/*Competitions*/
SELECT 'SELECT competition_data.create_competition(1,''Dummy Competition '||ROW_NUMBER () OVER (ORDER BY 1)||''', '||v.id||', '||p.id||', '||r.id||', '||gm.id||') as data;'
FROM master_data.videogame_platform vp
JOIN master_data.videogame v ON vp.videogame = v.id
JOIN master_data.platform p ON vp.platform = p.id
JOIN master_data.region r ON v.id = r.videogame
JOIN master_data.gamemode gm ON v.id = gm.videogame
WHERE vp.enabled
AND v.enabled
AND p.enabled
AND r.enabled
AND gm.enabled
AND (random()*1)::int = 1;

/*Phases*/
SELECT 'SELECT competition_data.create_phase('||c.id||', '||(random()*2)::int+1||', '||(random()*2)::int+1||', '||2^(random()*2)::int||', '||2^((random()*2)::int+2)||') as data;'
FROM competition_data.competition c;

SELECT 'SELECT competition_data.create_phase('||p.competition||', 3, '||p.bo||', 1, '||p.participants||') as data;'
FROM competition_data.phase p
WHERE p.groups > 1;

/*Participants*/
SELECT 'SELECT competition_data.set_participants('||p.id||') as data;'
FROM competition_data.phase p
LEFT JOIN competition_data.participant pa ON p.id = pa.phase
WHERE pa.id IS NULL;

/*Rounds*/
SELECT 'SELECT competition_data.set_rounds('||p.id||') as data;'
FROM competition_data.phase p
LEFT JOIN competition_data.round r ON p.id = r.phase
WHERE r.id IS NULL;

/*Matches*/
SELECT 'SELECT competition_data.set_matches('||r.id||') as data;'
FROM competition_data.round r
LEFT JOIN competition_data.match m ON r.id = m.round
WHERE m.id IS NULL;

/*Games*/
SELECT 'SELECT competition_data.set_games('||m.id||') as data;'
FROM competition_data.match m
LEFT JOIN competition_data.game g ON m.id = g.match
WHERE g.id IS NULL;
