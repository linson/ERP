<?php
  //echo phpinfo();
?>
<?php echo $header; ?>
<?php if($error_warning){ ?>
<div class="warning"><?php echo $error_warning; ?></div>
<?php } ?>
<?php if($success){ ?>
<div class="success"><?php echo $success; ?></div>
<?php } ?>
<div class="box">
  <div class="left"></div>
  <div class="right"></div>
  <div class="heading">
    <h1 style="background-image: url('view/image/product.png');">
    Inventory
    <font color=red>Some Picture is not correct. Anyone can replace picture !!</font>
    </h1>
    <!-- no need insert, copy, delete , besso-201103 -->
    <div class="buttons">
      <a class="button btn_insert"><span><?php echo $button_insert; ?></span></a>
      <!--a onclick="location = '<?php echo $insert; ?>'" class="button">
        <span><?php echo $button_insert; ?></span></a>
      <a onclick="$('#form').attr('action', '<?php echo $copy; ?>'); $('#form').submit();" class="button">
      <span><?php echo $button_copy; ?></span></a-->
      <a onclick="filter();" class="button"><span>Search</span></a>
    </div>
    <!--div class="buttons">
      <?php
      if(isset($count)){
        //$export = 'export';
        $button_export = 'export';
      ?> 
      Total <?php echo $count; ?> =>  
      <a onclick="location = '<?php echo $export; ?>'" class="button">
        <span><?php echo $button_export; ?></span></a>
      <?php
      }
      ?>
    </div-->
  </div>
  <div class="content">
    <form action="<?php echo $delete; ?>" method="post" enctype="multipart/form-data" id="form">
      <table class="list">
        <thead>
          <tr>
            <!--td width="1" style="text-align: center;">
              <input type="checkbox" onclick="$('input[name*=\'selected\']').attr('checked', this.checked);" />
            </td-->
            <td class="center"><?php echo $column_image; ?></td>
            <td class="center">
              <?php if($sort == 'pd.name'){ ?>
              <a href="<?php echo $sort_name; ?>" class="<?php echo strtolower($order); ?>"><?php echo $column_name; ?></a>
              <?php }else{ ?>
              <a href="<?php echo $sort_name; ?>"><?php echo $column_name; ?></a>
              <?php } ?>
            </td>
            <td>Category</td>
            <td class="center"><?php if($sort == 'p.model'){ ?>
              <a href="<?php echo $sort_model; ?>" class="<?php echo strtolower($order); ?>"><?php echo $column_model; ?></a>
              <?php }else{ ?>
              <a href="<?php echo $sort_model; ?>"><?php echo $column_model; ?></a>
              <?php } ?></td>
            <td>Pcs</td>
            <td class="center">
              <?php if($sort == 'p.ws_price'){ ?>
              <a href="<?php echo $sort_ws_price; ?>" class="<?php echo strtolower($order); ?>"><?php echo $column_ws_price; ?></a>
              <?php }else{ ?>
              <a href="<?php echo $sort_ws_price; ?>"><?php echo $column_ws_price; ?></a>
              <?php } ?>
            </td>
            <td class="center">
              <?php if($sort == 'p.rt_price'){ ?>
              <a href="<?php echo $sort_rt_price; ?>" class="<?php echo strtolower($order); ?>"><?php echo $column_rt_price; ?></a>
              <?php }else{ ?>
              <a href="<?php echo $sort_rt_price; ?>"><?php echo $column_rt_price; ?></a>
              <?php } ?>
            </td>
            <td class="center"><?php if($sort == 'p.quantity'){ ?>
              <a href="<?php echo $sort_quantity; ?>" class="<?php echo strtolower($order); ?>"><?php echo $column_quantity; ?></a>
              <?php }else{ ?>
              <a href="<?php echo $sort_quantity; ?>"><?php echo $column_quantity; ?></a>
              <?php } ?></td>
          </tr>
        </thead>
        <tbody>
          <tr class="filter">
            <td class='center'>
              <select name='filter_oem'>
                <option value='n'>N.OEM</option>
                <option value='y'>OEM</option>
              </select>
            </td>
            <td class='center'><input type="text" name="filter_name" value="<?php echo $filter_name; ?>" size=15 /></td>
            <td class='center'>
              <select name='filter_cat'>
              <?php
              $aCat = $this->config->ubpCategory();
                echo "<option value=''>---</option>";
              foreach($aCat as $key => $cat){
                echo "<option value='{$key}'>{$cat}</option>";
              }
              ?>
              </select>
            </td>
            <td class='center'>
              <input type="text" name="filter_model" value="<?php echo $filter_model; ?>" class="short_input" />
              <!--input type="text" name="filter_model_to" value="<?php echo $filter_model_to; ?>" class="short_input"  /-->
            </td>
            <td colspan='4'></td>
          </tr>
          <?php if(isset($products)){ ?>
          <?php foreach ($products as $product){ ?>
          <tr class='main_list'>
            <!--td style="text-align: center;"><?php if($product['selected']){ ?>
              <input type="checkbox" name="selected[]" value="<?php echo $product['product_id']; ?>" checked="checked" />
              <?php }else{ ?>
              <input type="checkbox" name="selected[]" value="<?php echo $product['product_id']; ?>" />
              <?php } ?></td-->
              <input type="hidden" name="product_id" value="<?php echo $product['product_id']; ?>" />
            <td><img class='more' src="<?php echo $product['image']; ?>" alt="<?php echo $product['name']; ?>" style="margin:0px; padding:0px; border:1px solid #DDDDDD;cursor:pointer;" /></td>
            <td class="left" style='width:200px;'><?php echo $product['name']; ?></td>
            <td>
              <?php
              //$this->log->aPrint( $product['name'] );
              $cat = substr($product['model'],0,2);
              $aCat = $this->config->ubpCategory();
              if(isset($aCat[$cat])){
                print $aCat[$cat];
              }else{ echo 'OEM'; }
              ?>
            </td>
            <td class="right"><?php echo $product['model']; ?></td>
            <td class="right"><?php echo $product['pc']; ?></td>
            <td class="right">
              <input type="number" name="ws_price" value="<?php echo $product['ws_price']; ?>" class="short_input" />
            </td>
            <td class="right">
              <input type="number" name="rt_price" value="<?php echo $product['rt_price']; ?>" class="short_input" />
            </td>
            <td class="right">
              <input type="number" name="quantity" value="<?php echo $product['quantity']; ?>" class="short_input" readonly style='background-color:#e2e2e2;' />
              <input type="number" name="plus" class='plus' value="0" size=3/>
            </td>
          </tr>
          <?php } ?>
          <?php }else{ ?>
          <tr>
            <td class="center" colspan="9"><?php echo $text_no_results; ?></td>
          </tr>
          <?php } ?>
        </tbody>
      </table>
    </form>
    <div class="pagination"><?php echo $pagination; ?></div>
  </div>
