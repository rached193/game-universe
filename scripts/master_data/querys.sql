/*Videogame*/
SELECT master_data.create_videogame(p_name) as data;

SELECT master_data.enable_videogame(p_id, p_enabled) as data;

SELECT master_data.edit_videogame(p_id, p_name) as data;

SELECT master_data.get_videogames() ad data;

/*Platform*/
SELECT master_data.create_platform(p_name) as data;

SELECT master_data.enable_platform(p_id, p_enabled) as data;

SELECT master_data.edit_platform(p_id, p_name) as data;

SELECT master_data.get_platforms() as data;

/*Region*/
SELECT master_data.create_region(p_videogame, p_name) as data;

SELECT master_data.enable_region(p_id, p_enabled) as data;

SELECT master_data.edit_region(p_id, p_name) as data;

SELECT master_data.get_regions() as data;

/*GameMode*/
SELECT master_data.create_gamemode(p_videogame, p_name) as data;

SELECT master_data.enable_gamemode(p_id, p_enabled) as data;

SELECT master_data.edit_gamemode(p_id, p_name) as data;

SELECT master_data.get_gamemodes() as data;

/*Videogame-Platform*/
SELECT master_data.create_videogame_platform(p_videogame, p_platform) as data;

SELECT master_data.enable_videogame_platform(p_videogame, p_platform, p_enabled) as data;

SELECT master_data.get_videogames_platforms() as data;

/*Format*/
SELECT master_data.create_format(p_name) as data;

SELECT master_data.enable_format(p_id, p_enabled) as data;

SELECT master_data.edit_format(p_id, p_name) as data;

SELECT master_data.get_formats() as data;

/*MASTER_BO*/
SELECT master_data.create_bo(p_name, p_games) as data;

SELECT master_data.enable_bo(p_id, p_enabled) as data;

SELECT master_data.edit_bo(p_id, p_name, p_games) as data;

SELECT master_data.get_bos() as data;
