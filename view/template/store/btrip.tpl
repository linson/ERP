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
      <a class="button">
        <span id='batch'>Batch Move</span></a>
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
  width:500px;
}
#rpanel{
  float:right;
}
#rpanel{
  width:400px;
}
#btripTable{
  width:400px;
  height:300px;
  border:1px solid red;
  background-color:#e2e2e2;
  padding-bottom:40px;
}
#btripTable tr{
  vertical-align:top;
}

</style>
  <div class="content" style='min-height:900px;width:906px;'>
    <div id='lpanel'>
    <?php 
      // no delete or so
      $delete = ''; 
    ?>
    <form action="<?php echo $delete; ?>" method="post" enctype="multipart/form-data" id="form">
      <table class="list" id='storeTable'>
        <thead>
          <tr>
            <td class="left">Acct.no</td>
            <td class="left">
              <?php if ($sort == 'name') { ?>
              <a href="<?php echo $sort_name; ?>" class="<?php echo strtolower($order); ?>">
                <?php echo $column_name; ?></a>
              <?php } else { ?>
              <a href="<?php echo $sort_name; ?>"><?php echo $column_name; ?></a>
              <?php } ?>
            </td>
            <td class="left">
              <?php if($sort == 'storetype'){ ?>
              <a href="<?php echo $sort_storetype; ?>" class="<?php echo strtolower($order); ?>">
                W/R</a>
              <?php } else { ?>
              <a href="<?php echo $sort_storetype; ?>">W/R</a>
              <?php } ?>
            </td>
            <!--td class="left">
              <?php echo $column_address1; ?>
            </td-->
            <td class="left">
              CITY
            </td>
            <td class="left">
              STATE
            </td>
            <!--td class="left">
              <?php echo $column_zipcode; ?>
            </td-->
            <td class="left">
              PHONE
            </td>
            <!--td class="left">FAX</td-->
            <!--td class="left">REP</td-->
            <!--td class="left">Balance</td-->
            <!-- todo. sort not work for status , besso-201103 -->
            <!--td class="left">
              <?php if($sort == 'status'){ ?>
              <a href="<?php echo $sort_status; ?>" class="<?php echo strtolower($order); ?>"><?php echo $column_status; ?></a>
              <?php }else{ ?>
              <a href="<?php echo $sort_status; ?>"><?php echo $column_status; ?></a>
              <?php } ?>
            </td-->
            <!--td class="right"><?php echo $column_action; ?></td-->
          </tr>
          <!-- it's only for page module , besso-201103 -->
          <tr class="filter">
            <td>
              <input type="text" name="filter_accountno" value="<?php echo $filter_accountno; ?>" size='6' />
            </td>
            <td>
              <input type="text" name="filter_name" value="<?php echo $filter_name; ?>" size='10' />
            </td>
            <td>
              <select name='filter_storetype'>
                <?php if (strtolower($filter_storetype) == 'w') { ?>
                  <option value="">--</option>
                  <option value="w" selected="selected">W</option>
                  <option value="r">R</option>
                <?php } elseif (strtolower($filter_storetype) == 'r') { ?>
                  <option value="">--</option>
                  <option value="w">W</option>
                  <option value="r" selected="selected">R</option>
                <?php }else{ ?>
                  <option value="" selected="selected">--</option>
                  <option value="w">W</option>
                  <option value="r">R</option>
                <?php }?>
              </select>
            </td>
            <td>
              <input type="text" name="filter_city" value="<?php echo $filter_city; ?>" size='8' />
            </td>
            <td>
              <input type="text" name="filter_state" value="<?php echo $filter_state; ?>" size='2' />
            </td>
            <td align="left">
              <input type="text" name="filter_phone1" value="<?php echo $filter_phone1; ?>" style="text-align: left;" size='12' />
            </td>
            <!--td align="left">
              <?php
              // todo. how to make beautiful user leveling , besso-201103 
              //if('11' != $this->user->getGroupID()){
              if($this->user->getGroupID()){
              ?>
              <input type="text" name="filter_salesrep" value="<?php echo $filter_salesrep; ?>" style="text-align: left;" size='8' />
              <?php
              }else{
                echo $this->user->getUserName();
              }
              ?>
            </td>
            <td></td>
            <td>
              <?php 
                $aStoreCode = $this->config->getStoreStatus(); 
              ?>
              <select name="filter_status">
                <option value="0" <?php if('0'==$filter_status) echo 'selected'; ?>><?php echo $aStoreCode['0']; ?></option>
                <option value="1" <?php if('1'==$filter_status) echo 'selected'; ?>><?php echo $aStoreCode['1']; ?></option>
                <option value="2" <?php if('2'==$filter_status) echo 'selected'; ?>><?php echo $aStoreCode['2']; ?></option>
                <option value="3" <?php if('3'==$filter_status) echo 'selected'; ?>><?php echo $aStoreCode['3']; ?></option>
                <option value="9" <?php if('9'==$filter_status) echo 'selected'; ?>><?php echo $aStoreCode['9']; ?></option>
              </select>    
            </td>
            <td align="right">
              <a onclick='filter();' class="button btn_filter">
                <span><?php echo $button_filter; ?></span>
              </a>
            </td-->
          </tr>
        </thead>  
        <tbody>
          <?php if ($store) { ?>
          <?php foreach ($store as $row) { ?>
          <tr>
            <td class='center accountno_in_list'>
              <input type="hidden" name="id" class='id_in_list' value="<?php echo $row['id']; ?>" />
              <input type='hidden' name='view' value='proxy' />
              <input type='hidden' class='address1_in_list' name='address1' value='<?php echo $row['address1']; ?>' />
              <input type='hidden' class='zipcode_in_list' name='zipcode' value='<?php echo $row['zipcode']; ?>' />
              <input type='hidden' class='fax_in_list' name='fax' value='<?php echo $row['fax']; ?>' />
              <input type='hidden' name='lat' value='<?php echo $row['lat']; ?>' />
              <input type='hidden' name='lng' value='<?php echo $row['lng']; ?>' />
              <?php echo $row['accountno']; ?>
            </td>
            <!--td class='center name_in_list'-->
            <td>
              <a onclick='' class='edit'>
              <?php echo $row['name']; ?></a>
            </td>
            <td class='center storetype_in_list'>
              <?php echo $row['storetype']; ?>
            </td>
            <td class='center city_in_list'>
              <?php echo $row['city']; ?>
            </td>
            <td class='center state_in_list'>
              <?php echo $row['state']; ?>
            </td>
            <td class='center phone1_in_list'>
              <?php echo $row['phone1']; ?>
            </td>
            <!--td class='center salesrep_in_list'>
              <?php echo $row['salesrep']; ?>
            </td>
            <td class='center salesrep_in_list'>
              <?php echo $row['balance']; ?>
            </td>
            <td class="left" class='status_in_list'><?php echo $aStoreCode[$row['status']]; ?></td>
            <td class="center">
              <a class='button edit'><span>More</span></a>
            </td-->
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
        // custom map definition
        $btrip_gmap_width = '400';
        $btrip_gmap_height = '300';
        $btrip_gmap_zoom = '14';
        $btrip_gmap_type = 'roadmap';
        $btrip_gmap_address = '220 s roselle rd schaumburg il';
        ?>
        <table>
            <!--tr>
            	<td><?php echo $entry_btrip_gmap_step1; ?></td>
            	<td>
            		<input type="text" id="btrip_gmap_width" name="btrip_gmap_width" size="4" value="<?php echo $btrip_gmap_width;?>" /> x <input type="text" id="btrip_gmap_height" name="btrip_gmap_height" size="4" value="<?php echo $btrip_gmap_height;?>" />&nbsp;&nbsp;&nbsp;
            		<select id="btrip_gmap_zoom" name="btrip_gmap_zoom">
            			<?php for($i = 0; $i <= 21; $i++){ ?>
            			<option value="<?php echo $i;?>" <?php echo $i == $btrip_gmap_zoom? "selected='selected'" : ""; ?>><?php echo $i;?></option>
            			<?php } ?>
            		</select>
            	</td>
            </tr-->
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
            		<a id="btnLanLng" class="button"><span>Get Lat/Lng</span></a>          		
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
        <table id='btripTable'>
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
  height:300px;
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
  function filter(){
  	var url = 'index.php?route=store/btrip';
    var filter_name = $('input[name=\'filter_name\']').attr('value');
  	if(filter_name)    url += '&filter_name=' + encodeURIComponent(filter_name);
  	var filter_accountno = $('input[name=\'filter_accountno\']').attr('value');
  	if(filter_accountno)   url += '&filter_accountno=' + encodeURIComponent(filter_accountno);
  	var filter_storetype = $('input[name=\'filter_storetype\']').attr('value');
  	if(filter_storetype) url += '&filter_storetype=' + encodeURIComponent(filter_storetype);
    var filter_storetype = $('select[name=\'filter_storetype\']').attr('value');
    if(filter_storetype != '') url += '&filter_storetype=' + encodeURIComponent(filter_storetype);
  	var filter_city = $('input[name=\'filter_city\']').attr('value');
  	if(filter_city)  url += '&filter_city=' + encodeURIComponent(filter_city);
  	var filter_state = $('input[name=\'filter_state\']').attr('value');
  	if(filter_state)  url += '&filter_state=' + encodeURIComponent(filter_state);
  	var filter_phone1 = $('input[name=\'filter_phone1\']').attr('value');
  	if(filter_phone1)   url += '&filter_phone1=' + encodeURIComponent(filter_phone1);
  	location = url;
  }
  $('#form input').keydown(function(e){
  	if(e.keyCode == 13) filter();
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
<?php echo $footer; ?>