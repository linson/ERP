<style>
input {
  width:60px;
  height:25px;
  font-size:20px;
  color:blue;
  font-weight:bold;
  background-color:white;
  display:block;
  margin-bottom:15px;
  margin-top:10px;
}
</style>
  <div id="oem">
    <div class="toolbar">
      <h1>OEM</h1>
      <a href="#" class="back">Back</a>
    </div>
    <form action="<?php echo $delete; ?>" method="post" enctype="multipart/form-data" id="form">
      <table class="list">
        <thead>
          <tr>
            <td class="right" style='width:100px' >Model</td>
            <!--td class="left">Name</td-->
            <td class='right'>Plus</td>
            <td class="right">Quantity</td>
            <td class='left'>Minus</td>
          </tr>
        </thead>
        <tbody>
          <?php foreach ($products as $product) { ?>
          <tr>
            <td class="right"><?php echo $product['model']; ?></td>
            <!--td class="left" style='width:200px'><?php echo $product['name']; ?></td-->
            <td class="right">
              <input type="number" name="plus" class='plus' value=""/>
            </td>
            <td class="right" style='width:50px'>
              <input type="number" name="quantity" value="<?php echo $product['quantity']; ?>" readonly/>
            </td>
            <td class="left">
              <input type="number" name="minus" class='minus' value=""/>
            </td>
          </tr>
          <?php } ?>
        </tbody>
      </table>
    </form>
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
        if('' == $plus){
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