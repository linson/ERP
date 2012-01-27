<?php
class ModelReportExcel extends Model {
public function export(){
		$this->load->language('store/list');
		$title = $this->language->get('heading_title');

    $export_qry = $this->request->get['export_qry'];

/***
    $export_qry = "
select p.model,p.sku,pd.name_for_sales,package.code,package.name 
  from product p, product_package pp, product_description = pd, package
 where p.product_id = pp.pid
   and p.product_id = pd.product_id
   and package.code = pp.pkg
 order by p.model
    ";
***/

			$ReflectionResponse = new ReflectionClass($this->response);
			if ($ReflectionResponse->getMethod('addheader')->getNumberOfParameters() == 2) {
				$this->response->addheader('Pragma', 'public');
				$this->response->addheader('Expires', '0');
				$this->response->addheader('Content-Description', 'File Transfer');
				$this->response->addheader("Content-type', 'text/octect-stream");
				$this->response->addheader("Content-Disposition', 'attachment;filename=" . $title . ".csv");
				$this->response->addheader('Content-Transfer-Encoding', 'binary');
				$this->response->addheader('Cache-Control', 'must-revalidate, post-check=0,pre-check=0');
			} else {
				$this->response->addheader('Pragma: public');
				$this->response->addheader('Expires: 0');
				$this->response->addheader('Content-Description: File Transfer');
				$this->response->addheader("Content-type:text/octect-stream");
				$this->response->addheader("Content-Disposition:attachment;filename=" . $title . ".csv");
				$this->response->addheader('Content-Transfer-Encoding: binary');
				$this->response->addheader('Cache-Control: must-revalidate, post-check=0,pre-check=0');
			}
			$this->load->model('tool/csv');
			$this->response->setOutput($this->model_tool_csv->csvExport($title,$export_qry));

  }
}
?>