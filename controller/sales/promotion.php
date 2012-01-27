<?php
/*
todo. batch process for trans , Later , besso-201103 
*/
class ControllerSalesPromotion extends Controller {
	private $error = array();
	private $bManager = false;
	public  $exp_qry = 'dummy';

 	public function index(){

    $this->bManager = false;
    if('manager' == $this->user->getGroupName($this->user->getUserName()) ){
      $this->bManager = true;
    }
		$this->getList();
  }
  
  // ajax proxy call
  public function getList(){
    $this->template = 'sales/promotion.tpl';
		$this->children = array(
			'common/header',
			'common/footer'
		);
	  $this->data['lnk_promotion_history']  = HTTPS_SERVER . 'index.php?route=sales/promotionhistory&token=' . $this->session->data['token'];
		$this->response->setOutput($this->render(TRUE), $this->config->get('config_compression'));
  }

  public function ajax_list(){
	  isset($this->request->get['filter_code']) ? $filter_code = $this->request->get['filter_code'] : $filter_code = '';
	  isset($this->request->get['filter_name']) ? $filter_name = $this->request->get['filter_name'] : $filter_name = '';

		$this->load->model('product/price');

    $aFilter = array(
      'filter_model' => $filter_code,
      'filter_name'  => $filter_name
    );
    $this->data['products']    = $this->model_product_price->getProducts($aFilter,$this->exp_qry);
    $this->data['total']       = $this->model_product_price->getTotalProducts($aFilter);

    $this->data['token'] = $this->session->data['token'];
    $this->data['action'] = HTTPS_SERVER . 'index.php?route=material/lookup/update&token=' . $this->session->data['token'];

    $this->template = 'sales/promotion_list.tpl';
		$this->response->setOutput($this->render(TRUE), $this->config->get('config_compression'));
  }

  public function insert(){
    //$this->log->aPrint( $this->request->post ); exit;
  	$this->load->model('sales/promotion');
    if($this->model_sales_promotion->insert($this->request->post)){
      echo true;
    }else{
      echo false;
    }
  }

  public function delete(){
  	$this->load->model('sales/promotion');
  	//$this->log->aPrint( $this->request->get ); exit;
  	$id = ( isset($this->request->get['id']) ) ? $this->request->get['id'] : '';
    //$this->log->aPrint( $id ); exit;
    if($this->model_sales_promotion->delete($id)){
      echo true;
    }else{
      echo false;
    }
  }

  public function export(){
		$this->load->language('store/btrip');
		$title = $this->language->get('heading_title');

    $export_qry = $this->request->get['export_qry'];

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