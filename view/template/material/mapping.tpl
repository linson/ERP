<style>
.box{ z-index:10; }
.content .name_in_list{ color:purple; cursor:pointer; }
#detail{
  position:absolute;  top:100px;  left:200px;  visibility:hidden;
  border: 1px dotted green; z-index:2;
}
#lpanel{  float:left; width:400px;  }
#rpanel{  float:right;  }
#rpanel{  width:400px;  }
#btripTable{
  width:400px;  height:60px;  border:1px solid red;
  background-color:#e2e2e2;  padding-bottom:40px;
}
#btripTable tr{  vertical-align:top;  }
</style>
<div class="box">
  <div class="left"></div><div class="right"></div>
  <div class="heading">
    <h1 style="background-image: url('view/image/product.png');">
      Package Mapping <?php if($total) echo "(" . $total . ")";?> </h1>
    <div class="buttons">
      <a class="button"><span id='save'>Save</span></a>
      <a class="button"><span id='close'>Close</span></a>
    </div>
  </div>
  <?php
    $filter_code = '';
    $filter_name = '';
  ?>
  <div class="content" style='min-height:900px;width:800px;'>
    <div id='lpanel'>
    <?php 
      // no delete or so
      $delete = ''; 
    ?>
    <form action="<?php echo $delete; ?>" method="post" enctype="multipart/form-data" id="form">
      <table class="list" id='storeTable'>
        <thead>
          <tr>
            <td class="left">code</td>
            <td class="left">name</td>
          </tr>
          <!-- it's only for page module , besso-201103 -->
          <tr class="filter">
            <td>
              <input type="text" name="filter_code" value="<?php echo $filter_code; ?>" size='6' />
            </td>
            <td>
              <input type="text" name="filter_name" value="<?php echo $filter_name; ?>" size='15' />
            </td>
          </tr>
        </thead>  
        <tbody>
          <?php if(isset($packagelist)) { ?>
          <?php foreach ($packagelist as $row) { ?>
          <tr>
            <td class='center accountno_in_list'>
              <input type="hidden" name="id" class='id_in_list' value="<?php echo $row['code']; ?>" />
              <input type='hidden' name='view' value='proxy' />
              <?php echo $row['code']; ?>
            </td>
            <!--td class='center name_in_list'-->
            <td>
              <a onclick='' class='edit'>
              <?php echo $row['name']; ?></a>
            </td>
          </tr>
          <?php } // end foreach ?>
          <?php } else { ?>
          <tr>
            <td class="center" colspan="11">No Result</td>
          </tr>
          <?php } ?>
        </tbody>
      </table>
    </form>
    <!--div class="pagination"><?php echo $pagination; ?></div-->
    </div><!-- lpanel -->
    <div id='rpanel'>
	    <div id="startingPoint">
        <!-- start of map -->
        <?php
        //$this->log->aPrint( $product );
        ?>
        <table>
          <tr style='background:peru;'>
            <td colspan=2>
              <p style='color:white;width:16px;width:300px;height:20px;padding-left:20px;font-size:14px;font-wegiht:bold;'>
              Product</p>
            </td></tr>
          <tr>
            <td>
              <input type=hidden name='product_id' id='product_id' value='<?php echo $product['product_id']; ?>'>
              <img src="image/<?php echo $product['image']; ?>" alt="<?php echo $product['name']; ?>" style="margin:0px; padding:0px; border:1px solid #DDDDDD;width:80px;height:80px;" />
            </td>
            <td>
              <ul>
                <li><?php echo $product['model']; ?></li>
                <li><?php echo $product['name']; ?></li>
              </ul>
            <td>
          </tr>
  		  </table>
      </div>
      <?php
        if(isset($package)){
          $pkgHtml = '<tbody>';
          foreach($package as $exist){
            //$this->log->aPrint( $exist );
            $code = $exist['code'];
            $name = $exist['name'];
            $pkgHtml .=<<<HTML
              <tr class='ui-draggable'>
                  <td class='center accountno_in_list'>
                    <input name='id' class='id_in_list' value='$code' type='hidden'>
                    <input name='view' value='proxy' type='hidden'>
                    $code
                  </td>
                  <!--td class='center name_in_list'-->
                  <td>
                    <a onclick='' class='edit'>
                    $name
                    </a>
                  </td>
              </tr>
HTML;
          }
          $pkgHtml .= '</tbody>';
        }
      ?>
      <div>
        <table id='btripTable'>
        <?php   if(isset($package)) echo $pkgHtml; ?>
        </table>
      </div>
    </div>
  </div>
</div>

<script type="text/javascript">
$(document).ready(function(){
  $.fn.lookup = function(){
    //$('#detail').css('visibility','hidden');
  	var $product_id = $('#product_id').val(),
        $filter_code = $('input[name=\'filter_code\']').attr('value'),
        $filter_name = $('input[name=\'filter_name\']').attr('value'),
        $srcHtml = $('#btripTable').html();
    $.ajax({
      type:'get',
      url:'index.php?route=material/productpackage/callMapping',
      dataType:'html',
      data:'token=<?php echo $token; ?>&product_id=' + $product_id + '&filter_code=' + $filter_code + '&filter_name=' + $filter_name,
      success:function(html){
        $('#detail').css('visibility','visible');
        $('#detail').html(html);
        $('#btripTable').html($srcHtml);
      }
    });
  }

  $('input[name=filter_code]').keydown(function(e){
  	if(e.keyCode == 13) $.fn.lookup();
  });
  $('input[name=filter_name]').keydown(function(e){
  	if(e.keyCode == 13) $.fn.lookup();
  });

  $('#save').bind('click',function(e){
    //$('#detail').css('visibility','hidden');
  	var $product_id = $('#product_id').val(),
  	    $el_tr = $('#btripTable tbody').children("tr"),
  	    $el_package_id = $el_tr.find('.id_in_list'),
  	    $pkgid = '';
    jQuery.each($el_package_id, function(i,id){ $pkgid += id.value + ","; });
    $.ajax({
      type:'get',
      url:'index.php?route=material/productpackage/storeMapping',
      dataType:'html',
      data:'token=<?php echo $token; ?>&product_id=' + $product_id + '&pkgid=' + $pkgid,
      success:function(html){
        $('#detail').css('visibility','hidden');
        location.href = 'index.php?route=material/productpackage';
      }
    });
  });

  $('#close').click(function(e){
    $('#detail').css('visibility','hidden');
  });

  $(window).bind('scroll',function(){
    var winP = $(window).scrollTop()+215;
    var mapCss = {
      "position":"absolute",
      "top":winP +'px',
    }
    $("#btripTable").css(mapCss);
  });

  $('#storeTable tr').draggable({
    revert:'invalid',
    helper:'clone'
  });
  $('#btripTable').droppable({
    drop:function(event,ui){
      $('#btripTable').append(ui.draggable);
    }
  });
});
</script>