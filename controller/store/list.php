<?php
/*
  it's used for main Account menu.
  For ajax list, i used lookup.php
  // gd install : sudo apt-get -y install libgd2-xpm-dev build-essential
 */
class ControllerStoreList extends Controller{
	private $error = array();
	private $bManager = false; 
	private $bSales = false;

  public function printLabel(){
    $this->load->model('store/store');
    $idlist = $this->request->get['idlist'];
    $aList = explode(',',$idlist);
    $aStore = array();
    foreach($aList as $list){
      $aStore[] = $this->model_store_store->getOneStore($list);
    }
    $this->data['stores'] = $aStore;
    $this->template = 'store/printLabel.tpl';
    $this->response->setOutput($this->render(TRUE), $this->config->get('config_compression'));
  }

 	public function index(){
    $this->bManager = false;
    if('manager' == $this->user->getGroupName($this->user->getUserName()) ){
      $this->bManager = true;
    }
    // todo. need to move session, the boolean sales
    //$this->log->aPrint( $this->user->getUsername() );    $this->log->aPrint( $this->user->getSales() );    exit;
    $uname  = $this->user->getUsername();
    $aSales = $this->user->getSales();
    if( in_array( trim($uname), $aSales ) ){
      $this->bSales = true;
      //$this->log->aPrint( 'AAA' );
    }
    //$this->log->aPrint( 'BBB' );  exit;
		$this->getList();
  }

