USE bestalbum;

#Renaming Tables
RENAME TABLE `appletopalbum` TO apple_top_album;
RENAME TABLE `billboard200` TO billboard_200;
RENAME TABLE `rollingstone` TO rolling_stone;
RENAME TABLE `spotifystreams` TO spotify_streams;

#Billboard cleaning
#verifying columns datatype
DESCRIBE billboard_200;
#Renaming columns
ALTER TABLE billboard_200
RENAME COLUMN `S/N` TO position,
RENAME COLUMN Album TO album,
RENAME COlUMN AlbumYear TO album_year,
RENAME COlUMN Artist TO artist,
RENAME COlUMN `Peak Position` TO peak_position,
RENAME COlUMN `RIAA Certification` TO riaa_certification,
RENAME COlUMN Grammys TO grammys,
RENAME COlUMN `Year End Charts` TO year_end_chart;

SELECT * 
FROM billboard_200;
#Changing the datatype
ALTER TABLE billboard_200 
MODIFY COLUMN position VARCHAR(10),
MODIFY COLUMN album_year YEAR,
MODIFY COLUMN peak_position VARCHAR(10),
MODIFY COLUMN year_end_chart VARCHAR(10);

#Fixing missing values
SELECT 
    *
FROM
    billboard_200
WHERE
    album_name = '' OR artist = ''
        OR album_year = ''
        OR peak_position = ''
        OR riaa_certification = ''
        OR grammys = ''
        OR year_end_chart = '';
#There is a missing value in riaa certification and this is because the album is not certified
UPDATE billboard_200
SET riaa_certification = 'Not Certified'
WHERE riaa_certification = '';

#Cleaning rolling stone
SELECT 
    *
FROM
    rolling_stone;
#Deleting unused columns
ALTER TABLE rolling_stone
DROP COLUMN rank_2003,
DROP COLUMN rank_2012,
DROP COLUMN differential,
DROP COLUMN weeks_on_billboard,
DROP COLUMN artist_member_count,
DROP COLUMN artist_birth_year_sum,
DROP COLUMN debut_album_release_year,
DROP COLUMN years_between,
DROP COLUMN ave_age_at_top_500;

ALTER TABLE rolling_stone
DROP COLUMN spotify_popularity;

#Deleteing 2020 null
DELETE FROM rolling_stone
WHERE rank_2020 IS NULL;

#Replacing genre null values
UPDATE rolling_stone
SET genre = 'Unknown'
WHERE genre IS NULL;

UPDATE rolling_stone 
SET 
    artist_gender = 'Various Artists'
WHERE
    artist_gender IS NULL;

#Changing data type
ALTER TABLE rolling_stone
MODIFY COLUMN peak_billboard_position INT,
MODIFY COLUMN rank_2020 INT,
MODIFY COLUMN release_year YEAR;

#Removing some rows from rolling stone list and adding more
DELETE FROM rolling_stone 
WHERE
    album IN ('Fine Line' , 'The Beach Boys Today!',
    'Screamadelica',
    'For Your Pleasure',
    'My Aim is True',
    'Goo',
    'Disraeli Gears',
    'Legend: The Best of Bob Marley and the Wailers');
#Updating with 2023 rank
INSERT INTO rolling_stone (clean_name,album, rank_2020, release_year, genre, peak_billboard_position, artist_gender)
VALUES ('Harry Styles', 'Harry\'s House', 491, 2022, 'Punk/Post-Punk/New Wave/Power Pop', 1, 'Male'),
('Black Uhuru', 'Red', 466, 1981, 'Reggae', 28, 'Various Artists'),
('Gorillaz', 'Demon Days', 437, 2005, 'Unknown', 1, 'Various Artists'),
('Bad Bunny', 'Un Verano Sin Ti', 430, 2022, 'Indie/Alternative Rock', 1, 'Male'),
('Olivia Rodrigo', 'SOUR', 358, 2021, 'Punk/Post-Punk/New Wave/Power Pop', 3, 'Female'),
('SZA', 'SOS', 351, 2022, 'Soul/Gospel/R&B', 1, 'Female'),
('Taylor Swift', 'Folklore', 170, 2020, 'Indie/Alternative Rock', 1, 'Female'),
('Beyoncé', 'Renaissance', 171, 2022, 'Unknown', 1, 'Female');
#Made a mistake with beyonce rank so adjusting it 
UPDATE rolling_stone 
SET 
    rank_2020 = 71
