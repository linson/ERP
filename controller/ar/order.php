<?php
class ControllerArOrder extends Controller {
	private $error = array();

 	public function index(){
    //echo 'start index';
		$this->load->language('ar/order');
		$this->document->title = $this->language->get('heading_title');
    $this->load->model('ar/order');
    if(isset($this->request->get['txid'])){
    	$this->callOrderForm($this->request->get['txid']);
    }else{
    	$this->callOrderForm();
    }  
  }

  // order form
  private function callOrderForm($txid = ''){
    //echo 'callOrderForm start';
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
      if($res = $this->model_ar_order->selectTransaction($txid)){
     	  $this->data['txid'] = $res['txid'];
     	  $this->data['store_id']   = $res['store_id'];
        $this->data['description'] = $res['description'];
        $this->data['arrep'] = $res['order_user'];
        $this->data['order_price'] = $res['order_price'];  
     	  $this->data['order_date']    = substr($res['order_date'],0,10);
     	  $this->data['other_cost']    = $res['other_cost'];
     	  $this->data['weight_sum']    = $res['weight_sum'];
     	  $this->data['balance']    = $res['balance'];
     	  $this->data['payed_sum']    = $res['payed_sum'];
     	  $this->data['term']    = $res['term'];
     	  $this->data['invoice_no']    = $res['invoice_no'];
     	  $this->data['billto']    = $res['billto'];
     	  $this->data['shipto']    = $res['shipto'];
        // firstname retrieve
     	  $this->data['firstname'] = $this->user->getFirstName($res['order_user']);
     	  
      }else{
        // todo. use modal for any fail and mail to it team , besso-201103
        echo 'selectTransaction fail';
        exit;
      }
      /*
      echo '<pre>';
      print_r($res);
      echo '</pre>';
      */
      if($res = $this->model_ar_order->selectStore($this->data['store_id'])){
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

      if($res = $this->model_ar_order->selectStoreARTotal($this->data['store_id'])){
        /*
        echo '<pre>';
        print_r($res);
        echo '</pre>';
        */
        $this->data['store_ar_total'] = $res;
     	}else{
     	  //echo 'selectStoreARTotal fail';
     	  //exit;
     	}

      if($res = $this->model_ar_order->selectStoreHistory($this->data['store_id'])){
        /*
        echo '<pre>';
        print_r($res);
        echo '</pre>';
        */
        $this->data['store_history'] = $res;
     	}else{
     	  //echo 'selectStoreHistory fail';
     	  //exit;
     	}


      if($res = $this->model_ar_order->selectSales($this->data['txid'])){
        $this->data['sales'] = $res;
     	}else{
     	  //echo 'selectSales fail';
     	  //exit;
     	}

      /***
      echo '<pre>';
      print_r($res);
      echo '</pre>';
   	  ***/

      if($res = $this->model_ar_order->selectShip($this->data['txid'])){
        $this->data['ship'] = $res;
     	}else{
     	  // todo. no result
     	  // echo 'selectShip fail';
     	  $this->data['ship'] = array();
     	}

      if($res = $this->model_ar_order->selectPay($this->data['txid'])){
        $this->data['pay'] = $res;
     	}else{
     	  // todo. no result
     	  //echo 'selectPay fail';
     	  //exit;
     	}

      $this->data['ddl'] = 'update';

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

      $this->data['ddl'] = 'insert';
      //$this->data['status'] = '0';
   	  
   	  // todo. differ from insert/update
   	  $this->data['arrep'] = $this->user->getUserName();
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
      

    } // no txid
    //$this->log->aPrint( $this->data );
    // [todo] it's ugly way to pass session
   	$this->data['token']    = $this->session->data['token'];

    # lnk
 		$this->data['lnk_cancel'] = HTTP_SERVER . 'index.php?route=ar/order&token=' . $this->session->data['token'] . $url;
 		$this->data['lnk_list'] = HTTP_SERVER . 'index.php?route=ar/list&token=' . $this->session->data['token'] . $url;

		$this->data['order_action'] = HTTP_SERVER . 'index.php?route=ar/order/saveOrder&token=' . $this->session->data['token'];

    $this->template = 'ar/order.tpl';
		$this->children = array(
			'common/header',
			'common/footer'
		);

		$this->response->setOutput($this->render(TRUE), $this->config->get('config_compression'));
  }

