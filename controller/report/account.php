<?php
class ControllerReportAccount extends Controller{
	public function index(){

 		isset($this->error['warning']) ? $this->data['error_warning'] = $this->error['warning'] : $this->data['error_warning'] = '';
		isset($this->session->data['success']) ? $this->data['success'] = $this->session->data['success'] : $this->data['success'] = '';
		unset($this->session->data['success']);

    $page   = $this->util->parseRequest('page','get','1');
    $sort   = $this->util->parseRequest('sort','get','');
    $order  = $this->util->parseRequest('order','get','DESC');

    $accountno  = $this->util->parseRequest('accountno','get','');
    //$this->log->aPrint( $accountno );

    $filter_from   = $this->util->parseRequest('filter_from','get',date("Y-m").'-01');
    $filter_to     = $this->util->parseRequest('filter_to','get',date("Y-m-t",strtotime("0 month")));

		$url = '';
		if($page) $url.='&page='.$page;
		if($sort) $url.='&sort='.$sort;
		if($order) $url.='&order='.$order;

		$this->data['token'] = $this->session->data['token'];
		$this->data['sort'] = $sort;
		$this->data['order'] = $order;

		$this->data['filter_from'] = $filter_from;
		$this->data['filter_to'] = $filter_to;
		
		$this->load->model('report/sale');

		$req = array(
		  'sort'  => $sort,
		  'order' => $order,
		  'filter_from' => $filter_from,
		  'filter_to' => $filter_to,
		  'accountno' => $accountno,
		);

		$res = $this->model_report_sale->stat_account($req);
		//$this->log->aPrint( $res );
    
    // today
		//$order_total_day = 0;
		//foreach($res['today'] as $row){ $order_total_day += $row['qty']; }
		//$total_count_day = count($res['today']);
		$this->data['stat'] = $res;
		$this->data['accountno'] = $accountno;
		//$this->data['order_total_day'] = $order_total_day;
		//$this->data['total_count_day'] = $total_count_day;


		$this->template = 'report/account.tpl';
		$this->children = array(
			'common/header',	
			'common/footer'	
		);
		
		$this->response->setOutput($this->render(TRUE), $this->config->get('config_compression'));
  }

	public function chart(){
		$this->load->language('common/home');

		$data = array();

		$data['order'] = array();
		$data['customer'] = array();
		$data['xaxis'] = array();

		$data['order']['label'] = $this->language->get('text_order');
		$data['customer']['label'] = $this->language->get('text_customer');

		if (isset($this->request->get['range'])){
			$range = $this->request->get['range'];
		}else{
			$range = 'month';
		}

		switch($range){
			case 'day':
				for ($i = 0; $i < 24; $i++){
				  $sql = "SELECT COUNT(*) AS total FROM transaction ";
				  $sql.= " where shipped_yn = 'Y' AND (DATE(order_date) = DATE(NOW()) AND HOUR(order_date) = '" . (int)$i . "') GROUP BY HOUR(order_date) ORDER BY order_date ASC";
					$query = $this->db->query($sql);
					//$this->log->aPrint( $sql );
					if ($query->num_rows){
						$data['order']['data'][]  = array($i, (int)$query->row['total']);
					}else{
						$data['order']['data'][]  = array($i, 0);
					}

					$query = $this->db->query("SELECT COUNT(*) AS total FROM user WHERE DATE(date_added) = DATE(NOW()) AND HOUR(date_added) = '" . (int)$i . "' GROUP BY HOUR(date_added) ORDER BY date_added ASC");
					
					if ($query->num_rows){
						$data['customer']['data'][] = array($i, (int)$query->row['total']);
					}else{
						$data['customer']['data'][] = array($i, 0);
					}

					$data['xaxis'][] = array($i, date('H', mktime($i, 0, 0, date('n'), date('j'), date('Y'))));
				}					
				break;
			case 'week':
				$date_start = strtotime('-' . date('w') . ' days'); 
				for ($i = 0; $i < 7; $i++){
					$date = date('Y-m-d', $date_start + ($i * 86400));
					$query = $this->db->query("SELECT COUNT(*) AS total FROM transaction WHERE shipped_yn = 'Y' AND DATE(order_date) = '" . $this->db->escape($date) . "' GROUP BY DATE(order_date)");
					if ($query->num_rows){
						$data['order']['data'][] = array($i, (int)$query->row['total']);
					}else{
						$data['order']['data'][] = array($i, 0);
					}
					$query = $this->db->query("SELECT COUNT(*) AS total FROM user WHERE DATE(date_added) = '" . $this->db->escape($date) . "' GROUP BY DATE(date_added)");
					if ($query->num_rows){
						$data['customer']['data'][] = array($i, (int)$query->row['total']);
					}else{
						$data['customer']['data'][] = array($i, 0);
					}
					$data['xaxis'][] = array($i, date('D', strtotime($date)));
				}
				break;
			default:
			case 'month':
				for ($i = 1; $i <= date('t'); $i++){
					$date = date('Y') . '-' . date('m') . '-' . $i;
					$query = $this->db->query("SELECT COUNT(*) AS total FROM transaction WHERE shipped_yn = 'Y' AND (DATE(order_date) = '" . $this->db->escape($date) . "') GROUP BY DAY(order_date)");
					if ($query->num_rows){
						$data['order']['data'][] = array($i, (int)$query->row['total']);
					}else{
						$data['order']['data'][] = array($i, 0);
					}	
					$query = $this->db->query("SELECT COUNT(*) AS total FROM user WHERE DATE(date_added) = '" . $this->db->escape($date) . "' GROUP BY DAY(date_added)");
					if ($query->num_rows){
						$data['customer']['data'][] = array($i, (int)$query->row['total']);
					}else{
						$data['customer']['data'][] = array($i, 0);
					}	

					$data['xaxis'][] = array($i, date('j', strtotime($date)));
				}
				break;
			case 'year':
				for ($i = 1; $i <= 12; $i++){
					$query = $this->db->query("SELECT COUNT(*) AS total FROM transaction WHERE shipped_yn = 'Y' AND YEAR(order_date) = '" . date('Y') . "' AND MONTH(order_date) = '" . $i . "' GROUP BY MONTH(order_date)");
					
					if ($query->num_rows){
						$data['order']['data'][] = array($i, (int)$query->row['total']);
					}else{
						$data['order']['data'][] = array($i, 0);
					}

					$query = $this->db->query("SELECT COUNT(*) AS total FROM user WHERE YEAR(date_added) = '" . date('Y') . "' AND MONTH(date_added) = '" . $i . "' GROUP BY MONTH(date_added)");
					
					if ($query->num_rows){ 
						$data['customer']['data'][] = array($i, (int)$query->row['total']);
					}else{
						$data['customer']['data'][] = array($i, 0);
					}
					
					$data['xaxis'][] = array($i, date('M', mktime(0, 0, 0, $i, 1, date('Y'))));
				}
				break;
		}

		$this->load->library('json');

		$this->response->setOutput(Json::encode($data));
	}

