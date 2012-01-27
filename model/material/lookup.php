<?php
class ModelMaterialLookup extends Model{
	public function addPackage($data){
		$this->db->query("INSERT INTO package SET cat = '" . $this->db->escape($data['cat']) . "', sku = '" . $this->db->escape($data['sku']) . "', location = '" . $this->db->escape($data['location']) . "', quantity = '" . (int)$data['quantity'] . "', minimum = '" . (int)$data['minimum'] . "', subtract = '" . (int)$data['subtract'] . "', stock_status_id = '" . (int)$data['stock_status_id'] . "', date_available = '" . $this->db->escape($data['date_available']) . "', manufacturer_id = '" . (int)$data['manufacturer_id'] . "', shipping = '" . (int)$data['shipping'] . "', price = '" . (float)$data['price'] . "', cost = '" . (float)$data['cost'] . "', weight = '" . (float)$data['weight'] . "', weight_class_id = '" . (int)$data['weight_class_id'] . "', length = '" . (float)$data['length'] . "', width = '" . (float)$data['width'] . "', height = '" . (float)$data['height'] . "', length_class_id = '" . (int)$data['length_class_id'] . "', status = '" . (int)$data['status'] . "', tax_class_id = '" . (int)$data['tax_class_id'] . "', sort_order = '" . (int)$data['sort_order'] . "', date_added = NOW()");
		$package_id = $this->db->getLastId();
		if(isset($data['image'])){
			$this->db->query("UPDATE package SET image = '" . $this->db->escape($data['image']) . "' WHERE package_id = '" . (int)$package_id . "'");
		}
		foreach ($data['package_description'] as $language_id => $value){
			$this->db->query("INSERT INTO package_description SET package_id = '" . (int)$package_id . "', language_id = '" . (int)$language_id . "', name = '" . $this->db->escape($value['name']) . "', meta_keywords = '" . $this->db->escape($value['meta_keywords']) . "', meta_description = '" . $this->db->escape($value['meta_description']) . "', description = '" . $this->db->escape($value['description']) . "'");
		}
		if(isset($data['package_store'])){
			foreach ($data['package_store'] as $store_id){
				$this->db->query("INSERT INTO package_to_store SET package_id = '" . (int)$package_id . "', store_id = '" . (int)$store_id . "'");
			}
		}
		if(isset($data['package_option'])){
			foreach ($data['package_option'] as $package_option){
				$this->db->query("INSERT INTO package_option SET package_id = '" . (int)$package_id . "', sort_order = '" . (int)$package_option['sort_order'] . "'");
				$package_option_id = $this->db->getLastId();
				foreach ($package_option['language'] as $language_id => $language){
					$this->db->query("INSERT INTO package_option_description SET package_option_id = '" . (int)$package_option_id . "', language_id = '" . (int)$language_id . "', package_id = '" . (int)$package_id . "', name = '" . $this->db->escape($language['name']) . "'");
				}
				if(isset($package_option['package_option_value'])){
					foreach ($package_option['package_option_value'] as $package_option_value){
						$this->db->query("INSERT INTO package_option_value SET package_option_id = '" . (int)$package_option_id . "', package_id = '" . (int)$package_id . "', quantity = '" . (int)$package_option_value['quantity'] . "', subtract = '" . (int)$package_option_value['subtract'] . "', price = '" . (float)$package_option_value['price'] . "', prefix = '" . $this->db->escape($package_option_value['prefix']) . "', sort_order = '" . (int)$package_option_value['sort_order'] . "'");
						$package_option_value_id = $this->db->getLastId();
						foreach ($package_option_value['language'] as $language_id => $language){
							$this->db->query("INSERT INTO package_option_value_description SET package_option_value_id = '" . (int)$package_option_value_id . "', language_id = '" . (int)$language_id . "', package_id = '" . (int)$package_id . "', name = '" . $this->db->escape($language['name']) . "'");
						}
					}
				}
			}
		}
		if(isset($data['package_discount'])){
			foreach ($data['package_discount'] as $value){
				$this->db->query("INSERT INTO package_discount SET package_id = '" . (int)$package_id . "', customer_group_id = '" . (int)$value['customer_group_id'] . "', quantity = '" . (int)$value['quantity'] . "', priority = '" . (int)$value['priority'] . "', price = '" . (float)$value['price'] . "', date_start = '" . $this->db->escape($value['date_start']) . "', date_end = '" . $this->db->escape($value['date_end']) . "'");
			}
		}
		if(isset($data['package_special'])){
			foreach ($data['package_special'] as $value){
				$this->db->query("INSERT INTO package_special SET package_id = '" . (int)$package_id . "', customer_group_id = '" . (int)$value['customer_group_id'] . "', priority = '" . (int)$value['priority'] . "', price = '" . (float)$value['price'] . "', date_start = '" . $this->db->escape($value['date_start']) . "', date_end = '" . $this->db->escape($value['date_end']) . "'");
			}
		}
		if(isset($data['package_image'])){
			foreach ($data['package_image'] as $image){
        		$this->db->query("INSERT INTO package_image SET package_id = '" . (int)$package_id . "', image = '" . $this->db->escape($image) . "'");
			}
		}
		if(isset($data['package_download'])){
			foreach ($data['package_download'] as $download_id){
				$this->db->query("INSERT INTO package_to_download SET package_id = '" . (int)$package_id . "', download_id = '" . (int)$download_id . "'");
			}
		}
		if(isset($data['package_category'])){
			foreach ($data['package_category'] as $category_id){
				$this->db->query("INSERT INTO package_to_category SET package_id = '" . (int)$package_id . "', category_id = '" . (int)$category_id . "'");
			}
		}
		if(isset($data['package_related'])){
			foreach ($data['package_related'] as $related_id){
				$this->db->query("INSERT INTO package_related SET package_id = '" . (int)$package_id . "', related_id = '" . (int)$related_id . "'");
				$this->db->query("INSERT INTO package_related SET package_id = '" . (int)$related_id . "', related_id = '" . (int)$package_id . "'");
			}
		}
		if($data['keyword']){
			$this->db->query("INSERT INTO url_alias SET query = 'package_id=" . (int)$package_id . "', keyword = '" . $this->db->escape($data['keyword']) . "'");
		}
		foreach ($data['package_tags'] as $language_id => $value){
			$tags = explode(',', $value);
			foreach ($tags as $tag){
				$this->db->query("INSERT INTO package_tags SET package_id = '" . (int)$package_id . "', language_id = '" . (int)$language_id . "', tag = '" . $this->db->escape(trim($tag)) . "'");
			}
		}
		$this->cache->delete('package');
	}

