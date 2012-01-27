<?php
class ModelMaterialProductPackage extends Model {
	
  /* update product , besso-201103 */
	public function update($product_id,$key,$val){
	  $sql = "UPDATE " . DB_PREFIX . "product ";
	  $sql.= " SET " . $key . " = " . $this->db->escape($val) . "";
	  $sql.= " where product_id = '" . $this->db->escape($product_id) . "'";
	  print $sql;
    $this->db->query($sql);
 		$this->cache->delete('product');
	}

	public function getProductPackage($product_id){
	  //$sql = "select * from package p, product_package pp where p.code = pp.pkg and pp.pid = $product_id and p.status = '1'";
	  $sql = "select * from package p, product_package pp where p.code = pp.pkg and pp.pid = $product_id";
	  //echo $sql;
		$query = $this->db->query("$sql");
		return $query->rows;
	}

	public function storePackage($product_id,$pkgid){
	  # delete the pid
	  $sql = "delete from product_package where pid = $product_id";
		$this->db->query("$sql");
	  
	  # insert product_package
	  $aPkg = explode(',',$pkgid);
	  //$this->log->aPrint( $aPkg );
	  foreach($aPkg as $pkg){
	    if($pkg){
	      $sql = "insert into product_package (pid,pkg,cnt) values (";
	      $sql.= " $product_id,'$pkg',1 ";
	      $sql.= ")";
	      //echo $sql;
		    $this->db->query("$sql");
      }
		}
		return "ok";
	}
}

?>