	public function login(){

		// Iphone auth
		$aMacAuth = array(
			'webapp/inventory',
			'webapp/inventory/getQuantity',
 			'webapp/inventory/updateQuantity',
 			'product/oem',
 			'product/oem/update',
 			'cron/oem',
 			'product/main',
 			'product/main/update',
      'product/main/callUpdatePannel',
 			'product/main/updateThres',
		);
		$route = '';
		if(isset($this->request->get['route'])){
		  $route = $this->request->get['route'];
		}
    if(!in_array($route,$aMacAuth)){
  		if(!$this->user->isLogged()){
  			return $this->forward('common/login');
  		}
    }else{
      // todo!! do macadress authentication here. , besso 201105 
    }

		if(isset($this->request->get['route'])){
			$route = '';
			$part = explode('/', $this->request->get['route']);

			if (isset($part[0])){
				$route .= $part[0];
			}

			if (isset($part[1])){
				$route .= '/' . $part[1];
			}

			// ignore login also , besso-201103 
			$ignore = array(
				'common/login',
				'common/logout',
				'error/not_found',
				'error/permission',
				'sales/atc',
				'webapp/inventory',
   			'product/oem',
   			'product/oem/update',
   			'cron/oem',
   			'product/main',
   			'product/main/update',
        'product/main/callUpdatePannel',
        'product/main/updateThres',
			);

			$config_ignore = array();

			if ($this->config->get('config_token_ignore')){
				$config_ignore = unserialize($this->config->get('config_token_ignore'));
			}

			$ignore = array_merge($ignore, $config_ignore);
      //$this->log->aPrint( $ignore ); exit;
      # todo. besso remove all get-driven token from system , besso 201105 
			if(!in_array($route, $ignore)){
				//if (!isset($this->request->get['token']) || !isset($this->session->data['token']) || ($this->request->get['token'] != $this->session->data['token'])){
				if(!isset($this->session->data['token'])){
					return $this->forward('common/login');
				}
			}
		}else{
				if(!isset($this->session->data['token'])){
				  return $this->forward('common/login');
			}
		}
	}

	public function permission(){
	  //$this->log->aPrint($this->request->get);
		if (isset($this->request->get['route'])){
			$route = '';
			$part = explode('/', $this->request->get['route']);
			if (isset($part[0])){
				$route .= $part[0];
			}
			if (isset($part[1])){
				$route .= '/' . $part[1];
			}

			// all this one ignore permission , besso-201103 
			$ignore = array(
				'common/home',
				'common/login',
				'common/logout',
				'error/not_found',
				'error/permission',	
				'error/token',
				'sales/atc',
				'webapp/inventory',
  			'webapp/inventory/getQuantity',
  			'webapp/inventory/updateQuantity',
   			'product/oem',
   			'product/oem/update',
   			'cron/oem',
   			'cron/cron',
   			'product/main',
   			'product/main/update',
   			'product/main/updateThres',
			);

			if (!in_array($route, $ignore)){
				if (!$this->user->hasPermission('access', $route)){
					return $this->forward('error/permission');
				}
			}
		}
	}
}
?>