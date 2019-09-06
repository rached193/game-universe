/*Competition Filters*/
SELECT competition_data.get_videogames() as data;/*videogame: 1*/

SELECT competition_data.get_competition_filters(1) as data;/*region: 1, game_mode: 1, playform: 1*/

SELECT competition_data.get_organizations(1) as data;/*Organization: 1*/

/*Competition and Registering*/
SELECT competition_data.create_competition(1, 'Test League Competition', 1, 1, 1, 1, '2019/09/01', '2019/09/01', 8, 16) as data;/*Competition: 7*/

SELECT competition_data.create_registration(7, 'Generic Player 1', null) as data;/*Registration: 22*/
SELECT competition_data.create_registration(7, 'Generic Player 2', null) as data;/*Registration: 23*/
SELECT competition_data.create_registration(7, 'Generic Player 3', null) as data;/*Registration: 24*/
SELECT competition_data.create_registration(7, 'Generic Player 4', null) as data;/*Registration: 25*/
SELECT competition_data.create_registration(7, 'Generic Player 5', null) as data;/*Registration: 26*/
SELECT competition_data.create_registration(7, 'Generic Player 6', null) as data;/*Registration: 27*/
SELECT competition_data.create_registration(7, 'Generic Player 7', null) as data;/*Registration: 28*/
SELECT competition_data.create_registration(7, 'Generic Player 8', null) as data;/*Registration: 20*/
SELECT competition_data.create_registration(7, 'Generic Player 9', null) as data;/*Registration: 30*/
SELECT competition_data.create_registration(7, 'Generic Player 10', null) as data;/*Registration: 31*/
SELECT competition_data.create_registration(7, 'Generic Player 11', null) as data;/*Registration: 32*/
SELECT competition_data.create_registration(7, 'Generic Player 12', null) as data;/*Registration: 33*/
SELECT competition_data.create_registration(7, 'Generic Player 13', null) as data;/*Registration: 34*/
SELECT competition_data.create_registration(7, 'Generic Player 14', null) as data;/*Registration: 35*/
SELECT competition_data.create_registration(7, 'Generic Player 15', null) as data;/*Registration: 36*/

/*Phase Filters*/
SELECT competition_data.get_formats() as data;/*Format: 1*//*Format: 3*/

SELECT competition_data.get_bos() as data;/*BO: 1*//*BO: 3*/

/*Phase and Configuration*/
SELECT competition_data.create_phase(7, 1, 1, 1, '2019/09/01') as data;/*Phase: 4*/
SELECT competition_data.create_phase(7, 2, 3, 3, '2019/09/01') as data;/*Phase: 5*/

SELECT competition_data.set_competitors(4, 15) as data;
SELECT competition_data.get_competitors(4) as data;/*Competitors: 24-38*/
SELECT competition_data.edit_competitor(24, 22) as data;
SELECT competition_data.edit_competitor(25, 23) as data;
SELECT competition_data.edit_competitor(26, 24) as data;
SELECT competition_data.edit_competitor(27, 25) as data;
SELECT competition_data.edit_competitor(28, 26) as data;
SELECT competition_data.edit_competitor(29, 27) as data;
SELECT competition_data.edit_competitor(30, 28) as data;
SELECT competition_data.edit_competitor(31, 29) as data;
SELECT competition_data.edit_competitor(32, 30) as data;
SELECT competition_data.edit_competitor(33, 31) as data;
SELECT competition_data.edit_competitor(34, 32) as data;
SELECT competition_data.edit_competitor(35, 33) as data;
SELECT competition_data.edit_competitor(36, 34) as data;
SELECT competition_data.edit_competitor(37, 35) as data;
SELECT competition_data.edit_competitor(38, 36) as data;

SELECT competition_data.set_brackets(4, 2) as data;
SELECT competition_data.get_brackets(4) as data;/*Brackets: 5-6*/

SELECT competition_data.set_slots (5, 8) as data;
SELECT competition_data.get_slots(5) as data;/*Slots: 20-27*/

