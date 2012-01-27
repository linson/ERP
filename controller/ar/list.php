<?php
class ControllerArList extends Controller{
  public $export_sql = '';
 	public function index(){
		$this->getList();
  }
  public function importQB(){
    $this->load->model('ar/list');
    $this->model_ar_list->importQB();
  }
  // ajax proxy call
  public function getList(){
    isset($this->error['warning']) ? $this->data['error_warning'] = $this->error['warning'] : $this->data['error_warning'] = '';
		isset($this->request->get['page']) ?	$page = $this->request->get['page'] : $page = 1;
		isset($this->request->get['sort']) ? $sort = $this->request->get['sort'] :	$sort = 's.accountno';
    $url = '';
		if(isset($this->request->get['filter_store_name'])){
      $url .= '&filter_store_name=' . $this->request->get['filter_store_name'];
      $filter_store_name = $this->request->get['filter_store_name'];
  	}else{
      $filter_store_name = NULL;
  	}
		if(isset($this->request->get['filter_bankaccount'])){
      $url .= '&filter_bankaccount=' . $this->request->get['filter_bankaccount'];
      $filter_bankaccount = $this->request->get['filter_bankaccount'];
  	}else{
      $filter_bankaccount = NULL;
  	}
		if(isset($this->request->get['filter_txid'])){
      $url .= '&filter_txid=' . $this->request->get['filter_txid'];
      $filter_txid = $this->request->get['filter_txid'];
  	}else{
      $filter_txid = NULL;
  	} 
  	if(isset($this->request->get['filter_order_date_from'])){
      $url .= '&filter_order_date_from=' . $this->request->get['filter_order_date_from'];
      $filter_order_date_from = $this->request->get['filter_order_date_from'];
  	}else{
      // let's fix as recentl 1 week
  	  $weekago = date('Y-m-d', strtotime('-7 days'));
      $filter_order_date_from = $weekago;
  	}
  	if(isset($this->request->get['filter_order_date_to'])){
      $url .= '&filter_order_date_to=' . $this->request->get['filter_order_date_to'];
      $filter_order_date_to = $this->request->get['filter_order_date_to'];
  	}else{
      $tdate = date('Y-m-d');
      $filter_order_date_to = $tdate;  
  	}
  	if(isset($this->request->get['filter_order_price'])){
      $url .= '&filter_order_price=' . $this->request->get['filter_order_price'];
      $filter_order_price = $this->request->get['filter_order_price'];
  	}else{
      $filter_order_price = NULL;  
  	}
  	if(isset($this->request->get['filter_ship'])){
      $url .= '&filter_ship=' . $this->request->get['filter_ship'];
      $filter_ship = $this->request->get['filter_ship'];
  	}else{
      $filter_ship = NULL;  
  	}
		if( isset($this->request->get['filter_payed']) && '' != $this->request->get['filter_payed'] ){
      $url .= '&filter_payed=' . $this->request->get['filter_payed'];
      $filter_payed = $this->request->get['filter_payed'];
  	}else{
      $filter_payed = NULL;  
  	}

    # AR don't need User filtering
		if(isset($this->request->get['filter_order_user'])){
      $url .= '&filter_order_user=' . $this->request->get['filter_order_user'];
      $filter_order_user = $this->request->get['filter_order_user'];
  	}else{
   	  $filter_order_user = NULL;  
  	}
		if(isset($this->request->get['order'])){
			$url .= '&order=' . $this->request->get['order'];
		  $order = $this->request->get['order'];
  	}else{
  	  $order = 'ASC';  
  	}
		$order == 'ASC' ? $url .= '&order=DESC' : $url .= '&order=ASC';

    # link
		$this->data['lnk_insert'] = HTTP_SERVER . 'index.php?route=ar/order&token=' . $this->session->data['token'] . $url;
		$this->data['lnk_delete'] = HTTP_SERVER . 'index.php?route=ar/list/delete&token=' . $this->session->data['token'] . $url;
		$this->data['lnk_import'] = HTTP_SERVER . 'index.php?route=ar/list/importQB&token=' . $this->session->data['token'] . $url;
    
    # filter & sort
 		$this->data['sort_store_name'] = HTTP_SERVER . 'index.php?route=ar/list&token=' . $this->session->data['token'] . '&sort=name' . $url;
 		$this->data['sort_order_date'] = HTTP_SERVER . 'index.php?route=ar/list&token=' . $this->session->data['token'] . '&sort=x.order_date' . $url;
 		// let's do for additional requirement , besso-201103 
 		//$this->data['sort_accountno'] = HTTP_SERVER . 'store/lookup/' . $this->session->data['token'] . '&sort=accountno' . $url;
 		//$this->data['sort_state'] = HTTP_SERVER . 'store/lookup/' . $this->session->data['token'] . '&sort=state' . $url;

		if(isset($this->request->get['order'])){
			$order = $this->request->get['order'];
		} else {
			$order = 'DESC';
		}

    # call data
    $this->load->model('ar/list');

		$this->data['txs'] = array();
    $request = array(
			'filter_store_name'	  => $filter_store_name,
			'filter_bankaccount'	  => $filter_bankaccount,
			'filter_txid'	  => $filter_txid,
			'filter_order_date_from'=> $filter_order_date_from,
			'filter_order_date_to'=> $filter_order_date_to,
			'filter_order_price' => $filter_order_price,
			'filter_ship'=> $filter_ship,
			'filter_payed'     => $filter_payed,
			'filter_order_user'  => $filter_order_user,
			'sort'            => $sort,
			'order'           => $order,
			'start'           => ($page - 1) * $this->config->get('config_admin_limit'),
			'limit'           => $this->config->get('config_admin_limit')
    );

    $total = $this->model_ar_list->getTotalList($request);
		$response = $this->model_ar_list->getList($request,$this->export_sql);
		$sum = $this->model_ar_list->getSumList($request);
    isset($sum) ? $this->data['sum'] = $sum[0] : $this->data['sum'] = array() ;

    # bad temporary
    $sqlFile = "/var/www/html/backyard/data/sql";
    $handle = @fopen($sqlFile,'w');
    fwrite($handle,$this->export_sql);
    fclose($handle);

    $this->data['export'] = HTTPS_SERVER . 'index.php?route=ar/list/export&token=' . $this->session->data['token'];
    $this->data['total'] = $total;

    foreach($response as $row){
			$action = array();
			$action[] = array(
				'text' => 'Edit',
				'href' => HTTP_SERVER . 'index.php?route=ar/detail&token=' . $this->session->data['token'] . '&store_id=' . $row['store_id']
			);

      # let's tune store-status
      //$row['order_date'] = '2011-03-01';
      $today = date('Y-m-d');
      
      // +30
      if($today < $this->add_date(substr($row['order_date'],0,10),30)){
        $pay_due = '30';
      // 30-60
      }else if( $this->add_date(substr($row['order_date'],0,10),30) <= $today && $today < $this->add_date(substr($row['order_date'],0,10),60)){
        $pay_due = '60';
        //echo ('30-60');
      }else if( $this->add_date(substr($row['order_date'],0,10),60) <= $today && $today < $this->add_date(substr($row['order_date'],0,10),90)){
        $pay_due = '90';
        //echo ('60-90');
      }else if( $this->add_date(substr($row['order_date'],0,10),90) <= $today){
        $pay_due = '120';
        //echo ('over 90');
      }
      
      /*
      $this->log->aPrint( $row['order_date'] );
      $this->log->aPrint( $this->add_date($row['order_date'],30) );
      $this->log->aPrint( $this->add_date($row['order_date'],60) );
      $this->log->aPrint( $today );
      $this->log->aPrint( $pay_due );
      $this->log->aPrint( '-----' );
      */
      // todo. measure paid yn
      ($row['balance'] >= 0) ? $payed_yn = 'yet' : $payed_yn = 'done';
      $this->data['txs'][] = array(
			  'txid'        => $row['txid'],
			  'bankaccount' => $row['bankaccount'],
			  'store_name'  => $row['store_name'],
        'order_price' => $row['order_price'],
        'shipped_yn'  => $row['shipped_yn'],
        'payed_yn'    => $payed_yn,
        'order_date'  => substr($row['order_date'],0,13),
        'order_user'  => $row['order_user'],
				'balance'     => $row['balance'],
				'action'      => $action,
 				'pay_due'     => $pay_due,
 				'selected'    => isset($this->request->post['selected']) && in_array($result['id'], $this->request->post['selected']),
			);
    }

    /**
    echo '<pre>';
    print_r($action);
    echo '</pre>';
    *** , besso-201103 */
    
    //print 'total cnt : ' . $total;

 		$pagination = new Pagination();
		$pagination->total = $total;
		$pagination->page = $page;
		$pagination->limit = $this->config->get('config_admin_limit');
		$pagination->text = $this->language->get('text_pagination');
		$pagination->url = HTTP_SERVER . 'index.php?route=ar/list&token=' . $this->session->data['token'] . $url . '&page={page}';

		$this->data['pagination'] = $pagination->render();
		
    		
		$this->data['filter_store_name'] = $filter_store_name;
		$this->data['filter_bankaccount'] = $filter_bankaccount;
		$this->data['filter_txid'] = $filter_txid;
		$this->data['filter_order_price'] = $filter_order_price;
		$this->data['filter_order_date_from'] = $filter_order_date_from;
		$this->data['filter_order_date_to'] = $filter_order_date_to;
		$this->data['filter_ship'] = $filter_ship;
		$this->data['filter_payed'] = $filter_payed;
		$this->data['filter_order_user'] = $filter_order_user;
		
    $this->data['sort'] = $sort;
		$this->data['order'] = $order;
    
    $this->data['token'] = $this->session->data['token'];
    
    # call view
    $this->template = 'ar/list.tpl';
		$this->children = array(
			'common/header',
			'common/footer'
		);
		$this->response->setOutput($this->render(TRUE), $this->config->get('config_compression'));
  }

  public function add_date($givendate,$day=0,$mth=0,$yr=0){
    $givendate = $givendate. ' 00:00:00';
    $cd = strtotime($givendate);
    $newdate = date('Y-m-d', mktime(date('h',$cd),
                    date('i',$cd), date('s',$cd), date('m',$cd)+$mth,
                    date('d',$cd)+$day, date('Y',$cd)+$yr));
    return $newdate;
  }

  public function delete(){
		$this->load->model('ar/list');
		$deleteList =  $this->request->post['selected'];
		foreach($deleteList as $txid){
		  $this->model_ar_list->deleteTransaxtion($txid);
		}

		$this->session->data['success'] = "Delete done : " . count($deleteList);
		$this->redirect(HTTP_SERVER . 'index.php?route=ar/list&token=' . $this->session->data['token']);
   	$this->getList();
 	}

  public function export(){
		$title = 'ar';

    # bad temporary
    $sqlFile = "/var/www/html/backyard/data/sql";
    $handle = @fopen($sqlFile,'r');
    $export_qry = fread($handle,8192);
    fclose($handle);
    //$this->log->aPrint( $export_qry ); exit;

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
