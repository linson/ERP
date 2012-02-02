<?php
class ModelStoreStore extends Model {
  // crond function
  public function storeList(){
    $sql = "select accountno "; //into outfile '/var/lib/asterisk/backyard/data/store.list' ";
    $sql.= "  from storelocator order by accountno";
    $query = $this->db->query($sql);
    return $query->rows;
  }

  public function getStoreOwner($accountno){
    $sql = "select salesrep from storelocator where accountno = '$accountno'";
    $query = $this->db->query($sql);
    return $query->row;
  }

  public function getStoreID($accountno){
    $sql = "select id from storelocator where accountno = '$accountno'";
    $query = $this->db->query($sql);
    return $query->row;
  }

  public function getStore($request=array(),&$export_qry){
		$res = array();
		if($request){
			$sql = "SELECT s.* , t1.balance_total as balance FROM storelocator s left join ";
			$sql.= " ( select store_id , sum(balance) as balance_total from transaction where 1 = 1 ";
		  if(isset($request['filter_order_date_from']) && !is_null($request['filter_order_date_from'])){
		  	$sql .= " AND LCASE(order_date) between '" . $this->db->escape(strtolower($request['filter_order_date_from'])) . "' and '" . $this->db->escape(strtolower($request['filter_order_date_to'])) . "'";
		  }
			$sql.= " group by store_id ) t1 ";
			$sql.= " on s.id = t1.store_id where 1 = 1 ";

			if(isset($request['filter_name']) && !is_null($request['filter_name'])){
				$sql .= " AND LCASE(s.name) LIKE '%" . $this->db->escape(strtolower($request['filter_name'])) . "%'";
			}
			if(isset($request['filter_accountno']) && !is_null($request['filter_accountno'])){
				$sql .= " AND LCASE(s.accountno) like '%" . $this->db->escape(strtolower($request['filter_accountno'])) . "%'";
			}
			if(isset($request['filter_storetype']) && !is_null($request['filter_storetype'])){
				$sql .= " AND LCASE(s.storetype) = '" . $this->db->escape(strtolower($request['filter_storetype'])) . "'";
			}
			if(isset($request['filter_address1']) && !is_null($request['filter_address1'])){
				$sql .= " AND LCASE(s.address1) LIKE '%" . $this->db->escape(strtolower($request['filter_address1'])) . "%'";
			}
			if(isset($request['filter_city']) && !is_null($request['filter_city'])){
				$sql .= " AND LCASE(s.city) LIKE '%" . $this->db->escape(strtolower($request['filter_city'])) . "%'";
			}
			if(isset($request['filter_state']) && !is_null($request['filter_state'])){
				$sql .= " AND LCASE(s.state) like '%" . $this->db->escape(strtolower($request['filter_state'])) . "%'";
			}
			if(isset($request['filter_zipcode']) && !is_null($request['filter_zipcode'])){
				$sql .= " AND LCASE(s.zipcode) = '" . $this->db->escape(strtolower($request['filter_zipcode'])) . "'";
			}
			if(isset($request['filter_phone1']) && !is_null($request['filter_phone1'])){
				$sql .= " AND LCASE(s.phone1) LIKE '%" . $this->db->escape(strtolower($request['filter_phone1'])) . "%'";
			}
			if(isset($request['filter_chrt']) && '' != $request['filter_chrt']){
				$sql .= " AND LCASE(s.chrt) = '" . $this->db->escape(strtolower($request['filter_chrt'])) . "'";
			}
			if(isset($request['filter_status']) && '' != $request['filter_status']){
				$sql .= " AND LCASE(s.status) = '" . $this->db->escape(strtolower($request['filter_status'])) . "'";
			}
			if(isset($request['filter_salesrep']) && !is_null($request['filter_salesrep'])){
			  //todo. change to like statement - rollback
				$sql .= " AND s.salesrep = ( select username from user where user_group_id in (1,10,11) and LCASE(username) = '" . $this->db->escape(strtolower($request['filter_salesrep'])) . "')";
			}
			//$sql .= " and substr(s.zipcode,1,1) = '0'";
			if(isset($request['filter_balance']) && !is_null($request['filter_balance'])){
			  $filter_balance = $request['filter_balance'];
        $sql .= " and t1.balance_total > $filter_balance ";
  		}
      $sort_data = array('name','status','storetype','salesrep');
			if(isset($request['sort']) && in_array($request['sort'], $sort_data)){
				$sql .= " ORDER BY " . $request['sort'];
			}else{
				$sql .= " ORDER BY s.accountno";
			}
			if(isset($request['order']) && ($request['order'] == 'DESC')){
				$sql .= " DESC";
			}else{
				$sql .= " ASC";
			}
      if( isset($request['filter_page']) &&  !is_null($request['filter_page'])  ){
		    $request['start'] = 20 * ( $request['filter_page'] - 1 ); 
		  }

      // todo. export_qry need not limit ext , besso-201103 
      $export_qry = $sql;

			if(isset($request['start']) || isset($request['limit'])){
				if($request['start'] < 0){
					$request['start'] = 0;
				}
				if($request['limit'] < 1){
					$request['limit'] = 20;
				}
				$sql .= " LIMIT " . (int)$request['start'] . "," . (int)$request['limit'];
			}
      //$this->log->aPrint( $sql );
      $query = $this->db->query($sql);
			//$res = $query->rows;
			$aRtn = array();
			$i = 0;
			foreach($query->rows as $row){
			  $store_id = $row['id'];
			  $sql = "select order_date,order_price from transaction where store_id = $store_id";
			  $query_tx = $this->db->query($sql);
			  $row['tx'] = $query_tx->rows;
			  $aRtn[$i] = $row;
			  $i++;
			  //$this->log->aPrint( $row );
			}
			//$this->log->aPrint( $aRtn );
			return $aRtn;
		}else{
			$response = $this->cache->get('storelocator.' . $this->config->get('config_language_id'));
			if(!$response){
				$query = $this->db->query("SELECT * FROM storelocator");
				$response = $query->rows;
				$this->cache->set('storelocator.' . $this->config->get('config_language_id'), $response);
			}
			$res = $response;
		}
    return $res;
	}

