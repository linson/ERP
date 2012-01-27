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
    <h1 style="background-image: url('view/image/product.png');">OEM</h1>
    <!-- no need insert, copy, delete , besso-201103 -->
    <!--div class="buttons">
      <a onclick="location = '<?php echo $insert; ?>'" class="button">
        <span><?php echo $button_insert; ?></span></a>
      <a onclick="$('#form').attr('action', '<?php echo $copy; ?>'); $('#form').submit();" class="button">
      <span><?php echo $button_copy; ?></span></a>
      <a onclick="$('form').submit();" class="button"><span><?php echo $button_delete; ?></span></a>
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
            <!--td class="center"><?php echo $column_image; ?></td-->
            <td class="right"><?php if ($sort == 'p.model') { ?>
              <a href="<?php echo $sort_model; ?>" class="<?php echo strtolower($order); ?>"><?php echo $column_model; ?></a>
              <?php } else { ?>
              <a href="<?php echo $sort_model; ?>"><?php echo $column_model; ?></a>
              <?php } ?></td>
            <td class="left"><?php if ($sort == 'pd.name') { ?>
              <a href="<?php echo $sort_name; ?>" class="<?php echo strtolower($order); ?>"><?php echo $column_name; ?></a>
              <?php } else { ?>
              <a href="<?php echo $sort_name; ?>"><?php echo $column_name; ?></a>
              <?php } ?></td>
            <td class='right'>Plus</td>
            <td class="right"><?php if ($sort == 'p.quantity') { ?>
              <a href="<?php echo $sort_quantity; ?>" class="<?php echo strtolower($order); ?>"><?php echo $column_quantity; ?></a>
              <?php } else { ?>
              <a href="<?php echo $sort_quantity; ?>"><?php echo $column_quantity; ?></a>
              <?php } ?></td>
            <td class='left'>Minus</td>
            <td style='width:400px'></td>
          </tr>
        </thead>
        <tbody>
          <?php if ($products) { ?>
          <?php foreach ($products as $product) { ?>
          <tr>
            <!--td style="text-align: center;"><?php if ($product['selected']) { ?>
              <input type="checkbox" name="selected[]" value="<?php echo $product['product_id']; ?>" checked="checked" />
              <?php } else { ?>
              <input type="checkbox" name="selected[]" value="<?php echo $product['product_id']; ?>" />
              <?php } ?></td-->
              <input type="hidden" name="product_id" value="<?php echo $product['product_id']; ?>" />
            <!--td class="right">
              <img class='cPkg' src="<?php echo $product['image']; ?>" alt="<?php echo $product['name']; ?>" style="margin:0px; padding:0px; border:1px solid #DDDDDD;" />
            </td-->
            <td class="right"><?php echo $product['model']; ?></td>
            <td class="left" style='width:200px'><?php echo $product['name']; ?></td>
            <td class="right">
              <input type="number" name="plus" class='plus' value="" size=3/>
            </td>
            <td class="right" style='width:50px'>
              <input type="number" name="quantity" value="<?php echo $product['quantity']; ?>" size=3 readonly/>
            </td>
            <td class="left">
              <input type="number" name="minus" class='minus' value="" size=3/>
            </td>
            <td style='width:700px'></td>
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
$(document).ready(function(){
  $('#form').bind('keydown',function(event){
    if(event.keyCode == '13'){
      var $tgt = $(event.target);
      if($tgt.is('input.plus')){
        $pnt = $tgt.parents('tr'),
               $ele_quantity = $pnt.find('input[name=quantity]'),
               $quantity = $ele_quantity.val(),
               $plus = $tgt.val(),
               $product_id = $pnt.find('input[name=product_id]').val();
        if('' == $plus){
          alert('No number'); 
          return false; 
        }
        $sum = parseInt($quantity) + parseInt($plus);
        $.fn.updateQuantity($product_id,$sum,$tgt);
        $ele_quantity.val($sum);
        $tgt.val('');
      }
      if($tgt.is('input.minus')){
        $pnt = $tgt.parents('tr'),
               $ele_quantity = $pnt.find('input[name=quantity]'),
               $quantity = $ele_quantity.val(),
               $minus = $tgt.val(),
               $product_id = $pnt.find('input[name=product_id]').val();
        if('' == $minus){
          alert('No number'); 
          return false;
        }
        $sum = parseInt($quantity) - parseInt($minus);
        $.fn.updateQuantity($product_id,$sum,$tgt);
        $ele_quantity.val($sum);
        $tgt.val('');
      }
    }
  });

  $.fn.updateQuantity = function(product_id,quantity,$tgt){
    $.ajax({
      type:'get',
      url:'index.php?route=product/oem/update',
      dataType:'html',
      data:'product_id=' + product_id + '&quantity=' + quantity,
      success:function(){
        $p = $tgt.position();
        $imgCss = {
          'visibility':'visible',
          'width':'80px',
          'height':'20px',
          'top':$p.top-30,
          'left':$p.left-30,
          'background-color':'black',
          'color':'white',
          'text-align':'center'
        }
        $('#detail').css($imgCss);
        $('#detail').html('success : ' + quantity );
        //$('#detail').draggable(); 
      },
      fail:function(){
      }
    });
  }

  // make key move like excel
  $('.list').keydown(function(event){
    var $tgt = $(event.target);
    // 38 up, 40 down, 37 left, 39 right
    if((('37' == event.which) || ('39' == event.which) ||
        ('38' == event.which) || ('40' == event.which) )
        && $tgt.is('input')){
      var $tgtName = 'input[name="' + $tgt.attr('name') + '"]',
          $pntTR = $tgt.parents('tr'),
          $pntTD = $tgt.parents('td'),
          //$downTgt = $pntTR.next().find($tgtName),
          // todo. keep the cnt only for keydown one , besso-201103 
          $downTgt = $pntTR.next().find($tgtName),
          $upTgt = $pntTR.prev().find($tgtName),
          $rightTgt = $pntTD.next().find('input'),
          $leftTgt = $pntTD.prev().find('input');
      if('37' == event.which){
        $leftTgt.select();
      }
      if('39' == event.which){
        $rightTgt.select();
      }
      if('38' == event.which){
        $upTgt.select();
      }
      if('40' == event.which){
        $downTgt.select();
      }
    }
  });
});
</script>
<?php echo $footer; ?>