<?php
class ModelArOrder extends Model {
  public function getTxid($txid){
    $sql = "select txid from transaction where substr(txid,1,18) like '%{$txid}%'";
    // select txid from transaction where substr(txid,1,17) = 'JH20110325-FL4545'
		//echo $sql;
		$query = $this->db->query($sql);
		return $query->rows;
  }
  public function insertTransaction($data){
    //$this->log->aPrint( $data ); exit;
    $sql = "INSERT INTO transaction ";
    $sql.= " (txid,store_id,description,order_user,saled_ym,term,order_price,";
    $sql.="   weight_sum,order_date,balance,payed_sum,status) values (";
    $sql.= " '" . $data['txid'] . "','" . $data['store_id'] . "','" . $data['description'] . "','";
    $sql.= $data['order_user'] . "','" . $data['saled_ym'] . "','";
    $sql.= $data['term'] . "','" . $data['order_price'] . "','" . $data['weight_sum'] . "','" . $data['order_date'] . "','";
    $sql.= $data['balance'] . "','" . $data['payed_sum']."',".$data['status']."')";
    //echo $sql;
    //exit;
		if($this->db->query($sql)){
		  return 'ok';
		}else{
		  return 'fail';
		}
  }
  public function insertSales($data){
    //$this->log->aPrint( $data ); exit;
    /*
        $aModel,
        $aProduct_id,       
        $aStock,      
        $aCnt,      
        $aFree,             
        $aDamage,
        6 - $aPrice,
        $aDiscount, 
        $aTotal_price,
        $aWeight_row,
    */
    $sql = "delete from sales where txid = '" . $data['txid'] . "'";
    if($this->db->query($sql)){
  	  // todo. set flag to control ok , besso-201103 
  	  //return 'ok';
  	}else{
  		//return 'fail';
  	}
    for($i=0;$i<count($data[1]);$i++){
      //print_r($data);
      if($data[9][$i]){ // if weight_row exist, it could be 0 quantity for freegood or damage
        
        if(NULL == $data[3][$i]) $data[3][$i] = 0;
        if(NULL == $data[4][$i]) $data[4][$i] = 0;
              
        $sql = "INSERT INTO sales ";
        $sql.= " (txid,model,product_id,order_quantity,free,damage,price1,discount,total_price,weight_row,order_date)";
        $sql.= " values ('" . $data['txid']. "','" .$data[0][$i]. "','" .$data[1][$i]. "'," .$data[3][$i]. ",";
        $sql.= $data[4][$i] . "," . $data[5][$i] . "," . $data[6][$i] .",'";
        $sql.= $data[7][$i]. "','" .$data[8][$i]. "','" .$data[9][$i] ."','" .$data['order_date'] . "')";
        //echo $sql;
  		  if($this->db->query($sql)){
  		    // todo. set flag to control ok , besso-201103 
  		    //return 'ok';
  		  }else{
  		    //return 'fail';
  		  }
  
        $sql = "update product set quantity = " . $data[2][$i] . " where product_id = '" . $data[1][$i] . "'";
  		  //echo $sql;
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

    $sql = "delete from ship where txid = '" . $data['txid'] . "'";        
    if($this->db->query($sql)){
  	  // todo. set flag to control ok , besso-201103 
  	  //return 'ok';
  	}else{
  		//return 'fail';
  	}

    /***
    echo '<pre>';
    print_r($data);
    echo '</pre>';
    //exit;
    ***/
    /***
        0$aMethod,
        1$aShip_date,
        2$aLift,
        3$aCod,
        4$aShip_appointment,
        5$aShip_comment,
        6$aShip_user,
    [txid] => BE20110330-FL4545-2
    ***/
    for($i=0;$i<count($data[1]);$i++){
      // todo. use ship_date as key, it's not strong one , besso-201103 
      if($data[1][$i]){
        $sql = "INSERT INTO ship ";
        $sql.= " (txid,method,ship_date,lift,cod,ship_appointment,ship_comment,ship_user) values (";
        $sql.= " '" . $data['txid'] . "','" . $data[0][$i] . "','" . $data[1][$i] . "','";
        $sql.= $data[2][$i] . "','" . $data[3][$i] . "','";
        $sql.= $data[4][$i] . "','" . addslashes($data[5][$i]) . "','";
        $sql.= $data[6][$i] . "')";
        //echo $sql . '<br/>';
  		  
  		  if($this->db->query($sql)){
  		    //return 'ok';
  		  }else{
  		    //return 'fail';
  		  }
  		}
  	} // end for
  	return 'ok';
  }

  public function insertPay($data,$balance,$payed_sum){

    $sql = "delete from pay where txid = '" . $data['txid'] . "'";        
    if($this->db->query($sql)){
  	  // todo. set flag to control ok , besso-201103 
  	  //return 'ok';
  	}else{
  		//return 'fail';
  	}

    /*
        $aPay_price,
        $aPay_method,
        $aPay_date,
        $aPay_num,
        $aPay_user,
        'txid' => $txid
    */
    /*/
    echo '<pre>';
    print_r($data);
    echo '</pre>';
    //exit;
    /*/
    for($i=0;$i<count($data[0]);$i++){
      // todo. use pay_price as key, it's not strong one , besso-201103 
      if($data[0][$i]){
        $sql = "INSERT INTO pay ";
        $sql.= " (txid,pay_price,pay_method,pay_date,pay_num,pay_user) values (";
        $sql.= " '" . $data['txid'] . "','" . $data[0][$i] . "','" . $data[1][$i] . "','";
        $sql.= $data[2][$i] . "','" . $data[3][$i] . "','";
        $sql.= $data[4][$i] . "')";
        /*
        echo $sql;
  		  exit;
  		  */
  		  if($this->db->query($sql)){
  		    //return 'ok';
  		  }else{
  		    //return 'fail';
  		  }
  		}
		}
    
    // update balance and payed_sum to tx
    $sql = "update transaction set balance = $balance, payed_sum = $payed_sum where txid = '" . $data['txid'] . "'";
    //echo $sql;
    //exit;
    if($this->db->query($sql)){
  	  // todo. set flag to control ok , besso-201103 
  	  //return 'ok';
  	}else{
  		//return 'fail';
  	}
    
    return 'ok';
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
    //echo $sql;
    
		$query = $this->db->query($sql);
		$response = $query->row;
    
    return $response;
  }

  public function selectStoreARTotal($store_id){
    $sql = "
            select store_id,
               count(txid) as count,
                sum(order_price) as tot_order ,
                sum(payed_sum) as tot_payed,
               (sum(order_price) - sum(payed_sum)) as balance
          from transaction
         where store_id = $store_id";
		$query = $this->db->query($sql);
		$data = $query->row;
    return $data;
  }  
  
  public function selectStoreHistory($store_id){
    /***
    echo '<pre>';
    print_r($data);
    echo '</pre>';
    exit;
    ***/
    $sql = "
           select pa.txid,tx.order_date, tx.order_price, tx.payed_sum, tx.balance, 
                  datediff(date_format(curdate(),'%Y%m%d'),date_format(tx.order_date,'%Y%m%d')) as order_diff,
                  pa.pay_date,
                  pa.pay_price,
                  datediff(date_format(pa.pay_date,'%Y%m%d'),date_format(tx.order_date,'%Y%m%d')) as pay_diff
             from pay pa, transaction tx
            where pa.txid = tx.txid
              and tx.txid in (select txid from transaction where store_id = {$store_id})
              and tx.balance != 0
            order by tx.order_date,pa.pay_date asc
           ";
		//echo $sql;
		$query = $this->db->query($sql);
		$data = $query->rows;
    
    $t1 = '';
    $aData = array();
    foreach($data as $k => $v){
      $txid = $v['txid'];
      if($txid != $t1){
        $t1 = $txid;
        $i = 0;
        $aData[$txid]['order_date'] = $v['order_date'];
        $aData[$txid]['order_price'] = $v['order_price'];
        $aData[$txid]['payed_sum'] = $v['payed_sum'];
        $aData[$txid]['balance'] = $v['balance'];
        $aData[$txid]['order_diff'] = $v['order_diff'];
        $aData[$txid]['pay'][$i] = array(
                                    'pay_date' => $v['pay_date'],
                                    'pay_price' => $v['pay_price'],
                                    'pay_diff' => $v['pay_diff'],
                                   );
        $i++;
      }else{
        $i++;
        $aData[$txid]['pay'][$i]['pay_date'] = $v['pay_date'];
        $aData[$txid]['pay'][$i]['pay_price'] = $v['pay_price'];
        $aData[$txid]['pay'][$i]['pay_diff'] = $v['pay_diff'];
      }
    }
    return $aData;
  }
  
  public function selectSales($txid){
    //$this->log->aPrint( $txid );
    $aCat = $this->config->ubpCategory();
    $aSales = array();
    foreach($aCat as $k => $v){
      $sql = "select s.product_id, s.model, s.order_quantity, s.price1,
                     s.free, s.damage, s.discount, s.total_price, p.quantity, s.weight_row, p.ups_weight ,p.image, pd.name_for_sales as product_name, p.pc
                from sales s, product p, product_description pd
               where s.txid ='$txid' and s.product_id = p.product_id and p.product_id = pd.product_id 
                 and substr(s.model,1,2) = '$k' order by s.model" ;
	  	$query = $this->db->query($sql);
	  	//$this->log->aPrint( $sql );	  	exit;
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
    exit;
    */
    $aData = array();
    $sql = "select *
              from ship
             where txid ='$txid' order by ship_date";
    //echo $sql;
  	//exit;
  	$query = $this->db->query($sql);
	  $res = $query->rows;
	  $aData = $res;
    
    return $aData;
  }

  public function selectPay($txid){
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
  
  /*** always update store information
        'id' => $store_id,
        'name' => $store_name,
        'accountno' => $accountno,
        'salesrep' => $salesrep,
        'address1' => $address1,
        'city' => $city,
        'state' => $state,
        'zipcode' => $zipcode,
        'storetype' => $storetype,
        'phone1' => $phone1,
        'fax' => $fax
  ***/
  public function updateStore($data){
    $sql = "update storelocator set name = '" . $data['name'] . "'," ;
    $sql.= " accountno = '" . $data['accountno'] . "'," ;
    $sql.= " salesrep = '" . $data['salesrep'] . "'," ;
    $sql.= " address1 = '" . $data['address1'] . "'," ;
    $sql.= " city = '" . $data['city'] . "'," ;
    $sql.= " state = '" . $data['state'] . "'," ;
    $sql.= " zipcode = '" . $data['zipcode'] . "'," ;
    $sql.= " storetype = '" . $data['storetype'] . "'," ;
    $sql.= " phone1 = '" . $data['phone1'] . "'," ;
    $sql.= " fax = '" . $data['fax'] . "' " ;
    $sql.= " where id = '" . $data['id'] . "'";
    //echo $sql; exit;
    
    if($this->db->query($sql)){
		  return 'ok';
		}else{
		  return 'fail';
		}
  }

  public function updateTransaction($data){
    /*
    echo '<pre>';
    print_r($data);
    echo '</pre>';
    */
    $sql = "update transaction set store_id = '" . $data['store_id'] . "'," ;
    $sql.= " description = '" . $data['description'] . "'," ;
    $sql.= " order_user = '" . $data['order_user'] . "'," ;
    $sql.= " saled_ym = '" . $data['saled_ym'] . "'," ;
    $sql.= " term = '" . $data['term'] . "'," ;
    $sql.= " order_price = '" . $data['order_price'] . "'," ;
    $sql.= " weight_sum = '" . $data['weight_sum'] . "'," ;
    $sql.= " status = '" . $data['status'] . "'," ;
    $sql.= " order_date = '" . $data['order_date'] . "'" ;
    $sql.= " where txid = '" . $data['txid'] . "'";
    //echo $sql; //exit;
    
    if($this->db->query($sql)){
		  return 'ok';
		}else{
		  return 'fail';
		}
  }
}
?>