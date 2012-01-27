<?php 
class ControllerToolUtil extends Controller { 
	
	public function index(){}
	
	public function gsi(){
    echo json_encode($this->session->data['token']);
	}
	
}
?>