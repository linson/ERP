<?php
/*
todo. batch process for trans , Later , besso-201103 
*/
class ControllerStoreBtrip extends Controller {
	private $error = array();
	private $bManager = false;

 	public function index(){

    $this->bManager = false;
    if('manager' == $this->user->getGroupName($this->user->getUserName()) ){
      $this->bManager = true;
    }
		//$this->load->language('store/btrip');
		//$this->document->title = $this->language->get('heading_title');
		//$this->load->model('sales/order');
		//$this->callOrderForm();
		//echo 'store btrip start';
		$this->getList();
  }

  // ajax proxy call
  public function getList(){
   	$this->load->language('store/store');

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
		if (isset($this->request->get['page'])) {
			$page = $this->request->get['page'];
		} else {
			$page = 1;
		}
    //$this->log->aPrint( $this->request->get );
		if(isset($this->request->get['sort'])) {
			$sort = $this->request->get['sort'];
		} else {
			$sort = 'name';
		}
		if (isset($this->request->get['filter_name'])) {
				$url .= '&filter_name=' . $this->request->get['filter_name'];
		  	$filter_name = $this->request->get['filter_name'];
  	}else{
  	    $filter_name = NULL;  
  	}
  	
  	if (isset($this->request->get['filter_accountno'])) {
				$url .= '&filter_accountno=' . $this->request->get['filter_accountno'];
		    $filter_accountno = $this->request->get['filter_accountno'];
  	}else{
  	    $filter_accountno = NULL;  
  	}

  	if (isset($this->request->get['filter_address1'])) {
				$url .= '&filter_address1=' . $this->request->get['filter_address1'];
		    $filter_address1 = $this->request->get['filter_address1'];
  	}else{
  	    $filter_address1 = NULL;  
  	}
  	
  	if (isset($this->request->get['filter_storetype'])) {
				$url .= '&filter_storetype=' . $this->request->get['filter_storetype'];
		    $filter_storetype = $this->request->get['filter_storetype'];
  	}else{
  	    $filter_storetype = NULL;  
  	}
		if (isset($this->request->get['filter_city'])) {
				$url .= '&filter_city=' . $this->request->get['filter_city'];
		    $filter_city = $this->request->get['filter_city'];
  	}else{
  	    $filter_city = NULL;  
  	}
		if (isset($this->request->get['filter_state'])) {
				$url .= '&filter_state=' . $this->request->get['filter_state'];
		    $filter_state = $this->request->get['filter_state'];
  	}else{
  	    $filter_state = NULL;  
  	}
  	if (isset($this->request->get['filter_zipcode'])) {
				$url .= '&filter_zipcode=' . $this->request->get['filter_zipcode'];
		    $filter_zipcode = $this->request->get['filter_zipcode'];
  	}else{
  	    $filter_zipcode = NULL;  
  	}
		if (isset($this->request->get['filter_phone1'])) {
				$url .= '&filter_phone1=' . $this->request->get['filter_phone1'];
		    $filter_phone1 = $this->request->get['filter_phone1'];
  	}else{
  	    $filter_phone1 = NULL;  
  	}

		if (isset($this->request->get['filter_salesrep'])) {
				$url .= '&filter_salesrep=' . $this->request->get['filter_salesrep'];
		    $filter_salesrep = $this->request->get['filter_salesrep'];
  	}else{
    	if(true != $this->bManager){
  	    $filter_salesrep = $this->user->getUserName();
  	  }else{
  	    $filter_salesrep = NULL;
  	  }
  	}
		if( isset($this->request->get['filter_status']) && '' != $this->request->get['filter_status'] ){
				$url .= '&filter_status=' . $this->request->get['filter_status'];
		    $filter_status = $this->request->get['filter_status'];
  	}else{
  	    $filter_status = '';  
  	}
  	//$this->log->aPrint( $this->request->get );
		if (isset($this->request->get['order'])) {
		  $order = $this->request->get['order'];
  	}else{
  	  $order = 'ASC';  
  	}
  	
  	//todo. need to check error and success, besso-201103 
  	if(isset($this->error['warning'])){
			$this->data['error_warning'] = $this->error['warning'];
		}else{
			$this->data['error_warning'] = '';
		}
		if (isset($this->session->data['success'])) {
			$this->data['success'] = $this->session->data['success'];
			unset($this->session->data['success']);
		} else {
			$this->data['success'] = '';
		}

		if($order == 'ASC'){
			$url .= '&order=DESC';
		}else{
			$url .= '&order=ASC';
		}

    # link
		$this->data['lnk_insert'] = HTTPS_SERVER . 'index.php?route=store/btrip/insert&token=' . $this->session->data['token'] . $url;
		//$this->data['lnk_update'] = HTTPS_SERVER . 'index.php?route=store/btrip/update&token=' . $this->session->data['token'] . $url;
		$this->data['lnk_delete'] = HTTPS_SERVER . 'index.php?route=store/btrip/delete&token=' . $this->session->data['token'] . $url;
    
    # filter & sort
 		$this->data['sort_name'] = HTTPS_SERVER . 'index.php?route=store/btrip&token=' . $this->session->data['token'] . '&sort=name' . $url;
 		// let's do for additional requirement , besso-201103 
 		//$this->data['sort_accountno'] = HTTPS_SERVER . 'index.php?route=store/btrip&token=' . $this->session->data['token'] . '&sort=accountno' . $url;
 		$this->data['sort_status'] = HTTPS_SERVER . 'index.php?route=store/btrip&token=' . $this->session->data['token'] . '&sort=status' . $url;
 		$this->data['sort_storetype'] = HTTPS_SERVER . 'index.php?route=store/btrip&token=' . $this->session->data['token'] . '&sort=storetype' . $url;


    # call data
    $this->load->model('store/btrip');
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
			'filter_status'   => $filter_status,
			'sort'            => $sort,
			'order'           => $order,
			'start'           => ($page - 1) * $this->config->get('config_admin_limit'),
			'limit'           => $this->config->get('config_admin_limit')
			//'limit'           => '100'
    );
    //$this->log->aPrint( $request );
    $store_total = $this->model_store_btrip->getTotalStore($request);
		$response = $this->model_store_btrip->getStore($request,$export_qry);

