<?php
class ControllerStoreLookup extends Controller {
	private $error = array();
 	public function index() {
		//$this->load->language('store/lookup');
		//$this->document->title = $this->language->get('heading_title');

		//$this->load->model('sales/order');
		//$this->callOrderForm();
  }

  // ajax proxy call
  public function callback(){
    //echo 'besso'; exit;
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
		if (isset($this->request->get['sort'])) {
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
  	
  	// todo. some test show it retain stale account no. , besso 201105 
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
  	    $filter_salesrep = NULL;  
  	}

		if (isset($this->request->get['filter_chrt'])) {
				$url .= '&filter_chrt=' . $this->request->get['filter_chrt'];
		    $filter_chrt = $this->request->get['filter_chrt'];
  	}else{
 	    $filter_chrt = '';
  	}

		if (isset($this->request->get['filter_status'])) {
				$url .= '&filter_status=' . $this->request->get['filter_status'];
		    $filter_status = $this->request->get['filter_status'];
  	}else{
  	    $filter_status = NULL;  
  	}
		if (isset($this->request->get['filter_page'])) {
				$url .= '&filter_page=' . $this->request->get['filter_page'];
		    $filter_page = $this->request->get['filter_page'];
  	}else{
  	    $filter_page = '1';  
  	}
		if (isset($this->request->get['order'])) {
			$url .= '&order=' . $this->request->get['order'];
		  $order = $this->request->get['order'];
  	}else{
  	    $filter_order = 'ASC';  
  	}
    
    # link
		$this->data['lnk_insert'] = HTTPS_SERVER . 'index.php?route=store/lookup/insert&token=' . $this->session->data['token'] . $url;
		//$this->data['lnk_update'] = HTTPS_SERVER . 'index.php?route=store/lookup/update&token=' . $this->session->data['token'] . $url;
		$this->data['lnk_delete'] = HTTPS_SERVER . 'index.php?route=store/lookup/delete&token=' . $this->session->data['token'] . $url;

    # filter & sort
 		$this->data['sort_name'] = HTTPS_SERVER . 'index.php?route=store/lookup&token=' . $this->session->data['token'] . '&sort=name' . $url;
 		// let's do for additional requirement , besso-201103 
 		//$this->data['sort_accountno'] = HTTPS_SERVER . 'index.php?route=store/lookup&token=' . $this->session->data['token'] . '&sort=accountno' . $url;
 		//$this->data['sort_state'] = HTTPS_SERVER . 'index.php?route=store/lookup&token=' . $this->session->data['token'] . '&sort=state' . $url;

		if(isset($this->request->get['order'])) {
			$order = $this->request->get['order'];
		} else {
			$order = 'ASC';
		}


    # call data
    $this->load->model('store/store');
    
		$this->data['store'] = array();
    $request = array(
			'filter_name'	  => $filter_name,
			'filter_accountno'=> $filter_accountno,
			'filter_storetype'=> $filter_storetype,
			'filter_address1' => $filter_address1,
			'filter_city'     => $filter_city,
			'filter_state'   => $filter_state,
			'filter_zipcode'   => $filter_zipcode,
			'filter_phone1'  => $filter_phone1,
			'filter_salesrep'  => $filter_salesrep,
			'filter_chrt'   => $filter_chrt,
			'filter_status'   => $filter_status,
			'filter_page'   => $filter_page,
			'sort'            => $sort,
			'order'           => $order,
			'start'           => ($page - 1) * $this->config->get('config_admin_limit'),
			'limit'           => $this->config->get('config_admin_limit')
    );
    //$this->log->aPrint( $request );
    $store_total = $this->model_store_store->getTotalStore($request);
    // todo. ajax do not support excel functionality
    $export_qry = '';
		$response = $this->model_store_store->getStore($request,$export_qry);

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
			
   	  $address = $row['name'] . '\n' .
           $row['address1'] . '\n' .
           $row['city'] . "," . $row['state'] . "," . $row['zipcode'] . '\n' .
           "TEL : " . $row['phone1'];

   	  if($row['billto'] != ""){
   	    $billto = $row['billto'];
   	  }else{ $billto = $address; }
   	  if($row['shipto'] != ""){
   	    $shipto = $row['shipto'];
   	  }else{ $shipto = $address; }

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
        'chrt'    => $row['chrt'],
        'status'    => $row['status'],
        'discount'  => $row['discount'],
        'billto'  => $billto,
        'shipto'  => $shipto,
				'action'     => $action,
 				'selected'   => isset($this->request->post['selected']) && in_array($result['id'], $this->request->post['selected']),
			);
    }

    //print 'total cnt : ' . $store_total;

 		$pagination = new Pagination();
		$pagination->total = $store_total;
		//$pagination->page = $page;
		$pagination->page = $filter_page;

		$pagination->limit = $this->config->get('config_admin_limit');
		$pagination->text = $this->language->get('text_pagination');
		$pagination->url = HTTPS_SERVER . 'index.php?route=store/lookup/callback&token=' . $this->session->data['token'] . $url . '&page={page}';
	
		$this->data['pagination'] = $pagination->render();

		$this->data['filter_name'] = $filter_name;
		$this->data['filter_accountno'] = $filter_accountno;
		$this->data['filter_storetype'] = $filter_storetype;
		$this->data['filter_city'] = $filter_city;
		$this->data['filter_state'] = $filter_state;
		$this->data['filter_phone1'] = $filter_phone1;
		$this->data['filter_salesrep'] = $filter_salesrep;
		$this->data['filter_chrt'] = $filter_chrt;
		$this->data['filter_status'] = $filter_status;
		$this->data['filter_page'] = $filter_page;
		
    $this->data['sort'] = $sort;
		$this->data['order'] = $order;
    
    $this->data['token'] = $this->session->data['token'];

    # call view
    $this->template = 'store/lookup_proxy.tpl';
		$this->response->setOutput($this->render(TRUE), $this->config->get('config_compression'));
  
  }
  
  public function insert(){
    
  }

  public function update(){
    
  }
  
  public function delete(){
    
  }
  
  
}
?>
