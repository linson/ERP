<?php echo $header; ?>
<?php if($error_warning) { ?><div class="warning"><?php echo $error_warning; ?></div><?php } ?>
<?php if($success){ ?><div class="success"><?php echo $success; ?></div><?php } ?>
<div class="box">
  <div class="left"></div><div class="right"></div><div class="heading">
    <h1 style='padding-left:10px;'>
      <?php if($manager == true){ ?>
        <input type=text name='notice' style='width:400px;' id='update_notice' value='<?php echo $notice[0]['notice'] ?>' />
      <?php }else{  ?>
        <font color='red'><?php echo $notice[0]['notice'] ?></font>
      <?php } ?>
    </h1>
    <div class="buttons">
      <?php
      $aSales = $this->user->getSales();
      foreach($aSales as $row){
        if( $row != 'UBP' && $row != 'AK2' && $row != 'BJ' ){
          echo "<a href='index.php?route=sales/list&filter_order_user=$row'><span style='background-color:#fdf8a0;padding:0 5px;'>$row</span></a>";
        }
      }
      ?>
      <a onclick="location = '<?php echo $lnk_insert; ?>'" class="button"><span>Insert</span></a>
      <!--a id='batch_ship' class="button"><span>Ship</span></a-->
      <!--a id='batch_print' class="button"><span>Print</span></a-->
      <a onclick="$('#form').submit();" class="button"><span>Delete</span></a>
    </div>
  </div>
  <div class="content">
    <form action="<?php echo $lnk_delete; ?>" method="post" enctype="multipart/form-data" id="form">
      <table class="list">
        <thead>
          <tr>
            <td width="1" style="text-align: center;">
              <input type="checkbox" onclick="$('input[name*=\'selected\']').attr('checked', this.checked);" /></td>
            <td class="left"><?php if($sort == 'x.txid'){ ?>
              <a href="<?php echo $sort_txid; ?>" class="<?php echo strtolower($order); ?>">TXID</a>
              <?php }else{ ?>
              <a href="<?php echo $sort_txid; ?>">TXID</a>
              <?php } ?></td>
            <td class="left"><?php if($sort == 's.name'){ ?>
              <a href="<?php echo $sort_store_name; ?>" class="<?php echo strtolower($order); ?>">STORE</a>
              <?php }else{ ?>
              <a href="<?php echo $sort_store_name; ?>">STORE</a>
              <?php } ?></td>
            <td class="left"><?php if($sort == 'x.order_date'){ ?>
              <a href="<?php echo $sort_order_date; ?>" class="<?php echo strtolower($order); ?>">ORDER DATE</a>
              <?php }else{ ?>
              <a href="<?php echo $sort_order_date; ?>">ORDER DATE</a>
              <?php } ?></td>
            <td class="left"><?php if($sort == 'x.order_price'){ ?>
              <a href="<?php echo $sort_order_price; ?>" class="<?php echo strtolower($order); ?>">RATE</a>
              <?php }else{ ?>
              <a href="<?php echo $sort_order_price; ?>">RATE</a>
              <?php } ?></td>
            <td class="center">Ship</td>
            <!--td class="center">Balance</td-->
            <td class="left">
              <?php if($sort == 'x.order_user'){ ?>
              <a href="<?php echo $sort_order_user; ?>" class="<?php echo strtolower($order); ?>">REP</a>
              <?php }else{ ?>
              <a href="<?php echo $sort_order_user; ?>">REP</a>
              <?php } ?>
            </td>
            <td class="center">
              <?php if($sort == 'x.approve_status'){ ?>
              <a href="<?php echo $sort_approve_status; ?>" class="<?php echo strtolower($approve_status); ?>">APPROVE</a>
              <?php }else{ ?>
              <a href="<?php echo $sort_order_user; ?>">APPROVE</a>
              <?php } ?>
            </td>
            <td>STAT</td>
            <td class="right"></td>
          </tr>
        </thead>
        <tbody>
          <tr class="filter">
            <td colspan='2'>
              <input type="text" name="filter_txid" value="<?php echo $filter_txid; ?>"  style='width:100px;' />
            </td>
            <td><input type="text" name="filter_store_name" value="<?php echo $filter_store_name; ?>" /></td>
            <td class='center' colspan='2'>
              <input type="text" class='date_pick' name="filter_order_date_from" value="<?php echo $filter_order_date_from; ?>" style='width:70px;' />
              -
              <input type="text" class='date_pick' name="filter_order_date_to" value="<?php echo $filter_order_date_to; ?>" style='width:70px;' />
            </td>
            <td>
              <select name="filter_ship">
                <option value=""  <?php if($filter_ship == '')  echo 'selected' ?> >-</option>
                <option value="Y" <?php if($filter_ship == 'Y') echo 'selected' ?> >Y</option>
                <option value="N" <?php if($filter_ship == 'N') echo 'selected' ?> >N</option>
              </select>
            </td>
            <!--td>
              <select name="filter_payed">
                <?php if($filter_payed == 'done'){ ?>
                <option value="done" selected="selected">Done</option>
                <?php }else{ ?>
                <option value="done">done</option>
                <?php } ?>
                <?php if($filter_payed == 'yet'){ ?>
                <option value="yet" selected="selected">Yet</option>
                <?php }else{ ?>
                <option value="yet">yet</option>
                <?php } ?>
                <?php if($filter_payed == ''){ ?>
                <option value="yet" selected="selected">all</option>
                <?php }else{ ?>
                <option value="">all</option>
                <?php } ?>
              </select>
            </td-->
            <td>
              <select name='filter_order_user'>
                <option value=''>---</option>
                <?php
                if( !$filter_order_user ) $filter_order_user = $this->user->getUsername();
                $aSales = $this->user->getSales();
                foreach($aSales as $row){
                  $rep = $row;
                  $selected = ( $filter_order_user == $rep ) ? 'selected' : '' ;
                  echo "<option value='$rep' $selected>$rep</option>";
                }
                ?>
              </select>
            </td>
            <td>
              <select id="filter_approve_status">
            		<option value='all' <?php echo 'all' == $filter_approve_status ? "selected='selected'" : ""; ?>>All</option>
            		<option value='new' <?php echo 'new' == $filter_approve_status ? "selected='selected'" : ""; ?>>New</option>
            		<option value="approve" <?php echo 'approve' == $filter_approve_status ? "selected='selected'" : ""; ?>>A</option>
            		<option value="pending" <?php echo 'pending' == $filter_approve_status ? "selected='selected'" : ""; ?>>P</option>
            	</select>
            </td>
            <td>
              <select id="filter_status">
            		<option value='' selected>---</option>
            		<option value='0'>YET</option>
            		<option value='1'>SUBMIT</option>
            		<option value='2'>POST(HOLD)</option>
            		<option value='3'>INVOICE</option>
            	</select>
            </td>
            <td align="right"><a onclick="$.fn.filter();" class="button"><span>Filter</span></a></td>
          </tr>
          <?php if($txs){ ?>
          <?php
          $total = 0;
          foreach ($txs as $tx){ 
            $bg_css = '';
            if('yet' == $tx['payed_yn']){
              switch($tx['pay_due']){
                case '30':
                  $bg_css = 'style=background-color:#fdf8a0;';  // yello
                  break;
                case '60':
                  $bg_css = 'style=background-color:#a0fdb8;';  // green, 30-60
                  break;
                case '90':
                  $bg_css = 'style=background-color:#84eafc;';  // blue
                  break;
                case '120':
                  $bg_css = 'style=background-color:#fc8d84;';  // red
                  break;
              }
            }
            $approve_status = $tx['approve_status'];
            if($approve_status == 'pending')  $approve_status = "<font color='red'>$approve_status</font>";
            $order_user = ( $tx['executor'] != $tx['order_user'] ) ? $tx['order_user'] . ' / <font size=1>' . $tx['executor'] . '</font>' : $tx['order_user'];
            $total += $tx['order_price'];
          ?>
          <tr <?php echo $bg_css?>>
            <td style="text-align: center;">
              <?php if($tx['selected']){ ?>
              <input type="checkbox" name="selected[]" value="<?php echo $tx['txid']; ?>" checked="checked" />
              <?php }else{ ?>
              <input type="checkbox" name="selected[]" value="<?php echo $tx['txid']; ?>" />
              <?php } ?>
              <input type="hidden" name="store_id" value="<?php echo $tx['store_id']; ?>" />
            </td>
            <td class="center">
              <!--a href="<?php echo $tx['action'][0]['href']; ?>"-->
              <a href="index.php?route=sales/order&mode=show&txid=<?php echo $tx['txid']; ?>">
              <?php echo $tx['txid']; ?>
              </a>
            </td>
            <td class="left list_store"><?php echo $tx['store_name']; ?></td>
            <td class="left"><?php echo $tx['order_date']; ?></td>
            <td class="left"><?php echo $tx['order_price']; ?></td>
            <td class="left">
              <!--input type=text name=sign_yn value=<?php echo $tx['sign_yn'] ?>       style='width:16px' /-->
              <input type=text name=shipped_yn value=<?php echo $tx['shipped_yn'] ?> style='width:16px' />
            </td>
            <!--td class="left"><?php echo $tx['balance']; ?></td-->
            <td class="left"><?php echo $order_user ?></td>
            <td class="left"><?php echo $approve_status ?></td>
            <td class="center">
            <?php
            if(trim($tx['status']) == '2'){ echo 'POST'; 
            }else if(trim($tx['status']) == '0'){ echo 'YET'; 
            }else if(trim($tx['status']) == '1'){ echo 'SUBMIT'; 
            }else if(trim($tx['status']) == '3'){ echo 'INVOICE'; } 
            ?>
            </td>
            <td class="right"><?php foreach ($tx['action'] as $action){ ?>
              <a href="<?php echo $tx['action'][0]['href']; ?>" class='button'><span>View</span></a>
              <?php } ?></td>
          </tr>
          <?php } ?>
          <?php }else{ ?>
          <tr><td class="center" colspan="11">No Result</td></tr>
          <?php } ?>
        </tbody>
      </table>
    </form>
    <div id='show_total' style='float:right;padding-right:20px;'>
      <?php if( isset($total) ){  ?>
      Total : <?php echo $total ?> ( <?php echo count($txs) ?> )
      <?php } ?>
    </div>
    <div class="pagination"><?php echo $pagination; ?></div>
  </div>
