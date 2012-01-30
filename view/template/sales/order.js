$(document).ready(function(){
  var $ele_amount = $('#payment').find('input[name=order_price]'),
      $ele_payed_sum = $('#payment').find('input[name=payed_sum]'),
      $ele_balance = $('#payment').find('input[name=balance]'),
      $el_freegood_amount = $('#freegood_amount'),
      $el_freegood_percent = $('#freegood_percent');

  //////////////////////////////////////////////////////////////////////////////
  // PROMOTION manually !!
  // It's just Description management
  //////////////////////////////////////////////////////////////////////////////
  // todo. make simplify
  $.fn.managePromotion = function($model,$cnt){
    $added = '';
    $msg = '';
    $cnt = parseInt($cnt);
    // A. order_price basement
    $order_price = $('input[name=order_price]').val();
    $storetype = $('input[name=storetype]').val();
    $el_desc = $('textarea[name=description]');
    $ship_method = $('select[name=ship_method]').val();

    if( 'W' == $storetype ){
      if( ('3S8623' == $model ) || ('3S8627' == $model ) ){
        $msg = '[Promotion A] WWW 2oz 5% discount \n';
        $ptn = /(\[Promotion A\] WWW.+\n?)/;
        if( $el_desc.val().match($ptn) )  $el_desc.val( $el_desc.val().replace($ptn,'') );
        if( $added.match($ptn) )  $added = $added.replace($ptn,'');
        $added = $added + $msg;
      }

      if( $model.substring(2,6) >= '7110' && $model.substring(2,6) <= '7117' ){
        $msg = '[Promotion A] IRIE DRED 10% discount \n';
        $ptn = /(\[Promotion A\] IRIE DRED 10.+\n?)/;
        if( $el_desc.val().match($ptn) )  $el_desc.val( $el_desc.val().replace($ptn,'') );
        if( $added.match($ptn) )  $added = $added.replace($ptn,'');
        $added = $added + $msg;
      }
    }

    if( 'R' == $storetype && 'ups' == $ship_method ){
      $ptn = /(\[Promotion A\].+\n?)/;
      /***
      if($order_price >= 1000){
        $msg = '[Promotion A] over $1000 , Lace + Spiritz + Wig shine(2oz) + A/E Wig Spray(4oz) \n';
      }else if($order_price >= 700){
        $msg = '[Promotion A] over $700 , Lace + Spiritz + Wig shine(2oz) \n';
      }else ***/
      if($order_price >= 500){
        $msg = '[Promotion A] over $500 , Lace + Wig shine (2oz) \n';
      }else if($order_price >= 300){
        $msg = '[Promotion A] over $300 , Lace 0.5 oz Bond \n';
      }
      if( $el_desc.val().match($ptn) )  $el_desc.val( $el_desc.val().replace($ptn,'') );
      if( $added.match($ptn) )  $added = $added.replace($ptn,'');
      $added = $added + $msg;
    }

    if( 'R' == $storetype ){
      if( 'AE8109' == $model && $cnt >= 5){
        //console.log($model);  console.log($cnt);
        $msg = '[Promotion B] N/Shampoo Buy 5 Get 1 Free \n';
        $ptn = /(\[Promotion B\] N\/Shampoo.+\n?)/;
        if( $el_desc.val().match($ptn) )  $el_desc.val( $el_desc.val().replace($ptn,'') );
        if( $added.match($ptn) )  $added = $added.replace($ptn,'');
        $added = $added + $msg;
      }
      
      if( 'IR7117' == $model && $cnt > 0){
        $ptn = /(\[Promotion B\] I\/D.+\n?)/;
        $msg = '[Promotion B] I/D Display 10% DC \n';
        if( $el_desc.val().match($ptn) )  $el_desc.val( $el_desc.val().replace($ptn,'') );
        if( $added.match($ptn) )  $added = $added.replace($ptn,'');
        $added = $added + $msg;
      }

      if( ( $model.substring(2,6) >= '7110' && $model.substring(2,6) <= '7117' )
          && $cnt >= 5 ){
        $msg = '[Promotion B] IRIE DRED buy 5 free 1 \n';
        $ptn = /(\[Promotion B\] IRIE DRED buy.+\n?)/;
        if( $el_desc.val().match($ptn) )  $el_desc.val( $el_desc.val().replace($ptn,'') );
        if( $added.match($ptn) )  $added = $added.replace($ptn,'');
        $added = $added + $msg;
      }
  
      if($added != ''){
        if($el_desc.val() != ''){
          $el_desc.val( $added + $('textarea[name=description]').val() );
        }else{
          $el_desc.val( $added );
        }
      }
    } // only for retail
  }

  var $_count,$_free,$_dc1,$_dc2,$_total,$_amount;
  $('#order').bind('keydown',function(event){
    var $tgt = $(event.target);
    // 38 up, 40 down, 37 left, 39 right
    if((('37' == event.which) || ('39' == event.which) ||
        ('38' == event.which) || ('40' == event.which) || ('13' == event.which))
        && $tgt.is('input')){
      var $tgtName = 'input[name="' + $tgt.attr('name') + '"]',
          $pntTR = $tgt.parents('tr'),
          $pntTD = $tgt.parents('td'),
          $pntDIV = $tgt.parents('div'),
          $downTgt = $pntTR.next().find($tgtName)[0],
          // todo. keep the cnt only for keydown one , besso-201103 
          //$downTgt = $pntTR.next().find('input[name="cnt[]"]'),
          $upTgt = $pntTR.prev().find($tgtName)[0],
          //$rightTgt = $pntDIV.next().find('input').filter(':visible'),
          $rightTgt = $pntDIV.nextAll().find('input:visible')[0],
          //$rightTgt = $pntDIV.next().find('input'),
          $leftTgt  = $pntDIV.prevAll().find('input:visible')[0];

      if( $pntTD.hasClass('left') ){
        $upTgt   = $pntTR.prevAll().find('td.left').find($tgtName)[0];
        $downTgt = $pntTR.nextAll().find('td.left').find($tgtName)[0];
      }else{
        $upTgt   = $pntTR.prevAll().find('td.right').find($tgtName)[0];
        $downTgt = $pntTR.nextAll().find('td.right').find($tgtName)[0];
      }
      
      //todo. need test
      event.preventDefault();

      if('37' == event.which){
        $leftTgt.select();  //left
      }
      if('39' == event.which){
        $rightTgt.select();  //right
      }
      if('38' == event.which)  $upTgt.select();
      if('40' == event.which)  $downTgt.select();
      if('13' == event.which){
        $rightTgt.select();
        if($downTgt.length == 0){
          /*
          if( $pntTD.hasClass('left') ){
            $pntTR.find('td.right')[0].select();
          }else{
            $rightTgt.select();
          }
          */
          $rightTgt.select();
        }else{
          $downTgt.select();
        }
      }
    }
  });

  // generate total price
  // todo. we must keep the inventory for Damage , besso 201105
  // todo. focusout or change
  $('div#order')
  .bind('focusin.sales',function(event){
    $tgt = $(event.target),$node = $tgt.parents('td');
    $_count = $node.find('input[name="cnt[]"]').val();
    $_free = $node.find('input[name="free[]"]').val();
    $_damage = $node.find('input[name="damage[]"]').val();
    $_promotion = $node.find('input[name="promotion[]"]').val();
    $_total = $node.find('input[name="total_price[]"]').val();
    $_weight_row = $node.find('input[name="weight_row[]"]').val();

    if($tgt.is('input')){
      var $node = $tgt.parents('td');
      $('#order td').css('background-color','white');
      $node.css('background-color','yellow');
    }
  })
  .bind('focusout.sales',function(event){
    $tgt = $(event.target);
    //todo. add price for price change
    if($tgt.is('input[name="price[]"]') || 
       $tgt.is('input[name="cnt[]"]') || 
       $tgt.is('input[name="free[]"]') || 
       $tgt.is('input[name="damage[]"]') || 
       $tgt.is('input[name="promotion[]"]') || 
       $tgt.is('input[name="discount[]"]') || 
       $tgt.is('input[name="discount2[]"]') ){

      $ptn = /\d/;
      if( !$ptn.test($tgt.val()) ){
        $tgt.val('0');
      }
      $.fn.setOneRow($tgt);
    }
  });

  // Control one raw and total order price / balance , Weight
  $.fn.setOneRow = function($tgt){
    var $node = $tgt.parents('td'),
        $stock = $node.find('input[name="stock[]"]').attr('value'),
        $price = parseFloat($node.find('input[name="price[]"]').attr('value')),
        $weight= $node.find('input[name="weight[]"]').attr('value'),
        $damageObj= $node.find('input[name="damage[]"]'),
        $el_promotion= $node.find('input[name="promotion[]"]'),
        $countObj = $node.find('input[name="cnt[]"]'),
        $el_free= $node.find('input[name="free[]"]'),
        $discountObj = $node.find('input[name="discount[]"]'),
        $discount2Obj = $node.find('input[name="discount2[]"]'),
        $model = $node.find('input[name="model[]"]').val();

    var $free = '0', $damage = '0', $promotion = 0, $count = '0', $discount = '0', $weight_row = '0', $dc1 = 0, $dc2 = 0;
    if("" == $el_free.val() || "f" == $el_free.val() ){
      $el_free.val('0');
    }
    if("" == $countObj.attr('value')  ) $countObj.val('0');
    if("" == $damageObj.attr('value') || "d" == $damageObj.attr('value') )        $damageObj.val('0');
    if("" == $el_promotion.attr('value') || "p" == $el_promotion.attr('value') )  $el_promotion.val('0');
    if("" == $discountObj.attr('value') || "d1" == $discountObj.attr('value') ) $discountObj.val('0');
    if("" == $discount2Obj.attr('value') || "d2" == $discount2Obj.attr('value') ) $discount2Obj.val('0');

    // changed
    $count = $countObj[0].value;      $_count = $count - $_count;
    $dc1 = $discountObj[0].value;
    $dc2 = $discount2Obj[0].value;

    //$ptn = /[0-9]+/;
    $free = $el_free[0].value;
    //if( !$free.match($ptn) )  alert('freegood should be number');
    if(isNaN($_free)) $_free = 0;
    $_free = $free - $_free;
    
    
    $damage = $damageObj[0].value;
    if(isNaN($_damage)) $_damage = 0;
    $_damage = $damage - $_damage;

    $promotion = $el_promotion[0].value;
    if(isNaN($_promotion)) $_promotion = 0;
    $_promotion = $promotion - $_promotion;

    $total = 0;
    // todo. i know there is more better way to lessen ajax transaction
    //if( $_count == 0 && $_free == 0 && $_damage == 0 ){      return;    }

    ///// main calc /////
    //todo. it should be independent object, do not lookup before value !
    //$total_diff = parseFloat( $price * $_count );
    //$total = $total_diff + parseFloat($_total);
    $total = parseFloat( $price * $count );
    $total  = $total.toFixed(2);
    
    // todo. this for freegood without DC apply
    // $total_wo_dc = $total;
    
    // dc is pure sum of current val ( not before value calculation )
    // it's sequencial calc, dc1 first and dc2
    if( $dc1 > 0 ){
      $total = parseFloat( parseFloat($price) * parseFloat($count) * ((100-$dc1) / 100) );
    }
    if( $dc2 > 0 ){
      if( !($dc1 > 0) ) $total = parseFloat($price) * parseFloat($count);
      $total = parseFloat( $total * ((100-$dc2) / 100) );
    }
    // todo. omg store discount. do just once.
    $store_dc1 = $('input[name=dc1]').val();
    $store_dc2 = $('input[name=dc2]').val();
    if($store_dc1 > 0){
      $total = parseFloat( $total * ((100 - $store_dc1) / 100) );
    }
    if($store_dc2 > 0){
      $total = parseFloat( $total * ((100 - $store_dc2) / 100) );
    }
    // used ceil instead of round , besso 201108 
    if ( $dc1 > 0 || $dc2 > 0 || $store_dc1 > 0 || $store_dc2 > 0 ){
      $total = Math.round( $total * 100 ) / 100;
    }
    $node.find('input[name="total_price[]"]').val($total);

    $total_diff = $total - $_total;
    $order_price = $('#form').find('input[name=order_price]').val();

    $order_price = parseFloat($order_price) + parseFloat($total_diff);
    $order_price = $order_price.toFixed(2);
    $('#form').find('input[name=order_price]').val($order_price);

    $balance = parseFloat($order_price) - parseFloat($ele_payed_sum.val());
    $ele_balance.val($balance);

    // todo. think more with sales
    $weight_row_diff = parseFloat( $_count + $_free + $_damage ) * parseFloat($weight);
    $weight_row = parseFloat($_weight_row) + parseFloat($weight_row_diff);
    $node.find('input[name="weight_row[]"]').val($weight_row);

    // todo. weight need to test severely later , besso-201103
    $weight_sum  = $('#form').find('input[name="weight_sum"]').val();
    $weight_sum  = parseFloat($weight_sum) + $weight_row_diff;
    $('#form').find('input[name="weight_sum"]').val($weight_sum);

    //todo. need to talk for ship method more, it will be weight , right?
    if( $ele_amount.val() > 3000 )  $('#ship').find("select[name='method[]'] option[value=truck]").attr('selected',true);

    // tune balance 
    //if(false == $.fn.validateAR()){      alert('AR Problem, all stop and ask IT team');    }

    // maintain freegood consistency
    // all freegood is to be substained by cod / lift
    $free_diff = parseFloat( $price * $_free );
    $freegood_amount = $('#form').find('#freegood_amount').val();
    $freegood_amount = parseFloat($freegood_amount) + $free_diff;
    $('#form').find('#freegood_amount').val($freegood_amount);
    
    //if($order_price > 0){
      $origin_order_price = $order_price;
      $cod = $('input[name=ship_cod]').val();
      $lift = $('input[name=ship_lift]').val();
      if($cod || $lift){
        $order_price = parseFloat($order_price) - parseFloat($cod) - parseFloat($lift);
      }
      $freePercent = parseFloat( $freegood_amount / $order_price * 100 );
      $freePercent = $freePercent.toFixed(2);
      if( isNaN( $freePercent) ) $freePercent = 0;
      $('#freegood_percent').val($freePercent);
      if($('#freegood_percent').val() > 10){
        $('#freegood_percent').css('color','red');
      }else{
        $('#freegood_percent').css('color','black');
      }
      $('#floatmenu').find('input[name=float_order_price]').val($origin_order_price);
      $('#floatmenu').find('input[name=float_freegood_percent]').val($freePercent);

      if( $weight_sum > 220 ){
        $('select[name=ship_method]').val('trk');
      }

      if($tgt.is('input[name="cnt[]"]')){
        $.fn.managePromotion($model,$countObj.val());
      }
      
      // trucking
    /*  
    }else{
      //alert('You can\'t assign free,damage,promotion under ZERO order !');
      //return false;
    }
    */
  }

});   // end of ready()