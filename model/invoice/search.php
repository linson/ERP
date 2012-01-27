<?php
class ModelInvoiceSearch extends Model {
  /** deprecated
  public function shipConfirm($data){
    $aTxid = explode(',',$data['txidList']);
    foreach($aTxid as $txid){
      $sql = "update transaction set shipped_yn = 'Y'";
      $sql.= " where txid = '$txid'";
      $this->db->query($sql);
    }
  } 
  **/

  public function issueInvoiceNo($data){
    //$this->log->aPrint( $data ); exit;
    //$aTxid = explode(',',$data['txidList']);
    //$aDescription = explode(',',$data['description']);
    $txid = $data['txid'];
    $desc = $data['desc'];
    $desc = $this->db->escape($desc);
    $tdate = date('Y-m-d');
    $shipped_by = $this->user->getUsername();

    $sql = "select max(invoice_no)+1 as invoice_no from transaction";
    $qry = $this->db->query($sql);
    $invoice_no = $qry->row['invoice_no'];
    //$this->log->aPrint( $invoice_no ); exit;
    if(!$invoice_no) $invoice_no = 1000;

    $sql = "update transaction set invoice_no = $invoice_no , shipped_yn = 'Y',";
    $sql.= " shipped_by = '$shipped_by', shipped_date = '$tdate',";
    $sql.= " invoice_description = '$desc' ";
    $sql.= " where txid = '$txid'";
    //$this->log->aPrint( $sql );
    $this->db->query($sql);

    # product quantity be updated at this time !!!
    $sql = "select order_quantity,model from sales where txid = '$txid'";
    $qry = $this->db->query($sql);
    $aSales = $qry->rows;
    foreach($aSales as $row){
      $model = $row['model'];
      $quantity = $row['order_quantity'];
      $sql = "update product set quantity = quantity - $quantity where model = '$model'";
  	  //$this->log->aPrint( $sql );
  	  if($this->db->query($sql)){
  	    //return true;
  	  }else{
  	    //return false;
  	  }
  	}
  }