SELECT competition_data.set_rounds(5, 2) as data;
SELECT competition_data.get_rounds(5) as data;/*Rounds: 26-39*/

SELECT competition_data.set_matches(26) as data;
SELECT competition_data.get_matches(26) as data;/*Matches: 74-77*/

SELECT competition_data.set_rivals(74) as data;
SELECT competition_data.set_games(74) as data;
SELECT competition_data.set_rivals(75) as data;
SELECT competition_data.set_games(75) as data;
SELECT competition_data.set_rivals(76) as data;
SELECT competition_data.set_games(76) as data;
SELECT competition_data.set_rivals(77) as data;
SELECT competition_data.set_games(77) as data;

SELECT competition_data.set_matches(27) as data;
SELECT competition_data.get_matches(27) as data;/*Matches: 78-81*/

SELECT competition_data.set_rivals(78) as data;
SELECT competition_data.set_games(78) as data;
SELECT competition_data.set_rivals(79) as data;
SELECT competition_data.set_games(79) as data;
SELECT competition_data.set_rivals(80) as data;
SELECT competition_data.set_games(80) as data;
SELECT competition_data.set_rivals(81) as data;
SELECT competition_data.set_games(81) as data;

SELECT competition_data.set_matches(28) as data;
SELECT competition_data.get_matches(28) as data;/*Matches: 82-85*/

SELECT competition_data.set_rivals(82) as data;
SELECT competition_data.set_games(82) as data;
SELECT competition_data.set_rivals(83) as data;
SELECT competition_data.set_games(83) as data;
SELECT competition_data.set_rivals(84) as data;
SELECT competition_data.set_games(84) as data;
SELECT competition_data.set_rivals(85) as data;
SELECT competition_data.set_games(85) as data;

SELECT competition_data.set_matches(29) as data;
SELECT competition_data.get_matches(29) as data;/*Matches: 86-89*/

SELECT competition_data.set_rivals(86) as data;
SELECT competition_data.set_games(86) as data;
SELECT competition_data.set_rivals(87) as data;
SELECT competition_data.set_games(87) as data;
SELECT competition_data.set_rivals(88) as data;
SELECT competition_data.set_games(88) as data;
SELECT competition_data.set_rivals(89) as data;
SELECT competition_data.set_games(89) as data;

SELECT competition_data.set_matches(30) as data;
SELECT competition_data.get_matches(30) as data;/*Matches: 90-93*/

SELECT competition_data.set_rivals(90) as data;
SELECT competition_data.set_games(90) as data;
SELECT competition_data.set_rivals(91) as data;
SELECT competition_data.set_games(91) as data;
SELECT competition_data.set_rivals(92) as data;
SELECT competition_data.set_games(92) as data;
SELECT competition_data.set_rivals(93) as data;
SELECT competition_data.set_games(93) as data;

SELECT competition_data.set_matches(31) as data;
SELECT competition_data.get_matches(31) as data;/*Matches: 94-97*/

SELECT competition_data.set_rivals(94) as data;
SELECT competition_data.set_games(94) as data;
SELECT competition_data.set_rivals(95) as data;
SELECT competition_data.set_games(95) as data;
SELECT competition_data.set_rivals(96) as data;
SELECT competition_data.set_games(96) as data;
SELECT competition_data.set_rivals(97) as data;
SELECT competition_data.set_games(97) as data;

SELECT competition_data.set_matches(32) as data;
SELECT competition_data.get_matches(32) as data;/*Matches: 98-101*/

SELECT competition_data.set_rivals(98) as data;
SELECT competition_data.set_games(98) as data;
SELECT competition_data.set_rivals(99) as data;
SELECT competition_data.set_games(99) as data;
SELECT competition_data.set_rivals(100) as data;
SELECT competition_data.set_games(100) as data;
SELECT competition_data.set_rivals(101) as data;
SELECT competition_data.set_games(101) as data;

