<?php
/*
todo. need to make copy functionality
*/
class ModelSalesOrder extends Model{
  public function getSalesQuantity($model){
    $result = array();
    $sql = "select sum(s.order_quantity) as locked
              from transaction t, sales s
             where t.txid = s.txid
               and t.shipped_yn != 'Y'
               and s.model = '$model'";
    //$this->log->aPrint( $sql ); exit;
    $query = $this->db->query($sql);
		$locked = $query->row['locked'];
    if( $locked > 0 ){
      $sql = "select sum(s.order_quantity) as rep_total, t.order_user,'$locked' as locked
                from transaction t, sales s
               where t.txid = s.txid
                 and t.shipped_yn != 'Y'
                 and s.model = '$model'
               group by t.order_user";
      //echo $sql;
      $query = $this->db->query($sql);
      $result = $query->rows;
    }
 		return $result;
  }

  /* lookup existing Txid and retrieve next offset from DB
   * return 1, if exists already
   */ 
  public function getTxid($txid){
    $sql = "select max( substr(txid,-1) + 1 ) as offset from transaction where txid like '%{$txid}%' order by txid";
		$query = $this->db->query($sql);
		isset($query->row['offset']) ? $offset = $query->row['offset'] : $offset = '1';
		$txid = $txid . '-' . $offset;
		return $txid;
  }

  public function updateApprove($txid,$status){
    $today = date('Y-m-d');
    $approve_user = $this->user->getUserName();
    $sql = "update transaction set approve_status = '$status', approved_user = '$approve_user', ";
    $sql.= " approved_date = '$today' where txid = '$txid'";
    //$this->log->aPrint( $sql );
    if($query = $this->db->query($sql)){
      return true;
    }
  }

  public function insertTransaction($data){
    //$this->log->aPrint( $data ); exit;
    $executor = $this->user->getUsername();
    $order_date = $data['order_date'] . ' ' . date("H:m:s");
    //$this->log->aPrint( $order_date ); exit;
    //$order_price = $data['order_price'] + $data['ship_cod'] + $data['ship_lift'];
    $sql = "INSERT INTO transaction ";
    $sql.= " (txid,store_id,description,order_user,saled_ym,order_price,weight_sum,";
    $sql.= "  order_date,balance,payed_sum,shipped_yn,executor ,payment,ship_method,";
    $sql.= "  cod,lift,ship_appointment,status,discount,pc_date,post_check,cur_check,cur_cash) values (";
    $sql.= " '" . $data['txid'] . "','" . $data['store_id'] . "','" . $data['description'] . "','";
    $sql.= $data['order_user'] . "','" . $data['saled_ym'] . "','";
    $sql.= $data['order_price'] . "','" . $data['weight_sum'] . "','" . $order_date . "','";
    $sql.= $data['balance'] . "','" . $data['payed_sum'] . "','" . $data['shipped_yn'] . "','" . $executor . "','";
    $sql.= $data['payment'] . "','" . $data['ship_method'] . "'," . $data['ship_cod'] . "," . $data['ship_lift'] . ",'";
    $sql.= $data['ship_appointment'] . "','". $data['status'] ."','" . $data['discount'] . "','";
    $sql.= $data['pc_date'] . "'," . $data['post_check'] . "," . $data['cur_check'] . "," . $data['cur_cash'] . ")";
		if($this->db->query($sql)){
		  return true;
		}else{
      if( !$this->db->query($sql) ){
        $aErr = array();
        $aErr['key'] = $txid;
        $aErr['msg'] = $sql;
        $this->sendBesso($aErr);
        echo '<br/>Besso solve soon, sorry for disturbing<br/>';
        return false;
      }
		}
  }

