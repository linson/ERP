<?php
class ControllerCronOem extends Controller {
 	public function index() {

    $this->load->model('product/oem');
		$this->getList();
 	}

  private function getList() {
    $mail = new Mail();
	  $mail->protocol = $this->config->get('config_mail_protocol');
	  $mail->hostname = $this->config->get('config_smtp_host');
	  $mail->username = $this->config->get('config_smtp_username');
	  $mail->password = $this->config->get('config_smtp_password');
	  $mail->port = $this->config->get('config_smtp_port');
	  $mail->timeout = $this->config->get('config_smtp_timeout');							

		$this->load->model('product/oem');
		$products = $this->model_product_oem->getUnderThres();
		//print($this->export_qry);
    $date = date('YmdHis');
    echo phpinfo();
    echo $date; exit;

    $body = "Below Product at Risk !! \n\n";
    $sum = 0;
		foreach ($products as $product) {  
		  $model = $product['model'];
		  $name  = $product['name'];
		  $quantity = $product['quantity'];
		  $thres = $product['thres'];
		  $body .= "$model :: $quantity/$thres :: $name \n";
		  $sum++;
		}
    $subject = "SMS TEST -> Inventory Alert ($date) (count:$sum)";
    $aReceiver = array( 'besso@live.com','ubp-jp@yahoo.com');
    foreach($aReceiver as $receiver){
		  $mail->setTo($receiver);
		  $mail->setFrom($this->config->get('config_email'));
		  $mail->setSender('Inventory Alert');
		  $mail->setSubject($subject);
		  $mail->setText(html_entity_decode($body, ENT_QUOTES, 'UTF-8'));
		  //$mail->send();
    }
/***
бсAT&T: number@txt.att.net
бсQwest: number@qwestmp.com
бсT-Mobile: number@tmomail.net
бсVerizon: number@vtext.com
бсSprint: number@messaging.sprintpcs.com or number@pm.sprint.com
бсVirgin Mobile: number@vmobl.com
бсNextel: number@messaging.nextel.com
бсAlltel: number@message.alltel.com
бсMetro PCS: number@mymetropcs.com
бсPowertel: number@ptel.com
бсSuncom: number@tms.suncom.com
бсU.S. Cellular: number@email.uscc.net
***/
    $aReceiver = array('8473707009@vtext.com','8473028759@vtext.com');
    foreach($aReceiver as $receiver){
		  $body = '';
		  foreach ($products as $product) {  
		    $model = $product['model'];
		    $name  = $product['name'];
		    $quantity = $product['quantity'];
		    $thres = $product['thres'];
		    $body .= "$model,";
		    $sum++;
		  }
		  $mail->setTo($receiver);
		  $mail->setFrom($this->config->get('config_email'));
		  $mail->setSender('Inventory Alert');
		  $mail->setSubject($subject);
		  $mail->setText(html_entity_decode($body, ENT_QUOTES, 'UTF-8'));
		  $mail->send();
		}
 	}
}
?>