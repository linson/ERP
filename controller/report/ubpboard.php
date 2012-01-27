<?php
class ControllerReportUbpboard extends Controller{
	public function index(){
		$this->template = 'report/ubpboard.tpl';
		$this->children = array(
			'common/header',	
			'common/footer'	
		);
		$this->response->setOutput($this->render(TRUE), $this->config->get('config_compression'));
	}
}
?>