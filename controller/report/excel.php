<?php
class ControllerReportExcel extends Controller { 
	public function index(){
	  $this->data['lnk_export'] = HTTPS_SERVER . 'index.php?route=report/excel/export&token=' . $this->session->data['token'];
		$this->template = 'report/excel.tpl';
		$this->children = array(
			'common/header',	
			'common/footer'	
		);
		$this->response->setOutput($this->render(TRUE), $this->config->get('config_compression'));
	}

  public function export(){
    $title = '';
    $export_qry = $this->request->get['sql'];
    //$this->log->aPrint( $export_qry );exit;

		$ReflectionResponse = new ReflectionClass($this->response);
		if ($ReflectionResponse->getMethod('addheader')->getNumberOfParameters() == 2) {
			$this->response->addheader('Pragma', 'public');
			$this->response->addheader('Expires', '0');
			$this->response->addheader('Content-Description', 'File Transfer');
			$this->response->addheader("Content-type', 'text/octect-stream");
			$this->response->addheader("Content-Disposition', 'attachment;filename=export.csv");
			$this->response->addheader('Content-Transfer-Encoding', 'binary');
			$this->response->addheader('Cache-Control', 'must-revalidate, post-check=0,pre-check=0');
		} else {
			$this->response->addheader('Pragma: public');
			$this->response->addheader('Expires: 0');
			$this->response->addheader('Content-Description: File Transfer');
			$this->response->addheader("Content-type:text/octect-stream");
			$this->response->addheader("Content-Disposition:attachment;filename=export.csv");
			$this->response->addheader('Content-Transfer-Encoding: binary');
			$this->response->addheader('Cache-Control: must-revalidate, post-check=0,pre-check=0');
		}
		$this->load->model('tool/csv');
		$this->response->setOutput($this->model_tool_csv->csvExport($title,$export_qry));
  }
}
?>