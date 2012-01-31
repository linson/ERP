<style>
@media print {
  body, td, th, input, select, textarea, option, optgroup {
    font-size: 14px;
  }
  #header,#menu,#footer{
    display:none;
  }
  #content .left,.right{
    display:none;
  }
  #content .heading div.buttons{
    display:none;
  }
  .np{
    display:none;
  }
} 
</style>

<?php
  $heading_title = 'Montly';
  $export = '';
  $lnk_action = '';
?>
<?php echo $header; ?>
<?php if($error_warning){ ?>
<div class="warning"><?php echo $error_warning; ?></div>
<?php } ?>
<?php if ($success){ ?>
<div class="success"><?php echo $success; ?></div>
<?php } ?>
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
</style>

<div class="box">
  <div class="left"></div>
  <div class="right"></div>
  <div class="heading">
    <h1>
      <?php echo $heading_title; ?>
    </h1>
    <h1 style='float:right;'>
      <a href="index.php?route=report/product">Product</a>
      &nbsp;
      <a href="index.php?route=report/account">Account</a>
    </h1>
  </div>

  <div class="content">
    <form action="<?php echo $lnk_action; ?>" method="post" enctype="multipart/form-data" id="form">
      <table class="list">
        <tbody>
          <!-- it's only for page module , besso-201103 -->
          <tr class="filter np">
            <td class="center" colspan='3' style='width:160px'>
              <div>
                <input type="text" class='date_pick' name="filter_from" value="<?php echo $filter_from; ?>" style='width:70px;' /> -
                <input type="text" class='date_pick' name="filter_to" value="<?php echo $filter_to; ?>" style='width:70px;' />
              </div>
              <!--div>
                <a href='<?php echo $lnk_pday ?>'>
                <?php echo $pday_label ?>
                </a>&nbsp;
                <a href='<?php echo $lnk_tday ?>'>
                <?php echo $tday_label ?>
                </a>
              </div-->
              <div>
                <a href='<?php echo $lnk_pmonth ?>'>
                <?php echo $pmonth_label ?>
                </a>&nbsp;
                <a href='<?php echo $lnk_tmonth ?>'>
                <?php echo $tmonth_label ?>
                </a>&nbsp;
                <a href='<?php echo $lnk_nmonth ?>'>
                <?php echo $nmonth_label ?>
                </a>
              </div>
              <!--div>
                <a href='<?php echo $lnk_pquarter ?>'>
                <?php echo $pquarter_label ?>
                </a>&nbsp;
                <a href='<?php echo $lnk_tquarter ?>'>
                <?php echo $tquarter_label ?>
                </a>
              </div-->
            </td>
            <td colspan='1'>
              <a onclick='filter();' class="button btn_filter">
                <span>Search</span>
              </a>
            </td>
            <td colspan='4'></td>
            <td colspan='1'>
              <!--a onclick='filter_product();' class="button btn_filter_product">
                <span>Product Stat</span>
              </a-->
            </td>
            <td colspan='1'>
              <a class="btn_filter_hidden">
                <span style='color:#E7EFEF'>STAT</span>
              </a>
            </td>
          </tr>

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
          $plnk = HTTPS_SERVER . 'index.php?route=common/home&filter_from=' . $pday . '&filter_to=' . $pday;
          $nlnk = HTTPS_SERVER . 'index.php?route=common/home&filter_from=' . $nday . '&filter_to=' . $nday;
          ?>
          <tr style='height:20px'>
            <td colspan='10'>
              <a href='<?php echo $plnk ?>' style='color:black;font-size:20px;font-weight:bold;'>
              <<
              </a>&nbsp;
              <h2 style='display:inline'>Day lookup : <?php echo $lbl_this_day ?></h2>
              &nbsp;
              <a href='<?php echo $nlnk ?>' style='color:black;font-size:20px;font-weight:bold;'>
              >>
              </a>
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
              <a href='index.php?route=sales/list&filter_order_user=<?php echo $row['order_user'] ?>&filter_order_date_from=<?php echo $this_day ?>&filter_order_date_to=<?php echo $this_day ?>' target=new>
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
            <td class="center">Remain</td>
            <td class="center">Percent</td>
            <td class="center">Count</td>
            <td class="center">Retail</td>
            <td class="center">W/S</td>
          </tr>
          <?php
          $total = $target = $day_target = $percent = $day_percent = $cnt = $rcnt = $wcnt = $remain = $remain_sum = 0;
          foreach ($stat as $row){
            $total += $row['order_price'];
            $cnt += $row['cnt'];
            $rcnt += $row['rcnt'];
            $wcnt += $row['wcnt'];
            $target += $row['target'];
            $percent += $row['percent'] - $row['order_price'];
            if( $row['target'] > $row['order_price'] ){
              $remain = $row['target'] - $row['order_price'];
            }else{
              $remain = 0;
            }
            $remain_sum += $remain;
          ?>
          <tr style='background-color:<?php echo $bg_td ?>'>
            <td class='center'>
              <a href='index.php?route=sales/list&filter_order_user=<?php echo $row['order_user'] ?>&filter_order_date_from=<?php echo $filter_from ?>&filter_order_date_to=<?php echo $filter_to ?>' target=new>
              <?php echo $row['order_user'] ?>
              </a>
            </td>
            <td class='center'><?php echo $row['order_date'] ?></td>
            <td class='center' colspan=2><?php echo $this->util->formatMoney($row['target']) ?></td>
            <td class='center'><?php echo $this->util->formatMoney($row['order_price']) ?></td>
            <td class='center'><font color=red><?php echo round($remain) ?></font></td>
            <td class='center'><b><?php echo $row['percent']; ?></b> %</td>
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
            <td class='center'><font size=5><b><?php echo round($remain_sum) ?></b></font></td>
            <td class='center'><font size=5><b><?php echo round( ($total / $target)*100 , 2) ?></b></font> %</td>
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



          <!-- last month -->
          <!-- last month -->
          <!-- last month -->
          <?php if( count($lstat) > 0 ){ ?>
          <tr style='height:20px'><td colspan='10'>
            <h2>Past Month Lookup  <?php //echo $pmonth_label ?></h2></td>
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
          foreach ($lstat as $row){
            $total += $row['order_price'];
            $cnt += $row['cnt'];
            $rcnt += $row['rcnt'];
            $wcnt += $row['wcnt'];
            $target += $row['target'];
            $percent += $row['percent'];
          ?>
          <tr style='background-color:<?php echo $bg_td ?>'>
            <td class='center'>
              <a href='index.php?route=sales/list&filter_order_user=<?php echo $row['order_user'] ?>&filter_order_date_from=<?php echo $row['order_date'].'-01'; ?>&filter_order_date_to=<?php echo $row['order_date'].'-31'; ?>' target=new>
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
            <td class='center' colspan=2><?php echo $this->util->formatMoney($target) ?></td>
            <td class='center'><?php echo $this->util->formatMoney(round($total)) ?></td>
            <td class='center' colspan=2><?php echo round( ($total / $target)*100 , 2) ?> %</td>
            <td class='center'><?php echo $cnt; ?></td>
            <td class='center'><?php echo $rcnt; ?></td>
            <td class='center'><?php echo $wcnt; ?></td>
          </tr>
          <?php }else{ ?>
          <tr>
            <td class="center" colspan="8">No Result</td>
          </tr>
          <?php } ?>

        </tbody>
      </table>
    </form>

  </div>
</div>
<!-- common detail div -->
<div id='detail' class='ui-widget-content'></div>

<script type="text/javascript">
$(document).ready(function(){
  $.fn.filter = function(){
  	url = 'index.php?route=common/home&token=<?php echo $token; ?>';
  	var filter_from = $('input[name=\'filter_from\']').attr('value');
  	if(filter_from)  url += '&filter_from=' + encodeURIComponent(filter_from);
  	var filter_to = $('input[name=\'filter_to\']').attr('value');
  	if(filter_to)  url += '&filter_to=' + encodeURIComponent(filter_to);
  	location = url;
  }

  $.fn.filter_hidden = function(){
  	url = 'index.php?route=common/home&token=<?php echo $token; ?>&hidden=true';
  	var filter_from = $('input[name=\'filter_from\']').attr('value');
  	if(filter_from)  url += '&filter_from=' + encodeURIComponent(filter_from);
  	var filter_to = $('input[name=\'filter_to\']').attr('value');
  	if(filter_to)  url += '&filter_to=' + encodeURIComponent(filter_to);
  	location = url;
  }

  // date picker binding
  $('#form').bind('focusin',function(event){
    var $tgt = $(event.target);
    if($tgt.is('input.date_pick')){
      //$(".date-pick").datePicker({startDate:'01/01/1996'});
      $(".date_pick").datePicker({
        clickInput:true,
        createButton:false,
        startDate:'2000-01-01'
      });
    }
  });
  $('.btn_filter_hidden').bind('click',function(e){
//  debugger;
    $.fn.filter_hidden();
  });

  $('.btn_filter').bind('click',function(e){
    $.fn.filter();
  });

});
</script>
<?php echo $footer; ?>