  public function saveOrder(){
    /***
    echo '<pre>';
    print_r($this->request->post);    
    echo '</pre>';
    ***/
    # generate txid : JH20110323-IL0004-01
    # and lookup exsiting account
    # it's done in client side ( ajax, verify_txid )
    
    # parse data for each table inserting
    
    $txid   = $this->request->post['txid'];
    $ddl    = $this->request->post['ddl'];
    $status = $this->request->post['status'];
    #storeinfo
    $store_id = $this->request->post['store_id'];
    $order_date = $this->request->post['order_date'];
    $store_name = $this->request->post['store_name'];
    $accountno = $this->request->post['accountno'];
    $arrep = $this->request->post['arrep'];
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

    #ship and pay
    $weight_sum = $this->request->post['weight_sum'];
    $term = $this->request->post['term'];

    $method = $this->request->post['method'];
    $lift = $this->request->post['lift'];
    $cod = $this->request->post['cod'];
    $ship_date = $this->request->post['ship_date'];

    #ar
    $pay_price = $this->request->post['pay_price'];
    $pay_method = $this->request->post['pay_method'];
    $pay_date = $this->request->post['pay_date'];
    $balance = $this->request->post['balance'];
    $payed_sum = $this->request->post['payed_sum'];
    
    $order_price = $this->request->post['order_price'];

    #payment
    $aPay_id = $this->request->post['pay_id'];
    $aPay_price = $this->request->post['pay_price'];
    $aPay_method = $this->request->post['pay_method'];
    $aPay_date = $this->request->post['pay_date'];
    $aPay_num = $this->request->post['pay_num'];
    $aPay_user = $this->request->post['pay_user'];
    /***
    echo '<pre>';
    print_r($this->request->post);
    echo '</pre>';
    exit;
    ***/
    #order
    $aModel = $this->request->post['model'];
    $aProduct_id = $this->request->post['product_id'];
    $aStock = $this->request->post['stock'];
    $aCnt = $this->request->post['cnt'];
    $aFree = $this->request->post['free'];
    $aDamage = $this->request->post['damage'];
    $aPrice = $this->request->post['price'];
    $aDiscount = $this->request->post['discount'];
    $aTotal_price = $this->request->post['total_price'];
    $aWeight_row = $this->request->post['weight_row'];

    #ship
    $aShip_id = $this->request->post['ship_id'];
    $aMethod = $this->request->post['method'];
    $aShip_date = $this->request->post['ship_date'];
    $aLift = $this->request->post['lift'];
    $aCod = $this->request->post['cod'];
    $aShip_appointment = $this->request->post['ship_appointment'];
    $aShip_comment = $this->request->post['ship_comment'];
    $aShip_user = $this->request->post['ship_user'];
    
    $this->load->model('ar/order');

    if('insert' == $ddl){
      # incremental tx sequence
      $aTxid = array();
      $aTxid = $this->model_ar_order->getTxid($txid);
      // for test
      /* todo, if suffix > 10 , the sort will be broken , besso-201103 
      $aTxid = array(
        'JH20110325-FL4545-1',
        'JH20110325-FL4545-3',
        'JH20110325-FL4545-2',
      );
      $aTxid = $response[0]['txid'];
      print_r($aTxid);
      */
      
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

    // parsing data for ddl
    $data = array(
      'store' => array(
        'id' => $store_id,
        'name' => $store_name,
        'accountno' => $accountno,
        'arrep' => $arrep,
        'address1' => $address1,
        'city' => $city,
        'state' => $state,
        'zipcode' => $zipcode,
        'storetype' => $storetype,
        'phone1' => $phone1,
        'fax' => $fax
      ),
      'tx' => array(
        'txid' => $txid,
        'store_id' => $store_id,
        'description' => addslashes($description),
        // todo. arrep should be uniq, alter table and validation login in adding user , besso-201103 
        'order_user' => $arrep,  
        'saled_ym'  => substr($order_date,0,4).substr($order_date,5,2),
        // todo. new_store isn't considered yet. need consult
        'term' => $term,
        // todo. store_grade, daily crond or some batch will record it. , besso-201103
        'order_price' => $order_price,
        'weight_sum' => $weight_sum,
        'order_date' => $order_date,
        'balance' => $balance,
        'payed_sum' => $payed_sum,
        'status' => $status
      ),
      'ar' => array(
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
        'order_date' => $order_date,
        'txid' => $txid
      ),
      /*** no need to insert by ar */
      'ship' => array(
        $aMethod,
        $aShip_date,
        $aLift,
        $aCod,
        $aShip_appointment,
        $aShip_comment,
        $aShip_user,
        'txid' => $txid
      ),
      /***/
      'pay' => array(
        $aPay_price,
        $aPay_method,
        $aPay_date,
        $aPay_num,
        $aPay_user,
        'txid' => $txid
      )
    );

    /***
    echo '<pre>';
    print_r($data);    
    echo '</pre>';
    exit;
    ***/

    // $this->model_catalog_product->getProd
    # insert transaction , ar, ship_history, payment_history
    if($ddl == 'insert'){
      
      if('ok' == $this->model_ar_order->insertTransaction($data['tx']) ){
        // todo. keep logging for any transaction in log
      }else{
        // todo. need exception 
        return false; 
      }

    }else{    // update

      if('ok' == $this->model_ar_order->updateTransaction($data['tx']) ){
        // todo. keep logging for any transaction in log
      }else{
        // todo. need exception 
        return false; 
      }

      /***
      if('ok' == $this->model_ar_order->updateSales($txid, $data['ar']) ){
        // todo. keep logging for any transaction in log
      }else{
        // todo. need exception 
        return false; 
      }
      
      if('ok' == $this->model_ar_order->updateShip($txid,$data['ship']) ){
        // todo. keep logging for any transaction in log
      }else{
        // todo. need exception 
        return false; 
      }

      if('ok' == $this->model_ar_order->updatePayment($txid,$data['payment']) ){
        // todo. keep logging for any transaction in log
      }else{
        // todo. need exception 
        return false; 
      }
      ***/
    }
    
    # always update store
    if('ok' == $this->model_ar_order->updateStore($data['store']) ){
      // todo. keep logging for any transaction in log
      //echo 'update store done';
    }else{
      // todo. need exception 
      return false; 
    }
    
    
    # always insert after delete.
    if('ok' == $this->model_ar_order->insertSales($data['ar']) ){
      // todo. keep logging for any transaction in log
    }else{
      // todo. need exception 
      return false; 
    }

    # always insert for ship and 
    if('ok' == $this->model_ar_order->insertShip($data['ship']) ){
      // todo. keep logging for any transaction in log
    }else{
      // todo. need exception 
      return false; 
    }
    
    if('ok' == $this->model_ar_order->insertPay($data['pay'],$data['tx']['balance'],$data['tx']['payed_sum']) ){
      // todo. keep logging for any transaction in log
    }else{
      // todo. need exception 
      return false; 
    }


    $this->redirect(HTTP_SERVER . 'index.php?route=ar/order&token=' . $this->session->data['token'] . '&txid=' . $txid );
    //$this->callOrderForm($txid);

  }
  
  public function verify_txid(){
    //$this->log->aPrint( $this->request->get['txid'] );
    # call model to check txid and return
		$this->load->model('ar/order');
    $response = $this->model_ar_order->getTxid($this->request->get['txid']);
    $this->data['txid'] = array();
    //$this->log->aPrint( count($response) );
    if(count($response) != 0 ){
      $this->data['txid'] = $response;      
    }
    $this->template = 'ar/verify_txid_proxy.tpl';
		$this->response->setOutput($this->render(TRUE), $this->config->get('config_compression'));
  }
}
?>