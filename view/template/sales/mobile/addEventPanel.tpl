<style>
.edit_content{
  width:300px;
  border:1px dotted orange;
}
</style>
<?php
  $start = substr($time,0,4) .'-'. substr($time,4,2) .'-'. substr($time,6,2);
?>
<div class="edit_content">
    <div id="tab_general">
      <table class="form">
        <tr>
          <td>period</td>
          <td>
            <input type="text" name="start" class='date_pick' size="8" value="<?php echo $start; ?>"/>-
            <input type="text" name="end"   class='date_pick' size="8" value="" />
          </td>
        </tr>
        <tr>
          <td>title</td>
          <td>
            <input type="hidden" name="id" value="<?php echo $id; ?>"/>
            <input type="hidden" name="time" value="<?php echo $time; ?>"/>
            <input type="text" name="title" size="30" value="<?php echo $title; ?>" />
          </td>
        </tr>
        <tr>
          <td>Content</td>
          <td>
            <textarea name='slug' width=80px><?php echo $slug; ?></textarea>
          </td>
        </tr>
        <tr>
          <td>Time</td>
          <td>
            <?php echo $time; ?>
          </td>
        </tr>
        <tr>
          <td colspan=2>
            <a id='edit_event' class="button">
              <span>Edit</span></a>
            <a onclick="$('#calendar-events').html(); $('#calendar-events').css('display','none');" class="button">
              <span>Close</span></a>
          </td>
        </tr>
      </table>
    </div>
</div>
<script>
$(document).ready(function(){
  
	$('#edit_event').click(function(event){
    event.preventDefault();

    var token = '<?php echo $token; ?>',
        param = '';
    
	  var id = $('.edit_content').find('input[name=\'id\']').attr('value');
	  if (id != '') {
	  	param += '&id=' + encodeURIComponent(id);
	  }

	  var start = $('.edit_content').find('input[name=\'start\']').attr('value');
	  if (start != '') {
	  	param += '&start=' + encodeURIComponent(start);
	  }

    var end = $('.edit_content').find('input[name=\'end\']').attr('value');
	  if (end != '') {
	  	param += '&end=' + encodeURIComponent(end);
	  }

	  var time = $('.edit_content').find('input[name=\'time\']').attr('value');
	  if (time != '') {
	  	param += '&time=' + encodeURIComponent(time);
	  }

	  var time = $('.edit_content').find('input[name=\'time\']').attr('value');
	  if (time != '') {
	  	param += '&time=' + encodeURIComponent(time);
	  }else{
	    alert('time');
	    return false;
	  }
	  
	  var title = $('.edit_content').find('input[name=\'title\']').attr('value');
	  if (title != '') {
	  	param += '&title=' + encodeURIComponent(title);
	  }else{
	    alert('title');
	    return false;
	  }
    
	  var slug = $('.edit_content').find('textarea[name=\'slug\']').attr('value');
	  if (slug != '') {
	  	param += '&slug=' + encodeURIComponent(slug);
	  }else{
	    //alert('body');
	    //return false;
    }
    
    $.fn.callAjax(param);
  }); // end of click

	
	$.fn.callAjax = function(param){
	  $.ajax({
      type:'get',
      url:'index.php?route=sales/calendar/updateEvent',
      dataType:'html',
      data:'token=' + token + param,
      beforesend:function(){
        //console.log('beforesend');
      },
      complete:function(){
        //console.log('complete');
      },
      success:function(rtn){
        //if("success" == rtn){
          $('#calendar-events').html();
          $('#calendar-events').css('display','none');
          window.location.reload(true);
        //}else{
          //alert('fail for ajax form');
        //}
      },
      fail:function(){
        //console.log('fail : no response from proxy');
      }
    
    }); // end of ajax
	}
	
	$('table.form').bind('focusin',function(event){ 
    var $tgt = $(event.target);
    if($tgt.is('input.date_pick')){
      $(".date_pick").datePicker({
        clickInput:true,
        createButton:false,
        startDate:'2000-01-01'
      });
    }
    debugger;
  });
});
</script>