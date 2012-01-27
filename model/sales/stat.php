<?php
class ModelSalesStat extends Model {
	public function getList($month) {
    $sql = "select * from rep_stat where month = '$month'";
    $query = $this->db->query($sql);
    return $query->rows;
	}
	
	public function getRep(){
	  $sql = "select username,user_group_id,firstname from user where user_group_id = 11";
	  //$this->log->aPrint( $sql );
    $query = $this->db->query($sql);
    return $query->rows;
	}

	public function getRepSum($rep,$month){
	  $sql = "select order_user,sum(order_price) as total,count(order_price) as count from transaction ";
	  $sql.= " where concat(substr(order_date,1,4),substr(order_date,6,2)) = '$month'";
	  $sql.= "   and order_user = '$rep' group by order_user";
    $query = $this->db->query($sql);
    return $query->row;
	}

  public function updatePackage($data){
    $month = $data['month'];
    $sql = "select count(*) as count from rep_stat where month = '$month'";
    $query = $this->db->query($sql);
    $count = $query->row['count'];
    if($count == 0) $data['ddl'] = 'insert';
    for($i=0; $i<count($data['rep']);$i++){
      if($data['target'][$i] > 0){
        
        if($data['ddl'] == 'insert'){
          $sql = "insert into rep_stat ( month,rep,target,up_date ) values ( ";
          $sql.= " '$month','". $data['rep'][$i] ."','". $data['target'][$i] ."','". date('Ymd') ."' )";
        }else{  // update
          $sql = "update rep_stat set target = " . $data['target'][$i];
          $sql.= " where id = " .$data['id'][$i];
        }
        $query = $this->db->query($sql);
      }
    }
    return true;
  }
}
?>