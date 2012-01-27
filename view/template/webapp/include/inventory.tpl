  <div id="inventory">
    <div class="toolbar">
      <h1>Search Product</h1>
      <a href="#" class="back">Back</a>
    </div>
    <form action='' id='search'>
      <ul class="edit rounded">
        <li>
          <input type="number" name="model" placeholder="Model" id="model"/>
        </li>
      </ul>
      <ul class="edgetoedge" id="search-results">
          <li class="sep">Results</li>                
      </ul>
    </form>
  </div>

<script>
$(document).ready(function(){
	var $ele_model = $('#model'),
	    $model = $ele_model.val();
  $ele_model.val('');
  $ele_model.bind('focus',function(e){
    $ele_model.val('');
  });
  $('#model').live('keypress',function(event){
  	if(event.keyCode == 13){
      $('form#search').submit();
    }
  });
  // plus, minus button
  $('form#search').click(function(event){
    $tgt = $(event.target);
    if($tgt.is('.plus')){
      event.preventDefault();
      //$tgt.css('background-color','#53b401');
      //$tgt.css('background-color','red');
      $pnt = $tgt.parents('li');
      $ele_quantity = $pnt.children('#quantity');
      $qty = $ele_quantity.val();
      $sum = parseInt($qty) + parseInt(1);
      //debugger;
      $ele_quantity.val($sum);
      //$tgt.css('background-color','#222222');
      //$tgt.css('background','none');
    }
    if($tgt.is('.minus')){
      event.preventDefault();
      $pnt = $tgt.parents('li');
      $ele_quantity = $pnt.children('#quantity');
      $qty = $ele_quantity.val();
      $sum = parseInt($qty) - parseInt(1);
      //debugger;
      $ele_quantity.val($sum);
    }
    
    if($tgt.is('.addQty')){
      event.preventDefault();
      $pnt = $tgt.parents('li');
      $ele_quantity = $pnt.children('input[name=quantity]');
      $ele_pid = $pnt.children('input[name=pid]');
      $quantity = $ele_quantity.val();
      $pid = $ele_pid.val();
      $.getJSON("http://192.168.0.93/backyard/index.php?route=webapp/inventory/updateQuantity",
        { product_id: $pid, 
          quantity:$quantity
        },
        function(data){
          alert(data);
        }
      );
    }
  });
  $("#search").submit(function(event, info) {
    //var model = $("input[id=model]", this);
    $ele_model.blur();
 
    var results = $("#search-results", this).empty();
    results.append($("<li>", {
        "class": "sep",
        text: 'Results for "' + $ele_model.val() + '"'
    }));
    $.getJSON("http://192.168.0.93/backyard/index.php?route=webapp/inventory/getQuantity",
        { model: $ele_model.val() 
        },
        function(data){
          $.each(data, function(i,rtn) {
            $html = '<li><strong>' + rtn.model + '</strong><br/>' + rtn.name + '<br/>';
            $html+= '<input type="number" name="quantity" id="quantity" value="' + rtn.quantity + '" style="width:150px;height:35px;font-size:30px;color:blue;font-weight:bold;background-color:white;display:block;margin-bottom:15px;margin-top:10px;"/>';
            $html+= '<input type="hidden" name="pid" value="' + rtn.pid + '" />';
            $html+= '<a class="plus whiteButton" style="width:100px;display:inline;background-color:#222222;">+</a>';
            $html+= '<a class="minus whiteButton" style="width:10px;display:inline;margin-left:20px;background-color:#222222;">-</a>';
            $html+= '<a class="addQty whiteButton" style="width:100px;display:inline;margin-left:10px;background-color:#222222;margin-left:50px;">Add</a></li>';
            results.append($html);
          });
        }
    );
    return false;
  });
  //$("#search").submit();
});
</script>