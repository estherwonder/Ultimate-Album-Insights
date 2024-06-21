LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/rolling_stone.csv'
INTO TABLE bestalbum.rollingstone
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(@clean_name, @album, @rank_2003, @rank_2012, @rank_2020, @differential, @release_year, @genre, @weeks_on_billboard, @peak_billboard_position, @spotify_popularity, @artist_member_count, @artist_gender, @artist_birth_year_sum, @debut_album_release_year, @ave_age_at_top_500, @years_between)
SET
    clean_name = (CASE WHEN @clean_name = '' THEN NULL ELSE @clean_name END),
    album = (CASE WHEN @album = '' THEN NULL ELSE @album END),
    rank_2003 = (CASE WHEN @rank_2003 = '' THEN NULL ELSE @rank_2003 END),
    rank_2012 = (CASE WHEN @rank_2012 = '' THEN NULL ELSE @rank_2012 END),
    rank_2020 = (CASE WHEN @rank_2020 = '' THEN NULL ELSE @rank_2020 END),
	differential = (CASE WHEN @differential = '' THEN NULL ELSE @differential END),
    release_year = (CASE WHEN @release_year = '' THEN NULL ELSE @release_year END),
    genre = (CASE WHEN @genre = '' THEN NULL ELSE @genre END),
    weeks_on_billboard = (CASE WHEN @weeks_on_billboard = '' THEN NULL ELSE @weeks_on_billboard END),
    peak_billboard_position = (CASE WHEN @peak_billboard_position = '' THEN NULL ELSE @peak_billboard_position END),
    spotify_popularity = (CASE WHEN @spotify_popularity = '' THEN NULL ELSE @spotify_popularity END),
    artist_member_count = (CASE WHEN @artist_member_count = '' THEN NULL ELSE @artist_member_count END),
    artist_gender = (CASE WHEN @artist_gender = '' THEN NULL ELSE @artist_gender END),
    artist_birth_year_sum = (CASE WHEN @artist_birth_year_sum = '' THEN NULL ELSE @artist_birth_year_sum END),
    debut_album_release_year = (CASE WHEN @debut_album_release_year = '' THEN NULL ELSE @debut_album_release_year END),
    ave_age_at_top_500 = (CASE WHEN @ave_age_at_top_500 = '' THEN NULL ELSE @ave_age_at_top_500 END),
    years_between = (CASE WHEN @years_between = '' THEN NULL ELSE @years_between END)
;

ALTER TABLE bestalbum.rollingstone
MODIFY COLUMN genre VARCHAR(255);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Most streamed albums on Spotify.csv'
INTO TABLE bestalbum.spotifystreams
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(@Position, @Album, @Artists, @Total, @Daily)
SET
    Position = (CASE WHEN @Position = '' THEN NULL ELSE @Position END),
    Album = (CASE WHEN @Album = '' THEN NULL ELSE @Album END),
    Artists = (CASE WHEN @Artists = '' THEN NULL ELSE @Artists END),
    Total = (CASE WHEN @Total = '' THEN NULL ELSE @Total END),
    Daily = (CASE WHEN @Daily = '' THEN NULL ELSE @Daily END)
;

ALTER TABLE bestalbum.spotifystreams
MODIFY COLUMN Total BIGINT,
MODIFY COLUMN Daily BIGINT;
ALTER TABLE bestalbum.spotify_streams CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
ALTER TABLE bestalbum.spotify_streams MODIFY COLUMN Position VARCHAR(10);

