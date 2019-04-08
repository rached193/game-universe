/*Videogame*/
SELECT master_data.create_videogame(p_name);

SELECT master_data.enable_videogame(p_id, p_enabled);

SELECT master_data.get_videogames();

/*Platform*/
SELECT master_data.create_platform(p_name);

SELECT master_data.enable_platform(p_id, p_enabled);

SELECT master_data.get_platforms();

/*Region*/
SELECT master_data.create_region(p_videogame, p_name);

SELECT master_data.enable_region(p_id, p_enabled);

SELECT master_data.get_regions();

/*GameMode*/
SELECT master_data.create_gamemode(p_videogame, p_name);

SELECT master_data.enable_gamemode(p_id, p_enabled);

SELECT master_data.get_gamemodes();

/*Videogame-Platform*/
SELECT master_data.create_videogame_platform(p_videogame, p_platform);

SELECT master_data.enable_videogame_platform(p_videogame, p_platform, p_enabled);

SELECT master_data.get_videogames_platforms();

/*Format*/
SELECT master_data.create_format(p_name);

SELECT master_data.enable_format(p_id, p_enabled);

SELECT master_data.get_formats();

/*MASTER_BO*/
SELECT master_data.create_bo(p_name, p_games);

SELECT master_data.enable_bo(p_id, p_enabled);

SELECT master_data.get_bos();