  // ajax proxy call
  public function getList(){
   	$this->load->language('store/store');

    // todo. more neat control
    // $this->data['bManager'] = $this->bManager;

    # translation
    $this->data['heading_title'] = $this->language->get('heading_title');
    $this->data['column_name']      = $this->language->get('column_name');
    $this->data['column_accountno'] = $this->language->get('column_accountno');
    $this->data['column_storetype'] = $this->language->get('column_storetype');
    $this->data['column_address1']  = $this->language->get('column_address1');
    $this->data['column_city']      = $this->language->get('column_city');
    $this->data['column_state']     = $this->language->get('column_state');
    $this->data['column_zipcode']   = $this->language->get('column_zipcode');
    $this->data['column_phone1']    = $this->language->get('column_phone1');
    $this->data['column_fax']    = $this->language->get('column_fax');
    $this->data['column_salesrep']  = $this->language->get('column_salesrep');
		$this->data['column_status'] = $this->language->get('column_status');
		$this->data['column_action'] = $this->language->get('column_action');
		
		$this->data['button_filter'] = $this->language->get('button_filter');
		$this->data['text_enabled'] = $this->language->get('text_enabled');
		$this->data['text_disabled'] = $this->language->get('text_disabled');
    
    //echo '<pre>';
    //print_r($this->request->get);
    //echo '</pre>';
    # parcing request param
    $url = '';
		if(isset($this->request->get['page'])){
			$page = $this->request->get['page'];
		} else{
			$page = 1;
		}
    //$this->log->aPrint( $this->request->get );
		if(isset($this->request->get['sort'])){
			$sort = $this->request->get['sort'];
		} else{
			$sort = 'accountno';
		}
		if(isset($this->request->get['filter_name'])){
				$url .= '&filter_name=' . $this->request->get['filter_name'];
		  	$filter_name = $this->request->get['filter_name'];
  	}else{
  	    $filter_name = NULL;  
  	}
  	
  	if(isset($this->request->get['filter_accountno'])){
				$url .= '&filter_accountno=' . $this->request->get['filter_accountno'];
		    $filter_accountno = $this->request->get['filter_accountno'];
  	}else{
  	    $filter_accountno = NULL;  
  	}

  	if(isset($this->request->get['filter_address1'])){
				$url .= '&filter_address1=' . $this->request->get['filter_address1'];
		    $filter_address1 = $this->request->get['filter_address1'];
  	}else{
  	    $filter_address1 = NULL;  
  	}
  	
  	if(isset($this->request->get['filter_storetype'])){
				$url .= '&filter_storetype=' . $this->request->get['filter_storetype'];
		    $filter_storetype = $this->request->get['filter_storetype'];
  	}else{
  	    $filter_storetype = NULL;  
  	}
		if(isset($this->request->get['filter_city'])){
				$url .= '&filter_city=' . $this->request->get['filter_city'];
		    $filter_city = $this->request->get['filter_city'];
  	}else{
  	    $filter_city = NULL;  
  	}
		if(isset($this->request->get['filter_state'])){
				$url .= '&filter_state=' . $this->request->get['filter_state'];
		    $filter_state = $this->request->get['filter_state'];
  	}else{
  	    $filter_state = NULL;  
  	}
  	if(isset($this->request->get['filter_zipcode'])){
				$url .= '&filter_zipcode=' . $this->request->get['filter_zipcode'];
		    $filter_zipcode = $this->request->get['filter_zipcode'];
  	}else{
  	    $filter_zipcode = NULL;  
  	}
		if(isset($this->request->get['filter_phone1'])){
				$url .= '&filter_phone1=' . $this->request->get['filter_phone1'];
		    $filter_phone1 = $this->request->get['filter_phone1'];
  	}else{
  	    $filter_phone1 = NULL;  
  	}

		if(isset($this->request->get['filter_salesrep'])){
				$url .= '&filter_salesrep=' . $this->request->get['filter_salesrep'];
		    $filter_salesrep = $this->request->get['filter_salesrep'];
  	}else{
  	  //$this->log->aPrint( $this->bSales ); exit;
    	if(true === $this->bSales){
  	    //$filter_salesrep = $this->user->getUserName();
  	    //todo. temporarily release the list
  	    $filter_salesrep = NULL;
  	  }else{
  	    $filter_salesrep = NULL;
  	  }
  	}
    //$this->log->aPrint( $this->request->get );
		if(isset($this->request->get['filter_balance'])){
				$url .= '&filter_balance=' . $this->request->get['filter_balance'];
		    $filter_balance = $this->request->get['filter_balance'];
  	}else{
  	    $filter_balance = NULL;
  	}
  	//$this->log->aPrint( 'balance : ' . $filter_balance );
		if( isset($this->request->get['filter_status']) && '' != $this->request->get['filter_status'] ){
				$url .= '&filter_status=' . $this->request->get['filter_status'];
		    $filter_status = $this->request->get['filter_status'];
  	}else{
  	    $filter_status = '';
  	}

  	//todo. set order as DESC
		//$order = (isset($this->request->get['order'])) ? $this->request->get['order'] : '';
		$order = 'ASC';

  	//todo. need to check error and success, besso-201103 
  	if(isset($this->error['warning'])){
			$this->data['error_warning'] = $this->error['warning'];
		}else{
			$this->data['error_warning'] = '';
		}
		if(isset($this->session->data['success'])){
			$this->data['success'] = $this->session->data['success'];
			unset($this->session->data['success']);
		} else{
			$this->data['success'] = '';
		}

		if($order == 'ASC'){
			$url .= '&order=DESC';
		}else{
			$url .= '&order=ASC';
		}

    # link
		$this->data['lnk_insert'] = HTTPS_SERVER . 'index.php?route=store/list/insert&token=' . $this->session->data['token'] . $url;
		//$this->data['lnk_update'] = HTTPS_SERVER . 'index.php?route=store/list/update&token=' . $this->session->data['token'] . $url;
		$this->data['lnk_delete'] = HTTPS_SERVER . 'index.php?route=store/list/delete&token=' . $this->session->data['token'] . $url;
    
    # filter & sort
 		$this->data['sort_name'] = HTTPS_SERVER . 'index.php?route=store/list&token=' . $this->session->data['token'] . '&sort=name' . $url;
 		// let's do for additional requirement , besso-201103 
 		//$this->data['sort_accountno'] = HTTPS_SERVER . 'index.php?route=store/list&token=' . $this->session->data['token'] . '&sort=accountno' . $url;
 		$this->data['sort_status'] = HTTPS_SERVER . 'index.php?route=store/list&token=' . $this->session->data['token'] . '&sort=status' . $url;
 		$this->data['sort_storetype'] = HTTPS_SERVER . 'index.php?route=store/list&token=' . $this->session->data['token'] . '&sort=storetype' . $url;
 		$this->data['sort_salesrep'] = HTTPS_SERVER . 'index.php?route=store/list&token=' . $this->session->data['token'] . '&sort=salesrep' . $url;

    # call data
    $this->load->model('store/store');
		$this->data['store'] = array();
    $request = array(
			'filter_name'	    => $filter_name,
			'filter_accountno'=> $filter_accountno,
			'filter_storetype'=> $filter_storetype,
			'filter_address1' => $filter_address1,
			'filter_city'     => $filter_city,
			'filter_state'    => $filter_state,
			'filter_zipcode'  => $filter_zipcode,
			'filter_phone1'   => $filter_phone1,
			'filter_salesrep' => $filter_salesrep,
			'filter_balance' => $filter_balance,
			'filter_status'   => $filter_status,
			'sort'            => $sort,
			'order'           => $order,
			//'start'           => ($page - 1) * $this->config->get('config_admin_limit'),
			'start'           => ($page - 1) * 100,
			//'limit'           => $this->config->get('config_admin_limit')
			'limit'           => '100'
    );
    //$this->log->aPrint( $request );
    $store_total = $this->model_store_store->getTotalStore($request);
		$response = $this->model_store_store->getStore($request,$export_qry);
		
		//$this->log->aPrint( $export_qry );

    //echo $export_qry;
		$this->data['export'] = HTTPS_SERVER . 'index.php?route=store/list/export&token=' . $this->session->data['token'] . '&export_qry=' . urlencode($export_qry);

    //$this->log->aPrint( $response ); exit;

    foreach($response as $row){
			$action = array();
			$action[] = array(
				'text' => $this->language->get('text_edit'),
				'href' => HTTPS_SERVER . 'index.php?route=store/store/update&token=' . $this->session->data['token'] . '&id=' . $row['id'] . $url
			);
      $balance = ($row['balance']) ? $row['balance'] : 0 ;
      $this->data['store'][] = array(
			  'id'        => $row['id'],
			  'name'      => $row['name'],
			  'storetype' => $row['storetype'],
			  'accountno' => $row['accountno'],
			  'address1'  => $row['address1'],
        'address2'  => $row['address2'],
        'city'      => $row['city'],
        'state'     => $row['state'],
        'zipcode'   => $row['zipcode'],
        'phone1'    => $row['phone1'],
        'phone2'    => $row['phone2'],
        'fax'       => $row['fax'],
        'salesrep'  => $row['salesrep'],
        'status'    => $row['status'],
        'tx'        => $row['tx'],
        'balance'   => $balance,
				'action'    => $action,
 				'selected'  => isset($this->request->post['selected']) && in_array($result['id'], $this->request->post['selected']),
			);
    }

 		$pagination = new Pagination();
		$pagination->total = $store_total;
		$pagination->page = $page;
		//$pagination->limit = $this->config->get('config_admin_limit');
		$pagination->limit = 100;
		$pagination->text = $this->language->get('text_pagination');
		$pagination->url = HTTPS_SERVER . 'index.php?route=store/list&token=' . $this->session->data['token'] . $url . '&page={page}';
		//$this->p(debug_backtrace()); exit;
		$this->data['pagination'] = $pagination->render();
		$this->data['total'] = $store_total;
		$this->data['filter_name'] = $filter_name;
		$this->data['filter_accountno'] = $filter_accountno;
		$this->data['filter_storetype'] = $filter_storetype;
		$this->data['filter_city'] = $filter_city;
		$this->data['filter_state'] = $filter_state;
		$this->data['filter_phone1'] = $filter_phone1;
		$this->data['filter_salesrep'] = $filter_salesrep;
		$this->data['filter_balance'] = $filter_balance;
		$this->data['filter_status'] = $filter_status;
    $this->data['sort'] = $sort;
		$this->data['order'] = $order;
    $this->data['token'] = $this->session->data['token'];

		$this->template = 'store/list.tpl';
		$this->children = array(
			'common/header',
			'common/footer'
		);

		$this->response->setOutput($this->render(TRUE), $this->config->get('config_compression'));
  
  }

