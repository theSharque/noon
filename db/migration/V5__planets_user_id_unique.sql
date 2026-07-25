UPDATE planets p
  INNER JOIN users u ON u.id = p.user_id AND u.place_id = p.id
  INNER JOIN planets extra ON extra.user_id = u.id AND extra.id <> p.id
   SET extra.user_id = NULL;

UPDATE planets p
  INNER JOIN (
    SELECT user_id, MIN(id) keep_id
      FROM planets
     WHERE user_id IS NOT NULL
     GROUP BY user_id
    HAVING COUNT(*) > 1
  ) d ON p.user_id = d.user_id AND p.id <> d.keep_id
   SET p.user_id = NULL;

ALTER TABLE planets DROP INDEX by_user;
ALTER TABLE planets ADD UNIQUE INDEX by_user (user_id);
