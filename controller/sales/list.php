<?php
class ControllerSalesList extends Controller {
	private $error = array();
	private $bManager = false;
	
 	public function index(){
    $this->bManager = false;
    if('manager' == $this->user->getGroupName($this->user->getUserName()) ){
      $this->bManager = true;
    }
    $this->data['bManager'] = $this->bManager;
		$this->getList();
  }

  // ajax proxy call
  public function getList(){
   	$this->load->language('sales/list');
    # translation
    $this->data['heading_title'] = $this->language->get('heading_title');
    $url = '';
		if(isset($this->request->get['page'])){
			$page = $this->request->get['page'];
		}else{
			$page = 1;
		}
		if(isset($this->request->get['sort'])){
			$sort = $this->request->get['sort'];
		}else{
			$sort = 'x.order_date';
		}

		isset($this->request->get['order'])? $order = $this->request->get['order'] : $order = 'DESC';
		if(isset($this->request->get['page'])){
		  $url = '&order=' + $order;
		}else{
		  $url = ($order == 'ASC') ? '&order=DESC' : '&order=ASC';
		}

		if(isset($this->request->get['filter_txid'])){
				$url .= '&filter_txid=' . $this->request->get['filter_txid'];
		  	$filter_txid = $this->request->get['filter_txid'];
  	}else{
  	    $filter_txid = NULL;  
  	}
		if(isset($this->request->get['filter_store_name'])){
				$url .= '&filter_store_name=' . $this->request->get['filter_store_name'];
		  	$filter_store_name = $this->request->get['filter_store_name'];
  	}else{
  	    $filter_store_name = NULL;  
  	}
  	if(isset($this->request->get['filter_order_date_from'])){
      $url .= '&filter_order_date_from=' . $this->request->get['filter_order_date_from'];
      $filter_order_date_from = $this->request->get['filter_order_date_from'];
  	}else{
  	  $weekago = date('Y-m-d', strtotime('-7 days'));
      $filter_order_date_from = $weekago;
      //$filter_order_date_from = date('Y-m-d');
  	}
  	if(isset($this->request->get['filter_order_date_to'])){
      $url .= '&filter_order_date_to=' . $this->request->get['filter_order_date_to'];
      $filter_order_date_to = $this->request->get['filter_order_date_to'];
  	}else{
      $tdate = date('Y-m-d');
      $filter_order_date_to = $tdate;  
  	}
  	if(isset($this->request->get['filter_order_price'])){
				$url .= '&filter_order_price=' . $this->request->get['filter_order_price'];
		    $filter_order_price = $this->request->get['filter_order_price'];
  	}else{
  	    $filter_order_price = NULL;  
  	}
  	if(isset($this->request->get['filter_ship'])){
				$url .= '&filter_ship=' . $this->request->get['filter_ship'];
		    $filter_ship = $this->request->get['filter_ship'];
  	}else{
  	    $filter_ship = NULL;  
  	}
		if( isset($this->request->get['filter_payed']) && '' != $this->request->get['filter_payed'] ){
				$url .= '&filter_payed=' . $this->request->get['filter_payed'];
		    $filter_payed = $this->request->get['filter_payed'];
  	}else{
  	    $filter_payed = NULL;  
  	}
		if(isset($this->request->get['filter_approve_status'])){
      $url .= '&filter_approve_status=' . $this->request->get['filter_approve_status'];
		  $filter_approve_status = $this->request->get['filter_approve_status'];
  	}else{
      $filter_approve_status = 'all';
  	}

		if(isset($this->request->get['filter_order_user'])){
				$url .= '&filter_order_user=' . $this->request->get['filter_order_user'];
		    $filter_order_user = $this->request->get['filter_order_user'];
  	}else{
      $username = $this->user->getUserName();
      //if($username && false == $this->bManager){
      /*
      if(false == $this->bManager){
        $filter_order_user = $username;
      }else{
    	  $filter_order_user = NULL;  
      }
      */
      $filter_order_user = NULL;
  	}

    $this->data['manager'] = $this->bManager;

    # link
		$this->data['lnk_insert'] = HTTP_SERVER . 'index.php?route=sales/order&token=' . $this->session->data['token'] . $url;
		$this->data['lnk_delete'] = HTTP_SERVER . 'index.php?route=sales/list/delete&token=' . $this->session->data['token'] . $url;
    
    # filter & sort
 		$this->data['sort_store_name'] = HTTP_SERVER . 'index.php?route=sales/list&token=' . $this->session->data['token'] . '&sort=s.name'  . $url;
 		$this->data['sort_order_date'] = HTTP_SERVER . 'index.php?route=sales/list&token=' . $this->session->data['token'] . '&sort=x.order_date'  . $url;
 		$this->data['sort_order_user'] = HTTP_SERVER . 'index.php?route=sales/list&token=' . $this->session->data['token'] . '&sort=x.order_user'  . $url;
 		
 		// let's do for additional requirement , besso-201103 
 		//$this->data['sort_accountno'] = HTTP_SERVER . 'store/lookup/' . $this->session->data['token'] . '&sort=accountno' . $url;
 		//$this->data['sort_state'] = HTTP_SERVER . 'store/lookup/' . $this->session->data['token'] . '&sort=state' . $url;

    # call data
    $this->load->model('sales/list');
    
		$this->data['txs'] = array();
    $request = array(
			'filter_txid'	  => $filter_txid,
			'filter_store_name'	  => $filter_store_name,
			'filter_order_date_from'=> $filter_order_date_from,
			'filter_order_date_to'=> $filter_order_date_to,
			'filter_order_price' => $filter_order_price,
			'filter_ship'=> $filter_ship,
			'filter_payed'     => $filter_payed,
			'filter_order_user'  => $filter_order_user,
			'filter_approve_status'  => $filter_approve_status,
			'sort'            => $sort,
			'order'           => $order,
			//'start'           => ($page - 1) * $this->config->get('config_admin_limit'),
			'start'           => ($page - 1) * 40,
			//'limit'           => $this->config->get('config_admin_limit')
			'limit'           => 40
    );
    $total = $this->model_sales_list->getTotalList($request);
		$response = $this->model_sales_list->getList($request);

    foreach($response as $row){
			$action = array();
			$action[] = array(
				'text' => $this->language->get('text_edit'),
				'href' => HTTP_SERVER . 'index.php?route=sales/order&mode=show&token=' . $this->session->data['token'] . '&txid=' . $row['txid']
			);

      # let's tune store-status
      //$row['order_date'] = '2011-03-01';
      $today = date('Y-m-d');

      // +30
      if($today < $this->add_date(substr($row['order_date'],0,10),30)){
        $pay_due = '30';
      // 30-60
      }else if( $this->add_date(substr($row['order_date'],0,10),30) <= $today && $today < $this->add_date(substr($row['order_date'],0,10),60)){
        $pay_due = '60';
        //echo ('30-60');
      }else if( $this->add_date(substr($row['order_date'],0,10),60) <= $today && $today < $this->add_date(substr($row['order_date'],0,10),90)){
        $pay_due = '90';
        //echo ('60-90');
      }else if( $this->add_date(substr($row['order_date'],0,10),90) <= $today){
        $pay_due = '120';
        //echo ('over 90');
      }

      $this->data['txs'][] = array(
			  'txid'        => $row['txid'],
			  'store_id'  => $row['store_id'],
			  'store_name'  => $row['store_name'],
        'order_price'  => $row['order_price'],
        'sign_yn'  => $row['sign_yn'],
        'shipped_yn'  => $row['shipped_yn'],
        'payed_yn'  => $row['payed_yn'],
        'order_date'  => substr($row['order_date'],0,13),
        'order_user'  => $row['order_user'],
        'approve_status'  => $row['approve_status'],
        'approved_user'  => $row['approved_user'],
        'executor'  => $row['executor'],
				'balance'   => $row['balance'],
				'status'   => $row['status'],
				'action'     => $action,
 				'pay_due' => $pay_due,
 				'selected'   => isset($this->request->post['selected']) && in_array($result['id'], $this->request->post['selected']),
			);
    }

 		$pagination = new Pagination();
		$pagination->total = $total;
		$pagination->page = $page;
		//$pagination->limit = $this->config->get('config_admin_limit');
		$pagination->limit = 40;
		$pagination->text = $this->language->get('text_pagination');

		$pagination->url = HTTP_SERVER . 'index.php?route=sales/list&token=' . $this->session->data['token'] . $url . '&page={page}';

		$this->data['pagination'] = $pagination->render();
		
		// todo. need to investigation warning and success , besso-201103 
 		if(isset($this->error['warning'])){
			$this->data['error_warning'] = $this->error['warning'];
		}else{
			$this->data['error_warning'] = '';
		}
		if(isset($this->session->data['success'])){
			$this->data['success'] = $this->session->data['success'];
			unset($this->session->data['success']);
		}else{
			$this->data['success'] = '';
		}
		
		$this->data['filter_txid'] = $filter_txid;
		$this->data['filter_store_name'] = $filter_store_name;
		$this->data['filter_order_price'] = $filter_order_price;
		$this->data['filter_order_date_from'] = $filter_order_date_from;
		$this->data['filter_order_date_to'] = $filter_order_date_to;
		$this->data['filter_ship'] = $filter_ship;
		$this->data['filter_payed'] = $filter_payed;
		$this->data['filter_order_user'] = $filter_order_user;
		$this->data['filter_approve_status'] = $filter_approve_status;
		
    $this->data['sort'] = $sort;
		$this->data['order'] = $order;
    
    $this->data['token'] = $this->session->data['token'];

    $this->data['notice'] = $this->selectNotice();
//    $this->log->aPrint( $this->data['notice'] );

    $this->template = 'sales/list.tpl';
		$this->children = array(
			'common/header',
			'common/footer'
		);

/*
    echo '<pre>';
    print_r($this->request->server);
    print $this->session->data['token'];
    echo '</pre>';
*/
		$this->response->setOutput($this->render(TRUE), $this->config->get('config_compression'));
  }

