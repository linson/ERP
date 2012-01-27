<?php
class ControllerSalesATC extends Controller{
  private $dataPath = '';
	private $error = array();
  private $ptn = array('3S' => '30 Sec ',
                   'AE' => 'A/E ',
                   'IR' => 'IRIE DREAD ',
                   'QT' => 'QT ',
                   'SP' => 'S/P ',
                   'VN' => 'Via ');

 	public function index() {
		//$this->load->language('sales/atc');
		//$this->document->title = $this->language->get('heading_title');
		//$this->load->model('sales/order');
		//$this->prepareATC();
  }

  // crond prepare atc and store in static file
  // call : HTTPS_SERVER . 'index.php?route=sales/atc/prepareATC';
  // http://192.168.0.93/backyard/index.php?route=sales/atc/prepareATC
  public function prepareATC(){
    $this->load->model('product/lib');
    $aCat = $this->config->ubpCategory();
    foreach($aCat as $k => $v){
      $cat = $k;
      $delim = '|';
      $data = $this->model_product_lib->getModelNamePerCat($cat);
      //$this->log->aPrint( $data );
      //$namePtn = "/([A-Za-z0-9]*) ([A-Za-z0-9]*) (.*)/";

      // locate file where not reach'ed by http
      // todo. did 777 !!
      $outFile = $_SERVER["DOCUMENT_ROOT"]."/backyard/data/$cat";
      //print $outFile;
      $fp = fopen($outFile, 'w');
      foreach($data as $line){
        $model = $line['model'];
        $name = $line['name'];

        //print $model. '<br/>';
        //print $name. '<br/>';
        
        $model_prefix = substr($model,0,2);
        $model = substr($model,2,4);
        $name = str_replace($this->ptn[$model_prefix],'',$name);
        $name = $model . ' ' . $name;
        fwrite($fp, "{$model}{$delim}{$name}\n");
        
        /********
        preg_match_all($namePtn,trim($name),$match);
        if(isset($match[3][0])){
          $name = substr($model,2,4) . ' ' . $match[3][0];
          fwrite($fp, "{$model}{$delim}{$name}\n");
        }
        **********/
      }
      fclose($fp);
    }  
  }

  public function getProductProxy(){
    $this->load->model('product/lib');
    $model = $this->request->get['model'];
    $data = $this->model_product_lib->getProduct($model);
    
    $namePtn = "/([A-Za-z0-9]*) ([A-Za-z0-9]*) (.*)/";
    preg_match_all($namePtn,trim($data['product_name']),$match);
    if(isset($match[3][0])){
      $data['product_name'] = $match[3][0];
    }
    
    $response = array();
    $response['product_id'] = $data['product_id'];
    $response['quantity'] = $data['quantity'];
    $response['ws_price'] = $data['ws_price'];
    $response['rt_price'] = $data['rt_price'];
    $response['weight'] = $data['ups_weight'];
    $response['image'] = $data['image'];
    $response['product_name'] = $data['product_name'];
    $response['pc'] = $data['pc'];
        
    echo json_encode($response);
    
  }
  
  

