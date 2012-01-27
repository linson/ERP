jQuery(document).ready(function($){

	$('table.calendar').bind('click',function(event){
    $tgt = $(event.target);
    if($tgt.is('p.day_event')){
      var $pnt = $tgt.parents('span'),
          id = $pnt.find('input[name=id]').val(),
          title = $tgt.html(),
          slug = $pnt.find('input[name=slug]').val(),
          time = $pnt.find('input[name=time]').val()
          param = '';
      //debugger;
      if(id != '') param += '&id=' + encodeURIComponent(id);
      if(title != '')  param += '&title=' + encodeURIComponent(title);
      if(slug != '')  param += '&slug=' + encodeURIComponent(slug);
      if(time != '')  param += '&time=' + encodeURIComponent(time);

      $.ajax({
        type:'get',
        url:'index.php?route=sales/calendar/addEventPanel',
        dataType:'html',
        data:'token=' + token + param ,
        beforesend:function(){
          //console.log('beforesend');
        },
        complete:function(){
          //console.log('complete');
        },
        success:function(html){
  	  		var $calendarEvents = $('#calendar-events');			
          var $left = $(event.pageX);
          var $top= $(event.pageY);
          //debugger;
          $calendarEvents.css('display','block');
          $calendarEvents.css('position','absolute');
          $calendarEvents.css('background-color','#e2e2e2');
          $calendarEvents.css('top',$top[0]);
          $calendarEvents.css('left',$left[0]);
	        $calendarEvents.html(html);
	        $calendarEvents.draggable(); 
        },
        fail:function(){
          //console.log('fail : no response from proxy');
        }
      }); // end of ajax
	  }
  });

  // change to dynamic event driven , besso-201103 
	$('table.calendar a').each(function(i,item){
  	var linkId = item.id;
		$this = $(this);
    $this.click(function(event){
      event.preventDefault();
      $.ajax({
        type:'get',
        url:'index.php?route=sales/calendar/addEventPanel',
        dataType:'html',
        data:'token=' + token + '&time=' + linkId ,
        beforesend:function(){
          //console.log('beforesend');
        },
        complete:function(){
          //console.log('complete');
        },
        success:function(html){
  	  		var $calendarEvents = $('#calendar-events');			
          var $left = $(event.pageX);
          var $top= $(event.pageY);
          //debugger;
          $calendarEvents.css('display','block');
          $calendarEvents.css('position','absolute');
          $calendarEvents.css('background-color','#e2e2e2');
          $calendarEvents.css('top',$top[0]);
          $calendarEvents.css('left',$left[0]);
	        $calendarEvents.html(html);
	        $calendarEvents.draggable(); 
        },
        fail:function(){
          //console.log('fail : no response from proxy');
        }
      }); // end of ajax
    }); // end of click
	});
});