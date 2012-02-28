<?php
/**
 * DML for mapping of product and package
 * Model : share product / price
 * besso 201105 
 */
class ControllerMaterialProductPackage extends Controller {
  private $error = array();
  # need one mem for this , besso-201103 
  public $export_qry = '';
  public $title = '';

 	public function index(){
		$this->load->language('material/productpackage');
		$this->document->title = $this->language->get('heading_title');
    $this->title =  $this->language->get('heading_title');
    $this->load->model('product/price');
		$this->getList();
 	}

  public function callMapping(){
	  $product_id  = $this->request->get['product_id'];
	  isset($this->request->get['filter_code']) ? $filter_code = $this->request->get['filter_code'] : $filter_code = '';
	  isset($this->request->get['filter_name']) ? $filter_name = $this->request->get['filter_name'] : $filter_name = '';

		$this->load->model('material/productpackage');
		$this->load->model('material/lookup');
		$this->load->model('product/price');

    $this->data['product']     = $this->model_product_price->getProduct($product_id);
    $this->data['package']     = $this->model_material_productpackage->getProductPackage($product_id);

    $aFilter = array(
      'filter_code' => $filter_code,
      'filter_name' => $filter_name
    );

    $this->data['total']       = $this->model_material_lookup->getTotalPackages($aFilter);

    # some large data, APC caching
    $this->data['packagelist'] = $this->model_material_lookup->getPackages($aFilter);

    $this->data['filter_code'] = $filter_code;
    $this->data['filter_name'] = $filter_name;

    $this->data['token'] = $this->session->data['token'];
    $this->data['action'] = HTTPS_SERVER . 'index.php?route=material/lookup/update&token=' . $this->session->data['token'];

    $this->template = 'material/mapping.tpl';
  	$this->response->setOutput($this->render(TRUE), $this->config->get('config_compression'));
  }

  public function storeMapping(){
    $product_id  = $this->request->get['product_id'];
    $pkgid  = $this->request->get['pkgid'];
    $this->load->model('material/productpackage');
    $this->model_material_productpackage->storePackage($product_id,$pkgid);
    //return 'ok';
  }

  public function export(){
		$this->load->language('material/productpackage');
		$title = $this->language->get('heading_title');
    $export_sql = $this->request->get['export_sql'];
		$ReflectionResponse = new ReflectionClass($this->response);
		if($ReflectionResponse->getMethod('addheader')->getNumberOfParameters() == 2){
			$this->response->addheader('Pragma', 'public');
			$this->response->addheader('Expires', '0');
			$this->response->addheader('Content-Description', 'File Transfer');
			$this->response->addheader("Content-type', 'text/octect-stream");
			$this->response->addheader("Content-Disposition', 'attachment;filename=" . $title . ".csv");
			$this->response->addheader('Content-Transfer-Encoding', 'binary');
			$this->response->addheader('Cache-Control', 'must-revalidate, post-check=0,pre-check=0');
		}else{
			$this->response->addheader('Pragma: public');
			$this->response->addheader('Expires: 0');
			$this->response->addheader('Content-Description: File Transfer');
			$this->response->addheader("Content-type:text/octect-stream");
			$this->response->addheader("Content-Disposition:attachment;filename=" . $title . ".csv");
			$this->response->addheader('Content-Transfer-Encoding: binary');
			$this->response->addheader('Cache-Control: must-revalidate, post-check=0,pre-check=0');
		}
		$this->load->model('tool/csv');
		$this->response->setOutput($this->model_tool_csv->csvExport($title,$export_sql));
  }

