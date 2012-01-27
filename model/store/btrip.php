<?php
class ModelStoreBtrip extends Model {
  public function getStore($request=array(),&$export_qry){
		$res = array();
		if($request){
			$sql = "SELECT * FROM storelocator where status = '1' and lat != '' ";
			if(isset($request['filter_name']) && !is_null($request['filter_name'])) {
				$sql .= " AND LCASE(name) LIKE '%" . $this->db->escape(strtolower($request['filter_name'])) . "%'";
			}
			if(isset($request['filter_accountno']) && !is_null($request['filter_accountno'])) {
				$sql .= " AND LCASE(accountno) like '%" . $this->db->escape(strtolower($request['filter_accountno'])) . "%'";
			}
			if(isset($request['filter_storetype']) && !is_null($request['filter_storetype'])) {
				$sql .= " AND LCASE(storetype) = '" . $this->db->escape(strtolower($request['filter_storetype'])) . "'";
			}
			if(isset($request['filter_address1']) && !is_null($request['filter_address1'])) {
				$sql .= " AND LCASE(address1) LIKE '%" . $this->db->escape(strtolower($request['filter_address1'])) . "%'";
			}
			if(isset($request['filter_city']) && !is_null($request['filter_city'])) {
				$sql .= " AND LCASE(city) LIKE '%" . $this->db->escape(strtolower($request['filter_city'])) . "%'";
			}
			if(isset($request['filter_state']) && !is_null($request['filter_state'])) {
				$sql .= " AND LCASE(state) like '%" . $this->db->escape(strtolower($request['filter_state'])) . "%'";
			}
			if(isset($request['filter_phone1']) && !is_null($request['filter_phone1'])) {
				$sql .= " AND LCASE(phone1) LIKE '%" . $this->db->escape(strtolower($request['filter_phone1'])) . "%'";
			}
			if(isset($request['filter_salesrep']) && !is_null($request['filter_salesrep'])) {
				$sql .= " AND salesrep = ( select username from user where LCASE(username) = '" . $this->db->escape(strtolower($request['filter_salesrep'])) . "')";
			}
      $sort_data = array('name','status','storetype');
			if(isset($request['sort']) && in_array($request['sort'], $sort_data)) {
				$sql .= " ORDER BY " . $request['sort'];
			}else{
				$sql .= " ORDER BY name";
			}
			//$this->log->aPrint( $request['order'] );
			if(isset($request['order']) && ($request['order'] == 'DESC')) {
				$sql .= " DESC";
			} else {
				$sql .= " ASC";
			}

      // besso adhoc for pagination in ajax, , besso-201103 
      if( isset($request['filter_page']) &&  !is_null($request['filter_page'])  ) {
		    $request['start'] = 20 * ( $request['filter_page'] - 1 ); 
		  }

      //$this->log->aPrint( $sql );
      
      // todo. export_qry need not limit ext , besso-201103 
      $export_qry = $sql;
      
      # no limit for business trip planning , besso 201105 
      /***
			if(isset($request['start']) || isset($request['limit'])) {
				if ($request['start'] < 0) {
					$request['start'] = 0;
				}
				if ($request['limit'] < 1) {
					$request['limit'] = 20;
				}
				$sql .= " LIMIT " . (int)$request['start'] . "," . (int)$request['limit'];
			}
			***/
			//echo $sql;

      $query = $this->db->query($sql);
			
			
			$res = $query->rows;
			
		}else{
			$response = $this->cache->get('storelocator.' . $this->config->get('config_language_id'));
			if(!$response) {
				$query = $this->db->query("SELECT * FROM storelocator");
				$response = $query->rows;
				$this->cache->set('storelocator.' . $this->config->get('config_language_id'), $response);
			}
			$res = $response;
		}

    $rtn = array();
    if(isset($res)){
      foreach($res as $one){
        $sid = $one['id'];
        //todo. adhoc for test , besso-201103 
        //$sid = '2181';
        $sql = "select (sum(order_price) - sum(payed_sum)) as balance from transaction
                 where store_id = $sid";
        $query = $this->db->query($sql);
        $balance = $query->row;
        //$this->log->aPrint( $one );
        //$this->log->aPrint( $balance );
        $one['balance'] = $balance['balance']?$balance['balance']:'0';
        $rtn[] = $one;
      }
		}
		//$this->log->aPrint( $rtn );
		
		return $rtn;
	}
	
