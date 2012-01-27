<?php
/***
Invoice List Controller
***/
class ControllerInvoiceSearch extends Controller {

 	public function index(){
		$this->getList();
  }

  public function shipConfirm(){
    $this->load->model('invoice/search');
    $this->model_invoice_list->shipConfirm($this->request->get);
  }

  // todo. no any exception check
  public function issueInvoiceNo(){
    //$this->log->aPrint( $this->request->get ); exit;
    $this->load->model('invoice/search');
    $this->model_invoice_list->issueInvoiceNo($this->request->get);
  }
  
  // ajax proxy call
  public function getList(){
    isset($this->error['warning']) ? $this->data['error_warning'] = $this->error['warning'] : $this->data['error_warning'] = '';
		isset($this->request->get['page']) ?	$page = $this->request->get['page'] : $page = 1;
		isset($this->request->get['sort']) ? $sort = $this->request->get['sort'] :	$sort = 'x.order_date';

    $url = '';
		if(isset($this->request->get['filter_txid'])){
		  $url .= '&filter_txid=' . $this->request->get['filter_txid'];
		  $filter_txid = $this->request->get['filter_txid'];
  	}else{
      $filter_txid = NULL;  
  	}

  	if(isset($this->request->get['filter_invoice_no'])){
			$url .= '&filter_invoice_no=' . $this->request->get['filter_invoice_no'];
	    $filter_invoice_no = $this->request->get['filter_invoice_no'];
  	}else{
 	    $filter_invoice_no = NULL;  
  	}

		if(isset($this->request->get['filter_store_name'])){
		  $url .= '&filter_store_name=' . $this->request->get['filter_store_name'];
		  $filter_store_name = $this->request->get['filter_store_name'];
  	}else{
      $filter_store_name = NULL;  
  	}

  	if(isset($this->request->get['filter_ship_date_from'])){
				$url .= '&filter_ship_date_from=' . $this->request->get['filter_ship_date_from'];
		    $filter_ship_date_from = $this->request->get['filter_ship_date_from'];
  	}else{
  	    $filter_ship_date_from = NULL;  
  	}
  	if(isset($this->request->get['filter_ship_date_to'])){
				$url .= '&filter_ship_date_to=' . $this->request->get['filter_ship_date_to'];
		    $filter_ship_date_to = $this->request->get['filter_ship_date_to'];
  	}else{
  	    $filter_ship_date_to = NULL;  
  	}


		if(isset($this->request->get['filter_shipped_yn'])){
				$url .= '&filter_shipped_yn=' . $this->request->get['filter_shipped_yn'];
		    $filter_shipped_yn = $this->request->get['filter_shipped_yn'];
  	}else{
  	    $filter_shipped_yn = 'Y';  
  	}

    # AR don't need User filtering
		if( isset($this->request->get['filter_order_user']) && '' != $this->request->get['filter_order_user'] ){
			$url .= '&filter_order_user=' . $this->request->get['filter_order_user'];
	    $filter_order_user = $this->request->get['filter_order_user'];
  	}else{
   	  $filter_order_user = NULL;
  	}

		if(isset($this->request->get['order'])){
			$url .= '&order=' . $this->request->get['order'];
		  $order = $this->request->get['order'];
  	}else{
 	    $filter_order = 'DESC';  
  	}
    
    # link
		$this->data['lnk_insert'] = HTTP_SERVER . 'index.php?route=invoice/order&token=' . $this->session->data['token'] . $url;
		$this->data['lnk_delete'] = HTTP_SERVER . 'index.php?route=invoice/search/delete&token=' . $this->session->data['token'] . $url;
    
    # filter & sort
 		$this->data['sort_store_name'] = HTTP_SERVER . 'index.php?route=store/lookup&token=' . $this->session->data['token'] . '&sort=name' . $url;
 		// let's do for additional requirement , besso-201103 
 		//$this->data['sort_accountno'] = HTTP_SERVER . 'store/lookup/' . $this->session->data['token'] . '&sort=accountno' . $url;
 		//$this->data['sort_state'] = HTTP_SERVER . 'store/lookup/' . $this->session->data['token'] . '&sort=state' . $url;

		if(isset($this->request->get['order'])){
			$order = $this->request->get['order'];
		}else{
			$order = 'DESC';
		}

    # call data
    $this->load->model('invoice/search');
    
		$this->data['txs'] = array();
    $request = array(
      'filter_txid'	  => $filter_txid,
			'filter_invoice_no'=> $filter_invoice_no,
			'filter_store_name'	  => $filter_store_name,
			'filter_ship_date_from'=> $filter_ship_date_from,
			'filter_ship_date_to'=> $filter_ship_date_to,
			'filter_shipped_yn'=> $filter_shipped_yn,
			'filter_order_user'  => $filter_order_user,
			'sort'            => $sort,
			'order'           => $order,
			'start'           => ($page - 1) * $this->config->get('config_admin_limit'),
			'limit'           => $this->config->get('config_admin_limit')
    );
    $total = $this->model_invoice_search->getTotalList($request);
		$response = $this->model_invoice_search->getList($request);

    foreach($response as $row){
			$action = array();
			$action[] = array(
				'text' => 'Edit',
				'href' => HTTP_SERVER . 'index.php?route=invoice/order&token=' . $this->session->data['token'] . '&txid=' . $row['txid']
			);

      $this->data['txs'][] = array(
			  'txid'         => $row['txid'],
			  'store_name'   => $row['store_name'],
        'order_price'  => $row['order_price'],
        'shipped_yn'   => $row['shipped_yn'],
        'invoice_no'   => $row['invoice_no'],
        'approved_user'=> $row['approved_user'],
        'ship_date'    => $row['shipped_date'],
        'order_user'   => $row['order_user'],
        'description'  => $row['description'],
				'status'       => $row['status'],
				'action'       => $action,
 				'selected'     => isset($this->request->post['selected']) && in_array($result['id'], $this->request->post['selected']),
			);
    }
    //$this->log->aPrint( $this->data['txs'] );
    
 		$pagination = new Pagination();
		$pagination->total = $total;
		$pagination->page = $page;
		$pagination->limit = $this->config->get('config_admin_limit');
		$pagination->text = $this->language->get('text_pagination');
		$pagination->url = HTTP_SERVER . 'index.php?route=invoice/search&token=' . $this->session->data['token'] . $url . '&page={page}';

		$this->data['pagination'] = $pagination->render();

		$this->data['filter_txid']       = $filter_txid;
		$this->data['filter_store_name'] = $filter_store_name;
		$this->data['filter_ship_date_from']  = $filter_ship_date_from;
		$this->data['filter_ship_date_to']  = $filter_ship_date_to;
		$this->data['filter_shipped_yn'] = $filter_shipped_yn;
		$this->data['filter_invoice_no'] = $filter_invoice_no;
		$this->data['filter_order_user'] = $filter_order_user;
		
    $this->data['sort'] = $sort;
		$this->data['order'] = $order;
    
    $this->data['token'] = $this->session->data['token'];
    
    # call view
    $this->template = 'invoice/search.tpl';
		$this->children = array(
			'common/header',
			'common/footer'
		);
		$this->response->setOutput($this->render(TRUE), $this->config->get('config_compression'));
  }
  
  // todo. move to common lib later , besso 201105 
  public function add_date($givendate,$day=0,$mth=0,$yr=0){
    $givendate = $givendate. ' 00:00:00';
    $cd = strtotime($givendate);
    $newdate = date('Y-m-d', mktime(date('h',$cd),
                    date('i',$cd), date('s',$cd), date('m',$cd)+$mth,
                    date('d',$cd)+$day, date('Y',$cd)+$yr));
    return $newdate;
  }

  public function delete(){
		$this->load->model('invoice/search');
		$deleteList =  $this->request->post['selected'];
		foreach($deleteList as $txid){
		  $this->model_invoice_list->deleteTransaxtion($txid);
		}
		
		$this->session->data['success'] = "Delete done : " . count($deleteList);
		$this->redirect(HTTP_SERVER . 'index.php?route=invoice/search&token=' . $this->session->data['token']);
   	$this->getList();
 	}

}
?>
