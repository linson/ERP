<?php
class ControllerArDetail extends Controller {

 	public function index() {
 	  $this->load->model('sales/order');
		$this->getList();
  }

  public function updateComment(){
 	  $this->load->model('store/store');
    //$this->log->aPrint( $this->request->get ); 
    isset($this->request->post['store_id']) ?	$store_id = $this->request->post['store_id'] : $store_id = '';
    isset($this->request->post['comment']) ?	$comment = $this->request->post['comment'] : $comment = '';
    //$comment = nl2br($comment);
    //$this->log->aPrint(  nl2br(stripslashes($comment)) );

    if($this->model_store_store->updateComment($store_id,$comment)){
      echo 'success';
    }else{
      echo 'fail';
    }
  }

  public function callHistoryPannel(){
	  $txid = $this->request->get['txid'];
		$this->load->model('ar/detail');
    $this->data['data'] = $this->model_ar_detail->getHistoryData($txid);
    $this->data['token'] = $this->session->data['token'];
    $this->template = 'ar/historyPannel.tpl';
  	$this->response->setOutput($this->render(TRUE), $this->config->get('config_compression'));
  }

  public function updateFinance(){
    $this->load->model('ar/detail');
    isset($this->request->get['txid']) ?	  $txid = $this->request->get['txid'] : $txid = '';
    isset($this->request->get['paid']) ?	  $paid = $this->request->get['paid'] : $paid = '';
    isset($this->request->get['method']) ?	$method = $this->request->get['method'] : $method = '';
    isset($this->request->get['pay_num']) ?	$pay_num = $this->request->get['pay_num'] : $pay_num = '';
    isset($this->request->get['balance']) ?	$balance = $this->request->get['balance'] : $balance = '';
    isset($this->request->get['bankaccount']) ?	$bankaccount = $this->request->get['bankaccount'] : $bankaccount = '';
    isset($this->request->get['diff']) ?	$diff = $this->request->get['diff'] : $diff = '';

    if($res = $this->model_ar_detail->updateFinance($txid,$paid,$balance,$method,$pay_num,$bankaccount,$diff)){
      // todo
      $this->data['finance'] = $res;
    }
  }

  public function insertFinance(){
    $this->load->model('ar/detail');
    isset($this->request->get['txid']) ?	   $txid = $this->request->get['txid'] : $txid = '';
    isset($this->request->get['store_id']) ? $store_id = $this->request->get['store_id'] : $store_id = '';
    isset($this->request->get['memo']) ?	   $memo = $this->request->get['memo'] : $memo = '';
    
    if($res = $this->model_ar_detail->insertFinance($txid,$store_id,$memo)){
      //$this->data['finance'] = $res;
    }
  }

  public function arHistory(){
    //$this->log->aPrint( $this->request->get );
    isset($this->request->get['store_id']) ?	$store_id = $this->request->get['store_id'] : $store_id = '';
    $this->data['store_id'] = $store_id;
    
 	  $this->load->model('sales/order');
    # AR total
    if($res = $this->model_sales_order->selectStoreARTotal($this->data['store_id'])){
      $this->data['store_ar_total'] = $res;
    }
    # history
    if($res = $this->model_sales_order->selectStoreHistory($this->data['store_id'])){
      $this->data['store_history'] = $res;
    }
    //$this->log->aPrint( $res );
    $this->template = 'ar/arHistory.tpl';
    $this->response->setOutput($this->render(TRUE), $this->config->get('config_compression'));
  }

  public function getList(){
    $this->load->model('ar/detail');
    
    isset($this->error['warning']) ? $this->data['error_warning'] = $this->error['warning'] : $this->data['error_warning'] = '';
		isset($this->request->get['page']) ?	$page = $this->request->get['page'] : $page = 1;
   	$this->data['token']    = $this->session->data['token'];

		# custom
		isset($this->request->get['store_id']) ?	$store_id = $this->request->get['store_id'] : $store_id = '3779';
    isset($this->request->get['accountno']) ?	$accountno = $this->request->get['accountno'] : $accountno = '';
    if('' != $accountno) $store_id = $this->model_ar_detail->getStoreID($accountno);
    //$this->log->aPrint( $store_id ); exit;
    $this->data['store_id'] = $store_id;
		$this->data['user'] = $this->user->getUserName();
    
    
		

		# store info
		if($res = $this->model_sales_order->selectStore($this->data['store_id'])){
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
    if($res = $this->model_ar_detail->getARdata($store_id)){
      $this->data['finance'] = $res;
      //$this->log->aPrint( $res ); exit;
    }

 		$this->data['lnk_list'] = 'index.php?route=ar/list&token=' . $this->session->data['token'];

    # call view
    $this->template = 'ar/detail.tpl';
		$this->children = array(
			'common/header',
			'common/footer'
		);
		$this->response->setOutput($this->render(TRUE), $this->config->get('config_compression'));
  }
}