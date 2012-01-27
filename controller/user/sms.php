<?php
class ControllerUserSms extends Controller {
	private $error = array();
	private $bManager = false;
	private $sms_content = '';

 	public function index(){
    $this->bManager = false;
    if('manager' == $this->user->getGroupName($this->user->getUserName()) ){
      $this->bManager = true;
    }
    $this->sms_content = '';
    $this->data['bManager'] = $this->bManager;
		$this->getList();
  }

  // ajax proxy call
  public function getList(){

		if(isset($this->session->data['success'])){
			$this->data['success'] = $this->session->data['success'];
			unset($this->session->data['success']);
		}else{
			$this->data['success'] = '';
		}

    $sales = $this->user->getAllSales();
    $this->data['sales'] = $sales;
    $this->data['token'] = $this->session->data['token'];

  	if( isset($this->request->post['selected']) ){
    	for($i=0; $i<count($sales); $i++){
      	if( in_array($sales[$i]['user_id'], $this->request->post['selected']) ){
      	  $sales[$i]['selected'] = true;
      	}else{
      	  $sales[$i]['selected'] = false;
      	}
      }
    }

		$this->data['sms_content'] = $this->sms_content;
		$this->data['lnk_sms'] = HTTP_SERVER . 'index.php?route=user/sms/sms&token=' . $this->session->data['token'];

    # call view
    $this->template = 'user/sms.tpl';
		$this->children = array(
			'common/header',
			'common/footer'
		);
		$this->response->setOutput($this->render(TRUE), $this->config->get('config_compression'));
  }

  public function sms(){
		$sms_content =  $this->request->post['sms_content'];
		//$this->log->aPrint( $sms_content );
		if( $sms_content == '' ){
  		$this->session->data['success'] = "No Message !";
	   	$this->getList();
		}

		$smsList =  isset($this->request->post['selected']) ? $this->request->post['selected'] : array();
		if( count($smsList) == 0 ){
  		$this->session->data['success'] = "Please choose User !";
	   	$this->getList();
		}
		$aReceiver = array();
		foreach($smsList as $row){
		  $recv = trim($row) . '@vtext.com';
      $aReceiver[] = $recv;
		}

//		$aReceiver = array('besso@live.com');

    $mail = new Mail();
	  $mail->protocol = $this->config->get('config_mail_protocol');
	  $mail->hostname = $this->config->get('config_smtp_host');
	  $mail->username = $this->config->get('config_smtp_username');
	  $mail->password = $this->config->get('config_smtp_password');
	  $mail->port = $this->config->get('config_smtp_port');
	  $mail->timeout = $this->config->get('config_smtp_timeout');
    $aExt = array(
      'JP'=>'202',
      'CS'=>'223',
      'WH'=>'227',
      'AK'=>'205',
      'BL'=>'222',
      'YK'=>'206',
      'BJ'=>'203',
      'KH'=>'221',
      'HL'=>'227',
      'pchoe'=>'201',
      'HY'=>'283',
      'YU'=>'282',
      'monica'=>'293',
      'kim'=>'211',
      'cho'=>'212',
      'yang'=>'213',
    );
    $usr = $this->user->getUserName();
    $ext = isset($aExt[$usr]) ? $aExt[$usr] : '' ;
    $subject = $ext . " " . $this->user->getUserName();
    //$this->log->aPrint( $subject );
    $body = $sms_content;

    foreach($aReceiver as $receiver){
		  $mail->setTo($receiver);
		  $mail->setFrom($this->config->get('config_email'));
		  $mail->setSender('UBP');
		  $mail->setSubject($subject);
		  $mail->setText(html_entity_decode($body, ENT_QUOTES, 'UTF-8'));
		  $mail->send();
    }
   	$this->session->data['success'] = "Send Well : " . $body;
   	$this->getList();
 	}

  public function add_date($givendate,$day=0,$mth=0,$yr=0){
    $givendate = $givendate. ' 00:00:00';
    $cd = strtotime($givendate);
    $newdate = date('Y-m-d', mktime(date('h',$cd),
                    date('i',$cd), date('s',$cd), date('m',$cd)+$mth,
                    date('d',$cd)+$day, date('Y',$cd)+$yr));
    return $newdate;
  }
}
?>