	public function getTotalStore($request=array()){
		if($request){
			$sql = "SELECT count(*) as total FROM storelocator where status = '1' and lat != '' ";
			if(isset($request['filter_name']) && !is_null($request['filter_name'])) {
				$sql .= " AND LCASE(name) LIKE '%" . $this->db->escape(strtolower($request['filter_name'])) . "%'";
			}
			if(isset($request['filter_accountno']) && !is_null($request['filter_accountno'])) {
				$sql .= " AND LCASE(accountno) like '%" . $this->db->escape(strtolower($request['filter_accountno'])) . "%'";
			}
			if(isset($request['filter_storetype']) && !is_null($request['filter_storetype'])) {
				$sql .= " AND LCASE(storetype) = '" . $this->db->escape(strtolower($request['filter_storetype'])) . "'";
			}
			if(isset($request['filter_address1']) && !is_null($request['filter_address1'])) {
				$sql .= " AND LCASE(address1) LIKE '%" . $this->db->escape(strtolower($request['filter_address1'])) . "%'";
			}
			if(isset($request['filter_city']) && !is_null($request['filter_city'])) {
				$sql .= " AND LCASE(city) LIKE '%" . $this->db->escape(strtolower($request['filter_city'])) . "%'";
			}
			if(isset($request['filter_state']) && !is_null($request['filter_state'])) {
				$sql .= " AND LCASE(state) like '%" . $this->db->escape(strtolower($request['filter_state'])) . "%'";
			}
			if(isset($request['filter_zipcode']) && !is_null($request['filter_zipcode'])) {
				$sql .= " AND LCASE(zipcode) = '" . $this->db->escape(strtolower($request['filter_zipcode'])) . "'";
			}
			if(isset($request['filter_phone1']) && !is_null($request['filter_phone1'])) {
				$sql .= " AND LCASE(phone1) LIKE '%" . $this->db->escape(strtolower($request['filter_phone1'])) . "%'";
			}
			if(isset($request['filter_status']) && '' != $request['filter_status']) {
				$sql .= " AND LCASE(status) = '" . $this->db->escape(strtolower($request['filter_status'])) . "'";
			}
			if(isset($request['filter_salesrep']) && !is_null($request['filter_salesrep'])) {
				$sql .= " AND salesrep = ( select username from user where LCASE(username) = '" . $this->db->escape(strtolower($request['filter_salesrep'])) . "')";
			}
			      
      $sort_data = array('name','status','storetype');
      //$this->log->aPrint( $request );
			if(isset($request['sort']) && in_array($request['sort'], $sort_data)) {
				$sql .= " ORDER BY " . $request['sort'];
			} else {
				$sql .= " ORDER BY name";
			}

			if(isset($request['order']) && ($request['order'] == 'DESC')) {
				$sql .= " DESC";
			} else {
				$sql .= " ASC";
			}
			//echo $sql;
			$query = $this->db->query($sql);
			return $query->row['total'];
		}else{
			$query = $this->db->query("SELECT count(*) as total FROM storelocator");
      return $query->row['total'];
		}
	}

