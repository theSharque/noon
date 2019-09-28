<?php

if (!defined('_SAPE_USER')){
  define('_SAPE_USER', '2ecff8ad8e254025ba7b1b60741e1f37'); 
}
require_once($_SERVER['DOCUMENT_ROOT'].'/'._SAPE_USER.'/sape.php'); 

/*
$o['force_show_code'] = true;
$sape = new SAPE_client($o);
*/

$sape = new SAPE_client();
$sape_article = new SAPE_articles();

//echo $sape->return_links();
echo $sape->return_block_links();
