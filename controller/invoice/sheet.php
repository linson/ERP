<?php
/***
todo. need to make list button
***/

class ControllerInvoiceSheet extends Controller{
	private $error = array();
	private $bApprove = false;
	private $bManager = false;

 	public function index(){
    //echo 'start index';
		$this->load->language('sales/order');
		$this->document->title = $this->language->get('heading_title');

    $this->bApprove = false;
    $this->bManager = false;
    // todo. more simply way please
    if('manager' == $this->user->getGroupName( $this->user->getUserName()) ){
      $this->bManager = true;
      $this->bApprove = true;
    }
    $this->data['bManager'] = $this->bManager;
//$this->log->aPrint( $this->request->get ); exit;
    $this->load->model('sales/order');
    if(isset($this->request->get['txid'])){
    	$this->callOrderForm($this->request->get['txid']);
    }else{
    	$this->callOrderForm();
    }  
  }

  public function updateApprove(){
    //$this->log->aPrint( $this->request->get );
    isset($this->request->get['txid']) ?	$txid = $this->request->get['txid'] : $txid = '';
    isset($this->request->get['status']) ?	$status = $this->request->get['status'] : $status = '';

 	  $this->load->model('sales/order');
    # AR total
    if($this->model_sales_order->updateApprove($txid,$status)){
      echo 'success';
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
    $this->template = 'sales/arHistory.tpl';
    $this->response->setOutput($this->render(TRUE), $this->config->get('config_compression'));
  }

  // order form
  private function callOrderForm($txid = ''){
    // todo. fix the commone iterate , besso-201103 
    # translate
   	$this->data['button_save']   = $this->language->get('button_save');
   	$this->data['button_cancel'] = $this->language->get('button_cancel');
    $this->data['heading_title'] = $this->language->get('heading_title');

 		if (isset($this->error['warning'])) {
  		$this->data['error_warning'] = $this->error['warning'];
		} else {
			$this->data['error_warning'] = '';
		}
    # data from model
    $url = '';  // query param

    // if txid from list or else
    if($txid){
      if($res = $this->model_sales_order->selectTransaction($txid)){
     	  $this->data['txid'] = $res['txid'];
     	  $this->data['store_id']   = $res['store_id'];
        $this->data['description'] = $res['invoice_description'];
        $this->data['salesrep'] = $res['order_user'];
        $this->data['order_price'] = $res['order_price'];  
     	  $this->data['order_date']    = $res['order_date'];
     	  $this->data['other_cost']    = $res['other_cost'];
     	  $this->data['weight_sum']    = $res['weight_sum'];
     	  $this->data['balance']    = $res['balance'];
     	  $this->data['payed_sum']    = $res['payed_sum'];
     	  $this->data['term']    = $res['term'];
     	  $this->data['approved_user']    = $res['approved_user'];
     	  $this->data['approved_date']    = $res['approved_date'];
     	  $this->data['approve_status']    = $res['approve_status'];
     	  $this->data['shipped_yn']    = $res['shipped_yn'];
     	  $this->data['invoice_no']    = $res['invoice_no'];
        $this->data['billto']    = $res['billto'];
     	  $this->data['shipto']    = $res['shipto'];
     	  
     	  $this->data['shipped_date']  = $res['shipped_date'];
     	  $this->data['shipped_by']    = $res['shipped_by'];
     	  $this->data['ship_method']   = $res['ship_method'];
     	  $this->data['store_dc']    = $res['discount'];

     	  $this->data['cod']    = $res['cod'];
     	  $this->data['lift']    = $res['lift'];

        # catalog for salesa
        $this->catalog = $this->config->getCatalogMobile();
        $this->data['catalog'] = $this->catalog;

        // firstname retrieve
     	  $this->data['firstname'] = $this->user->getFirstName($res['order_user']);
        // decide whether you are approver or not.
        if('sales' == $this->user->getGroupName($this->data['salesrep'])){
          $approver = $this->user->getApprover($this->data['salesrep']);
          if(''!=$approver){
            $approver = explode(',',$approver);
            if(in_array($this->user->getUserName(),$approver)){
              $this->bApprove = true;
            }
          }
        }
      }else{
        // todo. use modal for any fail and mail to it team , besso-201103
        echo 'selectTransaction fail';
        exit;
      }
      //$this->log->aPrint( $this->data );

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
     	}else{
     	  echo 'selectStore fail';
     	  exit;
     	}

      if($res = $this->model_sales_order->selectStoreARTotal($this->data['store_id'])){
        $this->data['store_ar_total'] = $res;
     	}else{
     	  //echo 'selectStoreARTotal fail';
     	  //exit;
     	}

      if($res = $this->model_sales_order->selectStoreHistory($this->data['store_id'])){
        $this->data['store_history'] = $res;
     	}else{
     	  //echo 'selectStoreHistory fail';
     	  //exit;
     	}

      # for mode::show, show prepare new tied data set with sales table
      //if($mode == 'show'){
        $this->load->model('product/lib');
        if($res = $this->model_product_lib->getProductOrdered($this->data['txid'])){
          $this->data['sales'] = $res;
     	  }else{
     	    //echo 'selectSales fail';
     	    //exit;
     	  }
     	//}
     	//$this->log->aPrint( $this->data ); exit; 

      if($res = $this->model_sales_order->selectShip($this->data['txid'])){
        $this->data['ship'] = $res;
     	}else{
     	  // todo. no result
     	  // echo 'selectShip fail';
     	  $this->data['ship'] = array();
     	}

      if($res = $this->model_sales_order->selectPay($this->data['txid'])){
        $this->data['pay'] = $res;
     	}else{
     	  // todo. no result
     	  //echo 'selectPay fail';
     	  //exit;
     	}

      $this->data['ddl'] = 'update';

      //$this->load->model('product/lib');
      //if($res = $this->model_product_lib->getProduct($this->data['txid'])){

    }else{  // if not txid
      //print ('no txid');
      # store
   	  $this->data['txid'] = '';
   	  $this->data['store_id']   = '';
   	  $this->data['store_name']   = '';
   	  $this->data['storetype']    = '';
   	  $this->data['accountno']    = '';
   	  $this->data['address1']   = '';
   	  $this->data['city']   = '';
   	  $this->data['state']  = '';
   	  $this->data['zipcode']    = '';
   	  $this->data['phone1']    = '';
   	  $this->data['fax']    = '';
   	  $this->data['description']    = '';
     	$this->data['approved_user']  = '';
     	$this->data['approved_date']  = '';
     	$this->data['approve_status'] = '';
     	$this->data['shipped_yn'] = 'N';

   	  // todo. differ from insert/update
   	  $this->data['salesrep'] = $this->user->getUserName();
   	  $this->data['firstname'] = $this->user->getFirstName();
   	  //$this->data['user_id'] = $this->user->getId();

   	  //set default value
      $this->data['term']    = '30';

 	    $this->data['weight_sum']    = '0';
   	  $this->data['balance']    = '0';
   	  $this->data['payed_sum']    = '0';
   	  $this->data['order_price']    = '0';
   	  $this->data['order_date']    = $this->util->date_format_kr(date('Ymdhis'));

      $this->data['ship'] = array();

   	  $this->data['pay'][0]['pay_price']    = '0';
   	  $this->data['pay'][0]['pay_method']    = 'cash';
   	  $this->data['pay'][0]['pay_date']    = '';
   	  $this->data['pay'][0]['pay_num']    = '';
   	  $this->data['pay'][0]['pay_user']    = 'kh';
      
      $this->data['ddl'] = 'insert';
    } // no txid

    # common for insert/update
    $this->data['bApprove'] = $this->bApprove;
   	
    // [todo] it's ugly way to pass session
   	$this->data['token']    = $this->session->data['token'];

    # lnk
 		$this->data['lnk_cancel'] = HTTP_SERVER . 'index.php?route=sales/order&token=' . $this->session->data['token'] . $url;
 		$this->data['lnk_list'] = HTTP_SERVER . 'index.php?route=invoice/list&token=' . $this->session->data['token'] . $url;

		$this->data['order_action'] = HTTP_SERVER . 'index.php?route=invoice/order/saveOrder&token=' . $this->session->data['token'];

    $this->template = 'invoice/sheet.tpl';
		$this->children = array(
			'common/header',
			'common/footer'
		);
		$this->response->setOutput($this->render(TRUE), $this->config->get('config_compression'));
  }

