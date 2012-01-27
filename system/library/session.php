<?php
final class Session {
	public $data = array();
	public $token = '';
			
  public function __construct(){
		if(!session_id()){
			ini_set('session.use_cookies', 'On');
			ini_set('session.use_trans_sid', 'Off');
		
			session_set_cookie_params(0, '/');
			session_start();
		}
    /**
		echo '<pre>';
    print_r($_SESSION);
		echo '<pre>';
		**/
		$this->data =& $_SESSION;
		//$this->token = $this->data['token'];
	}
	
}
?>