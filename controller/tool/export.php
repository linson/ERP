<?php 
class ControllerToolExport extends Controller { 
	private $error = array();
	
	public function index() {
		$this->load->language('tool/export');
		$this->document->title = $this->language->get('heading_title');
		$this->load->model('tool/export');

		if (($this->request->server['REQUEST_METHOD'] == 'POST') && ($this->validate())) {
			if ((isset( $this->request->files['upload'] )) && (is_uploaded_file($this->request->files['upload']['tmp_name']))) {
				$file = $this->request->files['upload']['tmp_name'];
				if ($this->model_tool_export->upload($file)) {
					$this->session->data['success'] = $this->language->get('text_success');
					$this->redirect(HTTPS_SERVER . 'index.php?route=tool/export&token=' . $this->session->data['token']);
				}
				else {
					$this->error['warning'] = $this->language->get('error_upload');
				}
			}
		}

    # language translation
		$this->data['heading_title'] = $this->language->get('heading_title');
		$this->data['entry_restore'] = $this->language->get('entry_restore');
		$this->data['entry_description'] = $this->language->get('entry_description');
		$this->data['export_text'] = $this->language->get('export_text');
		$this->data['button_import'] = $this->language->get('button_import');
		$this->data['button_export'] = $this->language->get('button_export');
    
    // tmp used, besso-20110228
		$this->data['button_backup'] = $this->language->get('button_backup');

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
			'href'      => HTTPS_SERVER . 'index.php?route=tool/export&token=' . $this->session->data['token'],
			'text'      => $this->language->get('heading_title'),
			'separator' => ' :: '
		);

    # model		
		$this->data['action'] = HTTPS_SERVER . 'index.php?route=tool/export&token=' . $this->session->data['token'];
		$this->data['export'] = HTTPS_SERVER . 'index.php?route=tool/export/download&token=' . $this->session->data['token'];
    $this->data['tables'] = $this->model_tool_export->getTables();

    # export-model
 		$this->data['export_action'] = HTTPS_SERVER . 'index.php?route=tool/export/backup&token=' . $this->session->data['token'];
 		$this->data['backup'] = HTTPS_SERVER . 'index.php?route=tool/export/backup&token=' . $this->session->data['token'];
		
		$this->template = 'tool/export.tpl';
		$this->children = array(
			'common/header',	
			'common/footer',	
		);
		$this->response->setOutput($this->render(TRUE), $this->config->get('config_compression'));
	}


	public function download() {
		if ($this->validate()) {

			// set appropriate memory and timeout limits
			ini_set("memory_limit","128M");
			set_time_limit( 1800 );

			// send the categories, products and options as a spreadsheet file
			$this->load->model('tool/export');
			$this->model_tool_export->download();

		} else {

			// return a permission error page
			return $this->forward('error/permission');
		}
	}


	public function backup() {
		if ($this->validate()) {
			$this->load->model('tool/export');
			//$this->model_tool_export->backup();
			$this->response->setOutput($this->model_tool_export->backup($this->request->post['backup']));
		} else {
			return $this->forward('error/permission');
		}
	}
	
	
	private function validate() {
		if (!$this->user->hasPermission('modify', 'tool/export')) {
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