WHERE
    clean_name = 'Beyoncé' AND album =  'Renaissance';
UPDATE rolling_stone 
SET 
    rank_2020 = 46
WHERE
    album =  'Exodus';
    
ALTER TABLE rolling_stone
RENAME COLUMN clean_name TO `artist`,
RENAME COLUMN release_year TO `album_year`,
RENAME COLUMN rank_2020 TO `2023_rank`;
    
#Cleaning apple top albums
SELECT 
    *
FROM
    apple_top_album;

#Changing column name
ALTER TABLE apple_top_album
RENAME COLUMN Artists TO `artist`,
RENAME COLUMN Year TO `album_year`,
RENAME COLUMN Position TO `position`,
RENAME COLUMN Album TO `album`;

#Changing data type
ALTER TABLE apple_top_album
MODIFY COLUMN album_year YEAR;

#Cleaning grammys
SELECT 
    *
FROM
    grammys;
    
#Deleting unused columns
ALTER TABLE grammys
DROP COLUMN `City/town of birth/origin`,
DROP COLUMN `US State of birth/origin`;

#Renaming columns
ALTER TABLE grammys
RENAME COLUMN Year TO album_year,
RENAME COLUMN `Artist` TO artist_name,
RENAME COLUMN `Work` TO album_name,
RENAME COLUMN `Country of birth/origin` TO country,
RENAME COLUMN `Racial/Ethnic group` TO ethnicity;

#Changing data type
ALTER TABLE grammys
MODIFY COLUMN album_year YEAR;

#Cleaning spotify streams
SELECT *
FROM spotify_streams;

#Renaming columns
ALTER TABLE spotify_streams
RENAME COLUMN Position TO position,
RENAME COLUMN Album TO album_name,
RENAME COLUMN Artists TO artist_name,
RENAME COLUMN Total TO total_streams,
RENAME COLUMN Daily TO daily_streams;

#Removing the commas in the position i.e changing 1,000 to 1000
UPDATE spotify_streams
SET position = REPLACE(position, ',', '')
WHERE position LIKE '%,%';

#Changing Datatype
ALTER TABLE spotify_streams
MODIFY COLUMN position INT;

