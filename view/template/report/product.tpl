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
    <h1><?php echo $heading_title; ?></h1>
    <h1 style='float:right;'>
      <a href="index.php?route=common/home">Basic</a>
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
            <td class="center" colspan='2' style='width:120px'>
              <div>
                <input type="text" class='date_pick' name="filter_from" value="<?php echo $filter_from; ?>" style='width:70px;' /> -
                <input type="text" class='date_pick' name="filter_to" value="<?php echo $filter_to; ?>" style='width:70px;' />
              </div>
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
            </td>
            <td colspan='8'>
              <a onclick='filter();' class="button btn_filter">
                <span>Search</span>
              </a>
            </td>
          </tr>
          <tr style='height:20px'><td colspan='10'></td></tr>

          <!-- today -->
          <!-- today -->
          <!-- today -->
          <?php
          if(substr($filter_from,-2) == '01'){
            $this_day = date("Y-m-d");
          }else{
            $this_day = $filter_from;
          }
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
          $plnk = HTTPS_SERVER . 'index.php?route=report/product&filter_from=' . $pday . '&filter_to=' . $pday;
          $nlnk = HTTPS_SERVER . 'index.php?route=report/product&filter_from=' . $nday . '&filter_to=' . $nday;
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
            <td class="center" colspan=7>Category</td>
            <td class="center" colspan=1>Count</td>
            <td class="center" colspan=1>Rate</td>
            <td class="center" colspan=1>Percent</td>
          </tr>
          <?php
          $total = $order_sum = 0;
          $aData = array();
          foreach($today as $group => $row){
            foreach($row as $k => $v){
              $order_sum += $v[2];
            }
          }
          
          //$this->log->aPrint( $order_sum );
          
          foreach($today as $group => $row){
            $sum = $order_total = $percent = 0;
            foreach($row as $k => $v){
              $sum += $v[1];
              $order_total += $v[2];
            }
            $percent = round( $order_total / $order_sum * 100 , 2);
            $aData[$group] = array($order_total,$sum,$percent);
          }

          arsort($aData);