</div>
<style>
#ship_detail{
  position:absolute;
  top:200px;
  left:200px;
  width:400px;
  visibility:hidden;
  background-color:white;
  border:1px dotted blue;
  padding:10px;
}
</style>
<div id='ship_detail'>
  <form action="/sales/" method="post" enctype="multipart/form-data">
  <table>
    <tr>
      <td class=label>SHIP</td>
      <td class=context>
        <input type='hidden' name=txidList value=''>
        <select name=method[]>
          <option value='truck' selected>truck</option>
          <option value='ups'>ups</option>
          <option value='cod'>cod</option>
          <option value='visit'>visit</option>
          <option value='etc'>etc</option>
        </select>
      </td>
      <td class=label>DATE</td>
      <td class=context>
        <input type=text name=ship_date[] value='<?php echo date("Y-m-d"); ?>' style='width:40%' /></td></tr>
    <tr>
      <td class=label>LIFT</td><td class=context>
        <input type=text name=lift[] value='' size=5 /></td>
      <td class=label>COD</td><td class=context>
        <input type=text name=cod[] value='' size=5 />
        <p class=plus style='float:right;margin:0px;margin-right:2px;' />
        <input type='hidden' name='ship_user[]' value='<?php echo $this->user->getUserName(); ?>' /></td>
    </tr>
    <tr>
      <td colspan=4><textarea name='ship_comment[]' style='width:300px;height:100px;'/>
      </textarea></td></tr>
    <tr>
      <td colspan=4>
        <input type=submit value='Confirm' />
        <input type=button value='Close' onclick="$('#ship_detail').css('visibility','hidden');"/>
      </td>
    </tr>
  </table>
  </form>
