UPDATE `enciclopedia` SET `desc` = REPLACE(`desc`, 'src="img/karier2.png"', 'src="/app/img/planet/bldK.png"') WHERE object_id = 23;
UPDATE `enciclopedia` SET `desc` = REPLACE(`desc`, 'src="img/dispancer2.png"', 'src="/app/img/planet/bldP.png"') WHERE object_id = 24;
UPDATE `enciclopedia` SET `desc` = REPLACE(`desc`, 'src="img/laboratory_2.png"', 'src="/app/img/planet/bldL.png"') WHERE object_id = 25;
UPDATE `enciclopedia` SET `desc` = REPLACE(`desc`, 'src="img/capsule.png"', 'src="/app/img/planet/bldC.png"') WHERE object_id = 26;
UPDATE `enciclopedia` SET `desc` = REPLACE(`desc`, 'src="img/rocket.png"', 'src="/app/img/planet/bldD.png"') WHERE object_id = 27;
UPDATE `enciclopedia` SET `desc` = REPLACE(`desc`, 'src="img/laser.png"', 'src="/app/img/planet/bldH.png"') WHERE object_id = 28;
UPDATE `enciclopedia` SET `desc` = REPLACE(`desc`, 'src="img/plasma.png"', 'src="/app/img/planet/bldJ.png"') WHERE object_id = 29;
UPDATE `enciclopedia` SET `desc` = REPLACE(`desc`, 'src="img/maser.png"', 'src="/app/img/planet/bldN.png"') WHERE object_id = 30;
UPDATE `enciclopedia` SET `desc` = REPLACE(`desc`, 'src="img/shield.png"', 'src="/app/img/planet/bldU.png"') WHERE object_id = 31;
UPDATE `enciclopedia` SET `desc` = REPLACE(`desc`, 'src="img/factory2.png"', 'src="/app/img/planet/bldF.png"') WHERE object_id = 33;
UPDATE `enciclopedia` SET `desc` = REPLACE(`desc`, 'src="img/electro_2.png"', 'src="/app/img/planet/bldE.png"') WHERE object_id = 34;
UPDATE `enciclopedia` SET `desc` = REPLACE(`desc`, 'src="img/mine2.png"', 'src="/app/img/planet/bldM.png"') WHERE object_id = 36;
UPDATE `enciclopedia` SET `desc` = REPLACE(`desc`, 'src="img/burovaya_2.png"', 'src="/app/img/planet/bldO.png"') WHERE object_id = 37;
UPDATE `enciclopedia` SET `desc` = REPLACE(`desc`, 'src="img/silo.png"', 'src="/app/img/planet/bldS.png"') WHERE object_id = 38;
UPDATE `enciclopedia` SET `desc` = REPLACE(`desc`, 'src="img/asemble2.png"', 'src="/app/img/planet/bldR.png"') WHERE object_id = 39;

UPDATE `enciclopedia` SET `desc` = REPLACE(`desc`, 'src="img/geosat.png"', 'src="/app/img/orbit/bldG.png"') WHERE object_id = 3002;
UPDATE `enciclopedia` SET `desc` = REPLACE(`desc`, 'src="img/power.png"', 'src="/app/img/orbit/bldA.png"') WHERE object_id = 3003;
UPDATE `enciclopedia` SET `desc` = REPLACE(`desc`, 'src="img/warehouse.png"', 'src="/app/img/orbit/bldI.png"') WHERE object_id = 3004;
UPDATE `enciclopedia` SET `desc` = REPLACE(`desc`, 'src="img/orbfactory.png"', 'src="/app/img/orbit/bldQ.png"') WHERE object_id = 3005;
UPDATE `enciclopedia` SET `desc` = REPLACE(`desc`, 'src="img/orbmine.png"', 'src="/app/img/orbit/bldW.png"') WHERE object_id = 3006;
UPDATE `enciclopedia` SET `desc` = REPLACE(`desc`, 'src="img/orb_laser.png"', 'src="/app/img/orbit/bldV.png"') WHERE object_id = 3007;
UPDATE `enciclopedia` SET `desc` = REPLACE(`desc`, 'src="img/orb_plasma.png"', 'src="/app/img/orbit/bldX.png"') WHERE object_id = 3008;
UPDATE `enciclopedia` SET `desc` = REPLACE(`desc`, 'src="img/orb_quant.png"', 'src="/app/img/orbit/bldY.png"') WHERE object_id = 3009;
UPDATE `enciclopedia` SET `desc` = REPLACE(`desc`, 'src="img/orb_termo.png"', 'src="/app/img/orbit/bldZ.png"') WHERE object_id = 3010;