  // todo. input arg could be different in cases.
  // so it's better to check if already existed model or not
  public function insertSales($data){
    //$this->log->aPrint( $data ); exit;
    
    $aExist = array();
    $txid = $data['txid'];
    $order_date = $data['order_date'];
    
    $sql = "select model from sales where txid = '$txid'";
    //$this->log->aPrint( $sql ); exit;
    $this->db->query($sql);
    $query = $this->db->query($sql);
    foreach($query->rows as $exist) $aExist[] = $exist['model'];
    //$this->log->aPrint( $aExist );
    
    for($i=0;$i<count($data[1]);$i++){
      $aErr = array();
      $model = $data[0][$i];
      $product_id = $data[1][$i];
      $order_quantity = $data[3][$i];   if(NULL == $order_quantity) $order_quantity = 0;
      $free = $data[4][$i];      if('f' == $free) $free = 0;
      $damage = $data[5][$i];    if('d' == $damage) $damage = 0;
      $price1 = $data[6][$i];
      $discount = $data[7][$i];   if('d1' == $discount)  $discount = 0;
      $discount2 = $data[10][$i]; if('d2' == $discount2) $discount2 = 0;
      $total_price = $data[8][$i];
      $weight_row = $data[9][$i];
      $backorder  = isset($data[11][$i]) ? $data[11][$i] : 0;
      $backfree   = isset($data[12][$i]) ? $data[12][$i] : 0;
      $backdamage = isset($data[13][$i]) ? $data[13][$i] : 0;
      $promotion  = isset($data[14][$i]) ? $data[14][$i] : 0;   if('p' == $promotion) $promotion = 0;
      $backpromotion  = isset($data[15][$i]) ? $data[15][$i] : 0; 
      
      //$this->log->aPrint( $promotion );
      if( isset($aExist) && in_array($model,$aExist) ) {
        //echo 'exist : ' . $model;
        if( 0 == $order_quantity && 0 == $free && 0 == $damage && 0 == $backorder && 0 == $backfree && 0 == $backdamage && 0 == $promotion ){
          $sql = "delete from sales where txid = '$txid' and model = '$model'";
          $this->db->query($sql);
        }else{
          $sql = "update sales set ";
          $sql.= " order_quantity = $order_quantity ,free = $free ,damage = $damage ,discount = $discount , total_price = $total_price, ";
          $sql.= " weight_row = $weight_row, discount2 = $discount2 , order_date = '$order_date', price1 = $price1,";
          //$sql.= " backorder = $backorder, backfree = $backfree, backdamage = $backdamage, promotion = $promotion , backpromotion = $backpromotion";
          $sql.= " promotion = $promotion ";
          $sql.= " where model = '$model' and txid = '$txid'";
          //if( $model == 'VN7916' )  $this->log->aPrint( $sql );
          if( !$this->db->query($sql) ){
            $aErr['key'] = $txid;
            $aErr['msg'] = $sql;
            $this->sendBesso($aErr);
            return false;
          }
        }
      }else{
        if($order_quantity || $free || $damage || $promotion){
          $sql = "INSERT INTO sales ";
          $sql.= " (txid,model,product_id,order_quantity,free,damage,price1,discount,total_price,weight_row,discount2,order_date,promotion,backpromotion)";
          $sql.= " values ('" . $data['txid']. "','" . $model . "','" . $product_id . "'," . $order_quantity . ",";
          $sql.= $free . "," . $damage . "," . $price1 .",";
          $sql.= $discount . "," . $total_price . "," . $weight_row ."," . $discount2 .",'" .$data['order_date'] . "',";
          $sql.= $promotion . "," . $backpromotion . ")";
          //$this->log->aPrint( $sql );
          if( $this->db->query($sql) ){
            $aErr['key'] = $txid;
            $aErr['msg'] = $sql;
            $this->sendBesso($aErr);
            return false;
          }
		    }
      }
    } // end for
    
    // todo. temporary , besso-201103 
    return true;
  }

  public function insertShip($data){
    $sql = "delete from ship where txid = '" . $data['txid'] . "'";        
    if($this->db->query($sql)){
  	  // todo. set flag to control ok , besso-201103 
  	  //return true;
  	}else{
  		//return false;
  	}
    for($i=0;$i<count($data[1]);$i++){
      // todo. use ship_date as key, it's not strong one , besso-201103 
      if($data['txid']){
        $sql = "INSERT INTO ship ";
        $sql.= " (txid,method,ship_date,lift,cod,ship_appointment,ship_comment,ship_user) values (";
        $sql.= " '" . $data['txid'] . "','" . $data[0][$i] . "','" . date('Y-m-d') . "','";
        $sql.= $data[2][$i] . "','" . $data[3][$i] . "','";
        $sql.= $data[4][$i] . "','" . addslashes($data[5][$i]) . "','";
        $sql.= $data[6][$i] . "')";
        //$this->log->aPrint( $sql ); exit;
  		  if($this->db->query($sql)){
  		    //return true;
  		  }else{
  		    //return false;
  		  }
  		}
  	} // end for
  	return true;
  }

