<?php
class ControllerSalesOrder extends Controller {
	private $error = array();
	private $bApprove = false;
	private $bManager = false;
	private $catalog = array();
	private $isMobile = false;
	private $isDebug  = false;

 	public function index(){
 	  $this->isDebug = ( isset($this->request->get['debug']) ) ? true : false ;
 	  //$this->log->aPrint( $this->isDebug );

 	  //todo. let's make global var 'isMobile'
 	  $this->isMobile = ( isset($this->request->get['mobile']) ) ? true : false ;

    //echo 'start index';
		$this->load->language('sales/order');
		$this->document->title = $this->language->get('heading_title');

    $this->bApprove = false;
    $this->bManager = false;
    // todo. more simply way please
    if('manager' == $this->user->getGroupName($this->user->getUserName()) ){
      $this->bManager = true;
      $this->bApprove = true;
    }
    $this->data['bManager'] = $this->bManager;

    # catalog for salesa
    if( isset($this->request->get['mobile']) ){
      $this->catalog = $this->config->getCatalogMobile();
    }else{
      $this->catalog = $this->config->getCatalog();
    }
    $this->data['catalog'] = $this->catalog;
    //$this->log->aPrint( $this->catalog );

    $this->load->model('sales/order');
    if(isset($this->request->get['txid'])){
    	isset($this->request->get['mode']) ? $mode = $this->request->get['mode'] : $mode = 'edit';
    	//isset($this->request->post['mode']) ? $mode = $this->request->post['mode'] : $mode = 'edit';
    	$this->callOrderForm($this->request->get['txid'],$mode);
    }else{
    	$this->callOrderForm();
    }
  }

