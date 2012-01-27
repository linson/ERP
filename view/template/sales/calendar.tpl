<?php echo $header; ?>
<?php if($error_warning){ echo $error_warning;?>
<div class="warning"><?php echo $error_warning; ?></div>
<?php } ?>
<?php if ($success) { ?>
<div class="success"><?php echo $success; ?></div>
<?php } ?>

<style>
.calendar{
  width:100%;
  border:1px solid #e3e3e3;
}
.day_head-sunday{
  font-size:18px;
  font-weight:bold;
  text-align:center;
  color:red;
  width:14%;
}
.day_head{
  font-size:18px;
  font-weight:bold;
  text-align:center;
  width:14%;
  height:50px;
}
.calendar-day{
  vertical-align:top;
  height:80px;
}
.day_title a{
  font-size:18px;
  text-decoration:none;
  color:purple;
}
.day_body{
  padding-left:20px;
}
.calendar-row{
  height:50px;
}
.calendar-day li{
  list-style:none;
}

.nav_calendar, .nav_calendar a{
  text-align:center;
  font-size:16px;
  font-weight:bold;
  color:peru;
  text-decoration:none;
  padding-left:20px;
  padding-right:20px;
}
.sunday div li a{
  color:red;
}
.saturday div li a{
  color:blue;
}
</style>

<script type="text/javascript" src="view/javascript/jquery/calendar.js"></script>
<div class="box">
  <div class="left"></div>
  <div class="right"></div>
  <div class="heading">
    <h1 style="background-image: url('view/image/product.png');">
      Calendar</h1>
  </div>
  <div class="content">
  <!-- start of calendar -->
    <div class='nav_calendar'>
      <a href='<?php echo $action_prev; ?>'>  <<  </a>    <?php echo substr($today,0,8); ?>    <a href='<?php echo $action_next; ?>'>  >>  </a>
    </div>
    <?php 
	    $calendar = '<table cellpadding="0" border="1" cellspacing="0" class="calendar">';
    
	    /* table headings */
	    $headings = array('Sun','Mon','Tue','Wed','Thu','Fri','Sat');
	    $calendar.= '<tr class="calendar-row"><td class="day_head-sunday">'.implode('</td><td class="day_head">',$headings).'</td></tr>';

      //echo $year . '<br/>';
      //echo $month . '<br/>';
	    /* days and weeks vars now ... */
	    
      $running_day = date('w',strtotime("first day of $year-$month"));
	    $days_in_month = date('t',time(0,0,0,$month,1,$year));

      //$running_day = date ('Y-m-d', strtotime ( date ( 'Y' ) . 'W' . date ( 'W' ) . '1' ) );
      /*****
	    echo 'running day : '. $running_day;
      echo '<br/>';
 	    echo 'days_in_month : '. $days_in_month;
	    *****/
	    
	    $days_in_this_week = 1;
	    $day_counter = 0;
	    $dates_array = array();

	    //$running_day = date('w',mktime(0,0,0,'12',1,'2011'));
      //echo $running_day . '<br/>';
	        
	    /* row for week one */
	    $calendar.= '<tr class="calendar-row">';
	    /* print "blank" days until the first of the current week */
	    for($x = 0; $x < $running_day; $x++):
	    	$calendar.= '<td class="calendar-day-np"> </td>';
	    	$days_in_this_week++;
	    endfor;
    
	    /* keep going with days.... */
	    $i = 7;
	    for($list_day = 1; $list_day <= $days_in_month; $list_day++):
        // sunday check
        ($running_day+7)%7 == 0 ? $sunClass='sunday' : $sunClass = '';
        ($running_day+7)%7 == 6 ? $satClass='saturday' : $satClass = '';
	    	$calendar.= "<td class='calendar-day $sunClass $satClass'  >";
	    	if(strlen($list_day)==1){
	    	  $ymdh_day = '0'.$list_day;
	    	}else{
	    	  $ymdh_day = $list_day;
    	
	    	}
	    	$ymdh = $year.$month.$ymdh_day.$hour;
	    	$calendar.= '<div class="day-number">
	    	              <li class="day_title">
	    	                <a id="'.$ymdh.'" href="#" class="day">'.$list_day.'</a>
	    	              </li>
	    	              <li class="day_body">';
	    	$html = '';
	    	foreach($events as $k => $day_event){
	    	  //$this->log->aPrint( $event );
	    	  if($k == $list_day){
            foreach($day_event as $event){
	    	      //$this->log->aPrint( $event );
	    	      $id = $event['id'];
	    	      $title = $event['title'];
	    	      $slug = substr($event['slug'],0,20);
	    	      $time = $event['time'];
	    	      $html .= "<span><input type='hidden' name=id value='$id' /><input type='hidden' name=slug value='$slug' /><input type='hidden' name=time value='$time' />
	    	      <p style='cursor:pointer;' class='day_event'>$title</p></span>";
	    	    }
	    	  }
        }
	    	$calendar .= $html;
	    	$calendar .=  '</li>
	    	             </div>';
	    	$calendar.= '</td>';
	    	if($running_day == 6):
	    		$calendar.= '</tr>';
	    		if(($day_counter+1) != $days_in_month):
	    			$calendar.= '<tr class="calendar-row">';
	    		endif;
	    		$running_day = -1;
	    		$days_in_this_week = 0;
	    	endif;
	    	$days_in_this_week++; $running_day++; $day_counter++;
	      $i++;
	    endfor;
    
	    /* finish the rest of the days in the week */
	    if($days_in_this_week < 8):
	    	for($x = 1; $x <= (8 - $days_in_this_week); $x++):
	    		$calendar.= '<td class="calendar-day-np"> </td>';
	    	endfor;
	    endif;
    
	    /* final row */
	    $calendar.= '</tr>';
    
	    /* end the table */
	    $calendar.= '</table>';
      echo $calendar;
    ?>
    <script>
    	// define in php acceptable ext , besso-201103 
    	var token = '<?php echo $token; ?>';
    </script>
   <!-- end of calendar -->
  </div>
</div>
<!-- common detail div -->
<?php echo $footer; ?>
<div id="calendar-events" style="display:none;"></div>