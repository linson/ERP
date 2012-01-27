<style>
.box {
  z-index:10;
}
.content .name_in_list{
  color:purple;
  cursor:pointer;
}
#detail{
  position : absolute;
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
    <h1 style="background-image: url('view/image/product.png');">
      Package Mapping <?php if($total) echo "(" . $total . ")";?> </h1>
    <div class="buttons">
      <a class="button"><span id='save'>save</span></a>
      <a class="button"><span id='close'>close</span></a>
    </div>
  </div>
  <?php
    $filter_code = '';
    $filter_name = '';
  ?>

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

  $.fn.lookup = function(){
    $('#detail').css('visibility','hidden');
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
  	    
    jQuery.each($el_package_id, function(i,id){ 
      $pkgid += id.value + ",";
    });

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
  
  $.fn.btripDND = function(){
    $('#btripTable tr').draggable({
      revert:'invalid',
      helper:'clone'
    });
    $('#storeTable').droppable({
      drop:function(event,ui){
        $('#storeTable').append(ui.draggable);
      }
    });
  }
  $.fn.btripDND();
  
  $('#batch').bind('click',function(event){
    $srcHtml = $('#storeTable>tbody').html();
    $('#btripTable').html('');
    $('#btripTable').append($srcHtml);
    var mapCss = {
      "position":"absolute",
      "top":'215px',
    }
    $("#btripTable").css(mapCss);
    $(window).unbind('scroll');
    $.fn.btripDND();
  });

	$('#btnLanLng').click(function(){
    var $ele_btrip = $('#btripTable'),
    	  $ele_tr = $ele_btrip.children(),
        aStore = new Array();
    //todo. so suck adhoc , besso 201105 
    if($ele_tr.is('tbody')){
      $ele_tr = $('#btripTable>tbody').children();
		}

		if($('#btrip_gmap_width').val() == "" || $('#btrip_gmap_height').val() == ""){
			alert("map size error");
			$('#btrip_gmap_width').focus() ;
		}else if($('#btrip_gmap_address').val() == ""){
			alert("AdDResS");
			$('#btrip_gmap_address').focus();
		}else{
      var geocoder = new google.maps.Geocoder();
      var address = $('#btrip_gmap_address').val();
			if(geocoder){
			  geocoder.geocode({ 'address': address }, function (results, status) {
				  if(status == google.maps.GeocoderStatus.OK) {
				    var $center = results[0].geometry.location;
				  	$lat_base = $center.lat(),
				  	$lng_base = $center.lng();
				  	$('#startLat').val($lat_base);
				  	$('#startLng').val($lng_base);
				  	//debugger;
            
            location1 = {lat:$lat_base,lng:$lng_base};
            var distance = new Array();
            $ele_tr.each(function(idx){
              $id  = $(this).find('input[name=id]').val();
              $lat = $(this).find('input[name=lat]').val();
              $lng = $(this).find('input[name=lng]').val();
              $name= $(this).find('.edit').html();
              $phone = $(this).find('.phone1_in_list').html();
              aStore.push([$lat,$lng,$id]);
              location2 = {lat:$lat,lng:$lng};
              $miles = $.fn.distance(location1,location2);
              //distance.push([$lat,$lng,$id,$miles]);
              distance[idx] = {lat:$lat, lng:$lng, id:$id, name:$name,phone:$phone,miles:$miles};
            });
            
            // sort with miles. distance
            distance.sort(function(a, b){
              //alert(a.miles);
              var milesA=a.miles, milesB=b.miles;
              if(milesA < milesB)
                return -1
              if (milesA > milesB)
                return 1
              return 0;
            });

            var directionsService = new google.maps.DirectionsService();
            var map;
            if(distance.length > 0){
              $('#map_canvas').css('visibility','visible');
              $('#directions_panel').css('visibility','visible');
              directionsDisplay = new google.maps.DirectionsRenderer();
              var startLatLng = new google.maps.LatLng($lat_base,$lng_base);
              var lastDistance = distance.pop();
              var endLatLng = new google.maps.LatLng(lastDistance.lat,lastDistance.lng);
              var myOptions = {
                  zoom: 6,
                  mapTypeId: google.maps.MapTypeId.ROADMAP,
                  center: startLatLng
              }
               
              map = new google.maps.Map(document.getElementById("map_canvas"),myOptions);
              directionsDisplay.setMap(map);  
              
              // way points
              var waypts = new Array();
              for(var i=0; i< distance.length; i++){
                wayLatLng = new google.maps.LatLng(distance[i].lat,distance[i].lng);
                waypts.push( { location:wayLatLng,stopover:true } );
              }

              // todo. hack for pararell pursue , besso 201105        
              //$.fn.displayDirectionRoute(startLatLng,endLatLng,waypts);
              //return;

              var request = {
                origin: startLatLng, 
                destination: endLatLng,
                waypoints: waypts,
                optimizeWaypoints: true,
                travelMode: google.maps.DirectionsTravelMode.DRIVING
              };

              directionsService.route(request,function(response,status){
                if (status == google.maps.DirectionsStatus.OK) {
                  directionsDisplay.setDirections(response);
                  var route = response.routes[0];

                  var summaryPanel = document.getElementById("directions_panel");
                  summaryPanel.innerHTML = "<a onclick=$('#map_canvas').css('visibility','hidden');$('#directions_panel').css('visibility','hidden'); style='display:block;background-color:black;color:white;font-size:16px;font-weight:bold;padding-bottom:3px;padding-right:3px;padding-left:3px;'>Close</a>";
                  // For each route, display summary information.
                  for (var i = 0; i < route.legs.length; i++) {
                    var routeSegment = i + 1;
                    summaryPanel.innerHTML += "<b>Route Segment: " + routeSegment + "</b><br />";
                    summaryPanel.innerHTML += route.legs[i].start_address + " to ";
                    summaryPanel.innerHTML += route.legs[i].end_address + "<br />";
                    summaryPanel.innerHTML += route.legs[i].distance.text + "<br /><br />";
                  }
                }
              });
            } // if count > 0
				  }else{  // init geocode call
				    	alert("Geocoding failed: " + status);
				  }
			  }); // get lat,lng 
	 		}
		}
	});

  // calculate distance
  $.fn.distance = function(location1,location2){
  	try{
  		var glatlng1 = new google.maps.LatLng(location1.lat, location1.lng);
  		var glatlng2 = new google.maps.LatLng(location2.lat, location2.lng);
  		//var miledistance = glatlng1.distanceFrom(glatlng2, 3959).toFixed(1);
  		var earth_radius_miles = 3963.19;
  		var miledistance = google.maps.geometry.spherical.computeDistanceBetween(glatlng1,glatlng2,earth_radius_miles); 
  		//var miledistance = google.maps.geometry.spherical.computeHeading(glatlng1,glatlng2); 
  		var kmdistance = (miledistance * 1.609344).toFixed(1);
  	  return miledistance;
  		//alert(miledistance);
  		//document.getElementById('results').innerHTML = '<strong>Address 1: </strong>' + location1.address + '<br /><strong>Address 2: </strong>' + location2.address + '<br /><strong>Distance: </strong>' + miledistance + ' miles (or ' + kmdistance + ' kilometers)';
  	}catch(error){
  		alert(error);
  	}
  }


  /** 
   * Calculate path between destinations. 
   * 
   * @param {Array<GOOGLE.MAPS.DIRECTIONSWAYPOINT>} destinations The list of destinations 
   *    to visit. 
   * @param {google.maps.DirectionsTravelMode} selectedMode The type of traveling: car, bike, or walking 
   * @param {bool} hwy Whether to avoid highways 
   * @param {bool} toll Whether to avoid tolled roads 
   * @param {bool} onlyCurrent If using multiple routes, do we want to show all of them or just the current 
   * @param {string} units The distance units to use, either "km" or "mi" 
   */
  /*
  $.fn.displayDirectionRoute = function(startLatLng,endLatLng,waypts,selectedMode,units){ 
       this.directionsDisplay.reset();
       // Add all destinations as markers. 
       var places = new Array(); 
       for(var i=0; i < destinations.length; i++) { 
            this.process_location_(destinations, i, places); 
       } 
       // Determine unit system. 
       var unitSystem = google.maps.DirectionsUnitSystem.IMPERIAL; 
       if(units == "km") 
            unitSystem = google.maps.DirectionsUnitSystem.METRIC; 
       
       // Loop through all destinations in groups of 10, and find route to display. 
       for(var idx1=0; idx1 < destinations.length-1; idx1+=9){ 
            // Setup options.
            // var idx2 = Math.min(idx1+9, destinations.length-1); 
            var request = { 
                origin: startLatLng, 
                destination: endLatLng,
                waypoints: waypts,
                optimizeWaypoints: true,
                travelMode: google.maps.DirectionsTravelMode.DRIVING
            };
      
            // Determine path and display results. 
            this.directionsService.route(request, function (response, status) { 
              if (status == google.maps.DirectionsStatus.OK) 
                this.directionsDisplay.parse(response, units); 
            }); 
       }
  }
  */

  /** 
   * Generates boxes for a given route and distance 
   * 
   * @param {google.maps.DirectionsResult} response The result of calculating 
   *    directions through the destinations. 
   */
  /*
  $.fn.displayDirectionParse = function(response,units){ 
    var routes = response.routes; 
    // Loop through all routes and append 
    for(var rte in routes){ 
         var legs = routes[rte].legs; 
         this.add_leg_(routes[rte].overview_path); 
         for(var leg in legs){ 
              var steps = legs[leg].steps; 
              // Compute overall distance and time for the trip. 
              this.overallDistance += legs[leg].distance.value; 
              this.overallTime += legs[leg].duration.value; 
         } 
    } 
    // Set zoom and center of map to fit all paths, and display directions. 
    this.fit_route_(); 
    this.create_stepbystep_(response, units); 
  }
  */

});

</script>