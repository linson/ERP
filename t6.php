<?php
$content = file_get_contents('http://kr.yahoo.com');
$txid = '"aaaaaa"';
$txid = str_replace('"','',$txid); 
echo $txid;
?>