SELECT competition_data.set_matches(33) as data;
SELECT competition_data.get_matches(33) as data;/*Matches: 102-105*/

SELECT competition_data.set_rivals(102) as data;
SELECT competition_data.set_games(102) as data;
SELECT competition_data.set_rivals(103) as data;
SELECT competition_data.set_games(103) as data;
SELECT competition_data.set_rivals(104) as data;
SELECT competition_data.set_games(104) as data;
SELECT competition_data.set_rivals(105) as data;
SELECT competition_data.set_games(105) as data;

SELECT competition_data.set_matches(34) as data;
SELECT competition_data.get_matches(34) as data;/*Matches: 106-109*/

SELECT competition_data.set_rivals(106) as data;
SELECT competition_data.set_games(106) as data;
SELECT competition_data.set_rivals(107) as data;
SELECT competition_data.set_games(107) as data;
SELECT competition_data.set_rivals(108) as data;
SELECT competition_data.set_games(108) as data;
SELECT competition_data.set_rivals(109) as data;
SELECT competition_data.set_games(109) as data;

SELECT competition_data.set_matches(35) as data;
SELECT competition_data.get_matches(35) as data;/*Matches: 110-113*/

SELECT competition_data.set_rivals(110) as data;
SELECT competition_data.set_games(110) as data;
SELECT competition_data.set_rivals(111) as data;
SELECT competition_data.set_games(111) as data;
SELECT competition_data.set_rivals(112) as data;
SELECT competition_data.set_games(112) as data;
SELECT competition_data.set_rivals(113) as data;
SELECT competition_data.set_games(113) as data;

SELECT competition_data.set_matches(36) as data;
SELECT competition_data.get_matches(36) as data;/*Matches: 114-117*/

SELECT competition_data.set_rivals(114) as data;
SELECT competition_data.set_games(114) as data;
SELECT competition_data.set_rivals(115) as data;
SELECT competition_data.set_games(115) as data;
SELECT competition_data.set_rivals(116) as data;
SELECT competition_data.set_games(116) as data;
SELECT competition_data.set_rivals(117) as data;
SELECT competition_data.set_games(117) as data;

SELECT competition_data.set_matches(37) as data;
SELECT competition_data.get_matches(37) as data;/*Matches: 118-121*/

SELECT competition_data.set_rivals(118) as data;
SELECT competition_data.set_games(118) as data;
SELECT competition_data.set_rivals(119) as data;
SELECT competition_data.set_games(119) as data;
SELECT competition_data.set_rivals(120) as data;
SELECT competition_data.set_games(120) as data;
SELECT competition_data.set_rivals(121) as data;
SELECT competition_data.set_games(121) as data;

SELECT competition_data.set_matches(38) as data;
SELECT competition_data.get_matches(38) as data;/*Matches: 122-125*/

SELECT competition_data.set_rivals(122) as data;
SELECT competition_data.set_games(122) as data;
SELECT competition_data.set_rivals(123) as data;
SELECT competition_data.set_games(123) as data;
SELECT competition_data.set_rivals(124) as data;
SELECT competition_data.set_games(124) as data;
SELECT competition_data.set_rivals(125) as data;
SELECT competition_data.set_games(125) as data;

SELECT competition_data.set_matches(39) as data;
SELECT competition_data.get_matches(39) as data;/*Matches: 126-129*/

SELECT competition_data.set_rivals(126) as data;
SELECT competition_data.set_games(126) as data;
SELECT competition_data.set_rivals(127) as data;
SELECT competition_data.set_games(127) as data;
SELECT competition_data.set_rivals(128) as data;
SELECT competition_data.set_games(128) as data;
SELECT competition_data.set_rivals(129) as data;
SELECT competition_data.set_games(129) as data;

SELECT competition_data.set_slots (6, 7) as data;
SELECT competition_data.get_slots(6) as data;/*Slots: 28-34*/

SELECT competition_data.set_rounds(6, 2) as data;
SELECT competition_data.get_rounds(5) as data;/*Rounds: 40-53*/

