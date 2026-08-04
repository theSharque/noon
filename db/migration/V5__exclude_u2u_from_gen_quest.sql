-- u2u hire templates must not be spawned by gen_quest into the public quest pool.
UPDATE quest_types
   SET cnt = 0
 WHERE type IN (SELECT id FROM u2u_types);

DELETE uc
  FROM users_quests uc
  LEFT JOIN u2u_quests u2 ON u2.event_id = uc.id
 WHERE uc.type IN (SELECT id FROM u2u_types)
   AND uc.user_id IS NULL
   AND u2.event_id IS NULL;
