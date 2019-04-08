/*Videogame*/
SELECT competition_data.get_videogames() ad data;

/*Platform*/
SELECT competition_data.get_platforms(p_videogame) as data;

/*Region*/
SELECT competition_data.get_regions(p_videogame) as data;

/*GameMode*/
SELECT competition_data.get_gamemodes(p_videogame) as data;

/*Competition*/
SELECT competition_data.create_competition(p_organization, p_name, p_videogame, p_platform, p_region, p_gamemode) as data;