	public function editPackage($package_id, $data){
		$this->db->query("UPDATE package SET cat = '" . $this->db->escape($data['cat']) . "', sku = '" . $this->db->escape($data['sku']) . "', location = '" . $this->db->escape($data['location']) . "', quantity = '" . (int)$data['quantity'] . "', minimum = '" . (int)$data['minimum'] . "', subtract = '" . (int)$data['subtract'] . "', stock_status_id = '" . (int)$data['stock_status_id'] . "', date_available = '" . $this->db->escape($data['date_available']) . "', manufacturer_id = '" . (int)$data['manufacturer_id'] . "', shipping = '" . (int)$data['shipping'] . "', price = '" . (float)$data['price'] . "', cost = '" . (float)$data['cost'] . "', weight = '" . (float)$data['weight'] . "', weight_class_id = '" . (int)$data['weight_class_id'] . "', length = '" . (float)$data['length'] . "', width = '" . (float)$data['width'] . "', height = '" . (float)$data['height'] . "', length_class_id = '" . (int)$data['length_class_id'] . "', status = '" . (int)$data['status'] . "', tax_class_id = '" . (int)$data['tax_class_id'] . "', sort_order = '" . (int)$data['sort_order'] . "', date_modified = NOW() WHERE package_id = '" . (int)$package_id . "'");
		if(isset($data['image'])){
			$this->db->query("UPDATE package SET image = '" . $this->db->escape($data['image']) . "' WHERE package_id = '" . (int)$package_id . "'");
		}
		$this->db->query("DELETE FROM package_description WHERE package_id = '" . (int)$package_id . "'");
		foreach ($data['package_description'] as $language_id => $value){
			$this->db->query("INSERT INTO package_description SET package_id = '" . (int)$package_id . "', language_id = '" . (int)$language_id . "', name = '" . $this->db->escape($value['name']) . "', meta_keywords = '" . $this->db->escape($value['meta_keywords']) . "', meta_description = '" . $this->db->escape($value['meta_description']) . "', description = '" . $this->db->escape($value['description']) . "'");
		}
		$this->db->query("DELETE FROM package_to_store WHERE package_id = '" . (int)$package_id . "'");
		if(isset($data['package_store'])){
			foreach ($data['package_store'] as $store_id){
				$this->db->query("INSERT INTO package_to_store SET package_id = '" . (int)$package_id . "', store_id = '" . (int)$store_id . "'");
			}
		}
		$this->db->query("DELETE FROM package_option WHERE package_id = '" . (int)$package_id . "'");
		$this->db->query("DELETE FROM package_option_description WHERE package_id = '" . (int)$package_id . "'");
		$this->db->query("DELETE FROM package_option_value WHERE package_id = '" . (int)$package_id . "'");
		$this->db->query("DELETE FROM package_option_value_description WHERE package_id = '" . (int)$package_id . "'");
		if(isset($data['package_option'])){
			foreach ($data['package_option'] as $package_option){
				$this->db->query("INSERT INTO package_option SET package_id = '" . (int)$package_id . "', sort_order = '" . (int)$package_option['sort_order'] . "'");
				$package_option_id = $this->db->getLastId();
				foreach ($package_option['language'] as $language_id => $language){
					$this->db->query("INSERT INTO package_option_description SET package_option_id = '" . (int)$package_option_id . "', language_id = '" . (int)$language_id . "', package_id = '" . (int)$package_id . "', name = '" . $this->db->escape($language['name']) . "'");
				}
				if(isset($package_option['package_option_value'])){
					foreach ($package_option['package_option_value'] as $package_option_value){
						$this->db->query("INSERT INTO package_option_value SET package_option_id = '" . (int)$package_option_id . "', package_id = '" . (int)$package_id . "', quantity = '" . (int)$package_option_value['quantity'] . "', subtract = '" . (int)$package_option_value['subtract'] . "', price = '" . (float)$package_option_value['price'] . "', prefix = '" . $this->db->escape($package_option_value['prefix']) . "', sort_order = '" . (int)$package_option_value['sort_order'] . "'");
						$package_option_value_id = $this->db->getLastId();
						foreach ($package_option_value['language'] as $language_id => $language){
							$this->db->query("INSERT INTO package_option_value_description SET package_option_value_id = '" . (int)$package_option_value_id . "', language_id = '" . (int)$language_id . "', package_id = '" . (int)$package_id . "', name = '" . $this->db->escape($language['name']) . "'");
						}
					}
				}
			}
		}
		$this->db->query("DELETE FROM package_discount WHERE package_id = '" . (int)$package_id . "'");
		if(isset($data['package_discount'])){
			foreach ($data['package_discount'] as $value){
				$this->db->query("INSERT INTO package_discount SET package_id = '" . (int)$package_id . "', customer_group_id = '" . (int)$value['customer_group_id'] . "', quantity = '" . (int)$value['quantity'] . "', priority = '" . (int)$value['priority'] . "', price = '" . (float)$value['price'] . "', date_start = '" . $this->db->escape($value['date_start']) . "', date_end = '" . $this->db->escape($value['date_end']) . "'");
			}
		}
		$this->db->query("DELETE FROM package_special WHERE package_id = '" . (int)$package_id . "'");
		if(isset($data['package_special'])){
			foreach ($data['package_special'] as $value){
				$this->db->query("INSERT INTO package_special SET package_id = '" . (int)$package_id . "', customer_group_id = '" . (int)$value['customer_group_id'] . "', priority = '" . (int)$value['priority'] . "', price = '" . (float)$value['price'] . "', date_start = '" . $this->db->escape($value['date_start']) . "', date_end = '" . $this->db->escape($value['date_end']) . "'");
			}
		}
		$this->db->query("DELETE FROM package_image WHERE package_id = '" . (int)$package_id . "'");
		if(isset($data['package_image'])){
			foreach ($data['package_image'] as $image){
        		$this->db->query("INSERT INTO package_image SET package_id = '" . (int)$package_id . "', image = '" . $this->db->escape($image) . "'");
			}
		}
		$this->db->query("DELETE FROM package_to_download WHERE package_id = '" . (int)$package_id . "'");
		if(isset($data['package_download'])){
			foreach ($data['package_download'] as $download_id){
				$this->db->query("INSERT INTO package_to_download SET package_id = '" . (int)$package_id . "', download_id = '" . (int)$download_id . "'");
			}
		}
		$this->db->query("DELETE FROM package_to_category WHERE package_id = '" . (int)$package_id . "'");
		if(isset($data['package_category'])){
			foreach ($data['package_category'] as $category_id){
				$this->db->query("INSERT INTO package_to_category SET package_id = '" . (int)$package_id . "', category_id = '" . (int)$category_id . "'");
			}
		}
		$this->db->query("DELETE FROM package_related WHERE package_id = '" . (int)$package_id . "'");
		if(isset($data['package_related'])){
			foreach ($data['package_related'] as $related_id){
				$this->db->query("INSERT INTO package_related SET package_id = '" . (int)$package_id . "', related_id = '" . (int)$related_id . "'");
				$this->db->query("DELETE FROM package_related WHERE package_id = '" . (int)$related_id . "' AND related_id = '" . (int)$package_id . "'");
				$this->db->query("INSERT INTO package_related SET package_id = '" . (int)$related_id . "', related_id = '" . (int)$package_id . "'");
			}
		}
		$this->db->query("DELETE FROM url_alias WHERE query = 'package_id=" . (int)$package_id. "'");
		if($data['keyword']){
			$this->db->query("INSERT INTO url_alias SET query = 'package_id=" . (int)$package_id . "', keyword = '" . $this->db->escape($data['keyword']) . "'");
		}
		$this->db->query("DELETE FROM package_tags WHERE package_id = '" . (int)$package_id. "'");
		foreach ($data['package_tags'] as $language_id => $value){
			$tags = explode(',', $value);
			foreach ($tags as $tag){
				$this->db->query("INSERT INTO package_tags SET package_id = '" . (int)$package_id . "', language_id = '" . (int)$language_id . "', tag = '" . $this->db->escape(trim($tag)) . "'");
			}
		}
		$this->cache->delete('package');
	}

