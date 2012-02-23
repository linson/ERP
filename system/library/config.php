<?php
final class Config {
	private $data = array();

 	public function get($key) {
   	return (isset($this->data[$key]) ? $this->data[$key] : NULL);
  }	

	public function set($key, $value) {
    	$this->data[$key] = $value;
  	}

	public function has($key) {
    	return isset($this->data[$key]);
  }

 	public function load($filename) {
		$file = DIR_CONFIG . $filename . '.php';
   	if (file_exists($file)) { 
  		$cfg = array();
  		require($file);
  		$this->data = array_merge($this->data, $cfg);
		} else {
			exit('Error: Could not load config ' . $filename . '!');
		}
 	}

  public function ubpCategory(){
    $cat = array('3S' => '30 SECONDS',
             'SP' => 'SALON PRO',
             'VN' => 'VIA NATURAL',
             'AE' => 'AFRICAN',
             'IR' => 'IR',
             'QT' => 'QT',
             'OEM'=> 'OEM');
		return $cat;
	}

  public function getCatalog(){
    $catalog = array();
    $categoryFile = DIR_APPLICATION . "data/catalog";
    require($categoryFile);
    return $catalog;
  }

  public function getCatalogMobile(){
    $catalog = array();
    $categoryFile = DIR_APPLICATION . "data/catalog_mobile";
    require($categoryFile);
    return $catalog;
  }


	public function getStoreStatus(){
		$aStoreCode = array(
			'0' => 'DEAD',
			'1' => 'GOOD',
			'2' => 'BAD',
			'3' => 'WORST',
			'9' => 'POTENTIAL'
		);
		return $aStoreCode;
	}

  // todo , To init Arg1 fail. weird
  public function redirectGroup($group){
    if($group == '') $group = '11';
    $aRedirectGroup = array(
      //'11' => 'sales/list',
      '11' => 'common/home',
      '12' => 'material/lookup',
      '14' => 'ar/list',
      '19' => 'report/sale',
      '13' => 'invoice/list'
    );
    //echo( $group );
    //var_dump( $aRedirectGroup[$group] );
    return $aRedirectGroup[$group];
  }

  public function mainProduct(){
    $mainProduct = array(
      'SP2001','SP2002'
    );
  }
}
?>