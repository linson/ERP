<?php
class ControllerCommonHome extends Controller{
	public function index(){
 		isset($this->error['warning']) ? $this->data['error_warning'] = $this->error['warning'] : $this->data['error_warning'] = '';
		isset($this->session->data['success']) ? $this->data['success'] = $this->session->data['success'] : $this->data['success'] = '';
		unset($this->session->data['success']);

    $page   = $this->util->parseRequest('page','get','1');
    $sort   = $this->util->parseRequest('sort','get','');
    $order  = $this->util->parseRequest('order','get','DESC');
    
    $filter_from   = $this->util->parseRequest('filter_from','get',date("Y-m").'-01');
    $filter_to     = $this->util->parseRequest('filter_to','get',date("Y-m-t",strtotime("0 month")));
    $hidden   = $this->util->parseRequest('hidden','get',false);

		$url = '';
		if($page) $url.='&page='.$page;
		if($sort) $url.='&sort='.$sort;
		if($order) $url.='&order='.$order;
		
		$this->data['token'] = $this->session->data['token'];
		$this->data['sort'] = $sort;
		$this->data['order'] = $order;

		$this->data['filter_from'] = $filter_from;
		$this->data['filter_to'] = $filter_to;
		$this->data['hidden'] = $hidden;
		
		$this->load->model('report/sale');

		$req = array(
		  'sort'  => $sort,
		  'order' => $order,
		  'filter_from' => $filter_from,
		  'filter_to' => $filter_to,
		  'hidden' => $hidden,
		);

		$res = $this->model_report_sale->stat($req);

    // today
		$order_total_day = 0;
		foreach($res['today'] as $row){ $order_total_day += $row['order_price']; }
		$total_count_day = count($res['today']);
		$this->data['today'] = $res['today'];
		$this->data['order_total_day'] = $order_total_day;
		$this->data['total_count_day'] = $total_count_day;

    //$this->log->aPrint( $res['today'] );

		$order_total = 0;
		foreach($res['this_month'] as $row){ $order_total += $row['order_price']; }
		$total_count = count($res['this_month']);
		$this->data['stat'] = $res['this_month'];
		$this->data['order_total'] = $order_total;
		$this->data['total_count'] = $total_count;

		$order_total_last = 0;
		foreach($res['last_month'] as $row){ $order_total += $row['order_price']; }
		$total_count_last = count($res['last_month']);
		$this->data['lstat'] = $res['last_month'];
		$this->data['order_total_last'] = $order_total_last;
		$this->data['total_count_last'] = $total_count_last;

    // day
    for($i=0;$i<7;$i++){
      $week = date('w',strtotime("-1 day"));
      if($week != 0 || $week != 6){
        $pday_label = date('m-d(D)',strtotime("-1 day"));
        $pday_from = $pday_to = date('Y-m-d',strtotime("-1 day"));
        break;
      }
    }
    $this->data['pday_label'] = $pday_label;
		$this->data['lnk_pday'] = HTTPS_SERVER . 'index.php?route=common/home&filter_from=' . $pday_from . '&filter_to=' . $pday_to;

    $tday_label = date('m-d(D)',strtotime("0 month"));
    $tday_from = $tday_to = date('Y-m-d',strtotime("0 month"));
    $this->data['tday_label'] = $tday_label;
		$this->data['lnk_tday'] = HTTPS_SERVER . 'index.php?route=common/home&filter_from=' . $tday_from . '&filter_to=' . $tday_to;

    // month
    $pmonth_label = date('Y-m',strtotime("-1 month"));
    $pmonth_from = date('Y-m-01',strtotime("-1 month"));
    $pmonth_to = date('Y-m-t',strtotime("-1 month"));
    $this->data['pmonth_label'] = $pmonth_label;
		$this->data['lnk_pmonth'] = HTTPS_SERVER . 'index.php?route=common/home&filter_from=' . $pmonth_from . '&filter_to=' . $pmonth_to;

    // todo. Need Label work
    $tmonth_label = date('Y-m');
    $tmonth_from = date('Y-m-01');
    $tmonth_to = date('Y-m-t');
    $this->data['tmonth_label'] = $tmonth_label;
		$this->data['lnk_tmonth'] = HTTPS_SERVER . 'index.php?route=common/home&filter_from=' . $tmonth_from . '&filter_to=' . $tmonth_to;

    $nmonth_label = date('Y-m',strtotime("+1 month"));
    $nmonth_from = date('Y-m-01',strtotime("+1 month"));
    $nmonth_to = date('Y-m-t',strtotime("+1 month"));
    $this->data['nmonth_label'] = $nmonth_label;
		$this->data['lnk_nmonth'] = HTTPS_SERVER . 'index.php?route=common/home&filter_from=' . $nmonth_from . '&filter_to=' . $nmonth_to;

    /***
    // quarter
    $pquarter_label = date('Y-m',strtotime("-6 month"));
    $pquarter_from = date('Y-m-01',strtotime("-6 month"));
    $pquarter_to = date('Y-m-t',strtotime("-6 month"));
    $this->data['pquarter_label'] = $pquarter_label;
		$this->data['lnk_pquarter'] = HTTPS_SERVER . 'index.php?route=common/home&filter_from=' . $pquarter_from . '&filter_to=' . $pquarter_to;

    $pquarter_label = date('Y-m',strtotime("-3 month"));
    $pquarter_from = date('Y-m-01',strtotime("-3 month"));
    $pquarter_to = date('Y-m-t',strtotime("-3 month"));
    $this->data['pquarter_label'] = $pquarter_label;
		$this->data['lnk_pquarter'] = HTTPS_SERVER . 'index.php?route=common/home&filter_from=' . $pquarter_from . '&filter_to=' . $pquarter_to;
    ***/

		$this->template = 'common/home.tpl';
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

		if(isset($this->request->get['range'])){
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
					if($query->num_rows){
						$data['order']['data'][]  = array($i, (int)$query->row['total']);
					}else{
						$data['order']['data'][]  = array($i, 0);
					}

					$query = $this->db->query("SELECT COUNT(*) AS total FROM user WHERE DATE(date_added) = DATE(NOW()) AND HOUR(date_added) = '" . (int)$i . "' GROUP BY HOUR(date_added) ORDER BY date_added ASC");

					if($query->num_rows){
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
					if($query->num_rows){
						$data['order']['data'][] = array($i, (int)$query->row['total']);
					}else{
						$data['order']['data'][] = array($i, 0);
					}
					$query = $this->db->query("SELECT COUNT(*) AS total FROM user WHERE DATE(date_added) = '" . $this->db->escape($date) . "' GROUP BY DATE(date_added)");
					if($query->num_rows){
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
					if($query->num_rows){
						$data['order']['data'][] = array($i, (int)$query->row['total']);
					}else{
						$data['order']['data'][] = array($i, 0);
					}	
					$query = $this->db->query("SELECT COUNT(*) AS total FROM user WHERE DATE(date_added) = '" . $this->db->escape($date) . "' GROUP BY DAY(date_added)");
					if($query->num_rows){
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
					
					if($query->num_rows){
						$data['order']['data'][] = array($i, (int)$query->row['total']);
					}else{
						$data['order']['data'][] = array($i, 0);
					}

					$query = $this->db->query("SELECT COUNT(*) AS total FROM user WHERE YEAR(date_added) = '" . date('Y') . "' AND MONTH(date_added) = '" . $i . "' GROUP BY MONTH(date_added)");
					
					if($query->num_rows){ 
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
			'report/validation',
 			'report/report',
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

			if(isset($part[0])){
				$route .= $part[0];
			}

			if(isset($part[1])){
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
   			'report/validation',
   			'report/report',
			);

			$config_ignore = array();

			if($this->config->get('config_token_ignore')){
				$config_ignore = unserialize($this->config->get('config_token_ignore'));
			}

			$ignore = array_merge($ignore, $config_ignore);
      # todo. besso remove all get-driven token from system , besso 201105 
			if(!in_array($route, $ignore)){
				//if(!isset($this->request->get['token']) || !isset($this->session->data['token']) || ($this->request->get['token'] != $this->session->data['token'])){
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
		if(isset($this->request->get['route'])){
			$route = '';
			$part = explode('/', $this->request->get['route']);
			if(isset($part[0])){
				$route .= $part[0];
			}
			if(isset($part[1])){
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
   			'report/validation',
   			'report/report',
			);

			if(!in_array($route, $ignore)){
				if(!$this->user->hasPermission('access', $route)){
					return $this->forward('error/permission');
				}
			}
		}
	}
}
?>