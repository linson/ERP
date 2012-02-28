<?php
class ModelProductPrice extends Model{

  public function getOneData($id){
		$res = array();
		if($id){
			$sql = "SELECT * FROM product p , product_description pd where p.product_id = pd.product_id and p.product_id = $id ";
      $query = $this->db->query($sql);
			$rtn = $query->row;
		}
		return $rtn;
	}

  public function updatePrice($data){
    $this->log->aPrint( $data );
    $ws_price = $data['ws_price'];
    $rt_price = $data['rt_price'];
    $product_id = $data['product_id'];
    $sql = "update product set ws_price = $ws_price,";
    $sql.= "  rt_price = $rt_price where product_id = $product_id";
    $query = $this->db->query($sql);
  }

	public function updateProduct($data){
	  //$this->log->aPrint( $data ); exit;
	  $sql = "UPDATE product ";
	  $sql.= " SET model = '" . $this->db->escape($data['model']) . "',";
	  $sql.= "     sku   = '" . $this->db->escape($data['sku']) . "',";
	  $sql.= "     image = '" . $this->db->escape($data['image']) . "',";
	  $sql.= "     status = '" . $this->db->escape($data['status']) . "',";
	  $sql.= "     quantity = '" . $this->db->escape($data['quantity']) . "',";
	  $sql.= "     ws_price = '" . $this->db->escape($data['ws_price']) . "',";
	  $sql.= "     rt_price = '" . $this->db->escape($data['rt_price']) . "',";
    $sql.= "     thres = '" . $this->db->escape($data['thres']) . "',";
	  $sql.= "     pc = '" . $this->db->escape($data['pc']) . "',";
	  $sql.= "     ups_weight = '" . $this->db->escape($data['ups_weight']) . "',";
	  $sql.= "     dc = '" . $this->db->escape($data['dc']) . "',";
	  $sql.= "     dc2 = '" . $this->db->escape($data['dc2']) . "'";
	  $sql.= " where product_id = '" . $this->db->escape($data['product_id']) . "'";
    if($this->db->query($sql)){}

	  $sql = "UPDATE product_description ";
	  $sql.= " SET name = '" . $this->db->escape($data['name']) . "',";
	  $sql.= "     name_for_sales = '" . $this->db->escape($data['name_for_sales']) . "'";
	  $sql.= " where product_id = '" . $this->db->escape($data['product_id']) . "'";
	  //$this->log->aPrint( $sql );
    if($this->db->query($sql)){}
    
    return true;
	}	
	
  /* update store , besso-201103 */
	public function insertProduct($data){
	  //$this->log->aPrint( $data ); exit;
    $model = $this->db->escape($data['model']);
    $sku = $this->db->escape($data['sku']);
    $quantity = $this->db->escape($data['quantity']);
    $image = 'data/package/African-Essence-Non-Flaking-Styling-Gel-Clear-Super.jpg';
    $ws_price = $this->db->escape($data['ws_price']);
    $rt_price = $this->db->escape($data['rt_price']);
    $pc = $this->db->escape($data['pc']);
    $ups_weight = $this->db->escape($data['ups_weight']);
    $thres = $this->db->escape($data['thres']);
    $dc = $this->db->escape($data['dc']);
    $dc2 = $this->db->escape($data['dc2']);
    $name_for_sales = $this->db->escape($data['name_for_sales']);
    $status = $this->db->escape($data['status']);
    
	  $sql = "insert into product (model,sku,quantity,image,ws_price,rt_price,     pc,ups_weight,thres,dc,dc2,status)";
	  $sql.= " values ('$model','$sku','$quantity','$image','$ws_price','$rt_price','$pc','$ups_weight','$thres','$dc','$dc2','$status')";
    //$this->log->aPrint( $sql ); exit;
    $this->db->query($sql);
    
    $sql = "select product_id from product where model = '$model'";
    $query = $this->db->query($sql);
  	$product_id = $query->row['product_id'];

  	$sql = "insert into product_description (product_id,language_id,name,name_for_sales) values ($product_id,1,'$name_for_sales','$name_for_sales')";
    $this->db->query($sql);
    
    return true;
	}	
	