	public function getTotalStore($request=array()){
		if($request){
			$sql = "SELECT count(*) as total FROM storelocator s left join ";
			$sql.= " ( select store_id , sum(balance) as balance_total from transaction where balance > 0 ";
		  if(isset($request['filter_order_date_from']) && !is_null($request['filter_order_date_from'])){
		  	$sql .= " AND LCASE(order_date) between '" . $this->db->escape(strtolower($request['filter_order_date_from'])) . "' and '" . $this->db->escape(strtolower($request['filter_order_date_to'])) . "'";
		  }
			$sql.= " group by store_id ) t1 ";
			$sql.= " on s.id = t1.store_id where 1 = 1 ";
			if(isset($request['filter_name']) && !is_null($request['filter_name'])){
				$sql .= " AND LCASE(s.name) LIKE '%" . $this->db->escape(strtolower($request['filter_name'])) . "%'";
			}
			if(isset($request['filter_accountno']) && !is_null($request['filter_accountno'])){
				$sql .= " AND LCASE(s.accountno) like '%" . $this->db->escape(strtolower($request['filter_accountno'])) . "%'";
			}
			if(isset($request['filter_storetype']) && !is_null($request['filter_storetype'])){
				$sql .= " AND LCASE(s.storetype) = '" . $this->db->escape(strtolower($request['filter_storetype'])) . "'";
			}
			if(isset($request['filter_address1']) && !is_null($request['filter_address1'])){
				$sql .= " AND LCASE(s.address1) LIKE '%" . $this->db->escape(strtolower($request['filter_address1'])) . "%'";
			}
			if(isset($request['filter_city']) && !is_null($request['filter_city'])){
				$sql .= " AND LCASE(s.city) LIKE '%" . $this->db->escape(strtolower($request['filter_city'])) . "%'";
			}
			if(isset($request['filter_state']) && !is_null($request['filter_state'])){
				$sql .= " AND LCASE(s.state) like '%" . $this->db->escape(strtolower($request['filter_state'])) . "%'";
			}
			if(isset($request['filter_zipcode']) && !is_null($request['filter_zipcode'])){
				$sql .= " AND LCASE(s.zipcode) = '" . $this->db->escape(strtolower($request['filter_zipcode'])) . "'";
			}
			if(isset($request['filter_phone1']) && !is_null($request['filter_phone1'])){
				$sql .= " AND LCASE(s.phone1) LIKE '%" . $this->db->escape(strtolower($request['filter_phone1'])) . "%'";
			}
			if(isset($request['filter_chrt']) && '' != $request['filter_chrt']){
				$sql .= " AND LCASE(s.chrt) = '" . $this->db->escape(strtolower($request['filter_chrt'])) . "'";
			}
			if(isset($request['filter_status']) && '' != $request['filter_status']){
				$sql .= " AND LCASE(s.status) = '" . $this->db->escape(strtolower($request['filter_status'])) . "'";
			}
			if(isset($request['filter_salesrep']) && !is_null($request['filter_salesrep'])){
				$sql .= " AND s.salesrep = ( select username from user where user_group_id in (1,10,11) and LCASE(username) = '" . $this->db->escape(strtolower($request['filter_salesrep'])) . "')";
			}
			if(isset($request['filter_balance']) && !is_null($request['filter_balance'])){
			  $filter_balance = $request['filter_balance'];
        $sql .= " and t1.balance_total > $filter_balance ";
  		}
      //$this->log->aPrint( $sql );
			$query = $this->db->query($sql);
		}else{
			$query = $this->db->query("SELECT * as total FROM storelocator");
		}
    $res = $query->rows[0]['total'];
    return $res;
	}