	public function addStore($data) {
		$this->db->query("INSERT INTO " . DB_PREFIX . "store SET model = '" . $this->db->escape($data['model']) . "', sku = '" . $this->db->escape($data['sku']) . "', location = '" . $this->db->escape($data['location']) . "', quantity = '" . (int)$data['quantity'] . "', minimum = '" . (int)$data['minimum'] . "', subtract = '" . (int)$data['subtract'] . "', stock_status_id = '" . (int)$data['stock_status_id'] . "', date_available = '" . $this->db->escape($data['date_available']) . "', manufacturer_id = '" . (int)$data['manufacturer_id'] . "', shipping = '" . (int)$data['shipping'] . "', price = '" . (float)$data['price'] . "', cost = '" . (float)$data['cost'] . "', weight = '" . (float)$data['weight'] . "', weight_class_id = '" . (int)$data['weight_class_id'] . "', length = '" . (float)$data['length'] . "', width = '" . (float)$data['width'] . "', height = '" . (float)$data['height'] . "', length_class_id = '" . (int)$data['length_class_id'] . "', status = '" . (int)$data['status'] . "', tax_class_id = '" . (int)$data['tax_class_id'] . "', sort_order = '" . (int)$data['sort_order'] . "', date_added = NOW()");

		$store_id = $this->db->getLastId();

		if (isset($data['image'])) {
			$this->db->query("UPDATE " . DB_PREFIX . "store SET image = '" . $this->db->escape($data['image']) . "' WHERE store_id = '" . (int)$store_id . "'");
		}

		foreach ($data['store_description'] as $language_id => $value) {
			$this->db->query("INSERT INTO " . DB_PREFIX . "store_description SET store_id = '" . (int)$store_id . "', language_id = '" . (int)$language_id . "', name = '" . $this->db->escape($value['name']) . "', meta_keywords = '" . $this->db->escape($value['meta_keywords']) . "', meta_description = '" . $this->db->escape($value['meta_description']) . "', description = '" . $this->db->escape($value['description']) . "'");
		}

		if (isset($data['store_store'])) {
			foreach ($data['store_store'] as $store_id) {
				$this->db->query("INSERT INTO " . DB_PREFIX . "storelocator SET store_id = '" . (int)$store_id . "', store_id = '" . (int)$store_id . "'");
			}
		}

		if (isset($data['store_option'])) {
			foreach ($data['store_option'] as $store_option) {
				$this->db->query("INSERT INTO " . DB_PREFIX . "store_option SET store_id = '" . (int)$store_id . "', sort_order = '" . (int)$store_option['sort_order'] . "'");

				$store_option_id = $this->db->getLastId();

				foreach ($store_option['language'] as $language_id => $language) {
					$this->db->query("INSERT INTO " . DB_PREFIX . "store_option_description SET store_option_id = '" . (int)$store_option_id . "', language_id = '" . (int)$language_id . "', store_id = '" . (int)$store_id . "', name = '" . $this->db->escape($language['name']) . "'");
				}

				if (isset($store_option['store_option_value'])) {
					foreach ($store_option['store_option_value'] as $store_option_value) {
						$this->db->query("INSERT INTO " . DB_PREFIX . "store_option_value SET store_option_id = '" . (int)$store_option_id . "', store_id = '" . (int)$store_id . "', quantity = '" . (int)$store_option_value['quantity'] . "', subtract = '" . (int)$store_option_value['subtract'] . "', price = '" . (float)$store_option_value['price'] . "', prefix = '" . $this->db->escape($store_option_value['prefix']) . "', sort_order = '" . (int)$store_option_value['sort_order'] . "'");

						$store_option_value_id = $this->db->getLastId();

						foreach ($store_option_value['language'] as $language_id => $language) {
							$this->db->query("INSERT INTO " . DB_PREFIX . "store_option_value_description SET store_option_value_id = '" . (int)$store_option_value_id . "', language_id = '" . (int)$language_id . "', store_id = '" . (int)$store_id . "', name = '" . $this->db->escape($language['name']) . "'");
						}
					}
				}
			}
		}

		if (isset($data['store_discount'])) {
			foreach ($data['store_discount'] as $value) {
				$this->db->query("INSERT INTO " . DB_PREFIX . "store_discount SET store_id = '" . (int)$store_id . "', customer_group_id = '" . (int)$value['customer_group_id'] . "', quantity = '" . (int)$value['quantity'] . "', priority = '" . (int)$value['priority'] . "', price = '" . (float)$value['price'] . "', date_start = '" . $this->db->escape($value['date_start']) . "', date_end = '" . $this->db->escape($value['date_end']) . "'");
			}
		}

		if (isset($data['store_special'])) {
			foreach ($data['store_special'] as $value) {
				$this->db->query("INSERT INTO " . DB_PREFIX . "store_special SET store_id = '" . (int)$store_id . "', customer_group_id = '" . (int)$value['customer_group_id'] . "', priority = '" . (int)$value['priority'] . "', price = '" . (float)$value['price'] . "', date_start = '" . $this->db->escape($value['date_start']) . "', date_end = '" . $this->db->escape($value['date_end']) . "'");
			}
		}

		if (isset($data['store_image'])) {
			foreach ($data['store_image'] as $image) {
        		$this->db->query("INSERT INTO " . DB_PREFIX . "store_image SET store_id = '" . (int)$store_id . "', image = '" . $this->db->escape($image) . "'");
			}
		}

		if (isset($data['store_download'])) {
			foreach ($data['store_download'] as $download_id) {
				$this->db->query("INSERT INTO " . DB_PREFIX . "store_to_download SET store_id = '" . (int)$store_id . "', download_id = '" . (int)$download_id . "'");
			}
		}

		if (isset($data['store_category'])) {
			foreach ($data['store_category'] as $category_id) {
				$this->db->query("INSERT INTO " . DB_PREFIX . "store_to_category SET store_id = '" . (int)$store_id . "', category_id = '" . (int)$category_id . "'");
			}
		}

		if (isset($data['store_related'])) {
			foreach ($data['store_related'] as $related_id) {
				$this->db->query("INSERT INTO " . DB_PREFIX . "store_related SET store_id = '" . (int)$store_id . "', related_id = '" . (int)$related_id . "'");
				$this->db->query("INSERT INTO " . DB_PREFIX . "store_related SET store_id = '" . (int)$related_id . "', related_id = '" . (int)$store_id . "'");
			}
		}

		if ($data['keyword']) {
			$this->db->query("INSERT INTO " . DB_PREFIX . "url_alias SET query = 'store_id=" . (int)$store_id . "', keyword = '" . $this->db->escape($data['keyword']) . "'");
		}

		foreach ($data['store_tags'] as $language_id => $value) {
			$tags = explode(',', $value);
			foreach ($tags as $tag) {
				$this->db->query("INSERT INTO " . DB_PREFIX . "store_tags SET store_id = '" . (int)$store_id . "', language_id = '" . (int)$language_id . "', tag = '" . $this->db->escape(trim($tag)) . "'");
			}
		}


		$this->cache->delete('store');
	}