	public function addProduct($data){
		$this->db->query("INSERT INTO " . DB_PREFIX . "product SET model = '" . $this->db->escape($data['model']) . "', sku = '" . $this->db->escape($data['sku']) . "', location = '" . $this->db->escape($data['location']) . "', quantity = '" . (int)$data['quantity'] . "', minimum = '" . (int)$data['minimum'] . "', subtract = '" . (int)$data['subtract'] . "', stock_status_id = '" . (int)$data['stock_status_id'] . "', date_available = '" . $this->db->escape($data['date_available']) . "', manufacturer_id = '" . (int)$data['manufacturer_id'] . "', shipping = '" . (int)$data['shipping'] . "', price = '" . (float)$data['price'] . "', cost = '" . (float)$data['cost'] . "', weight = '" . (float)$data['weight'] . "', weight_class_id = '" . (int)$data['weight_class_id'] . "', length = '" . (float)$data['length'] . "', width = '" . (float)$data['width'] . "', height = '" . (float)$data['height'] . "', length_class_id = '" . (int)$data['length_class_id'] . "', status = '" . (int)$data['status'] . "', tax_class_id = '" . (int)$data['tax_class_id'] . "', sort_order = '" . (int)$data['sort_order'] . "', date_added = NOW()");
		$product_id = $this->db->getLastId();
		if(isset($data['image'])){
			$this->db->query("UPDATE " . DB_PREFIX . "product SET image = '" . $this->db->escape($data['image']) . "' WHERE product_id = '" . (int)$product_id . "'");
		}
		foreach ($data['product_description'] as $language_id => $value){
			$this->db->query("INSERT INTO " . DB_PREFIX . "product_description SET product_id = '" . (int)$product_id . "', language_id = '" . (int)$language_id . "', name = '" . $this->db->escape($value['name']) . "', meta_keywords = '" . $this->db->escape($value['meta_keywords']) . "', meta_description = '" . $this->db->escape($value['meta_description']) . "', description = '" . $this->db->escape($value['description']) . "'");
		}
		if(isset($data['product_store'])){
			foreach ($data['product_store'] as $store_id){
				$this->db->query("INSERT INTO " . DB_PREFIX . "product_to_store SET product_id = '" . (int)$product_id . "', store_id = '" . (int)$store_id . "'");
			}
		}
		if(isset($data['product_option'])){
			foreach ($data['product_option'] as $product_option){
				$this->db->query("INSERT INTO " . DB_PREFIX . "product_option SET product_id = '" . (int)$product_id . "', sort_order = '" . (int)$product_option['sort_order'] . "'");
				$product_option_id = $this->db->getLastId();
				foreach ($product_option['language'] as $language_id => $language){
					$this->db->query("INSERT INTO " . DB_PREFIX . "product_option_description SET product_option_id = '" . (int)$product_option_id . "', language_id = '" . (int)$language_id . "', product_id = '" . (int)$product_id . "', name = '" . $this->db->escape($language['name']) . "'");
				}
				if(isset($product_option['product_option_value'])){
					foreach ($product_option['product_option_value'] as $product_option_value){
						$this->db->query("INSERT INTO " . DB_PREFIX . "product_option_value SET product_option_id = '" . (int)$product_option_id . "', product_id = '" . (int)$product_id . "', quantity = '" . (int)$product_option_value['quantity'] . "', subtract = '" . (int)$product_option_value['subtract'] . "', price = '" . (float)$product_option_value['price'] . "', prefix = '" . $this->db->escape($product_option_value['prefix']) . "', sort_order = '" . (int)$product_option_value['sort_order'] . "'");
						$product_option_value_id = $this->db->getLastId();
						foreach ($product_option_value['language'] as $language_id => $language){
							$this->db->query("INSERT INTO " . DB_PREFIX . "product_option_value_description SET product_option_value_id = '" . (int)$product_option_value_id . "', language_id = '" . (int)$language_id . "', product_id = '" . (int)$product_id . "', name = '" . $this->db->escape($language['name']) . "'");
						}
					}
				}
			}
		}
		if(isset($data['product_discount'])){
			foreach ($data['product_discount'] as $value){
				$this->db->query("INSERT INTO " . DB_PREFIX . "product_discount SET product_id = '" . (int)$product_id . "', customer_group_id = '" . (int)$value['customer_group_id'] . "', quantity = '" . (int)$value['quantity'] . "', priority = '" . (int)$value['priority'] . "', price = '" . (float)$value['price'] . "', date_start = '" . $this->db->escape($value['date_start']) . "', date_end = '" . $this->db->escape($value['date_end']) . "'");
			}
		}
		if(isset($data['product_special'])){
			foreach ($data['product_special'] as $value){
				$this->db->query("INSERT INTO " . DB_PREFIX . "product_special SET product_id = '" . (int)$product_id . "', customer_group_id = '" . (int)$value['customer_group_id'] . "', priority = '" . (int)$value['priority'] . "', price = '" . (float)$value['price'] . "', date_start = '" . $this->db->escape($value['date_start']) . "', date_end = '" . $this->db->escape($value['date_end']) . "'");
			}
		}
		if(isset($data['product_image'])){
			foreach ($data['product_image'] as $image){
        		$this->db->query("INSERT INTO " . DB_PREFIX . "product_image SET product_id = '" . (int)$product_id . "', image = '" . $this->db->escape($image) . "'");
			}
		}
		if(isset($data['product_download'])){
			foreach ($data['product_download'] as $download_id){
				$this->db->query("INSERT INTO " . DB_PREFIX . "product_to_download SET product_id = '" . (int)$product_id . "', download_id = '" . (int)$download_id . "'");
			}
		}
		if(isset($data['product_category'])){
			foreach ($data['product_category'] as $category_id){
				$this->db->query("INSERT INTO " . DB_PREFIX . "product_to_category SET product_id = '" . (int)$product_id . "', category_id = '" . (int)$category_id . "'");
			}
		}
		if(isset($data['product_related'])){
			foreach ($data['product_related'] as $related_id){
				$this->db->query("INSERT INTO " . DB_PREFIX . "product_related SET product_id = '" . (int)$product_id . "', related_id = '" . (int)$related_id . "'");
				$this->db->query("INSERT INTO " . DB_PREFIX . "product_related SET product_id = '" . (int)$related_id . "', related_id = '" . (int)$product_id . "'");
			}
		}
		if($data['keyword']){
			$this->db->query("INSERT INTO " . DB_PREFIX . "url_alias SET query = 'product_id=" . (int)$product_id . "', keyword = '" . $this->db->escape($data['keyword']) . "'");
		}
		foreach ($data['product_tags'] as $language_id => $value){
			$tags = explode(',', $value);
			foreach ($tags as $tag){
				$this->db->query("INSERT INTO " . DB_PREFIX . "product_tags SET product_id = '" . (int)$product_id . "', language_id = '" . (int)$language_id . "', tag = '" . $this->db->escape(trim($tag)) . "'");
			}
		}
		$this->cache->delete('product');
	}

