/*Competition Filters*/
SELECT competition_data.get_videogames() as data;

SELECT competition_data.get_platforms(p_videogame) as data;

SELECT competition_data.get_regions(p_videogame) as data;

SELECT competition_data.get_gamemodes(p_videogame) as data;

SELECT competition_data.get_competition_filters(p_videogame) as data;

SELECT competition_data.get_organizations(p_account) as data;

/*Competition*/
SELECT competition_data.get_competitions(p_organization) as data;

SELECT competition_data.create_competition(p_organization, p_name, p_videogame, p_platform, p_region, p_game_mode, p_registration_date, p_competition_date, p_weak_cap, p_hard_cap) as data;

SELECT competition_data.edit_competition(p_id, p_name, p_videogame, p_platform, p_region, p_game_mode, p_registration_date, p_competition_date, p_weak_cap, p_hard_cap) as data;

SELECT competition_data.update_competition_step(p_id, p_step) as data;

/*Registration*/
SELECT competition_data.get_registrations(p_competition) as data;

SELECT competition_data.create_registration(p_competition, p_name, p_account) as data;

SELECT competition_data.edit_registration(p_id, p_name, p_account) as data;

SELECT competition_data.update_registration_step(p_id, p_step) as data;

/*Phase Filters*/
SELECT competition_data.get_formats() as data;

SELECT competition_data.get_bos() as data;

/*Phase*/
SELECT competition_data.get_phases(p_competition) as data;

SELECT competition_data.create_phase(p_competition, p_phase, p_format, p_bo, p_phase_date) as data;

SELECT competition_data.edit_phase(p_id, p_format, p_bo, p_phase_date) as data;

SELECT competition_data.update_phase_step(p_id, p_step) as data;

/*Competitor*/
SELECT competition_data.set_competitors(p_phase, p_competitors) as data;

SELECT competition_data.get_competitors(p_phase) as data;

SELECT competition_data.edit_competitor(p_id, p_registration) as data;

SELECT competition_data.update_competitor_step(p_id, p_step) as data;

/*Bracket*/
SELECT competition_data.set_brackets(p_phase, p_brackets) as data;

SELECT competition_data.get_brackets(p_phase) as data;

SELECT competition_data.update_bracket_step(p_id, p_step) as data;

/*Slot*/
SELECT competition_data.set_slots (p_bracket, p_slots) as data;

SELECT competition_data.get_slots(p_bracket) as data;

SELECT competition_data.edit_slot(p_id, p_competitor) as data;

SELECT competition_data.update_slot_step(p_id, p_step) as data;

/*Round*/
SELECT competition_data.set_rounds(p_bracket, p_rounds) as data;

SELECT competition_data.get_rounds(p_bracket) as data;

SELECT competition_data.edit_round(p_id, p_round_date) as data;

SELECT competition_data.update_round_step(p_id, p_step) as data;

/*Match*/
SELECT competition_data.set_matches(p_round) as data;

SELECT competition_data.get_matches(p_round) as data;

SELECT competition_data.edit_match(p_id, p_match_date) as data;

SELECT competition_data.update_match_step(p_id, p_step) as data;

/*Rival*/
SELECT competition_data.set_rivals(p_match) as data;

SELECT competition_data.get_rivals(p_match) as data;

SELECT competition_data.edit_rival(p_id, p_slot) as data;

SELECT competition_data.update_rival_step(p_id, p_step) as data;

/*Game*/
SELECT competition_data.set_games(p_match) as data;

SELECT competition_data.get_games(p_match) as data;

SELECT competition_data.edit_game(p_id, p_game_date) as data;

SELECT competition_data.update_game_step(p_id, p_step) as data;

SELECT competition_data.edit_winner(p_id, p_winner) as data;

/*Assign Slots*/
SELECT competition_data.assign_slots(p_phase) as data;

/*Set Pairings*/
SELECT competition_data.set_league_pairings(p_bracket) as data;