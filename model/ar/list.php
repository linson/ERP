<?php
class ModelArList extends Model {
  public function importQB(){
    #truncate before import
    $sql = "truncate transaction"; 
    $query = $this->db->query($sql);
    
    $sql = "truncate sales"; 
    $query = $this->db->query($sql);
    
    $sql = "truncate ship";
    $query = $this->db->query($sql);
    
    //$sql = "select * from ar_kim where c1 = 'TX7699'";
    $sql = "select * from ar_kim";
    $query = $this->db->query($sql);
    
    foreach($query->rows as $k => $row){
      $t1 = $row['c1'];
      $aAcct = explode('-',$t1);
      $acct = $aAcct[0];
      $acct = str_replace('"','',$acct);
      if(strlen($acct) > 7 ) continue;
      $current = $row['current'];
      $c30 = $row['c30'];
      $c60 = $row['c60'];
      $c90 = $row['c90'];
      $c120 = $row['c120'];
      // todo. is it reasonable to create total_balance culumn in storelocator , besso 201105 
      $total = $row['total'];
      
      $today = date('Y-m-d');

      $date = date_create(date('Y-m-d'));
      date_add($date, date_interval_create_from_date_string('-10 days'));
      $date_current = date_format($date, 'Y-m-d');
      
      $date = date_create(date('Y-m-d'));
      date_add($date, date_interval_create_from_date_string('-22 days'));
      $date30 = date_format($date, 'Y-m-d');
      
      $date = date_create(date('Y-m-d'));
      date_add($date, date_interval_create_from_date_string('-50 days'));
      $date60 = date_format($date, 'Y-m-d');
      
      $date = date_create(date('Y-m-d'));
      date_add($date, date_interval_create_from_date_string('-80 days'));
      $date90 = date_format($date, 'Y-m-d');
      
      $date = date_create(date('Y-m-d'));
      date_add($date, date_interval_create_from_date_string('-110 days'));
      $date120 = date_format($date, 'Y-m-d');
      
      # get store and user information
      $this->load->model('store/store');
      $res = $this->model_store_store->getStoreOwner($acct);
      $this->log->aPrint( $acct );
      $owner = $res['salesrep'];
      $res = $this->model_store_store->getStoreID($acct);
      $store_id = $res['id'];
      
      
      
      for($i=0;$i<5;$i++){
        $txid = '';
        if( 0 == $i && 0 != $current ){
          $txid = $acct . '-' . $owner . str_replace('-','',$date_current) . '-' . (int)($i+1);
          $date = $date_current;
          $price = $current;
        }else if( 1 == $i && 0 != $c30 ){
          $txid = $acct . '-' . $owner . str_replace('-','',$date30) . '-' . (int)($i+1);
          $date = $date30;
          $price = $c30;
        }else if( 2 == $i && 0 != $c60 ){
          $txid = $acct . '-' . $owner . str_replace('-','',$date60) . '-' . (int)($i+1);
          $date = $date60;
          $price = $c60;
        }else if( 3 == $i && 0 != $c90 ){
          $txid = $acct . '-' . $owner . str_replace('-','',$date90) . '-' . (int)($i+1);
          $date = $date90;
          $price = $c90;
        }else if( 4 == $i && 0 != $c120 ){
          $txid = $acct . '-' . $owner . str_replace('-','',$date120) . '-' . (int)($i+1);
          $date = $date120;
          $price = $c120;
        }
        
        

        if('' != $txid){
          $data = "('$txid',$store_id,'improt from QB','$owner','CH','$date','','',30,0,'',$price,0,0,$price,'Y',0,'$date','approve',null)";
          $this->insTransaction($data);
          
          $data = "(null,'$txid',199,'SP2001',100,$price,null,0,0,0.00,$price,null,100,'$date',0)";
          $this->insSales($data);
          
          $data = "(null,'$txid','truck','$date',0,0,'','','$owner')";
          $this->insShip($data);
        }
      } // end for
    }
  }
  
  public function insTransaction($data){
    $sql = "insert into transaction values $data";
    $this->db->query($sql);
  }

  public function insSales($data){
    $sql = "insert into sales values $data";
    $this->db->query($sql);
  }

  public function insShip($data){
    $sql = "insert into ship values $data";
    $this->db->query($sql);
  }

  public function insPay($data){}

