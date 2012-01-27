<?php
class ControllerReportValidation extends Controller{
	public function index(){
    $filter_from   = $this->util->parseRequest('filter_from','get',date("Y-m-d"));
    $filter_to     = $this->util->parseRequest('filter_to','get',date("Y-m-d"));
    $this->data['filter_from'] = $filter_from;
		$this->data['filter_to'] = $filter_to;

		$this->load->model('report/sale');
		$request = array(
		  'filter_from' => $filter_from,
		  'filter_to' => $filter_to,
		);
		$response = $this->model_report_sale->validate($request);
		if( count($response) > 0 ){
      $mail = new Mail();
  	  $mail->protocol = $this->config->get('config_mail_protocol');
  	  $mail->hostname = $this->config->get('config_smtp_host');
  	  $mail->username = $this->config->get('config_smtp_username');
  	  $mail->password = $this->config->get('config_smtp_password');
  	  $mail->port = $this->config->get('config_smtp_port');
  	  $mail->timeout = $this->config->get('config_smtp_timeout');

      $subject = 'Alert!!! ' . date('m-d h:i');
      $body = '';
      foreach($response as $row){
        $body .= $row['txid'] . ' ' . $row['tx_price'] . '  ' . $row['sale_price'] . "  " . $row['store_discount'] . "\n";
      }
      //$this->log->aPrint( $subject );
      //$this->log->aPrint( $body );
      $aReceiver = array(
        'besso@live.com',
        '8472392086@VTEXT.COM',
      );

      //$receiver = $aReceiver[0];
      //$this->log->aPrint( $receiver );
      foreach($aReceiver as $receiver){
    	  $mail->setTo($receiver);
    	  $mail->setFrom($this->config->get('config_email'));
    	  $mail->setSender('besso@live.com');
    	  $mail->setSubject($subject);
        $mail->setText($body);
    	  $mail->send();
    	}
		}
  }
}
?>