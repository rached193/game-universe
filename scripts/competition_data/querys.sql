/*Competition Filters*/
SELECT competition_data.get_videogames() ad data;

SELECT competition_data.get_platforms(p_videogame) as data;

SELECT competition_data.get_regions(p_videogame) as data;

SELECT competition_data.get_gamemodes(p_videogame) as data;

SELECT competition_data.get_competition_filters(p_videogame) as data;

/*Competition*/
SELECT competition_data.create_competition(p_organization, p_name, p_videogame, p_platform, p_region, p_gamemode) as data;
