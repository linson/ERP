<?php
class ControllerMaterialLookup extends Controller{
	private $error = array();
 	public function index(){
		$this->load->model('material/lookup');
		$this->getList();
 	}

 	public function delete(){
   	$this->load->language('material/lookup');
   	$this->document->title = $this->language->get('heading_title');
		$this->load->model('material/lookup');
		if(isset($this->request->post['selected']) && $this->validateDelete()){
			foreach ($this->request->post['selected'] as $id){
				$this->model_material_lookup->deletePackage($id);
  		}
			$this->session->data['success'] = $this->language->get('text_success');
			$url = '';
			if(isset($this->request->get['filter_name'])){
				$url .= '&filter_name=' . $this->request->get['filter_name'];
			}
			if(isset($this->request->get['filter_model'])){
				$url .= '&filter_model=' . $this->request->get['filter_model'];
			}
			if(isset($this->request->get['filter_price'])){
				$url .= '&filter_price=' . $this->request->get['filter_price'];
			}
			if(isset($this->request->get['filter_quantity'])){
				$url .= '&filter_quantity=' . $this->request->get['filter_quantity'];
			}
			if(isset($this->request->get['filter_status'])){
				$url .= '&filter_status=' . $this->request->get['filter_status'];
			}
			if(isset($this->request->get['page'])){
				$url .= '&page=' . $this->request->get['page'];
			}
			if(isset($this->request->get['sort'])){
				$url .= '&sort=' . $this->request->get['sort'];
			}
			if(isset($this->request->get['order'])){
				$url .= '&order=' . $this->request->get['order'];
			}
			$this->redirect(HTTPS_SERVER . 'index.php?route=material/lookup&token=' . $this->session->data['token'] . $url);
		}
   	$this->getList();
 	}

 	private function getList(){
 		isset($this->error['warning']) ? $this->data['error_warning'] = $this->error['warning'] : $this->data['error_warning'] = '';
		isset($this->session->data['success']) ? $this->data['success'] = $this->session->data['success'] : $this->data['success'] = '';
		unset($this->session->data['success']);

    //$this->log->aPrint( 'start getList()' );
    $page   = $this->util->parseRequest('page','get','1');
    $sort   = $this->util->parseRequest('sort','get','code');
    $order  = $this->util->parseRequest('order','get','ASC');
    $filter_code      = $this->util->parseRequest('filter_code','get');
    $filter_name      = $this->util->parseRequest('filter_name','get');
    $filter_desc      = $this->util->parseRequest('filter_desc','get');
    $filter_cat       = $this->util->parseRequest('filter_cat','get');
    $filter_price     = $this->util->parseRequest('filter_price','get');
    $filter_quantity  = $this->util->parseRequest('filter_quantity','get');
    $filter_thres  = $this->util->parseRequest('filter_thres','get');
    $filter_status    = $this->util->parseRequest('filter_status','get','1');

    //$this->log->aPrint( $filter_status );

		$url = '';
		if($page) $url.='&page='.$page;
		if($sort) $url.='&sort='.$sort;
		if($order) $url.='&order='.$order;
		if($filter_code) $url.='&filter_code='.$filter_code;
		if($filter_name) $url.='&filter_name='.$filter_name;
		if($filter_desc) $url.='&filter_desc='.$filter_desc;
		if($filter_cat)  $url.='&filter_cat='.$filter_cat;
		if($filter_price) $url.='&filter_price='.$filter_price;
		if($filter_quantity) $url.='&filter_quantity='.$filter_quantity;
		if($filter_thres) $url.='&filter_thres='.$filter_thres;
		if($filter_status) $url.='&filter_status='.$filter_status;
    //echo 'url : ' . $url; 

		$this->data['heading_title'] = 'Material - Package';
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
      'href'      => HTTPS_SERVER . 'index.php?route=material/lookup&token=' . $this->session->data['token'] . $url,
      'text'      => 'Material - Package',
      'separator' => ' :: '
   	);

		$this->data['insert'] = HTTPS_SERVER . 'index.php?route=material/lookup/insert&token=' . $this->session->data['token'] . $url;
		$this->data['copy'] = HTTPS_SERVER . 'index.php?route=material/lookup/copy&token=' . $this->session->data['token'] . $url;
		$this->data['delete'] = HTTPS_SERVER . 'index.php?route=material/lookup/delete&token=' . $this->session->data['token'] . $url;

