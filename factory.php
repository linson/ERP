<?php
class Example{
  private static $instance;
  private $count = 0;
  
  private function __construct(){}
  
  public static function singleton(){
    if(!isset(self::$instance)){
      echo "Creating new instance \n";
      $className = __CLASS__;
      echo "classname : $className \n";
      self::$instance = new $className;
    }
    return self::$instance;
  }
  
  public function increment(){
    return $this->count++;
  }
  
  public function __clone(){
    trigger_error('Clone is not allowed.',E_USER_ERROR);
  }
  
  public function __wakeup(){
    trigger_error('Unserializing is not allowed.',E_USER_ERROR);
  }
}
?>

<?php
$singleton = Example::singleton();
echo $singleton->increment();
echo $singleton->increment();

$singleton = Example::singleton();
echo $singleton->increment();
echo $singleton->increment();

//$singleton2 = new Example;
//$singleton3 = clone $singleton;
//$singleton4 = unserialize(serialize($singleton));


?>