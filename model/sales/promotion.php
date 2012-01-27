<?php
class ModelSalesPromotion extends Model{

  public function delete($id){
    $sql = "delete from promotion where id = $id";
    if($this->db->query($sql)){
      return true;
    }else{
      return false;
    }
  }

  public function insert($data){
    //$this->log->aPrint( $data ); exit;

    $updator = $this->user->getUsername();
		$aId  = ( isset($data['id']) ) ? $data['id'] : array();
		$aCnt = ( isset($data['cnt']) ) ? $data['cnt'] : array();
		$aJson = array();
		if(count($aId) > 0){
		  foreach($aId as $i => $id){
		    $aJson[$id] = $aCnt[$i];
		  }
		}
		
		$json = json_encode($aJson);
		
    $sql = "insert into promotion set ";
    $sql.= "  name   = '" . $data['name'] . "',";
    $sql.= "  price   = " . $data['price'] . ",";
    $sql.= "  storetype = '" . $data['target'] . "',";
    $sql.= "  start_date = '" . $data['promotion_from'] . "',";
    $sql.= "  end_date = '" . $data['promotion_to'] . "',";
    $sql.= "  models  = '" . $json . "',";
    $sql.= "  updator = '" . $updator . "',";
    $sql.= "  update_date = now()";
    
    //echo $sql; exit;
    
    if( $this->db->query($sql) ){
      return true;
    }else{
      return false;
    }
  }
  
	public function getList($data = array()){
		if($data){
			$sql = "SELECT * FROM promotion pr";
			$sql.= " order by pr.update_date";
			$query = $this->db->query($sql);
      $product_data=$query->rows;
			return $product_data;
		}
	}

	public function getTotalList($data = array()){
		if($data){
			$sql = "SELECT count(*) FROM promotion pr";
			$sql.= " order by pr.update_date";
			$query = $this->db->query($sql);
      $product_data=$query->rows;
			return $product_data;
		}
	}
}
?>