SELECT competition_data.set_matches(40) as data;
SELECT competition_data.get_matches(40) as data;/*Matches: 130-132*/

SELECT competition_data.set_rivals(130) as data;
SELECT competition_data.set_games(130) as data;
SELECT competition_data.set_rivals(131) as data;
SELECT competition_data.set_games(131) as data;
SELECT competition_data.set_rivals(132) as data;
SELECT competition_data.set_games(132) as data;

SELECT competition_data.set_matches(41) as data;
SELECT competition_data.get_matches(41) as data;/*Matches: 133-135*/

SELECT competition_data.set_rivals(133) as data;
SELECT competition_data.set_games(133) as data;
SELECT competition_data.set_rivals(134) as data;
SELECT competition_data.set_games(134) as data;
SELECT competition_data.set_rivals(135) as data;
SELECT competition_data.set_games(135) as data;

SELECT competition_data.set_matches(42) as data;
SELECT competition_data.get_matches(42) as data;/*Matches: 136-138*/

SELECT competition_data.set_rivals(136) as data;
SELECT competition_data.set_games(136) as data;
SELECT competition_data.set_rivals(137) as data;
SELECT competition_data.set_games(137) as data;
SELECT competition_data.set_rivals(138) as data;
SELECT competition_data.set_games(138) as data;

SELECT competition_data.set_matches(43) as data;
SELECT competition_data.get_matches(43) as data;/*Matches: 139-141*/

SELECT competition_data.set_rivals(139) as data;
SELECT competition_data.set_games(139) as data;
SELECT competition_data.set_rivals(140) as data;
SELECT competition_data.set_games(140) as data;
SELECT competition_data.set_rivals(141) as data;
SELECT competition_data.set_games(141) as data;

SELECT competition_data.set_matches(44) as data;
SELECT competition_data.get_matches(44) as data;/*Matches: 142-144*/

SELECT competition_data.set_rivals(142) as data;
SELECT competition_data.set_games(142) as data;
SELECT competition_data.set_rivals(143) as data;
SELECT competition_data.set_games(143) as data;
SELECT competition_data.set_rivals(144) as data;
SELECT competition_data.set_games(144) as data;

SELECT competition_data.set_matches(45) as data;
SELECT competition_data.get_matches(45) as data;/*Matches: 145-147*/

SELECT competition_data.set_rivals(145) as data;
SELECT competition_data.set_games(145) as data;
SELECT competition_data.set_rivals(146) as data;
SELECT competition_data.set_games(146) as data;
SELECT competition_data.set_rivals(147) as data;
SELECT competition_data.set_games(147) as data;

SELECT competition_data.set_matches(46) as data;
SELECT competition_data.get_matches(46) as data;/*Matches: 148-150*/

SELECT competition_data.set_rivals(148) as data;
SELECT competition_data.set_games(148) as data;
SELECT competition_data.set_rivals(149) as data;
SELECT competition_data.set_games(149) as data;
SELECT competition_data.set_rivals(150) as data;
SELECT competition_data.set_games(150) as data;

SELECT competition_data.set_matches(47) as data;
SELECT competition_data.get_matches(47) as data;/*Matches: 151-153*/

SELECT competition_data.set_rivals(151) as data;
SELECT competition_data.set_games(151) as data;
SELECT competition_data.set_rivals(152) as data;
SELECT competition_data.set_games(152) as data;
SELECT competition_data.set_rivals(153) as data;
SELECT competition_data.set_games(153) as data;

SELECT competition_data.set_matches(48) as data;
SELECT competition_data.get_matches(48) as data;/*Matches: 154-156*/

SELECT competition_data.set_rivals(154) as data;
SELECT competition_data.set_games(154) as data;
SELECT competition_data.set_rivals(155) as data;
SELECT competition_data.set_games(155) as data;
SELECT competition_data.set_rivals(156) as data;
SELECT competition_data.set_games(156) as data;