	public function copyPackage($package_id){
		$query = $this->db->query("SELECT DISTINCT * FROM package p LEFT JOIN package_description pd ON (package_id = package_id) WHERE package_id = '" . (int)$package_id . "' AND language_id = '" . (int)$this->config->get('config_language_id') . "'");
		if($query->num_rows){
			$data = array();
			$data = $query->row;
			$data = array_merge($data, array('package_description' => $this->getPackageDescriptions($package_id)));
			$data = array_merge($data, array('package_option' => $this->getPackageOptions($package_id)));
			$data['keyword'] = '';
			$data['status'] = '0';
      foreach(array_keys($data['package_description']) as $key){
        $data['package_description'][$key]['name'] = $data['package_description'][$key]['name'] . '*';
      }
			$data['package_image'] = array();
			$results = $this->getPackageImages($package_id);
			foreach ($results as $result){
				$data['package_image'][] = $result['image'];
			}
			$data = array_merge($data, array('package_discount' => $this->getPackageDiscounts($package_id)));
			$data = array_merge($data, array('package_special' => $this->getPackageSpecials($package_id)));
			$data = array_merge($data, array('package_download' => $this->getPackageDownloads($package_id)));
			$data = array_merge($data, array('package_category' => $this->getPackageCategories($package_id)));
			$data = array_merge($data, array('package_store' => $this->getPackageStores($package_id)));
			$data = array_merge($data, array('package_related' => $this->getPackageRelated($package_id)));
			$data = array_merge($data, array('package_tags' => $this->getPackageTags($package_id)));
			$this->addPackage($data);
		}
	}