  /* update product , besso-201103 */
	public function update($product_id,$key,$val){
	  $sql = "UPDATE " . DB_PREFIX . "product ";
	  $sql.= " SET " . $key . " = " . $this->db->escape($val) . "";
	  $sql.= " where product_id = '" . $this->db->escape($product_id) . "'";
	  //print $sql;
    $this->db->query($sql);
	}

  /* we need to lessen package according to how pieces in one boxes
   */
	public function updatePackage($req){
    /***
    +----+------+--------+----------+----------------+--------------+-----+-----------------------------+------+
    | id | code | price  | quantity | up_date        | comment      | rep | company                     | diff |
    +----+------+--------+----------+----------------+--------------+-----+-----------------------------+------+
    |  1 | 1770 | 0.1131 |    12556 | 20110912063037 | manufactured | YK  |                             |    0 |
    |  2 | 1771 | 0.0000 |    13206 | 20110912063037 | manufactured | YK  |                             |    0 |
    |  3 | 9050 | 0.5478 |     4388 | 20110912063037 | manufactured | YK  | """""""BATAVIA CONTAINER""" |    0 |
    |  4 | 9060 | 0.1282 |     9803 | 20110912063037 | manufactured | YK  | """""""BATAVIA CONTAINER""" |    0 |
    +----+------+--------+----------+----------------+--------------+-----+-----------------------------+------+
    392
    // pid = 161
    1770 :: 12556 :: 5 LB GEL JAR (PROTEIN) -> 2352 => 10204
    1771 :: 13206 :: 5 LB GEL CAP (GOLD)  ->2352 => 10854
    9050 :: 4388 :: 5LB STYLING GEL (BOX) -> 392 => 3996
    9060 :: 9803 :: 5LB STYLING GEL (DIV) -> 392 => 9411
    update product set quantity = 0 where product_id = 161;
    ***/
    /***
    [route] => product/price/updatePackage
    [token] => d72ba23d861121c594c124f51f8ec918
    [plus] => 1
    [product_id] => 222
    ***/
    //$this->log->aPrint( $req ); exit;
    $product_id = $req['product_id'];
    $plus = $req['plus'];
	  $sql = "select pc from product where product_id = $product_id";
	  $query = $this->db->query($sql);
	  $pc = $query->row['pc'];

	  $sql = "select * from package p, product_package pp where p.code = pp.pkg and pp.pid = $product_id";
	  $query = $this->db->query($sql);
	  $basePackages = $query->rows;

	  foreach($basePackages as $base){
	    $change = ''; // set it's abnormally overrided
	    $code = $base['code'];
	    //todo. check the status
	    $status = $base['status'];
	    $cat = $base['cat'];
	    
	    // todo. it's quite manual one , besso 201108
	    if($cat == 'BOX' || $cat == 'DIV' || $cat == 'PAD' || $cat == 'DISPLAY' ){
	      $change = $plus;
	    }else{
	      $change = $pc * $plus;
	    }

	    # insert history
      $rep = $this->user->getUserName();
      $tdate = date('Ymdhis');
      // todo. historical package table
	    $sql = "insert into package_history ";
	    $sql.= " SET code  = ( select code from package where code = '$code' and status = '$status'),";
	    $sql.= "     price = ( select price from package where code = '$code' and status = '$status'),";
	    $sql.= "     quantity = ( select quantity - $change from package where code = '$code' and status = '$status'),";
	    $sql.= "     diff =  - $change ,";
      $sql.= "     up_date = '" . $tdate . "',";
	    $sql.= "     comment = 'manufactured',";
	    $sql.= "     rep = '" . $rep . "',";
	    //$sql.= "     company = ( select company from package where code = '$code' and status = '$status')";
	    $sql.= "     company = 'UBP',";
	    $sql.= "     final = $product_id";
	    $this->db->query($sql);

	    $sql = "update package set quantity = quantity - $change where code = '$code' and status = '$status'";
	    $this->db->query($sql);
	  }
	  
	  # follow! follow server procedual, not ajax
	  $sql = "UPDATE " . DB_PREFIX . "product ";
	  $sql.= " SET quantity = quantity + " . $this->db->escape($plus) . "";
	  $sql.= " where product_id = '" . $this->db->escape($product_id) . "'";
    $this->db->query($sql);
	}