  /* update store , besso-201103 */
	public function updateStore($data) {
/*
            [id] => 2931
            [accountno] => VA1339
            [name] => A & D Wholesale
            [storetype] => selected
            [address1] => 309 East Street
            [address2] => 
            [city] => Hampton
            [state] => VA
            [zipcode] => 23661
            [phone1] => 757-825-1339
            [phone2] => 
            [salesrep] => JU
            [status] => 1
            [fax] => 
            [chrt] => 0
            [parent] => 
            [comment] => 

*/
    //$this->log->aPrint( $data );
    //exit;
	  $sql = "UPDATE " . DB_PREFIX . "storelocator ";
	  $sql.= " SET accountno = '" . $this->db->escape($data['accountno']) . "',";
	  $sql.= "     name = '" . $this->db->escape($data['name']) . "',";
	  $sql.= "     storetype = '" . $this->db->escape($data['storetype']) . "',";
	  $sql.= "     address1 = '" . $this->db->escape($data['address1']) . "',";
    $sql.= "     city = '" . $this->db->escape($data['city']) . "',";
	  $sql.= "     state = '" . $this->db->escape($data['state']) . "',";
	  $sql.= "     zipcode = '" . $this->db->escape($data['zipcode']) . "',";
	  $sql.= "     phone1 = '" . $this->db->escape($data['phone1']) . "',";
	  $sql.= "     phone2 = '" . $this->db->escape($data['phone2']) . "',";
	  $sql.= "     salesrep = '" . $this->db->escape($data['salesrep']) . "',";
	  $sql.= "     status = '" . $this->db->escape($data['status']) . "',";
	  $sql.= "     chrt = '" . $this->db->escape($data['chrt']) . "',";
	  $sql.= "     parent = '" . $this->db->escape($data['parent']) . "',";
	  $sql.= "     lat = '" . $this->db->escape($data['lat']) . "',";
	  $sql.= "     lng = '" . $this->db->escape($data['lng']) . "',";
	  $sql.= "     comment = '" . $this->db->escape($data['comment']) . "'";
	  $sql.= " where id = '" . $this->db->escape($data['id']) . "'";
	  //echo $sql; exit;
    //$t1 = mb_detect_encoding($sql);
    //echo $t1;
    
    if($this->db->query($sql)){
      return true;
    }else{
      return false; 
    }
 		//todo. cache control , besso-201103
 		//$this->cache->delete('store');
	}

