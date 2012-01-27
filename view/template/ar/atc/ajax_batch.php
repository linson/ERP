<?
/**
 * Auto Complete 5.1
 * April 13, 2010
 * Corey Hart @ http://www.codenothing.com
 */ 

// Make request var preg safe
$value = strtolower(trim($_POST['value']));

// Ensure there is a value to search for
if ((!isset($value) || $value == '') && ! $_POST['all']){
  exit;
}
$cat = $_POST['cat'];
// Get list of random words
//$cat = '3S';  //todo. need to set dynamic cat via ajax post data
//http://192.168.0.82:5555/backyard/index.php?route=sales/atc/prepareATC
$file = "/var/chroot/home/content/44/6104844/data/$cat";
//$words = explode('\r', file_get_contents($file));

// Set up the send back array
$found = array();
$num = rand(1, 100);
// Search through each standard val and match it if possible
$fp = fopen($file, 'rb'); 
while ( $line = fgets($fp) ){ 
  $data = split('\|',trim($line));
  $model = $data[0];
  $name  = $data[1];
  if (!$name || $name == '') continue;

  //print $name . '<br/>';

  $word = strtolower($name);


  foreach(split(' ',$word) as $single){
    // If all parameter is passed, load up all C/D values
  	if ($_POST['all'] && (($_POST['letter'] == 'c' && strtolower($single[0]) == 'c') || ($_POST['letter'] == 'd' && strtolower($single[0]) == 'd'))){
  		// Return Array
  		$found[] = array(
  			"value" => $word, 
  			"model" => $model,
  		);
  	}
  	else if (!$_POST['all'] && strpos($single, $value) === 0){
  		// Return Array
  		$found[] = array(
  			"value" => $word, 
  			"model" => $model,
  		);
  		if (count($found) >= 10)
  			break;
  	}
    
  
  }
  
  /*
  // If all parameter is passed, load up all C/D values
	if ($_POST['all'] && (($_POST['letter'] == 'c' && strtolower($word[0]) == 'c') || ($_POST['letter'] == 'd' && strtolower($word[0]) == 'd'))){
		// Return Array
		$found[] = array(
			"value" => $word, 
			"model" => $model,
		);
	}
	else if (!$_POST['all'] && strpos($word, $value) === 0){
		// Return Array
		$found[] = array(
			"value" => $word, 
			"model" => $model,
		);
		if (count($found) >= 10)
			break;
	}
  */
}

fclose($fp);

/**
echo '<pre>';
print_r($found);
echo '</pre>';
**/
// JSON encode the array for return
echo json_encode($found);
?>
