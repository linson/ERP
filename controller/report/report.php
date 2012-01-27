<?php
class ControllerReportReport extends Controller{
	public function index(){
 		isset($this->error['warning']) ? $this->data['error_warning'] = $this->error['warning'] : $this->data['error_warning'] = '';
		isset($this->session->data['success']) ? $this->data['success'] = $this->session->data['success'] : $this->data['success'] = '';
		unset($this->session->data['success']);

    $page   = $this->util->parseRequest('page','get','1');
    $sort   = $this->util->parseRequest('sort','get','');
    $order  = $this->util->parseRequest('order','get','DESC');
    
    $filter_from   = $this->util->parseRequest('filter_from','get',date("Y-m").'-01');
    $filter_to     = $this->util->parseRequest('filter_to','get',date("Y-m-t",strtotime("0 month")));
    
    // todo. static define
    $filter_from = $filter_to = date("Y-m-d",strtotime("-1 days"));
//    $this->log->aPrint( $filter_from );    $this->log->aPrint( $filter_to );

    $hidden   = $this->util->parseRequest('hidden','get',true);

		$url = '';
		if($page) $url.='&page='.$page;
		if($sort) $url.='&sort='.$sort;
		if($order) $url.='&order='.$order;
		
		//$this->data['token'] = $this->session->data['token'];
		$this->data['sort'] = $sort;
		$this->data['order'] = $order;

		$this->data['filter_from'] = $filter_from;
		$this->data['filter_to'] = $filter_to;
		$this->data['hidden'] = $hidden;

		$this->load->model('report/sale');
    //$filter_from = $filter_to = '2012-01-30';
		$req = array(
		  'sort'  => $sort,
		  'order' => $order,
		  'filter_from' => $filter_from,
		  'filter_to' => $filter_to,
		  'hidden' => $hidden,
		);

		$res = $this->model_report_sale->stat($req);

    // today
		$order_total_day = 0;
		foreach($res['today'] as $row){ $order_total_day += $row['order_price']; }
		$total_count_day = count($res['today']);
		$this->data['today'] = $res['today'];
		$this->data['order_total_day'] = $order_total_day;
		$this->data['total_count_day'] = $total_count_day;

    //$this->log->aPrint( $res['today'] );

		$order_total = 0;
		foreach($res['this_month'] as $row){ $order_total += $row['order_price']; }
		$total_count = count($res['this_month']);
		$this->data['stat'] = $res['this_month'];
		$this->data['order_total'] = $order_total;
		$this->data['total_count'] = $total_count;

		$order_total_last = 0;
		foreach($res['last_month'] as $row){ $order_total += $row['order_price']; }
		$total_count_last = count($res['last_month']);
		$this->data['lstat'] = $res['last_month'];
		$this->data['order_total_last'] = $order_total_last;
		$this->data['total_count_last'] = $total_count_last;

    // day
    for($i=0;$i<7;$i++){
      $week = date('w',strtotime("-1 day"));
      if($week != 0 || $week != 6){
        $pday_label = date('m-d(D)',strtotime("-1 day"));
        $pday_from = $pday_to = date('Y-m-d',strtotime("-1 day"));
        break;
      }
    }
    $this->data['pday_label'] = $pday_label;
		$this->data['lnk_pday'] = HTTPS_SERVER . 'index.php?route=common/home&filter_from=' . $pday_from . '&filter_to=' . $pday_to;

    $tday_label = date('m-d(D)',strtotime("0 month"));
    $tday_from = $tday_to = date('Y-m-d',strtotime("0 month"));
    $this->data['tday_label'] = $tday_label;
		$this->data['lnk_tday'] = HTTPS_SERVER . 'index.php?route=common/home&filter_from=' . $tday_from . '&filter_to=' . $tday_to;

    // month
    $pmonth_label = date('Y-m',strtotime("-1 month"));
    $pmonth_from = date('Y-m-01',strtotime("-1 month"));
    $pmonth_to = date('Y-m-t',strtotime("-1 month"));
    $this->data['pmonth_label'] = $pmonth_label;
		$this->data['lnk_pmonth'] = HTTPS_SERVER . 'index.php?route=common/home&filter_from=' . $pmonth_from . '&filter_to=' . $pmonth_to;

    // todo. Need Label work
    $tmonth_label = date('Y-m');
    $tmonth_from = date('Y-m-01');
    $tmonth_to = date('Y-m-t');
    $this->data['tmonth_label'] = $tmonth_label;
		$this->data['lnk_tmonth'] = HTTPS_SERVER . 'index.php?route=common/home&filter_from=' . $tmonth_from . '&filter_to=' . $tmonth_to;

    $nmonth_label = date('Y-m',strtotime("+1 month"));
    $nmonth_from = date('Y-m-01',strtotime("+1 month"));
    $nmonth_to = date('Y-m-t',strtotime("+1 month"));
    $this->data['nmonth_label'] = $nmonth_label;
		$this->data['lnk_nmonth'] = HTTPS_SERVER . 'index.php?route=common/home&filter_from=' . $nmonth_from . '&filter_to=' . $nmonth_to;

    /***
    // quarter
    $pquarter_label = date('Y-m',strtotime("-6 month"));
    $pquarter_from = date('Y-m-01',strtotime("-6 month"));
    $pquarter_to = date('Y-m-t',strtotime("-6 month"));
    $this->data['pquarter_label'] = $pquarter_label;
		$this->data['lnk_pquarter'] = HTTPS_SERVER . 'index.php?route=common/home&filter_from=' . $pquarter_from . '&filter_to=' . $pquarter_to;

    $pquarter_label = date('Y-m',strtotime("-3 month"));
    $pquarter_from = date('Y-m-01',strtotime("-3 month"));
    $pquarter_to = date('Y-m-t',strtotime("-3 month"));
    $this->data['pquarter_label'] = $pquarter_label;
		$this->data['lnk_pquarter'] = HTTPS_SERVER . 'index.php?route=common/home&filter_from=' . $pquarter_from . '&filter_to=' . $pquarter_to;
    ***/

		$this->template = 'report/report.tpl';
		$this->children = array(
			'common/header',	
			'common/footer'	
		);

    $html = $this->render(TRUE);
    //echo $html;
    //exit;
    if( count($this->data['today']) > 0 ){
      $mail = new Mail();
  	  $mail->protocol = $this->config->get('config_mail_protocol');
  	  $mail->hostname = $this->config->get('config_smtp_host');
  	  $mail->username = $this->config->get('config_smtp_username');
  	  $mail->password = $this->config->get('config_smtp_password');
  	  $mail->port = $this->config->get('config_smtp_port');
  	  $mail->timeout = $this->config->get('config_smtp_timeout');

      $subject = 'Sales Report : ' . $filter_from;
      //$this->log->aPrint( $subject );
      $aReceiver = array(
        'besso@live.com',
        'ycki@hotmail.com',
        'pchoe@universalbeauty.com',
        'ypark@universalbeauty.com',
        'monica@universalbeauty.com,
      );

      foreach($aReceiver as $receiver){
  		  $mail->setTo($receiver);
  		  $mail->setFrom($this->config->get('config_email'));
  		  $mail->setSender('besso@live.com');
  		  $mail->setSubject($subject);
  		  //$mail->setText(html_entity_decode($body, ENT_QUOTES, 'UTF-8'));
        $mail->setHtml($html);
  		  $mail->send();
      }
    }
  }
}
?>