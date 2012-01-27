<link href="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8/themes/base/jquery-ui.css" rel="stylesheet" type="text/css"/>

<!--script type="text/javascript" src="http://jqueryui.com/jquery-1.5.1.js"></script-->
<!--script type="text/javascript" src="view/javascript/jquery/jquery-1.5.1.js"></script-->
<script type="text/javascript" src="view/javascript/jquery/jquery.min.js"></script>

<!--script type="text/javascript" src="view/javascript/jquery/ui/ui.core.js"></script-->
<script type="text/javascript" src="http://jqueryui.com/ui/jquery.ui.core.js"></script>

<script type="text/javascript" src="http://jqueryui.com/ui/jquery.ui.widget.js"></script>
<script type="text/javascript" src="view/javascript/jquery/jquery.ui.mouse.js"></script>

<script type="text/javascript" src="view/javascript/jquery/superfish/js/superfish.js"></script>
<script type="text/javascript" src="view/javascript/jquery/tab.js"></script>
<script src="http://maps.google.com/maps/api/js?sensor=false&libraries=geometry"></script>

<script type="text/javascript" src="http://jqueryui.com/ui/jquery.ui.draggable.js"></script>
<script type="text/javascript" src="http://jqueryui.com/ui/jquery.ui.droppable.js"></script>

<script type="text/javascript" src="view/javascript/jquery/autoresize.jquery.js"></script>

<script type="text/javascript" src="view/javascript/thickbox-compressed.js"></script>
<link rel="stylesheet" type="text/css" media="screen" href="http://jquery.com/demo/thickbox/thickbox-code/thickbox.css">

<script type="text/javascript" src="view/javascript/datePicker/date.js"></script>
<script src="view/javascript/datePicker/jquery.datePicker.js"></script>
<link rel="stylesheet" type="text/css" media="screen" href="view/javascript/datePicker/datePicker.css">

<script src="view/javascript/jquery/jquery.fancybox-1.3.4.pack.js"></script>
<link rel="stylesheet" type="text/css" href="view/stylesheet/jquery.fancybox-1.3.4.css" />

<?php
  $heading_title = 'Montly';
  $export = '';
  $lnk_action = '';
?>

<style>
.box {
  z-index:10;
}
.content .name_in_list{
  color:purple;
  cursor:pointer;
}
#detail{
  position : absolute;
  top: 100px;
  left: 100px;
  visibility:hidden;
  border: 1px dotted green;
  z-index:2;
}
#content{
  width:900px;
}
.box .content{
  border:none;
}

#header{
  display:none;
}

#header .div2{
  display:none;
}

#ubpboard{
  display:none;
}

#menu{
  display:none;
}
</style>

<div class="box">
  <!--div class="left"></div>
  <div class="right"></div>
  <div class="heading">
    <h1><?php echo $heading_title; ?></h1>
  </div-->

  <div class="content">
    <form action="<?php echo $lnk_action; ?>" method="post" enctype="multipart/form-data" id="form">

      <h3> UBP auto analysis system </h3>

      <table class="list">
        <tbody>

          <tr style='height:20px'><td colspan='10'></td></tr>

          <!-- today -->
          <!-- today -->
          <!-- today -->
          <?php 
          if( count($today) > 0 ){ 
            $this_day = $today[0]['today'];
          }else{
            if(substr($filter_from,-2) == '01'){
                $this_day = date("Y-m-d");
            }else{
                $this_day = $filter_from;
            }
          }

