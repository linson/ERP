<?php
/* references by  
http://www.newmediacampaigns.com/page/create-a-jquery-calendar-with-ajax-php-and-a-remote-data-source
, besso-201103 

DB
CREATE TABLE events (
	id INTEGER PRIMARY KEY,
	title TEXT,
	slug TEXT,
	time INTEGER
);

todo.
- move Year level . ask use or not
- batch insert with area - can do
- UI tuning
- opencart model build-up
- lookup list-level
let me do later.
*/
class ControllerSalesCalendar extends Controller {
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
    $dateOneYearPrev = date('Y',strtotime(date("Y-m-d", strtotime($todayDate)) . "-1 year"));
    $dateOneYearNext = date('Y',strtotime(date("Y-m-d", strtotime($todayDate)) . "+1 year"));
    $dateOneMonthPrev = date('m',strtotime(date("Y-m-d", strtotime($todayDate)) . "-1 month"));
    $dateOneMonthNext = date('m',strtotime(date("Y-m-d", strtotime($todayDate)) . "+1 month"));

    $prevDate = $this->data['year'] . $dateOneMonthPrev . $this->data['day'] . $this->data['hour'];
    if($dateOneMonthPrev == '12')     $prevDate =  $dateOneYearPrev . '12' . $this->data['day'] . $this->data['hour'];
    $nextDate = $this->data['year'] . $dateOneMonthNext . $this->data['day'] . $this->data['hour'];
    if($dateOneMonthNext == '01')     $nextDate =  $dateOneYearNext . '01' . $this->data['day'] . $this->data['hour'];

    $this->data['action_prev'] = HTTPS_SERVER . 'index.php?route=sales/calendar&token=' . $this->session->data['token'] . '&time=' . $prevDate;
    $this->data['action_next'] = HTTPS_SERVER . 'index.php?route=sales/calendar&token=' . $this->session->data['token'] . '&time=' . $nextDate;

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
    isset($this->request->get['id']) ? $this->data['id'] = $this->request->get['id'] :  $this->data['id'] = '' ;
    isset($this->request->get['start']) ? $this->data['start'] = $this->request->get['start'] :  $this->data['start'] = '' ;
    isset($this->request->get['end']) ? $this->data['end'] = $this->request->get['end'] :  $this->data['end'] = '' ;
    isset($this->request->get['title']) ? $this->data['title'] = $this->request->get['title'] :  $this->data['title'] = '' ;
    isset($this->request->get['slug']) ? $this->data['slug'] = $this->request->get['slug'] :  $this->data['slug'] = '' ;
    isset($this->request->get['time']) ? $this->data['time'] = $this->request->get['time'] :  $this->data['time'] = '' ;

    $this->load->model('sales/calendar');
    if($this->model_sales_calendar->updateEvent($this->data)){
      echo json_encode('success');
    }
  }

 	public function deleteEvent(){
    isset($this->request->get['id']) ? $this->data['id'] = $this->request->get['id'] :  $this->data['id'] = '' ;
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