		$this->data['packages'] = array();
		$data = array(
			'filter_code'	    => $filter_code,
			'filter_name'	    => $filter_name,
			'filter_desc'	    => $filter_desc,
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
		$package_total = $this->model_material_lookup->getTotalPackages($data);
		$results = $this->model_material_lookup->getPackages($data);
		//$this->log->aPrint( $results );
		foreach ($results as $result){
			$action = array();
			$action[] = array(
				'text' => $this->language->get('text_edit'),
				'href' => HTTPS_SERVER . 'index.php?route=material/lookup/update&token=' . $this->session->data['token'] . '&id=' . $result['id'] . $url
			);
			if($result['image'] && file_exists(DIR_IMAGE . $result['image'])){
				$image = $this->model_tool_image->resize($result['image'], 60, 60);
			}else{
				$image = $this->model_tool_image->resize('no_image.jpg', 60, 60);
			}
			$this->data['packages'][] = array(
			  'id' => $result['id'],
			  'code'   => $result['code'],
			  'name'       => $result['name'],
			  'cat'        => $result['cat'],
			  'price'      => $result['price'],
			  'image'      => $image,
			  'quantity'   => $result['quantity'],
			  'thres'      => $result['thres'],
			  'company'      => $result['company'],
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

		$this->data['sort_name'] = HTTPS_SERVER . 'index.php?route=material/lookup&token=' . $this->session->data['token'] . '&sort=pd.name' . $url;
		$this->data['sort_price'] = HTTPS_SERVER . 'index.php?route=material/lookup&token=' . $this->session->data['token'] . '&sort=p.price' . $url;
		$this->data['sort_quantity'] = HTTPS_SERVER . 'index.php?route=material/lookup&token=' . $this->session->data['token'] . '&sort=p.quantity' . $url;
		$this->data['sort_status'] = HTTPS_SERVER . 'index.php?route=material/lookup&token=' . $this->session->data['token'] . '&sort=p.status' . $url;
		$this->data['sort_order'] = HTTPS_SERVER . 'index.php?route=material/lookup&token=' . $this->session->data['token'] . '&sort=p.sort_order' . $url;

		$pagination = new Pagination();
		$pagination->total = $package_total;
		$pagination->page = $page;
		$pagination->limit = $this->config->get('config_admin_limit');
		$pagination->text = $this->language->get('text_pagination');
		$pagination->url = HTTPS_SERVER . 'index.php?route=material/lookup&token=' . $this->session->data['token'] . $url . '&page={page}';

		$this->data['pagination'] = $pagination->render();

		$this->data['filter_code'] = $filter_code;
		$this->data['filter_name'] = $filter_name;
		$this->data['filter_desc'] = $filter_desc;
		$this->data['filter_cat'] = $filter_cat;
		$this->data['filter_price'] = $filter_price;
		$this->data['filter_quantity'] = $filter_quantity;
		$this->data['filter_thres'] = $filter_thres;
		$this->data['filter_status'] = $filter_status;

		$this->data['sort'] = $sort;
		$this->data['order'] = $order;

		$this->template = 'material/lookup.tpl';
		$this->children = array(
			'common/header',
			'common/footer'
		);

		$this->response->setOutput($this->render(TRUE), $this->config->get('config_compression'));
  }

  // ajax call for callQuickUpdate
  public function callQuickUpdate(){
    $id = $this->request->get['id'];
    $quantity = $this->request->get['quantity'];
    $price    = $this->request->get['price'];

    isset($this->request->get['desc']) ? $desc = $this->request->get['desc'] : $desc = 'stored';
		$this->load->model('material/lookup');
    $this->model_material_lookup->callQuickUpdate($id,$quantity,$price,$desc);
  }

  // ajax call for update pannel
  public function callUpdatePannel(){
    $ddl = $this->request->get['ddl'];
    if('insert' == $ddl){
      $this->data['action'] = HTTPS_SERVER . 'index.php?route=material/lookup/insert&token=' . $this->session->data['token'];
    }else{
  	  $id = $this->request->get['id'];
  		$this->load->model('material/lookup');
      $this->data['data'] = $this->model_material_lookup->getOneData($id);
      $this->data['token'] = $this->session->data['token'];
      $this->data['action'] = HTTPS_SERVER . 'index.php?route=material/lookup/update&token=' . $this->session->data['token'];
    }
    $this->data['ddl'] = $ddl;
    $this->template = 'material/updatePannel.tpl';
  	$this->response->setOutput($this->render(TRUE), $this->config->get('config_compression'));
  }

  // ajax call for update pannel
  public function callHistoryPannel(){
	  $id = $this->request->get['id'];
		$this->load->model('material/lookup');
    $this->data['data'] = $this->model_material_lookup->getHistoryData($id);
    $this->data['token'] = $this->session->data['token'];
    $this->template = 'material/historyPannel.tpl';
  	$this->response->setOutput($this->render(TRUE), $this->config->get('config_compression'));
  }

  public function insert(){
    //$this->log->aPrint( $this->request );
  	$this->load->model('material/lookup');
    if($this->model_material_lookup->insertPackage($this->request->post)){
      $this->getList();
    }else{
      echo "<script>alert('update fail');</script>";
    }
  }

  public function update(){
    //$this->log->aPrint( $this->request );  	exit;
  	$this->load->model('material/lookup');
    if($this->model_material_lookup->updatePackage($this->request->post)){
      $this->getList();
    }else{
      echo "<script>alert('update fail');</script>";
    }
  }

	public function category(){
		$this->load->model('material/lookup');
		if(isset($this->request->get['category_id'])){
			$category_id = $this->request->get['category_id'];
		}else{
			$category_id = 0;
		}
		$package_data = array();
		$results = $this->model_material_lookup->getPackagesByCategoryId($category_id);
		foreach ($results as $result){
			$package_data[] = array(
				'id' => $result['id'],
				'name'       => $result['name'],
				'model'      => $result['model']
			);
		}
		$this->load->library('json');
		$this->response->setOutput(Json::encode($package_data));
	}

	public function related(){
		$this->load->model('material/lookup');
		$package_data = array();
		isset($this->request->post['package_related']) ? $packages = $this->request->post['package_related'] :	$packages = array();
		foreach($packages as $id){
			$package_info = $this->model_material_lookup->getPackage($id);
			if($package_info){
				$package_data[] = array(
					'id' => $package_info['id'],
					'name'       => $package_info['name'],
					'model'      => $package_info['model']
				);
			}
		}
		$this->load->library('json');
		$this->response->setOutput(Json::encode($package_data));
	}
	
	public function updateQuantity(){
  	$this->load->model('product/price');
    if(!$this->model_product_price->updateQuantity($this->request->get)){
      echo "Update Fail";
    }
  }
}
?>