<?php
class ModelArDetail extends Model{

  public function getHistoryData($txid){
		$res = array();
		if($txid){
			$sql = "SELECT * FROM pay where txid = '$txid'";
      $query = $this->db->query($sql);
			$rtn = $query->rows;
		}
		return $rtn;
	}

  public function getStoreID($accountno){
    $sql = "select id from storelocator where accountno like '%$accountno%'";
		$query = $this->db->query($sql);
		$response = $query->row;
    return $response['id'];
  }

  /* retrieve ar data from transaction 
   * todo. for check num , we need to join with pay , the pay history table
   */
  /*
  select txid,order_date,order_user,order_price,balance,payed_sum,
         datediff(date_format(curdate(),'%Y%m%d'),date_format(order_date,'%Y%m%d')) as order_diff 
         from transaction where store_id = '3780' order by order_date
   */
  public function getARdata($store_id){
    /*
    $sql = "select txid,order_date,order_user,order_price,balance,payed_sum,";
    $sql.= " datediff(date_format(curdate(),'%Y%m%d'),date_format(order_date,'%Y%m%d')) as order_diff, payment";
    $sql.= "  from transaction where store_id = '$store_id' order by order_date";
    */
    $sql = "select x.*,datediff(date_format(curdate(),'%Y%m%d'),date_format(order_date,'%Y%m%d')) as order_diff,p.pay_num,p.pay_method ";
    $sql.= "  from transaction x left join pay p on x.txid = p.txid and p.id = ( select max(id) from pay where txid = x.txid and pay_num != '' )";
    $sql.= " where x.store_id = '$store_id' order by x.txid";
    $query = $this->db->query($sql);
    //$this->log->aPrint( $sql );
    return $query->rows;
  }

  public function insertFinance($txid,$store_id,$memo){
    // generate txid with next index
    // inherit most information from txid
    $sql = "select max(txid) as txid from transaction where store_id = $store_id";
    $query = $this->db->query($sql);
    $txid = $query->row['txid'];
    $prefix = substr($txid,0,-1);
    // todo. it's better to lookup the max suffix from DB. or let's set as 9. poor
    //$suffix = substr($txid,-1,1);
    $suffix = '9';
    $newTxid = $prefix . $suffix;
    $order_price = $balance = 10;
    $payed_sum = 0;
    $order_date = date("Y-m-d");

    $sql = "insert into transaction (txid,store_id,description,order_user,approved_user,approved_date,saled_ym,new_store,term,other_cost,store_grade,order_price,payed_price,payed_sum,balance,shipped_yn,weight_sum,order_date,approve_status,invoice_no,bankaccount,executor,readonly,lift,cod,ship_method,ship_appointment,payment,backorder,shipped_by,shipped_date,billto,shipto)";
    $sql.= " select '$newTxid',store_id,'bounce',order_user,approved_user,approved_date,saled_ym,new_store,term,other_cost,store_grade,";
    $sql.= " $order_price,payed_price,$payed_sum,$balance,shipped_yn,weight_sum,'$order_date',approve_status,invoice_no,bankaccount,executor,";
    $sql.= " readonly,lift,cod,ship_method,ship_appointment,payment,backorder,shipped_by,shipped_date,billto,shipto from transaction where txid = '$txid'";
    $this->log->aPrint( $sql );
    if($this->db->query($sql)){}
    
    $tday = date('YmdH');
    $pay_method = 'bounce';
    $user = $this->user->getUsername();
    $sql = "insert into pay (txid,pay_method,pay_date,pay_num,pay_user,pay_price,store_id,bankaccount) values ";
    $sql.= "('$newTxid','$pay_method','$tday','$memo','$user',0,'$store_id','')";
    $this->log->aPrint( $sql );
    if($this->db->query($sql)){}

  }

  public function updateFinance($txid,$paid,$balance,$method,$pay_num,$bankaccount,$diff=0){
    if(!$balance) $balance = 0;

    // update process
    // UPDATE transaction SET payed_sum =?,balance=order_price-payed_sum WHERE txid=?
    $sql = "update transaction set order_price=order_price, ";
    $sql.= " payed_sum=payed_sum+$paid, balance=$balance, bankaccount='$bankaccount'";
    $sql.= " where txid = '$txid'";
    $this->log->aPrint( $sql );
    if($this->db->query($sql)){}
    
    $tday = date('YmdH');
    $user = $this->user->getUserName();
    $store_id = substr($txid,0,6);
    if($balance < 0) $paid = $paid - $balance;
    //echo $diff;
    if($diff != 0) $paid = $diff;
    // insert history
    // insert into pay (txid,pay_method,pay_date,pay_num,pay_user,pay_price,store_id) values (?,?,?,?,?,?,?)
    $sql = "insert into pay (txid,pay_method,pay_date,pay_num,pay_user,pay_price,store_id,bankaccount) values ";
    $sql.= "('$txid','$method','$tday','$pay_num','$user',$paid,'$store_id','$bankaccount')";
    $this->log->aPrint( $sql );
    if($this->db->query($sql)){}

  }
}
?>