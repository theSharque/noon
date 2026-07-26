UPDATE objects SET soldable = 1
 WHERE class = 2
   AND name NOT LIKE '%одарок%'
   AND name NOT LIKE '%мороз%';

UPDATE objects SET soldable = 0
 WHERE class = 2
   AND (name LIKE '%одарок%' OR name LIKE '%мороз%');