	public function getList($request = array(),&$export_sql){
    // todo. weird one. exclude all default condition from data to cache for * query in mysql , , besso-201103 
    if($request){
      $sql = "select x.txid, u.username as order_user, s.name as store_name,x.store_id,x.order_date,x.order_price,x.balance,";
      //$sql.= " if((order_price-payed_sum)>0,'yet','done') as payed_yn,x.shipped_yn, x.term";
      $sql.= " x.shipped_yn, x.term, x.bankaccount";
      $sql.= " from transaction x , storelocator s, user u, user_group ug where x.store_id = s.id and x.order_user = u.username";
      $sql.= "  and u.user_group_id = ug.user_group_id and ug.user_group_id in (1,11) ";
      // todo. this should be done by trigging , besso-201103 
      // ( select sum(price) from pay_history where txid = x.txid )
      //echo $sql;
		  if(isset($request['filter_store_name']) && !is_null($request['filter_store_name'])){
		  	$sql .= " AND LCASE(s.name) LIKE '%" . $this->db->escape(strtolower($request['filter_store_name'])) . "%'";
		  }
		  if(isset($request['filter_txid']) && !is_null($request['filter_txid'])){
		  	$sql .= " AND LCASE(x.txid) LIKE '%" . $this->db->escape(strtolower($request['filter_txid'])) . "%'";
		  }
		  if(isset($request['filter_bankaccount']) && !is_null($request['filter_bankaccount'])){
		  	$sql .= " AND LCASE(x.bankaccount) LIKE '%" . $this->db->escape(strtolower($request['filter_bankaccount'])) . "%'";
		  }
		  if(isset($request['filter_order_date_from']) && !is_null($request['filter_order_date_from'])){
		  	$sql .= " AND LCASE(x.order_date) between '" . $this->db->escape(strtolower($request['filter_order_date_from'])) . "' and '" . $this->db->escape(strtolower($request['filter_order_date_to'])) . "'";
		  }
		  if(isset($request['filter_order_price']) && !is_null($request['filter_order_price'])){
		  	$sql .= " AND LCASE(x.order_price) > " . $this->db->escape(strtolower($request['filter_order_price']));
		  }
		  if(isset($request['filter_ship']) && !is_null($request['filter_ship'])){
		  	$sql .= " AND LCASE(x.shipped_yn) = '" . $this->db->escape(strtolower($request['filter_ship'])) . "'";
		  }
		  if(isset($request['filter_order_user']) && !is_null($request['filter_order_user'])){
		  	$sql .= " AND LCASE(x.order_user) = '" . $this->db->escape(strtolower($request['filter_order_user'])) . "'";
		  }
		  if(isset($request['filter_payed']) && !is_null($request['filter_payed'])){
        if($request['filter_payed'] == 'yet'){
  	  		$sql .= " AND (x.order_price - x.payed_sum) > 0 ";
  	  		//$sql .= " and x.balance > 0";
	      }else{
	        // todo. some intelligent process need to check whole validation
	        $sql .= " AND (x.order_price - x.payed_sum) <= 0 ";
	        //$sql .= " and x.balance <= 0";
	      }
		  }
		  if(isset($request['filter_order_user']) && !is_null($request['filter_order_user'])){
		  	//$sql .= " AND x.order_user = ( select user_id from user where user_group_id = (select user_group_id from user_group where name = 'ar') and LCASE(username) LIKE '%" . $this->db->escape(strtolower($request['filter_order_user'])) . "%')";
        $sql .= " AND LCASE(u.username) = '" . $this->db->escape(strtolower($request['filter_order_user'])) . "'";
		  }
      
		  isset($request['sort']) ? $sql .= " ORDER BY " . $request['sort'] : $sql .= " ORDER BY x.balance";

		  if(isset($request['order']) && ($request['order'] == 'ASC')){
		  	$sql .= " ASC";
		  } else {
		  	$sql .= " DESC";
		  }

      $export_sql = $sql;
      //$this->log->aPrint( $export_sql ); exit;

		  if(isset($request['start']) || isset($request['limit'])){
		  	if ($request['start'] < 0){
		  		$request['start'] = 0;
		  	}
		  	if ($request['limit'] < 1){
		  		$request['limit'] = 20;
		  	}
		  	$sql .= " LIMIT " . (int)$request['start'] . "," . (int)$request['limit'];
		  }
		  //$this->log->aPrint( $sql );
		  $query = $this->db->query($sql);
		  return $query->rows;

    }else{

  	  $response = $this->cache->get('storelocator.' . $this->config->get('config_language_id'));
  	  if(!$response){
  	    // todo. need to change it later under choosen period
  	  	$query = $this->db->query("SELECT * FROM transaction");
  	  	$response = $query->rows;
  	  	$this->cache->set('storelocator.' . $this->config->get('config_language_id'), $response);
  	  }
  	  return $response;
    }
	}
	
