<?php echo $header; ?>
<?php if ($error_warning) { ?>
<div class="warning"><?php echo $error_warning; ?></div>
<?php } ?>
<?php if ($success) { ?>
<div class="success"><?php echo $success; ?></div>
<?php } ?>
<div class="box">
  <div class="left"></div>
  <div class="right"></div>
  <div class="heading">
    <h1 style="background-image: url('view/image/product.png');"><?php echo $heading_title; ?></h1>
    <!-- no need insert, copy, delete , besso-201103 -->
    <!--div class="buttons">
      <a onclick="location = '<?php echo $insert; ?>'" class="button">
        <span><?php echo $button_insert; ?></span></a>
      <a onclick="$('#form').attr('action', '<?php echo $copy; ?>'); $('#form').submit();" class="button">
      <span><?php echo $button_copy; ?></span></a>
      <a onclick="$('form').submit();" class="button"><span><?php echo $button_delete; ?></span></a>
    </div-->
    <div class="buttons">
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
    </div>
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
            <td class="left"><?php if ($sort == 'pd.name') { ?>
              <a href="<?php echo $sort_name; ?>" class="<?php echo strtolower($order); ?>"><?php echo $column_name; ?></a>
              <?php } else { ?>
              <a href="<?php echo $sort_name; ?>"><?php echo $column_name; ?></a>
              <?php } ?></td>
            <td class="right"><?php if ($sort == 'p.model') { ?>
              <a href="<?php echo $sort_model; ?>" class="<?php echo strtolower($order); ?>"><?php echo $column_model; ?></a>
              <?php } else { ?>
              <a href="<?php echo $sort_model; ?>"><?php echo $column_model; ?></a>
              <?php } ?></td>
            <td class="right">
              <?php if ($sort == 'p.ws_price') { ?>
              <a href="<?php echo $sort_ws_price; ?>" class="<?php echo strtolower($order); ?>"><?php echo $column_ws_price; ?></a>
              <?php } else { ?>
              <a href="<?php echo $sort_ws_price; ?>"><?php echo $column_ws_price; ?></a>
              <?php } ?>
            </td>
            <td class="right">
              <?php if ($sort == 'p.rt_price') { ?>
              <a href="<?php echo $sort_rt_price; ?>" class="<?php echo strtolower($order); ?>"><?php echo $column_rt_price; ?></a>
              <?php } else { ?>
              <a href="<?php echo $sort_rt_price; ?>"><?php echo $column_rt_price; ?></a>
              <?php } ?>
            </td>
            <td class="right"><?php if ($sort == 'p.quantity') { ?>
              <a href="<?php echo $sort_quantity; ?>" class="<?php echo strtolower($order); ?>"><?php echo $column_quantity; ?></a>
              <?php } else { ?>
              <a href="<?php echo $sort_quantity; ?>"><?php echo $column_quantity; ?></a>
              <?php } ?></td>
            <td class="right"><?php echo $column_pc; ?></td>
            <td class="center"><?php echo $column_action; ?></td>
          </tr>
        </thead>
        <tbody>
          <tr class="filter">
            <!--td></td-->
            <td></td>
            <td><input type="text" name="filter_name" value="<?php echo $filter_name; ?>" class="long_input" /></td>
            <td class="right">
              <input type="text" name="filter_model_from" value="<?php echo $filter_model_from; ?>" class="short_input" /> - 
              <input type="text" name="filter_model_to" value="<?php echo $filter_model_to; ?>" class="short_input"  />
            </td>
            <td></td><!-- ws_price -->
            <td></td><!-- rt_price -->
            <td><input type="text" name="filter_quantity" value="<?php echo $filter_quantity; ?>" class="short_input" /></td><!-- quantity -->
            <td></td><!-- pieces -->
            <td align="right"><a onclick="filter();" class="button"><span><?php echo $button_filter; ?></span></a></td>
          </tr>
          <?php if ($products) { ?>
          <?php foreach ($products as $product) { ?>
          <tr>
            <!--td style="text-align: center;"><?php if ($product['selected']) { ?>
              <input type="checkbox" name="selected[]" value="<?php echo $product['product_id']; ?>" checked="checked" />
              <?php } else { ?>
              <input type="checkbox" name="selected[]" value="<?php echo $product['product_id']; ?>" />
              <?php } ?></td-->
              <input type="hidden" name="product_id" value="<?php echo $product['product_id']; ?>" />
            <td class="right">
              <img class='cPkg' src="<?php echo $product['image']; ?>" alt="<?php echo $product['name']; ?>" style="margin:0px; padding:0px; border:1px solid #DDDDDD;" />
            </td>
            <td class="left"><?php echo $product['name']; ?></td>
            <td class="right"><?php echo $product['model']; ?></td>
            <td class="right">
              <!--input type="text" name="upd_ws_price" value="<?php echo $product['ws_price']; ?>" class="short_input" readonly /-->
              <?php echo $product['ws_price']; ?>
            </td>
            <td class="right">
              <!--input type="text" name="upd_rt_price" value="<?php echo $product['rt_price']; ?>" class="short_input" readonly /-->
              <?php echo $product['rt_price']; ?>
            </td>
            <td class="right">
              <input type="text" name="quantity" value="<?php echo $product['quantity']; ?>" class="short_input" style='background-color:peru;' />
            </td>
            <td class="right"><?php echo $product['pc']; ?></td>
            <td class="right">
              <a class='button edit'><span>Edit</span></a>
            </td>
          </tr>
          <?php } ?>
          <?php } else { ?>
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

<!-- common detail div -->
<style>
#detail{
  position : absolute;
  top: 100px;
  left: 200px;
  visibility:hidden;
  border: 1px dotted green;
  z-index:2;
}
</style>
<div id='detail'></div>

