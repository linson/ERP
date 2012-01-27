<?php
class ControllerToolCSV extends Controller{
	private $error = array();
	public function index() {
		if(!isset($this->session->data['token'])){
			$this->session->data['token'] = 0;
		}
		$this->data['token'] = $this->session->data['token'];
		$this->load->language('tool/csv');
		$this->document->title = $this->language->get('heading_title');
		$this->load->model('tool/csv');

		if($this->request->server['REQUEST_METHOD'] == 'POST' && $this->validate()){
      //header('Content-Type: text/html; charset=euc-kr'); 
      //setlocale(LC_ALL, 'en_US.UTF-8');
      
      //$this->log->aPrint(  iconv_get_encoding() );
		  $filename = $this->request->files['csv_import']['tmp_name'];
    	$enc = mb_detect_encoding($filename,'auto');
    	//echo $enc; exit;
    	// if a charanter is valid ASCII, it's valid UTF8 , subjet of Unicode 
    	if('iso-8859-1' == $enc){
    	  $filename = iconv('iso-8859-1','utf-8//TRANSLIT//IGNORE',$filename);
    	}
    	
			if(is_uploaded_file($filename)){
        $content = file_get_contents($filename);
        //$this->log->aPrint( $content );
			}else{
				$content = false;
			}
			if($content){
				$this->model_tool_csv->csvImport($filename);
				$this->session->data['success'] = $this->language->get('text_success');
				$this->redirect(HTTPS_SERVER . 'index.php?route=tool/csv&token=' . $this->session->data['token']);
			} else {
				$this->error['warning'] = $this->language->get('error_empty');
			}
		}

		$this->data['heading_title'] = $this->language->get('heading_title');
		$this->data['text_select_all'] = $this->language->get('text_select_all');
		$this->data['text_unselect_all'] = $this->language->get('text_unselect_all');
		$this->data['entry_export'] = $this->language->get('entry_export');
		$this->data['entry_import'] = $this->language->get('entry_import');
		$this->data['button_backup'] = $this->language->get('button_backup');
		$this->data['button_restore'] = $this->language->get('button_restore');
		$this->data['tab_general'] = $this->language->get('tab_general');

 		if (isset($this->error['warning'])) {
			$this->data['error_warning'] = $this->error['warning'];
		} else {
			$this->data['error_warning'] = '';
		}

		if (isset($this->session->data['success'])) {
			$this->data['success'] = $this->session->data['success'];

			unset($this->session->data['success']);
		} else {
			$this->data['success'] = '';
		}

  		$this->document->breadcrumbs = array();
   		$this->document->breadcrumbs[] = array(
       		'href'      => HTTPS_SERVER . 'index.php?route=common/home&token=' . $this->session->data['token'],
       		'text'      => $this->language->get('text_home'),
      		'separator' => FALSE
   		);

   		$this->document->breadcrumbs[] = array(
       		'href'      => HTTPS_SERVER . 'index.php?route=tool/csv&token=' . $this->session->data['token'],
       		'text'      => $this->language->get('heading_title'),
      		'separator' => ' :: '
   		);

		$this->data['restore'] = HTTPS_SERVER . 'index.php?route=tool/csv&token=' . $this->session->data['token'];
		$this->data['csv'] = HTTPS_SERVER . 'index.php?route=tool/csv/csv&token=' . $this->session->data['token'];
		$this->data['csv_import'] = HTTPS_SERVER . 'index.php?route=tool/csv&token=' . $this->session->data['token'];
		$this->data['csv_export'] = HTTPS_SERVER . 'index.php?route=tool/csv/csvExport&token=' . $this->session->data['token'];

		$this->load->model('tool/csv');
		$this->data['tables'] = $this->model_tool_csv->getTables();

		$this->template = 'tool/csv.tpl';
		$this->children = array(
			'common/header',
			'common/footer'
		);

		$this->response->setOutput($this->render(TRUE), $this->config->get('config_compression'));
	}

	public function csvExport(){
	  //$this->log->aPrint( $this->request ); exit;
		if ($this->request->server['REQUEST_METHOD'] == 'POST' && $this->validate() && isset($this->request->post['csv_export'])) {
			$ReflectionResponse = new ReflectionClass($this->response);
			//$t1 = $ReflectionResponse->getCharset();
			//echo $t1; exit;
			if ($ReflectionResponse->getMethod('addheader')->getNumberOfParameters() == 2) {
				$this->response->addheader('Pragma', 'public');
				$this->response->addheader('Expires', '0');
				$this->response->addheader('Content-Description', 'File Transfer');
				$this->response->addheader("Content-type', 'text/octect-stream");
				$this->response->addheader("Content-Disposition', 'attachment;filename=" . $this->request->post['csv_export'] . ".csv");
				$this->response->addheader('Content-Transfer-Encoding', 'binary');
				$this->response->addheader('Cache-Control', 'must-revalidate, post-check=0,pre-check=0');
			} else {
				$this->response->addheader('Pragma: public');
				$this->response->addheader('Expires: 0');
				$this->response->addheader('Content-Description: File Transfer');
				$this->response->addheader("Content-type:text/octect-stream");
				$this->response->addheader("Content-Disposition:attachment;filename=" . $this->request->post['csv_export'] . ".csv");
				$this->response->addheader('Content-Transfer-Encoding: binary');
				$this->response->addheader('Cache-Control: must-revalidate, post-check=0,pre-check=0');
			}
			//$this->log->aPrint( $this->response ); exit;
			$this->load->model('tool/csv');
			$this->response->setOutput($this->model_tool_csv->csvExport($this->request->post['csv_export']));
		} else {
			return $this->forward('error/permission');
		}
	}

	private function validate() {
		if (!$this->user->hasPermission('modify', 'tool/csv')) {
			$this->error['warning'] = $this->language->get('error_permission');
		}

		if (!$this->error) {
			return TRUE;
		} else {
			return FALSE;
		}
	}
}
?>