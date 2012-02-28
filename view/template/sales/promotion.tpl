<?php
  $filter_code = '';
  $filter_name = '';
?>

<?php echo $header; ?>

<style>
.box{
  z-index:10;
}
.content .name_in_list{
  color:purple;
  cursor:pointer;
}
#detail{
  position:absolute;
  top: 100px;
  left: 200px;
  visibility:hidden;
  border: 1px dotted green;
  z-index:2;
}
</style>

<div class="box">
  <div class="left"></div>
  <div class="right"></div>
  <div class="heading">
    <h1 style="background-image: url('view/image/product.png');">Update Promotion</h1>
    <div class='buttons'>
      <a href=<?php echo $lnk_promotion_history ?> class='button'><span>Promotin History</span></a>
    </div>
  </div>

<style>
#lpanel{
  float:left;
  width:400px;
}
#rpanel{
  float:right;
}
#rpanel{
  width:400px;
}
#btripTable{
  width:400px;
  height:60px;
  border:1px solid red;
  background-color:#e2e2e2;
  padding-bottom:40px;
}
#btripTable tr{
  vertical-align:top;
}
</style>
  <div class="content" style='min-height:900px;width:800px;'>
    <div id='lpanel'>
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
        </tbody>
      </table>

    <!--div class="pagination"><?php echo $pagination; ?></div-->
    </div><!-- lpanel -->
    <div id='rpanel'>
	    <form id='form_promotion' action='index.php?route=sales/promotion/insert'>
	    <div id="startingPoint">
        <!-- start of map -->
        <table>
          <tr style='background:peru;'>
            <td colspan=2>
              <p style='color:white;width:16px;width:300px;height:20px;padding-left:20px;font-size:14px;font-wegiht:bold;'>
              Promotion</p>
            </td></tr>
          <tr>
            <td style='width:100px;text-align:center;'>Title</td>
            <td>
              <input type=text name='name' value=''>
            </td>
          </tr>
          <tr>
            <td style='width:100px;text-align:center;'>Price</td>
            <td>
              Over <input type=text name='price' value=''>
              <select name='target'>
                <option value='R' selected>R</option>
                <option value='W'>W</option>
              </select>
            </td>
          </tr>
          <tr>
            <td style='width:100px;text-align:center;'>Period</td>
            <td>
              <input type="text" class='date_pick' name="promotion_from" value="" style='width:60px;' />
              -
              <input type="text" class='date_pick' name="promotion_to" value="" style='width:60px;' />
              <a id='update_promotion' class='button'><span>Update</span></a>
            </td>
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
      </form>
    </div>
  </div>
</div>
<!-- common detail div -->
<style>
#detail{
  z-index:10;
}
</style>
<div id='detail'></div>
<style>
#map_canvas{
  visibility:hidden;
  position:absolute;
  top:0px;
  left:0px;
  width:800px;
  height:600px;
  z-index:10;
}
#directions_panel{
  visibility:hidden;
  position:absolute;
  top:0px;
  left:800px;
  width:160px;
  background-color:#FFEE77;
  padding-left:10px;
  z-index:10;
}
</style>
<div id="map_canvas" class="map"></div>
<div id="directions_panel" style=""></div>

<script type="text/javascript">
$(document).ready(function(){
  $('.filter input').keydown(function(e){
  	if(e.keyCode == 13){
  	  filter_code = $('input[name=\'filter_code\']').attr('value');
  	  filter_name = $('input[name=\'filter_name\']').attr('value');
	    $.fn.displayList(filter_code,filter_name);
  	}
  });

  $('.content').click(function(event){
    var $tgt = $(event.target);
    //if($tgt.is('a.edit>span')){
    if($tgt.is('a.edit')){
      var $pnt = $tgt.parents('tr'),
          $ele_id = $pnt.find('.id_in_list'),
          $store_id = $ele_id.val();
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
          $('#detail').draggable(); 
        },
        fail:function(){
          //console.log('fail : no response from proxy');
        }
      });
    }
  }); // end of click event

  $('#update_promotion').bind('click',function(e){
    $form  = $('#form_promotion');
    $title = $form.find('input[name=name]').val();
    if($title == ''){
      alert('input title'); return;
    }
    $price = $form.find('input[name=price]').val();
    if($price == ''){
      alert('input price'); return;
    }
    $from  = $form.find('input[name=promotion_from]').val();
    if($from == ''){
      alert('input from'); return;
    }
    $to    = $form.find('input[name=promotion_to]').val();
    if($to == ''){
      alert('input to'); return;
    }
    if( $('#btripTable').html().trim() == '' ){
      alert('choose product'); return;
    }
    
    $.post( $form.attr('action') , $form.serialize() , function(data){
      if(data == '1'){
        $('#btripTable').html('');
        $form.find('input[name=price]').val('')
      }
    });
  });

  $(window).bind('scroll',function(){
    var winP = $(window).scrollTop()+215;
    var mapCss = {
      "position":"absolute",
      "top":winP +'px',
    }
    $("#btripTable").css(mapCss);
  });
  
  // date picker binding
  $('#form_promotion').bind('focusin',function(event){
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

  $.fn.displayList = function($filter_code,$filter_name){
    //if('undefined' == $filter_code) $filter_code = '';
    //if('undefined' == $filter_name) $filter_name = '';
    $.ajax({
      type:'get',
      url:'/backyard/index.php?route=sales/promotion/ajax_list',
      dataType:'html',
      data:'filter_code='+$filter_code+'&filter_name='+$filter_name,
      success:function(html){
        $('#storeTable tbody').html(html);
      }
    });
  }

  $.fn.displayList('','');

}); 

</script>
<?php echo $footer; ?>