  // ajax call for update pannel
  public function callUpdatePannel(){
    $store_id = $this->request->get['store_id'];

		$this->load->model('store/store');
    $this->data['store'] = $this->model_store_store->getOneStore($store_id);
    $accountno = $this->data['store']['accountno'];
    //$this->log->aPrint( $this->data['store'] );

    //todo. release later! adhoc for test , besso-201103 
    //$accountno = 'PA8077';
    $this->data['trans_history'] = $this->model_store_store->getStoreHistory($accountno);
    //$this->log->aPrint( $this->data['trans_history'] );

		$this->load->model('sales/order');

  	//todo. release later! adhoc for test , besso-201103
		//$store_id = '2451';
    $this->data['store_ar_total'] = $this->model_sales_order->selectStoreARTotal($store_id);
    //$this->log->aPrint( $this->data['store_ar_total'] );

    $this->data['store_history'] = $this->model_sales_order->selectStoreHistory($store_id);
    //$this->log->aPrint( $this->data['store_history'] );

	  //##############################################################################
	  // Module: Google Map
	  //##############################################################################
		$this->load->language('store/store');

	  $this->data['column_gmap']		     = $this->language->get('column_gmap');
	  $this->data['entry_gmap_step1']	     = $this->language->get('entry_gmap_step1');
	  $this->data['entry_gmap_step2']	     = $this->language->get('entry_gmap_step2');
	  $this->data['entry_gmap_step3']	     = $this->language->get('entry_gmap_step3');
	  $this->data['entry_gmap_step4']	     = $this->language->get('entry_gmap_step4');
	  $this->data['entry_gmap_step5']	     = $this->language->get('entry_gmap_step5');
	  $this->data['button_get_lat_lng']	 = $this->language->get('button_get_lat_lng');
	  $this->data['error_gmap_size']	     = $this->language->get('error_gmap_size' );
	  $this->data['error_gmap_address']    = $this->language->get('error_gmap_address');
	  
	  if(isset($this->request->post['gmap_width'])){
    	$this->data['gmap_width'] = $this->request->post['gmap_width'];
	  }elseif(isset($product_info)){
	  	$this->data['gmap_width'] = $product_info['gmap_width'];
	  }else{
      $this->data['gmap_width'] = '';
	  }
	  
	  if(isset($this->request->post['gmap_height'])){
    		$this->data['gmap_height'] = $this->request->post['gmap_height'];
	  } elseif(isset($product_info)){
	  	$this->data['gmap_height'] = $product_info['gmap_height'];
	  } else{
    		$this->data['gmap_height'] = '';
	  }    	
	  
	  if(isset($this->request->post['gmap_zoom'])){
    		$this->data['gmap_zoom'] = $this->request->post['gmap_zoom'];
	  } elseif(isset($product_info)){
	  	$this->data['gmap_zoom'] = $product_info['gmap_zoom'];
	  } else{
    		$this->data['gmap_zoom'] = '14';
	  }    	
	  
	  if(isset($this->request->post['gmap_type'])){
    		$this->data['gmap_type'] = $this->request->post['gmap_type'];
	  } elseif(isset($product_info)){
	  	$this->data['gmap_type'] = $product_info['gmap_type'];
	  } else{
    		$this->data['gmap_type'] = 'roadmap';
	  }    	
	  
	  if(isset($this->request->post['gmap_address'])){
    		$this->data['gmap_address'] = $this->request->post['gmap_address'];
	  } elseif(isset($product_info)){
	  	$this->data['gmap_address'] = $product_info['gmap_address'];
	  } else{
    		$this->data['gmap_address'] = '';
	  }
	  
	  if(isset($this->request->post['gmap_lat_and_lng'])){
    		$this->data['gmap_lat_and_lng'] = $this->request->post['gmap_lat_and_lng'];
	  } elseif(isset($product_info)){
	  	$this->data['gmap_lat_and_lng'] = $product_info['gmap_lat_and_lng'];
	  } else{
    		$this->data['gmap_lat_and_lng'] = '';
	  }
	  
	  //##############################################################################
	  // Module: Google Map
	  //##############################################################################

    $this->data['token'] = $this->session->data['token'];
    $url = '';
    $this->data['action'] = HTTPS_SERVER . 'index.php?route=store/list/update&token=' . $this->session->data['token'] . $url;

    $this->template = 'store/updatePannel.tpl';
  	$this->response->setOutput($this->render(TRUE), $this->config->get('config_compression'));
  }