  public function getProductBatchProxy(){
    $model = $this->request->get['model'];
    $this->log->aPrint( $model );
    $aModel = array($model);
    $outFile = $_SERVER["DOCUMENT_ROOT"]."/backyard/data/categoryMap";
    $handle = @fopen($outFile, "r");
    if($handle){
      while (($buffer = fgets($handle, 4096)) !== false) {
        if(strstr($buffer,$model)){
          $aModel = explode(',',$buffer);
        }
      }
      if (!feof($handle)) {
          echo "Error: unexpected fgets() fail\n";
      }
      fclose($handle);
    }

    $this->load->model('product/lib');
    $this->load->model('sales/order');
    
    $response = array();
    $i = 0;
    foreach($aModel as $m){
      if(strlen($m) == 6){
        $data = $this->model_product_lib->getProduct($m);
        //$this->log->aPrint( $data );
        // just to make showing name better.
        $product_name = $data['product_name'];
        if(isset($this->ptn[substr($m,0,2)])){
          $product_name = str_replace($this->ptn[substr($m,0,2)],'',$data['product_name']);
        }
        /***
        $namePtn = "/([A-Za-z0-9]*) ([A-Za-z0-9]*) (.*)/";
        preg_match_all($namePtn,trim($data['product_name']),$match);
        if(isset($match[3][0])){
          $data['product_name'] = $match[3][0];
        }
        ***/
        
        // independent quantity management
        $locked = false;
        $aSalesQuantity = $this->model_sales_order->getSalesQuantity($data['model']);
        if( count($aSalesQuantity) > 0 ){
          $quantity = $data['quantity'] - $aSalesQuantity[0]['locked'];
          $locked = true;
        }else{
          $quantity = $data['quantity'];
        }
        //$this->log->aPrint( $quantity );
        
        //$response[$i]['model'] = substr($data['model'],2,4);
        $response[$i]['model'] = $data['model'];
        $response[$i]['product_id'] = $data['product_id'];
        $response[$i]['quantity'] = $quantity;
        $response[$i]['ws_price'] = $data['ws_price'];
        $response[$i]['rt_price'] = $data['rt_price'];
        $response[$i]['weight'] = $data['ups_weight'];
        $response[$i]['image'] = $data['image'];
        $response[$i]['product_name'] = $product_name;
        $response[$i]['pc'] = $data['pc'];
        $response[$i]['dc'] = $data['dc'];
        $response[$i]['dc2'] = $data['dc2'];
        $response[$i]['locked'] = $locked;
        
        $i++;
      }
    }
    echo json_encode($response);
  }


  public function getProductBatchProxy2(){
    //isset($this->request->get['mode']) ? $mode = $this->request->get['mode'] : $mode = 'edit';
    $model = $this->request->get['model'];
    $aModel = explode('|',$model);
    $txid = $this->request->get['txid'];
    $txid = html_entity_decode($txid);
    $txid = str_replace('"','',$txid);
    
    $this->load->model('product/lib');
    $this->load->model('sales/order');

    //$this->log->aPrint( $aModel );

    $response = array();
    $i = 0;
    foreach($aModel as $m){
      if(strlen($m) == 6){
        $data = $this->model_product_lib->getProducts($m,$txid);
        //$this->log->aPrint( $data );
        // just to make showing name better.
        if(!isset($data['product_name'])){
           $response[$i] = array();
           continue;
        }
        $product_name = $data['product_name'];
        if(isset($this->ptn[substr($m,0,2)])){
          $product_name = str_replace($this->ptn[substr($m,0,2)],'',$data['product_name']);
        }
        /***
        $namePtn = "/([A-Za-z0-9]*) ([A-Za-z0-9]*) (.*)/";
        preg_match_all($namePtn,trim($data['product_name']),$match);
        if(isset($match[3][0])){
          $data['product_name'] = $match[3][0];
        }
        ***/
        
        // independent quantity management
        $locked = false;
        $aSalesQuantity = $this->model_sales_order->getSalesQuantity($data['model']);
        if( count($aSalesQuantity) > 0 ){
          $quantity = $data['quantity'] - $aSalesQuantity[0]['locked'];
          $locked = true;
        }else{
          $quantity = $data['quantity'];
        }
        //$this->log->aPrint( $quantity );
        // sometimes sales edit price forcely
        if( $data['rate'] > 0 ){
          $data['ws_price'] = $data['rate'];
          $data['rt_price'] = $data['rate'];
        }
        
        /***
        //$response[$i]['model'] = substr($data['model'],2,4);
        $response[$i]['model'] = $data['model'];
        $response[$i]['product_id'] = $data['product_id'];
        $response[$i]['product_name'] = $product_name;
        $response[$i]['quantity'] = $quantity;
        $response[$i]['ws_price'] = $data['ws_price'];
        $response[$i]['rt_price'] = $data['rt_price'];
        $response[$i]['weight'] = $data['ups_weight'];
        $response[$i]['image'] = '';  // image is not used
        $response[$i]['pc'] = ''; // pc is not used
        $response[$i]['dc1'] = $data['dc1'];
        $response[$i]['dc2'] = $data['dc2'];
        $response[$i]['locked'] = $locked;
        
        // from sales
        $response[$i]['cnt'] = $data['cnt'];
        $response[$i]['free'] = $data['free'];
        $response[$i]['damage'] = $data['damage'];
        $response[$i]['promotion'] = $data['promotion'];
        $response[$i]['total_price'] = $data['total_price'];
        $response[$i]['weight_row'] = $data['weight_row'];
        $response[$i]['backorder'] = $data['backorder'];
        $response[$i]['backfree'] = $data['backfree'];
        $response[$i]['backdamage'] = $data['backdamage'];
        **/

        $response[$i]['m']  = $data['model'];
        $response[$i]['id'] = $data['product_id'];
        $response[$i]['pn'] = trim($product_name);
        $response[$i]['q']  = $quantity;
        $response[$i]['ws'] = $data['ws_price'];
        $response[$i]['rt'] = $data['rt_price'];
        $response[$i]['wt'] = $data['ups_weight'];
        //$response[$i]['i'] = '';  // image is not used
        //$response[$i]['p'] = ''; // pc is not used
        $response[$i]['d1'] = $data['dc1'];
        $response[$i]['d2'] = $data['dc2'];
        //$response[$i]['l'] = $locked; // locked not used
        
        // from sales
        $response[$i]['c']  = ( isset($data['cnt']        ) && $data['cnt']         != 'null' ) ? $data['cnt'] : 0 ;
        $response[$i]['f']  = ( isset($data['free']       ) && $data['free']        != 'null' ) ? $data['free'] : 0 ;
        $response[$i]['d']  = ( isset($data['damage']     ) && $data['damage']      != 'null' ) ? $data['damage'] : 0 ;
        $response[$i]['p']  = ( isset($data['promotion']  ) && $data['promotion']   != 'null' ) ? $data['promotion'] : 0 ;
        $response[$i]['tp'] = ( isset($data['total_price']) && $data['total_price'] != 'null' ) ? $data['total_price'] : 0 ;
        $response[$i]['wr'] = ( isset($data['weight_row'] ) && $data['weight_row']  != 'null' ) ? $data['weight_row'] : 0 ;
        //$response[$i]['bo'] = ( isset($data['backorder']  ) && $data['backorder']   != 'null' ) ? $data['backorder'] : 0 ;
        //$response[$i]['bf'] = ( isset($data['backfree']   ) && $data['backfree']    != 'null' ) ? $data['backfree'] : 0 ;
        //$response[$i]['bd'] = ( isset($data['backdamage'] ) && $data['backdamage']  != 'null' ) ? $data['backdamage'] : 0 ;
        //$response[$i]['bp'] = ( isset($data['backpromotion'] ) && $data['backpromotion']  != 'null' ) ? $data['backpromotion'] : 0 ;
//$this->log->aPrint( $response );
      }elseif( '' == $m ){
        $response[$i] = array();
      }
      $i++;
    }
    //$this->log->aPrint( $response );
    echo json_encode($response);
  }