	public function editStore($store_id, $data) {
		$this->db->query("UPDATE " . DB_PREFIX . "store SET model = '" . $this->db->escape($data['model']) . "', sku = '" . $this->db->escape($data['sku']) . "', location = '" . $this->db->escape($data['location']) . "', quantity = '" . (int)$data['quantity'] . "', minimum = '" . (int)$data['minimum'] . "', subtract = '" . (int)$data['subtract'] . "', stock_status_id = '" . (int)$data['stock_status_id'] . "', date_available = '" . $this->db->escape($data['date_available']) . "', manufacturer_id = '" . (int)$data['manufacturer_id'] . "', shipping = '" . (int)$data['shipping'] . "', price = '" . (float)$data['price'] . "', cost = '" . (float)$data['cost'] . "', weight = '" . (float)$data['weight'] . "', weight_class_id = '" . (int)$data['weight_class_id'] . "', length = '" . (float)$data['length'] . "', width = '" . (float)$data['width'] . "', height = '" . (float)$data['height'] . "', length_class_id = '" . (int)$data['length_class_id'] . "', status = '" . (int)$data['status'] . "', tax_class_id = '" . (int)$data['tax_class_id'] . "', sort_order = '" . (int)$data['sort_order'] . "', date_modified = NOW() WHERE store_id = '" . (int)$store_id . "'");

		if (isset($data['image'])) {
			$this->db->query("UPDATE " . DB_PREFIX . "store SET image = '" . $this->db->escape($data['image']) . "' WHERE store_id = '" . (int)$store_id . "'");
		}

		$this->db->query("DELETE FROM " . DB_PREFIX . "store_description WHERE store_id = '" . (int)$store_id . "'");

		foreach ($data['store_description'] as $language_id => $value) {
			$this->db->query("INSERT INTO " . DB_PREFIX . "store_description SET store_id = '" . (int)$store_id . "', language_id = '" . (int)$language_id . "', name = '" . $this->db->escape($value['name']) . "', meta_keywords = '" . $this->db->escape($value['meta_keywords']) . "', meta_description = '" . $this->db->escape($value['meta_description']) . "', description = '" . $this->db->escape($value['description']) . "'");
		}

		$this->db->query("DELETE FROM " . DB_PREFIX . "storelocator WHERE store_id = '" . (int)$store_id . "'");

		if (isset($data['store_store'])) {
			foreach ($data['store_store'] as $store_id) {
				$this->db->query("INSERT INTO " . DB_PREFIX . "storelocator SET store_id = '" . (int)$store_id . "', store_id = '" . (int)$store_id . "'");
			}
		}

		$this->db->query("DELETE FROM " . DB_PREFIX . "store_option WHERE store_id = '" . (int)$store_id . "'");
		$this->db->query("DELETE FROM " . DB_PREFIX . "store_option_description WHERE store_id = '" . (int)$store_id . "'");
		$this->db->query("DELETE FROM " . DB_PREFIX . "store_option_value WHERE store_id = '" . (int)$store_id . "'");
		$this->db->query("DELETE FROM " . DB_PREFIX . "store_option_value_description WHERE store_id = '" . (int)$store_id . "'");

		if (isset($data['store_option'])) {
			foreach ($data['store_option'] as $store_option) {
				$this->db->query("INSERT INTO " . DB_PREFIX . "store_option SET store_id = '" . (int)$store_id . "', sort_order = '" . (int)$store_option['sort_order'] . "'");

				$store_option_id = $this->db->getLastId();

				foreach ($store_option['language'] as $language_id => $language) {
					$this->db->query("INSERT INTO " . DB_PREFIX . "store_option_description SET store_option_id = '" . (int)$store_option_id . "', language_id = '" . (int)$language_id . "', store_id = '" . (int)$store_id . "', name = '" . $this->db->escape($language['name']) . "'");
				}

				if (isset($store_option['store_option_value'])) {
					foreach ($store_option['store_option_value'] as $store_option_value) {
						$this->db->query("INSERT INTO " . DB_PREFIX . "store_option_value SET store_option_id = '" . (int)$store_option_id . "', store_id = '" . (int)$store_id . "', quantity = '" . (int)$store_option_value['quantity'] . "', subtract = '" . (int)$store_option_value['subtract'] . "', price = '" . (float)$store_option_value['price'] . "', prefix = '" . $this->db->escape($store_option_value['prefix']) . "', sort_order = '" . (int)$store_option_value['sort_order'] . "'");

						$store_option_value_id = $this->db->getLastId();

						foreach ($store_option_value['language'] as $language_id => $language) {
							$this->db->query("INSERT INTO " . DB_PREFIX . "store_option_value_description SET store_option_value_id = '" . (int)$store_option_value_id . "', language_id = '" . (int)$language_id . "', store_id = '" . (int)$store_id . "', name = '" . $this->db->escape($language['name']) . "'");
						}
					}
				}
			}
		}

		$this->db->query("DELETE FROM " . DB_PREFIX . "store_discount WHERE store_id = '" . (int)$store_id . "'");

		if (isset($data['store_discount'])) {
			foreach ($data['store_discount'] as $value) {
				$this->db->query("INSERT INTO " . DB_PREFIX . "store_discount SET store_id = '" . (int)$store_id . "', customer_group_id = '" . (int)$value['customer_group_id'] . "', quantity = '" . (int)$value['quantity'] . "', priority = '" . (int)$value['priority'] . "', price = '" . (float)$value['price'] . "', date_start = '" . $this->db->escape($value['date_start']) . "', date_end = '" . $this->db->escape($value['date_end']) . "'");
			}
		}

		$this->db->query("DELETE FROM " . DB_PREFIX . "store_special WHERE store_id = '" . (int)$store_id . "'");

		if (isset($data['store_special'])) {
			foreach ($data['store_special'] as $value) {
				$this->db->query("INSERT INTO " . DB_PREFIX . "store_special SET store_id = '" . (int)$store_id . "', customer_group_id = '" . (int)$value['customer_group_id'] . "', priority = '" . (int)$value['priority'] . "', price = '" . (float)$value['price'] . "', date_start = '" . $this->db->escape($value['date_start']) . "', date_end = '" . $this->db->escape($value['date_end']) . "'");
			}
		}

		$this->db->query("DELETE FROM " . DB_PREFIX . "store_image WHERE store_id = '" . (int)$store_id . "'");

		if (isset($data['store_image'])) {
			foreach ($data['store_image'] as $image) {
        		$this->db->query("INSERT INTO " . DB_PREFIX . "store_image SET store_id = '" . (int)$store_id . "', image = '" . $this->db->escape($image) . "'");
			}
		}

		$this->db->query("DELETE FROM " . DB_PREFIX . "store_to_download WHERE store_id = '" . (int)$store_id . "'");

		if (isset($data['store_download'])) {
			foreach ($data['store_download'] as $download_id) {
				$this->db->query("INSERT INTO " . DB_PREFIX . "store_to_download SET store_id = '" . (int)$store_id . "', download_id = '" . (int)$download_id . "'");
			}
		}

		$this->db->query("DELETE FROM " . DB_PREFIX . "store_to_category WHERE store_id = '" . (int)$store_id . "'");

		if (isset($data['store_category'])) {
			foreach ($data['store_category'] as $category_id) {
				$this->db->query("INSERT INTO " . DB_PREFIX . "store_to_category SET store_id = '" . (int)$store_id . "', category_id = '" . (int)$category_id . "'");
			}
		}

		$this->db->query("DELETE FROM " . DB_PREFIX . "store_related WHERE store_id = '" . (int)$store_id . "'");

		if (isset($data['store_related'])) {
			foreach ($data['store_related'] as $related_id) {
				$this->db->query("INSERT INTO " . DB_PREFIX . "store_related SET store_id = '" . (int)$store_id . "', related_id = '" . (int)$related_id . "'");
				$this->db->query("DELETE FROM " . DB_PREFIX . "store_related WHERE store_id = '" . (int)$related_id . "' AND related_id = '" . (int)$store_id . "'");
				$this->db->query("INSERT INTO " . DB_PREFIX . "store_related SET store_id = '" . (int)$related_id . "', related_id = '" . (int)$store_id . "'");
			}
		}

		$this->db->query("DELETE FROM " . DB_PREFIX . "url_alias WHERE query = 'store_id=" . (int)$store_id. "'");

		if ($data['keyword']) {
			$this->db->query("INSERT INTO " . DB_PREFIX . "url_alias SET query = 'store_id=" . (int)$store_id . "', keyword = '" . $this->db->escape($data['keyword']) . "'");
		}

		$this->db->query("DELETE FROM " . DB_PREFIX . "store_tags WHERE store_id = '" . (int)$store_id. "'");

		foreach ($data['store_tags'] as $language_id => $value) {
			$tags = explode(',', $value);
			foreach ($tags as $tag) {
				$this->db->query("INSERT INTO " . DB_PREFIX . "store_tags SET store_id = '" . (int)$store_id . "', language_id = '" . (int)$language_id . "', tag = '" . $this->db->escape(trim($tag)) . "'");
			}
		}

		$this->cache->delete('store');
	}