	public function getTotalList($request=array()){
		if($request){
			$sql = "select count(*) as total
        from transaction x , storelocator s, user u, user_group ug 
       where x.store_id = s.id and x.order_user = u.username
         and u.user_group_id = ug.user_group_id
         and ug.user_group_id in (1,11) ";      
      // todo. this should be done by trigging , besso-201103 
      // ( select sum(price) from pay_history where txid = x.txid )
    
		  if(isset($request['filter_store_name']) && !is_null($request['filter_store_name'])){
		  	$sql .= " AND LCASE(s.name) LIKE '%" . $this->db->escape(strtolower($request['filter_store_name'])) . "%'";
		  }
		  if(isset($request['filter_txid']) && !is_null($request['filter_txid'])){
		  	$sql .= " AND LCASE(x.txid) LIKE '%" . $this->db->escape(strtolower($request['filter_txid'])) . "%'";
		  }
		  if(isset($request['filter_bankaccount']) && !is_null($request['filter_bankaccount'])){
		  	$sql .= " AND LCASE(x.bankaccount) LIKE '%" . $this->db->escape(strtolower($request['filter_bankaccount'])) . "%'";
		  }
		  if(isset($request['filter_order_date_from']) && !is_null($request['filter_order_date_from'])){
		  	$sql .= " AND LCASE(x.order_date) between '" . $this->db->escape(strtolower($request['filter_order_date_from'])) . "' and '" . $this->db->escape(strtolower($request['filter_order_date_to'])) . "'";
		  }
		  if(isset($request['filter_order_price']) && !is_null($request['filter_order_price'])){
		  	$sql .= " AND LCASE(x.order_price) > " . $this->db->escape(strtolower($request['filter_order_price']));
		  }
		  if(isset($request['filter_ship']) && !is_null($request['filter_ship'])){
		  	$sql .= " AND LCASE(x.shipped_yn) = '" . $this->db->escape(strtolower($request['filter_ship'])) . "'";
		  }
		  if(isset($request['filter_order_user']) && !is_null($request['filter_order_user'])){
		  	$sql .= " AND LCASE(x.order_user) = '" . $this->db->escape(strtolower($request['filter_order_user'])) . "'";
		  }
		  if(isset($request['filter_payed']) && !is_null($request['filter_payed'])){
        if($request['filter_payed'] == 'yet'){
  	  		$sql .= " AND (x.order_price - x.payed_sum) > 0 ";
	      }else{
	        // todo. some intelligent process need to check whole validation
	        $sql .= " AND (x.order_price - x.payed_sum) <= 0 ";
	      }
		  }
		  if(isset($request['filter_order_user']) && !is_null($request['filter_order_user'])){
		  	//$sql .= " AND x.order_user = ( select user_id from user where user_group_id = (select user_group_id from user_group where name = 'ar') and LCASE(username) LIKE '%" . $this->db->escape(strtolower($request['filter_order_user'])) . "%')";
        $sql .= " AND LCASE(u.username) = '" . $this->db->escape(strtolower($request['filter_order_user'])) . "'";
		  }
			$query = $this->db->query($sql);
			return $query->row['total'];
		}else{
			$query = $this->db->query("SELECT count(*) as total FROM transaction");
      return $query->row['total'];
		}
	}

