<?php
class ControllerReportLog extends Controller {
	public function index(){
    $msg = isset($this->request->get['msg']) ? $this->request->get['msg'] : 'no msg' ;
    $logFile = DIR_LOGS . 'ajax.err';
    $fp = fopen($logFile, 'a');
    fwrite($fp,$msg);
    fclose($fp);
  }
}
?>