    //echo $export_qry;
		$this->data['export'] = HTTPS_SERVER . 'index.php?route=store/btrip/export&token=' . $this->session->data['token'] . '&export_qry=' . urlencode($export_qry);

    /**
    echo '<pre>';
    print_r($response);
    echo '</pre>';
    *** , besso-201103 */
    foreach($response as $row){
			$action = array();
			$action[] = array(
				'text' => $this->language->get('text_edit'),
				'href' => HTTPS_SERVER . 'index.php?route=store/store/update&token=' . $this->session->data['token'] . '&id=' . $row['id'] . $url
			);

      $this->data['store'][] = array(
			  'id'        => $row['id'],
			  'name'        => $row['name'],
			  'storetype'        => $row['storetype'],
			  'accountno' => $row['accountno'],
			  'address1'  => $row['address1'],
        'address2'  => $row['address2'],
        'city'      => $row['city'],
        'state'     => $row['state'],
        'zipcode'   => $row['zipcode'],
        'phone1'    => $row['phone1'],
        'phone2'    => $row['phone2'],
        'fax'    => $row['fax'],
        'salesrep'  => $row['salesrep'],
        'status'    => $row['status'],
        'balance'   => $row['balance'],
        'lat'   => $row['lat'],
        'lng'   => $row['lng'],
				'action'     => $action,
 				'selected'   => isset($this->request->post['selected']) && in_array($result['id'], $this->request->post['selected']),
			);
    }

    //print 'total cnt : ' . $store_total;
    # no pagenation
    /***
 		$pagination = new Pagination();
		$pagination->total = $store_total;
		$pagination->page = $page;
		$pagination->limit = $this->config->get('config_admin_limit');
		$pagination->text = $this->language->get('text_pagination');
		$pagination->url = HTTPS_SERVER . 'index.php?route=store/btrip&token=' . $this->session->data['token'] . $url . '&page={page}';
		//$this->p(debug_backtrace()); exit;
		$this->data['pagination'] = $pagination->render();
		***/
		
