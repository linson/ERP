<?php   
class ControllerSalesStat extends Controller {   
	public function index(){
		$this->data['token'] = $this->session->data['token'];
		$this->load->model('sales/stat');
    $aDone = array();
  	isset($this->request->get['month']) ? $month = $this->request->get['month'] : $month = date('Ym'); 
    $aStat = $this->model_sales_stat->getList($month);
    //$this->log->aPrint( $aStat );
    $this->data['stat'] = $aStat;
    if( count($aStat) > 0 ){
      foreach($aStat as $idx => $row){
        //$this->log->aPrint( $row['rep'] );
        $aRepTot = $this->model_sales_stat->getRepSum($row['rep'],$month);
        if( count($aRepTot) > 0 ){
          $aDone[$idx] = $aRepTot;
          $aDone[$idx]['target'] = $row['target'];
          $aDone[$idx]['percent'] = round ( 100 * ( $aRepTot['total'] / $row['target'] ) , 2 );
          $aDone[$idx]['count'] = $aRepTot['count'];
        }
      }
    }
    
    if(isset($aDone)){
      usort($aDone,function($a,$b){
        if($a['percent'] == $b['percent'])  return 0;
        return ($a['percent'] > $b['percent']) ? -1 : 1;
      });
    }
    
    $this->data['stat'] = $aDone;

		$this->template = 'sales/stat.tpl';
		$this->children = array(
			'common/header',	
			'common/footer'	
		);
		$this->response->setOutput($this->render(TRUE), $this->config->get('config_compression'));
 	}

  public function callUpdatePannel(){
  	isset($this->request->get['month']) ? $month = $this->request->get['month'] : $month = date('Ym'); 

  	$this->load->model('sales/stat');
    $this->data['stat'] = $this->model_sales_stat->getList($month);
    $this->data['rep']  = $this->model_sales_stat->getRep();
    $this->data['token'] = $this->session->data['token'];
//$this->log->aPrint( $this->data );
    $this->data['action'] = HTTPS_SERVER . 'index.php?route=sales/stat/update&token=' . $this->session->data['token'];

    $this->template = 'sales/updatePannel.tpl';
  	$this->response->setOutput($this->render(TRUE), $this->config->get('config_compression'));
  }

  public function update(){
    //$this->log->aPrint( $this->request );  	exit;
  	$this->load->model('sales/stat');
    if($this->model_sales_stat->updatePackage($this->request->post)){
      //
    }else{
      echo "<script>alert('update fail');</script>";
    }
  }

}
?>