//$this->log->aPrint( $this_day );

          $lbl_this_day = date("Y-m-d [D]",mktime(0, 0, 0, date(substr($this_day,5,2)), date(substr($this_day,8,2)), date(substr($this_day,0,4))));

          for($i=1;$i<7;$i++){
            $week = date("w",mktime(0, 0, 0, date(substr($this_day,5,2)), date(substr($this_day,8,2))-$i, date(substr($this_day,0,4))));
            if( $week != 6 && $week != 0 ){
              $pday = date("Y-m-d",mktime(0, 0, 0, date(substr($this_day,5,2)), date(substr($this_day,8,2))-$i, date(substr($this_day,0,4))));
              break;
            }
          }
          for($i=1;$i<7;$i++){
            $week = date("w",mktime(0, 0, 0, date(substr($this_day,5,2)), date(substr($this_day,8,2))+$i, date(substr($this_day,0,4))));
            if( $week != 6 && $week != 0 ){
              $nday = date("Y-m-d",mktime(0, 0, 0, date(substr($this_day,5,2)), date(substr($this_day,8,2))+$i, date(substr($this_day,0,4))));
              break;
            }
          }
          $plnk = HTTPS_SERVER . 'http://168.93.73.186/backyard/index.php?route=common/home&filter_from=' . $pday . '&filter_to=' . $pday;
          $nlnk = HTTPS_SERVER . 'http://168.93.73.186/backyard/index.php?route=common/home&filter_from=' . $nday . '&filter_to=' . $nday;
          ?>
          <tr style='height:20px'>
            <td colspan='10'>
              <h2 style='display:inline'>Day lookup : <?php echo $lbl_this_day ?></h2>
            </td>
          </tr>
          <?php 
          if( count($today) > 0 ){ 
          ?>
          <tr style='background-color:#e2e2e2;'>
            <td class="center">REP</td>
            <td class="center">Period</td>
            <td class="center">Target(M)</td>
            <td class="center">Target(D)</td>
            <td class="center">SUM</td>
            <td class="center">Percent(M)</td>
            <td class="center">Percent(D)</td>
            <td class="center">Count</td>
            <td class="center">Retail</td>
            <td class="center">W/S</td>
          </tr>
          <?php
          $total = $target = $day_target = $percent = $day_percent = $cnt = $rcnt = $wcnt = 0;
          foreach ($today as $row){
            $total += $row['order_price'];
            $cnt += $row['cnt'];
            $rcnt += $row['rcnt'];
            $wcnt += $row['wcnt'];
            $target += $row['target'];
            $day_target += $row['day_target'];
            $percent += $row['percent'];
            $day_percent += $row['day_percent'];
          ?>
          <tr style='background-color:<?php echo $bg_td ?>'>
            <td class='center'>
              <a href='http://168.93.73.186/backyard/index.php?route=sales/list&filter_order_user=<?php echo $row['order_user'] ?>&filter_order_date_from=<?php echo $this_day ?>&filter_order_date_to=<?php echo $this_day ?>' target=new>
              <?php echo $row['order_user'] ?>
              </a>
            </td>
            <td class='center'><?php echo $row['today'] ?></td>
            <td class='center'><?php echo $this->util->formatMoney($row['target']) ?></td>
            <td class='center'><?php echo $this->util->formatMoney($row['day_target']) ?></td>
            <td class='center'><?php echo $this->util->formatMoney($row['order_price']) ?></td>
            <td class='center'><b><?php echo $row['percent']; ?></b> %</td>
            <td class='center'><b><?php echo $row['day_percent']; ?></b> %</td>
            <td class='center'><?php echo $row['cnt']; ?></td>
            <td class='center'><?php echo $row['rcnt']; ?></td>
            <td class='center'><?php echo $row['wcnt']; ?></td>
          </tr>
          <?php } // end foreach ?>
          <tr style='background-color:#e2e2e2;'>
            <td class='center'></td>
            <td class='center'></td>
            <td class='center'><?php echo $this->util->formatMoney($target) ?></td>
            <td class='center'><?php echo $this->util->formatMoney($day_target) ?></td>
            <td class='center'><?php echo $this->util->formatMoney(round($total)) ?></td>
            <td class='center'><?php echo round( ($total / $target)*100 , 2) ?> %</td>
            <td class='center'><?php echo round( ($total / $day_target)*100 , 2) ?>%</td>
            <td class='center'><?php echo $cnt; ?></td>
            <td class='center'><?php echo $rcnt; ?></td>
            <td class='center'><?php echo $wcnt; ?></td>
          </tr>
          <?php }else{ ?>
          <tr>
            <td class="center" colspan="10">No Result</td>
          </tr>
          <?php } ?>
          <tr style='height:40px'><td colspan='10'></td></tr>



          <!-- this month -->
          <!-- this month -->
          <!-- this month -->
          <?php if( count($stat) > 0 ){ ?>
          <tr style='height:20px;'><td colspan='10'>
            <h2>Month Lookup  <?php //echo $tmonth_label ?></h2></td>
          </tr>
          <tr style='background-color:#e2e2e2;'>
            <td class="center">REP</td>
            <td class="center">Period</td>
            <td class="center" colspan=2>Target</td>
            <td class="center">SUM</td>
            <td class="center" colspan=2>Percent</td>
            <td class="center">Count</td>
            <td class="center">Retail</td>
            <td class="center">W/S</td>
          </tr>
          <?php
          $total = $target = $day_target = $percent = $day_percent = $cnt = $rcnt = $wcnt = 0;
          foreach ($stat as $row){
            $total += $row['order_price'];
            $cnt += $row['cnt'];
            $rcnt += $row['rcnt'];
            $wcnt += $row['wcnt'];
            $target += $row['target'];
            $percent += $row['percent'];
          ?>
          <tr style='background-color:<?php echo $bg_td ?>'>
            <td class='center'>
              <a href='http://168.93.73.186/backyard/index.php?route=sales/list&filter_order_user=<?php echo $row['order_user'] ?>&filter_order_date_from=<?php echo $filter_from ?>&filter_order_date_to=<?php echo $filter_to ?>' target=new>
              <?php echo $row['order_user'] ?>
              </a>
            </td>
            <td class='center'><?php echo $row['order_date'] ?></td>
            <td class='center' colspan=2><?php echo $this->util->formatMoney($row['target']) ?></td>
            <td class='center'><?php echo $this->util->formatMoney($row['order_price']) ?></td>
            <td class='center' colspan=2><b><?php echo $row['percent']; ?></b> %</td>
            <td class='center'><?php echo $row['cnt']; ?></td>
            <td class='center'><?php echo $row['rcnt']; ?></td>
            <td class='center'><?php echo $row['wcnt']; ?></td>
          </tr>
          <?php } // end foreach ?>
          <tr style='background-color:#e2e2e2;'>
            <td class='center'></td>
            <td class='center'></td>
            <td class='center' colspan=2><font size=5><b><?php echo $this->util->formatMoney($target) ?></b></font></td>
            <td class='center'><font size=5><b><?php echo $this->util->formatMoney(round($total)) ?></b></font></td>
            <td class='center' colspan=2><font size=5><b><?php echo round( ($total / $target)*100 , 2) ?></b></font> %</td>
            <td class='center'><?php echo $cnt; ?></td>
            <td class='center'><?php echo $rcnt; ?></td>
            <td class='center'><?php echo $wcnt; ?></td>
          </tr>
          <?php }else{ ?>
          <tr>
            <td class="center" colspan="8">No Result</td>
          </tr>
          <?php } ?>
          <tr style='height:40px'><td colspan='10'></td></tr>




        </tbody>
      </table>
    </form>

  </div>
</div>
<!-- common detail div -->
<div id='detail' class='ui-widget-content'></div>