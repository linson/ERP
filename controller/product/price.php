<?php
class ControllerProductPrice extends Controller{
  private $error = array();
  public $export_qry = '';
  public $title = '';

 	public function index(){
		$this->load->language('product/price');
		$this->document->title = $this->language->get('heading_title');
    $this->title =  $this->language->get('heading_title');
    $this->load->model('product/price');
		$this->getList();
 	}

  public function export(){
		$this->load->language('product/price');
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

  public function insert(){
    	$this->load->language('product/price');
    	$this->document->title = $this->language->get('heading_title');
		  $this->load->model('product/price');
    	if(($this->request->server['REQUEST_METHOD'] == 'POST') && $this->validateForm()){
			$this->model_product_price->addProduct($this->request->post);

			$this->session->data['success'] = $this->language->get('text_success');

			$url = '';

			if(isset($this->request->get['filter_name'])){
				$url .= '&filter_name=' . $this->request->get['filter_name'];
			}

			if(isset($this->request->get['filter_model'])){
				$url .= '&filter_model_from=' . $this->request->get['filter_model_from'];
			}
      /***
			if(isset($this->request->get['filter_model_to'])){
				$url .= '&filter_model_to=' . $this->request->get['filter_model_to'];
			}
      ***/
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

			$this->redirect(HTTPS_SERVER . 'index.php?route=product/price&token=' . $this->session->data['token'] . $url);
    	}

    	$this->getForm();
  	}

  	public function update(){
  		$this->load->model('product/price');
      $req = array();
      if(isset($this->request->get['product_id'])){
        $product_id = $this->request->get['product_id'];
      }
      if(isset($this->request->get['ws_price'])){
        $key = 'ws_price';
        $val = $this->request->get['ws_price'];
      }
      if(isset($this->request->get['rt_price'])){
        $key = 'rt_price';
        $val = $this->request->get['rt_price'];
      }
      if(isset($this->request->get['quantity'])){
        $key = 'quantity';
        $val = $this->request->get['quantity'];
      }
      $this->load->model('product/price');
      $this->model_product_price->update($product_id,$key,$val);
  	}

  public function updatePackage(){
    $this->load->model('product/price');
    $this->model_product_price->updatePackage($this->request->get);
  }

  public function delete(){
    $this->load->language('product/price');
    $this->document->title = $this->language->get('heading_title');
		$this->load->model('product/price');
		if(isset($this->request->post['selected']) && $this->validateDelete()){
			foreach ($this->request->post['selected'] as $product_id){
				$this->model_product_price->deleteProduct($product_id);
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

			$this->redirect(HTTPS_SERVER . 'index.php?route=product/price&token=' . $this->session->data['token'] . $url);
		}

    	$this->getList();
  	}

  public function copy(){
    	$this->load->language('product/price');

    	$this->document->title = $this->language->get('heading_title');

		$this->load->model('product/price');

		if(isset($this->request->post['selected']) && $this->validateCopy()){
			foreach ($this->request->post['selected'] as $product_id){
				$this->model_product_price->copyProduct($product_id);
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
			$this->redirect(HTTPS_SERVER . 'index.php?route=product/price&token=' . $this->session->data['token'] . $url);
		}
    	$this->getList();
  }

  private function getList(){
		isset($this->request->get['page']) ? $page = $this->request->get['page'] : $page = 1;
		isset($this->request->get['sort']) ? $sort = $this->request->get['sort'] : $sort = 'pd.name';
		isset($this->request->get['order'])? $order = $this->request->get['order'] : $order = 'ASC';
		isset($this->request->get['filter_name']) ? $filter_name = $this->request->get['filter_name'] : $filter_name = NULL;
		isset($this->request->get['filter_pid']) ? $filter_pid = $this->request->get['filter_pid'] : $filter_pid = NULL;
		isset($this->request->get['filter_model']) ? $filter_model = $this->request->get['filter_model'] : $filter_model = NULL;
		isset($this->request->get['filter_oem']) ? $filter_oem = $this->request->get['filter_oem'] : $filter_oem = 'n';
		isset($this->request->get['filter_price']) ? $filter_price = $this->request->get['filter_price'] : $filter_price = NULL;
		isset($this->request->get['filter_quantity']) ? $filter_quantity = $this->request->get['filter_quantity'] : $filter_quantity = NULL;
		isset($this->request->get['filter_status']) ? $filter_status = $this->request->get['filter_status'] : $filter_status = NULL;
		isset($this->request->get['filter_cat']) ? $filter_cat = $this->request->get['filter_cat'] : $filter_cat = NULL;

		$url = '';
		if(isset($this->request->get['filter_name'])) $url .= '&filter_name=' . $this->request->get['filter_name'];
		if(isset($this->request->get['filter_model']))  $url .= '&filter_model=' . $this->request->get['filter_model'];
		if(isset($this->request->get['filter_oem']))  $url .= '&filter_oem=' . $this->request->get['filter_oem'];
		if(isset($this->request->get['filter_price']))  $url .= '&filter_price=' . $this->request->get['filter_price'];
		if(isset($this->request->get['filter_quantity'])) $url .= '&filter_quantity=' . $this->request->get['filter_quantity'];
		if(isset($this->request->get['filter_status'])) $url .= '&filter_status=' . $this->request->get['filter_status'];
		if(isset($this->request->get['filter_cat']))  $url .= '&filter_cat=' . $this->request->get['filter_cat'];
		if(isset($this->request->get['page']))  $url .= '&page=' . $this->request->get['page'];
		if(isset($this->request->get['sort']))  $url .= '&sort=' . $this->request->get['sort'];
		if(isset($this->request->get['order'])) $url .= '&order=' . $this->request->get['order'];

		$this->document->breadcrumbs = array();
 		$this->document->breadcrumbs[] = array(
     	'href'      => HTTPS_SERVER . 'index.php?route=common/home&token=' . $this->session->data['token'],
     	'text'      => $this->language->get('text_home'),
    	'separator' => FALSE
 		);
 		$this->document->breadcrumbs[] = array(
     	'href'      => HTTPS_SERVER . 'index.php?route=product/price&token=' . $this->session->data['token'] . $url,
     	'text'      => $this->language->get('heading_title'),
    	'separator' => ' :: '
 		);

		$this->data['insert'] = HTTPS_SERVER . 'index.php?route=product/price/insert&token=' . $this->session->data['token'] . $url;
		$this->data['copy'] = HTTPS_SERVER . 'index.php?route=product/price/copy&token=' . $this->session->data['token'] . $url;
		$this->data['delete'] = HTTPS_SERVER . 'index.php?route=product/price/delete&token=' . $this->session->data['token'] . $url;
		$data = array(
			'filter_name'	  => $filter_name,
			'filter_pid'	  => $filter_pid,
			'filter_model'	  => $filter_model,
			'filter_oem'	    => $filter_oem,
			'filter_price'	  => $filter_price,
			'filter_quantity' => $filter_quantity,
			'filter_status'   => $filter_status,
			'filter_cat'   => $filter_cat,
			'sort'            => $sort,
			'order'           => $order,
			'start'           => ($page - 1) * $this->config->get('config_admin_limit'),
			'limit'           => $this->config->get('config_admin_limit')
		);
		$this->load->model('tool/image');
		$product_total = $this->model_product_price->getTotalProducts($data);
		$results = $this->model_product_price->getProducts($data,$this->export_qry);
		foreach ($results as $result){
			$action = array();
			$action[] = array(
				'text' => $this->language->get('text_edit'),
				'href' => HTTPS_SERVER . 'index.php?route=product/price/update&token=' . $this->session->data['token'] . '&product_id=' . $result['product_id'] . $url
			);
			if($result['image'] && file_exists(DIR_IMAGE . $result['image'])){
				$image = $this->model_tool_image->resize($result['image'], 60, 60);
			}else{
				$image = $this->model_tool_image->resize('no_image.jpg', 60, 60);
			}
			$product_specials = $this->model_product_price->getProductSpecials($result['product_id']);
      if($product_specials){
        $special = reset($product_specials);
        if($special['date_start'] > date('Y-m-d') || $special['date_end'] < date('Y-m-d')){
          $special = FALSE;
        }
      }else{
        $special = FALSE;
      }
      $this->data['products'][] = array(
				'product_id' => $result['product_id'],
				'name'       => $result['name'],
				'model'      => $result['model'],
        //'cat'      => substr($result['model'],0,2),
				'ws_price'   => $result['ws_price'],
				'rt_price'   => $result['rt_price'],				
				'special'    => $special['price'],
				'image'      => $image,
				'quantity'   => $result['quantity'],
				'pc'         => $result['pc'],
				'status'     => ($result['status'] ? $this->language->get('text_enabled') : $this->language->get('text_disabled')),
				'selected'   => isset($this->request->post['selected']) && in_array($result['product_id'], $this->request->post['selected']),
				'action'     => $action
			);
    }

		$this->data['heading_title'] = $this->language->get('heading_title');
		$this->data['text_enabled'] = $this->language->get('text_enabled');
		$this->data['text_disabled'] = $this->language->get('text_disabled');
		$this->data['text_no_results'] = $this->language->get('text_no_results');
		$this->data['text_image_manager'] = $this->language->get('text_image_manager');
		$this->data['column_image'] = $this->language->get('column_image');
		$this->data['column_name'] = $this->language->get('column_name');
    $this->data['column_model'] = $this->language->get('column_model');
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

		$this->data['export'] = HTTPS_SERVER . 'index.php?route=product/price/export&token=' . $this->session->data['token'] . '&export_sql=' . urlencode($this->export_qry);
 		$this->data['token'] = $this->session->data['token'];

 		isset($this->error['warning']) ? $this->data['error_warning'] = $this->error['warning'] : $this->data['error_warning'] = '';
		if(isset($this->session->data['success'])){
			$this->data['success'] = $this->session->data['success'];
			unset($this->session->data['success']);
		}else{
			$this->data['success'] = '';
		}

		$url = ($order == 'ASC') ? '&order=DESC' : '&order=ASC';
		
		if(isset($this->request->get['page'])){
			$url .= '&page=' . $this->request->get['page'];
		}

		$this->data['sort_name'] = HTTPS_SERVER . 'index.php?route=product/price&token=' . $this->session->data['token'] . '&sort=pd.name' . $url;
		$this->data['sort_model'] = HTTPS_SERVER . 'index.php?route=product/price&token=' . $this->session->data['token'] . '&sort=p.model' . $url;
		$this->data['sort_ws_price'] = HTTPS_SERVER . 'index.php?route=product/price&token=' . $this->session->data['token'] . '&sort=p.ws_price' . $url;
		$this->data['sort_rt_price'] = HTTPS_SERVER . 'index.php?route=product/price&token=' . $this->session->data['token'] . '&sort=p.rt_price' . $url;
		$this->data['sort_quantity'] = HTTPS_SERVER . 'index.php?route=product/price&token=' . $this->session->data['token'] . '&sort=p.quantity' . $url;
		$this->data['sort_status'] = HTTPS_SERVER . 'index.php?route=product/price&token=' . $this->session->data['token'] . '&sort=p.status' . $url;
		$this->data['sort_order'] = HTTPS_SERVER . 'index.php?route=product/price&token=' . $this->session->data['token'] . '&sort=p.sort_order' . $url;

		$pagination = new Pagination();
		$pagination->total = $product_total;
		$pagination->page = $page;
		$pagination->limit = $this->config->get('config_admin_limit');
		$pagination->text = $this->language->get('text_pagination');
		$pagination->url = HTTPS_SERVER . 'index.php?route=product/price&token=' . $this->session->data['token'] . $url . '&page={page}';

		$this->data['pagination'] = $pagination->render();
    $this->data['count']  = $product_total;
		$this->data['filter_name'] = $filter_name;
		$this->data['filter_model'] = $filter_model;
		$this->data['filter_price'] = $filter_price;
		$this->data['filter_quantity'] = $filter_quantity;
		$this->data['filter_cat'] = $filter_cat;
		$this->data['filter_status'] = $filter_status;
		$this->data['sort'] = $sort;
		$this->data['order'] = $order;

		$this->template = 'product/price_list.tpl';
		$this->children = array(
			'common/header',
			'common/footer'
		);
		$this->response->setOutput($this->render(TRUE), $this->config->get('config_compression'));
  }

  public function callUpdatePannel(){
    $ddl = $this->request->get['ddl'];
    if('insert' == $ddl){
      $this->data['action'] = HTTPS_SERVER . 'index.php?route=product/price/insertProduct&token=' . $this->session->data['token'];
    }else{
  	  $id = $this->request->get['id'];
  		$this->load->model('product/price');
      $this->data['data'] = $this->model_product_price->getOneData($id);
      $this->data['token'] = $this->session->data['token'];
      $this->data['action'] = HTTPS_SERVER . 'index.php?route=product/price/updateProduct&token=' . $this->session->data['token'];
    }
    $this->data['ddl'] = $ddl;
    $this->template = 'product/updatePannel.tpl';
  	$this->response->setOutput($this->render(TRUE), $this->config->get('config_compression'));
  }

  public function updateProduct(){
    //$this->log->aPrint( $this->request );  	exit;
  	$this->load->model('product/price');
    if($this->model_product_price->updateProduct($this->request->post)){
      $this->getList();
    }else{
      echo "<script>alert('update fail');</script>";
    }
  }

  public function insertProduct(){
    //$this->log->aPrint( $this->request );
  	$this->load->model('product/price');
    if($this->model_product_price->insertProduct($this->request->post)){
      $this->getList();
    }else{
      echo "<script>alert('update fail');</script>";
    }
  }

  public function updatePrice(){
  	$this->load->model('product/price');
    if($this->model_product_price->updatePrice($this->request->get)){
    }else{
    }
  }


}
?>