	public function deletePackage($package_id){
		$this->db->query("DELETE FROM package WHERE package_id = '" . (int)$package_id . "'");
		$this->db->query("DELETE FROM package_description WHERE package_id = '" . (int)$package_id . "'");
		$this->db->query("DELETE FROM package_option WHERE package_id = '" . (int)$package_id . "'");
		$this->db->query("DELETE FROM package_option_description WHERE package_id = '" . (int)$package_id . "'");
		$this->db->query("DELETE FROM package_option_value WHERE package_id = '" . (int)$package_id . "'");
		$this->db->query("DELETE FROM package_option_value_description WHERE package_id = '" . (int)$package_id . "'");
		$this->db->query("DELETE FROM package_discount WHERE package_id = '" . (int)$package_id . "'");
		$this->db->query("DELETE FROM package_image WHERE package_id = '" . (int)$package_id . "'");
		$this->db->query("DELETE FROM package_related WHERE package_id = '" . (int)$package_id . "'");
		$this->db->query("DELETE FROM package_to_download WHERE package_id = '" . (int)$package_id . "'");
		$this->db->query("DELETE FROM package_to_category WHERE package_id = '" . (int)$package_id . "'");
		$this->db->query("DELETE FROM review WHERE package_id = '" . (int)$package_id . "'");
		$this->db->query("DELETE FROM package_to_store WHERE package_id = '" . (int)$package_id . "'");
		$this->db->query("DELETE FROM url_alias WHERE query = 'package_id=" . (int)$package_id. "'");
		$this->db->query("DELETE FROM package_tags WHERE package_id='" . (int)$package_id. "'");
		$this->cache->delete('package');
	}

