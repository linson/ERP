<?php
abstract class Controller {
	protected $registry;	
	protected $id;
	protected $template;
	protected $children = array();
	protected $data = array();
	protected $output;
	
	public function __construct($registry) {
		$this->registry = $registry;
	}
	
	public function __get($key) {
		return $this->registry->get($key);
	}
	
	public function __set($key, $value) {
		$this->registry->set($key, $value);
	}
			
	protected function forward($route, $args = array()) {
		return new Action($route, $args);
	}

	protected function redirect($url) {
		header('Location: ' . str_replace('&amp;', '&', $url));
		exit();
	}
	
	protected function render($return = FALSE) {
		foreach ($this->children as $child) {
			$action = new Action($child);
			$file   = $action->getFile();
			$class  = $action->getClass();
			$method = $action->getMethod();
			$args   = $action->getArgs();
			if (file_exists($file)) {
				require_once($file);

				$controller = new $class($this->registry);
				
				$controller->index();
				
				$this->data[$controller->id] = $controller->output;
			} else {
				exit('Error: Could not load controller ' . $child . '!');
			}
		}
/*		
echo '<pre>';
echo $return . '<br/>';
print_r($this->template);
echo '</pre>';
*/
		if ($return) {
			return $this->fetch($this->template);
		} else {
			$this->output = $this->fetch($this->template);
/*
if($this->template == "ubp/template/common/home.tpl"){
	print $this->output . '<br/>';
}
*/
		}
//		echo $this->output;
	}
	
	protected function fetch($filename) {
		$file = DIR_TEMPLATE . $filename;
    
		if (file_exists($file)) {
			extract($this->data);
/*
if($filename == "ubp/template/common/home.tpl"){
	print $file . '<br/>';
}
*/
      		ob_start();
      
	  		require($file);
      
	  		$content = ob_get_contents();
/*
if($filename == "ubp/template/common/home.tpl"){
	print $content . '<br/>';
}
*/
      		ob_end_clean();

      		return $content;
    	} else {
      		exit('Error: Could not load template ' . $file . '!');
    	}
	}
}
?>