<script type="text/javascript">
$(".edit").click(
  function(){
    var jNode = $(this).parent().parent();
    var html = jNode.html();
    var product_id = jNode.children("input[name=product_id]").attr("value");
    //var upd_ws_price = jNode.find("input[name=upd_ws_price]").attr("value");
    //var upd_rt_price = jNode.find("input[name=upd_rt_price]").attr("value");
    var quantity = jNode.find("input[name=quantity]").attr("value");
    url = 'index.php?route=product/inventory/update&token=<?php echo $token; ?>';
    url += '&product_id=' + encodeURIComponent(product_id);
    url += '&quantity=' + encodeURIComponent(quantity);
    //debugger;
    location = url;
  }
);


function update(){
  var target = $(event.srcElement);
  alert(target.nodeName);
  url = 'index.php?route=product/price/update&token=<?php echo $token; ?>';
  var eventTarget = $(event).srcElement;
  //var eventTarget = (event.target) ? jQuery(event.target) : jQuery(event.srcElement);
  //alert(eventTarget.id);
  debugger;
  
  var product_id = $('input[name=\'product_id\']').attr('value');
  var upd_ws_price = $('input[name=\'upd_ws_price\']').attr('value');
  var upd_rt_price = $('input[name=\'upd_rt_price\']').attr('value');
 	var filter_model_from = $('input[name=\'filter_model_from\']').attr('value');
	var filter_model_to = $('input[name=\'filter_model_to\']').attr('value');
	
	alert(product_id);
	alert(upd_ws_price);
	
	if (filter_model_from) {
	  if(!filter_model_to){
	    filter_model_to = filter_model_from;
	    
	    $('input[name=\'filter_model_to\']').val(filter_model_to);
	  }
		url += '&filter_model_from=' + encodeURIComponent(filter_model_from);
		url += '&filter_model_to=' + encodeURIComponent(filter_model_to);
	}

  url += '&product_id=' + encodeURIComponent(product_id);
  url += '&upd_ws_price=' + encodeURIComponent(upd_ws_price);
  url += '&upd_rt_price=' + encodeURIComponent(upd_rt_price);
  location = url;
}

function filter() {
	url = 'index.php?route=product/inventory&token=<?php echo $token; ?>';
	var filter_name = $('input[name=\'filter_name\']').attr('value');
	if (filter_name) {
		url += '&filter_name=' + encodeURIComponent(filter_name);
	}
	var filter_model_from = $('input[name=\'filter_model_from\']').attr('value');
	var filter_model_to = $('input[name=\'filter_model_to\']').attr('value');
	if (filter_model_from) {
	  if(!filter_model_to){
	    filter_model_to = filter_model_from;
	    
	    $('input[name=\'filter_model_to\']').val(filter_model_to);
	  }
		url += '&filter_model_from=' + encodeURIComponent(filter_model_from);
		url += '&filter_model_to=' + encodeURIComponent(filter_model_to);
	}
	var filter_price = $('input[name=\'filter_price\']').attr('value');
	if (filter_price) {
		url += '&filter_price=' + encodeURIComponent(filter_price);
	}
	var filter_quantity = $('input[name=\'filter_quantity\']').attr('value');
	if (filter_quantity) {
		url += '&filter_quantity=' + encodeURIComponent(filter_quantity);
	}
	location = url;
}

$(document).ready(function(){

  $('#form').click(function(event){
    var $tgt = $(event.target);
    if($tgt.is('img.cPkg')){
      var $pnt = $tgt.parents('tr'),
          $ele_pid = $pnt.find('input[name=product_id]'),
          $id = $ele_pid.val();
//debugger;
      $.ajax({
        type:'get',
        url:'index.php?route=product/inventory/callUpdatePannel',
        dataType:'html',
        data:'token=<?php echo $token; ?>&id=' + $id,
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
  });

  $('#form tr.filter input').keydown(function(e) {
  	if (e.keyCode == 13) {
  		filter();
  	}
  });
});
</script>

<?php echo $footer; ?>