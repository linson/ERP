<style>
#edit_content{
  width:300px;
  border:1px dotted orange;
}
#edit_content .lbl{
  width:45px;
}
</style>
<?php
$start = substr($time,0,4) .'-'. substr($time,4,2) .'-'. substr($time,6,2);
?>
<div id="edit_content">
    <div id="tab_general">
      <table class="form" style='margin-bottom:0px'>
        <tr>
          <td class='lbl'>period</td>
          <td>
            <input type="text" name="start" class='date_pick' size="10" value="<?php echo $start; ?>"/>-
            <input type="text" name="end"   class='date_pick' size="10" value="<?php echo $start; ?>" />
          </td>
        </tr>
        <tr>
          <td class='lbl'>title</td>
          <td>
            <input type="hidden" name="id" value="<?php echo $id; ?>"/>
            <input type="hidden" name="time" value="<?php echo $time; ?>"/>
            <input type="text" name="title" size="35" value="<?php echo html_entity_decode($title); ?>" />
          </td>
        </tr>
        <tr>
          <td class='lbl'>Content</td>
          <td>
            <textarea name='slug' style='width:200px;height:150px;'><?php echo html_entity_decode($slug); ?></textarea>
          </td>
        </tr>
        <tr>
          <td class='lbl'>Time</td>
          <td>
            <?php echo substr($time,0,4) . '-' . substr($time,4,2) . '-' . substr($time,6,2); ?>
          </td>
        </tr>
        <tr>
          <td colspan=2>
            <a id='edit_event' class="button"><span>Edit</span></a>
            <a id='edit_delete' class="button"><span>Delete</span></a>
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
	  var id = $('#edit_content').find('input[name=\'id\']').attr('value');
	  if(id != '')  param += '&id=' + encodeURIComponent(id);
	  var start = $('#edit_content').find('input[name=\'start\']').attr('value');
	  if(start != '') param += '&start=' + encodeURIComponent(start);
    var end = $('#edit_content').find('input[name=\'end\']').attr('value');
	  if(end != '') param += '&end=' + encodeURIComponent(end);
	  var time = $('#edit_content').find('input[name=\'time\']').attr('value');
	  if(time != '')  param += '&time=' + encodeURIComponent(time);
	  var time = $('#edit_content').find('input[name=\'time\']').attr('value');
	  if(time != ''){
	  	param += '&time=' + encodeURIComponent(time);
	  }else{
      alert('time');  return false;
	  }
	  var title = $('#edit_content').find('input[name=\'title\']').attr('value');
	  if(title != ''){
	  	param += '&title=' + encodeURIComponent(title);
	  }else{
      alert('title'); return false;
	  }
	  var slug = $('#edit_content').find('textarea[name=\'slug\']').attr('value');
	  if(slug != ''){
	  	param += '&slug=' + encodeURIComponent(slug);
	  }else{
	    //alert('body');  return false;
    }
    $.fn.callAjax(param);
  }); // end of click

	$.fn.callAjax = function(param){
	  $.ajax({
      type:'get',
      url:'index.php?route=sales/calendar/updateEvent',
      dataType:'html',
      data:'token=' + token + param,
      success:function(rtn){
        //if("success" == rtn){
          $('#calendar-events').html();
          $('#calendar-events').css('display','none');
          window.location.reload(true);
        //}else{
          //alert('fail for ajax form');
        //}
      },
    }); // end of ajax
	}

	$('#edit_delete').click(function(event){
    event.preventDefault();
    var token = '<?php echo $token; ?>',
        param = '';
	  var id = $('#edit_content').find('input[name=\'id\']').attr('value');
	  if(id != '')  param += '&id=' + encodeURIComponent(id);
	  $.ajax({
      type:'get',
      url:'index.php?route=sales/calendar/deleteEvent',
      dataType:'html',
      data:'token=' + token + param,
      success:function(rtn){
        $('#calendar-events').html();
        $('#calendar-events').css('display','none');
        window.location.reload(true);
      },
    }); // end of ajax
  }); // end of click

	$('table.form').bind('focusin',function(event){
    var $tgt = $(event.target);
    if($tgt.is('input.date_pick')){
      $(".date_pick").datepicker({
        clickInput:true,
        createButton:false,
        startDate:'2000-01-01'
      });
    }
  });
});
</script>