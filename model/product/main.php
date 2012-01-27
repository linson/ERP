<?php
class ModelProductMain extends Model {
  public function getQuantity($model){
    $sql = "select p.product_id as pid,p.model,pd.name_for_sales as name,p.quantity from product p, product_description pd ";
    $sql.= " where p.product_id = pd.product_id and p.model like '%$model%'";
    $query = $this->db->query($sql);
    return $query->rows;
  }

	public function update($data){
	  //$this->log->aPrint( $data );
    $outFile = $_SERVER["DOCUMENT_ROOT"]."/backyard/data/mainProduct";
	  //$this->log->aPrint( $data ); exit;
	  $model = implode(',',$data);
	  if(file_put_contents($outFile,$model)){
	    return true;
	  }else{
	    return false;
	  }
	}

	public function updateThres($data){
	  $thres = $data['thres'];
	  $product_id = $data['product_id'];
    $sql = "update product set thres = $thres where product_id = $product_id";
    //$this->log->aPrint( $sql);
    //echo $sql; exit;
	  if($query=$this->db->query($sql)){
	    return true;
	  }else{
	    return false;
	  }
	}

	public function getProduct($product_id) {
		$query = $this->db->query("SELECT DISTINCT *, (SELECT keyword FROM " . DB_PREFIX . "url_alias WHERE query = 'product_id=" . (int)$product_id . "') AS keyword FROM " . DB_PREFIX . "product p LEFT JOIN " . DB_PREFIX . "product_description pd ON (p.product_id = pd.product_id) WHERE p.product_id = '" . (int)$product_id . "' AND pd.language_id = '" . (int)$this->config->get('config_language_id') . "'");
		return $query->row;
	}

  public function getUnderThres(){
    $sql = "select p.model,pd.name_for_sales as name,p.quantity,p.thres from product p, product_description pd ";
    $sql.= " where p.product_id = pd.product_id and p.quantity < p.thres";
    //echo $sql; exit;
    $query = $this->db->query($sql);
    return $query->rows;
  }

	public function getTotalProducts($data = array()) {
	  $aCat = $this->config->ubpCategory();
	  //$this->log->aPrint( $cat );
		$sql = "SELECT COUNT(*) AS total FROM " . DB_PREFIX . "product p LEFT JOIN " . DB_PREFIX . "product_description pd ON (p.product_id = pd.product_id) WHERE pd.language_id = '" . (int)$this->config->get('config_language_id') . "'";
		if (isset($data['filter_name']) && !is_null($data['filter_name'])) {
			$sql .= " AND LCASE(pd.name) LIKE '%" . $this->db->escape(strtolower($data['filter_name'])) . "%'";
		}
		foreach($aCat as $k => $v){
		  $sql .= " and substr(p.model,1,2) != '$k'";
		}
		if (isset($data['filter_price']) && !is_null($data['filter_price'])) {
			$sql .= " AND LCASE(p.price) LIKE '" . $this->db->escape(strtolower($data['filter_price'])) . "%'";
		}
		if (isset($data['filter_quantity']) && !is_null($data['filter_quantity'])) {
			$sql .= " AND p.quantity = '" . $this->db->escape($data['filter_quantity']) . "'";
		}
//print($sql);
		if (isset($data['filter_status']) && !is_null($data['filter_status'])) {
			$sql .= " AND p.status = '" . (int)$data['filter_status'] . "'";
		}
		$query = $this->db->query($sql);
		return $query->row['total'];
	}