  public function callLockedPannel(){
    $model = $this->request->get['model'];
		$this->load->model('sales/order');
    $this->data['qty'] = $this->model_sales_order->getSalesQuantity($model);
    //$aLocked = $this->model_sales_order->getSalesQuantity($model);
    //$this->load->library('json');
		//$this->response->setOutput(Json::encode($data));
		$this->template = 'sales/lockedPannel.tpl';
  	$this->response->setOutput($this->render(TRUE), $this->config->get('config_compression'));
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

  // tmp
  public function qbHistory(){
    //$this->log->aPrint( $this->request->get );
    isset($this->request->get['store_id']) ?	$store_id = $this->request->get['store_id'] : $store_id = '';
    $this->data['store_id'] = $store_id;

 	  $this->load->model('sales/order');

    # history
    if($res = $this->model_sales_order->quickbookHistory($this->data['store_id'])){
      $this->data['store_history'] = $res;
    }
    //$this->log->aPrint( $res );
    $this->template = 'sales/qbHistory.tpl';
    $this->response->setOutput($this->render(TRUE), $this->config->get('config_compression'));
  }

  // order form
  private function callOrderForm($txid = '',$mode='edit'){
    //$this->log->aPrint( $this->request ); exit;

    $this->data['mode'] = $mode;
    //echo 'callOrderForm start';

    // todo. fix the commone iterate , besso-201103 
    # translate
   	$this->data['button_save']   = $this->language->get('button_save');
   	$this->data['button_cancel'] = $this->language->get('button_cancel');
    $this->data['heading_title'] = $this->language->get('heading_title');

 		if (isset($this->error['warning'])) {
  		$this->data['error_warning'] = $this->error['warning'];
		}else{
			$this->data['error_warning'] = '';
		}

    # data from model
    $url = '';  // query param

    // if txid from list or else
    if($txid){
      if($res = $this->model_sales_order->selectTransaction($txid)){
     	  $this->data['txid'] = $res['txid'];
     	  $this->data['status'] = $res['status'];
     	  $this->data['executor'] = $res['executor'];
     	  $this->data['store_id']   = $res['store_id'];
        $this->data['description'] = $res['description'];
        $this->data['salesrep'] = $res['order_user'];
        $this->data['order_price'] = $res['order_price'];
     	  $this->data['order_date']    = substr($res['order_date'],0,10);
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

     	  $this->data['payment']     = $res['payment'];
     	  $this->data['ship_method'] = $res['ship_method'];
     	  $this->data['ship_cod']    = $res['cod'];
     	  $this->data['ship_lift']   = $res['lift'];
     	  $this->data['ship_appointment']   = $res['ship_appointment'];
     	  $this->data['shipto']      = $res['shipto'];
     	  $this->data['store_dc']    = $res['discount'];

     	  $this->data['pc_date'] = ( isset($res['pc_date']) ) ? substr($res['pc_date'],0,10) : '' ;
     	  $this->data['post_check'] = $res['post_check'];
     	  $this->data['cur_check']  = $res['cur_check'];
     	  $this->data['cur_cash']   = $res['cur_cash'];

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
      //$this->log->aPrint( $this->data ); exit;

      if($res = $this->model_sales_order->selectStore($this->data['store_id'])){
        $this->data['store_name']   = $res['name'];
     	  //$this->data['store_name']   = htmlspecialchars($res['name']);
     	  //$this->log->aPrint( $this->data['store_name'] );
     	  $this->data['storetype']    = $res['storetype'];
     	  $this->data['accountno']    = $res['accountno'];
     	  $this->data['address1']     = $res['address1'];
     	  $this->data['city']         = $res['city'];
     	  $this->data['state']        = $res['state'];
     	  $this->data['zipcode']      = $res['zipcode'];
     	  $this->data['phone1']       = $res['phone1'];
     	  $this->data['fax']          = $res['fax'];
     	  //$this->data['store_dc']    = $res['discount'];

     	  # shipto , shipto managing
     	  $address = $res['name'] . '\n' .
                   $res['address1'] . '\n' .
                   $res['city'] . "," . $res['state'] . "," . $res['zipcode'] . '\n' .
                   "TEL : " . $res['phone1'];
     	  if($this->data['shipto'] == ""){
     	    $this->data['shipto'] = $res['shipto'];
     	  }
     	  if( $this->data['shipto'] == "" ) $this->data['shipto'] = $address;
     	}else{
     	  echo 'selectStore fail';
     	  exit;
     	}

      if($res = $this->model_sales_order->selectStoreARTotal($this->data['store_id'])){
        $this->data['store_ar_total'] = $res;
     	}else{
     	  //echo 'selectStoreARTotal fail'; exit;
     	}

      if($res = $this->model_sales_order->selectStoreHistory($this->data['store_id'])){
        $this->data['store_history'] = $res;
     	}else{
     	  //echo 'selectStoreHistory fail'; exit;
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

      if($res = $this->model_sales_order->selectFreegoodSum($this->data['txid'])){
        $this->data['freegood_amount'] = $res;
     	}else{}

      /*
      if($res = $this->model_sales_order->selectShip($this->data['txid'])){
        $this->data['ship'] = $res;
     	}else{
     	  $this->data['ship'] = array();
     	}
      if($res = $this->model_sales_order->selectPay($this->data['txid'])){
        $this->data['pay'] = $res;
     	}else{
     	  // todo. no result
     	  //echo 'selectPay fail';
     	  //exit;
     	}
     	*/
      $this->data['ddl'] = 'update';
    }else{  // if not txid
      //print ('no txid');
      # store
   	  $this->data['txid'] = '';
   	  $this->data['executor'] = '';
   	  $this->data['store_id']   = '';
   	  $this->data['store_name']   = '';
   	  $this->data['storetype']    = '';
   	  $this->data['store_dc']     = '';
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
     	$this->data['payment'] = 'n3';
     	$this->data['ship_method'] = 'ups';
     	$this->data['ship_cod'] = '0';
     	$this->data['ship_lift'] = '0';
     	$this->data['ship_appointment'] = $this->util->date_format_kr(date('Ymdhis'));

     	$this->data['pc_date'] = '';
     	$this->data['post_check'] = '0';
     	$this->data['cur_check'] = '0';
     	$this->data['cur_cash'] = '0';

     	$this->data['shipto'] = '';

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
   	  $this->data['pay'][0]['pay_user']    = '';

   	  $this->data['freegood_amount']    = '0';
   	  $this->data['freegood_percent']    = '0';

      $this->data['ddl'] = 'insert';
      $this->data['status'] = '0';
    } // no txid

    # common for insert/update
    $this->data['bApprove'] = $this->bApprove;

    // [todo] it's ugly way to pass session
   	$this->data['token']    = $this->session->data['token'];

    # lnk
 		$this->data['lnk_cancel'] = HTTP_SERVER . 'index.php?route=sales/order&token=' . $this->session->data['token'] . $url;
 		$this->data['lnk_list'] = HTTP_SERVER . 'index.php?route=sales/list&token=' . $this->session->data['token'] . $url;
		$this->data['order_action'] = HTTP_SERVER . 'index.php?route=sales/order/saveOrder&token=' . $this->session->data['token'];

    if($this->isMobile == true){
      $this->template = 'sales/mobile/order.tpl';
    }else{
      $this->template = 'sales/order.tpl';
    }

    if($this->isDebug == true)  $this->template = 'sales/order_debug.tpl';
		$this->children = array(
			'common/header',
			'common/footer'
		);
		$this->response->setOutput($this->render(TRUE), $this->config->get('config_compression'));
  }

  public function saveOrder(){
    //$this->log->aPrint( $this->request->post ); exit;
    # parse data for each table inserting
    $txid = $this->request->post['txid'];
    $txid = html_entity_decode($txid);
    $txid = str_replace('"','',$txid);

    $ddl    = $this->request->post['ddl'];
    $status = $this->request->post['status'];
    $mode   = $this->request->post['mode'];
    #storeinfo
    $store_id = $this->request->post['store_id'];
    $order_date = $this->request->post['order_date'];
    $store_name = $this->request->post['store_name'];
    $accountno = $this->request->post['accountno'];
    isset($this->request->post['salesrep']) ? $salesrep = $this->request->post['salesrep'] : $salesrep = $this->user->getUserName();
    // todo. need not use this , besso-201103 
    //$user_id = $this->request->post['user_id'];
    $address1 = $this->request->post['address1'];
    $city = $this->request->post['city'];
    $state = $this->request->post['state'];
    $zipcode = $this->request->post['zipcode'];
    $storetype = $this->request->post['storetype'];
    $phone1 = $this->request->post['phone1'];
    $fax = $this->request->post['fax'];
    $description = $this->request->post['description'];
    //$this->log->aPrint( 'post : description : ' . $description );
    $shipped_yn = $this->request->post['shipped_yn'];
    $shipto = $this->request->post['shipto'];

  	$pc_date    = $this->request->post['pc_date'];
   	$post_check = $this->request->post['post_check'];
   	$cur_check  = $this->request->post['cur_check'];
   	$cur_cash   = $this->request->post['cur_cash'];

    // store discount control
    $discount = NULL;
    isset($this->request->post['dc1']) ? $dc1 = $this->request->post['dc1'] : $dc1 = 0;
    isset($this->request->post['dc1_desc']) ? $dc1_desc = $this->request->post['dc1_desc'] : $dc1_desc = '';
    isset($this->request->post['dc2']) ? $dc2 = $this->request->post['dc2'] : $dc2 = 0;
    isset($this->request->post['dc2_desc']) ? $dc2_desc = $this->request->post['dc2_desc'] : $dc2_desc = '';
    if($dc1 == '') $dc1 = 0;
    if($dc2 == '') $dc2 = 0;
    //$this->log->aPrint( stristr($description,'Store Discount') ); exit;
    //$this->log->aPrint( $this->request->post ); exit;

    $aDC = array();
    if($dc1 > 0){
      $aDC[0] = $dc1 . '|' . $dc1_desc;
      /*
      $description .= "\n";
      if( strstr($description,'Store Discount') === FALSE ){
        $description .= "[ Store Discount 1 ] $dc1 % $dc1_desc \n";
      }
      */
    }
    if($dc2 > 0){
      $aDC[1] = $dc2 . '|' . $dc2_desc;
    }

    ( count($aDC) > 0 ) ? $discount = json_encode($aDC) : $discount = '';

    #ship and pay
    $weight_sum = $this->request->post['weight_sum'];

    $payment     = $this->request->post['payment'];
    $ship_method = $this->request->post['ship_method'];
    $ship_lift   = $this->request->post['ship_lift'];
    $ship_cod    = $this->request->post['ship_cod'];
    $ship_appointment = $this->request->post['ship_appointment'];

    # ar
    $balance = isset($this->request->post['balance']) ? $this->request->post['balance'] : $this->request->post['order_price'] ;
    $payed_sum = isset($this->request->post['payed_sum']) ? $this->request->post['payed_sum'] : '0' ;
    $order_price = $this->request->post['order_price'];

    #order
    $aModel = $this->request->post['model'];
    $aProduct_id = $this->request->post['product_id'];
    $aStock = $this->request->post['stock'];
    $aCnt = $this->request->post['cnt'];
    $aFree = $this->request->post['free'];
    $aDamage = $this->request->post['damage'];
    $aPromotion = $this->request->post['promotion'];
    $aPrice = $this->request->post['price'];
    $aDiscount = $this->request->post['discount'];
    $aDiscount2 = $this->request->post['discount2'];
    $aTotal_price = $this->request->post['total_price'];
    $aWeight_row = $this->request->post['weight_row'];
    //$aBackorder = $this->request->post['backorder'];
    //$aBackfree = $this->request->post['backfree'];
    //$aBackdamage = $this->request->post['backdamage'];    
    //$this->log->aPrint( $aPromotion );exit;

    // todo. just for Gel. not good 
    $flagDC = false;
    foreach( $aDiscount as $dc ){
      if(is_numeric($dc) && $dc > 0 ){
        $flagDC = true;
        break;
      }
    }
    /** todo. let's tune later how to set best description. ***/
    if($flagDC == true){
      //$description .= "\n";
      //$description .= "Check Discount and make Discount statement for Account";
      //$description .= "[ DAMAGE DISCOUNT ] : 2 % \n";
      //$description .= "[ SPECIAL DISCOUNT ] : 5 % \n";
    }

    //echo $flagDC;     echo '<br/>';    echo $description;    exit;
    #ship
    /***
    $aShip_id = $this->request->post['ship_id'];
    $aMethod = $this->request->post['method'];
    $aShip_date = $this->request->post['ship_date'];
    $aLift = $this->request->post['lift'];
    $aCod = $this->request->post['cod'];
    ***/
    // todo. ship appointment will be replaced with Description , besso 201105 
    //$aShip_appointment = $this->request->post['ship_appointment'];
    //$aShip_comment = $this->request->post['ship_comment'];
    //$ship_user = $this->request->post['ship_user'];
    $this->load->model('sales/order');

    /*****
    if('insert' == $ddl){
      # incremental tx sequence
      # no need to any incremetal job
      $aTxid = array();
      $aTxid = $this->model_sales_order->getTxid($txid);
      if(count($aTxid) == 0){
        $txid = $txid . '-1';  
      }else{
        arsort($aTxid);
        $prefix = substr($aTxid[0]['txid'],0,17);
        foreach($aTxid as $k => $v){
          $suffix = substr($v['txid'],18,2);
          $suffix += 1;
          break;
        }
        if($prefix == $txid){
          $txid = $prefix . '-' . $suffix; 
        }else{
          // todo. need standard fallback process , besso-201103 
          print 'we got wrong txid before creating new txid for inserting'; 
        }
      }
    }
    *****/

    // parsing data for ddl
    $data = array(
      'store' => array(
        'id' => $store_id,
        'name' => $store_name,
        'accountno' => $accountno,
        'salesrep' => $salesrep,
        'address1' => $address1,
        'city' => $city,
        'state' => $state,
        'zipcode' => $zipcode,
        'storetype' => $storetype,
        'phone1' => $phone1,
        'fax' => $fax,
        'discount' => $discount
      ),
      'tx' => array(
        'txid' => $txid,
        'store_id' => $store_id,
        'description' => addslashes($description),
        // todo. salesrep should be uniq, alter table and validation login in adding user , besso-201103 
        'order_user' => $salesrep,  
        'saled_ym'  => substr($order_date,0,4).substr($order_date,5,2),
        // todo. new_store isn't considered yet. need consult
        //'term' => $term,
        // todo. store_grade, daily crond or some batch will record it. , besso-201103
        'order_price' => $order_price,
        'weight_sum' => $weight_sum,
        'order_date' => $order_date,
        'balance' => $balance,
        'payed_sum' => $payed_sum,
        'shipped_yn' => $shipped_yn,
        'payment' => $payment,
        'ship_method' => $ship_method,
        'ship_appointment' => $ship_appointment,
        'ship_cod' => $ship_cod,
        'ship_lift' => $ship_lift,
        'shipto' => $shipto,
        'status' => $status,
        'discount' => $discount,
      	'pc_date' => $pc_date,
       	'post_check' => $post_check,
       	'cur_check' => $cur_check,
       	'cur_cash' => $cur_cash,
      ),
      'sales' => array(
        $aModel,
        $aProduct_id,
        $aStock,
        $aCnt,
        $aFree,
        $aDamage,
        $aPrice,
        $aDiscount,
        $aTotal_price,
        $aWeight_row,
        $aDiscount2,  // 10
        //$aBackorder,
        //$aBackfree,
        //$aBackdamage,
        $aPromotion,
        'order_date' => $order_date,
        'txid' => $txid
      ),
    );

    //$this->log->aPrint( $data ); exit;
    //$this->log->aPrint( $ddl ); exit;
    // $this->model_catalog_product->getProd
    # insert transaction , sales, ship_history, payment_history
    if($ddl == 'insert'){
      if(true == $this->model_sales_order->insertTransaction($data['tx']) ){
        // todo. keep logging for any transaction in log
      }else{
        // todo. need exception 
        return false; 
      }
    }else{    // update
      if(true == $this->model_sales_order->updateTransaction($data['tx']) ){
        // todo. keep logging for any transaction in log
      }else{
        // todo. need exception 
        return false; 
      }
    }

    # always update store
    if(true == $this->model_sales_order->updateStore($data['store']) ){
      // todo. keep logging for any transaction in log
      //echo 'update store done';
    }else{
      // todo. need exception 
      return false; 
    }

    //$this->log->aPrint( $data['sales'] ); exit;
    # always insert after delete.
    if(true == $this->model_sales_order->insertSales($data['sales']) ){
      // todo. keep logging for any transaction in log
    }else{
      // todo. need exception 
      return false; 
    }

    // if the request is from ajax post, we dont need to redirect
    //$this->log->aPrint( $this->request->post );
    if( 'true' != $this->request->post['async'] ){
      if( $this->isMobile == true ){
        $this->redirect(HTTP_SERVER . 'index.php?route=sales/order&mobile=true&token=' . $this->session->data['token'] . '&txid=' . $txid . '&mode=' . $mode);
      }else{
        $this->redirect(HTTP_SERVER . 'index.php?route=sales/order&token=' . $this->session->data['token'] . '&txid=' . $txid . '&mode=' . $mode);
      }
    }
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