	public function getPackage($package_id){
	  $sql = "SELECT DISTINCT *, (SELECT keyword FROM url_alias WHERE query = 'package_id=" . (int)$package_id . "') AS keyword FROM package p LEFT JOIN package_description pd ON (package_id = package_id) WHERE package_id = '" . (int)$package_id . "' AND language_id = '" . (int)$this->config->get('config_language_id') . "'";
		//$this->log->aPrint( $sql );
		$query = $this->db->query($sql);
		return $query->row;
	}

  public function getOneData($id){
		$res = array();
		if($id){
			$sql = "SELECT * FROM package where id = $id ";
      $query = $this->db->query($sql);
			$rtn = $query->row;
		}
		return $rtn;
	}

  public function getHistoryData($id){
		$res = array();
		if($id){
			$sql = "SELECT ph.*, p.model FROM package_history ph left join product p on (p.product_id = ph.final) where ph.code = ( select code from package where id = " . $id . ") and ph.diff != 0";
      //echo $sql;
      $query = $this->db->query($sql);
			$rtn = $query->rows;
		}
		return $rtn;
	}

  public function callQuickUpdate($id,$quantity,$price,$desc){
    $sql = "select quantity from package_history where up_date = ( select max(up_date) from package_history where code = ( select code from package where id = " . $id . ") ) ";
    $qry = $this->db->query($sql);
    $rows = $qry->row;
    if(isset($rows['quantity'])){
      $diff = $quantity - $rows['quantity'];
    }else{
      $diff = $quantity;
    }
    /***
    $defact = '0.3';
    $diff = round( $diff * ( 100 + $defact ) / 100 );
    ***/
    $rep = $this->user->getUserName();
    $tdate = date('Ymdhis');
    // todo. historical package table
	  $sql = "insert into package_history ";
	  $sql.= " SET code = ( select code from package where id = " . $this->db->escape($id) . "),";
	  $sql.= "     price = " . $price . ",";
	  $sql.= "     quantity = " . $quantity . ",";
	  $sql.= "     diff = " . $diff . ",";
    $sql.= "     up_date = '" . $tdate . "',";
	  $sql.= "     comment = '" . $desc . "',";
	  $sql.= "     rep = '" . $rep . "',";
	  $sql.= "     company = ( select company from package where id = " . $this->db->escape($id) . ")";
	  if($this->db->query($sql)){
      // ok
    }
	  $sql = "UPDATE package ";
	  $sql.= " SET quantity = '" . $this->db->escape($quantity) . "',";
	  $sql.= "     price = " . $this->db->escape($price) ;
	  $sql.= " where id = '" . $this->db->escape($id) . "'";
	  //echo $sql;
	  if($this->db->query($sql)){
      // ok
    }
    return true;
  }

  /* update store , besso-201103 */
	public function insertPackage($data){
    $code = $this->db->escape($data['code']);
    $name = $this->db->escape($data['name']);
    $cat = $this->db->escape($data['cat']);
    $image = 'data/package/African-Essence-Non-Flaking-Styling-Gel-Clear-Super.jpg';
    $price = $this->db->escape($data['price']);
    $quantity = $this->db->escape($data['quantity']);
    $thres = $this->db->escape($data['thres']);
    $warehouse = 'ubp';
    $company = $this->db->escape($data['company']);
    $description = $this->db->escape($data['description']);
    $up_date = date('Ymdhis');
    $status = $this->db->escape($data['status']);
	  $sql = "insert into package (code,name,cat,image,price,quantity,thres,warehouse,company,description,up_date,status)";
	  $sql.= " values ('$code','$name','$cat','$image',$price,'$quantity','$thres','$warehouse','$company','$description','$up_date','$status')";
    if($this->db->query($sql)){
      return true;
    }else{
      return false; 
    }
	}	

