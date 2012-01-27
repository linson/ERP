<?php
class ControllerSalesATC extends Controller{
	private $error = array();

 	public function index() {
		//$this->load->language('sales/atc');
		//$this->document->title = $this->language->get('heading_title');

		//$this->load->model('sales/order');
		//$this->prepareATC();
  }

  // crond prepare atc 
  // call : HTTPS_SERVER . 'index.php?route=sales/atc/prepareATC';
  // http://192.168.0.82:5555/backyard/index.php?route=sales/atc/prepareATC
  public function prepareATC(){
    $this->load->model('product/lib');

    $aCat = $this->config->ubpCategory();
    foreach($aCat as $k => $v){

      $cat = $k;
      $delim = '|';
      $data = $this->model_product_lib->getModelNamePerCat($cat);
  
      $namePtn = "/([A-Za-z0-9]*) ([A-Za-z0-9]*) (.*)/";
      // locate file where not reach'ed by http
      $outFile = "/var/chroot/home/content/44/6104844/data/$cat";
  
      $fp = fopen($outFile, 'w');
      foreach($data as $line){
        $model = $line['model'];
        $name = $line['name'];
        preg_match_all($namePtn,trim($name),$match);
        if(isset($match[3][0])){
          $name = $match[3][0];
          fwrite($fp, "{$model}{$delim}{$name}\n");
        }
      }
      fclose($fp);
    }  
  }

  public function getProductProxy(){
    $this->load->model('product/lib');
    $model = $this->request->get['model'];
    $data = $this->model_product_lib->getProduct($model);
    $response = array();
    $response['product_id'] = $data['product_id'];
    $response['quantity'] = $data['quantity'];
    $response['ws_price'] = $data['ws_price'];
    $response['rt_price'] = $data['rt_price'];
    $response['weight'] = $data['ups_weight'];
        
    echo json_encode($response);
    
  }

}
?>