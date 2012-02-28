<?php
class ModelSalesList extends Model {
	public function getList($request = array()){
    // todo. weird one. exclude all default condition from data to cache for * query in mysql , , besso-201103 
    if($request){
      $sql = "select x.txid, u.username as order_user, s.id as store_id, s.name as store_name ,
              x.order_date,x.order_price,x.balance,x.approve_status,x.approved_user,
             if( (order_price - payed_sum) > 0 , 'yet' , 'done' ) as payed_yn,
             x.shipped_yn, x.term,x.status, x.executor, x.sign_yn
        from transaction x , storelocator s, user u, user_group ug 
       where x.store_id = s.id and x.order_user = u.username 
         and u.user_group_id = ug.user_group_id ";
      /***
      if(!$this->user->isSales()){
        $sql.= " and x.status != '0'";
      } 
      ***/
      // todo. this should be done by trigging , besso-201103 
      // ( select sum(price) from pay_history where txid = x.txid )
		  if(isset($request['filter_txid']) && !is_null($request['filter_txid'])){
		  	$sql .= " AND LCASE(x.txid) LIKE '%" . $this->db->escape(strtolower($request['filter_txid'])) . "%'";
		  }
		  if(isset($request['filter_store_name']) && !is_null($request['filter_store_name'])){
		  	$sql .= " AND LCASE(s.name) LIKE '%" . $this->db->escape(strtolower($request['filter_store_name'])) . "%'";
		  }
		  if(isset($request['filter_order_date']) && !is_null($request['filter_order_date'])){
		  	$sql .= " AND LCASE(x.order_date) = '" . $this->db->escape(strtolower($request['filter_order_date'])) . "'";
		  }
		  if(isset($request['filter_order_date_from']) && !is_null($request['filter_order_date_from'])){
		  	$sql .= " AND substr(x.order_date,1,10) between '" . $this->db->escape($request['filter_order_date_from']) . "' and '" . $this->db->escape($request['filter_order_date_to']) . "'";
		  }
		  if(isset($request['filter_ship']) && !is_null($request['filter_ship'])){
		  	$sql .= " AND LCASE(x.shipped_yn) = '" . $this->db->escape(strtolower($request['filter_ship'])) . "'";
		  }
		  /*** no need for paid or not yet
		  if(isset($request['filter_payed']) && !is_null($request['filter_payed'])){
        if($request['filter_payed'] == 'yet'){
  	  		$sql .= " AND (x.order_price - x.payed_sum) > 0 ";
	      }else{
	        // todo. some intelligent process need to check whole validation
	        $sql .= " AND (x.order_price - x.payed_sum) <= 0 ";
	      }
		  }
		  ***/
		  if(isset($request['filter_order_user']) && !is_null($request['filter_order_user'])){
		  	//$sql .= " AND x.order_user = ( select user_id from user where user_group_id = (select user_group_id from user_group where name = 'sales') and LCASE(username) LIKE '%" . $this->db->escape(strtolower($request['filter_order_user'])) . "%')";
        $sql .= " AND LCASE(u.username) = '" . $this->db->escape(strtolower($request['filter_order_user'])) . "'";
		  }
		  if( isset($request['filter_approve_status']) ){
		  	$approve_status = $request['filter_approve_status'];
		  	if( 'new' == $approve_status ){
		  	  $sql .= " AND LCASE(x.approve_status) is null";
		  	}elseif( 'all' == $approve_status ){
		  	  $sql .= " ";
		  	}else{
		  	  $sql .= " AND LCASE(x.approve_status) = '" . $this->db->escape(strtolower($request['filter_approve_status'])) . "'";
		  	}
		  }
		  if( isset($request['filter_status']) ){
		  	$status = $request['filter_status'];
	  	  $sql .= " AND x.status = $status";
		  }
		  if( isset($request['sort']) ){
		  	$sql .= " ORDER BY " . $request['sort'] . " DESC";
		  }else{
		  	$sql .= " ORDER BY x.order_date DESC";
		  }
		  /***
		  if(isset($request['order']) && ($request['order'] == 'ASC')){
		  	$sql .= " ASC";
		  }else{
		  	$sql .= " DESC";
		  }
		  ***/
		  //$this->log->aPrint( $request );
		  if(isset($request['limit']) || isset($request['limit'])){
		  	if($request['start'] < 0) $request['start'] = 0;
		  	if($request['limit'] < 1) $request['limit'] = 40;
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
         and u.user_group_id = ug.user_group_id ";      
      // todo. this should be done by trigging , besso-201103 
      // ( select sum(price) from pay_history where txid = x.txid )
      /**
      if(!$this->user->isSales()){
        $sql.= " and x.status != '0'";
      } 
      **/ 
		  if(isset($request['filter_txid']) && !is_null($request['filter_txid'])){
		  	$sql .= " AND LCASE(x.txid) LIKE '%" . $this->db->escape(strtolower($request['filter_txid'])) . "%'";
		  }
		  if(isset($request['filter_store_name']) && !is_null($request['filter_store_name'])){
		  	$sql .= " AND LCASE(s.name) LIKE '%" . $this->db->escape(strtolower($request['filter_store_name'])) . "%'";
		  }
		  if(isset($request['filter_order_date']) && !is_null($request['filter_order_date'])){
		  	$sql .= " AND LCASE(x.order_date) = '" . $this->db->escape(strtolower($request['filter_order_date'])) . "'";
		  }
		  if(isset($request['filter_order_date_from']) && !is_null($request['filter_order_date_from'])){
		  	$sql .= " AND substr(x.order_date,1,10) between '" . $this->db->escape($request['filter_order_date_from']) . "' and '" . $this->db->escape($request['filter_order_date_to']) . "'";
		  }
		  if(isset($request['filter_ship']) && !is_null($request['filter_ship'])){
		  	$sql .= " AND LCASE(x.shipped_yn) = '" . $this->db->escape(strtolower($request['filter_ship'])) . "'";
		  }
		  /***
		  if(isset($request['filter_payed']) && !is_null($request['filter_payed'])){
        if($request['filter_payed'] == 'yet'){
  	  		$sql .= " AND (x.order_price - x.payed_sum) > 0 ";
	      }else{
	        // todo. some intelligent process need to check whole validation
	        $sql .= " AND (x.order_price - x.payed_sum) <= 0 ";
	      }
		  }
		  ***/
		  if(isset($request['filter_order_user']) && !is_null($request['filter_order_user'])){
		  	//$sql .= " AND x.order_user = ( select user_id from user where user_group_id = (select user_group_id from user_group where name = 'sales') and LCASE(username) LIKE '%" . $this->db->escape(strtolower($request['filter_order_user'])) . "%')";
        $sql .= " AND LCASE(u.username) = '" . $this->db->escape(strtolower($request['filter_order_user'])) . "'";
		  }
		  if( isset($request['filter_approve_status']) ){
		  	$approve_status = $request['filter_approve_status'];
		  	if( 'new' == $approve_status ){
		  	  $sql .= " AND LCASE(x.approve_status) is null";
		  	}elseif( 'all' == $approve_status ){
		  	  $sql .= " ";
		  	}else{
		  	  $sql .= " AND LCASE(x.approve_status) = '" . $this->db->escape(strtolower($request['filter_approve_status'])) . "'";
		  	}
		  }
		  if( isset($request['filter_status']) ){
		  	$status = $request['filter_status'];
	  	  $sql .= " AND x.status = $status";
		  }
		  //$this->log->aPrint( $sql );
			$query = $this->db->query($sql);
			return $query->row['total'];
		}else{
			$query = $this->db->query("SELECT count(*) as total FROM transaction");
      return $query->row['total'];
		}
	}

  public function deleteTransaxtion($txid){
    $sql = "delete from transaction where txid = '$txid'";
    $query = $this->db->query($sql);
    $sql = "delete from sales where txid = '$txid'";
    $query = $this->db->query($sql);
    $sql = "delete from ship where txid = '$txid'";
    $query = $this->db->query($sql);
    $sql = "delete from pay where txid = '$txid'";
    $query = $this->db->query($sql);
  }

  // it's temporary for sales only system
  public function updateShippedYN($request){
  	$txid = $request['txid'];
  	$shipped_yn = $request['shipped_yn'];
  	$shipped_yn = strtoupper($shipped_yn);
    $sql = "update transaction set shipped_yn = '$shipped_yn' where txid = '$txid'";
    if($this->db->query($sql)){
      return true;
    }else{
      return false;
    }
  }

  public function updateSignYN($request){
  	$txid = $request['txid'];
  	$sign_yn = $request['sign_yn'];
  	$sign_yn = strtoupper($sign_yn);
    $sql = "update transaction set sign_yn = '$sign_yn' where txid = '$txid'";
    if($this->db->query($sql)){
      return true;
    }else{
      return false;
    }
  }

  public function updateNotice($request){
    //$this->log->aPrint( $request );
  	$notice = $request['notice'];
  	$user = $this->user->getUserName();
    $sql = "insert notice set notice = '$notice', date = now(), uploader = '$user'";
    if($this->db->query($sql)){
      return true;
    }else{
      return false;
    }
  }

  public function selectNotice(){
    //$this->log->aPrint( $request );
    $sql = "select * from notice order by id desc limit 1";
		$query = $this->db->query($sql);
  	return $query->rows;
  }
}
?>