USE bestalbum;
#the task here is to connect the albums that are common to two or three greatest album list i.e Billboard, Apple and Rolling stone
#Creating the table to combine all the albums that appeared in either 3 or 2 list as the ultimate album
DROP TABLE ultimate_album;
CREATE TABLE ultimate_album (
    album VARCHAR(255),
    artist VARCHAR(255),
    album_year YEAR,
    riaa_certification VARCHAR(255),
    grammys VARCHAR(255),
    genre VARCHAR(255),
    artist_gender VARCHAR(255),
    peak_position INT,
    appearance_in_list INT,
    rolling_stone VARCHAR(255),
    apple_top_album VARCHAR(255),
    billboard_200 VARCHAR(255)
);
#Inserting the result gotten by joining the three tables together and checking for the albums that are present in all three
INSERT INTO ultimate_album (album, artist, album_year, riaa_certification, grammys, genre, artist_gender, peak_position, appearance_in_list, rolling_stone, apple_top_album, billboard_200)
SELECT 
	a.album AS album,
    a.artist AS artist,
    b.album_year AS album_year,
    b.riaa_certification AS riaa_certification,
    b.grammys AS grammys,
    r.genre AS genre,
    r.artist_gender AS artist_gender,
    r.peak_billboard_position AS peak_position,
    #Creating new column to indicate the list the album belongs to and how many list they can be found
    CASE
        WHEN r.album IS NOT NULL AND b.album IS NOT NULL AND a.album IS NOT NULL THEN 3
        ELSE 0
    END AS appearance_in_list,
    CASE WHEN r.album IS NOT NULL THEN 'YES' ELSE 'NO' END AS rolling_stone,
    CASE WHEN a.album IS NOT NULL THEN 'YES' ELSE 'NO' END AS apple_top_album,
    CASE WHEN b.album IS NOT NULL THEN 'YES' ELSE 'NO' END AS billboard_200
FROM
    rolling_stone r
		JOIN
    billboard_200 b ON r.album = b.album
    AND r.album_year = b.album_year
        JOIN
    apple_top_album a ON r.album = a.album
    AND r.album_year = a.album_year;
    
#This query is focused on combining apple_top_album and billboard to distinctly select the albums found in both list
INSERT INTO ultimate_album (album, artist, album_year, riaa_certification, grammys, genre, artist_gender, peak_position, appearance_in_list, rolling_stone, apple_top_album, billboard_200)
SELECT 
    a.album AS album,
    a.artist AS artist,
    a.album_year AS album_year,
    b.riaa_certification AS riaa_certification,
    b.grammys AS grammys,
    NULL AS genre,
    NULL AS artist_gender,
    b.peak_position AS peak_position,
    CASE 
        WHEN a.album IS NOT NULL AND b.album IS NOT NULL THEN 2
        ELSE 1
    END AS appearance_in_list,
    CASE WHEN rolling_stone IS NOT NULL THEN 'YES' ELSE 'NO' END AS rolling_stone,
    CASE WHEN a.album IS NOT NULL THEN 'YES' ELSE 'NO' END AS apple_top_album,
    CASE WHEN b.album IS NOT NULL THEN 'YES' ELSE 'NO' END AS billboard_200
FROM
    billboard_200 b
    JOIN apple_top_album a ON b.album = a.album AND b.album_year = a.album_year
#The left join is used to filter the album and artist present in the ultimate_album from duplicating 
    LEFT JOIN ultimate_album u ON a.album = u.album AND a.artist = u.artist
WHERE
    u.album IS NULL AND u.artist IS NULL;
    
#This query is focused on combining apple_top_album and rolling_stone to distinctly select the albums found in both list   
INSERT INTO ultimate_album (album, artist, album_year, riaa_certification, grammys, genre, artist_gender, peak_position, appearance_in_list, rolling_stone, apple_top_album, billboard_200)	
SELECT 
    a.album AS album,
    a.artist AS artist,
    a.album_year AS album_year,
    NULL AS riaa_certification,
    NULL AS grammys,
    r.genre,
    r.artist_gender,
    r.peak_billboard_position AS peak_position,
    CASE
        WHEN
            a.album IS NOT NULL
                AND r.album IS NOT NULL
        THEN
            2
        ELSE 1
    END AS appearance_in_list,
    CASE
        WHEN r.album IS NOT NULL THEN 'YES'
        ELSE 'NO'
    END AS rolling_stone,
    CASE
        WHEN a.album IS NOT NULL THEN 'YES'
        ELSE 'NO'
    END AS apple_top_album,
    CASE
        WHEN billboard_200 IS NOT NULL THEN 'YES'
        ELSE 'NO'
    END AS billboard_200
FROM
    rolling_stone r
        JOIN
    apple_top_album a ON r.album = a.album
        AND r.album_year = a.album_year
        LEFT JOIN
    ultimate_album u ON a.album = u.album
        AND a.artist = u.artist
WHERE
    u.album IS NULL AND u.artist IS NULL;
 
 #This query is focused on combining billboard_200 and rolling_stone to distinctly select the albums found in both list   
INSERT INTO ultimate_album (album, artist, album_year, riaa_certification, grammys, genre, artist_gender, peak_position, appearance_in_list, rolling_stone, apple_top_album, billboard_200)
SELECT 
	b.album AS album,
    b.artist AS artist,
    b.album_year AS album_year,
	b.riaa_certification AS riaa_certification,
    b.grammys AS grammys,
    r.genre AS genre,
    r.artist_gender AS artist_gender,
    r.peak_billboard_position AS peak_position,
    CASE 
        WHEN b.album IS NOT NULL AND r.album IS NOT NULL THEN 2
        ELSE 1
    END AS appearance_in_list,
    CASE WHEN r.album IS NOT NULL THEN 'YES' ELSE 'NO' END AS rolling_stone,
    CASE WHEN apple_top_album IS NOT NULL THEN 'YES' ELSE 'NO' END AS apple_top_album,
    CASE WHEN b.album IS NOT NULL THEN 'YES' ELSE 'NO' END AS billboard_200
FROM
    rolling_stone r
        JOIN
    billboard_200 b ON r.album = b.album
    AND r.album_year = b.album_year
    LEFT JOIN
    ultimate_album u ON b.album = u.album
        AND b.artist = u.artist
WHERE
    u.album IS NULL AND u.artist IS NULL;

   
## Adding the spotify_streams column to ultimate_album 
ALTER TABLE ultimate_album ADD COLUMN spotify_streams BIGINT;

### Update the spotify_streams column with values from spotify_streams table
UPDATE ultimate_album u
LEFT JOIN spotify_streams s ON u.album = s.album_name AND u.artist = s.artist_name
SET u.spotify_streams = CASE 
    WHEN s.total_streams IS NULL THEN 0 ELSE s.total_streams
END;

#Creating ultimate_album column to check if the grammy winners are part of the greatest album or not   
SELECT 
	g.album_name ,
    g.artist_name,
    g.country,
    g.ethnicity,
    CASE 
        WHEN u.album IS NULL THEN 'NO'
        ELSE 'YES' 
	END AS ultimate_album 
FROM
    grammys g
       LEFT JOIN
    ultimate_album u ON g.album_name = u.album AND g.artist_name = u.artist;

    