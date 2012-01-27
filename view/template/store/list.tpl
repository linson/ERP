<?php echo $header; ?>
<?php if($error_warning){ ?>
<div class="warning"><?php echo $error_warning; ?></div>
<?php } ?>
<?php if($success){ ?>
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
</style>
<div class="box">
  <div class="left"></div>
  <div class="right"></div>
  <div class="heading">
    <h1 style="background-image: url('view/image/product.png');">
      <?php echo $heading_title; ?></h1>
    <div class="buttons">
      <?php
      if(count($total) > 0){
      ?> 
      <a onclick="location = '<?php echo $export; ?>'" class="button">
        <span><?php echo $total; ?> Export</span></a>
      <?php
      }
      ?>
      <a class="button btn_insert">
        <span>Insert</span></a>
      <!--a onclick="$('#form').attr('action', '<?php echo $update; ?>'); $('#form').submit();" class="button">
        <span>Update</span></a-->
      <!-- todo. need to think about check box usability and delete, delete not require for account , besso-201103 -->
      <!--a onclick="$('form').submit();" class="button">
        <span>Delete</span></a-->
      <a id='label' class="button"><span>Label</span></a>
    </div>
  </div>

  <?php
    // reset filter for quick re-query , besso-201103 
    // $filter_accountno = '';
    $filter_name = '';
    $filter_storetype = '';
    $filter_city = '';
    $filter_state = '';
    // $filter_phone1 = '';
    // todo. block later for user leveling
    //$filter_salesrep = '';
    //$filter_status = '';
    if(!$filter_status) $filter_status = '';
  ?>
  <div class="content">
    <?php 
      // no delete or so
      $delete = ''; 
    ?>
    <form action="<?php echo $delete; ?>" method="post" enctype="multipart/form-data" id="form">
      <table class="list">
        <thead>
          <tr>
            <td width="1" style="text-align: center;">
              <input type="checkbox" onclick="$('input[name*=\'selected\']').attr('checked', this.checked);" /></td>
            <td class="left">
              Acct.no
            </td>
            <td class="left">
              <?php if($sort == 'name'){ ?>
              <a href="<?php echo $sort_name; ?>" class="<?php echo strtolower($order); ?>">
                Store Name</a>
              <?php } else { ?>
              <a href="<?php echo $sort_name; ?>">Store Name</a>
              <?php } ?>
            </td>
            <td class="left">
              <?php if($sort == 'storetype'){ ?>
              <a href="<?php echo $sort_storetype; ?>" class="<?php echo strtolower($order); ?>">
                W/R</a>
              <?php } else { ?>
              <a href="<?php echo $sort_storetype; ?>">W/R</a>
              <?php } ?>
            </td>
            <!--td class="left">
              <?php echo $column_address1; ?>
            </td-->
            <td class="left">
              CITY
            </td>
            <td class="left">
              STATE
            </td>
            <!--td class="left">
              <?php echo $column_zipcode; ?>
            </td-->
            <td class="left">
              PHONE
            </td>
            <!--td class="left">
              FAX
            </td-->
            <td class="center">
              <?php if($sort == 'salesrep'){ ?>
              <a href="<?php echo $sort_salesrep; ?>" class="<?php echo strtolower($order); ?>">
                REP</a>
              <?php } else { ?>
              <a href="<?php echo $sort_salesrep; ?>">REP</a>
              <?php } ?>
            </td>
            <td class="left">
              Amount
            </td>
            <!-- todo. sort not work for status , besso-201103 -->
            <td class="left">
              <?php if($sort == 'status'){ ?>
              <a href="<?php echo $sort_status; ?>" class="<?php echo strtolower($order); ?>"><?php echo $column_status; ?></a>
              <?php }else{ ?>
              <a href="<?php echo $sort_status; ?>"><?php echo $column_status; ?></a>
              <?php } ?>
            </td>
            <td class="right"><?php echo $column_action; ?></td>
          </tr>
        </thead>
        <tbody>
          <!-- it's only for page module , besso-201103 -->
          <tr class="filter">
            <td></td>
            <td>
              <input type="text" name="filter_accountno" value="<?php echo $filter_accountno; ?>" size='6' />
            </td>
            <td>
              <input type="text" name="filter_name" value="<?php echo $filter_name; ?>" size='10' />
            </td>
            <td>
              <select name='filter_storetype'>
                <?php if(strtolower($filter_storetype) == 'w'){ ?>
                  <option value="">--</option>
                  <option value="w" selected="selected">W</option>
                  <option value="r">R</option>
                <?php } elseif(strtolower($filter_storetype) == 'r'){ ?>
                  <option value="">--</option>
                  <option value="w">W</option>
                  <option value="r" selected="selected">R</option>
                <?php }else{ ?>
                  <option value="" selected="selected">--</option>
                  <option value="w">W</option>
                  <option value="r">R</option>
                <?php }?>
              </select>
            </td>
            <td>
              <input type="text" name="filter_city" value="<?php echo $filter_city; ?>" size='8' />
            </td>
            <td>
              <input type="text" name="filter_state" value="<?php echo $filter_state; ?>" size='2' />
            </td>
            <td align="left">
              <input type="text" name="filter_phone1" value="<?php echo $filter_phone1; ?>" style="text-align: left;" size='12' />
            </td>
            <td align="left">
              <?php
              // todo. how to make beautiful user leveling , besso-201103 
              //if('11' != $this->user->getGroupID()){
              if($this->user->getGroupID()){
              ?>
              <input type="text" name="filter_salesrep" value="<?php echo $filter_salesrep; ?>" style="text-align:center;width:30px;" />
              <?php
              }else{
                echo $this->user->getUserName();
              }
              ?>
            </td>
            <td>
              > <input type="text" name="filter_balance" value="<?php echo $filter_balance; ?>" style="text-align: left;width:30px;" />
            </td>
            <td>
              <?php 
                $aStoreCode = $this->config->getStoreStatus(); 
              ?>
              <select name="filter_status">
                <option value="" <?php if(''==$filter_status) echo 'selected'; ?>>All</option>
                <option value="0" <?php if('0'==$filter_status) echo 'selected'; ?>><?php echo $aStoreCode['0']; ?></option>
                <option value="1" <?php if('1'==$filter_status) echo 'selected'; ?>><?php echo $aStoreCode['1']; ?></option>
                <!--option value="2" <?php if('2'==$filter_status) echo 'selected'; ?>><?php echo $aStoreCode['2']; ?></option>
                <option value="3" <?php if('3'==$filter_status) echo 'selected'; ?>><?php echo $aStoreCode['3']; ?></option-->
                <option value="9" <?php if('9'==$filter_status) echo 'selected'; ?>><?php echo $aStoreCode['9']; ?></option>
              </select>    
            </td>
            <td align="right">
              <a onclick='filter();' class="button btn_filter">
                <span><?php echo $button_filter; ?></span>
              </a>
            </td>
          </tr>

          <?php if($store){ ?>
          <?php
          //$this->log->aPrint( $store );
          foreach ($store as $row){
            $bg_td = '';
            if( $row['status'] == '0' ) $bg_td = 'gray';
            if( $row['status'] == '9' ) $bg_td = '#e2e2e2';
          ?>
          <tr style='background-color:black;height:2px;'><td colspan='11'></td></tr>
          <tr style='background-color:<?php echo $bg_td ?>'>
            <td style="text-align: center;"><?php if($row['selected']){ ?>
              <input type="checkbox" class='id_in_list' name="selected[]" value="<?php echo $row['id']; ?>" checked="checked" />
              <?php } else { ?>
              <input type="checkbox" class='id_in_list' name="selected[]" value="<?php echo $row['id']; ?>" />
              <?php } ?>
              <input type='hidden' name='view' value='proxy' />
              <input type='hidden' class='address1_in_list' name='address1' value='<?php echo $row['address1']; ?>' />
              <input type='hidden' class='zipcode_in_list' name='zipcode' value='<?php echo $row['zipcode']; ?>' />
              <input type='hidden' class='fax_in_list' name='fax' value='<?php echo $row['fax']; ?>' />
            </td>
            <td class='center accountno_in_list'>
              <a href='index.php?route=report/account&accountno=<?php echo $row['accountno'] ?>' target='new'>
              <?php echo $row['accountno']; ?>
              </a>
            </td>
            <!--td class='center name_in_list'-->
            <td>
              <?php echo $row['name']; ?>
            </td>
            <td class='center storetype_in_list'>
              <?php echo $row['storetype']; ?>
            </td>
            <td class='center city_in_list'>
              <?php echo $row['city']; ?>
            </td>
            <td class='center state_in_list'>
              <?php echo $row['state']; ?>
            </td>
            <td class='center phone1_in_list'>
              <?php echo $row['phone1']; ?>
            </td>
            <td class='center salesrep_in_list'>
              <?php echo $row['salesrep']; ?>
            </td>
            <td class='center salesrep_in_list'>
              <?php //echo $row['balance']; ?>
            </td>
            <td class="left" class='status_in_list'><?php echo $aStoreCode[$row['status']]; ?></td>
            <td class="center">
              <a class='button edit'><span>More</span></a>
            </td>
          </tr>
          <?php if( count($row['tx']) > 0 ){ ?>
          <tr>
            <td colspan=11>
              <?php
                // 730px;
                $aDiff = array();
                foreach( $row['tx'] as $tx ){
                  $order_date = substr($tx['order_date'],0,10);
                  $order_ts = mktime(0, 0, 0, date(substr($order_date,5,2)), date(substr($order_date,8,2)), date(substr($order_date,0,4)));
                  $order_price = $tx['order_price'];
                  $tdate_ts = time(date('Y-m-d'));
                  
                  //$this->log->aPrint( $order_ts );
                  //$this->log->aPrint( $tdate_ts );
                  $diff = round( ( $tdate_ts - $order_ts ) / ( 60 * 60 * 24 ) );
                  $diff = 182 - $diff;
                  $aDiff[$diff] = array($order_date,$order_price);
                }
                for($i=0;$i<182;$i++){
                  if( isset($aDiff[$i]) ){
                    $od = $aDiff[$i][0];
                    $op = $aDiff[$i][1];
                    $bgcolor = 'red';
                    $alt = $od . " " . $op;
                  }else{
                    $bgcolor = '#e2e2e2';
                    $alt = '';
                  }
                  if($i%30 == 0){
                    $height = 10;
                  }else{
                    $height = 5;
                  }
                  echo "<a style='height:" . $height . "px;width:5px;background-color:" . $bgcolor . ";display:inline-block;' onclick=\"show('" . $alt . "')\"></a>";
                  echo "<div id='ohis' style='display:none;'></div>";
                }
              ?>
              <script>
              function show(alt){
                alert(alt);
              }
              </script>
            </td>
          </tr>
          <?php
          } // end if count tx
          ?>

          <?php } // end foreach ?>

          <?php } else { ?>
          <tr>
            <td class="center" colspan="11">No Result</td>
          </tr>
          <?php } ?>
        </tbody>
      </table>
    </form>
    <div class="pagination"><?php echo $pagination; ?></div>
  </div>
</div>
<!-- common detail div -->
<div id='detail' class='ui-widget-content'></div>

<script type="text/javascript">
$(document).ready(function(){

  $('.btn_insert').bind('click',function(event){
    $.ajax({
      type:'get',
      url:'index.php?route=store/list/callInsertPannel',
      dataType:'html',
      data:'token=<?php echo $token; ?>',
      beforesend:function(){
        //console.log('beforesend');
      },
      complete:function(){
        //console.log('complete');
      },
      success:function(html){
        $('#detail').css('visibility','visible');
        $('#detail').html(html);
        //$('#detail').draggable(); 
      },
      fail:function(){
        //console.log('fail : no response from proxy');
      }
    });
  });
  // query store condition , besso-201103
  /***/
  $('.btn_filter').click(function(){
    //alert('clk');
    filter();
  });
  /***/
  function filter(){
  	var url = 'index.php?route=store/list&token=<?php echo $token; ?>';
    var filter_name = $('input[name=\'filter_name\']').attr('value');
  	if(filter_name) url += '&filter_name=' + encodeURIComponent(filter_name);
  	var filter_accountno = $('input[name=\'filter_accountno\']').attr('value');
  	if(filter_accountno)  url += '&filter_accountno=' + encodeURIComponent(filter_accountno);
  	var filter_storetype = $('input[name=\'filter_storetype\']').attr('value');
  	if(filter_storetype)  url += '&filter_storetype=' + encodeURIComponent(filter_storetype);
    var filter_storetype = $('select[name=\'filter_storetype\']').attr('value');
    if(filter_storetype != '')  url += '&filter_storetype=' + encodeURIComponent(filter_storetype);
  	var filter_city = $('input[name=\'filter_city\']').attr('value');
  	if(filter_city) url += '&filter_city=' + encodeURIComponent(filter_city);
  	var filter_state = $('input[name=\'filter_state\']').attr('value');
  	if(filter_state)  url += '&filter_state=' + encodeURIComponent(filter_state);
  	var filter_phone1 = $('input[name=\'filter_phone1\']').attr('value');
  	if(filter_phone1) url += '&filter_phone1=' + encodeURIComponent(filter_phone1);
  	var filter_salesrep = $('input[name=\'filter_salesrep\']').attr('value');
  	if(filter_salesrep) url += '&filter_salesrep=' + encodeURIComponent(filter_salesrep);
  	var filter_balance = $('input[name=\'filter_balance\']').attr('value');
  	if(filter_balance) url += '&filter_balance=' + encodeURIComponent(filter_balance);
  	var filter_status = $('select[name=\'filter_status\']').attr('value');
  	if(filter_status != '*')  url += '&filter_status=' + encodeURIComponent(filter_status);
  	location = url;
  }
  $('#form input').keydown(function(e){
  	if(e.keyCode == 13) filter();
  });

  $('.list').click(function(event){
    var $tgt = $(event.target);
    if($tgt.is('a.edit>span')){
      var $pnt = $tgt.parents('tr'),
          $ele_chkbox = $pnt.find('.id_in_list'),
          $store_id = $ele_chkbox.val();
      $.ajax({
        type:'get',
        url:'index.php?route=store/list/callUpdatePannel',
        dataType:'html',
        data:'token=<?php echo $token; ?>&store_id=' + $store_id,
        beforesend:function(){
          //console.log('beforesend');
        },
        complete:function(){
          //console.log('complete');
        },
        success:function(html){
          $('#detail').css('visibility','visible');
          $('#detail').html(html);
          //$('#detail').draggable();
        },
        fail:function(){
          //console.log('fail : no response from proxy');
        }
      });
    }
  }); // end of click event

  $('#label').bind('click',function(e){
    var $ele_checkbox = $('form tbody input:checkbox:checked'),
        $len = $ele_checkbox.length
        $idlist = '',
        $i = 1;
    $ele_checkbox.each(function(idx){
      if($idlist != ''){
        $idlist = $idlist + ',' + $(this).val() + ',';
      }else{
        $idlist = $(this).val() + ',';
      }
      $idlist = $idlist.substring(0,$idlist.length-1);
      if($i%2 == 0){
        //console.log(idx%2);        console.log($idlist);        console.log('--------------');
        $.fn.printLabel($idlist);
        $idlist = '';
      }else{
        if($i == $len){
          $.fn.printLabel($idlist);
        }
      }
      $i++;
    });
  });

  $.fn.printLabel = function($idlist){
    $param = '&idlist=' + $idlist,
    $url='index.php?route=store/list/printLabel&token=<?php echo $token; ?>' + $param;
    window.open($url);
    /*
    winHdr.onload = function(){
      winHdr.print();
      winHdr.close();
    }
    */
  }

  $(window).bind('scroll',function(){
    var winP = $(window).scrollTop()+100;
    var mapCss = {
      "position":"absolute",
      "top":winP +'px',
    }
    $("#detail").css(mapCss);
  });

});
</script>
<?php echo $footer; ?>