	public function editProduct($product_id, $data){
		$this->db->query("UPDATE " . DB_PREFIX . "product SET model = '" . $this->db->escape($data['model']) . "', sku = '" . $this->db->escape($data['sku']) . "', location = '" . $this->db->escape($data['location']) . "', quantity = '" . (int)$data['quantity'] . "', minimum = '" . (int)$data['minimum'] . "', subtract = '" . (int)$data['subtract'] . "', stock_status_id = '" . (int)$data['stock_status_id'] . "', date_available = '" . $this->db->escape($data['date_available']) . "', manufacturer_id = '" . (int)$data['manufacturer_id'] . "', shipping = '" . (int)$data['shipping'] . "', price = '" . (float)$data['price'] . "', cost = '" . (float)$data['cost'] . "', weight = '" . (float)$data['weight'] . "', weight_class_id = '" . (int)$data['weight_class_id'] . "', length = '" . (float)$data['length'] . "', width = '" . (float)$data['width'] . "', height = '" . (float)$data['height'] . "', length_class_id = '" . (int)$data['length_class_id'] . "', status = '" . (int)$data['status'] . "', tax_class_id = '" . (int)$data['tax_class_id'] . "', sort_order = '" . (int)$data['sort_order'] . "', date_modified = NOW() WHERE product_id = '" . (int)$product_id . "'");
		if(isset($data['image'])){
			$this->db->query("UPDATE " . DB_PREFIX . "product SET image = '" . $this->db->escape($data['image']) . "' WHERE product_id = '" . (int)$product_id . "'");
		}
		$this->db->query("DELETE FROM " . DB_PREFIX . "product_description WHERE product_id = '" . (int)$product_id . "'");
		foreach ($data['product_description'] as $language_id => $value){
			$this->db->query("INSERT INTO " . DB_PREFIX . "product_description SET product_id = '" . (int)$product_id . "', language_id = '" . (int)$language_id . "', name = '" . $this->db->escape($value['name']) . "', meta_keywords = '" . $this->db->escape($value['meta_keywords']) . "', meta_description = '" . $this->db->escape($value['meta_description']) . "', description = '" . $this->db->escape($value['description']) . "'");
		}
		$this->db->query("DELETE FROM " . DB_PREFIX . "product_to_store WHERE product_id = '" . (int)$product_id . "'");
		if(isset($data['product_store'])){
			foreach ($data['product_store'] as $store_id){
				$this->db->query("INSERT INTO " . DB_PREFIX . "product_to_store SET product_id = '" . (int)$product_id . "', store_id = '" . (int)$store_id . "'");
			}
		}
		$this->db->query("DELETE FROM " . DB_PREFIX . "product_option WHERE product_id = '" . (int)$product_id . "'");
		$this->db->query("DELETE FROM " . DB_PREFIX . "product_option_description WHERE product_id = '" . (int)$product_id . "'");
		$this->db->query("DELETE FROM " . DB_PREFIX . "product_option_value WHERE product_id = '" . (int)$product_id . "'");
		$this->db->query("DELETE FROM " . DB_PREFIX . "product_option_value_description WHERE product_id = '" . (int)$product_id . "'");
		if(isset($data['product_option'])){
			foreach ($data['product_option'] as $product_option){
				$this->db->query("INSERT INTO " . DB_PREFIX . "product_option SET product_id = '" . (int)$product_id . "', sort_order = '" . (int)$product_option['sort_order'] . "'");
				$product_option_id = $this->db->getLastId();
				foreach ($product_option['language'] as $language_id => $language){
					$this->db->query("INSERT INTO " . DB_PREFIX . "product_option_description SET product_option_id = '" . (int)$product_option_id . "', language_id = '" . (int)$language_id . "', product_id = '" . (int)$product_id . "', name = '" . $this->db->escape($language['name']) . "'");
				}
				if(isset($product_option['product_option_value'])){
					foreach ($product_option['product_option_value'] as $product_option_value){
						$this->db->query("INSERT INTO " . DB_PREFIX . "product_option_value SET product_option_id = '" . (int)$product_option_id . "', product_id = '" . (int)$product_id . "', quantity = '" . (int)$product_option_value['quantity'] . "', subtract = '" . (int)$product_option_value['subtract'] . "', price = '" . (float)$product_option_value['price'] . "', prefix = '" . $this->db->escape($product_option_value['prefix']) . "', sort_order = '" . (int)$product_option_value['sort_order'] . "'");
						$product_option_value_id = $this->db->getLastId();
						foreach ($product_option_value['language'] as $language_id => $language){
							$this->db->query("INSERT INTO " . DB_PREFIX . "product_option_value_description SET product_option_value_id = '" . (int)$product_option_value_id . "', language_id = '" . (int)$language_id . "', product_id = '" . (int)$product_id . "', name = '" . $this->db->escape($language['name']) . "'");
						}
					}
				}
			}
		}
		$this->db->query("DELETE FROM " . DB_PREFIX . "product_discount WHERE product_id = '" . (int)$product_id . "'");
		if(isset($data['product_discount'])){
			foreach ($data['product_discount'] as $value){
				$this->db->query("INSERT INTO " . DB_PREFIX . "product_discount SET product_id = '" . (int)$product_id . "', customer_group_id = '" . (int)$value['customer_group_id'] . "', quantity = '" . (int)$value['quantity'] . "', priority = '" . (int)$value['priority'] . "', price = '" . (float)$value['price'] . "', date_start = '" . $this->db->escape($value['date_start']) . "', date_end = '" . $this->db->escape($value['date_end']) . "'");
			}
		}
		$this->db->query("DELETE FROM " . DB_PREFIX . "product_special WHERE product_id = '" . (int)$product_id . "'");
		if(isset($data['product_special'])){
			foreach ($data['product_special'] as $value){
				$this->db->query("INSERT INTO " . DB_PREFIX . "product_special SET product_id = '" . (int)$product_id . "', customer_group_id = '" . (int)$value['customer_group_id'] . "', priority = '" . (int)$value['priority'] . "', price = '" . (float)$value['price'] . "', date_start = '" . $this->db->escape($value['date_start']) . "', date_end = '" . $this->db->escape($value['date_end']) . "'");
			}
		}
		$this->db->query("DELETE FROM " . DB_PREFIX . "product_image WHERE product_id = '" . (int)$product_id . "'");
		if(isset($data['product_image'])){
			foreach ($data['product_image'] as $image){
        		$this->db->query("INSERT INTO " . DB_PREFIX . "product_image SET product_id = '" . (int)$product_id . "', image = '" . $this->db->escape($image) . "'");
			}
		}
		$this->db->query("DELETE FROM " . DB_PREFIX . "product_to_download WHERE product_id = '" . (int)$product_id . "'");
		if(isset($data['product_download'])){
			foreach ($data['product_download'] as $download_id){
				$this->db->query("INSERT INTO " . DB_PREFIX . "product_to_download SET product_id = '" . (int)$product_id . "', download_id = '" . (int)$download_id . "'");
			}
		}
		$this->db->query("DELETE FROM " . DB_PREFIX . "product_to_category WHERE product_id = '" . (int)$product_id . "'");
		if(isset($data['product_category'])){
			foreach ($data['product_category'] as $category_id){
				$this->db->query("INSERT INTO " . DB_PREFIX . "product_to_category SET product_id = '" . (int)$product_id . "', category_id = '" . (int)$category_id . "'");
			}
		}
		$this->db->query("DELETE FROM " . DB_PREFIX . "product_related WHERE product_id = '" . (int)$product_id . "'");
		if(isset($data['product_related'])){
			foreach ($data['product_related'] as $related_id){
				$this->db->query("INSERT INTO " . DB_PREFIX . "product_related SET product_id = '" . (int)$product_id . "', related_id = '" . (int)$related_id . "'");
				$this->db->query("DELETE FROM " . DB_PREFIX . "product_related WHERE product_id = '" . (int)$related_id . "' AND related_id = '" . (int)$product_id . "'");
				$this->db->query("INSERT INTO " . DB_PREFIX . "product_related SET product_id = '" . (int)$related_id . "', related_id = '" . (int)$product_id . "'");
			}
		}
		$this->db->query("DELETE FROM " . DB_PREFIX . "url_alias WHERE query = 'product_id=" . (int)$product_id. "'");
		if($data['keyword']){
			$this->db->query("INSERT INTO " . DB_PREFIX . "url_alias SET query = 'product_id=" . (int)$product_id . "', keyword = '" . $this->db->escape($data['keyword']) . "'");
		}
		$this->db->query("DELETE FROM " . DB_PREFIX . "product_tags WHERE product_id = '" . (int)$product_id. "'");
		foreach ($data['product_tags'] as $language_id => $value){
			$tags = explode(',', $value);
			foreach ($tags as $tag){
				$this->db->query("INSERT INTO " . DB_PREFIX . "product_tags SET product_id = '" . (int)$product_id . "', language_id = '" . (int)$language_id . "', tag = '" . $this->db->escape(trim($tag)) . "'");
			}
		}
		$this->cache->delete('product');
	}