//          $this->log->aPrint( $aData );

          foreach ($aData as $group => $row){
            $total += $row[1];
            //$order_sum += $row[0];
          if($sum > 0){
          ?>
          <tr style='background-color:<?php echo $bg_td ?>'>
            <td class='center' colspan=7 style='text-align:left;'>
              <a class='prod_detail'><?php echo $group ?></a>
              <table id='<?php echo $group ?>' style='margin-left:40px;display:none;'>
                <?php
                foreach($today[$group] as $k => $v){
                ?>
                <tr>
                  <td><?php echo $k ?></td>
                  <td><?php echo $v[1] ?></td>
                  <td><?php echo $v[0] ?></td>
                </tr>
                <?php
                }
                ?>
                <div id='salesorder' style='float:right'></div>
              </table>
            </td>
            <td class='center' colspan=1><?php echo $row[1] ?></td>
            <td class='center' colspan=1><?php echo $row[0] ?></td>
            <td class="center" colspan=1><?php echo $row[2] ?> %</td>
          </tr>
          <?php 
          } // end if $sum = 0
          } // end foreach 
          ?>
          <tr style='background-color:#e2e2e2;'>
            <td class='center' colspan='7'></td>
            <td class='center'><?php echo $total; ?></td>
            <td class='center'><?php echo $order_sum; ?></td>
            <td class='center'></td>
          </tr>
          <?php }else{ ?>
          <tr>
            <td class="center" colspan="8">No Result</td>
          </tr>
          <?php } ?>
          <tr style='height:40px'><td colspan='10'></td></tr>
          
          
          
          <!-- this month -->
          <!-- this month -->
          <!-- this month -->
          <?php if( count($stat) > 0 ){ ?>
          <?php
          if( isset($filter_from) ){
            $this_month = substr($filter_from,0,7);
          }else{
            $this_month = date("Y-m");
          }
          ?>
          <tr style='height:20px;'><td colspan='10'>
            <h2>Month Lookup : <?php echo $this_month ?></h2></td>
          </tr>
          <tr style='background-color:#e2e2e2;'>
            <td class="center" colspan=7>Category</td>
            <td class="center" colspan=1>Count</td>
            <td class="center" colspan=1>Rate</td>
            <td class="center" colspan=1>Percent</td>
          </tr>
          <?php
          $total = $order_sum = 0;
          $aData = array();
          foreach($stat as $group => $row){
            foreach($row as $k => $v){
              $order_sum += $v[2];
            }
          }
          
          foreach($stat as $group => $row){
            $sum = 0;
            $order_total = 0;
            foreach($row as $k => $v){
              $sum += $v[1];
              $order_total += $v[2];
            }
            //$sum = array_sum($row);
            $percent = round( $order_total / $order_sum * 100 , 2);
            $aData[$group] = array($order_total,$sum,$percent);
          }
          arsort($aData);

          foreach ($aData as $group => $row){
            $total += $row[1];
          if($sum > 0){
          ?>
          <tr style='background-color:<?php echo $bg_td ?>'>
            <td class='center' colspan=7 style='text-align:left;'>
              <a class='prod_detail_month'><?php echo $group ?></a>
              <table id='<?php echo $group ?>' style='margin-left:40px;display:none;'>
                <?php
                foreach($stat[$group] as $k => $v){
                ?>
                <tr>
                  <td><?php echo $k ?></td>
                  <td><?php echo $v[1] ?></td>
                  <td><?php echo $v[0] ?></td>
                </tr>
                <?php
                }
                ?>
                <div id='salesorder' style='float:right'></div>
              </table>
            </td>
            <td class='center' colspan=1><?php echo $row[1] ?></td>
            <td class='center' colspan=1><?php echo $row[0] ?></td>
            <td class='center' colspan=1><?php echo $row[2] ?> %</td>
          </tr>
          <?php
          } // end if $sum = 0
          } // end foreach 
          ?>
          <tr style='background-color:#e2e2e2;'>
            <td class='center' colspan='7'></td>
            <td class='center'><?php echo $total; ?></td>
            <td class='center'><?php echo $order_sum; ?></td>
            <td class='center'></td>
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

<script type="text/javascript">
$(document).ready(function(){
  $.fn.filter = function(){
  	url = 'index.php?route=report/product&token=<?php echo $token; ?>';
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
  $('.btn_filter').bind('click',function(e){
    $.fn.filter();
  });

  $('.prod_detail').bind('click',function(e){
    $tgt = $(e.target);
    $group = $tgt.text();
    $pnt = $tgt.parents('td');
    $display = $pnt.find('table').css('display');
    if($display == 'none'){
      $pnt.find('table').css('display','block');
      $pnt.find('div').css('display','block');
      // add ajax
      $.ajax({
        type:'get',
        url:'index.php?route=report/product/ordersales',
        dataType:'json',
        data:'filter_from=<?php echo $this_day ?>&filter_to=<?php echo $this_day ?>&group=' + $group,
        success:function(data){
          //obj = $.parseJSON(data);
          $.each(data,function(i,row){
            html = '<p>' + row['rep'] + ' : ' + row['qty'] + '</p>';
            $pnt.find('#salesorder').append(html);
          });
        }
      });
    }
    if($display == 'block'){
      $pnt.find('table').css('display','none');
      $pnt.find('div').css('display','none')
      .html('');
    }
  });

  $('.prod_detail_month').bind('click',function(e){
    $tgt = $(e.target);
    $group = $tgt.text();
    $pnt = $tgt.parents('td');
    $display = $pnt.find('table').css('display');
    if($display == 'none'){
      $pnt.find('table').css('display','block');
      $pnt.find('div').css('display','block');
      // add ajax
      $.ajax({
        type:'get',
        url:'index.php?route=report/product/ordersales',
        dataType:'json',
        data:'filter_from=<?php echo $filter_from ?>&filter_to=<?php echo $filter_to ?>&group=' + $group,
        success:function(data){
          $.each(data,function(i,row){
            html = '<p>' + row['rep'] + ' : ' + row['qty'] + '</p>';
            $pnt.find('#salesorder').append(html);
          });
        }
      });
    }
    if($display == 'block'){
      $pnt.find('table').css('display','none');
      $pnt.find('div').css('display','none')
      .html('');
    }
  });
});
</script>
<?php echo $footer; ?>