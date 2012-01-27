<?php
class ModelMaterialHistory extends Model{
  public function getHistory($data = array()){
		if($data){
			$sql = "SELECT * FROM package p, package_history ph where p.code = ph.code and p.status = '1'";
			if(isset($data['filter_code']) && !is_null($data['filter_code'])){
				$sql .= " AND LCASE(ph.code) LIKE '%" . $this->db->escape(strtolower($data['filter_code'])) . "%'";
			}
			if(isset($data['filter_name']) && !is_null($data['filter_name'])){
				$sql .= " AND LCASE(p.name) LIKE '%" . $this->db->escape(strtolower($data['filter_name'])) . "%'";
			}
			if(isset($data['filter_name']) && !is_null($data['filter_name'])){
				$sql .= " AND LCASE(p.name) LIKE '%" . $this->db->escape(strtolower($data['filter_name'])) . "%'";
			}
			if(isset($data['filter_product']) && !is_null($data['filter_product'])){
				$sql .= " AND LCASE(ph.final) LIKE '%" . $this->db->escape(strtolower($data['filter_product'])) . "%'";
			}
			if(isset($data['filter_cat']) && !is_null($data['filter_cat'])){
				$sql .= " AND LCASE(p.cat) LIKE '%" . $this->db->escape(strtolower($data['filter_cat'])) . "%'";
			}
			if(isset($data['filter_price']) && !is_null($data['filter_price'])){
				$sql .= " AND LCASE(p.price) > " . $this->db->escape(strtolower($data['filter_price']));
			}
			if(isset($data['filter_history_from']) && !is_null($data['filter_history_from'])){
				$sql .= " AND substr(ph.up_date,1,8) between '" . $this->db->escape($this->util->date_format_no($data['filter_history_from'])) . "' and '" . $this->db->escape($this->util->date_format_no($data['filter_history_to'])) . "'";
			}
			$sort_data = array(
			  'ph.up_date',
			);
			if(isset($data['sort']) && in_array($data['sort'], $sort_data)){
				$sql .= " ORDER BY " . $data['sort'];
			}else{
				$sql .= " ORDER BY ph.up_date";
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

	public function getTotalHistory($data = array()){
		$sql = "SELECT count(*) as total FROM package p, package_history ph where p.code = ph.code and p.status = '1'";
		if(isset($data['filter_code']) && !is_null($data['filter_code'])){
			$sql .= " AND LCASE(ph.code) LIKE '%" . $this->db->escape(strtolower($data['filter_code'])) . "%'";
		}
		if(isset($data['filter_name']) && !is_null($data['filter_name'])){
			$sql .= " AND LCASE(p.name) LIKE '%" . $this->db->escape(strtolower($data['filter_name'])) . "%'";
		}
		if(isset($data['filter_product']) && !is_null($data['filter_product'])){
			$sql .= " AND LCASE(ph.final) LIKE '%" . $this->db->escape(strtolower($data['filter_product'])) . "%'";
		}
		if(isset($data['filter_cat']) && !is_null($data['filter_cat'])){
			$sql .= " AND LCASE(p.cat) LIKE '%" . $this->db->escape(strtolower($data['filter_cat'])) . "%'";
		}
		if(isset($data['filter_price']) && !is_null($data['filter_price'])){
			$sql .= " AND LCASE(p.price) > " . $this->db->escape(strtolower($data['filter_price']));
		}
		if(isset($data['filter_history_from']) && !is_null($data['filter_history_from'])){
			$sql .= " AND substr(ph.up_date,1,8) between '" . $this->db->escape($this->util->date_format_no($data['filter_history_from'])) . "' and '" . $this->db->escape($this->util->date_format_no($data['filter_history_to'])) . "'";
		}
		//echo $sql;
		// todo. debug paging one.
		$query = $this->db->query($sql);
		return $query->row['total'];
	}
}
?>