  # Statistics
	public function getSumList($request = array()){
    // todo. weird one. exclude all default condition from data to cache for * query in mysql , , besso-201103 
    if($request){
      $sql = "select sum(x.order_price) as order_sum,
                     sum(x.payed_price) as paid_sum,
                     sum(x.balance) as balance_sum,
                     count(x.txid) as count
        from transaction x , storelocator s, user u, user_group ug 
       where x.store_id = s.id and x.order_user = u.username
         and u.user_group_id = ug.user_group_id
         and ug.user_group_id in (1,11) ";      
      // todo. this should be done by trigging , besso-201103 
      // ( select sum(price) from pay_history where txid = x.txid )
      //echo $sql;
		  if(isset($request['filter_store_name']) && !is_null($request['filter_store_name'])){
		  	$sql .= " AND LCASE(s.name) LIKE '%" . $this->db->escape(strtolower($request['filter_store_name'])) . "%'";
		  }
		  if(isset($request['filter_txid']) && !is_null($request['filter_txid'])){
		  	$sql .= " AND LCASE(x.txid) LIKE '%" . $this->db->escape(strtolower($request['filter_txid'])) . "%'";
		  }
		  if(isset($request['filter_bankaccount']) && !is_null($request['filter_bankaccount'])){
		  	$sql .= " AND LCASE(x.bankaccount) LIKE '%" . $this->db->escape(strtolower($request['filter_bankaccount'])) . "%'";
		  }
		  if(isset($request['filter_order_date_from']) && !is_null($request['filter_order_date_from'])){
		  	$sql .= " AND LCASE(x.order_date) between '" . $this->db->escape(strtolower($request['filter_order_date_from'])) . "' and '" . $this->db->escape(strtolower($request['filter_order_date_to'])) . "'";
		  }
		  if(isset($request['filter_order_price']) && !is_null($request['filter_order_price'])){
		  	$sql .= " AND LCASE(x.order_price) > " . $this->db->escape(strtolower($request['filter_order_price']));
		  }
		  if(isset($request['filter_ship']) && !is_null($request['filter_ship'])){
		  	$sql .= " AND LCASE(x.shipped_yn) = '" . $this->db->escape(strtolower($request['filter_ship'])) . "'";
		  }
		  if(isset($request['filter_order_user']) && !is_null($request['filter_order_user'])){
		  	$sql .= " AND LCASE(x.order_user) = '" . $this->db->escape(strtolower($request['filter_order_user'])) . "'";
		  }
		  if(isset($request['filter_payed']) && !is_null($request['filter_payed'])){
        if($request['filter_payed'] == 'yet'){
  	  		$sql .= " AND (x.order_price - x.payed_sum) > 0 ";
	      }else{
	        // todo. some intelligent process need to check whole validation
	        $sql .= " AND (x.order_price - x.payed_sum) <= 0 ";
	      }
		  }
		  if(isset($request['filter_order_user']) && !is_null($request['filter_order_user'])){
		  	//$sql .= " AND x.order_user = ( select user_id from user where user_group_id = (select user_group_id from user_group where name = 'ar') and LCASE(username) LIKE '%" . $this->db->escape(strtolower($request['filter_order_user'])) . "%')";
        $sql .= " AND LCASE(u.username) = '" . $this->db->escape(strtolower($request['filter_order_user'])) . "'";
		  }
      
		  isset($request['sort']) ? $sql .= " ORDER BY " . $request['sort'] : $sql .= " ORDER BY x.balance";

		  if(isset($request['order']) && ($request['order'] == 'ASC')){
		  	$sql .= " ASC";
		  } else {
		  	$sql .= " DESC";
		  }

		  if(isset($request['start']) || isset($request['limit'])){
		  	if ($request['start'] < 0){
		  		$request['start'] = 0;
		  	}
		  	if ($request['limit'] < 1){
		  		$request['limit'] = 20;
		  	}
		  	$sql .= " LIMIT " . (int)$request['start'] . "," . (int)$request['limit'];
		  }
		  //$this->log->aPrint( $sql );
		  $query = $this->db->query($sql);
		  return $query->rows;

    }else{

  	  $response = $this->cache->get('storelocator.' . $this->config->get('config_language_id'));
  	  if(!$response){
  	    // todo. need to change it later under choosen period
  	  	$query = $this->db->query("SELECT * FROM transaction");
  	  	$response = $query->rows;
  	  	$this->cache->set('storelocator.' . $this->config->get('config_language_id'), $response);
  	  }
  	  return $response;
    }
	}

  public function deleteTransaxtion($txid){
    $sql = "delete from transaction where txid = '$txid'";
    $query = $this->db->query($sql);

    $sql = "delete from ar where txid = '$txid'";
    $query = $this->db->query($sql);

    $sql = "delete from ship where txid = '$txid'";
    $query = $this->db->query($sql);

    $sql = "delete from pay where txid = '$txid'";
    $query = $this->db->query($sql);        
  }


}
?>