#For better accuracy, the null values needs to be fixed, this is done by manually checking the information online and updating the data
UPDATE ultimate_album 
SET riaa_certification = '5x Platinum', grammys = 'Nominated' WHERE album = 'Un Verano Sin Ti' AND artist = 'Bad Bunny';
UPDATE ultimate_album 
SET riaa_certification = '3x Platinum', grammys = 'Nominated' WHERE album = 'Lemonade' AND artist = 'Beyoncé';
UPDATE ultimate_album 
SET riaa_certification = '2x Platinum', grammys = 'Nominated' WHERE album = 'Back to Black' AND artist = 'Amy Winehouse';
UPDATE ultimate_album 
SET riaa_certification = '< Gold', grammys = 'No' WHERE album = 'Hounds of Love' AND artist = 'Kate Bush';
UPDATE ultimate_album 
SET riaa_certification = '5x Platinum', grammys = 'No' WHERE album = 'Kind of Blue' AND artist = 'Miles Davis';
UPDATE ultimate_album 
SET riaa_certification = '5x Platinum', grammys = 'Nominated' WHERE album = 'Beyoncé' AND artist = 'Beyoncé';
UPDATE ultimate_album 
SET riaa_certification = '3x Platinum', grammys = 'No' WHERE album = 'Baduizm' AND artist = 'Erykah Badu';
UPDATE ultimate_album 
SET riaa_certification = 'Platinum', grammys = 'No' WHERE album = 'Supa Dupa Fly' AND artist = 'Missy Eliott';
UPDATE ultimate_album 
SET riaa_certification = '< Gold', grammys = 'No' WHERE album = 'Body Talk' AND artist = 'Robyn';
UPDATE ultimate_album 
SET riaa_certification = 'Gold', grammys = 'No' WHERE album = 'Homogenic' AND artist = 'Björk';
UPDATE ultimate_album 
SET riaa_certification = '6x Platinum', grammys = 'No' WHERE album = 'Anti' AND artist = 'Rihanna';
UPDATE ultimate_album 
SET riaa_certification = '4x Platinum', grammys = 'No' WHERE album = 'Love Deluxe' AND artist = 'Sade';
UPDATE ultimate_album 
SET riaa_certification = 'Platinum', grammys = 'Winner' WHERE album = 'Golden Hour' AND artist = 'Kacey Musgraves';
UPDATE ultimate_album 
SET riaa_certification = 'Gold', grammys = 'No' WHERE album = 'A Seat at the Table' AND artist = 'Solange';
UPDATE ultimate_album 
SET riaa_certification = 'Platinum', grammys = 'No' WHERE album = 'Highway 61 Revisited' AND artist = 'Bob Dylan';
UPDATE ultimate_album 
SET riaa_certification = 'Platinum', grammys = 'No' WHERE album = 'A Love Supreme' AND artist = 'John Coltrane';
UPDATE ultimate_album 
SET riaa_certification = 'Platinum', grammys = 'No' WHERE album = 'Pet Sounds' AND artist = 'The Beach Boys';
UPDATE ultimate_album 
SET riaa_certification = '5x Platinum', grammys = 'No' WHERE album = 'Revolver' AND artist = 'The Beatles';
UPDATE ultimate_album 
SET riaa_certification = '3x Platinum', grammys = 'No' WHERE album = 'My Beautiful Dark Twisted Fantasy' AND artist = 'Kanye West';
UPDATE ultimate_album 
SET riaa_certification = 'Gold', grammys = 'No' WHERE album = 'I Never Loved a Man the Way I Love You' AND artist = 'Aretha Franklin';
UPDATE ultimate_album 
SET riaa_certification = '5x Platinum', grammys = 'No' WHERE album = 'Are You Experienced' AND artist = 'The Jimi Hendrix Experience';
UPDATE ultimate_album 
SET riaa_certification = '3x Platinum', grammys = 'No' WHERE album = 'Aquemini' AND artist = 'OutKast';
UPDATE ultimate_album 
SET riaa_certification = 'Platinum', grammys = 'No' WHERE album = 'Blonde' AND artist = 'Frank Ocean';
UPDATE ultimate_album 
SET riaa_certification = '8x Platinum', grammys = 'No' WHERE album = 'Take Care' AND artist = 'Drake';
UPDATE ultimate_album 
SET riaa_certification = '12x Platinum', grammys = 'No' WHERE album = 'Led Zeppelin II' AND artist = 'Led Zeppelin';
UPDATE ultimate_album 
SET riaa_certification = '3x Platinum', grammys = 'Nominated' WHERE album = 'SOS' AND artist = 'SZA';
UPDATE ultimate_album 
SET riaa_certification = 'Platinum', grammys = 'No' WHERE album = 'Is This It' AND artist = 'The Strokes';
UPDATE ultimate_album 
SET riaa_certification = '3x Platinum', grammys = 'No' WHERE album = 'The Blueprint' AND artist = 'Jay-Z';
UPDATE ultimate_album 
SET riaa_certification = 'Platinum', grammys = 'No' WHERE album = 'Voodoo' AND artist = 'D\'Angelo';
UPDATE ultimate_album 
SET riaa_certification = '3x Platinum', grammys = 'Nominated' WHERE album = 'Good Kid, M.A.A.D City' AND artist = 'Kendrick Lamar';
UPDATE ultimate_album 
SET riaa_certification = '2x Platinum', grammys = 'No' WHERE album = 'After the Gold Rush' AND artist = 'Neil Young';
UPDATE ultimate_album 
SET riaa_certification = 'Platinum', grammys = 'Nominated' WHERE album = 'Kid A' AND artist = 'Radiohead';
UPDATE ultimate_album 
SET riaa_certification = 'Diamond (10x Platinum)', grammys = 'Winner' WHERE album = 'The Miseducation of Lauryn Hill' AND artist = 'Lauryn Hill';
UPDATE ultimate_album 
SET riaa_certification = 'Platinum', grammys = 'No' WHERE album = 'Blue' AND artist = 'Joni Mitchell';
UPDATE ultimate_album 
SET riaa_certification = 'Gold', grammys = 'No' WHERE album = 'What\'s Going On' AND artist = 'Marvin Gaye';
UPDATE ultimate_album 
SET riaa_certification = 'Gold', grammys = 'No' WHERE album = 'The Rise and Fall of Ziggy Stardust and the Spiders From Mars' AND artist = 'David Bowie';
UPDATE ultimate_album 
SET riaa_certification = 'Gold', grammys = 'No' WHERE album = 'Discovery' AND artist = 'Daft Punk';
UPDATE ultimate_album 
SET riaa_certification = '< Gold', grammys = 'Winner' WHERE album = 'Innervisions' AND artist = 'Stevie Wonder';
UPDATE ultimate_album 
SET riaa_certification = '8x Platinum', grammys = 'No' WHERE album = 'Goodbye Yellow Brick Road' AND artist = 'Elton John';
UPDATE ultimate_album 
SET riaa_certification = '< Gold', grammys = 'No' WHERE album = 'Horses' AND artist = 'Patti Smith';
UPDATE ultimate_album 
SET riaa_certification = '4x Platinum', grammys = 'No' WHERE album = 'Doggystyle' AND artist = 'Snoop Dogg';
UPDATE ultimate_album 
SET riaa_certification = '7x Platinum', grammys = 'No' WHERE album = 'Born to Run' AND artist = 'Bruce Springsteen';
UPDATE ultimate_album 
SET riaa_certification = '3x Platinum', grammys = 'No' WHERE album = 'AM' AND artist = 'Arctic Monkeys';
UPDATE ultimate_album 
SET riaa_certification = 'Diamond (10x Platinum)', grammys = 'Winner' WHERE album = 'Songs in the Key of Life' AND artist = 'Stevie Wonder';
UPDATE ultimate_album 
SET riaa_certification = '26x Platinum', grammys = 'Nominated' WHERE album = 'Hotel California' AND artist = 'Eagles';
UPDATE ultimate_album 
SET riaa_certification = '2x Platinum', grammys = 'No' WHERE album = 'Aja' AND artist = 'Steely Dan';
UPDATE ultimate_album 
SET riaa_certification = 'Gold', grammys = 'No' WHERE album = 'Exodus' AND artist = 'Bob Marley & The Wailers';
UPDATE ultimate_album 
SET riaa_certification = '< Gold', grammys = 'No' WHERE album = 'Trans-Europe Express' AND artist = 'Kraftwerk';
UPDATE ultimate_album 
SET riaa_certification = 'Diamond (10x Platinum)', grammys = 'No' WHERE album = 'All Eyez on Me' AND artist = '2Pac';
UPDATE ultimate_album 
SET riaa_certification = 'Platinum', grammys = 'No' WHERE album = 'London Calling' AND artist = 'The Clash';
UPDATE ultimate_album 
SET riaa_certification = '25x Platinum', grammys = 'No' WHERE album = 'Back in Black' AND artist = 'AC/DC';
UPDATE ultimate_album 
SET riaa_certification = 'Gold', grammys = 'No' WHERE album = 'Remain in Light' AND artist = 'Talking Heads';
UPDATE ultimate_album 
SET riaa_certification = '34x Platinum', grammys = 'Winner' WHERE album = 'Thriller' AND artist = 'Michael Jackson';
UPDATE ultimate_album 
SET riaa_certification = '13x Platinum', grammys = 'No' WHERE album = 'Purple Rain' AND artist = 'Prince & The Revolution';
UPDATE ultimate_album 
SET riaa_certification = '6× Platinum', grammys = 'No' WHERE album = 'Master of Puppets' AND artist = 'Metallica';
UPDATE ultimate_album 
SET riaa_certification = 'Gold', grammys = 'No' WHERE album = 'The Queen Is Dead' AND artist = 'The Smiths';
UPDATE ultimate_album 
SET riaa_certification = 'Platinum', grammys = 'No' WHERE album = 'Sign o\' the Times' AND artist = 'Prince';
UPDATE ultimate_album 
SET riaa_certification = '3× Platinum', grammys = 'No' WHERE album = 'Straight Outta Compton' AND artist = 'N.W.A';
UPDATE ultimate_album 
SET riaa_certification = '4× Platinum', grammys = 'No' WHERE album = 'Like a Prayer' AND artist = 'Madonna';
UPDATE ultimate_album 
SET riaa_certification = 'Platinum', grammys = 'No' WHERE album = '3 Feet High and Rising' AND artist = 'De La Soul';
UPDATE ultimate_album 
SET riaa_certification = '2× Platinum', grammys = 'No' WHERE album = 'Disintegration' AND artist = 'The Cure';
UPDATE ultimate_album 
SET riaa_certification = '2× Platinum', grammys = 'No' WHERE album = 'Paul\'s Boutique' AND artist = 'Beastie Boys';
UPDATE ultimate_album 
SET riaa_certification = 'Platinum', grammys = 'No' WHERE album = 'The Low End Theory' AND artist = 'A Tribe Called Quest';
UPDATE ultimate_album 
SET riaa_certification = '2× Platinum', grammys = 'No' WHERE album = 'Blue Lines' AND artist = 'Massive Attack';
UPDATE ultimate_album 
SET riaa_certification = '3× Platinum', grammys = 'No' WHERE album = 'The Chronic' AND artist = 'Dr. Dre';
UPDATE ultimate_album 
SET riaa_certification = '3× Platinum', grammys = 'No' WHERE album = 'Rage Against the Machine' AND artist = 'Rage Against the Machine';
UPDATE ultimate_album 
SET riaa_certification = '3× Platinum', grammys = 'No' WHERE album = 'My Life' AND artist = 'Mary J. Blige';
UPDATE ultimate_album 
SET riaa_certification = '6× Platinum', grammys = 'No' WHERE album = 'Ready to Die' AND artist = 'Notorious B.I.G.';
UPDATE ultimate_album 
SET riaa_certification = '2× Platinum', grammys = 'No' WHERE album = 'Illmatic' AND artist = 'Nas';
UPDATE ultimate_album 
SET riaa_certification = '4× Platinum', grammys = 'No' WHERE album = 'The Downward Spiral' AND artist = 'Nine Inch Nails';
UPDATE ultimate_album 
SET riaa_certification = 'Gold', grammys = 'No' WHERE album = 'Dummy' AND artist = 'Portishead';
UPDATE ultimate_album 
SET riaa_certification = '< Gold', grammys = 'No' WHERE album = '(What\'s the Story) Morning Glory?' AND artist = 'Oasis';
UPDATE ultimate_album 
SET riaa_certification = '2× Platinum', grammys = 'Nominated' WHERE album = 'OK Computer' AND artist = 'Radiohead';
UPDATE ultimate_album 
SET genre = 'Punk/Post-Punk/New Wave/Power Pop', artist_gender = 'Female' WHERE album = 'Pure Heroine' AND artist = 'Lorde';