  // crond prepare atc 
  // http://192.168.0.90/backyard/index.php?route=sales/atc/setCategoryATC
  public function setCategoryATC(){
    $this->load->model('product/lib');
    $data = $this->model_product_lib->getCategoryMap();
    //$this->log->aPrint( $data );    exit;
    $aCatAtc = array();
    $new_cat = '';
    $line = '';
    $i = 0;
    $cnt = count($data);
    foreach($data as $aCatProduct){
      $cat = $aCatProduct['category_id'];
      $model = $aCatProduct['model'];
      if($cat != $new_cat){
        if('' != $line){ 
          //$line = substr($line,0,-1);
          $aCatAtc[$new_cat] = $line;
        }
        $line = '';
        $new_cat = $cat;
        $line = $model . ',';
      }else{
        $line .= $model . ',';
        if($i+1 == $cnt) $aCatAtc[$new_cat] = $line;
      }
      $i++;
    }
    /*
    echo '<pre>';
    print_r($aCatAtc);
    echo '</pre>';
    */
    
    $outFile = $_SERVER["DOCUMENT_ROOT"]."/backyard/data/categoryMap";
    $fp = fopen($outFile, 'w');
    foreach($aCatAtc as $k => $v){
      $line = $v;
      fwrite($fp, $line."\n");
    
    }
    fclose($fp);
  }

  // http://192.168.0.90/backyard/index.php?route=sales/atc/tmpStoreArrange
  function tmpStoreArrange(){
    $this->load->model('store/store');
    $this->model_store_store->tmpStoreArrange();
    
  }

}
?>