	public function copyProduct($product_id){
		$query = $this->db->query("SELECT DISTINCT * FROM " . DB_PREFIX . "product p LEFT JOIN " . DB_PREFIX . "product_description pd ON (p.product_id = pd.product_id) WHERE p.product_id = '" . (int)$product_id . "' AND pd.language_id = '" . (int)$this->config->get('config_language_id') . "'");
		if($query->num_rows){
			$data = array();
			$data = $query->row;
			$data = array_merge($data, array('product_description' => $this->getProductDescriptions($product_id)));
			$data = array_merge($data, array('product_option' => $this->getProductOptions($product_id)));
			$data['keyword'] = '';
			$data['status'] = '1';
      foreach(array_keys($data['product_description']) as $key){
          $data['product_description'][$key]['name'] = $data['product_description'][$key]['name'] . '*';
      }
			$data['product_image'] = array();
			$results = $this->getProductImages($product_id);
			foreach ($results as $result){
				$data['product_image'][] = $result['image'];
			}
			$data = array_merge($data, array('product_discount' => $this->getProductDiscounts($product_id)));
			$data = array_merge($data, array('product_special' => $this->getProductSpecials($product_id)));
			$data = array_merge($data, array('product_download' => $this->getProductDownloads($product_id)));
			$data = array_merge($data, array('product_category' => $this->getProductCategories($product_id)));
			$data = array_merge($data, array('product_store' => $this->getProductStores($product_id)));
			$data = array_merge($data, array('product_related' => $this->getProductRelated($product_id)));
			$data = array_merge($data, array('product_tags' => $this->getProductTags($product_id)));
			$this->addProduct($data);
		}
	}

	public function deleteProduct($product_id){
		$this->db->query("DELETE FROM " . DB_PREFIX . "product WHERE product_id = '" . (int)$product_id . "'");
		$this->db->query("DELETE FROM " . DB_PREFIX . "product_description WHERE product_id = '" . (int)$product_id . "'");
		$this->db->query("DELETE FROM " . DB_PREFIX . "product_option WHERE product_id = '" . (int)$product_id . "'");
		$this->db->query("DELETE FROM " . DB_PREFIX . "product_option_description WHERE product_id = '" . (int)$product_id . "'");
		$this->db->query("DELETE FROM " . DB_PREFIX . "product_option_value WHERE product_id = '" . (int)$product_id . "'");
		$this->db->query("DELETE FROM " . DB_PREFIX . "product_option_value_description WHERE product_id = '" . (int)$product_id . "'");
		$this->db->query("DELETE FROM " . DB_PREFIX . "product_discount WHERE product_id = '" . (int)$product_id . "'");
		$this->db->query("DELETE FROM " . DB_PREFIX . "product_image WHERE product_id = '" . (int)$product_id . "'");
		$this->db->query("DELETE FROM " . DB_PREFIX . "product_related WHERE product_id = '" . (int)$product_id . "'");
		$this->db->query("DELETE FROM " . DB_PREFIX . "product_to_download WHERE product_id = '" . (int)$product_id . "'");
		$this->db->query("DELETE FROM " . DB_PREFIX . "product_to_category WHERE product_id = '" . (int)$product_id . "'");
		$this->db->query("DELETE FROM " . DB_PREFIX . "review WHERE product_id = '" . (int)$product_id . "'");
		$this->db->query("DELETE FROM " . DB_PREFIX . "product_to_store WHERE product_id = '" . (int)$product_id . "'");
		$this->db->query("DELETE FROM " . DB_PREFIX . "url_alias WHERE query = 'product_id=" . (int)$product_id. "'");
		$this->db->query("DELETE FROM " . DB_PREFIX . "product_tags WHERE product_id='" . (int)$product_id. "'");
		$this->cache->delete('product');
	}