	public function updatePackage($data){
    $sql = "select quantity from package_history where up_date = ( select max(up_date) from package_history where code = '" . $this->db->escape($data['code']) . "') ";
    $qry = $this->db->query($sql);
    $rows = $qry->row;
    if(isset($rows['quantity'])){
      $diff = $data['quantity'] - $rows['quantity'];
    }else{
      $diff = $data['quantity'];
    }
    $rep = $this->user->getUserName();
    $tdate = date('Ymdhis');
    // todo. historical package table
	  $sql = "insert into package_history ";
	  $sql.= " SET code = '" . $this->db->escape($data['code']) . "',";
	  $sql.= "     price = " . $this->db->escape($data['price']) . ",";
	  $sql.= "     quantity = " . $this->db->escape($data['quantity']) . ",";
	  $sql.= "     diff = " . $diff . ",";
    $sql.= "     up_date = '" . $tdate . "',";
	  $sql.= "     comment = '" . $this->db->escape($data['comment']) . "',";
	  $sql.= "     rep = '" . $rep . "',";
	  $sql.= "     company = '" . $this->db->escape($data['company']) . "'";
	  //$this->log->aPrint( $sql );
	  if($this->db->query($sql)){
      // ok
    }

	  $sql = "UPDATE package ";
	  $sql.= " SET cat = '" . $this->db->escape($data['cat']) . "',";
	  $sql.= "     code = '" . $this->db->escape($data['code']) . "',";
	  $sql.= "     name = '" . $this->db->escape($data['name']) . "',";
	  $sql.= "     price = " . $this->db->escape($data['price']) . ",";
	  $sql.= "     image = '" . $this->db->escape($data['image']) . "',";
	  $sql.= "     quantity = '" . $this->db->escape($data['quantity']) . "',";
    $sql.= "     thres = '" . $this->db->escape($data['thres']) . "',";
	  $sql.= "     company = '" . $this->db->escape($data['company']) . "',";
	  $sql.= "     status = '" . $this->db->escape($data['status']) . "',";
	  $sql.= "     term = '" . $this->db->escape($data['term']) . "',";
	  $sql.= "     warehouse = '" . $this->db->escape($data['warehouse']) . "',";
	  $sql.= "     description = '" . $this->db->escape($data['description']) . "'";
	  $sql.= " where id = '" . $this->db->escape($data['id']) . "'";

    if($this->db->query($sql)){
      // ok
    }
    return true;
	}	

  public function getPackages($data = array()){
		if($data){
			$sql = "SELECT * FROM package where id is not null";
			if(isset($data['filter_code']) && !is_null($data['filter_code'])){
				$sql .= " AND LCASE(code) LIKE '%" . $this->db->escape(strtolower($data['filter_code'])) . "%'";
			}
			if(isset($data['filter_name']) && !is_null($data['filter_name'])){
				$sql .= " AND LCASE(name) LIKE '%" . $this->db->escape(strtolower($data['filter_name'])) . "%'";
			}
			if(isset($data['filter_desc']) && !is_null($data['filter_desc'])){
				$sql .= " AND LCASE(description) LIKE '%" . $this->db->escape(strtolower($data['filter_desc'])) . "%'";
			}
			if(isset($data['filter_cat']) && !is_null($data['filter_cat'])){
				$sql .= " AND LCASE(cat) LIKE '%" . $this->db->escape(strtolower($data['filter_cat'])) . "%'";
			}
			if(isset($data['filter_price']) && !is_null($data['filter_price'])){
				$sql .= " AND LCASE(price) > " . $this->db->escape(strtolower($data['filter_price']));
			}
			if(isset($data['filter_quantity']) && !is_null($data['filter_quantity'])){
				$sql .= " AND quantity < " . $this->db->escape($data['filter_quantity']);
			}
			if(isset($data['filter_status']) && '' != $data['filter_status']){
				$sql .= " AND status = '" . (int)$data['filter_status'] . "'";
			}
			$sort_data = array(
			  'code',
				'name',
				'cat',
				'price',
				'quantity',
				'status',
				'sort_order'
			);
			if(isset($data['sort']) && in_array($data['sort'], $sort_data)){
				$sql .= " ORDER BY " . $data['sort'];
			}else{
				$sql .= " ORDER BY code";
			}
			if(isset($data['order']) && ($data['order'] == 'DESC')){
				$sql .= " DESC";
			}else{
				$sql .= " ASC";
			}
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
			return $query->rows;
		}else{
			$package_data = $this->cache->get('package.' . $this->config->get('config_language_id'));
			if(!$package_data){
				$query = $this->db->query("SELECT * FROM package ORDER BY name ASC");
				$package_data = $query->rows;
				$this->cache->set('package.' . $this->config->get('config_language_id'), $package_data);
			}
			return $package_data;
		}
	}