	public function getList($request = array()) {
    //$this->log->aPrint( $request );  exit;
    // todo. weird one. exclude all default condition from data to cache for * query in mysql , , besso-201103 
    if($request){
      $today = $this->util->date_format_kr(date('Ymdhis'));
      $sql = "select x.txid, u.username as order_user, s.name as store_name,x.store_id,x.approve_status,
              x.order_date,x.order_price,x.balance,x.invoice_no,
             if( (order_price - payed_sum) > 0 , 'yet' , 'done' ) as payed_yn,
             x.shipped_yn, x.term, x.status,x.shipped_date,x.approved_user,x.description
        from transaction x , storelocator s, user u, user_group ug 
       where x.store_id = s.id and x.order_user = u.username
         and x.approve_status = 'approve'
         and u.user_group_id = ug.user_group_id
         and x.ship_appointment <= '$today'";   // ship_appointment hold
         //and x.invoice_no is null";
      // and ug.user_group_id in (1,11) ";      
      // todo. this should be done by trigging , besso-201103 
      // ( select sum(price) from pay_history where txid = x.txid )
      //echo $sql;
      if(!$this->user->isSales()){
        $sql.= " and x.status != '0'";
      }
		  if(isset($request['filter_txid']) && !is_null($request['filter_txid'])) {
		  	$sql .= " AND LCASE(x.txid) LIKE '%" . $this->db->escape(strtolower($request['filter_txid'])) . "%'";
		  }
		  if(isset($request['filter_store_name']) && !is_null($request['filter_store_name'])) {
		  	$sql .= " AND LCASE(s.name) LIKE '%" . $this->db->escape(strtolower($request['filter_store_name'])) . "%'";
		  }
		  if(isset($request['filter_invoice_no']) && !is_null($request['filter_invoice_no'])) {
        $sql .= " AND LCASE(x.invoice_no) = '" . $this->db->escape(strtolower($request['filter_invoice_no'])) . "'";
		  }
		  if(isset($request['filter_ship_date_from']) && !is_null($request['filter_ship_date_from'])){
		  	$sql .= " AND LCASE(x.order_date) between '" . $this->db->escape(strtolower($request['filter_ship_date_from'])) . "' and '" . $this->db->escape(strtolower($request['filter_ship_date_to'])) . "'";
		  }
		  if(isset($request['filter_shipped_yn'])){
		  	$sql .= " AND LCASE(x.shipped_yn) = '" . $this->db->escape(strtolower($request['filter_shipped_yn'])) . "'";
		  }
		  if(isset($request['filter_order_user']) && !is_null($request['filter_order_user'])) {
        $sql .= " AND LCASE(u.username) = '" . $this->db->escape(strtolower($request['filter_order_user'])) . "'";
		  }
      
      $sort_data = array(
		  	'x.balance'
		  );
		  
		  if(isset($request['sort']) && in_array($request['sort'], $sort_data)) {
		  	$sql .= " ORDER BY " . $request['sort'];
		  } else {
		  	$sql .= " ORDER BY x.order_date";
		  }
		  if(isset($request['order']) && ($request['order'] == 'ASC')) {
		  	$sql .= " ASC";
		  } else {
		  	$sql .= " DESC";
		  }
		  if(isset($request['start']) || isset($request['limit'])) {
		  	if ($request['start'] < 0) {
		  		$request['start'] = 0;
		  	}
		  	if ($request['limit'] < 1) {
		  		$request['limit'] = 20;
		  	}
		  	$sql .= " LIMIT " . (int)$request['start'] . "," . (int)$request['limit'];
		  }
		  //$this->log->aPrint( $sql );
		  $query = $this->db->query($sql);
		  return $query->rows;
    
    }else{

  	  $response = $this->cache->get('storelocator.' . $this->config->get('config_language_id'));
  	  if(!$response) {
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
      if(!$this->user->isSales()){
        $sql.= " and x.status != '0'";
      }
		  if(isset($request['filter_txid']) && !is_null($request['filter_txid'])) {
		  	$sql .= " AND LCASE(x.txid) LIKE '%" . $this->db->escape(strtolower($request['filter_txid'])) . "%'";
		  }
		  if(isset($request['filter_store_name']) && !is_null($request['filter_store_name'])) {
		  	$sql .= " AND LCASE(s.name) LIKE '%" . $this->db->escape(strtolower($request['filter_store_name'])) . "%'";
		  }
		  if(isset($request['filter_invoice_no']) && !is_null($request['filter_invoice_no'])) {
        $sql .= " AND LCASE(x.invoice_no) = '" . $this->db->escape(strtolower($request['filter_invoice_no'])) . "'";
		  }
		  if(isset($request['filter_ship_date_from']) && !is_null($request['filter_ship_date_from'])){
		  	$sql .= " AND LCASE(x.order_date) between '" . $this->db->escape(strtolower($request['filter_ship_date_from'])) . "' and '" . $this->db->escape(strtolower($request['filter_ship_date_to'])) . "'";
		  }
		  if(isset($request['filter_shipped_yn'])){
		  	$sql .= " AND LCASE(x.shipped_yn) = '" . $this->db->escape(strtolower($request['filter_shipped_yn'])) . "'";
		  }
		  if(isset($request['filter_order_user']) && !is_null($request['filter_order_user'])) {
        $sql .= " AND LCASE(u.username) = '" . $this->db->escape(strtolower($request['filter_order_user'])) . "'";
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

    $sql = "delete from ar where txid = '$txid'";
    $query = $this->db->query($sql);

    $sql = "delete from ship where txid = '$txid'";
    $query = $this->db->query($sql);

    $sql = "delete from pay where txid = '$txid'";
    $query = $this->db->query($sql);        
  }


}
?>