  public function insertPay($data,$balance,$payed_sum,$order_price){
    $sql = "delete from pay where txid = '" . $data['txid'] . "'";        
    if($this->db->query($sql)){
  	  //return true;
  	}else{
  		//return false;
  	}
    /*
        $aPay_price,
        $aPay_method,
        $aPay_date,
        $aPay_num,
        $aPay_user,
        'txid' => $txid
    */
    /*
    $this->log->aPrint( $data );
    $this->log->aPrint( $balance );
    $this->log->aPrint( $order_price );
    $this->log->aPrint( $payed_sum );
    */
    # Double check the balance and payed
    $tmpPayed = 0;
    for($i=0;$i<count($data[0]);$i++){
      // todo. use pay_price as key, it's not strong one , besso-201103 
      if($data[0][$i]){
        $sql = "INSERT INTO pay ";
        $sql.= " (txid,pay_price,pay_method,pay_date,pay_num,pay_user,store_id) values (";
        $sql.= " '" . $data['txid'] . "','" . $data[0][$i] . "','" . $data[1][$i] . "','";
        $sql.= $data[2][$i] . "','" . $data[3][$i] . "','";
        $sql.= $data['pay_user'] . "','" . $data['store_id'] . "')";
  		  $this->db->query($sql); // ? //return true; : //return false ;
  		}
  		$tmpPayed += $data[0][$i];
		}
		if(number_format($tmpPayed,2) != number_format($payed_sum,2)){
		  echo 'Payed Sum Wrong !! call IT team';
		  exit;
		}
		$tmpBalance = number_format($order_price - $tmpPayed,2);
		//$this->log->aPrint( $tmpBalance); exit;
		if(number_format($balance,2) != $tmpBalance){
		  echo 'Balance Wrong !! call IT team';
		  exit;
		}
    // update balance and payed_sum to tx
    $sql = "update transaction set balance = $balance, payed_sum = $payed_sum where txid = '" . $data['txid'] . "'";
	  $this->db->query($sql);
    return true;
  }

  public function selectTransaction($txid){
    $sql = "select * from transaction where txid ='$txid'";
		$query = $this->db->query($sql);
		//$this->log->aPrint( $sql );
		$response = $query->row;
    return $response;
  }