	public function getTotalPackages($data = array()){
		$sql = "SELECT COUNT(*) AS total FROM package where id is not null";
		if(isset($data['filter_code']) && !is_null($data['filter_code'])){
			$sql .= " AND LCASE(code) LIKE '%" . $this->db->escape(strtolower($data['filter_code'])) . "%'";
		}
		if(isset($data['filter_name']) && !is_null($data['filter_name'])){
			$sql .= " AND LCASE(name) LIKE '%" . $this->db->escape(strtolower($data['filter_name'])) . "%'";
		}
		if(isset($data['filter_desc']) && !is_null($data['filter_desc'])){
			$sql .= " AND LCASE(description) LIKE '%" . $this->db->escape(strtolower($data['filter_desc'])) . "%'";
		}
		if(isset($data['filter_cat']) && !is_null($data['filter_cat'])){
			$sql .= " AND LCASE(cat) LIKE '%" . $this->db->escape(strtolower($data['filter_cat'])) . "%'";
		}
		if(isset($data['filter_price']) && !is_null($data['filter_price'])){
			$sql .= " AND LCASE(price) > " . $this->db->escape(strtolower($data['filter_price']));
		}
		if(isset($data['filter_quantity']) && !is_null($data['filter_quantity'])){
			$sql .= " AND quantity < " . $this->db->escape($data['filter_quantity']);
		}
		if(isset($data['filter_status']) && '' != $data['filter_status']){
			$sql .= " AND status = '" . (int)$data['filter_status'] . "'";
		}
		$query = $this->db->query($sql);
		return $query->row['total'];
	}

	public function addFeatured($data){
   	$this->db->query("DELETE FROM package_featured");
		if(isset($data['package_featured'])){
    	foreach ($data['package_featured'] as $package_id){
    		$this->db->query("INSERT INTO package_featured SET package_id = '" . (int)$package_id . "'");
    	}
		}
	}

	public function getFeaturedPackages(){
		$package_featured_data = array();
		$query = $this->db->query("SELECT package_id FROM package_featured");
		foreach ($query->rows as $result){
			$package_featured_data[] = $result['package_id'];
		}
		return $package_featured_data;
	}

	public function getPackagesByKeyword($keyword){
		if($keyword){
			$query = $this->db->query("SELECT * FROM package p LEFT JOIN package_description pd ON (package_id = package_id) WHERE language_id = '" . (int)$this->config->get('config_language_id') . "' AND (LCASE(name) LIKE '%" . $this->db->escape(strtolower($keyword)) . "%' OR LCASE(cat) LIKE '%" . $this->db->escape(strtolower($keyword)) . "%')");
			return $query->rows;
		}else{
			return array();
		}
	}

	public function getPackagesByCategoryId($category_id){
		$query = $this->db->query("SELECT * FROM package p LEFT JOIN package_description pd ON (package_id = package_id) LEFT JOIN package_to_category p2c ON (package_id = p2c.package_id) WHERE language_id = '" . (int)$this->config->get('config_language_id') . "' AND p2c.category_id = '" . (int)$category_id . "' ORDER BY name ASC");
		return $query->rows;
	}

	public function getPackageDescriptions($package_id){
		$package_description_data = array();
		$query = $this->db->query("SELECT * FROM package_description WHERE package_id = '" . (int)$package_id . "'");
		foreach ($query->rows as $result){
			$package_description_data[$result['language_id']] = array(
				'name'             => $result['name'],
				'meta_keywords'    => $result['meta_keywords'],
				'meta_description' => $result['meta_description'],
				'description'      => $result['description']
			);
		}
		return $package_description_data;
	}

	public function getPackageOptions($package_id){
		$package_option_data = array();
		$package_option = $this->db->query("SELECT * FROM package_option WHERE package_id = '" . (int)$package_id . "' ORDER BY sort_order");
		foreach ($package_option->rows as $package_option){
			$package_option_value_data = array();
			$package_option_value = $this->db->query("SELECT * FROM package_option_value WHERE package_option_id = '" . (int)$package_option['package_option_id'] . "' ORDER BY sort_order");
			foreach ($package_option_value->rows as $package_option_value){
				$package_option_value_description_data = array();
				$package_option_value_description = $this->db->query("SELECT * FROM package_option_value_description WHERE package_option_value_id = '" . (int)$package_option_value['package_option_value_id'] . "'");
				foreach ($package_option_value_description->rows as $result){
					$package_option_value_description_data[$result['language_id']] = array('name' => $result['name']);
				}
				$package_option_value_data[] = array(
					'package_option_value_id' => $package_option_value['package_option_value_id'],
					'language'                => $package_option_value_description_data,
         			'quantity'                => $package_option_value['quantity'],
					'subtract'                => $package_option_value['subtract'],
					'price'                   => $package_option_value['price'],
         			'prefix'                  => $package_option_value['prefix'],
					'sort_order'              => $package_option_value['sort_order']
				);
			}
			$package_option_description_data = array();
			$package_option_description = $this->db->query("SELECT * FROM package_option_description WHERE package_option_id = '" . (int)$package_option['package_option_id'] . "'");
			foreach ($package_option_description->rows as $result){
				$package_option_description_data[$result['language_id']] = array('name' => $result['name']);
			}
     	$package_option_data[] = array(
        'package_option_id'    => $package_option['package_option_id'],
				'language'             => $package_option_description_data,
				'package_option_value' => $package_option_value_data,
				'sort_order'           => $package_option['sort_order']
      );
    }
		return $package_option_data;
	}

