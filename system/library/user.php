<?php
final class User {
	private $user_id;
	private $user_group_id;
	private $username;
	private $firstname;
	private $approver;

 	private $permission = array();

 	public function __construct($registry) {
		$this->db = $registry->get('db');
		$this->request = $registry->get('request');
		$this->session = $registry->get('session');
		
   	if (isset($this->session->data['user_id'])) {
			$user_query = $this->db->query("SELECT * FROM " . DB_PREFIX . "user WHERE user_id = '" . (int)$this->session->data['user_id'] . "'");
			
			if ($user_query->num_rows) {
				$this->user_id = $user_query->row['user_id'];
				$this->user_group_id = $user_query->row['user_group_id'];
				$this->username = $user_query->row['username'];
				$this->approver = $user_query->row['approver'];
				$this->firstname = $user_query->row['firstname'];

        $this->db->query("UPDATE " . DB_PREFIX . "user SET ip = '" . $this->db->escape($this->request->server['REMOTE_ADDR']) . "' WHERE user_id = '" . (int)$this->session->data['user_id'] . "'");
        $user_group_query = $this->db->query("SELECT permission FROM " . DB_PREFIX . "user_group WHERE user_group_id = '" . (int)$user_query->row['user_group_id'] . "'");
				
        $permissions = unserialize($user_group_query->row['permission']);
        //print_r( $permissions );

				if (is_array($permissions)) {
	  				foreach ($permissions as $key => $value) {
	    				$this->permission[$key] = $value;
	  				}
				}
			}else{
				$this->logout();
			}
   	}
   	//echo '<pre>';    print_r($this->permission);   	echo '<pre>';
 	}
		
 	public function login($username, $password) {
    	$user_query = $this->db->query("SELECT * FROM " . DB_PREFIX . "user WHERE LOWER(username) = '" . $this->db->escape(strtolower($username)) . "' AND password = '" . $this->db->escape(md5($password)) . "'");

    	if ($user_query->num_rows) {
			$this->session->data['user_id'] = $user_query->row['user_id'];
			
			$this->user_id = $user_query->row['user_id'];
			$this->username = $user_query->row['username'];			
      
      $sql = "SELECT permission FROM " . DB_PREFIX . "user_group WHERE user_group_id = '" . (int)$user_query->row['user_group_id'] . "'";
      echo $sql;
      $user_group_query = $this->db->query($sql);

	  	$permissions = unserialize($user_group_query->row['permission']);

			if (is_array($permissions)) {
				foreach ($permissions as $key => $value) {
					$this->permission[$key] = $value;
				}
			}
		
      		return TRUE;
    	}else{
      		return FALSE;
    	}
  	}

  	public function logout() {
		unset($this->session->data['user_id']);
	
		$this->user_id = '';
		$this->username = '';
  	}

 	public function hasPermission($key,$value){
 	  //echo $key; 	  echo '---'; 	  echo $value; 	  echo '<br/>';
 	  //echo '<pre>';    print_r($this->permission);   	echo '<pre>';
   	if(isset($this->permission[$key])){
  		return in_array($value, $this->permission[$key]);
	  }else{
   		return FALSE;
	  }
 	}
  
  	public function isLogged() {
    	return $this->user_id;
  	}
  
  	public function getId() {
    	return $this->user_id;
  	}
	
  	public function getUserName() {
    	return $this->username;
  	}	

    public function getGroupID() {
    	return $this->user_group_id;
  	}	

    // todo. not use username , besso 201105
  	public function getFirstName($username = '') {
  	  if ($username != '') {
  	    $sql = "SELECT * FROM " . DB_PREFIX . "user WHERE username = '" . $username . "'";
  			//echo $sql;
  			$user_query = $this->db->query($sql);
        return $user_query->row['firstname'];
      }else{			
      	return $this->firstname;
      }
  	}	

  public function getGroupName($username = '') {
    if ($username != '') {
      $sql = "SELECT ug.name FROM user u, user_group ug WHERE u.user_group_id = ug.user_group_id and u.username = '" . $username . "'";
  		//echo $sql;
  		$query = $this->db->query($sql);
      return $query->row['name'];
    }
  }

  public function getApprover($username = '') {
    if ($username != '') {
      $sql = "SELECT approver FROM user WHERE username = '" . $username . "'";
  		//echo $sql;
  		$query = $this->db->query($sql);
      return $query->row['approver'];
    }
  }	

	// todo. need exception check , besso , is it used? check
	public function getUserId($username){
	  $user_query = $this->db->query("SELECT user_id FROM " . DB_PREFIX . "user WHERE LOWER(username) like '%" . $this->db->escape(strtolower($username)) . "%'");
		$username = $user_query->row;
		print_r($username);
	}
	
	public function getSales(){
	  $sql = "SELECT username FROM user WHERE user_group_id = 11 order by username";
	  $query = $this->db->query($sql);
    $aSales = array();
		foreach($query->rows as $row){
		  $aSales[] = $row['username'];
		}
		return $aSales;
	}

	public function getAllSales(){
	  $sql = "SELECT * FROM user WHERE user_group_id = 11 order by username";
	  $query = $this->db->query($sql);
		return $query->rows;
	}

	
	public function isSales(){
	  $sql = "SELECT username FROM user WHERE user_group_id = 11";
	  $query = $this->db->query($sql);
		$aSales = $query->rows;
		foreach($aSales as $sales){
		  if( $this->username == $sales['username'] ){
		    return true;
		    break;
		  } 
		}
	  return false;
	}
}
?>
