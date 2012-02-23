<style>
.box{ z-index:10; }
.content .name_in_list{ color:purple; cursor:pointer; }
</style>
<div class="box">
  <div class="left"></div><div class="right"></div>
  <div class="heading">
    <div class="buttons">
      <a onclick="$('#detail').html(); $('#detail').css('visibility','hidden');" class="button">
        <span>Close</span></a>
    </div>
  </div>
  <div class="content" id='store_proxy_list'>
    <form action="<?php echo $delete; ?>" method="post" enctype="multipart/form-data" id="form">
      <table class="list">
        <thead>
          <tr>
            <td width="1" style="text-align: center;">
              <input type="checkbox" onclick="$('input[name*=\'selected\']').attr('checked', this.checked);" style='display:none;'/>
            </td>
            <td class="left">
              <?php if($sort == 'accountno'){ ?>
              <a href="<?php echo $sort_accountno; ?>" class="<?php echo strtolower($order); ?>">
                Acct.no</a>
              <?php }else{ ?>
              <a href="<?php echo $sort_accountno; ?>">Acct.no</a>
              <?php } ?>
            </td>
            <td class="left">
              <?php if($sort == 'name'){ ?>
              <a href="<?php echo $sort_name; ?>" class="<?php echo strtolower($order); ?>">
                Store.Name</a>
              <?php }else{ ?>
              <a href="<?php echo $sort_name; ?>">Store.Name</a>
              <?php } ?>
            </td>
            <td class="left">W/R</td>
            <td class="left">City</td>
            <td class="left">
              <?php if($sort == 'state'){ ?>
              <a href="<?php echo $sort_state; ?>" class="<?php echo strtolower($order); ?>">
                State</a>
              <?php }else{ ?>
              <a href="<?php echo $sort_state; ?>">State</a>
              <?php } ?>
            </td>
            <td class="left">
              Phone
            </td>
            <td class="left">
              <?php if($sort == 'salesrep'){ ?>
              <a href="<?php echo $sort_salesrep; ?>" class="<?php echo strtolower($order); ?>">
                Rep</a>
              <?php }else{ ?>
              <a href="<?php echo $sort_salesrep; ?>">Rep</a>
              <?php } ?>
            </td>
            <td class="left">
              <?php if($sort == 'chrt'){ ?>
              <a href="<?php echo $sort_chrt; ?>" class="<?php echo strtolower($order); ?>">
                Chicago</a>
              <?php }else{ ?>
              <a href="<?php echo $sort_chrt; ?>">Chicago</a>
              <?php } ?>
            </td>
            <td class="left"><?php if($sort == 'p.status'){ ?>
              <a href="<?php echo $sort_status; ?>" class="<?php echo strtolower($order); ?>"><?php echo $column_status; ?></a>
              <?php }else{ ?>
              <a href="<?php echo $sort_status; ?>"><?php echo $column_status; ?></a>
              <?php } ?></td>
            <!--td class="right"><?php echo $column_action; ?></td-->
          </tr>
        </thead>
        <tbody>
          <!--tr class="filter">
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
              <input type="text" name="filter_salesrep" value="<?php echo $filter_salesrep; ?>" style="text-align: left;" size='8' />
            </td>
            <td>
              <select name="filter_chrt">
                <option value="1" <?php if($filter_chrt == '1') echo 'selected'; ?> >Y</option>
                <option value="0" <?php if($filter_chrt == '0') echo 'selected'; ?> >N</option>
                <option value="" <?php if($filter_chrt == '') echo 'selected'; ?> >--</option>
              </select>
            </td>
            <td>
              <?php
                $aStoreCode = $this->config->getStoreStatus();
              ?>
              <select name="filter_status">
                <option value="" <?php if(''==$filter_status) echo 'selected'; ?>>All</option>
                <option value="0" <?php if('0'==$filter_status) echo 'selected'; ?>><?php echo $aStoreCode['0']; ?></option>
                <option value="1" <?php if('1'==$filter_status) echo 'selected'; ?>><?php echo $aStoreCode['1']; ?></option>
                <option value="2" <?php if('2'==$filter_status) echo 'selected'; ?>><?php echo $aStoreCode['2']; ?></option>
                <option value="9" <?php if('9'==$filter_status) echo 'selected'; ?>><?php echo $aStoreCode['9']; ?></option>
              </select>
            </td>
            <td align="right"><a class="button btn_filter"><span>Filter</span></a></td>
          </tr-->
          <?php if($store){ ?>
          <?php 
          foreach($store as $row){
            if( $row['status'] == '0' || $row['status'] == '2' ){
              $cssBG = 'style="background-color:red;"';
            }else{
              $cssBG = '';
            }
          ?>
          <tr <?php echo $cssBG; ?>>
            <td style="text-align: center;">
              <?php if($row['selected']){ ?>
              <input type="checkbox" class='id_in_list' name="selected[]" value="<?php echo $row['id']; ?>" checked="checked" style='display:none;'/>
              <?php }else{ ?>
              <input type="checkbox" class='id_in_list' name="selected[]" value="<?php echo $row['id']; ?>" style='display:none;' />
              <?php } ?>
              <input type='hidden' name='view' value='proxy' />
              <input type='hidden' class='address1_in_list' name='address1' value='<?php echo $row['address1']; ?>' />
              <input type='hidden' class='zipcode_in_list' name='zipcode' value='<?php echo $row['zipcode']; ?>' />
              <input type='hidden' class='fax_in_list' name='fax' value='<?php echo $row['fax']; ?>' />
              <input type='hidden' class='discount' name='discount' value='<?php echo $row['discount']; ?>' />
              <input type='hidden' name='shipto' value="<?php echo $row['shipto']; ?>" />
              <input type='hidden' name='status' value="<?php echo $row['status']; ?>" />
            </td>
            <td class='center accountno_in_list'><?php echo $row['accountno']; ?></td>
            <td class='center name_in_list'><?php echo $row['name']; ?></td>
            <td class='center storetype_in_list'><?php echo $row['storetype']; ?></td>
            <td class='center city_in_list'><?php echo $row['city']; ?></td>
            <td class='center state_in_list'><?php echo $row['state']; ?></td>
            <td class='center phone1_in_list'><?php echo $row['phone1']; ?></td>
            <td class='center salesrep_in_list'><?php echo $row['salesrep']; ?></td>
            <td class="left">
              <?php if('1'==$row['chrt']){  echo 'Y'; }else{  echo 'N'; } ?>
            </td>
            <td class="left" class='status_in_list'><?php echo $aStoreCode[$row['status']]; ?></td>
            <!--td class="right"></td-->
          </tr>
          <?php } // end foreach ?>
          <?php }else{ ?>
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

<script>
$(document).ready(function(){
  $('.name_in_list').click(function(){
    var node = $(this).parent(),
        storeinfo = $("#storeinfo"),
        payment = $("#payment"),
        store_id = jQuery.trim(node.find(".id_in_list").attr('value')),
        accountno = jQuery.trim(node.find(".accountno_in_list").html()),
        store_name = jQuery.trim(node.find(".name_in_list").html()),
        storetype = jQuery.trim(node.find(".storetype_in_list").html()),
        address1 = jQuery.trim(node.find(".address1_in_list").attr('value')),
        city = jQuery.trim(node.find(".city_in_list").html()),
        state = jQuery.trim(node.find(".state_in_list").html()),
        zipcode = jQuery.trim(node.find(".zipcode_in_list").attr('value')),
        phone1 = jQuery.trim(node.find(".phone1_in_list").html()),
        fax = jQuery.trim(node.find(".fax_in_list").attr('value')),
        salesrep = jQuery.trim(node.find(".salesrep_in_list").html()),
        discount = jQuery.trim(node.find(".discount").val()),
        status = jQuery.trim(node.find("input[name=status]").val()),
        store_name = store_name.replace(/\&amp;/g,'&'),
        shipto = jQuery.trim(node.find("input[name=shipto]").val()),
        descText = "===== Store Discount =====\n",
        flagDC = false;
    if(status == '0' || status == '2'){
      alert('You couldn\'t proceed with DEAD or BAD account \n Please consult with your manager');
      return;
    }

    //todo. need to tune later for {"",""} case
    // need to add isset check
    dc1 = 0;
    dc2 = 0;
    dc1_desc = '';
    dc2_desc = '';
    if( '' != discount ){
      obj = $.parseJSON(discount);
      $.each(obj,function(idx,dc){
        aDC = dc.split('|');
        if(idx == 0){
          dc1 = aDC[0];
          dc1_desc = aDC[1];
          descText = '[ Store discount ] ' + dc1 + "% " + dc1_desc + "\n";
        }
        if(idx == 1){
          dc2 = aDC[0];
          dc2_desc = aDC[1];
          descText += '[ Store discount ] ' + dc2 + "% " + dc2_desc + "\n";
        }
      });
      $("input[name=dc1]").val(dc1);
      $("input[name=dc1_desc]").val(dc1_desc);
      $("input[name=dc2]").val(dc2);
      $("input[name=dc2_desc]").val(dc2_desc);
      storeinfo.find("textarea[name=description]").val(descText);
    }

    // set in parent for name click
    storeinfo.find("input[name=store_id]").val(store_id);
    storeinfo.find("input[name=store_name]").val(store_name);
    storeinfo.find("input[name=accountno]").val(accountno);
    storeinfo.find("input[name=storetype]").val(storetype);
    storeinfo.find("input[name=address1]").val(address1);
    storeinfo.find("input[name=city]").val(city);
    storeinfo.find("input[name=state]").val(state);
    storeinfo.find("input[name=zipcode]").val(zipcode);
    storeinfo.find("input[name=phone1]").val(phone1);
    storeinfo.find("input[name=fax]").val(fax);
    storeinfo.find("input[name=salesrep]").val(salesrep);

    $('#detail').css('visibility','hidden');
    $ptn = /(\\n)/gm;
    if( $('input[name=shipto]').val().match($ptn) ){
      //alert('matched');
    }
    shipto = shipto.replace($ptn,"\n");
    $('textarea[name=shipto]').val(shipto);

    // todo, i hate to configure ajax for this bunch of historical data, , besso-201103 
    // so forcely save the naive data having just store info
    // i dont understand why forcely save. plz comment detail Dude Jon
    // $('#save').click();
    //$.fn.arHistory(store_id);
    $.fn.qbHistory(store_id);
  });
  
  $('.pagination>div>a').bind('click',function(e){
    //e.preventDefault();
    $tgt = $(e.target);
    $page = $tgt.html();
    $.fn.fnSearch($page);
    return false;
  });

  $('a.btn_filter>span').bind('click',function(){ $.fn.fnSearch();  });

  $.fn.fnSearch = function($page){
    if(!$page) $page = '1';
  	param = '';
  	var filter_name = $('input[name=\'filter_name\']').attr('value');
  	if(filter_name) param += '&filter_name=' + encodeURIComponent(filter_name);
  	var filter_accountno = $('input[name=\'filter_accountno\']').attr('value');
  	if(filter_accountno)  param += '&filter_accountno=' + encodeURIComponent(filter_accountno);
  	var filter_storetype = $('input[name=\'filter_storetype\']').attr('value');
  	if(filter_storetype)  param += '&filter_storetype=' + encodeURIComponent(filter_storetype);
    var filter_storetype = $('select[name=\'filter_storetype\']').attr('value');
    if(filter_storetype != '')  param += '&filter_storetype=' + encodeURIComponent(filter_storetype);
  	var filter_city = $('input[name=\'filter_city\']').attr('value');
  	if(filter_city) param += '&filter_city=' + encodeURIComponent(filter_city);
  	var filter_state = $('input[name=\'filter_state\']').attr('value');
  	if(filter_state)  param += '&filter_state=' + encodeURIComponent(filter_state);
  	var filter_phone1 = $('input[name=\'filter_phone1\']').attr('value');
  	if(filter_phone1) param += '&filter_phone1=' + encodeURIComponent(filter_phone1);
  	var filter_salesrep = $('input[name=\'filter_salesrep\']').attr('value');
  	if(filter_salesrep) param += '&filter_salesrep=' + encodeURIComponent(filter_salesrep);
  	var filter_status = $('select[name=\'filter_status\']').attr('value');
  	if(filter_status != '*')  param += '&filter_status=' + encodeURIComponent(filter_status);
  	var filter_chrt = $('select[name=\'filter_chrt\']').attr('value');
  	if(filter_chrt != '') param += '&filter_chrt=' + encodeURIComponent(filter_chrt);
  	var filter_page = $page;
  	if(filter_page != '1')  param += '&filter_page=' + encodeURIComponent(filter_page);
    $.ajax({
      type:'get',
      url:'index.php?route=store/lookup/callback',
      dataType:'html',
      data:'token=<?php echo $token; ?>' + param,
      success:function(html){
        $('#detail').css('visibility','visible');
        $('#detail').html(html);
      },
      fail:function(){}
    });
  }
});
</script>