<?php echo $header; ?>
<?php if($error_warning){ ?>
<div class="warning"><?php echo $error_warning; ?></div>
<?php } ?>

<!--div class='help' style='width:100%;font-size:12px'>
<pre>
Default : list all unpaid AR list for all sales
Batch Print need to edit brower setting ( firefox possible, IE ??? )
</pre>
</div-->

<div class="box">
  <div class="left"></div>
  <div class="center"></div>
  <div class="right"></div>
  <div class="heading">
    <h1 style="background-image: url('view/image/product.png');">AR list</h1>
    <div class="buttons">
      <?php if(count($total) > 0){ ?> 
      <a onclick="location = '<?php echo $export; ?>'" class="button">
        <span><?php echo $total; ?> Export</span></a>
      <?php } ?>
      <a onclick="location = '<?php echo $lnk_insert; ?>'" class="button"><span>Insert</span></a>
      <a id='batch_print' class="button"><span>Print</span></a>
      <a href='<?php echo $lnk_import; ?>' class="button"><span>QB</span></a>
    </div>
  </div>
  <div class="content">
    <div id='lmenu'>
    </div>
    <form action="<?php echo $lnk_delete; ?>" method="post" enctype="multipart/form-data" id="form">
      <table class="list">
        <thead>
          <tr>
            <td width="1" style="text-align: center;">
              <input type="checkbox" onclick="$('input[name*=\'selected\']').attr('checked', this.checked);" /></td>
            <td class="center"><?php if($sort == 'x.txid'){ ?>
              <a href="<?php echo $sort_txid; ?>" class="<?php echo strtolower($order); ?>">TXID</a>
              <?php } else { ?>
              <a href="<?php echo $sort_txid; ?>">TXID</a>
              <?php } ?></td>
            <td class="center"><?php if($sort == 's.name'){ ?>
              <a href="<?php echo $sort_store_name; ?>" class="<?php echo strtolower($order); ?>">STORE</a>
              <?php } else { ?>
              <a href="<?php echo $sort_store_name; ?>">STORE</a>
              <?php } ?></td>
            <td class="center"><?php if($sort == 'x.order_date'){ ?>
              <a href="<?php echo $sort_order_date; ?>" class="<?php echo strtolower($order); ?>">ORDER DATE</a>
              <?php } else { ?>
              <a href="<?php echo $sort_order_date; ?>">ORD.DATE</a>
              <?php } ?></td>
            <td class="center"><?php if($sort == 'x.order_price'){ ?>
              <a href="<?php echo $sort_order_price; ?>" class="<?php echo strtolower($order); ?>">RATE</a>
              <?php } else { ?>
              <a href="<?php echo $sort_order_price; ?>">RATE</a>
              <?php } ?></td>
            <td class="center">SHIP</td>
            <td class="center">
              Balance
            </td>
            <td class="center">
              <?php if($sort == 'x.order_user'){ ?>
              <a href="<?php echo $sort_order_user; ?>" class="<?php echo strtolower($order); ?>">REP</a>
              <?php } else { ?>
              <a href="<?php echo $sort_order_user; ?>">REP</a>
              <?php } ?>
            </td>
            <td class="center"></td>
          </tr>
          <tr>
            <td colspan='2' class="center">
              Bank : 
              <select name='filter_bankaccount'>
                <option value='' selected>-----</option>
                <option value='123456789'>123456789</option>
                <option value='987654321'>987654321</option>
              </select>
            </td>
            <td colspan='1' class="right">
              Order : <?php echo $sum['count']; ?> cnt
            </td>
            <td colspan='1' class="right">
              Order : <?php echo $sum['order_sum']; ?>
            </td>
            <td colspan='2' class="right">
              Paid : <?php echo $sum['paid_sum']; ?>
            </td>
            <td colspan='2' class="right">
              Balance : <?php echo $sum['balance_sum']; ?>
            </td>
            <td></td>
          </tr>
        </thead>
        <tbody> 
          <tr class="filter">
            <td class='center' colspan='2'>
              <input type="text" name="filter_txid" value="<?php echo $filter_txid; ?>"  style='width:200px;' />
            </td>
            <td class='center' style='width:150px;'>
              <input type="text" name="filter_store_name" value="<?php echo $filter_store_name; ?>" style='width:100px;' />
            </td>
            <td class='center' colspan='2'>
              <button onclick="$('input[name=filter_order_date_from]').val('2000-01-01'); return false;">All</button>
              <input type="text" class='date_pick' name="filter_order_date_from" value="<?php echo $filter_order_date_from; ?>" style='width:70px;' />
              -
              <input type="text" class='date_pick' name="filter_order_date_to" value="<?php echo $filter_order_date_to; ?>" style='width:70px;' />
            </td>
            <!--td class='right'><input type="text" name="filter_price" value="<?php echo $filter_order_price; ?>" size='5' /></td-->
            <td class='center' style='width:30px;'>
              <select name="filter_ship">
                <option value="Y" <?php if($filter_ship=='Y') echo "selected"; ?> >Y</option>
                <option value="N" <?php if($filter_ship=='N') echo "selected"; ?> >N</option>
                <option value="" <?php if($filter_ship=='') echo "selected"; ?> >-</option>
              </select>
            </td>
            <td class='center'>
              <select name="filter_payed">
                <option value="done" <?php if($filter_payed == 'done') echo "selected"; ?>>done</option>
                <option value="yet" <?php if($filter_payed == 'yet') echo "selected"; ?>>yet</option>
                <option value="" <?php if($filter_payed == '') echo "selected"; ?>>--</option>
              </select>
            </td>
            <td class='center'>
              <select name='filter_order_user'>
                <?php
                $aSales = $this->user->getSales();
                foreach($aSales as $row){
                  $rep = $row;
                  $selected = ( $filter_order_user == $rep ) ? 'selected' : '' ;
                  echo "<option value='$rep' $selected>$rep</option>";
                }
                ?>
              </select>
            </td>
            <td class="center"><a onclick="$.fn.filter();" class="button"><span>Filter</span></a></td>
          </tr>
          <?php
          if($txs){
          ?>
          <?php
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
          ?>
          <tr <?php echo $bg_css?> >
            <td style="text-align: center;"><?php if($tx['selected']){ ?>
              <input type="checkbox" name="selected[]" value="<?php echo $tx['txid']; ?>" checked="checked" />
              <?php } else { ?>
              <input type="checkbox" name="selected[]" value="<?php echo $tx['txid']; ?>" />
              <?php } ?></td>
            <td class="center">
              <a href="<?php echo $tx['action'][0]['href']; ?>">
              <?php echo $tx['txid']; ?>
              </a>
            </td>
            <td class="center"><?php echo $tx['store_name']; ?></td>
            <td class="center"><?php echo $tx['order_date']; ?></td>
            <td class="center"><?php echo $tx['order_price']; ?></td>
            <td class="center"><?php echo $tx['shipped_yn']; ?></td>
            <td class="center"><?php echo $tx['balance']; ?></td>
            <td class="center"><?php echo $tx['order_user']; ?></td>
            <td class="center"><?php foreach ($tx['action'] as $action){ ?>
              <a href="<?php echo $tx['action'][0]['href']; ?>" class='button'><span>Detail</span></a>
              <?php } ?></td>
          </tr>
          <?php } ?>
          <?php } else { ?>
          <tr>
            <td class="center" colspan="9">No Result</td>
          </tr>
          <?php } ?>
        </tbody>
      </table>
    </form>
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
          $url='index.php?route=ar/order&token=<?php echo $token; ?>' + $param;
      winHdr = window.open($url,$name);
      winHdr.onload = function(){
        winHdr.print();
        winHdr.close();
      }
    });
  });

  $.fn.filter = function(){
  	url = 'index.php?route=ar/list&token=<?php echo $token; ?>';
  	var filter_store_name = $('input[name=\'filter_store_name\']').attr('value');
  	if(filter_store_name) url += '&filter_store_name=' + encodeURIComponent(filter_store_name);
  	var filter_txid = $('input[name=\'filter_txid\']').attr('value');
  	if(filter_txid) url += '&filter_txid=' + encodeURIComponent(filter_txid);
    var filter_bankaccount = $('select[name=\'filter_bankaccount\']').attr('value');
  	if(filter_bankaccount)  url += '&filter_bankaccount=' + encodeURIComponent(filter_bankaccount);
  	var filter_order_date_from = $('input[name=\'filter_order_date_from\']').attr('value');
  	if(filter_order_date_from)  url += '&filter_order_date_from=' + encodeURIComponent(filter_order_date_from);
  	var filter_order_date_to = $('input[name=\'filter_order_date_to\']').attr('value');
  	if(filter_order_date_to)  url += '&filter_order_date_to=' + encodeURIComponent(filter_order_date_to);
  	var filter_ship = $('select[name=\'filter_ship\']').attr('value');
  	if(filter_ship) url += '&filter_ship=' + encodeURIComponent(filter_ship);
  	var filter_order_user = $('select[name=\'filter_order_user\']').attr('value');
  	if(filter_order_user) url += '&filter_order_user=' + encodeURIComponent(filter_order_user);
  	var filter_payed = $('select[name=\'filter_payed\']').attr('value');
  	if(filter_payed != '*') url += '&filter_payed=' + encodeURIComponent(filter_payed);
  	location = url;
  }
  $('#form input').keydown(function(e){
  	if(e.keyCode == 13) $.fn.filter();
  });

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
});
</script>
<?php echo $footer; ?>