		$this->data['total'] = $store_total;
		$this->data['filter_name'] = $filter_name;
		$this->data['filter_accountno'] = $filter_accountno;
		$this->data['filter_storetype'] = $filter_storetype;
		$this->data['filter_city'] = $filter_city;
		$this->data['filter_state'] = $filter_state;
		$this->data['filter_phone1'] = $filter_phone1;
		$this->data['filter_salesrep'] = $filter_salesrep;
		$this->data['filter_status'] = $filter_status;
    $this->data['sort'] = $sort;
		$this->data['order'] = $order;
    $this->data['token'] = $this->session->data['token'];
    
    
    # call view
		//$this->template = 'store/btrip.tpl';
		$this->template = 'store/btrip2.tpl';
		$this->children = array(
			'common/header',
			'common/footer'
		);
		$this->response->setOutput($this->render(TRUE), $this->config->get('config_compression'));
  }

  // todo. TBD who help me? , besso 201105 
  public function insert(){
  }

  // ajax call for update pannel
  public function callUpdatePannel(){
    $store_id = $this->request->get['store_id'];

		$this->load->model('store/btrip');
    $this->data['store'] = $this->model_store_btrip->getOneStore($store_id);
    $accountno = $this->data['store']['accountno'];
    //$this->log->aPrint( $this->data['store'] );

    //todo. release later! adhoc for test , besso-201103 
    $accountno = 'PA8077';
    $this->data['trans_history'] = $this->model_store_btrip->getStoreHistory($accountno);
    //$this->log->aPrint( $this->data['trans_history'] );

		$this->load->model('sales/order');

  	//todo. release later! adhoc for test , besso-201103
		$store_id = '2451';
    $this->data['store_ar_total'] = $this->model_sales_order->selectStoreARTotal($store_id);
    //$this->log->aPrint( $this->data['store_ar_total'] );

    $this->data['store_history'] = $this->model_sales_order->selectStoreHistory($store_id);
    //$this->log->aPrint( $this->data['store_history'] );


	  //##############################################################################
	  // Module: Google Map
	  //##############################################################################
		$this->load->language('store/btrip');

	  $this->data['column_gmap']		     = $this->language->get('column_gmap');
	  $this->data['entry_gmap_step1']	     = $this->language->get('entry_gmap_step1');
	  $this->data['entry_gmap_step2']	     = $this->language->get('entry_gmap_step2');
	  $this->data['entry_gmap_step3']	     = $this->language->get('entry_gmap_step3');
	  $this->data['entry_gmap_step4']	     = $this->language->get('entry_gmap_step4');
	  $this->data['entry_gmap_step5']	     = $this->language->get('entry_gmap_step5');
	  $this->data['button_get_lat_lng']	 = $this->language->get('button_get_lat_lng');
	  $this->data['error_gmap_size']	     = $this->language->get('error_gmap_size' );
	  $this->data['error_gmap_address']    = $this->language->get('error_gmap_address');
	  
	  if (isset($this->request->post['gmap_width'])) {
    		$this->data['gmap_width'] = $this->request->post['gmap_width'];
	  } elseif (isset($product_info)) {
	  	$this->data['gmap_width'] = $product_info['gmap_width'];
	  } else {
    		$this->data['gmap_width'] = '';
	  }
	  
	  if (isset($this->request->post['gmap_height'])) {
    		$this->data['gmap_height'] = $this->request->post['gmap_height'];
	  } elseif (isset($product_info)) {
	  	$this->data['gmap_height'] = $product_info['gmap_height'];
	  } else {
    		$this->data['gmap_height'] = '';
	  }    	
	  
	  if (isset($this->request->post['gmap_zoom'])) {
    		$this->data['gmap_zoom'] = $this->request->post['gmap_zoom'];
	  } elseif (isset($product_info)) {
	  	$this->data['gmap_zoom'] = $product_info['gmap_zoom'];
	  } else {
    		$this->data['gmap_zoom'] = '14';
	  }    	
	  
	  if (isset($this->request->post['gmap_type'])) {
    		$this->data['gmap_type'] = $this->request->post['gmap_type'];
	  } elseif (isset($product_info)) {
	  	$this->data['gmap_type'] = $product_info['gmap_type'];
	  } else {
    		$this->data['gmap_type'] = 'roadmap';
	  }    	
	  
	  if (isset($this->request->post['gmap_address'])) {
    		$this->data['gmap_address'] = $this->request->post['gmap_address'];
	  } elseif (isset($product_info)) {
	  	$this->data['gmap_address'] = $product_info['gmap_address'];
	  } else {
    		$this->data['gmap_address'] = '';
	  }
	  
	  if (isset($this->request->post['gmap_lat_and_lng'])) {
    		$this->data['gmap_lat_and_lng'] = $this->request->post['gmap_lat_and_lng'];
	  } elseif (isset($product_info)) {
	  	$this->data['gmap_lat_and_lng'] = $product_info['gmap_lat_and_lng'];
	  } else {
    		$this->data['gmap_lat_and_lng'] = '';
	  }
	  
	  //##############################################################################
	  // Module: Google Map
	  //##############################################################################

    $this->data['token'] = $this->session->data['token'];
    $url = '';
    $this->data['action'] = HTTPS_SERVER . 'index.php?route=store/btrip/update&token=' . $this->session->data['token'] . $url;

    $this->template = 'store/updatePannel.tpl';
  	$this->response->setOutput($this->render(TRUE), $this->config->get('config_compression'));
  }

  public function update(){
    //$this->log->aPrint( $this->request );
  	$this->load->model('store/btrip');
    if($this->model_store_btrip->updateStore($this->request->post)){
      $this->getList();
    }else{
      echo "<script>alert('update fail');</script>";
    }
  }

  public function export(){
		$this->load->language('store/btrip');
		$title = $this->language->get('heading_title');

    $export_qry = $this->request->get['export_qry'];    

			$ReflectionResponse = new ReflectionClass($this->response);
			if ($ReflectionResponse->getMethod('addheader')->getNumberOfParameters() == 2) {
				$this->response->addheader('Pragma', 'public');
				$this->response->addheader('Expires', '0');
				$this->response->addheader('Content-Description', 'File Transfer');
				$this->response->addheader("Content-type', 'text/octect-stream");
				$this->response->addheader("Content-Disposition', 'attachment;filename=" . $title . ".csv");
				$this->response->addheader('Content-Transfer-Encoding', 'binary');
				$this->response->addheader('Cache-Control', 'must-revalidate, post-check=0,pre-check=0');
			} else {
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

}
?>