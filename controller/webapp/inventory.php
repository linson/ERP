<?php
class ControllerWebappInventory extends Controller {
	private $error = array();

 	public function index(){
		// controlling part
		$this->getList();
 	}

  public function getQuantity(){
    $model = $this->request->get['model'];
  	$this->load->model('product/inventory');
    $aRes = $this->model_product_inventory->getQuantity($model);
    if(count($aRes) > 0){
      echo json_encode($aRes);
    }else{
      echo '';
    }
  }

  public function updateQuantity(){
    $product_id = $this->request->get['product_id'];
    $quantity = $this->request->get['quantity'];
 		$this->load->model('product/inventory');
    if($this->model_product_inventory->updateProduct($product_id, $this->request->get)){
      echo 'success';
    }
  }

 	private function getList(){
 		isset($this->error['warning']) ? $this->data['error_warning'] = $this->error['warning'] : $this->data['error_warning'] = '';
		isset($this->session->data['success']) ? $this->data['success'] = $this->session->data['success'] : $this->data['success'] = '';
		unset($this->session->data['success']);
		
		## OEM TASK
    $this->load->model('product/oem');

		$data = array(
			'filter_name'	  => '',
			'filter_model_from'	  => '',
			'filter_model_to'	  => '',
			'filter_price'	  => '',
			'filter_quantity' => '',
			'filter_status'   => '',
			'sort'            => 'DESC',
			'order'           => '',
			'start'           => '0',
			'limit'           => '200'
		);
    $export = '';
    
		$product_total = $this->model_product_oem->getTotalProducts($data);
		$results = $this->model_product_oem->getProducts($data,$export);
		//print($this->export_qry);

		foreach($results as $result) {
			$action = array();

			$action[] = array(
				'text' => $this->language->get('text_edit'),
				'href' => HTTPS_SERVER . 'index.php?route=product/oem/update' . '&product_id=' . $result['product_id']
			);

      $this->data['products'][] = array(
				'product_id' => $result['product_id'],
				'name'       => $result['name'],
				'model'      => $result['model'],
				'ws_price'      => $result['ws_price'],
				'rt_price'      => $result['rt_price'],				
				'special'    => '',
				'image'      => '',
				'quantity'   => $result['quantity'],
				'pc'         => $result['pc'],
				'status'     => ($result['status'] ? $this->language->get('text_enabled') : $this->language->get('text_disabled')),
				'selected'   => isset($this->request->post['selected']) && in_array($result['product_id'], $this->request->post['selected']),
				'action'     => $action
			);
    }

/***
    //$this->log->aPrint( 'start getList()' );
    $page   = $this->util->parseRequest('page','get','1');
    $sort   = $this->util->parseRequest('sort','get','name');
    $order  = $this->util->parseRequest('order','get','ASC');
    $filter_name      = $this->util->parseRequest('filter_name','get');
    $filter_cat       = $this->util->parseRequest('filter_cat','get');
    $filter_price     = $this->util->parseRequest('filter_price','get');
    $filter_quantity  = $this->util->parseRequest('filter_quantity','get');
    $filter_thres  = $this->util->parseRequest('filter_thres','get');
    $filter_status    = $this->util->parseRequest('filter_status','get','1');
    
		$url = '';
		if($page) $url.='&page='.$page;
		if($sort) $url.='&sort='.$sort;
		if($order) $url.='&order='.$order;
		if($filter_name) $url.='&filter_name='.$filter_name;
		if($filter_cat)  $url.='&filter_cat='.$filter_cat;
		if($filter_price) $url.='&filter_price='.$filter_price;
		if($filter_quantity) $url.='&filter_quantity='.$filter_quantity;
		if($filter_thres) $url.='&filter_thres='.$filter_thres;
		if($filter_status) $url.='&filter_status='.$filter_status;
    //echo 'url : ' . $url; 

		$this->data['heading_title'] = 'Webapp - Package';
		$this->data['text_enabled'] = $this->language->get('text_enabled');
		$this->data['text_disabled'] = $this->language->get('text_disabled');
		$this->data['text_no_results'] = $this->language->get('text_no_results');
		$this->data['text_image_manager'] = $this->language->get('text_image_manager');

 		$this->document->breadcrumbs = array();
 		$this->document->breadcrumbs[] = array(
   		'href'      => HTTPS_SERVER . 'index.php?route=common/home&token=' . $this->session->data['token'],
      'text'      => $this->language->get('text_home'),
      'separator' => FALSE
   	);
 		$this->document->breadcrumbs[] = array(
      'href'      => HTTPS_SERVER . 'index.php?route=webapp/inventory&token=' . $this->session->data['token'] . $url,
      'text'      => 'Webapp - Package',
      'separator' => ' :: '
   	);

		$this->data['insert'] = HTTPS_SERVER . 'index.php?route=webapp/inventory/insert&token=' . $this->session->data['token'] . $url;
		$this->data['copy'] = HTTPS_SERVER . 'index.php?route=webapp/inventory/copy&token=' . $this->session->data['token'] . $url;
		$this->data['delete'] = HTTPS_SERVER . 'index.php?route=webapp/inventory/delete&token=' . $this->session->data['token'] . $url;


		$this->data['packages'] = array();
		$data = array(
			'filter_name'	    => $filter_name,
			'filter_cat'	    => $filter_cat,
			'filter_price'	  => $filter_price,
			'filter_quantity' => $filter_quantity,
			'filter_thres' => $filter_thres,
			'filter_status'   => $filter_status,
			'sort'            => $sort,
			'order'           => $order,
			'start'           => ($page - 1) * $this->config->get('config_admin_limit'),
			'limit'           => $this->config->get('config_admin_limit')
		);

		$this->load->model('tool/image');
		$package_total = $this->model_webapp_inventory->getTotalPackages($data);
		$results = $this->model_webapp_inventory->getPackages($data);
		foreach ($results as $result) {
			$action = array();
			$action[] = array(
				'text' => $this->language->get('text_edit'),
				'href' => HTTPS_SERVER . 'index.php?route=webapp/inventory/update&token=' . $this->session->data['token'] . '&id=' . $result['id'] . $url
			);

			if($result['image'] && file_exists(DIR_IMAGE . $result['image'])){
				$image = $this->model_tool_image->resize($result['image'], 60, 60);
			}else{
				$image = $this->model_tool_image->resize('no_image.jpg', 60, 60);
			}
      $this->data['packages'][] = array(
			  'id' => $result['id'],
			  'name'       => $result['name'],
			  'cat'        => $result['cat'],
			  'price'      => $result['price'],
			  'image'      => $image,
			  'quantity'   => $result['quantity'],
			  'thres'      => $result['thres'],
			  'status'     => ($result['status'] ? 'IN USE' : 'Unuse'),
			  'selected'   => isset($this->request->post['selected']) && in_array($result['id'], $this->request->post['selected']),
			  'action'     => $action
		  );
    }

		$this->data['button_copy'] = $this->language->get('button_copy');
		$this->data['button_insert'] = $this->language->get('button_insert');
		$this->data['button_delete'] = $this->language->get('button_delete');
		$this->data['button_filter'] = $this->language->get('button_filter');
 		$this->data['token'] = $this->session->data['token'];

		$this->data['sort_name'] = HTTPS_SERVER . 'index.php?route=webapp/inventory&token=' . $this->session->data['token'] . '&sort=pd.name' . $url;
		$this->data['sort_price'] = HTTPS_SERVER . 'index.php?route=webapp/inventory&token=' . $this->session->data['token'] . '&sort=p.price' . $url;
		$this->data['sort_quantity'] = HTTPS_SERVER . 'index.php?route=webapp/inventory&token=' . $this->session->data['token'] . '&sort=p.quantity' . $url;
		$this->data['sort_status'] = HTTPS_SERVER . 'index.php?route=webapp/inventory&token=' . $this->session->data['token'] . '&sort=p.status' . $url;
		$this->data['sort_order'] = HTTPS_SERVER . 'index.php?route=webapp/inventory&token=' . $this->session->data['token'] . '&sort=p.sort_order' . $url;

		$pagination = new Pagination();
		$pagination->total = $package_total;
		$pagination->page = $page;
		$pagination->limit = $this->config->get('config_admin_limit');
		$pagination->text = $this->language->get('text_pagination');
		$pagination->url = HTTPS_SERVER . 'index.php?route=webapp/inventory&token=' . $this->session->data['token'] . $url . '&page={page}';

		$this->data['pagination'] = $pagination->render();

		$this->data['filter_name'] = $filter_name;
		$this->data['filter_cat'] = $filter_cat;
		$this->data['filter_price'] = $filter_price;
		$this->data['filter_quantity'] = $filter_quantity;
		$this->data['filter_thres'] = $filter_thres;
		$this->data['filter_status'] = $filter_status;

		$this->data['sort'] = $sort;
		$this->data['order'] = $order;
***/
		$this->template = 'webapp/inventory.tpl';
		$this->response->setOutput($this->render(TRUE), $this->config->get('config_compression'));
  }


  public function update() {
    	$this->load->language('product/oem');
    	$this->document->title = $this->language->get('heading_title');
  		$this->load->model('product/oem');
      $product_id = $this->request->get['product_id'];
      $quantity = $this->request->get['quantity'];
      
      if (($this->request->server['REQUEST_METHOD'] == 'GET')) {
        $this->model_product_oem->updateProduct($this->request->get['product_id'], $this->request->get);
      }
    	//print_r($this->request->get);
    	//if (($this->request->server['REQUEST_METHOD'] == 'POST') && $this->validateForm()) {
			//$this->model_product_oem->editProduct($this->request->get['product_id'], $this->request->post);
      /**
			$this->session->data['success'] = $this->language->get('text_success');
			$url = '';
			if (isset($this->request->get['filter_model_from'])) {
				$url .= '&filter_model_from=' . $this->request->get['filter_model_from'];
			}
			if (isset($this->request->get['filter_model_to'])) {
				$url .= '&filter_model_to=' . $this->request->get['filter_model_to'];
			}
      $this->redirect(HTTPS_SERVER . 'index.php?route=product/oem' . $url);
    	$this->getList();
    	**/
  }

}
?>