</div>
<style>
#detail{
  position : absolute;
  top: 100px;
  left: 100px;
  visibility:hidden;
  border: 1px dotted green;
  z-index:2;
}
</style>
<div id='detail'></div>
<!--iframe id='order_detail' name='order_detail' src='' width=500px height=400px></iframe-->
<script type="text/javascript">
$(document).ready(function(){
  // batch_ship
  $('#batch_ship').click(function(){
    // set txidList for batch process
    var $ele_checkbox = $('form tbody input:checkbox:checked'),
        $len = $ele_checkbox.length,
        $txidList = [];
    $ele_checkbox.each(function(idx){
      $txidList.push($(this).val());
    });
    // show ship method and others
    if($txidList.length > 0){
      $('#ship_detail').find('input[name=txidList]').val($txidList);
      $('#ship_detail').css('visibility','visible');
    }
  });

  $('#batch_print').click(function(){
    // set txidList for batch process
    var $ele_checkbox = $('form tbody input:checkbox:checked'),
        $len = $ele_checkbox.length,
        $txidList = [];
    $ele_checkbox.each(function(idx){
      /***** todo. populate new iframe and print that , besso 201105 
      frame = 'frame' + idx;
      $html = "<iframe id='" + frame + "' name='" + frame + "' src='' width=1px height=1px></iframe>";
      $('#content').append($html);

      // we must use relative path for iframe control , besso 201105 
      // http://huuah.com/jquery-and-iframe-manipulation/ sigh~
      var $ele_iframe = $('iframe#'+frame),
          $txid = $(this).val(),
          $param = '?txid='+$txid,
          $url='/sales/order/<?php echo $token; ?>' + $param,
          $name = 'name' + idx;
      $ele_iframe.attr('src',$url);
      *****/
      var winHdr = null;
      var $txid = $(this).val(),
          $param = '&txid='+$txid,
          $name = 'name' + idx,
          $url='index.php?route=sales/order&token=<?php echo $token; ?>' + $param;
      winHdr = window.open($url,$name);
      winHdr.onload = function(){
        winHdr.print();
        winHdr.close();
      }
    });

    setTimeout(function(){
      for (var i=0; i<window.frames.length; i++){
        if(navigator.appName == "Microsoft Internet Explorer"){ 
          // todo. it cannot support WIN XP high over
          var PrintCommand = '<object ID="PrintCommandObject" WIDTH=0 HEIGHT=0 CLASSID="CLSID:8856F961-340A-11D0-A96B-00C04FD705A2"></object>';
          document.body.insertAdjacentHTML('beforeEnd', PrintCommand); 
          PrintCommandObject.ExecWB(6, -1); PrintCommandObject.outerHTML = ""; 
        }else{
          window.frames[i].focus();
          window.frames[i].print();
        }
      }
    },3000);
    // reset
    $txidList = [];
  });

  $.fn.filter = function(){
  	url = 'index.php?route=sales/list&token=<?php echo $token; ?>';
    var filter_txid = $('input[name=\'filter_txid\']').attr('value');
  	if(filter_txid) url += '&filter_txid=' + encodeURIComponent(filter_txid);
  	var filter_store_name = $('input[name=filter_store_name]').attr('value');
  	if(filter_store_name) url += '&filter_store_name=' + encodeURIComponent(filter_store_name);
  	var filter_order_date_from = $('input[name=\'filter_order_date_from\']').attr('value');
  	if(filter_order_date_from)  url += '&filter_order_date_from=' + encodeURIComponent(filter_order_date_from);
  	var filter_order_date_to = $('input[name=\'filter_order_date_to\']').attr('value');
  	if(filter_order_date_to)  url += '&filter_order_date_to=' + encodeURIComponent(filter_order_date_to);
  	var filter_order_price = $('input[name=\'filter_order_price\']').attr('value');
  	if(filter_order_price)  url += '&filter_order_price=' + encodeURIComponent(filter_order_price);
  	var filter_ship = $('select[name=\'filter_ship\']').attr('value');
  	if(filter_ship) url += '&filter_ship=' + encodeURIComponent(filter_ship);
  	var filter_payed = $('select[name=\'filter_payed\']').attr('value');
  	if(filter_payed != '*') url += '&filter_payed=' + encodeURIComponent(filter_payed);
  	var filter_order_user = $('select[name=filter_order_user]').attr('value');
  	if(filter_order_user != '') url += '&filter_order_user=' + encodeURIComponent(filter_order_user);
  	var filter_approve_status = $('#filter_approve_status').attr('value');
  	if(filter_approve_status != '') url += '&filter_approve_status=' + encodeURIComponent(filter_approve_status);
  	var filter_status = $('#filter_status').attr('value');
  	if(filter_status != '') url += '&filter_status=' + encodeURIComponent(filter_status);
  	location = url;
  }
  $('.filter input').keydown(function(e){
  	if(e.keyCode == 13){
  		$.fn.filter();
  	}
  });
  $('#form input')
  .bind('focusin',function(e){
    $(e.target).select();
  })
  .keydown(function(e){
  	if(e.keyCode == 13){
      var $tgt = $(e.target);
      // sign_yn
      if($tgt.is('input[name=sign_yn]')){
        var $pnt = $tgt.parents('tr'),
            $txid = $pnt.find('input[name="selected[]"]').val(),
            $sign_yn = $tgt.val();
        $.ajax({
          type:'get',
          url:'index.php?route=sales/list/updateSignYN',
          dataType:'html',
          data:'txid=' + $txid + '&sign_yn=' + $sign_yn,
          success:function(html){
            $p = $tgt.position();
            $imgCss = {
              'visibility':'visible',
              'width':'150px',
              'height':'20px',
              'top':$p.top-30,
              'left':$p.left-30,
              'background-color':'black',
              'color':'white',
              'text-align':'center'
            }
            $('#detail').css($imgCss);
            $('#detail').html('success');
          }
        });
      }
      // shipped_yn
      if($tgt.is('input[name=shipped_yn]')){
        var $pnt = $tgt.parents('tr'),
            $txid = $pnt.find('input[name="selected[]"]').val(),
            $shipped_yn = $tgt.val();
        $.ajax({
          type:'get',
          url:'index.php?route=sales/list/updateShippedYN',
          dataType:'html',
          data:'txid=' + $txid + '&shipped_yn=' + $shipped_yn,
          success:function(html){
            $p = $tgt.position();
            $imgCss = {
              'visibility':'visible',
              'width':'150px',
              'height':'20px',
              'top':$p.top-30,
              'left':$p.left-30,
              'background-color':'black',
              'color':'white',
              'text-align':'center'
            }
            $('#detail').css($imgCss);
            $('#detail').html('success');
          }
        });
      }
  	}
  });

  $('#form').click(function(event){
    var $tgt = $(event.target);
    if($tgt.is('td.list_store')){
      var $pnt = $tgt.parents('tr'),
          $ele_chkbox = $pnt.find('input[name=store_id]'),
          $store_id = $ele_chkbox.val();
      $.ajax({
        type:'get',
        url:'index.php?route=store/list/callUpdatePannel',
        dataType:'html',
        data:'token=<?php echo $token; ?>&store_id=' + $store_id,
        success:function(html){
          $('#detail').css('visibility','visible');
          $('#detail').html(html);
          //$('#detail').draggable(); 
        }
      });
    }
  });

  // date picker binding
  $('#form').bind('focusin',function(event){
    var $tgt = $(event.target);
    if($tgt.is('input.date_pick')){
      //$(".date-pick").datePicker({startDate:'01/01/1996'});
      $(".date_pick").datepicker({
        clickInput:true,
        createButton:false,
        startDate:'2000-01-01'
      });
    }
  });

  $('#update_notice').bind('keydown',function(e){
    $tgt = $(e.target);
    if( e.keyCode == 13 ){
      $notice = $(this).val();
      $.ajax({
        type:'get',
        url:'index.php?route=sales/list/updateNotice',
        dataType:'html',
        data:'notice=' + $notice,
        success:function(html){
          $p = $tgt.position();
          $imgCss = {
            'visibility':'visible',
            'width':'150px',
            'height':'20px',
            'top':$p.top-10,
            'left':$p.left-30,
            'background-color':'black',
            'color':'white',
            'text-align':'center'
          }
          $('#detail').css($imgCss);
          $('#detail').html('success');
        }
      });
    }
  });
});
</script>
<?php echo $footer; ?>