<?php
/*
todo. need to make copy functionality

*/
class ModelInvoiceOrder extends Model {

  public function getTxid($txid){
    $sql = "select txid from transaction where substr(txid,1,17) = '{$txid}'";
    // select txid from transaction where substr(txid,1,17) = 'JH20110325-FL4545'
    // echo $sql;
		$query = $this->db->query($sql);
		/*
		echo '</pre>';
		print_r($query->rows);
		echo '</pre>';
		*/
		return $query->rows;      
  }

  public function insertTransaction($data){
    /***
    echo '<pre>';
    print_r($data);
    echo '</pre>';
    exit;
    ***/
    $sql = "INSERT INTO transaction ";
    $sql.= " (txid,store_id,description,order_user,saled_ym,term,other_cost,order_price,weight_sum,order_date) values (";
    $sql.= " '" . $data['txid'] . "','" . $data['store_id'] . "','" . $data['description'] . "','";
    $sql.= $data['order_user'] . "','" . $data['saled_ym'] . "','";
    $sql.= $data['term'] . "','" . $data['other_cost'] . "','" . $data['order_price'] . "','" . $data['weight_sum'] . "','" . $data['order_date'] . "')";

		if($this->db->query($sql)){
		  return 'ok';
		}else{
		  return 'fail';
		}
    
  }

  public function insertSales($data){
    /*
    echo '<pre>';
    print_r($data);
    echo '</pre>';
    */
    for($i=0;$i<count($data[1]);$i++){
      if($data[1][$i]){ // if product id exist
        $sql = "INSERT INTO sales ";
        $sql.= " (txid,model,product_id,order_quantity,free,price1,discount,total_price,weight_row,order_date)";
        $sql.= " values ('" . $data['txid']. "','" .$data[0][$i]. "','" .$data[1][$i]. "','" .$data[3][$i]. "',";
        $sql.= $data[4][$i] . ",'" . $data[5][$i] ."','";
        $sql.= $data[6][$i]. "','" .$data[7][$i]. "','" .$data[8][$i] ."','" .$data['order_date'] . "')";
        //echo $sql;
  		  if($this->db->query($sql)){
  		    // todo. set flag to control ok , besso-201103 
  		    //return 'ok';
  		  }else{
  		    //return 'fail';
  		  }
  
        $sql = "update product set quantity = " . $data[2][$i] . " where product_id = '" . $data[1][$i] . "'";
  		  // echo $sql;
  		  if($this->db->query($sql)){
  		    // todo. set flag to control ok , besso-201103 
  		    //return 'ok';
  		  }else{
  		    //return 'fail';
  		  }
      }
    }

    // todo. temporary , besso-201103 
    return 'ok';
  }

  public function insertShip($data){
    /***
    echo '<pre>';
    print_r($data);
    echo '</pre>';
    exit;
    ***/
    /***
    Array
    [0] => Array
            [0] => ups
    [1] => Array
            [0] => 03302011
    [2] => Array
            [0] => 5
    [3] => Array
            [0] => 9.25
    [4] => Array
            [0] => besso
    [txid] => BE20110330-FL4545-2
    ***/
    for($i=0;$i<count($data[1]);$i++){
      $sql = "INSERT INTO ship ";
      $sql.= " (txid,method,ship_date,lift,cod,ship_user) values (";
      $sql.= " '" . $data['txid'] . "','" . $data[0][$i] . "','" . $data[1][$i] . "',";
      $sql.= $data[2][$i] . "," . $data[3][$i] . ",'";
      $sql.= $data[4][$i] . "')";
      //echo $sql;
		  if($this->db->query($sql)){
		    return 'ok';
		  }else{
		    return 'fail';
		  }
		}
  }
  // INSERT INTO ship (txid,method,ship_date,lift,cod,ship_user) values 
  // ( 'JH20110330-FL4545-1','self','23302011',115,91.25,'besso') 

  public function insertPayment($data){
    /*
        $aPay_price,
        $aPay_method,
        $aPay_date,
        $aPay_num,
        $aPay_user,
        'txid' => $txid
    */
    for($i=0;$i<count($data[1]);$i++){
      $sql = "INSERT INTO pay ";
      $sql.= " (txid,pay_price,pay_method,pay_date,pay_num,pay_user) values (";
      $sql.= " '" . $data['txid'] . "','" . $data[0][$i] . "','" . $data[1][$i] . "','";
      $sql.= $data[2][$i] . "','" . $data[3][$i] . "','";
      $sql.= $data[4][$i] . "')";
      //echo $sql;
		  if($this->db->query($sql)){
		    return 'ok';
		  }else{
		    return 'fail';
		  }
		}

  }

  public function selectTransaction($txid){
    /***
    echo '<pre>';
    print_r($data);
    echo '</pre>';
    exit;
    ***/
    $sql = "select * from transaction where txid ='$txid'";
		$query = $this->db->query($sql);
		$response = $query->row;
    return $response;
  }

  public function selectStore($id){
    $sql = "select * from storelocator where id ='$id'";
		$query = $this->db->query($sql);
		$response = $query->row;
    return $response;
  }
  
  public function selectSales($txid){
    /***
    echo '<pre>';
    print_r($data);
    echo '</pre>';
    exit;
    **/
    $aCat = $this->config->ubpCategory();
    $aSales = array();
    foreach($aCat as $k => $v){
      $sql = "select s.product_id, s.model, s.order_quantity, s.price1,
                     s.free, s.discount, s.total_price, p.quantity, s.weight_row 
                from sales s, product p
               where s.txid ='$txid' and s.product_id = p.product_id 
                 and substr(s.model,1,2) = '$k' order by s.model" ;
	  	$query = $this->db->query($sql);
		  $res = $query->rows;
		  $aSales[$k] = $res;
    }
    
    return $aSales;
  }

  public function selectShip($txid){
    /*
    echo '<pre>';
    print_r($data);
    echo '</pre>';
    //exit;
    */
    $aData = array();
    $sql = "select *
              from ship
             where txid ='$txid' order by ship_date";
    //echo $sql;
  	$query = $this->db->query($sql);
	  $res = $query->rows;
	  $aData = $res;
    
    return $aData;
  }

  public function selectPayment($data){
    /*
    echo '<pre>';
    print_r($data);
    echo '</pre>';
    //exit;
    */
    $aData = array();
    $sql = "select *
              from pay
             where txid ='$txid' order by pay_date";
    //echo $sql;
  	$query = $this->db->query($sql);
	  $res = $query->rows;
	  $aData = $res;
    
    return $aData;
  }
}
?>