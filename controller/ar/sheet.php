<?php
/***
todo. need to make list button
***/

class ControllerArSheet extends Controller{

 	public function index(){
   	$this->getList($this->request->get['id']);
  }

  // order form
  private function getList($id){
    $this->load->model('ar/detail');

    isset($this->error['warning']) ? $this->data['error_warning'] = $this->error['warning'] : $this->data['error_warning'] = '';
		isset($this->request->get['page']) ?	$page = $this->request->get['page'] : $page = 1;
   	$this->data['token']    = $this->session->data['token'];

		# custom
    $this->data['id'] = $id;
		$this->data['user'] = $this->user->getUserName();

		# store info
 	  $this->load->model('sales/order');
		if($res = $this->model_sales_order->selectStore($this->data['id'])){
      $this->data['store_name']   = $res['name'];
      $this->data['storetype']    = $res['storetype'];
      $this->data['accountno']    = $res['accountno'];
      $this->data['address1']   = $res['address1'];
      $this->data['city']   = $res['city'];
      $this->data['state']  = $res['state'];
      $this->data['zipcode']    = $res['zipcode'];
      $this->data['phone1']    = $res['phone1'];
      $this->data['fax']    = $res['fax'];
      $this->data['salesrep']    = $res['salesrep'];
      $this->data['comment']    = $res['comment'];
    }

    # payment info
    $accountno = '';
    if($res = $this->model_ar_detail->getARdata($id)){
      $this->data['finance'] = $res;
      $balance = 0;
      $payment = '';
      foreach($res as $row){
        $balance += $row['balance'];
        $payment = $row['payment']; // use latest payment credit
      }
      $this->data['balance'] = $balance;
      $this->data['payment'] = $payment;
    }else{
      //$this->error['warning'] = 'No AR History';
    }

 		$this->data['lnk_list'] = 'index.php?route=ar/list&token=' . $this->session->data['token'];

    # call view
    $this->template = 'ar/sheet.tpl';
		$this->response->setOutput($this->render(TRUE), $this->config->get('config_compression'));
	}
}
?>