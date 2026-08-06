-- Rebalance linсor + stormtrooper lines.
-- Ladder: fighters < corvette/frigate < linсors < stormtroopers.
-- ЛС / ШС = confederate premium, best in line.
-- Combat cargo capped below БШ (9475) / ГПТ (6333).

-- Линкор
UPDATE ship_types
   SET shield = 3200, cargo = 2800, w_power = 16, w_count = 12, w_sum = 192
 WHERE object_id = 9053;

-- Линкор-М (DPS sibling @900)
UPDATE ship_types
   SET shield = 3000, cargo = 1600, w_power = 80, w_count = 5, w_sum = 400
 WHERE object_id = 9072;

-- Линкор-Т (quantum beam w_count=0, charges to w_power)
UPDATE ship_types
   SET shield = 3100, cargo = 1200, w_power = 450, w_count = 0, w_sum = 450
 WHERE object_id = 9077;

-- Линкор-С (confederate premium — best linсor)
UPDATE ship_types
   SET shield = 5200, cargo = 3500, w_power = 300, w_count = 6, w_sum = 1800
 WHERE object_id = 9275;

-- Линкор Корсаров (mirror Л)
UPDATE ship_types
   SET shield = 3200, cargo = 2800, w_power = 16, w_count = 12, w_sum = 192
 WHERE object_id = 9329;

-- Штурмовик (planetary tank entry)
UPDATE ship_types
   SET shield = 4500, cargo = 800, w_power = 20, w_count = 4, w_sum = 80
 WHERE object_id = 9136;

-- Штурмовик М
UPDATE ship_types
   SET shield = 4000, cargo = 900, w_power = 250, w_count = 4, w_sum = 1000
 WHERE object_id = 9287;

-- Штурмовик Т (glass DPS)
UPDATE ship_types
   SET shield = 3000, cargo = 400, w_power = 450, w_count = 4, w_sum = 1800
 WHERE object_id = 9290;

-- Штурмовик странников (confederate premium — best stormtrooper)
UPDATE ship_types
   SET shield = 7000, cargo = 1800, w_power = 500, w_count = 5, w_sum = 2500
 WHERE object_id = 9206;

-- Штурмовик корсаров (mirror ШМ)
UPDATE ship_types
   SET shield = 4000, cargo = 900, w_power = 250, w_count = 4, w_sum = 1000
 WHERE object_id = 9332;

-- Scale live hull HP to new max (preserve damage ratio; full HP → full new max)
UPDATE ships s
  INNER JOIN ship_types st ON st.object_id = s.object_id
  INNER JOIN (
    SELECT 9053 AS object_id, 3141 AS old_shield UNION ALL
    SELECT 9072, 3158 UNION ALL
    SELECT 9077, 3261 UNION ALL
    SELECT 9275, 3781 UNION ALL
    SELECT 9329, 3141 UNION ALL
    SELECT 9136, 6048 UNION ALL
    SELECT 9287, 8064 UNION ALL
    SELECT 9290, 6048 UNION ALL
    SELECT 9206, 10000 UNION ALL
    SELECT 9332, 8064
  ) old ON old.object_id = s.object_id
   SET s.shield = LEAST(
     st.shield,
     GREATEST(0, ROUND(s.shield * st.shield / NULLIF(old.old_shield, 0)))
   )
 WHERE s.object_id IN (9053, 9072, 9077, 9275, 9329, 9136, 9287, 9290, 9206, 9332);