SELECT competition_data.set_matches(49) as data;
SELECT competition_data.get_matches(49) as data;/*Matches: 157-159*/

SELECT competition_data.set_rivals(157) as data;
SELECT competition_data.set_games(157) as data;
SELECT competition_data.set_rivals(158) as data;
SELECT competition_data.set_games(158) as data;
SELECT competition_data.set_rivals(159) as data;
SELECT competition_data.set_games(159) as data;

SELECT competition_data.set_matches(50) as data;
SELECT competition_data.get_matches(50) as data;/*Matches: 160-162*/

SELECT competition_data.set_rivals(160) as data;
SELECT competition_data.set_games(160) as data;
SELECT competition_data.set_rivals(161) as data;
SELECT competition_data.set_games(161) as data;
SELECT competition_data.set_rivals(162) as data;
SELECT competition_data.set_games(162) as data;

SELECT competition_data.set_matches(51) as data;
SELECT competition_data.get_matches(51) as data;/*Matches: 163-165*/

SELECT competition_data.set_rivals(163) as data;
SELECT competition_data.set_games(163) as data;
SELECT competition_data.set_rivals(164) as data;
SELECT competition_data.set_games(164) as data;
SELECT competition_data.set_rivals(165) as data;
SELECT competition_data.set_games(165) as data;

SELECT competition_data.set_matches(52) as data;
SELECT competition_data.get_matches(52) as data;/*Matches: 166-168*/

SELECT competition_data.set_rivals(166) as data;
SELECT competition_data.set_games(166) as data;
SELECT competition_data.set_rivals(167) as data;
SELECT competition_data.set_games(167) as data;
SELECT competition_data.set_rivals(168) as data;
SELECT competition_data.set_games(168) as data;

SELECT competition_data.set_matches(53) as data;
SELECT competition_data.get_matches(53) as data;/*Matches: 169-171*/

SELECT competition_data.set_rivals(169) as data;
SELECT competition_data.set_games(169) as data;
SELECT competition_data.set_rivals(170) as data;
SELECT competition_data.set_games(170) as data;
SELECT competition_data.set_rivals(171) as data;
SELECT competition_data.set_games(171) as data;

SELECT competition_data.set_league_pairings(5) as data;

SELECT competition_data.set_league_pairings(6) as data;

SELECT competition_data.set_competitors(5, 8) as data;
SELECT competition_data.get_competitors(5) as data;/*Competitors: 39-46*/

SELECT competition_data.set_brackets(5, 1) as data;
SELECT competition_data.get_brackets(5) as data;/*Bracket: 7*/

SELECT competition_data.set_slots (7, 8) as data;
SELECT competition_data.get_slots(7) as data;/*Slots: 35-42*/

SELECT competition_data.set_rounds(7, 1) as data;
SELECT competition_data.get_rounds(7) as data;/*Rounds: 54-56*/

SELECT competition_data.set_matches(54) as data;
SELECT competition_data.get_matches(54) as data;/*Matches: 172-175*/

SELECT competition_data.set_rivals(172) as data;
SELECT competition_data.set_games(172) as data;
SELECT competition_data.set_rivals(173) as data;
SELECT competition_data.set_games(173) as data;
SELECT competition_data.set_rivals(174) as data;
SELECT competition_data.set_games(174) as data;
SELECT competition_data.set_rivals(175) as data;
SELECT competition_data.set_games(175) as data;

SELECT competition_data.set_matches(55) as data;
SELECT competition_data.get_matches(55) as data;/*Matches: 176-177*/

SELECT competition_data.set_rivals(176) as data;
SELECT competition_data.set_games(176) as data;
SELECT competition_data.set_rivals(177) as data;
SELECT competition_data.set_games(177) as data;

SELECT competition_data.set_matches(55) as data;
SELECT competition_data.get_matches(55) as data;/*Matches: 178*/

SELECT competition_data.set_rivals(178) as data;
SELECT competition_data.set_games(178) as data;