  /* update store , besso-201103 */
	public function updateStore($data){
    $aDC = array();
    if($data['dc1'] >0) $aDC[0] = $data['dc1'] .'|'. $data['dc1_desc'];
    if($data['dc2'] >0) $aDC[1] = $data['dc2'] .'|'. $data['dc2_desc'];

    $dc = ( count($aDC) > 0 ) ? json_encode($aDC) : '';
    //$this->log->aPrint( $dc );
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
	  $sql.= "     fax = '" . $this->db->escape($data['fax']) . "',";
	  $sql.= "     salesrep = '" . $this->db->escape($data['salesrep']) . "',";
	  $sql.= "     status = '" . $this->db->escape($data['status']) . "',";
	  $sql.= "     chrt = '" . $this->db->escape($data['chrt']) . "',";
	  $sql.= "     parent = '" . $this->db->escape($data['parent']) . "',";
	  $sql.= "     lat = '" . $this->db->escape($data['lat']) . "',";
	  $sql.= "     lng = '" . $this->db->escape($data['lng']) . "',";
	  $sql.= "     email = '" . $this->db->escape($data['email']) . "',";
	  $sql.= "     billto = '" . $this->db->escape($data['billto']) . "',";
	  $sql.= "     shipto = '" . $this->db->escape($data['shipto']) . "',";
	  $sql.= "     comment  = '" . $this->db->escape($data['comment']) . "',";
	  $sql.= "     owner  = '" . $this->db->escape($data['contact']) . "',";
	  $sql.= "     discount = '" . $this->db->escape($dc) . "'";
	  $sql.= " where id = '" . $this->db->escape($data['id']) . "'";
    //$this->log->aPrint( $sql );
    if($this->db->query($sql)){
      return true;
    }else{
      return false; 
    }
 		//todo. cache control , besso-201103
 		//$this->cache->delete('store');
	}

  /* update store , besso-201103 */
	public function insertStore($data){
    $aDC = array(
      $data['dc1_desc'] => $data['dc1'] ,
      $data['dc2_desc'] => $data['dc2'] ,
      $data['dc3_desc'] => $data['dc3'] 
    );

    $dc = json_encode($aDC);

    //$this->log->aPrint( $data );
    //exit;
	  $sql = "insert into storelocator (accountno,name,storetype,address1,city,state,zipcode,phone1,phone2,salesrep,status,fax,chrt,parent,email,discount) values";
	  $sql.= " ( '" . $this->db->escape($data['accountno']) . "',";
	  $sql.= "   '" . $this->db->escape($data['name']) . "',";
	  $sql.= "   '" . $this->db->escape($data['storetype']) . "',";
	  $sql.= "   '" . $this->db->escape($data['address1']) . "',";
    $sql.= "   '" . $this->db->escape($data['city']) . "',";
	  $sql.= "   '" . $this->db->escape($data['state']) . "',";
	  $sql.= "   '" . $this->db->escape($data['zipcode']) . "',";
	  $sql.= "   '" . $this->db->escape($data['phone1']) . "',";
	  $sql.= "   '" . $this->db->escape($data['phone2']) . "',";
	  $sql.= "   '" . $this->db->escape($data['salesrep']) . "',";
	  $sql.= "   '" . $this->db->escape($data['status']) . "',";
	  $sql.= "   '" . $this->db->escape($data['fax']) . "',";
	  $sql.= "   '" . $this->db->escape($data['chrt']) . "',";
	  $sql.= "   '" . $this->db->escape($data['parent']) . "',";
	  $sql.= "   '" . $this->db->escape($data['email']) . "',";
	  $sql.= "   '" . $this->db->escape($dc) . "' )";
    //n$this->log->aPrint( $sql );
    if($this->db->query($sql)){
      return true;
    }else{
      return false; 
    }
 		//todo. cache control , besso-201103
 		//$this->cache->delete('store');
	}

