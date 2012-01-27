<?php
final class Util {
function formatMoney($number, $fractional=false) { 
    if ($fractional) { 
        $number = sprintf('%.2f', $number); 
    } 
    while (true) { 
        $replaced = preg_replace('/(-?\d+)(\d\d\d)/', '$1,$2', $number); 
        if ($replaced != $number) { 
            $number = $replaced; 
        } else { 
            break; 
        } 
    } 
    return $number; 
} 
  public function html2pdf($url,$target_dir){
    $target_dir = 
    system("");
    
  }

  public function date_format_kr($date){
    $y = substr($date,0,4);
    $m = substr($date,4,2);
    $d = substr($date,6,2);
    return $y . '-' . $m . '-' . $d;
  }

  public function date_format_us($date,$del='/'){
    $y = substr($date,0,4);
    $m = substr($date,5,2);
    $d = substr($date,8,2);
    return $m . $del . $d . $del . $y;
  }

  public function date_format_no($date){
    $y = substr($date,0,4);
    $m = substr($date,5,2);
    $d = substr($date,8,2);
    return $y . $m . $d;
  }

  // todo. it's date_diff for php4. use php5 date_diff 
  public function date_diff($start, $end="NOW"){
    $sdate = strtotime($start);
    $edate = strtotime($end);
    $time = $edate - $sdate;
    if($time>=0 && $time<=59) {
            // Seconds
            $timeshift = $time.' seconds ';
    } elseif($time>=60 && $time<=3599) {
            // Minutes + Seconds
            $pmin = ($edate - $sdate) / 60;
            $premin = explode('.', $pmin);
            $presec = $pmin-$premin[0];
            $sec = $presec*60;
            $timeshift = $premin[0].' min '.round($sec,0).' sec ';
    } elseif($time>=3600 && $time<=86399) {
            // Hours + Minutes
            $phour = ($edate - $sdate) / 3600;
            $prehour = explode('.',$phour);
            
            $premin = $phour-$prehour[0];
            $min = explode('.',$premin*60);
            
            $presec = '0.'.$min[1];
            $sec = $presec*60;
  
            $timeshift = $prehour[0].' hrs '.$min[0].' min '.round($sec,0).' sec ';
  
    } elseif($time>=86400) {
            // Days + Hours + Minutes
            $pday = ($edate - $sdate) / 86400;
            $preday = explode('.',$pday);
  
            $phour = $pday-$preday[0];
            $prehour = explode('.',$phour*24); 
  
            $premin = ($phour*24)-$prehour[0];
            $min = explode('.',$premin*60);
            
            // todo. what the sucked adhoc, , besso-201103 
            if(isset($min[1])){          
              $presec = '0.'.$min[1];
              $sec = $presec*60;
            }
            //$timeshift = $preday[0].' days '.$prehour[0].' hrs '.$min[0].' min '.round($sec,0).' sec ';
  
    }
    //return $timeshift;
    if(isset($preday[0])){
      return '<font color=red> +' . $preday[0] . '</font>'; 
    }else{
      return '';
    }
  }  

  public function parseRequest($key,$method,$default=NULL){
    $rtn = '';
    if('get' == $method){

      if(isset($_GET[$key])){
        $rtn = $_GET[$key];
      }else{
        $rtn = $default;
      }
    }

    if('post' == $method){
      if(isset($_POST[$key])){
        $rtn = $_POST[$key];
      }else{
        $rtn = $default;
      }
    }
    //echo $rtn;
    return $rtn;
  }


  //The function returns the no. of business days between two dates and it skips the holidays
  function getWorkingDays($startDate,$endDate){
    $holidays=array("2012-01-02");
    // do strtotime calculations just once
    $endDate = strtotime($endDate);
    $startDate = strtotime($startDate);

    //The total number of days between the two dates. We compute the no. of seconds and divide it to 60*60*24
    //We add one to inlude both dates in the interval.
    $days = ($endDate - $startDate) / 86400 + 1;

    $no_full_weeks = floor($days / 7);
    $no_remaining_days = fmod($days, 7);

    //It will return 1 if it's Monday,.. ,7 for Sunday
    $the_first_day_of_week = date("N", $startDate);
    $the_last_day_of_week = date("N", $endDate);

    //---->The two can be equal in leap years when february has 29 days, the equal sign is added here
    //In the first case the whole interval is within a week, in the second case the interval falls in two weeks.
    if ($the_first_day_of_week <= $the_last_day_of_week) {
      if ($the_first_day_of_week <= 6 && 6 <= $the_last_day_of_week) $no_remaining_days--;
      if ($the_first_day_of_week <= 7 && 7 <= $the_last_day_of_week) $no_remaining_days--;
    }else{
        // (edit by Tokes to fix an edge case where the start day was a Sunday
        // and the end day was NOT a Saturday)
        
        // the day of the week for start is later than the day of the week for end
        if ($the_first_day_of_week == 7) {
            // if the start date is a Sunday, then we definitely subtract 1 day
            $no_remaining_days--;
            
            if ($the_last_day_of_week == 6) {
                // if the end date is a Saturday, then we subtract another day
                $no_remaining_days--;
            }
        }
        else {
            // the start date was a Saturday (or earlier), and the end date was (Mon..Fri)
            // so we skip an entire weekend and subtract 2 days
            $no_remaining_days -= 2;
        }
    }
  
    $workingDays = $no_full_weeks * 5;
    if ($no_remaining_days > 0 )    {
      $workingDays += $no_remaining_days;
    }
  
    //We subtract the holidays
    foreach($holidays as $holiday){
        $time_stamp=strtotime($holiday);
        //If the holiday doesn't fall in weekend
        if ($startDate <= $time_stamp && $time_stamp <= $endDate && date("N",$time_stamp) != 6 && date("N",$time_stamp) != 7)
            $workingDays--;
    }
    return $workingDays;
  }

}
?>