	public function getPackageImages($package_id){
		$query = $this->db->query("SELECT * FROM package_image WHERE package_id = '" . (int)$package_id . "'");
		return $query->rows;
	}

	public function getPackageDiscounts($package_id){
		$query = $this->db->query("SELECT * FROM package_discount WHERE package_id = '" . (int)$package_id . "' ORDER BY quantity, priority, price");
		return $query->rows;
	}

	public function getPackageSpecials($package_id){
		$query = $this->db->query("SELECT * FROM package_special WHERE package_id = '" . (int)$package_id . "' ORDER BY priority, price");
		return $query->rows;
	}

	public function getPackageDownloads($package_id){
		$package_download_data = array();
		$query = $this->db->query("SELECT * FROM package_to_download WHERE package_id = '" . (int)$package_id . "'");
		foreach ($query->rows as $result){
			$package_download_data[] = $result['download_id'];
		}
		return $package_download_data;
	}

	public function getPackageStores($package_id){
		$package_store_data = array();
		$query = $this->db->query("SELECT * FROM package_to_store WHERE package_id = '" . (int)$package_id . "'");
		foreach ($query->rows as $result){
			$package_store_data[] = $result['store_id'];
		}
		return $package_store_data;
	}

	public function getPackageCategories($package_id){
		$package_category_data = array();
		$query = $this->db->query("SELECT * FROM package_to_category WHERE package_id = '" . (int)$package_id . "'");
		foreach ($query->rows as $result){
			$package_category_data[] = $result['category_id'];
		}
		return $package_category_data;
	}

	public function getPackageRelated($package_id){
		$package_related_data = array();
		$query = $this->db->query("SELECT * FROM package_related WHERE package_id = '" . (int)$package_id . "'");
		foreach ($query->rows as $result){
			$package_related_data[] = $result['related_id'];
		}
		return $package_related_data;
	}

	public function getPackageTags($package_id){
		$package_tag_data = array();
		$query = $this->db->query("SELECT * FROM package_tags WHERE package_id = '" . (int)$package_id . "'");
		$tag_data = array();
		foreach ($query->rows as $result){
			$tag_data[$result['language_id']][] = $result['tag'];
		}
		foreach ($tag_data as $language => $tags){
			$package_tag_data[$language] = implode(',', $tags);
		}
		return $package_tag_data;
	}

	public function getTotalPackagesByStockStatusId($stock_status_id){
    $query = $this->db->query("SELECT COUNT(*) AS total FROM package WHERE stock_status_id = '" . (int)$stock_status_id . "'");
		return $query->row['total'];
	}

	public function getTotalPackagesByImageId($image_id){
  	$query
 = $this->db->query("SELECT COUNT(*) AS total FROM package WHERE image_id = '" . (int)$image_id . "'");
		return $query->row['total'];
	}

	public function getTotalPackagesByTaxClassId($tax_class_id){
  	$query
 = $this->db->query("SELECT COUNT(*) AS total FROM package WHERE tax_class_id = '" . (int)$tax_class_id . "'");
		return $query->row['total'];
	}

	public function getTotalPackagesByWeightClassId($weight_class_id){
  	$query
 = $this->db->query("SELECT COUNT(*) AS total FROM package WHERE weight_class_id = '" . (int)$weight_class_id . "'");
		return $query->row['total'];
	}

	public function getTotalPackagesByLengthClassId($length_class_id){
  	$query
 = $this->db->query("SELECT COUNT(*) AS total FROM package WHERE length_class_id = '" . (int)$length_class_id . "'");
		return $query->row['total'];
	}

	public function getTotalPackagesByOptionId($option_id){
  	$query
 = $this->db->query("SELECT COUNT(*) AS total FROM package_to_option WHERE option_id = '" . (int)$option_id . "'");
		return $query->row['total'];
	}

	public function getTotalPackagesByDownloadId($download_id){
  	$query
 = $this->db->query("SELECT COUNT(*) AS total FROM package_to_download WHERE download_id = '" . (int)$download_id . "'");
		return $query->row['total'];
	}

	public function getTotalPackagesByManufacturerId($manufacturer_id){
  	$query
 = $this->db->query("SELECT COUNT(*) AS total FROM package WHERE manufacturer_id = '" . (int)$manufacturer_id . "'");
		return $query->row['total'];
	}
}
?>