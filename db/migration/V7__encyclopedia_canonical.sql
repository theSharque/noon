-- Encyclopedia: canonical texts on live ships (4) and parts (2); drop stub enc on kits/makets/blueprints.

INSERT INTO enciclopedia (object_id, `desc`)
SELECT st.object_id, e.`desc`
  FROM ship_types st
  INNER JOIN objects_sub os ON os.object_id = st.conserv_id
  INNER JOIN objects m ON m.id = os.res_id AND m.class = 7
  INNER JOIN enciclopedia e ON e.object_id = m.id
  INNER JOIN objects o ON o.id = st.object_id AND o.class = 4
  LEFT JOIN enciclopedia e4 ON e4.object_id = st.object_id
 WHERE e4.object_id IS NULL;

INSERT INTO enciclopedia (object_id, `desc`)
SELECT os.object_id, e.`desc`
  FROM objects_sub os
  INNER JOIN objects part ON part.id = os.object_id AND part.class = 2
  INNER JOIN objects bp ON bp.id = os.res_id AND bp.class = 6
  INNER JOIN enciclopedia e ON e.object_id = bp.id
  LEFT JOIN enciclopedia e2 ON e2.object_id = part.id
 WHERE e2.object_id IS NULL;

DELETE e
  FROM enciclopedia e
  INNER JOIN objects o ON o.id = e.object_id
 WHERE o.class IN (6, 7, 9);