	public function getProduct($product_id){
		$query = $this->db->query("SELECT DISTINCT *, (SELECT keyword FROM " . DB_PREFIX . "url_alias WHERE query = 'product_id=" . (int)$product_id . "') AS keyword FROM " . DB_PREFIX . "product p LEFT JOIN " . DB_PREFIX . "product_description pd ON (p.product_id = pd.product_id) WHERE p.product_id = '" . (int)$product_id . "' AND pd.language_id = '" . (int)$this->config->get('config_language_id') . "'");
		return $query->row;
	}

	public function getTotalProducts($data = array()){
		$sql = "SELECT COUNT(*) AS total FROM " . DB_PREFIX . "product p LEFT JOIN " . DB_PREFIX . "product_description pd ON (p.product_id = pd.product_id) WHERE pd.language_id = '" . (int)$this->config->get('config_language_id') . "'";
  	if(isset($data['filter_name']) && !is_null($data['filter_name'])){
  		$sql .= " AND LCASE(pd.name) LIKE '%" . $this->db->escape(strtolower($data['filter_name'])) . "%'";
  	}
  	if(isset($data['filter_model']) && !is_null($data['filter_model'])){
  		//$sql .= " AND Substr(LCASE(p.model),3,4) between '" . $this->db->escape(strtolower($data['filter_model'])) . "' and '" . $this->db->escape(strtolower($data['filter_model_to'])). "'";
  		$sql .= " AND Substr(LCASE(p.model),3,4) like '%" . $this->db->escape(strtolower($data['filter_model'])) . "%'";
  	}
		if( isset($data['filter_oem']) && 'y' == $data['filter_oem']  ){
			$sql .= " AND Substr(UCASE(p.model),1,2) not in ('SP','VN','AE','3S','IR','QT')";
		}else if( isset($data['filter_oem']) && 'n' == $data['filter_oem']  ){
      $sql .= " AND Substr(UCASE(p.model),1,2) in ('SP','VN','AE','3S','IR','QT')";
		}
  	if(isset($data['filter_price']) && !is_null($data['filter_price'])){
  		$sql .= " AND LCASE(p.price) LIKE '" . $this->db->escape(strtolower($data['filter_price'])) . "%'";
  	}
		if(isset($data['filter_quantity']) && !is_null($data['filter_quantity'])){
			$sql .= " AND p.quantity <= '" . $this->db->escape($data['filter_quantity']) . "'";
		}
		if(isset($data['filter_thres']) && !is_null($data['filter_thres'])){
			$sql .= " AND p.thres <= '" . $this->db->escape($data['filter_thres']) . "'";
		}
		if( isset($data['filter_cat']) && '' != $data['filter_cat'] ){
		  if( 'oem' == strtolower($data['filter_cat']) ){
		    $sql .= " AND Substr(LCASE(p.model),1,2) not in ('sp','ae','vn','3s','ir','qt')";
		  }else{
  			$sql .= " AND Substr(LCASE(p.model),1,2) = '" . $this->db->escape(strtolower($data['filter_cat'])) . "'";
  		}
		}
		$query = $this->db->query($sql);
		return $query->row['total'];
	}