  // todo. adhoc for OEM
	public function getMainProducts($data = array(),&$export_qry){
    $outFile = $_SERVER["DOCUMENT_ROOT"]."/backyard/data/mainProduct";
    $model = file_get_contents($outFile);
    $aModel = explode(',',$model);
    foreach($aModel as $k => $v){
      $aModel[$k] = "'" . trim($v) . "'";
    }
    asort($aModel);
    $cond_model = implode(',',$aModel);

	  $aCat = $this->config->ubpCategory();
	  //$this->log->aPrint( $cat );

	  $out_column = 'p.product_id,p.image,pd.name_for_sales as name,p.model,p.ws_price,p.rt_price,p.quantity,p.pc,p.status,p.thres';
		if ($data) {
			$sql = "SELECT " . $out_column . " FROM " . DB_PREFIX . "product p LEFT JOIN " . DB_PREFIX . "product_description pd ON (p.product_id = pd.product_id) ";
			// status is only for mall , besso-201103 
			//$sql .= " WHERE p.status = '1' and pd.language_id = '" . (int)$this->config->get('config_language_id') . "'";
			$sql .= " WHERE pd.language_id = '" . (int)$this->config->get('config_language_id') . "'";
			if (isset($data['filter_name']) && !is_null($data['filter_name'])) {
				$sql .= " AND LCASE(pd.name) LIKE '%" . $this->db->escape(strtolower($data['filter_name'])) . "%'";
			}
			/**
			if (isset($data['filter_model_from']) && !is_null($data['filter_model_from'])) {
				$sql .= " AND Substr(LCASE(p.model),3,4) between '" . $this->db->escape(strtolower($data['filter_model_from'])) . "' and '" . $this->db->escape(strtolower($data['filter_model_to'])). "'";
			}
			**/
			if($model){
			  $sql .= " and p.model in ($cond_model)";
			}
			if (isset($data['filter_price']) && !is_null($data['filter_price'])) {
				$sql .= " AND LCASE(p.price) LIKE '" . $this->db->escape(strtolower($data['filter_price'])) . "%'";
			}
			if (isset($data['filter_quantity']) && !is_null($data['filter_quantity'])) {
				$sql .= " AND p.quantity = '" . $this->db->escape($data['filter_quantity']) . "'";
			}
			$sort_data = array(
				#'pd.name',
				'p.model',
				'p.price',
				'p.quantity',
				'p.status',
				'p.sort_order'
			);
			if (isset($data['sort']) && in_array($data['sort'], $sort_data)) {
				$sql .= " ORDER BY " . $data['sort'];
			} else {
				$sql .= " ORDER BY p.model";
			}
			if (isset($data['order']) && ($data['order'] == 'DESC')) {
				$sql .= " DESC";
			} else {
				$sql .= " ASC";
			}

      //$this->log->aPrint( $sql );
      $product_data = array();
      $export_qry = $sql;
      /*
			if (isset($data['start']) || isset($data['limit'])) {
				if ($data['start'] < 0) {
					$data['start'] = 0;
				}
				if ($data['limit'] < 1) {
					$data['limit'] = 20;
				}
				$sql .= " LIMIT " . (int)$data['start'] . "," . (int)$data['limit'];
			}
			*/

      //print $export_qry;
			$query = $this->db->query($sql);
      $product_data=$query->rows;
      /**
      echo "<pre>";
      print_r($product_data);
      echo "</pre>";
      ***/
			return $product_data;

		} else {
			$product_data = $this->cache->get('product.' . $this->config->get('config_language_id'));

			if (!$product_data) {
				$query = $this->db->query("SELECT " . $out_column . " FROM " . DB_PREFIX . "product p LEFT JOIN " . DB_PREFIX . "product_description pd ON (p.product_id = pd.product_id) WHERE pd.language_id = '" . (int)$this->config->get('config_language_id') . "' ORDER BY p.model ASC");
        $export_qry = $query;
      $product_data = array();
      $product_data['export_qry'] = $sql;

				$product_data .= $query->rows;

				$this->cache->set('product.' . $this->config->get('config_language_id'), $product_data);
			}

			return $product_data;
		}
	}



	public function getTotalProductsByStockStatusId($stock_status_id) {
      	$query = $this->db->query("SELECT COUNT(*) AS total FROM " . DB_PREFIX . "product WHERE stock_status_id = '" . (int)$stock_status_id . "'");

		return $query->row['total'];
	}

	public function getTotalProductsByImageId($image_id) {
      	$query = $this->db->query("SELECT COUNT(*) AS total FROM " . DB_PREFIX . "product WHERE image_id = '" . (int)$image_id . "'");

		return $query->row['total'];
	}

	public function getTotalProductsByTaxClassId($tax_class_id) {
      	$query = $this->db->query("SELECT COUNT(*) AS total FROM " . DB_PREFIX . "product WHERE tax_class_id = '" . (int)$tax_class_id . "'");

		return $query->row['total'];
	}

	public function getTotalProductsByWeightClassId($weight_class_id) {
      	$query = $this->db->query("SELECT COUNT(*) AS total FROM " . DB_PREFIX . "product WHERE weight_class_id = '" . (int)$weight_class_id . "'");

		return $query->row['total'];
	}

	public function getTotalProductsByLengthClassId($length_class_id) {
      	$query = $this->db->query("SELECT COUNT(*) AS total FROM " . DB_PREFIX . "product WHERE length_class_id = '" . (int)$length_class_id . "'");

		return $query->row['total'];
	}

	public function getTotalProductsByOptionId($option_id) {
      	$query = $this->db->query("SELECT COUNT(*) AS total FROM " . DB_PREFIX . "product_to_option WHERE option_id = '" . (int)$option_id . "'");

		return $query->row['total'];
	}

	public function getTotalProductsByDownloadId($download_id) {
      	$query = $this->db->query("SELECT COUNT(*) AS total FROM " . DB_PREFIX . "product_to_download WHERE download_id = '" . (int)$download_id . "'");

		return $query->row['total'];
	}

	public function getTotalProductsByManufacturerId($manufacturer_id) {
      	$query = $this->db->query("SELECT COUNT(*) AS total FROM " . DB_PREFIX . "product WHERE manufacturer_id = '" . (int)$manufacturer_id . "'");

		return $query->row['total'];
	}
}
?>