  public function selectStore($id){
    $sql = "select * from storelocator where id ='$id'";
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

  public function quickbookHistory($store_id){
    $sql = "select a.* from storelocator s, ar_kim a where trim(s.accountno) = trim(a.c1) and s.id = $store_id";
    //echo $sql;
		$query = $this->db->query($sql);
		$data = $query->row;
    return $data;
  }

  public function selectStoreHistory($store_id){
    //datediff(date_format(pa.pay_date,'%Y%m%d'),date_format(tx.order_date,'%Y%m%d')) as pay_diff
    // todo. bad design and no monetized date type lead this exception query , besso 201108 
    $sql = "
           (select pa.txid as txid,tx.order_date, tx.order_price, tx.payed_sum, tx.balance, 
                  datediff(date_format(curdate(),'%Y%m%d'),date_format(tx.order_date,'%Y%m%d')) as order_diff,
                  pa.pay_date,
                  pa.pay_price,
                  pa.pay_method,
                  pa.pay_num,
                  datediff(date_format(concat(substr(pa.pay_date,1,4),substr(pa.pay_date,5,2),substr(pa.pay_date,7,2)),'%Y%m%d'),date_format(tx.order_date,'%Y%m%d')) as pay_diff
             from pay pa, transaction tx
            where pa.txid = tx.txid
              and tx.txid in (select txid from transaction where store_id = {$store_id})
              and tx.balance != 0 ) 
            union
           (select txid, order_date, order_price, payed_sum, balance,
                   datediff(date_format(curdate(),'%Y%m%d'),date_format(order_date,'%Y%m%d')) as order_diff, 
                   '','','','',''
              from transaction
             where store_id = {$store_id}
               and format(balance,2) != 0.00 )
             order by txid,pay_price desc
           ";
    //$this->log->aPrint( $sql ); exit;
		$query = $this->db->query($sql);
		$data = $query->rows;
    //$this->log->aPrint( $data );
    $t1 = '';
    $aData = array();
    foreach($data as $k => $v){
      //echo $v['order_price'];
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
                                    'pay_method' => $v['pay_method'],
                                    'pay_num' => $v['pay_num'],
                                   );
        $i++;
      }else{
        $i++;
        $aData[$txid]['pay'][$i]['pay_date'] = $v['pay_date'];
        $aData[$txid]['pay'][$i]['pay_price'] = $v['pay_price'];
        $aData[$txid]['pay'][$i]['pay_diff'] = $v['pay_diff'];
        $aData[$txid]['pay'][$i]['pay_method'] = $v['pay_method'];
        $aData[$txid]['pay'][$i]['pay_num'] = $v['pay_num'];
      }
    }
    //$this->log->aPrint( $aData );
    return $aData;
  }

  public function selectFreegoodSum($txid){
    //$this->log->aPrint( $txid );
    $sql = "select sum(free * price1) as freegood_sum from sales where txid = '$txid'";
    //$this->log->aPrint( $sql );
    $query = $this->db->query($sql);
	  $res = $query->row['freegood_sum'];
    return $res;
  }

  public function selectSales($txid){
    //$this->log->aPrint( $txid );
    $aCat = $this->config->ubpCategory();
    $aSales = array();
    foreach($aCat as $k => $v){
      $sql = "select s.product_id, s.model, s.order_quantity, s.price1, s.discount, s.discount2,
                     s.free, s.damage, s.discount, s.total_price, p.quantity, s.weight_row, 
                     p.ups_weight ,p.image, pd.name_for_sales as product_name, p.pc,
                     s.backorder,s.backfree,s.backdamage
                from sales s, product p, product_description pd
               where s.txid ='$txid' and s.product_id = p.product_id and p.product_id = pd.product_id 
                 and substr(s.model,1,2) = '$k' order by s.model" ;
	  	$query = $this->db->query($sql);
	  	//$this->log->aPrint( $sql );	  	exit;
		  $res = $query->rows;
		  $aSales[$k] = $res;
    }

    # merge OEM to exsiting flow
    $sql = "select s.product_id, s.model, s.order_quantity, s.price1, s.discount, s.discount2,
                   s.free, s.damage, s.discount, s.total_price, p.quantity, s.weight_row, 
                   p.ups_weight ,p.image, pd.name_for_sales as product_name, p.pc,
                   s.backorder,s.backfree,s.backdamage
              from sales s, product p, product_description pd
             where s.txid ='$txid' and s.product_id = p.product_id and p.product_id = pd.product_id 
               and substr(s.model,1,2) not in ('SP','AE','3S','VN','IR','QT') order by s.model";
	  $query = $this->db->query($sql);
	  $res = $query->rows;
	  $aSales['OEM'] = $res;
    return $aSales;
  }

  public function selectShip($txid){
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

  /*
    Update store information
    todo. i made Sales to edit Store-information in Order sheet.
    It could be blocked and let them go to Account Menu for any DDL
    If some decide to block this functinality later, Change several input as readonly or plain text , besso 201105 
    todo. Need more htmlentities (aka esacpe in db library ) work
   */
  public function updateStore($data){
    //$this->log->aPrint( $data ); exit;
    $sql = "update storelocator set name = '" . $this->db->escape($data['name']) . "'," ;
    $sql.= " accountno = '" . $data['accountno'] . "'," ;
    $sql.= " salesrep = '" . $data['salesrep'] . "'," ;
    $sql.= " address1 = '" . $data['address1'] . "'," ;
    $sql.= " city = '" . $data['city'] . "'," ;
    $sql.= " state = '" . $data['state'] . "'," ;
    $sql.= " zipcode = '" . $data['zipcode'] . "'," ;
    $sql.= " storetype = '" . $data['storetype'] . "'," ;
    $sql.= " phone1 = '" . $data['phone1'] . "'," ;
    $sql.= " fax = '" . $data['fax'] . "'," ;
    $sql.= " discount = '" . $data['discount'] . "'" ;
    $sql.= " where id = '" . $data['id'] . "'";
    if($this->db->query($sql)){
		  return true;
		}else{
		  return false;
		}
  }

  public function updateTransaction($data){
    //$this->log->aPrint( $data ); exit;
    $executor = $this->user->getUsername();
    //$order_date = $data['order_date'] . ' ' . date("H:m:s");
    //$order_price = $data['order_price'] + $data['ship_cod'] + $data['ship_lift'];
    $sql = "update transaction set store_id = '" . $data['store_id'] . "'," ;
    $sql.= " description    = '" . $this->db->escape($data['description']) . "'," ;
    $sql.= " order_user     = '" . $data['order_user'] . "'," ;
    $sql.= " saled_ym       = '" . $data['saled_ym'] . "'," ;
    $sql.= " order_price    = '" . $data['order_price'] . "'," ;
    $sql.= " balance        = '" . $data['balance'] . "'," ;
    $sql.= " weight_sum     = '" . $data['weight_sum'] . "'," ;
    //todo. allow to update order_date
    $sql.= " order_date     = concat('" . $data['order_date'] ."',substr(order_date,11,9)),";
    $sql.= " executor       = '" . $executor . "',";
    $sql.= " payment        = '" . $data['payment'] . "',";
    $sql.= " ship_method    = '" . $data['ship_method'] . "',";
    $sql.= " cod            = '" . $data['ship_cod'] . "',";
    $sql.= " lift           = '" . $data['ship_lift'] . "',";
    $sql.= " status         = '" . $data['status'] . "'," ;
    $sql.= " ship_appointment = '" . $data['ship_appointment'] . "',";
    $sql.= " shipto         = '" . $this->db->escape($data['shipto']) . "',";
    $sql.= " discount       = '" . $data['discount'] . "',";
    $sql.= " pc_date        = '" . $data['pc_date'] . "',";
    $sql.= " post_check     = '" . $data['post_check'] . "',";
    $sql.= " cur_check      = '" . $data['cur_check'] . "',";
    $sql.= " cur_cash       = '" . $data['cur_cash'] . "'";
    $sql.= " where txid     = '" . $data['txid'] . "'";
    //$this->log->aPrint( $sql ); exit;
    if($this->db->query($sql)){
		  return true;
		}else{
      if( !$this->db->query($sql) ){
        $aErr = array();
        $aErr['key'] = $txid;
        $aErr['msg'] = $sql;
        $this->sendBesso($aErr);
        echo '<br/>Besso solve soon, sorry for disturbing<br/>';
        return false;
      }
		}
  }
  
  public function sendBesso($request){
    $subject = $request['key'];
    $html    = $request['msg'];
    $mail = new Mail();
  	$mail->protocol = $this->config->get('config_mail_protocol');
  	$mail->hostname = $this->config->get('config_smtp_host');
  	$mail->username = $this->config->get('config_smtp_username');
  	$mail->password = $this->config->get('config_smtp_password');
  	$mail->port = $this->config->get('config_smtp_port');
  	$mail->timeout = $this->config->get('config_smtp_timeout');

    //$this->log->aPrint( $subject );
    $aReceiver = array(
      'besso@live.com',
    );

    foreach($aReceiver as $receiver){
  	  $mail->setTo($receiver);
  	  $mail->setFrom($this->config->get('config_email'));
  	  $mail->setSender('besso@live.com');
  	  $mail->setSubject($subject);
  	  //$mail->setText(html_entity_decode($body, ENT_QUOTES, 'UTF-8'));
      $mail->setHtml($html);
  	  $mail->send();
    }
  }
}
?>