</div>

<style>
#detail{
  position : absolute;
  top: 100px;
  left: 200px;
  visibility:hidden;
  border: 1px dotted green;
  background-color:white;
  z-index:99;
}
</style>
<div id='detail'></div>

<script type="text/javascript">
$('tbody').bind('click',function(e){
  $tgt = $(e.target);
  if($tgt.is('input')){
      $tgt.select();
  }
});


$('.filter').bind('keydown',function(e){
  if('13' == e.keyCode){
    $tgt = $(e.target);
    if($tgt.is('input')){
      filter();
    }
  }
});

$('.more').bind('click',function(e){
  $tgt = $(e.target);
  var $pnt = $tgt.parents('tr'),
      $el_id = $pnt.find('input[name=product_id]'),
      $id = $el_id.val();
  $.ajax({
    type:'get',
    url:'index.php?route=product/price/callUpdatePannel',
    dataType:'html',
    data:'token=<?php echo $token; ?>&ddl=update&id=' + $id,
    success:function(html){
      $('#detail').css('visibility','hidden');
      $p = $tgt.position();
      $('#detail').css('top',$p.top-200);
      $('#detail').html(html);
      $('#detail').css('visibility','visible');
      $('#detail').draggable();
    }
  });
});

$('.btn_insert').bind('click',function(event){
  $.ajax({
    type:'get',
    url:'index.php?route=product/price/callUpdatePannel',
    dataType:'html',
    data:'token=<?php echo $token; ?>&ddl=insert',
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
  
// unbind handling to prevent duplicated event driven
var handler = function(e){
  if('13' == e.keyCode){
    $tgt = $(e.target);
    if($tgt.is('input.plus')){
      $.fn.updatePackage($tgt);
    }
    
    if($tgt.is("input['name=rt_price']")){
      var $pnt = $tgt.parents('tr'),
          $product_id = $pnt.find('input[name=product_id]').val(),
          $ws_price = $pnt.find('input[name=ws_price]').val(),
          $rt_price = $pnt.find('input[name=rt_price]').val();
      $.ajax({
        type:'get',
        url:'index.php?route=product/price/updatePrice',
        dataType:'html',
        data:'token=<?php echo $token; ?>&product_id=' + $product_id + '&rt_price=' + $rt_price + '&ws_price=' + $ws_price,
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
}
$('.main_list').bind('keydown',handler);

/*
 * package is update automatically 
 */
$.fn.updatePackage = function($tgt){
  $product_id = $tgt.parents('tr').find('input[name=product_id]').val();
  $quantity_el = $tgt.parents('tr').find('input[name=quantity]');
  var $key = $tgt[0].name,
      $val = $tgt[0].value;

  if('plus' == $key){
    $param = '&' + $key + '=' + $val + '&product_id=' + $product_id;
    $.ajax({
      type:'get',
      url:'index.php?route=product/price/updatePackage&token=<?php echo $token; ?>',
      dataType:'html',
      data:$param,
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
        $('#detail').html('success : ' + $val );
        //$('#detail').draggable();
        
        $quantity_el.val( parseInt($val) + parseInt($quantity_el.val()) );
        $tgt.val('0');
        $tgt.select();
        
      }
    });
  }
}

function filter(){
	url = 'index.php?route=product/price&token=<?php echo $token; ?>';
	var filter_name = $('input[name=\'filter_name\']').attr('value');
	if(filter_name) url += '&filter_name=' + encodeURIComponent(filter_name);
	var filter_model = $('input[name=\'filter_model\']').attr('value');
  url += '&filter_model=' + encodeURIComponent(filter_model);
	var filter_price = $('input[name=\'filter_price\']').attr('value');
	if(filter_price)  url += '&filter_price=' + encodeURIComponent(filter_price);
	var filter_oem = $('select[name=\'filter_oem\']').attr('value');
	if(filter_oem)  url += '&filter_oem=' + encodeURIComponent(filter_oem);
	var filter_quantity = $('input[name=\'filter_quantity\']').attr('value');
	if(filter_quantity) url += '&filter_quantity=' + encodeURIComponent(filter_quantity);
  var filter_cat = $('select[name=\'filter_cat\']').attr('value');
  if(filter_cat != '*') url += '&filter_cat=' + encodeURIComponent(filter_cat);
	location = url;
}
</script>
<?php echo $footer; ?>