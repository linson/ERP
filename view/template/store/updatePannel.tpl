<style>
#tab_transfer,#tab_history{
  display:none;
}
#form .form{
  width:400px;
}
table.form tr td:first-child {
  width: 100px;
}
</style>
<div class="box" style='background-color:white;'>
  <div class="left"></div>
  <div class="right"></div>
  <div class="heading">
    <h1 style="background-image: url('view/image/product.png');">Store Update</h1>
    <div class="buttons">
      <a id='update_store' class="button">
        <span>Save</span></a>
      <a onclick="$('#detail').html(); $('#detail').css('visibility','hidden');" class="button">
        <span>Cancel</span></a>
    </div>
  </div>
  <div class="content">
    <div id="tabs" class="htabs">
      <a tab="#tab_general">Base Info</a>
      <a tab="#tab_trans_history">Comment</a>
      <a tab="#tab_ar_history">AR History</a>
      <a tab="#tab_maps">Map</a>
    </div>
    <form action="<?php echo $action; ?>" method="post" enctype="multipart/form-data" id="updateForm">
      <div id="tab_general">
        <?php
          //$this->log->aPrint( $store );
          $id  = $store['id'];
          $accountno = $store['accountno'];
          $name      = $store['name'];
          $storetype = $store['storetype'];
          $address1  = $store['address1'];
          $address2  = $store['address2'];
          $city      = $store['city'];
          $state     = $store['state'];
          $zipcode   = $store['zipcode'];
          $phone1    = $store['phone1'];
          $phone2    = $store['phone2'];
          $salesrep  = $store['salesrep'];
          $status    = $store['status'];
          $fax       = $store['fax'];
          $lat       = $store['lat'];
          $lng       = $store['lng'];
          $chrt      = $store['chrt'];
          $parent    = $store['parent'];
          $email     = $store['email'];
          $billto    = $store['billto'];
          $shipto    = $store['shipto'];
          $discount  = $store['discount'];
          $contact   = $store['owner'];
          $aDC = json_decode($discount,true);

          if(isset($aDC)){
            foreach($aDC as $k => $v){
              if("" == $v)  $aDC = array(); break;
            }
          }
          //$this->log->aPrint( $aDC );
          //$this->log->aPrint( count($aDC) );
        ?>
        <table class="form">
          <tr>
            <td class='label'>Acct.no</td>
            <td>
              <input type="hidden" name="id" size="50" value="<?php echo $id; ?>" readonly />
              <input type="text" name="accountno" size="6" value="<?php echo $accountno; ?>" style='background-color:#eeeeee' />
              <select name='storetype'>
                <option value='W' <?php if('W' == strtoupper($storetype)){ echo "selected"; } ?> >W</option>
                <option value='R' <?php if('R' == strtoupper($storetype)){ echo "selected"; } ?> >R</option>
              </select>
              <input type="text" name="salesrep" size="2" value="<?php echo $salesrep; ?>" />
            </td>
          </tr>
          <tr>
            <td class='label'>status</td>
            <td>
              <?php 
                $aStoreCode = $this->config->getStoreStatus(); 
              ?>
              <select name="status">
                <option value=""  <?php if(''==$status) echo 'selected'; ?>>--</option>
                <option value="0" <?php if('0'==$status) echo 'selected'; ?>><?php echo $aStoreCode['0']; ?></option>
                <option value="1" <?php if('1'==$status) echo 'selected'; ?>><?php echo $aStoreCode['1']; ?></option>
                <option value="2" <?php if('2'==$status) echo 'selected'; ?>><?php echo $aStoreCode['2']; ?></option>
                <!--option value="3" <?php if('3'==$status) echo 'selected'; ?>><?php echo $aStoreCode['3']; ?></option-->
                <option value="9" <?php if('9'==$status) echo 'selected'; ?>><?php echo $aStoreCode['9']; ?></option>
              </select>
            </td>
          </tr>
          <tr>
            <td class='label'>Name</td>
            <td><input type="text" name="name" size="50" value="<?php echo $name; ?>" /></td>
          </tr>
          <tr>
            <td class='label'>Address1</td>
            <td><input type="text" name="address1" size="50" value="<?php echo $address1; ?>" /></td>
          </tr>
          <!--tr>
            <td>Address2</td>
            <td><input type="text" name="address2" size="50" value="<?php echo $address2; ?>" /></td>
          </tr-->
          <tr>
            <td class='label'>City/State/Zip</td>
            <td>
              <input type="text" name="city" size="20" value="<?php echo $city; ?>" />/
              <input type="text" name="state" size="2" value="<?php echo $state; ?>" />/
              <input type="text" name="zipcode" size="5" value="<?php echo $zipcode; ?>" />
            </td>
          </tr>
          <tr>
            <td class='label'>Phone / Cell</td>
            <td>
              <input type="text" name="phone1" size="12" value="<?php echo $phone1; ?>" /> / 
              <input type="text" name="phone2" size="12" value="<?php echo $phone2; ?>" />
            </td>
          </tr>
          <tr>
            <td class='label'>fax</td>
            <td><input type="text" name="fax" size="20" value="<?php echo $fax; ?>" /></td>
          </tr>
          <tr>
            <td class='label'>Contact</td>
            <td><input type="text" name="contact" size="20" value="<?php echo $contact; ?>" /></td>
          </tr>
          <tr>
            <td class='label'>email</td>
            <td><input type="text" name="email" size="20" value="<?php echo $email; ?>" /></td>
          </tr>
          <tr>
            <td class='label'>Chicago Area</td>
            <td>
              <select name="chrt">
                <option value="0" <?php if('0'==$chrt) echo 'selected'; ?>>Not Area</option>
                <option value="1" <?php if('1'==$chrt) echo 'selected'; ?>>Chicago Area</option>
              </select>            
            </td>
          </tr>
          <tr>
            <td class='label'>Host account</td>
            <td><input type="text" name="parent" size="20" value="<?php echo $parent; ?>" /></td>
          </tr>
          <tr>
            <td class='label'>Bill To</td>
            <td><textarea name='billto' style='width:290px'><?php echo $billto; ?></textarea></td>
          </tr>
          <tr>
            <td class='label'>Ship To</td>
            <td><textarea name='shipto' style='width:290px'><?php echo $shipto; ?></textarea></td>
          </tr>
          <tr>
            <td class='label'>DC</td>
            <td>
              <?php
              if(count($aDC) > 0){
                $i=1;
                foreach($aDC as $k => $v){
                  $aT1 = explode('|',$v);
                  $dc = $aT1[0];
                  $desc = $aT1[1];
                ?>
                <input type="number" name="<?php echo 'dc'.$i ; ?>" size="1" value="<?php echo $dc; ?>" />%
                <input type="text" name="<?php echo 'dc'.$i.'_desc' ; ?>" size="40" value="<?php echo $desc; ?>" />
                <br/>
                <?php
                  $i++;
                }
              }else{
              ?>
                <input type="number" name="dc1" size="1" value="" />%
                <input type="text" name="dc1_desc" size="40" value="" /><br/>
                <input type="number" name="dc2" size="1" value="" />%
                <input type="text" name="dc2_desc" size="40" value="" /><br/>
              <?php
              }
              ?>
            </td>
          </tr>
        </table>
      </div>

      <!-- start of account history -->
      <div id='tab_ar_history' style='width:600px;'>
      </div><!--ar history-->

      <div id="tab_trans_history">
        <table class="form">
          <?php
          /***
          foreach($trans_history as $h){
          ?>
          <tr>
            <td><?php echo $h['assign_date']; ?></td>
            <td><?php echo $h['fromrep']; ?> ===> <?php echo $h['salesrep']; ?></td>
          </tr>
          <?php
          }
          ***/
          ?>
          <!--tr>To be done Later<td></td></tr-->
          <tr>
            <td>
              comment
            </td>
            <td>
              <textarea name='comment' style='width:400px;height:200px;'><?php echo $store['comment']; ?></textarea>
            </td>
          </tr>
        </table>
      </div>

      <!-- start of map -->
      <?php
      // custom map definition
      $gmap_width = '600';
      $gmap_height = '400';
      $gmap_zoom = '14';
      $gmap_type = 'roadmap';
      $gmap_address = $address1 . ' ' . $city . ' ' . $state . ' ' . $zipcode;
      ?>
	    <div id="tab_maps">
        <table class="form">        
            <!--tr>
            	<td><?php echo $entry_gmap_step1; ?></td>
            	<td>
            		<input type="text" id="gmap_width" name="gmap_width" size="4" value="<?php echo $gmap_width;?>" /> x <input type="text" id="gmap_height" name="gmap_height" size="4" value="<?php echo $gmap_height;?>" />&nbsp;&nbsp;&nbsp;
            		<select id="gmap_zoom" name="gmap_zoom">
            			<?php for($i = 0; $i <= 21; $i++){ ?>
            			<option value="<?php echo $i;?>" <?php echo $i == $gmap_zoom? "selected='selected'" : ""; ?>><?php echo $i;?></option>
            			<?php } ?>
            		</select>
            	</td>
            </tr-->
            <tr>
            	<td><?php echo $entry_gmap_step2; ?></td>
            	<td>
            		<select id="gmap_type" name="gmap_type">
            			<option value="roadmap" <?php echo 'satellite' == $gmap_type? "selected='selected'" : ""; ?>>Roadmap</option>
            			<!--option value="satellite" <?php echo 'satellite' == $gmap_type? "selected='selected'" : ""; ?>>Satellite</option-->
            			<option value="hybrid" <?php echo 'hybrid' == $gmap_type? "selected='selected'" : ""; ?>>Hybrid</option>
            			<option value="street" <?php echo 'street' == $gmap_type? "selected='selected'" : ""; ?>>Street</option>
            		</select>
            	</td>
            </tr>
            <tr>
              <td><?php echo $entry_gmap_step3; ?></td>
              <td>
              	<input type="text" id="gmap_address" name="gmap_address" value="<?php echo $gmap_address;?>" size="100" /> 
              	
              </td>
            </tr>        
            <tr>
            	<td>Latitude / Longitude</td>
            	<td>
            		<input type="text" id="lat" name="lat" value="<?php echo $lat;?>" /> /
            		<input type="text" id="lng" name="lng" value="<?php echo $lng;?>" />
            		&nbsp;
            		<a id="btn_get_lat_and_lng" class="button"><span>Get Lat/Lng</span></a>          		
            	</td>
            </tr>
            <tr>
            	<td><?php echo $entry_gmap_step5; ?></td>
            	<td>
            		<!--img id="gmap_preview_img" src="" style="display:none;" /-->
            		<div id="store_map_canvas" class="map" style="width:600px;height:400px"></div>
            	</td>
            </tr>
  		  </table>
		  </div>

		  <script type="text/javascript">
		  	$('#gmap_type').bind('change',function(){
  		  	$('#btn_get_lat_and_lng').click();
		  	});

		  	$('#btn_get_lat_and_lng').click(function(){
		  		if($('#gmap_width').val() == "" || $('#gmap_height').val() == ""){
		  			alert("<?php echo $error_gmap_size; ?>");
		  			$('#gmap_width').focus() ;
		  		}else if($('#gmap_address').val() == ""){
		  			alert("<?php echo $error_gmap_address; ?>");
		  			$('#gmap_address').focus();
		  		}else{
		  			var geocoder = new google.maps.Geocoder();
		  		  var address = $('#gmap_address').val();
		  			if(geocoder){
		  			  geocoder.geocode({ 'address': address }, function (results, status) {
		  				  if(status == google.maps.GeocoderStatus.OK) {
		  				    var $center = results[0].geometry.location;
		  				  	    $lat = $center.lat(),
		  				  	    $lng = $center.lng();
		  				  	$('#lat').val($lat);
		  				  	$('#lng').val($lng);
		  				  	//debugger;
		  				  	if($('#gmap_type').val() == 'street'){
		  				  	  var panoramaOptions = {   
		  				  	    position:$center,   
		  				  	    pov:{
		  				  	      heading:34,
		  				  	      pitch:10,
		  				  	      zoom:1
		  				  	    }
		  				  	  };
		  				  	  var panorama = new google.maps.StreetViewPanorama(document.getElementById("store_map_canvas"),panoramaOptions);
		  				  	  //map.setStreetView(panorama);
		  				  	}else{
  		  				  	var opt = {
  		  				  	  zoom:16,
  		  				  	  center:results[0].geometry.location,
                      mapTypeId: $('#gmap_type').val()
  		  				  	}
        		  			var map = new google.maps.Map(document.getElementById("store_map_canvas"),opt);               
                    var marker = new google.maps.Marker({
                      map:map,
                      position:results[0].geometry.location
                    });
                  }
		  				  }else{
		  				    	alert("Geocoding failed: " + status);
		  				  }
		  			  });
		     		}
		  		}
		  	});
		  	<?php
		  	if($lat != '' and $lng != ''){
		  	?>
		  	$('#btn_get_lat_and_lng').click();
		  	<?php
		  	}
		  	?>
		  </script>
		  <!--end of map-->
		</form>
  </div>
</div>

<script>
$(document).ready(function(){
  $.tabs('#tabs a'); 

  $.fn.arHistory = function(){
    $.ajax({
      type:'get',
      url:'index.php?route=sales/order/arHistory&token=<?php echo $token; ?>',
      dataType:'html',
      data:'store_id=<?php echo $id; ?>',
      success:function(html){
        $('#tab_ar_history').html(html);
      }
    });
  }

  $.fn.arHistory();

  $('#update_store').click(function(e){
    url = $('form#updateForm').attr('action');
    data= $('form#updateForm').serialize();
    $.post(url,data,function(){
      setTimeout("window.location.reload();",500);
    });
  });
});
</script>