  public function update(){
    //$this->log->aPrint( $this->request );
  	$this->load->model('store/store');
    if($this->model_store_store->updateStore($this->request->post)){
      $this->getList();
    }else{
      echo "<script>alert('update fail');</script>";
    }
  }

  // ajax call for update pannel
  public function callInsertPannel(){
    $this->data['action'] = HTTPS_SERVER . 'index.php?route=store/list/insert&token=' . $this->session->data['token'];
    $this->template = 'store/insertPannel.tpl';
  	$this->response->setOutput($this->render(TRUE), $this->config->get('config_compression'));
  }

  public function insert(){
    //$this->log->aPrint( $this->request );
  	$this->load->model('store/store');
    if($this->model_store_store->insertStore($this->request->post)){
      $this->getList();
    }else{
      echo "<script>alert('update fail');</script>";
    }
  }
  
  public function export(){
		$this->load->language('store/list');
		$title = $this->language->get('heading_title');
    $export_qry = $this->request->get['export_qry'];
    $export_qry = urldecode($export_qry);
    //$this->log->aPrint( $export_qry ); exit;

/***
    $export_qry = "
select p.model,p.sku,pd.name_for_sales,package.code,package.name 
  from product p, product_package pp, product_description = pd, package
 where p.product_id = pp.pid
   and p.product_id = pd.product_id
   and package.code = pp.pkg
 order by p.model
    ";
***/

		$ReflectionResponse = new ReflectionClass($this->response);
		if($ReflectionResponse->getMethod('addheader')->getNumberOfParameters() == 2){
			$this->response->addheader('Pragma', 'public');
			$this->response->addheader('Expires', '0');
			$this->response->addheader('Content-Description', 'File Transfer');
			$this->response->addheader("Content-type', 'text/octect-stream");
			$this->response->addheader("Content-Disposition', 'attachment;filename=" . $title . ".csv");
			$this->response->addheader('Content-Transfer-Encoding', 'binary');
			$this->response->addheader('Cache-Control', 'must-revalidate, post-check=0,pre-check=0');
		} else{
			$this->response->addheader('Pragma: public');
			$this->response->addheader('Expires: 0');
			$this->response->addheader('Content-Description: File Transfer');
			$this->response->addheader("Content-type:text/octect-stream");
			$this->response->addheader("Content-Disposition:attachment;filename=" . $title . ".csv");
			$this->response->addheader('Content-Transfer-Encoding: binary');
			$this->response->addheader('Cache-Control: must-revalidate, post-check=0,pre-check=0');
		}
		$this->load->model('tool/csv');
		$this->response->setOutput($this->model_tool_csv->csvExport($title,$export_qry));

  }

  public function getLatLng(){
    //$this->log->aPrint( $this->request );
  	$this->load->model('store/store');
  	$account = $this->request->get['account'];
    $rtn =  $this->model_store_store->getLatLng($account);
    echo json_encode($rtn);
  }

}
?>