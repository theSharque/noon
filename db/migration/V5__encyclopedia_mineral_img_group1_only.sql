UPDATE `enciclopedia`
   SET `desc` = SUBSTRING(`desc`, LOCATE('<b>', `desc`))
 WHERE object_id IN (
   5035, 5002, 5006, 5011, 5008, 5020, 5021, 5043, 5003, 5027,
   5029, 5038, 5041, 5039, 5048, 5058, 5057, 5034, 5056, 5044
 )
   AND `desc` LIKE '<img %'
   AND LOCATE('<b>', `desc`) > 0;