	public function getProducts($data = array(),&$export_qry){
	  $out_column = 'p.product_id,p.image,pd.name as name, p.model,p.ws_price,p.rt_price,p.quantity,p.pc,p.status,p.thres';
		if($data){
			$sql = "SELECT " . $out_column . " FROM " . DB_PREFIX . "product p LEFT JOIN " . DB_PREFIX . "product_description pd ON (p.product_id = pd.product_id) ";
			// status is only for mall , besso-201103 
			//$sql .= " WHERE p.status = '1' and pd.language_id = '" . (int)$this->config->get('config_language_id') . "'";
			$sql .= " WHERE pd.language_id = '" . (int)$this->config->get('config_language_id') . "'";
			if(isset($data['filter_name']) && !is_null($data['filter_name'])){
				$sql .= " AND LCASE(pd.name) LIKE '%" . $this->db->escape(strtolower($data['filter_name'])) . "%'";
			}
			if(isset($data['filter_model']) && !is_null($data['filter_model'])){
				//$sql .= " AND Substr(LCASE(p.model),3,4) between '" . $this->db->escape(strtolower($data['filter_model'])) . "' and '" . $this->db->escape(strtolower($data['filter_model_to'])). "'";
				//$sql .= " AND Substr(LCASE(p.model),3,4) like '%" . $this->db->escape(strtolower($data['filter_model'])) . "%'";
				$sql .= " AND LCASE(p.model) like '%" . $this->db->escape(strtolower($data['filter_model'])) . "%'";
			}
			if(isset($data['filter_pid']) && !is_null($data['filter_pid'])){
				$sql .= " AND p.product_id =  " . $this->db->escape($data['filter_pid']) . " ";
			}
			if( isset($data['filter_oem']) && 'y' == $data['filter_oem']  ){
				$sql .= " AND Substr(UCASE(p.model),1,2) not in ('SP','VN','AE','3S','IR','QT')";
			}else if( isset($data['filter_oem']) && 'n' == $data['filter_oem']  ){
        $sql .= " AND Substr(UCASE(p.model),1,2) in ('SP','VN','AE','3S','IR','QT')";
			}
			if(isset($data['filter_price']) && !is_null($data['filter_price'])){
				$sql .= " AND LCASE(p.price) LIKE '" . $this->db->escape(strtolower($data['filter_price'])) . "%'";
			}
			if(isset($data['filter_quantity']) && !is_null($data['filter_quantity'])){
				$sql .= " AND p.quantity <= '" . $this->db->escape($data['filter_quantity']) . "'";
			}
			if(isset($data['filter_thres']) && !is_null($data['filter_thres'])){
				$sql .= " AND p.thres <= '" . $this->db->escape($data['filter_thres']) . "'";
			}
			if( isset($data['filter_cat']) && '' != $data['filter_cat'] ){
			  if( 'oem' == strtolower($data['filter_cat']) ){
			    $sql .= " AND Substr(LCASE(p.model),1,2) not in ('sp','ae','vn','3s','ir','qt')";
			  }else{
  				$sql .= " AND Substr(LCASE(p.model),1,2) = '" . $this->db->escape(strtolower($data['filter_cat'])) . "'";
  			}
			}
			$sort_data = array(
				#'pd.name',
				'p.model',
				'p.price',
				'p.quantity',
				'p.status',
				'p.sort_order'
			);
			if(isset($data['sort']) && in_array($data['sort'], $sort_data)){
				$sql .= " ORDER BY " . $data['sort'];
			}else{
				$sql .= " ORDER BY substr(p.model,3,4)";
			}
			if(isset($data['order']) && ($data['order'] == 'DESC')){
				$sql .= " DESC";
			}else{
				$sql .= " ASC";
			}
      $product_data = array();
      $export_qry = $sql;
			if(isset($data['start']) || isset($data['limit'])){
				if($data['start'] < 0){
					$data['start'] = 0;
				}
				if($data['limit'] < 1){
					$data['limit'] = 20;
				}
				$sql .= " LIMIT " . (int)$data['start'] . "," . (int)$data['limit'];
			}
			//$this->log->aPrint( $sql );
			$query = $this->db->query($sql);
      $product_data=$query->rows;
			return $product_data;
		}else{
			$product_data = $this->cache->get('product.' . $this->config->get('config_language_id'));
			if(!$product_data){
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

	public function addFeatured($data){
    $this->db->query("DELETE FROM " . DB_PREFIX . "product_featured");
		if(isset($data['product_featured'])){
    	foreach ($data['product_featured'] as $product_id){
    		$this->db->query("INSERT INTO " . DB_PREFIX . "product_featured SET product_id = '" . (int)$product_id . "'");
    	}
		}
	}

	public function getFeaturedProducts(){
		$product_featured_data = array();
		$query = $this->db->query("SELECT product_id FROM " . DB_PREFIX . "product_featured");
		foreach ($query->rows as $result){
			$product_featured_data[] = $result['product_id'];
		}
		return $product_featured_data;
	}

	public function getProductsByKeyword($keyword){
		if($keyword){
			$query = $this->db->query("SELECT * FROM " . DB_PREFIX . "product p LEFT JOIN " . DB_PREFIX . "product_description pd ON (p.product_id = pd.product_id) WHERE pd.language_id = '" . (int)$this->config->get('config_language_id') . "' AND (LCASE(pd.name) LIKE '%" . $this->db->escape(strtolower($keyword)) . "%' OR LCASE(p.model) LIKE '%" . $this->db->escape(strtolower($keyword)) . "%')");
			return $query->rows;
		}else{
			return array();
		}
	}

	public function getProductsByCategoryId($category_id){
		$query = $this->db->query("SELECT * FROM " . DB_PREFIX . "product p LEFT JOIN " . DB_PREFIX . "product_description pd ON (p.product_id = pd.product_id) LEFT JOIN " . DB_PREFIX . "product_to_category p2c ON (p.product_id = p2c.product_id) WHERE pd.language_id = '" . (int)$this->config->get('config_language_id') . "' AND p2c.category_id = '" . (int)$category_id . "' ORDER BY pd.name ASC");
		return $query->rows;
	}

	public function getProductDescriptions($product_id){
		$product_description_data = array();
		$query = $this->db->query("SELECT * FROM " . DB_PREFIX . "product_description WHERE product_id = '" . (int)$product_id . "'");
		foreach ($query->rows as $result){
			$product_description_data[$result['language_id']] = array(
				'name'             => $result['name'],
				'meta_keywords'    => $result['meta_keywords'],
				'meta_description' => $result['meta_description'],
				'description'      => $result['description']
			);
		}
		return $product_description_data;
	}

	public function getProductOptions($product_id){
		$product_option_data = array();
		$product_option = $this->db->query("SELECT * FROM " . DB_PREFIX . "product_option WHERE product_id = '" . (int)$product_id . "' ORDER BY sort_order");
		foreach ($product_option->rows as $product_option){
			$product_option_value_data = array();
			$product_option_value = $this->db->query("SELECT * FROM " . DB_PREFIX . "product_option_value WHERE product_option_id = '" . (int)$product_option['product_option_id'] . "' ORDER BY sort_order");
			foreach ($product_option_value->rows as $product_option_value){
				$product_option_value_description_data = array();
				$product_option_value_description = $this->db->query("SELECT * FROM " . DB_PREFIX . "product_option_value_description WHERE product_option_value_id = '" . (int)$product_option_value['product_option_value_id'] . "'");
				foreach ($product_option_value_description->rows as $result){
					$product_option_value_description_data[$result['language_id']] = array('name' => $result['name']);
				}
				$product_option_value_data[] = array(
					'product_option_value_id' => $product_option_value['product_option_value_id'],
					'language'                => $product_option_value_description_data,
         	'quantity'                => $product_option_value['quantity'],
					'subtract'                => $product_option_value['subtract'],
					'price'                   => $product_option_value['price'],
         	'prefix'                  => $product_option_value['prefix'],
					'sort_order'              => $product_option_value['sort_order']
				);
			}
			$product_option_description_data = array();
			$product_option_description = $this->db->query("SELECT * FROM " . DB_PREFIX . "product_option_description WHERE product_option_id = '" . (int)$product_option['product_option_id'] . "'");
			foreach ($product_option_description->rows as $result){
				$product_option_description_data[$result['language_id']] = array('name' => $result['name']);
			}
      $product_option_data[] = array(
      	'product_option_id'    => $product_option['product_option_id'],
			  'language'             => $product_option_description_data,
			  'product_option_value' => $product_option_value_data,
			  'sort_order'           => $product_option['sort_order']
      );
    }
		return $product_option_data;
	}

	public function getProductImages($product_id){
		$query = $this->db->query("SELECT * FROM " . DB_PREFIX . "product_image WHERE product_id = '" . (int)$product_id . "'");
		return $query->rows;
	}

	public function getProductDiscounts($product_id){
		$query = $this->db->query("SELECT * FROM " . DB_PREFIX . "product_discount WHERE product_id = '" . (int)$product_id . "' ORDER BY quantity, priority, price");
		return $query->rows;
	}

	public function getProductSpecials($product_id){
		$query = $this->db->query("SELECT * FROM " . DB_PREFIX . "product_special WHERE product_id = '" . (int)$product_id . "' ORDER BY priority, price");
		return $query->rows;
	}

	public function getProductDownloads($product_id){
		$product_download_data = array();
		$query = $this->db->query("SELECT * FROM " . DB_PREFIX . "product_to_download WHERE product_id = '" . (int)$product_id . "'");
		foreach ($query->rows as $result){
			$product_download_data[] = $result['download_id'];
		}
		return $product_download_data;
	}

	public function getProductStores($product_id){
		$product_store_data = array();
		$query = $this->db->query("SELECT * FROM " . DB_PREFIX . "product_to_store WHERE product_id = '" . (int)$product_id . "'");
		foreach ($query->rows as $result){
			$product_store_data[] = $result['store_id'];
		}
		return $product_store_data;
	}

	public function getProductCategories($product_id){
		$product_category_data = array();
		$query = $this->db->query("SELECT * FROM " . DB_PREFIX . "product_to_category WHERE product_id = '" . (int)$product_id . "'");
		foreach ($query->rows as $result){
			$product_category_data[] = $result['category_id'];
		}
		return $product_category_data;
	}

	public function getProductRelated($product_id){
		$product_related_data = array();
		$query = $this->db->query("SELECT * FROM " . DB_PREFIX . "product_related WHERE product_id = '" . (int)$product_id . "'");
		foreach ($query->rows as $result){
			$product_related_data[] = $result['related_id'];
		}
		return $product_related_data;
	}

	public function getProductTags($product_id){
		$product_tag_data = array();
		$query = $this->db->query("SELECT * FROM " . DB_PREFIX . "product_tags WHERE product_id = '" . (int)$product_id . "'");
		$tag_data = array();
		foreach ($query->rows as $result){
			$tag_data[$result['language_id']][] = $result['tag'];
		}
		foreach ($tag_data as $language => $tags){
			$product_tag_data[$language] = implode(',', $tags);
		}
		return $product_tag_data;
	}

	public function getTotalProductsByStockStatusId($stock_status_id){
    $query = $this->db->query("SELECT COUNT(*) AS total FROM " . DB_PREFIX . "product WHERE stock_status_id = '" . (int)$stock_status_id . "'");
		return $query->row['total'];
	}

	public function getTotalProductsByImageId($image_id){
    $query = $this->db->query("SELECT COUNT(*) AS total FROM " . DB_PREFIX . "product WHERE image_id = '" . (int)$image_id . "'");
		return $query->row['total'];
	}

	public function getTotalProductsByTaxClassId($tax_class_id){
    $query = $this->db->query("SELECT COUNT(*) AS total FROM " . DB_PREFIX . "product WHERE tax_class_id = '" . (int)$tax_class_id . "'");
		return $query->row['total'];
	}

	public function getTotalProductsByWeightClassId($weight_class_id){
    $query = $this->db->query("SELECT COUNT(*) AS total FROM " . DB_PREFIX . "product WHERE weight_class_id = '" . (int)$weight_class_id . "'");
		return $query->row['total'];
	}

	public function getTotalProductsByLengthClassId($length_class_id){
    $query = $this->db->query("SELECT COUNT(*) AS total FROM " . DB_PREFIX . "product WHERE length_class_id = '" . (int)$length_class_id . "'");
		return $query->row['total'];
	}

	public function getTotalProductsByOptionId($option_id){
    $query = $this->db->query("SELECT COUNT(*) AS total FROM " . DB_PREFIX . "product_to_option WHERE option_id = '" . (int)$option_id . "'");
		return $query->row['total'];
	}

	public function getTotalProductsByDownloadId($download_id){
    $query = $this->db->query("SELECT COUNT(*) AS total FROM " . DB_PREFIX . "product_to_download WHERE download_id = '" . (int)$download_id . "'");
		return $query->row['total'];
	}

	public function getTotalProductsByManufacturerId($manufacturer_id){
    $query = $this->db->query("SELECT COUNT(*) AS total FROM " . DB_PREFIX . "product WHERE manufacturer_id = '" . (int)$manufacturer_id . "'");
		return $query->row['total'];
	}

	public function getProductModel($product_id){
    $query = $this->db->query("SELECT model FROM product WHERE product_id = $product_id");
		return $query->row['model'];
	}
	
	// for simple update quantity
	public function updateQuantity($req){
    $id = $req['id'];
    $quantity = $req['quantity'];
    $sql = "update product set quantity = $quantity where product_id = $id";
    //$this->log->aPrint( $sql );
    if($this->db->query($sql)){ return true; }else{ return false; }
	}
}
?>