<?php
class ControllerCronCron extends Controller {
  // index.php?route=cron/cron/storeList
 	public function storeList(){
    $this->load->model('store/store');
    $aStore = $this->model_store_store->storeList();
    //$this->log->aPrint( $aStore);
    
    $file = $_SERVER["DOCUMENT_ROOT"]."/backyard/data/store.list";
    unlink($file);
    $handle = @fopen($file,'a');
    foreach($aStore as $store){
      if(fwrite($handle,$store['accountno'] . "\n") === FALSE){
        echo "Cannot write to file ($file)";
        exit;
      }
      
    }
    fclose($handle);
 	}
}
?>