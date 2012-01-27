<?php
class ControllerMaterialHistory extends Controller {
 	public function index(){
		$this->load->model('material/history');
		$this->load->model('product/price');
		$this->getList();
 	}

 	private function getList(){
 		isset($this->error['warning']) ? $this->data['error_warning'] = $this->error['warning'] : $this->data['error_warning'] = '';
		isset($this->session->data['success']) ? $this->data['success'] = $this->session->data['success'] : $this->data['success'] = '';
		unset($this->session->data['success']);
    //$this->log->aPrint( 'start getList()' );
    $page   = $this->util->parseRequest('page','get','1');
    $sort   = $this->util->parseRequest('sort','get','ph.up_date');
    $order  = $this->util->parseRequest('order','get','ASC');
    $filter_code      = $this->util->parseRequest('filter_code','get');
    $filter_name      = $this->util->parseRequest('filter_name','get');
    $filter_product   = $this->util->parseRequest('filter_product','get');
    $filter_cat       = $this->util->parseRequest('filter_cat','get');
    $filter_history_from     = $this->util->parseRequest('filter_history_from','get',date('Y-m-d'));
    $filter_history_to       = $this->util->parseRequest('filter_history_to','get',date('Y-m-d'));
    //$this->log->aPrint( $filter_status );
		$url = '';
		if($page) $url.='&page='.$page;
		if($sort) $url.='&sort='.$sort;
		if($order) $url.='&order='.$order;
		if($filter_code) $url.='&filter_code='.$filter_code;
		if($filter_name) $url.='&filter_name='.$filter_name;
		if($filter_product) $url.='&filter_product='.$filter_product;
		if($filter_cat)  $url.='&filter_cat='.$filter_cat;
		if($filter_history_from)  $url.='&filter_history_from='.$filter_history_from;
		if($filter_history_to)    $url.='&filter_history_to='.$filter_history_to;
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
      'href'      => HTTPS_SERVER . 'index.php?route=material/history&token=' . $this->session->data['token'] . $url,
      'text'      => 'Material - History',
      'separator' => ' :: '
   	);

		$this->data['packages'] = array();
		$data = array(
			'filter_code'	    => $filter_code,
			'filter_name'	    => $filter_name,
			'filter_product'	    => $filter_product,
			'filter_cat'	    => $filter_cat,
			'filter_history_from'	    => $filter_history_from,
			'filter_history_to'	    => $filter_history_to,
			'sort'            => $sort,
			'order'           => $order,
			'start'           => ($page - 1) * $this->config->get('config_admin_limit'),
			'limit'           => $this->config->get('config_admin_limit')
		);

		$this->load->model('tool/image');
		$package_total = $this->model_material_history->getTotalHistory($data);
		$results = $this->model_material_history->getHistory($data);
		//$this->log->aPrint( $results );
		foreach ($results as $result){
			$action = array();
			$action[] = array(
				'text' => $this->language->get('text_edit'),
				'href' => HTTPS_SERVER . 'index.php?route=material/history/update&token=' . $this->session->data['token'] . '&id=' . $result['id'] . $url
			);
			if($result['image'] && file_exists(DIR_IMAGE . $result['image'])){
				$image = $this->model_tool_image->resize($result['image'], 60, 60);
			}else{
				$image = $this->model_tool_image->resize('no_image.jpg', 60, 60);
			}
			$model = '';
			if('' != $result['final']){
			  $model = $this->model_product_price->getProductModel($result['final']);
			}
			$this->data['packages'][] = array(
			  'id'       => $result['id'],
			  'code'     => $result['code'],
			  'name'     => $result['name'],
			  'final'    => $result['final'],
			  'model'    => $model,
			  'quantity' => $result['quantity'],
			  'cat'      => $result['cat'],
			  'image'    => $image,
			  'up_date'  => $this->util->date_format_kr($result['up_date']),
			  'diff'     => $result['diff'],
			  'rep'      => $result['rep'],
			  'comment'  => $result['comment'],
			  'selected' => isset($this->request->post['selected']) && in_array($result['id'], $this->request->post['selected']),
			  'action'   => $action
		  );
    }
		$this->data['button_copy'] = $this->language->get('button_copy');
		$this->data['button_insert'] = $this->language->get('button_insert');
		$this->data['button_delete'] = $this->language->get('button_delete');
		$this->data['button_filter'] = $this->language->get('button_filter');
 		$this->data['token'] = $this->session->data['token'];
		$this->data['sort_name'] = HTTPS_SERVER . 'index.php?route=material/history&token=' . $this->session->data['token'] . '&sort=p.name' . $url;
		$this->data['sort_quantity'] = HTTPS_SERVER . 'index.php?route=material/history&token=' . $this->session->data['token'] . '&sort=p.quantity' . $url;

		$pagination = new Pagination();
		$pagination->total = $package_total;
		$pagination->page = $page;
		$pagination->limit = $this->config->get('config_admin_limit');
		$pagination->text = $this->language->get('text_pagination');
		$pagination->url = HTTPS_SERVER . 'index.php?route=material/history&token=' . $this->session->data['token'] . $url . '&page={page}';

		$this->data['pagination'] = $pagination->render();
		$this->data['filter_code'] = $filter_code;
		$this->data['filter_name'] = $filter_name;
		$this->data['filter_product'] = $filter_product;
		$this->data['filter_cat'] = $filter_cat;
		$this->data['filter_history_from'] = $filter_history_from;
		$this->data['filter_history_to'] = $filter_history_to;

		$this->data['sort'] = $sort;
		$this->data['order'] = $order;
		$this->template = 'material/history.tpl';
		$this->children = array(
			'common/header',
			'common/footer'
		);
		$this->response->setOutput($this->render(TRUE), $this->config->get('config_compression'));
  }
}
?>