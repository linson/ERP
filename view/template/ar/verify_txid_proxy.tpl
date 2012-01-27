<?php
if(count($txid) == 0){
  echo '';
}else{
  echo json_encode($txid);
}
?>