/*Competition Filters*/
SELECT competition_data.get_videogames() as data;

SELECT competition_data.get_platforms(p_videogame) as data;

SELECT competition_data.get_regions(p_videogame) as data;

SELECT competition_data.get_gamemodes(p_videogame) as data;

SELECT competition_data.get_competition_filters(p_videogame) as data;

SELECT competition_data.get_organizations(p_account) as data;

/*Competition*/
SELECT competition_data.create_competition(p_organization, p_name, p_videogame, p_platform, p_region, p_gamemode) as data;

SELECT competition_data.enable_competition(p_id, p_enabled) as data;

SELECT competition_data.get_competitions(p_organization) as data;

SELECT competition_data.get_competition(p_id) as data;

/*Phase Filters*/
SELECT competition_data.get_formats() as data;

SELECT competition_data.get_bos() as data;

/*Phase*/
SELECT competition_data.get_next_phase(p_competition) as data;

SELECT competition_data.create_phase(p_competition, p_format, p_bo, p_groups, p_participants) as data;

SELECT competition_data.enable_phase(p_id, p_enabled) as data;

SELECT competition_data.get_phases(p_competition) as data;

SELECT competition_data.get_phase(p_id) as data;

/*Participant*/
SELECT competition_data.get_participants(p_phase) as data;

SELECT competition_data.create_participant(p_phase, p_account) as data;

SELECT competition_data.confirm_participant(p_id, p_confirmed) as data;

SELECT competition_data.set_groups(p_phase) as data;