	public function copyStore($store_id) {
		$query = $this->db->query("SELECT DISTINCT * FROM " . DB_PREFIX . "store p LEFT JOIN " . DB_PREFIX . "store_description pd ON (p.store_id = pd.store_id) WHERE p.store_id = '" . (int)$store_id . "' AND pd.language_id = '" . (int)$this->config->get('config_language_id') . "'");

		if ($query->num_rows) {
			$data = array();

			$data = $query->row;

			$data = array_merge($data, array('store_description' => $this->getStoreDescriptions($store_id)));
			$data = array_merge($data, array('store_option' => $this->getStoreOptions($store_id)));

			$data['keyword'] = '';

			$data['status'] = '1';

            foreach(array_keys($data['store_description']) as $key) {
                $data['store_description'][$key]['name'] = $data['store_description'][$key]['name'] . '*';
            }

			$data['store_image'] = array();

			$results = $this->getStoreImages($store_id);

			foreach ($results as $result) {
				$data['store_image'][] = $result['image'];
			}

			$data = array_merge($data, array('store_discount' => $this->getStoreDiscounts($store_id)));
			$data = array_merge($data, array('store_special' => $this->getStoreSpecials($store_id)));
			$data = array_merge($data, array('store_download' => $this->getStoreDownloads($store_id)));
			$data = array_merge($data, array('store_category' => $this->getStoreCategories($store_id)));
			$data = array_merge($data, array('store_store' => $this->getStoreStores($store_id)));
			$data = array_merge($data, array('store_related' => $this->getStoreRelated($store_id)));
			$data = array_merge($data, array('store_tags' => $this->getStoreTags($store_id)));

			$this->addStore($data);
		}
	}

	public function deleteStore($store_id) {
		$this->db->query("DELETE FROM " . DB_PREFIX . "store WHERE store_id = '" . (int)$store_id . "'");
		$this->db->query("DELETE FROM " . DB_PREFIX . "store_description WHERE store_id = '" . (int)$store_id . "'");
		$this->db->query("DELETE FROM " . DB_PREFIX . "store_option WHERE store_id = '" . (int)$store_id . "'");
		$this->db->query("DELETE FROM " . DB_PREFIX . "store_option_description WHERE store_id = '" . (int)$store_id . "'");
		$this->db->query("DELETE FROM " . DB_PREFIX . "store_option_value WHERE store_id = '" . (int)$store_id . "'");
		$this->db->query("DELETE FROM " . DB_PREFIX . "store_option_value_description WHERE store_id = '" . (int)$store_id . "'");
		$this->db->query("DELETE FROM " . DB_PREFIX . "store_discount WHERE store_id = '" . (int)$store_id . "'");
		$this->db->query("DELETE FROM " . DB_PREFIX . "store_image WHERE store_id = '" . (int)$store_id . "'");
		$this->db->query("DELETE FROM " . DB_PREFIX . "store_related WHERE store_id = '" . (int)$store_id . "'");
		$this->db->query("DELETE FROM " . DB_PREFIX . "store_to_download WHERE store_id = '" . (int)$store_id . "'");
		$this->db->query("DELETE FROM " . DB_PREFIX . "store_to_category WHERE store_id = '" . (int)$store_id . "'");
		$this->db->query("DELETE FROM " . DB_PREFIX . "review WHERE store_id = '" . (int)$store_id . "'");
		$this->db->query("DELETE FROM " . DB_PREFIX . "storelocator WHERE store_id = '" . (int)$store_id . "'");
		$this->db->query("DELETE FROM " . DB_PREFIX . "url_alias WHERE query = 'store_id=" . (int)$store_id. "'");
		$this->db->query("DELETE FROM " . DB_PREFIX . "store_tags WHERE store_id='" . (int)$store_id. "'");

		$this->cache->delete('store');
	}