  private function getList(){
		$page = isset($this->request->get['page']) ? $this->request->get['page'] : 1 ;
		$sort = isset($this->request->get['sort']) ? $this->request->get['sort'] : 'pd.name' ;

		if(isset($this->request->get['order'])){
			$order = $this->request->get['order'];
		}else{
			$order = 'ASC';
		}

		if(isset($this->request->get['filter_name'])){
			$filter_name = $this->request->get['filter_name'];
		}else{
			$filter_name = NULL;
		}

		if(isset($this->request->get['filter_model'])){
			$filter_model = $this->request->get['filter_model'];
		}else{
			$filter_model = NULL;
		}

		if(isset($this->request->get['filter_price'])){
			$filter_price = $this->request->get['filter_price'];
		}else{
			$filter_price = NULL;
		}

		if(isset($this->request->get['filter_quantity'])){
			$filter_quantity = $this->request->get['filter_quantity'];
		}else{
			$filter_quantity = NULL;
		}
    //$this->log->aPrint( $filter_quantity );
		if(isset($this->request->get['filter_status'])){
			$filter_status = $this->request->get['filter_status'];
		}else{
			$filter_status = NULL;
		}

		if(isset($this->request->get['filter_cat'])){
			$filter_cat = $this->request->get['filter_cat'];
		}else{
			$filter_cat = NULL;
		}

    $filter_thres = isset($this->request->get['filter_thres']) ? $this->request->get['filter_thres'] : NULL ;

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

		if(isset($this->request->get['filter_cat'])){
			$url .= '&filter_cat=' . $this->request->get['filter_cat'];
		}

		if(isset($this->request->get['filter_thres'])){
			$url .= '&filter_thres=' . $this->request->get['filter_thres'];
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

 		$this->document->breadcrumbs = array();

 		$this->document->breadcrumbs[] = array(
   		'href'      => HTTPS_SERVER . 'index.php?route=common/home&token=' . $this->session->data['token'],
   		'text'      => $this->language->get('text_home'),
   		'separator' => FALSE
 		);

   		$this->document->breadcrumbs[] = array(
       		'href'      => HTTPS_SERVER . 'index.php?route=material/productpackage&token=' . $this->session->data['token'] . $url,
       		'text'      => $this->language->get('heading_title'),
      		'separator' => ' :: '
   		);

		$this->data['insert'] = HTTPS_SERVER . 'index.php?route=material/productpackage/insert&token=' . $this->session->data['token'] . $url;
		$this->data['copy'] = HTTPS_SERVER . 'index.php?route=material/productpackage/copy&token=' . $this->session->data['token'] . $url;
		$this->data['delete'] = HTTPS_SERVER . 'index.php?route=material/productpackage/delete&token=' . $this->session->data['token'] . $url;
		
		//$this->data['products'] = array();

		$data = array(
			'filter_name'	  => $filter_name,
			'filter_model'	  => $filter_model,
			'filter_price'	  => $filter_price,
			'filter_quantity' => $filter_quantity,
			'filter_status'   => $filter_status,
			'filter_cat'   => $filter_cat,
			'filter_thres'   => $filter_thres,
			'sort'            => $sort,
			'order'           => $order,
			'start'           => ($page - 1) * $this->config->get('config_admin_limit'),
			'limit'           => $this->config->get('config_admin_limit')
		);
    //$this->log->aPrint( $data );
		$this->load->model('tool/image');
		$product_total = $this->model_product_price->getTotalProducts($data);
		$results = $this->model_product_price->getProducts($data,$this->export_qry);
		//$this->log->aPrint( $results );

    $this->load->model('material/productpackage');
		foreach ($results as $result){
			$action = array();
			$action[] = array(
				'text' => $this->language->get('text_edit'),
				'href' => HTTPS_SERVER . 'index.php?route=material/productpackage/update&token=' . $this->session->data['token'] . '&product_id=' . $result['product_id'] . $url
			);

			if($result['image'] && file_exists(DIR_IMAGE . $result['image'])){
				$image = $this->model_tool_image->resize($result['image'], 60, 60);
			}else{
				$image = $this->model_tool_image->resize('no_image.jpg', 60, 60);
			}

      # get package detail
      $package = $this->model_material_productpackage->getProductPackage($result['product_id']);
      $this->data['packages'][] = array(
				'id'         => $result['product_id'],
				'name'       => $result['name'],
				'model'      => $result['model'],
        //'cat'      => substr($result['model'],0,2),
				'ws_price'   => $result['ws_price'],
				'rt_price'   => $result['rt_price'],
				'image'      => $image,
				'quantity'   => $result['quantity'],
				'pc'         => $result['pc'],
				'thres'      => $result['thres'],
				'package'    => $package,
				'status'     => ($result['status'] ? $this->language->get('text_enabled') : $this->language->get('text_disabled')),
				'selected'   => isset($this->request->post['selected']) && in_array($result['product_id'], $this->request->post['selected']),
				'action'     => $action
			);
      /*
      if($result['product_id'] = '381'){
   	    $this->log->aPrint( $this->data );
      }
      */
   	}

		$this->data['heading_title'] = $this->language->get('heading_title');
		$this->data['text_enabled'] = $this->language->get('text_enabled');
		$this->data['text_disabled'] = $this->language->get('text_disabled');
		$this->data['text_no_results'] = $this->language->get('text_no_results');
		$this->data['text_image_manager'] = $this->language->get('text_image_manager');

		$this->data['column_image'] = $this->language->get('column_image');
		$this->data['column_name'] = $this->language->get('column_name');
    	$this->data['column_model'] = $this->language->get('column_model');
    # , besso-201103 
    $this->data['column_ws_price'] = $this->language->get('column_ws_price');
    $this->data['column_rt_price'] = $this->language->get('column_rt_price');
    
		$this->data['column_quantity'] = $this->language->get('column_quantity');
		$this->data['column_status'] = $this->language->get('column_status');

		$this->data['column_pc'] = $this->language->get('column_pc');

		$this->data['column_action'] = $this->language->get('column_action');

		$this->data['button_copy'] = $this->language->get('button_copy');
		$this->data['button_insert'] = $this->language->get('button_insert');
		$this->data['button_delete'] = $this->language->get('button_delete');
		$this->data['button_filter'] = $this->language->get('button_filter');

    # besso-201103 
    //$this->data['export_qry'] = $this->export_qry;
		$this->data['export'] = HTTPS_SERVER . 'index.php?route=material/productpackage/export&token=' . $this->session->data['token'] . '&export_sql=' . urlencode($this->export_qry);
   
 		$this->data['token'] = $this->session->data['token'];

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

		if($order == 'ASC'){
			$url .= '&order=DESC';
		}else{
			$url .= '&order=ASC';
		}

		$this->data['sort_name'] = HTTPS_SERVER . 'index.php?route=material/productpackage&token=' . $this->session->data['token'] . '&sort=pd.name' . $url;
		$this->data['sort_model'] = HTTPS_SERVER . 'index.php?route=material/productpackage&token=' . $this->session->data['token'] . '&sort=p.model' . $url;
		$this->data['sort_ws_price'] = HTTPS_SERVER . 'index.php?route=material/productpackage&token=' . $this->session->data['token'] . '&sort=p.ws_price' . $url;
		# , besso-201103
		$this->data['sort_rt_price'] = HTTPS_SERVER . 'index.php?route=material/productpackage&token=' . $this->session->data['token'] . '&sort=p.rt_price' . $url;

		$this->data['sort_quantity'] = HTTPS_SERVER . 'index.php?route=material/productpackage&token=' . $this->session->data['token'] . '&sort=p.quantity' . $url;
		$this->data['sort_status'] = HTTPS_SERVER . 'index.php?route=material/productpackage&token=' . $this->session->data['token'] . '&sort=p.status' . $url;
		$this->data['sort_order'] = HTTPS_SERVER . 'index.php?route=material/productpackage&token=' . $this->session->data['token'] . '&sort=p.sort_order' . $url;

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

		if(isset($this->request->get['filter_cat'])){
			$url .= '&filter_cat=' . $this->request->get['filter_cat'];
		}

		if(isset($this->request->get['order'])){
			$url .= '&order=' . $this->request->get['order'];
		}

		$pagination = new Pagination();
		$pagination->total = $product_total;
		$pagination->page = $page;
		$pagination->limit = $this->config->get('config_admin_limit');
		$pagination->text = $this->language->get('text_pagination');
		$pagination->url = HTTPS_SERVER . 'index.php?route=material/productpackage&token=' . $this->session->data['token'] . $url . '&page={page}';

		$this->data['pagination'] = $pagination->render();
    $this->data['count']  = $product_total;
		$this->data['filter_name'] = $filter_name;
		$this->data['filter_model'] = $filter_model;
		$this->data['filter_price'] = $filter_price;
		$this->data['filter_quantity'] = $filter_quantity;
		$this->data['filter_cat'] = $filter_cat;
		$this->data['filter_status'] = $filter_status;
		$this->data['filter_thres'] = $filter_thres;

		$this->data['sort'] = $sort;
		$this->data['order'] = $order;

//		$this->template = 'material/productpackage.tpl';
		$this->template = 'material/pp.tpl';
		$this->children = array(
			'common/header',
			'common/footer'
		);

		$this->response->setOutput($this->render(TRUE), $this->config->get('config_compression'));
 	}

	public function category(){
		$this->load->model('product/price');
		if(isset($this->request->get['category_id'])){
			$category_id = $this->request->get['category_id'];
		}else{
			$category_id = 0;
		}
		$product_data = array();
		$results = $this->model_product_price->getProductsByCategoryId($category_id);
		foreach ($results as $result){
			$product_data[] = array(
				'product_id' => $result['product_id'],
				'name'       => $result['name'],
				'model'      => $result['model']
			);
		}
		$this->load->library('json');
		$this->response->setOutput(Json::encode($product_data));
	}

	public function related(){
		$this->load->model('product/price');
		if(isset($this->request->post['product_related'])){
			$products = $this->request->post['product_related'];
		}else{
			$products = array();
		}
		$product_data = array();

		foreach ($products as $product_id){
			$product_info = $this->model_product_price->getProduct($product_id);
			if($product_info){
				$product_data[] = array(
					'product_id' => $product_info['product_id'],
					'name'       => $product_info['name'],
					'model'      => $product_info['model']
				);
			}
		}
		$this->load->library('json');
		$this->response->setOutput(Json::encode($product_data));
	}
}
?>