<?php 
  $aBackground = array('orange','peru','black','red','skyblue','green','gray',
                       'orange','peru','black','red','skyblue','green','gray'
                       );
  $i = 0;
  foreach($qty as $row){
    $total = $row['locked'];
    $rep = $row['order_user'];
    $rep_total = $row['rep_total'];
    $percent = 500 * ( $rep_total / $total );
    $precent = round($percent,2);
    $bg = $aBackground[$i];
?>
    <div class='rep_locked' style='line-height:25px;text-align:center;font-weight:30px;color:white;float:left;height:30px;width:<?php echo $percent; ?>px;background-color:<?php echo $bg; ?>'>
        <?php echo $rep . ' ' . $rep_total; ?>
    </div>
<?php
    $i++;
  }
?>