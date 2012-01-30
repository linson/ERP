<?php
/* references by  
http://www.newmediacampaigns.com/page/create-a-jquery-calendar-with-ajax-php-and-a-remote-data-source
todo.
- move Year level . ask use or not
- batch insert with area - can do
- UI tuning
- opencart model build-up
- lookup list-level
let me do later.
*/
class ControllerSalesCalendar extends Controller{
	private $error = array();
 	public function index(){
    # validation check
    $this->data['error_warning'] = '';
 		if(!$this->validateLookup()){
  	  $this->data['error_warning'] = 'Not have access permission';
	  }
	  $this->data['success'] = '';

    // some << >> navigation will return timestamp 
    if(isset($this->request->get['time'])){
      $date = $this->request->get['time'];
      $endDay = $this->returnEndDayOfMonth(substr($date,0,4),substr($date,4,2));
      $start = substr($date,0,4).substr($date,4,2).'0100';
      $end   = substr($date,0,4).substr($date,4,2).$endDay.'00';
      $this->data['year']  = substr($date,0,4);
      $this->data['month'] = substr($date,4,2);
      $this->data['day']  = substr($date,6,2);
      $this->data['hour']  = substr($date,8,2);
    }else{  // base is today
      $endDay = $this->returnEndDayOfMonth(date('Y'),date('m'));
      $start = date('Y').date('m').'0100';
      $end = date('Y').date('m').$endDay.'00';
      //todo. php date incorrect date +%Y%m%d%H , besso-201103
      //$date = @exec('date +%Y%m%d%H');
      $date = date('Ymdh');
      $this->data['year']  = substr($date,0,4);
      $this->data['month'] = substr($date,4,2);
      $this->data['day'] = substr($date,6,2);
      $this->data['hour']  = substr($date,8,2);
    }
    //$this->log->aPrint( $this->data );
    //Fetch events from database as associative array
    $this->load->model('sales/calendar');

    # retrieve recent three months default
    $events = $this->model_sales_calendar->getEvents($start,$end);

    $this->data['events'] = $events;
    //$this->log->aPrint( $events );
	  $this->data['token']  = $this->session->data['token'];

    $todayDate =  $this->data['year'] . '-' .  $this->data['month'] . '-' .  $this->data['day'];
//$this->log->aPrint( $todayDate );
    $dateOneYearPrev = date('Y',strtotime(date("Y-m-d", strtotime($todayDate)) . "-1 year"));
    $dateOneYearNext = date('Y',strtotime(date("Y-m-d", strtotime($todayDate)) . "+1 year"));
    $pastMonth = date('Ymd',strtotime(date("Y-m-d", strtotime($todayDate)) . "first day of last month"));
    $nextMonth = date('Ymd',strtotime(date("Y-m-d", strtotime($todayDate)) . "first day of next month"));

    $pmonth_label = date('Y-m',strtotime("first day of -1 month"));
    $pmonth_from = date('Y-m-01',strtotime("first day of -1 month"));
    $pmonth_to = date('Y-m-t',strtotime("first day of -1 month"));

    # strtotime bug , besso 201108
    # http://www.phpreferencebook.com/tips/fixing-strtotime-1-month/
    # not work well
    
    $nmonth_label = date('Y-m',strtotime("first day of +1 month"));
    $nmonth_from = date('Y-m-01',strtotime("first day of +1 month"));
    $nmonth_to = date('Y-m-t',strtotime("first day of +1 month"));

    // need to change 
    $prevDate = date('Ymd',strtotime(date("Y-m-d", strtotime($todayDate)) . "-1 day"));
    $nextDate = date('Ymd',strtotime(date("Y-m-d", strtotime($todayDate)) . "+1 day"));

    $this->data['action_prev'] = HTTPS_SERVER . 'index.php?route=sales/calendar&token=' . $this->session->data['token'] . '&time=' . $pastMonth;
    $this->data['action_next'] = HTTPS_SERVER . 'index.php?route=sales/calendar&token=' . $this->session->data['token'] . '&time=' . $nextMonth;

    $this->data['today'] = $date;
		$this->template = 'sales/calendar.tpl';
		$this->children = array(
			'common/header',
			'common/footer'
		);
		$this->response->setOutput($this->render(TRUE), $this->config->get('config_compression'));
  }

 	public function addEventPanel(){
    isset($this->request->get['id']) ? $this->data['id'] = $this->request->get['id'] :  $this->data['id'] = '' ;
    isset($this->request->get['title']) ? $this->data['title'] = $this->request->get['title'] :  $this->data['title'] = '' ;
    isset($this->request->get['slug']) ? $this->data['slug'] = $this->request->get['slug'] :  $this->data['slug'] = '' ;
    $this->data['time'] = $this->request->get['time'];
    $this->data['token']  = $this->session->data['token'];

    $this->template = 'sales/addEventPanel.tpl';
		$this->response->setOutput($this->render(TRUE), $this->config->get('config_compression'));
  }

 	public function updateEvent(){

//$this->log->aPrint( $this->request->get ); exit;

    isset($this->request->get['id']) ? $this->data['id'] = $this->request->get['id'] :  $this->data['id'] = '' ;
    isset($this->request->get['start']) ? $this->data['start'] = $this->request->get['start'] :  $this->data['start'] = '' ;
    isset($this->request->get['end']) ? $this->data['end']     = $this->request->get['end'] :  $this->data['end'] = '' ;
    isset($this->request->get['title']) ? $this->data['title'] = html_entity_decode($this->request->get['title']) :  $this->data['title'] = '' ;
    isset($this->request->get['slug']) ? $this->data['slug']   = html_entity_decode($this->request->get['slug']) :  $this->data['slug'] = '' ;
    isset($this->request->get['time']) ? $this->data['time']   = $this->request->get['time'] :  $this->data['time'] = '' ;

    //$this->log->aPrint( $this->data ); exit;

    $this->load->model('sales/calendar');
    if($this->model_sales_calendar->updateEvent($this->data)){
      echo json_encode('success');
    }
  }

 	public function deleteEvent(){
    $this->data['id'] = isset($this->request->get['id']) ? $this->request->get['id'] : '';
    $this->load->model('sales/calendar');
    if($this->model_sales_calendar->deleteEvent($this->data)){
      echo json_encode('success');
    }
  }

 	private function validateLookup() {
   	if($this->user->hasPermission('access','sales/calendar')){
   		return true;
   	}else{
   	  return false;  
   	}
	}

	private function returnEndDayOfMonth($year,$month){
	  $time = strtotime($month.'/01/'.$year.' 00:00:00');
	  $nextMonTime = strtotime('+1 month',$time);
	  $beforeOneSec = strtotime('-1 second',$nextMonTime);
	  $endDay = date('d',$beforeOneSec);
    return $endDay;
  }
}
?>