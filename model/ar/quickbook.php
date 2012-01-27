<?php
class utf8encode_filter extends php_user_filter{ 
  function filter($in, $out, &$consumed, $closing){ 

    while ($bucket = stream_bucket_make_writeable($in)){ 
      /*
      echo '<pre>';
      print_r($bucket);
      echo '</pre>';
      */
      $bucket->data = utf8_encode($bucket->data); 
      $consumed += $bucket->datalen; 
      stream_bucket_append($out, $bucket); 
    } 
    return PSFS_PASS_ON; 
  } 
} 

class ModelArQuickbook extends Model {

	public function getTables() {
		$table_data = array();

		$query = $this->db->query("SHOW TABLES FROM `" . DB_DATABASE . "`");

		foreach ($query->rows as $result) {
			$table_data[] = $result['Tables_in_' . DB_DATABASE];
		}

		return $table_data;
	}

	public function csvExport($table,$query=''){
		$output 	= '';
	  //$query 		= "SELECT * FROM " . DB_PREFIX . $table;
		if(!$query){
  		$query 		= "SELECT * FROM `" . $table . "`"; // prefix already part of the table name being passed in
	  }
	  //$this->log->aPrint( $query ); exit;

    //$table = 'storelocator';
    //$query = "select salesrep,accountno,comment from storelocator where comment != '' and salesrep = 'BJ' limit 10";

	  //print_r($query);	  exit;
    $result 	= $this->db->query($query);
    $columns 	= array_keys($result->row);
//$this->log->aPrint( $columns ); exit;
		$csv_terminated = "\n";
    $csv_separator = ",";
    $csv_enclosed = '"';
    $csv_escaped = "\\"; //linux
		$csv_escaped = '"';

		// Header Row
	 	$output .= '"' . $table . '.' . stripslashes(implode('","' . $table . '.',$columns)) . "\"\n";
	 	/*** need to check later
	 	if('' == $table){
  	 	$output .= '"' . stripslashes(implode('","',$columns)) . "\"\n";
  	}
  	***/
  	// Data Rows
	  foreach ($result->rows as $row){
		  //$output .= '"' . html_entity_decode(implode('","', str_replace($csv_enclosed, $csv_escaped . $csv_enclosed, str_replace(array("\r","\n","\t"), "", $row))), ENT_COMPAT, "utf-8") . "\"\n";
		  $schema_insert = '';

//$this->log->aPrint( $row );
foreach ($row as $k => $v) {
  $row[$k] = iconv('UTF-8','EUC-KR',$v);
}		  
//$this->log->aPrint( $row ); exit;

		  $fields_cnt = count($row);
		  foreach ($row as $k => $v) {
		    if ($row[$k] == '0' || $row[$k] != '') {
		      if ($csv_enclosed == '') {
		          $schema_insert .= $row[$k];
		      } else {
		      	$row[$k] = str_replace(array("\r","\n","\t"), "", $row[$k]);
		      	$row[$k] = html_entity_decode($row[$k], ENT_COMPAT, "UTF-8");
		        $schema_insert .= $csv_enclosed . str_replace($csv_enclosed, $csv_escaped . $csv_enclosed, $row[$k]) . $csv_enclosed;
            // todo. jon add for kr employee. need to conditioning.

		      }
		    } else {
		        $schema_insert .= '';
		    }
  
		    if ($k < $fields_cnt - 1) {
		      $schema_insert .= $csv_separator;
		    }
		  }
//$this->log->aPrint( $schema_insert ); echo '<br/>';
		  $output .= $schema_insert;
		  $output .= $csv_terminated;
	  }
    /* no way to show image url in excel cell without VBA 
    $output = ereg_replace('data/','http://192.168.0.82:5555/beautypro24/image/data/',$output);
    , besso-201103 */
//exit;
    return $output;
	}

	public function csvImport($file){
    //$this->log->aPrint( $file );
    //$this->log->aPrint( file_get_contents($file) ); exit;

	  # let's change $fils as UTF-8
		ini_set('max_execution_time', 999999);

    //setlocale( LC_ALL, 'en_US.UTF-8' );  

    //todo. change file as utf8 encoding before thru , besso 201105
    $handle = fopen($file,'r');
    if(!$handle) die('Cannot open uploaded file.');

    $table = 'ar_kim';
    $columns = array('c1','current','c30','c60','c90','c120','total');
    $row_count = 0;
		$sql_query = "INSERT INTO " . $table . "(". implode(',',$columns) .") VALUES(";
    $rows = array();
    while (($data = fgets($handle, 4096)) !== false) {
			$data = explode(',',$data);
			if (count($data) > count($columns)) {
				$data = array_slice($data, 0, count($columns));
			}

	    $row_count++;
      $aAccountno = explode('-',$data[0]);

      $data[0] = $aAccountno[0];
      if($data[0] == '') continue;

	    foreach($data as $key=>$value){
	      $value = trim($value);
	      $value = str_replace('"','',$value);
	      //$value = str_replace(',','',$value);
	      $value = str_replace('\'','',$value);
	      if(!$value) $value = 0;
	      $value = '\'' . $value . '\'';
			  $data[$key] = $value;
	    }
      $rows[] = implode(",",$data);
	  }
	  
	    $qry_val = implode("),(", $rows);
      $sql_query .= $qry_val;
      $sql_query .= ")";
	    fclose($handle);
	    if(count($rows)) {
			$this->db->query("TRUNCATE TABLE " . $table);
      //$this->log->aPrint( $sql_query );
      $this->db->query("set names utf8"); 
      $this->db->query($sql_query);
			$this->cache->delete('product');
		}
		//exit;
	  return $row_count;
	}

	function validDate($date){
		//replace / with - in the date
		$date = strtr($date,'/','-');
		//explode the date into date,month and year
		$datearr = explode('-', $date);
		//count that there are 3 elements in the array
		if(count($datearr) == 3){
			list($d, $m, $y) = $datearr;
			/*checkdate - check whether the date is valid. strtotime - Parse about any English textual datetime description into a Unix timestamp. Thus, it restricts any input before 1901 and after 2038, i.e., it invalidate outrange dates like 01-01-2500. preg_match - match the pattern*/
			if(checkdate($m, $d, $y) && strtotime("$y-$m-$d") && preg_match('#\b\d{2}[/-]\d{2}[/-]\d{4}\b#', "$d-$m-$y")) { /*echo "valid date";*/
				return TRUE;
			} else {/*echo "invalid date";*/
				return FALSE;
			}
		} else {/*echo "invalid date";*/
			return FALSE;
		}
		/*echo "invalid date";*/
		return FALSE;
	}


}
?>