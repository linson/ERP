<?php echo $header; ?>
<?php if($error_warning){ ?>
<div class="warning"><?php echo $error_warning; ?></div><?php } ?>
<?php if($success){ ?><div class="success"><?php echo $success; ?></div><?php } ?>
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
      Business Plan <?php if($total) echo "(" . $total . ")";?> </h1>
    <div class="buttons">
      <!--a class="button"><span id='batch'>Batch Move</span></a-->
    </div>
  </div>
  <?php
    // reset filter for quick re-query , besso-201103 
    // $filter_accountno = '';
    $filter_name = '';
    $filter_storetype = '';
    $filter_city = '';
    $filter_state = '';
    // $filter_phone1 = '';
    // todo. block later for user leveling
    //$filter_salesrep = '';
    //$filter_status = '';
    if(!$filter_status) $filter_status = '1';
  ?>

<style>
#lpanel{
  float:left;
  width:200px;
}
#rpanel{
  float:right;
}
#rpanel{
  width:400px;
}
#btripTable{
  width:200px;
  height:300px;
  border:1px solid red;
  background-color:#e2e2e2;
  padding-bottom:40px;
}
#btripTable tr{
  vertical-align:top;
}

</style>
  <div class="content" style='min-height:900px;width:600px;'>
    <div id='lpanel'>
    <?php 
      // no delete or so
      $delete = ''; 
    ?>
    <form action="" method="post" enctype="multipart/form-data" id="form">
      <table id='btripTable'>
        <?php
        for($i=0;$i<9;$i++){
        ?>
        <tr>
          <td>
            <input type=text name='account'        style='width:50px;'/>
            &nbsp;&nbsp;&nbsp;
            <input type='text' name='lat' value='' style='width:50px;'/>
            <input type='text' name='lng' value='' style='width:50px;'/>
            <input type='hidden' name='phone' value='''/>
          </td>
        </tr>
        <?php
        }
        ?>
      </table>
    </form>
    <!--div class="pagination"><?php echo $pagination; ?></div-->
    </div><!-- lpanel -->
    <div id='rpanel'>
	    <div id="startingPoint">
        <!-- start of map -->
        <?php
        // custom map definition
        $btrip_gmap_width = '400';
        $btrip_gmap_height = '300';
        $btrip_gmap_zoom = '14';
        $btrip_gmap_type = 'roadmap';
        $btrip_gmap_address = '220 s roselle rd schaumburg il';
        ?>
        <table>
            <tr style='background:peru;'>
              <td colspan=2>
                <p style='color:white;width:16px;width:300px;height:20px;padding-left:20px;font-size:14px;font-wegiht:bold;'>
                Starting Point</p>
              </td></tr>
            <tr>
            	<td>map type</td>
            	<td>
            		<select id="btrip_gmap_type" name="btrip_gmap_type">
            			<option value="roadmap" <?php echo 'satellite' == $btrip_gmap_type? "selected='selected'" : ""; ?>>Roadmap</option>
            			<!--option value="satellite" <?php echo 'satellite' == $btrip_gmap_type? "selected='selected'" : ""; ?>>Satellite</option-->
            			<option value="hybrid" <?php echo 'hybrid' == $btrip_gmap_type? "selected='selected'" : ""; ?>>Hybrid</option>
            			<option value="street" <?php echo 'street' == $btrip_gmap_type? "selected='selected'" : ""; ?>>Street</option>
            		</select>
            	</td>
            </tr>
            <tr>
              <td>address</td>
              <td>
              	<input type="text" id="btrip_gmap_address" name="btrip_gmap_address" value="<?php echo $btrip_gmap_address;?>" size="50" /> 
              </td>
            </tr>        
            <tr>
            	<td>Lat/Lng</td>
            	<td>
            		<input type="text" id="startLat" name="startLat" value="" size=3 /> /
            		<input type="text" id="startLng" name="startLng" value="" size=3 />
            		&nbsp;
            		<a id="batch" class="button"><span>Show map</span></a>          		
            	</td>
            </tr>
            <!--tr>
            	<td colspan=2>
            		<img id="btrip_gmap_preview_img" src="" style="display:none;" />
            		
            	</td>
            </tr-->
  		  </table>

      </div>
      <div>
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
  height:500px;
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
  $('input[name=account]')
  .bind('keydown',function(event){
    var $tgt = $(event.target);
    var $pnt = $tgt.parents('tr'),
        $account = $tgt.val();
    if( event.keyCode == 13){
      $pnt.next().find('input[name=account]').focus();
    }
  })
  .bind('focusout',function(event){
    var $tgt = $(event.target);
    var $pnt = $tgt.parents('tr'),
        $account = $tgt.val();
    $.ajax({
      type:'get',
      url:'index.php?route=store/list/getLatLng',
      dataType:'json',
      data:'token=<?php echo $token; ?>&account=' + $account,
      success:function(data){
        latlng = $.parseJSON(data);
        if( data['lat'] ){
          $pnt.find('input[name=lat]').val( data['lat'] );
          $pnt.find('input[name=lng]').val( data['lng'] );
//          $pnt.find('input[name=phone]').val( data['phone'] );
        }
      }
    });
  }); // end of click event
  
	$('#batch').click(function(){
    var $ele_btrip = $('#btripTable>tbody'),
    	  $ele_tr = $ele_btrip.children(),
        aStore = new Array();

    if($('#btrip_gmap_address').val() == ""){
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
            var labels = new Array();
            $ele_tr.each(function(idx){
              $account  = $(this).find('input[name=account]').val();
              if( $account != '' ){
                $lat = $(this).find('input[name=lat]').val();
                $lng = $(this).find('input[name=lng]').val();
                aStore.push([$lat,$lng,$account]);
                location2 = {lat:$lat,lng:$lng};
                $miles = $.fn.distance(location1,location2);
                //distance.push([$lat,$lng,$id,$miles]);
                distance[idx] = {lat:$lat,lng:$lng,id:$account,name:$account,phone:$account,miles:$miles};
                //labels[idx] = {lat:$lat,lng:$lng,id:$account,name:$account,phone:$account,miles:$miles};
              }
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
            
            labels = distance;

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
                //waypts.push( { location:wayLatLng,stopover:true,label:distance[i].account } );
                waypts.push( { location:wayLatLng,stopover:true } );
              }

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
                    summaryPanel.innerHTML += "<b>" + labels[routeSegment-1].name + " : " + routeSegment + "</b><br />";
                    summaryPanel.innerHTML += route.legs[i].start_address + " to <br/>";
                    summaryPanel.innerHTML += route.legs[i].end_address + "<br />";
                    summaryPanel.innerHTML += route.legs[i].distance.text + "<br /><br />";
//                    debugger;
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
<?php echo $footer; ?>