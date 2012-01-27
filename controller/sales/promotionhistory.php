<?php
class ControllerSalesPromotionHistory extends Controller {
	private $error = array();
	private $bManager = false;

 	public function index(){
    $this->bManager = false;
    if('manager' == $this->user->getGroupName($this->user->getUserName()) ){
      $this->bManager = true;
    }
    $this->data['bManager'] = $this->bManager;
		$this->getList();
  }

  // ajax proxy call
  public function getList(){
		$page = (isset($this->request->get['page'])) ? $this->request->get['page'] : 1;

		//$this->data['lnk_insert'] = HTTP_SERVER . 'index.php?route=sales/order&token=' . $this->session->data['token'] . $url;
		$this->data['lnk_delete'] = HTTP_SERVER . 'index.php?route=sales/promotion/delete&token=' . $this->session->data['token'];
    
    # call data
    $this->load->model('sales/promotion');
    
    $request = array(
			'start'           => ($page - 1) * $this->config->get('config_admin_limit'),
			'limit'           => $this->config->get('config_admin_limit')
    );
    
    $total = $this->model_sales_promotion->getTotalList($request);
		$response = $this->model_sales_promotion->getList($request);

    foreach($response as $row){
			$action = array();
			$action[] = array(
				'text' => $this->language->get('text_edit'),
				'href' => HTTP_SERVER . 'index.php?route=sales/order&mode=show&token=' . $this->session->data['token'] . '&id=' . $row['id']
			);
			
			$aModel = json_decode($row['models']);

      $this->data['pr'][] = array(
			  'id'          => $row['id'],
			  'start_date'  => $row['start_date'],
			  'end_date'    => $row['end_date'],
			  'name'        => $row['name'],
        'price'       => $row['price'],
        'models'      => $row['models'],
        'storetype'   => $row['storetype'],
        'updator'     => $row['updator'],
				'action'      => $action,
			);
    }

    /***
 		$pagination = new Pagination();
		$pagination->total = $total;
		$pagination->page = $page;
		$pagination->limit = $this->config->get('config_admin_limit');
		$pagination->text = $this->language->get('text_pagination');
		$pagination->url = HTTP_SERVER . 'index.php?route=sales/promotion&token=' . $this->session->data['token'] . '&page={page}';
		$this->data['pagination'] = $pagination->render();
		***/

    $this->data['token'] = $this->session->data['token'];
    
    # call view
    $this->template = 'sales/promotionhistory.tpl';
		$this->children = array(
			'common/header',
			'common/footer'
		);

/*
    echo '<pre>';
    print_r($this->request->server);
    print $this->session->data['token'];
    echo '</pre>';
*/
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
		$this->load->model('sales/promotion');
		$deleteList =  $this->request->post['selected'];
		foreach($deleteList as $txid){
		  $this->model_sales_list->deleteTransaxtion($txid);
		}

		$this->session->data['success'] = "Delete done : " . count($deleteList);
		$this->redirect(HTTP_SERVER . 'index.php?route=sales/promotion&token=' . $this->session->data['token']);
   	$this->getList();
 	}

}
?>