  public function add_date($givendate,$day=0,$mth=0,$yr=0){
    $givendate = $givendate. ' 00:00:00';
    $cd = strtotime($givendate);
    $newdate = date('Y-m-d', mktime(date('h',$cd),
                    date('i',$cd), date('s',$cd), date('m',$cd)+$mth,
                    date('d',$cd)+$day, date('Y',$cd)+$yr));
    return $newdate;
  }

  public function delete(){
		$this->load->model('sales/list');
		$deleteList =  $this->request->post['selected'];
		foreach($deleteList as $txid){
		  $this->model_sales_list->deleteTransaxtion($txid);
		}

		$this->session->data['success'] = "Delete done : " . count($deleteList);
		$this->redirect(HTTP_SERVER . 'index.php?route=sales/list&token=' . $this->session->data['token']);
   	$this->getList();
 	}
  
  // it's temporary for sales only system
  public function updateShippedYN(){
  	$this->load->model('sales/list');
    if($this->model_sales_list->updateShippedYN($this->request->get)){
      //return true;
    }else{
      //return false;
    }
  }

  // it's temporary for sales only system
  public function updateSignYN(){
  	$this->load->model('sales/list');
    if($this->model_sales_list->updateSignYN($this->request->get)){
      //return true;
    }else{
      //return false;
    }
  }

  // it's temporary for sales only system
  public function updateNotice(){
  	$this->load->model('sales/list');
    if($this->model_sales_list->updateNotice($this->request->get)){
      //return true;
    }else{
      //return false;
    }
  }

  // it's temporary for sales only system
  public function selectNotice(){
  	$this->load->model('sales/list');
    $response = $this->model_sales_list->selectNotice();
    //$this->log->aPrint( $response );
    return $response;
  }
}
?>