  public function saveOrder(){
    $this->log->aPrint( $this->request->post );    
    # only store ship

    $txid = $this->request->post['txid'];
    $store_id = $this->request->post['store_id'];
    $order_date = $this->request->post['order_date'];
    $invoice_no = $this->request->post['invoice_no'];
    $shipped_yn = $this->request->post['shipped_yn'];

    #ship and pay
    $weight_sum = $this->request->post['weight_sum'];
    $term = $this->request->post['term'];

    #ship
    $aShip_id = $this->request->post['ship_id'];
    $aMethod = $this->request->post['method'];
    $aShip_date = $this->request->post['ship_date'];
    $aLift = $this->request->post['lift'];
    $aCod = $this->request->post['cod'];
    $aShip_appointment = $this->request->post['ship_appointment'];
    $aShip_comment = $this->request->post['ship_comment'];
    $aShip_user = $this->request->post['ship_user'];

    $this->load->model('sales/order');

    // parsing data for ddl
    $data = array(
      'ship' => array(
        $aMethod,
        $aShip_date,
        $aLift,
        $aCod,
        $aShip_appointment,
        $aShip_comment,
        $aShip_user,
        'txid' => $txid
      )
    );

    //$this->log->aPrint( $data['ship'] ); exit;
    # always insert for ship and 
    if('ok' == $this->model_sales_order->insertShip($data['ship']) ){
      // todo. keep logging for any transaction in log
    }else{
      // todo. need exception 
      return false; 
    }
    
    $this->redirect(HTTP_SERVER . 'index.php?route=invoice/order&token=' . $this->session->data['token'] . '&txid=' . $txid );
  }

  public function verify_txid(){
    //$this->log->aPrint( $this->request->get['txid'] );
    # call model to check txid and return
		$this->load->model('sales/order');
    $response = $this->model_sales_order->getTxid($this->request->get['txid']);
    $this->data['txid'] = array();
    //$this->log->aPrint( count($response) );
    if(count($response) != 0 ){
      $this->data['txid'] = $response;      
    }
    $this->template = 'sales/verify_txid_proxy.tpl';
		$this->response->setOutput($this->render(TRUE), $this->config->get('config_compression'));
  }
}
?>