	public function addFeatured($data) {
      	$this->db->query("DELETE FROM " . DB_PREFIX . "store_featured");

		if (isset($data['store_featured'])) {
      		foreach ($data['store_featured'] as $store_id) {
        		$this->db->query("INSERT INTO " . DB_PREFIX . "store_featured SET store_id = '" . (int)$store_id . "'");
      		}
		}
	}

	public function getFeaturedStores() {
		$store_featured_data = array();

		$query = $this->db->query("SELECT store_id FROM " . DB_PREFIX . "store_featured");

		foreach ($query->rows as $result) {
			$store_featured_data[] = $result['store_id'];
		}
		return $store_featured_data;
	}

	public function getStoresByKeyword($keyword) {
		if ($keyword) {
			$query = $this->db->query("SELECT * FROM " . DB_PREFIX . "store p LEFT JOIN " . DB_PREFIX . "store_description pd ON (p.store_id = pd.store_id) WHERE pd.language_id = '" . (int)$this->config->get('config_language_id') . "' AND (LCASE(pd.name) LIKE '%" . $this->db->escape(strtolower($keyword)) . "%' OR LCASE(p.model) LIKE '%" . $this->db->escape(strtolower($keyword)) . "%')");

			return $query->rows;
		} else {
			return array();
		}
	}

	public function getStoresByCategoryId($category_id) {
		$query = $this->db->query("SELECT * FROM " . DB_PREFIX . "store p LEFT JOIN " . DB_PREFIX . "store_description pd ON (p.store_id = pd.store_id) LEFT JOIN " . DB_PREFIX . "store_to_category p2c ON (p.store_id = p2c.store_id) WHERE pd.language_id = '" . (int)$this->config->get('config_language_id') . "' AND p2c.category_id = '" . (int)$category_id . "' ORDER BY pd.name ASC");

		return $query->rows;
	}

	public function getStoreDescriptions($store_id) {
		$store_description_data = array();

		$query = $this->db->query("SELECT * FROM " . DB_PREFIX . "store_description WHERE store_id = '" . (int)$store_id . "'");

		foreach ($query->rows as $result) {
			$store_description_data[$result['language_id']] = array(
				'name'             => $result['name'],
				'meta_keywords'    => $result['meta_keywords'],
				'meta_description' => $result['meta_description'],
				'description'      => $result['description']
			);
		}

		return $store_description_data;
	}

	public function getStoreOptions($store_id) {
		$store_option_data = array();

		$store_option = $this->db->query("SELECT * FROM " . DB_PREFIX . "store_option WHERE store_id = '" . (int)$store_id . "' ORDER BY sort_order");

		foreach ($store_option->rows as $store_option) {
			$store_option_value_data = array();

			$store_option_value = $this->db->query("SELECT * FROM " . DB_PREFIX . "store_option_value WHERE store_option_id = '" . (int)$store_option['store_option_id'] . "' ORDER BY sort_order");

			foreach ($store_option_value->rows as $store_option_value) {
				$store_option_value_description_data = array();

				$store_option_value_description = $this->db->query("SELECT * FROM " . DB_PREFIX . "store_option_value_description WHERE store_option_value_id = '" . (int)$store_option_value['store_option_value_id'] . "'");

				foreach ($store_option_value_description->rows as $result) {
					$store_option_value_description_data[$result['language_id']] = array('name' => $result['name']);
				}

				$store_option_value_data[] = array(
					'store_option_value_id' => $store_option_value['store_option_value_id'],
					'language'                => $store_option_value_description_data,
         	'quantity'                => $store_option_value['quantity'],
					'subtract'                => $store_option_value['subtract'],
					'price'                   => $store_option_value['price'],
         	'prefix'                  => $store_option_value['prefix'],
					'sort_order'              => $store_option_value['sort_order']
				);
			}

			$store_option_description_data = array();

			$store_option_description = $this->db->query("SELECT * FROM " . DB_PREFIX . "store_option_description WHERE store_option_id = '" . (int)$store_option['store_option_id'] . "'");

			foreach ($store_option_description->rows as $result) {
				$store_option_description_data[$result['language_id']] = array('name' => $result['name']);
			}

        	$store_option_data[] = array(
        		'store_option_id'    => $store_option['store_option_id'],
				    'language'             => $store_option_description_data,
				    'store_option_value' => $store_option_value_data,
				    'sort_order'           => $store_option['sort_order']
        	);
      	}

		return $store_option_data;
	}

	public function getStoreImages($store_id) {
		$query = $this->db->query("SELECT * FROM " . DB_PREFIX . "store_image WHERE store_id = '" . (int)$store_id . "'");

		return $query->rows;
	}

	public function getStoreDiscounts($store_id) {
		$query = $this->db->query("SELECT * FROM " . DB_PREFIX . "store_discount WHERE store_id = '" . (int)$store_id . "' ORDER BY quantity, priority, price");

		return $query->rows;
	}