	public function deleteStore($store_id){
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

	public function addFeatured($data){
   	$this->db->query("DELETE FROM " . DB_PREFIX . "store_featured");
		if(isset($data['store_featured'])){
  		foreach ($data['store_featured'] as $store_id){
    		$this->db->query("INSERT INTO " . DB_PREFIX . "store_featured SET store_id = '" . (int)$store_id . "'");
  		}
		}
	}

	public function getFeaturedStores(){
		$store_featured_data = array();
		$query = $this->db->query("SELECT store_id FROM " . DB_PREFIX . "store_featured");
		foreach ($query->rows as $result){
			$store_featured_data[] = $result['store_id'];
		}
		return $store_featured_data;
	}

	public function getStoresByKeyword($keyword){
		if($keyword){
			$query = $this->db->query("SELECT * FROM " . DB_PREFIX . "store p LEFT JOIN " . DB_PREFIX . "store_description pd ON (p.store_id = pd.store_id) WHERE pd.language_id = '" . (int)$this->config->get('config_language_id') . "' AND (LCASE(pd.name) LIKE '%" . $this->db->escape(strtolower($keyword)) . "%' OR LCASE(p.model) LIKE '%" . $this->db->escape(strtolower($keyword)) . "%')");
			return $query->rows;
		}else{
			return array();
		}
	}

	public function getStoresByCategoryId($category_id){
		$query = $this->db->query("SELECT * FROM " . DB_PREFIX . "store p LEFT JOIN " . DB_PREFIX . "store_description pd ON (p.store_id = pd.store_id) LEFT JOIN " . DB_PREFIX . "store_to_category p2c ON (p.store_id = p2c.store_id) WHERE pd.language_id = '" . (int)$this->config->get('config_language_id') . "' AND p2c.category_id = '" . (int)$category_id . "' ORDER BY pd.name ASC");
		return $query->rows;
	}

	public function getStoreDescriptions($store_id){
		$store_description_data = array();
		$query = $this->db->query("SELECT * FROM " . DB_PREFIX . "store_description WHERE store_id = '" . (int)$store_id . "'");
		foreach ($query->rows as $result){
			$store_description_data[$result['language_id']] = array(
				'name'             => $result['name'],
				'meta_keywords'    => $result['meta_keywords'],
				'meta_description' => $result['meta_description'],
				'description'      => $result['description']
			);
		}

		return $store_description_data;
	}

	public function getStoreOptions($store_id){
		$store_option_data = array();
		$store_option = $this->db->query("SELECT * FROM " . DB_PREFIX . "store_option WHERE store_id = '" . (int)$store_id . "' ORDER BY sort_order");
		foreach ($store_option->rows as $store_option){
			$store_option_value_data = array();
			$store_option_value = $this->db->query("SELECT * FROM " . DB_PREFIX . "store_option_value WHERE store_option_id = '" . (int)$store_option['store_option_id'] . "' ORDER BY sort_order");
			foreach ($store_option_value->rows as $store_option_value){
				$store_option_value_description_data = array();
				$store_option_value_description = $this->db->query("SELECT * FROM " . DB_PREFIX . "store_option_value_description WHERE store_option_value_id = '" . (int)$store_option_value['store_option_value_id'] . "'");
				foreach ($store_option_value_description->rows as $result){
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
			foreach ($store_option_description->rows as $result){
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

	public function getStoreImages($store_id){
		$query = $this->db->query("SELECT * FROM " . DB_PREFIX . "store_image WHERE store_id = '" . (int)$store_id . "'");
		return $query->rows;
	}

	public function getStoreDiscounts($store_id){
		$query = $this->db->query("SELECT * FROM " . DB_PREFIX . "store_discount WHERE store_id = '" . (int)$store_id . "' ORDER BY quantity, priority, price");
		return $query->rows;
	}

	public function getStoreSpecials($store_id){
		$query = $this->db->query("SELECT * FROM " . DB_PREFIX . "store_special WHERE store_id = '" . (int)$store_id . "' ORDER BY priority, price");
		return $query->rows;
	}

	public function getStoreDownloads($store_id){
		$store_download_data = array();
		$query = $this->db->query("SELECT * FROM " . DB_PREFIX . "store_to_download WHERE store_id = '" . (int)$store_id . "'");
		foreach ($query->rows as $result){
			$store_download_data[] = $result['download_id'];
		}
		return $store_download_data;
	}

  // todo. get one store
	public function getStoreStores($store_id){
		$store_store_data = array();
		$query = $this->db->query("SELECT * FROM " . DB_PREFIX . "storelocator WHERE store_id = '" . (int)$store_id . "'");
		foreach ($query->rows as $result){
			$store_store_data[] = $result['store_id'];
		}
		return $store_store_data;
	}

	public function getStoreCategories($store_id){
		$store_category_data = array();
		$query = $this->db->query("SELECT * FROM " . DB_PREFIX . "store_to_category WHERE store_id = '" . (int)$store_id . "'");
		foreach ($query->rows as $result){
			$store_category_data[] = $result['category_id'];
		}
		return $store_category_data;
	}

	public function getStoreRelated($store_id){
		$store_related_data = array();
		$query = $this->db->query("SELECT * FROM " . DB_PREFIX . "store_related WHERE store_id = '" . (int)$store_id . "'");
		foreach ($query->rows as $result){
			$store_related_data[] = $result['related_id'];
		}
		return $store_related_data;
	}

	public function getStoreTags($store_id){
		$store_tag_data = array();
		$query = $this->db->query("SELECT * FROM " . DB_PREFIX . "store_tags WHERE store_id = '" . (int)$store_id . "'");
		$tag_data = array();
		foreach ($query->rows as $result){
			$tag_data[$result['language_id']][] = $result['tag'];
		}
		foreach ($tag_data as $language => $tags){
			$store_tag_data[$language] = implode(',', $tags);
		}
		return $store_tag_data;
	}

	public function getTotalStoresByStockStatusId($stock_status_id){
   	$query = $this->db->query("SELECT COUNT(*) AS total FROM " . DB_PREFIX . "store WHERE stock_status_id = '" . (int)$stock_status_id . "'");
		return $query->row['total'];
	}

	public function getTotalStoresByImageId($image_id){
   	$query = $this->db->query("SELECT COUNT(*) AS total FROM " . DB_PREFIX . "store WHERE image_id = '" . (int)$image_id . "'");
		return $query->row['total'];
	}

	public function getTotalStoresByTaxClassId($tax_class_id){
   	$query = $this->db->query("SELECT COUNT(*) AS total FROM " . DB_PREFIX . "store WHERE tax_class_id = '" . (int)$tax_class_id . "'");
		return $query->row['total'];
	}

	public function getTotalStoresByWeightClassId($weight_class_id){
   	$query = $this->db->query("SELECT COUNT(*) AS total FROM " . DB_PREFIX . "store WHERE weight_class_id = '" . (int)$weight_class_id . "'");
		return $query->row['total'];
	}

	public function getTotalStoresByLengthClassId($length_class_id){
   	$query = $this->db->query("SELECT COUNT(*) AS total FROM " . DB_PREFIX . "store WHERE length_class_id = '" . (int)$length_class_id . "'");
		return $query->row['total'];
	}

	public function getTotalStoresByOptionId($option_id){
   	$query = $this->db->query("SELECT COUNT(*) AS total FROM " . DB_PREFIX . "store_to_option WHERE option_id = '" . (int)$option_id . "'");
		return $query->row['total'];
	}

	public function getTotalStoresByDownloadId($download_id){
   	$query = $this->db->query("SELECT COUNT(*) AS total FROM " . DB_PREFIX . "store_to_download WHERE download_id = '" . (int)$download_id . "'");
		return $query->row['total'];
	}

	public function getTotalStoresByManufacturerId($manufacturer_id){
   	$query = $this->db->query("SELECT COUNT(*) AS total FROM " . DB_PREFIX . "store WHERE manufacturer_id = '" . (int)$manufacturer_id . "'");
		return $query->row['total'];
	}

  // todo. get one store
	public function getOneStore($store_id){
    $sql = "SELECT * FROM " . DB_PREFIX . "storelocator WHERE id = '" . (int)$store_id . "'";
		//$this->log->aPrint( $sql );
		$query = $this->db->query($sql);
		return $query->row;
	}

	public function getStoreHistory($accountno){
    $sql = "select *, (select comment from storelocator where accountno = '$accountno') as commnet
              from store_history where accountno = '$accountno' order by assign_date";
		$query = $this->db->query($sql);
		return $query->rows;
	}

	public function updateComment($store_id,$comment){
	  $sql = "update storelocator set comment = '$comment' where id = $store_id";
	  if($query = $this->db->query($sql)){
  	  return true;
  	}else{
  	  return false;
  	}
	}

	public function getLatLng($account){
	  $account = strtoupper($account);
	  $sql = "select lat,lng from storelocator where accountno = '$account'";
	  //$this->log->aPrint( $sql );
	  $query = $this->db->query($sql);
  	return $query->row;
	}

}
?>