UPDATE `enciclopedia`
   SET `desc` = CONCAT('<img src="/app/img/orbit/bldT.png">', `desc`)
 WHERE object_id = 3001 AND `desc` NOT LIKE '%<img%';

UPDATE `buildings` SET `pic` = 'planet/bldC.png' WHERE id = 26;
UPDATE `buildings` SET `pic` = 'planet/bldK.png' WHERE id = 23;
UPDATE `buildings` SET `pic` = 'planet/bldP.png' WHERE id = 24;
UPDATE `buildings` SET `pic` = 'planet/bldL.png' WHERE id = 25;
UPDATE `buildings` SET `pic` = 'planet/bldD.png' WHERE id = 27;
UPDATE `buildings` SET `pic` = 'planet/bldH.png' WHERE id = 28;
UPDATE `buildings` SET `pic` = 'planet/bldJ.png' WHERE id = 29;
UPDATE `buildings` SET `pic` = 'planet/bldN.png' WHERE id = 30;
UPDATE `buildings` SET `pic` = 'planet/bldU.png' WHERE id = 31;
UPDATE `buildings` SET `pic` = 'planet/bldF.png' WHERE id = 33;
UPDATE `buildings` SET `pic` = 'planet/bldE.png' WHERE id = 34;
UPDATE `buildings` SET `pic` = 'planet/bldM.png' WHERE id = 36;
UPDATE `buildings` SET `pic` = 'planet/bldO.png' WHERE id = 37;
UPDATE `buildings` SET `pic` = 'planet/bldS.png' WHERE id = 38;
UPDATE `buildings` SET `pic` = 'planet/bldR.png' WHERE id = 39;
UPDATE `buildings` SET `pic` = 'orbit/bldT.png' WHERE id = 3001;
UPDATE `buildings` SET `pic` = 'orbit/bldG.png' WHERE id = 3002;
UPDATE `buildings` SET `pic` = 'orbit/bldA.png' WHERE id = 3003;
UPDATE `buildings` SET `pic` = 'orbit/bldI.png' WHERE id = 3004;
UPDATE `buildings` SET `pic` = 'orbit/bldQ.png' WHERE id = 3005;
UPDATE `buildings` SET `pic` = 'orbit/bldW.png' WHERE id = 3006;
UPDATE `buildings` SET `pic` = 'orbit/bldV.png' WHERE id = 3007;
UPDATE `buildings` SET `pic` = 'orbit/bldX.png' WHERE id = 3008;
UPDATE `buildings` SET `pic` = 'orbit/bldY.png' WHERE id = 3009;
UPDATE `buildings` SET `pic` = 'orbit/bldZ.png' WHERE id = 3010;

UPDATE `enciclopedia` e
  INNER JOIN (
    SELECT 5010 AS object_id, 0 AS tile UNION ALL
    SELECT 5000, 1 UNION ALL SELECT 5005, 2 UNION ALL SELECT 5007, 3 UNION ALL SELECT 5032, 4 UNION ALL
    SELECT 5012, 5 UNION ALL SELECT 5015, 6 UNION ALL SELECT 5019, 7 UNION ALL SELECT 5018, 8 UNION ALL SELECT 5060, 9
  ) m ON m.object_id = e.object_id
   SET e.`desc` = CONCAT('<img src="/app/img/planet/jpeg', m.tile, '.png">', e.`desc`)
 WHERE e.`desc` NOT LIKE '%<img%';