	public function getStoreSpecials($store_id) {
		$query = $this->db->query("SELECT * FROM " . DB_PREFIX . "store_special WHERE store_id = '" . (int)$store_id . "' ORDER BY priority, price");

		return $query->rows;
	}

	public function getStoreDownloads($store_id) {
		$store_download_data = array();

		$query = $this->db->query("SELECT * FROM " . DB_PREFIX . "store_to_download WHERE store_id = '" . (int)$store_id . "'");

		foreach ($query->rows as $result) {
			$store_download_data[] = $result['download_id'];
		}

		return $store_download_data;
	}

  // todo. get one store
	public function getStoreStores($store_id) {
		$store_store_data = array();
		$query = $this->db->query("SELECT * FROM " . DB_PREFIX . "storelocator WHERE store_id = '" . (int)$store_id . "'");
		foreach ($query->rows as $result) {
			$store_store_data[] = $result['store_id'];
		}
		return $store_store_data;
	}

	public function getStoreCategories($store_id) {
		$store_category_data = array();

		$query = $this->db->query("SELECT * FROM " . DB_PREFIX . "store_to_category WHERE store_id = '" . (int)$store_id . "'");

		foreach ($query->rows as $result) {
			$store_category_data[] = $result['category_id'];
		}

		return $store_category_data;
	}

	public function getStoreRelated($store_id) {
		$store_related_data = array();

		$query = $this->db->query("SELECT * FROM " . DB_PREFIX . "store_related WHERE store_id = '" . (int)$store_id . "'");

		foreach ($query->rows as $result) {
			$store_related_data[] = $result['related_id'];
		}

		return $store_related_data;
	}

	public function getStoreTags($store_id) {
		$store_tag_data = array();

		$query = $this->db->query("SELECT * FROM " . DB_PREFIX . "store_tags WHERE store_id = '" . (int)$store_id . "'");

		$tag_data = array();

		foreach ($query->rows as $result) {
			$tag_data[$result['language_id']][] = $result['tag'];
		}

		foreach ($tag_data as $language => $tags) {
			$store_tag_data[$language] = implode(',', $tags);
		}

		return $store_tag_data;
	}

	public function getTotalStoresByStockStatusId($stock_status_id) {
      	$query = $this->db->query("SELECT COUNT(*) AS total FROM " . DB_PREFIX . "store WHERE stock_status_id = '" . (int)$stock_status_id . "'");

		return $query->row['total'];
	}

	public function getTotalStoresByImageId($image_id) {
      	$query = $this->db->query("SELECT COUNT(*) AS total FROM " . DB_PREFIX . "store WHERE image_id = '" . (int)$image_id . "'");

		return $query->row['total'];
	}

	public function getTotalStoresByTaxClassId($tax_class_id) {
      	$query = $this->db->query("SELECT COUNT(*) AS total FROM " . DB_PREFIX . "store WHERE tax_class_id = '" . (int)$tax_class_id . "'");

		return $query->row['total'];
	}

	public function getTotalStoresByWeightClassId($weight_class_id) {
      	$query = $this->db->query("SELECT COUNT(*) AS total FROM " . DB_PREFIX . "store WHERE weight_class_id = '" . (int)$weight_class_id . "'");

		return $query->row['total'];
	}

	public function getTotalStoresByLengthClassId($length_class_id) {
      	$query = $this->db->query("SELECT COUNT(*) AS total FROM " . DB_PREFIX . "store WHERE length_class_id = '" . (int)$length_class_id . "'");

		return $query->row['total'];
	}

	public function getTotalStoresByOptionId($option_id) {
      	$query = $this->db->query("SELECT COUNT(*) AS total FROM " . DB_PREFIX . "store_to_option WHERE option_id = '" . (int)$option_id . "'");

		return $query->row['total'];
	}

	public function getTotalStoresByDownloadId($download_id) {
      	$query = $this->db->query("SELECT COUNT(*) AS total FROM " . DB_PREFIX . "store_to_download WHERE download_id = '" . (int)$download_id . "'");

		return $query->row['total'];
	}

	public function getTotalStoresByManufacturerId($manufacturer_id) {
      	$query = $this->db->query("SELECT COUNT(*) AS total FROM " . DB_PREFIX . "store WHERE manufacturer_id = '" . (int)$manufacturer_id . "'");

		return $query->row['total'];
	}

  // todo. get one store
	public function getOneStore($store_id) {
    $sql = "SELECT * FROM " . DB_PREFIX . "storelocator WHERE id = '" . (int)$store_id . "'";
		$query = $this->db->query($sql);
		return $query->row;
	}

	public function getStoreHistory($accountno){
    /* making senario , besso-201103
    insert into store_history values('PA8077','AK','2010-10-10','');
    insert into store_history values('PA8077','YK','2011-01-10','');
    insert into store_history values('PA8077','JU','2011-02-10','');
    */
    $sql = "select *, (select comment from storelocator where accountno = '$accountno') as commnet
              from store_history where accountno = '$accountno' order by assign_date";
    //echo $sql;
		$query = $this->db->query($sql);
		return $query->rows;
	}
}
?>