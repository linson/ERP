<?php echo $header; ?>
<div class="box">
  <div class="left"></div>
  <div class="right"></div>
  <div class="heading">
    <h1 style="background-image: url('view/image/report.png');">CSV Generator</h1>
    <div class="buttons" style="padding-right:80px">
      <a class="button excel"><span>generate CSV</span></a>
    </div>
  </div>
  <?php
  $today = date("Ymd"); 
  $tomonth = date("Ym");
  ?>
  <div class="content">
    <textarea id='sql' style='width:800px;height:200px;'></textarea>
    <style>
    h3 { padding-top: 5px; }
    li { list-style : none; }
    </style>

    <h3> Product </h3>
    <ul>
      <li>
        <input type=button style="width:800px;height:30px;text-align:left;padding-left:20px;"
        value="Get product base"
        sql="select p.model, p.sku, pd.name_for_sales, p.quantity, p.ws_price, p.rt_price
          from product p, product_description pd
         where p.product_id = pd.product_id
        " 
        />
      </li>

      <?php
      $sql = "select p.model as model,ph.diff,substr(ph.up_date,1,8), ph.code
  from product p,product_description pd, package_history ph, package pk
  where substr(ph.up_date,1,6) = '$tomonth' 
    and ph.code = pk.code
    and pk.cat in ('BOX')
    and ph.final = pd.product_id
    and pd.product_id = p.product_id
    and ph.final is not null 
  order by ph.up_date";
      ?>
      <li>
        <input type=button style="width:800px;height:30px;text-align:left;padding-left:20px;"
        value="Get this month produced"
        sql="<?php echo $sql; ?>"
        />
      </li>

      <?php
      $sql = "select p.model as model,ph.diff,substr(ph.up_date,1,8), ph.code
  from product p,product_description pd, package_history ph, package pk
  where substr(ph.up_date,1,6) = '$today' 
    and ph.code = pk.code
    and pk.cat in ('BOX')
    and ph.final = pd.product_id
    and pd.product_id = p.product_id
    and ph.final is not null 
  order by ph.up_date";
      ?>
      <li>
        <input type=button style="width:800px;height:30px;text-align:left;padding-left:20px;"
        value="Get today produced"
        sql="<?php echo $sql; ?>"
        />
      </li>

    </ul>

    <h3> Sales </h3>
    <ul>
      <li>
        <input type=button style="width:800px;height:30px;text-align:left;padding-left:20px;"
        value="Today Total Order"
        sql="SELECT *  FROM transaction WHERE shipped_yn = 'Y' and order_date = substr(now(),1,10)" 
        />
      </li>
      <li>
        <input type=button style="width:800px;height:30px;text-align:left;padding-left:20px;"
        value="Yesterday Total Order"
        sql="SELECT * FROM transaction WHERE shipped_yn = 'Y' and order_date = adddate(substr(now(),1,10),-1)" 
        />
      </li>
      <!--li>
        <input type=button style="width:800px;height:30px;text-align:left;padding-left:20px;"
        value="This month Total Order"
        sql="SELECT * FROM transaction WHERE shipped_yn = 'Y' and substr(order_date,6,2) = substr(now(),6,2)" 
        />
      </li>
      <li>
        <input type=button style="width:800px;height:30px;text-align:left;padding-left:20px;"
        value="Last month Total Order"
        sql="SELECT * FROM transaction WHERE shipped_yn = 'Y' and substr(order_date,6,2) = substr(adddate(now(),-30),6,2)" 
        />
      </li-->
      <li>
        <input type=button style="width:800px;height:30px;text-align:left;padding-left:20px;"
        value="3 months Total Order"
        sql="SELECT * FROM transaction WHERE shipped_yn = 'Y' and substr(order_date,6,2) > substr(adddate(now(),-90),6,2)" 
        />
      </li>

    <h3> Package </h3>
    <ul>
      <li>
        <input type=button style="width:800px;height:30px;text-align:left;padding-left:20px;"
        value="Get package base"
        sql="select * from package" 
        />
      </li>
      <li>
        <input type=button style="width:800px;height:30px;text-align:left;padding-left:20px;"
        value="Get product package mapping base"
        sql="select p.model,p.sku,pd.name_for_sales,package.code,package.name 
  from product p, product_package pp, product_description = pd, package
 where p.product_id = pp.pid
   and p.product_id = pd.product_id
   and package.code = pp.pkg
 order by p.model" 
        />
      </li>
    <h3> Account </h3>
    <ul>
      <li>
        <input type=button style="width:800px;height:30px;text-align:left;padding-left:20px;"
        value="Get Account base"
        sql="select * from storelocator" 
        />
      </li>
    </ul>
  </div>
</div>
<script type="text/javascript"><!--
$(document).ready(function(){
  $('input').bind('click',function(e){
    $tgt = $(e.target);
    $sql = $tgt.attr('sql');
    $('textarea')[0].value = $sql;
  });
  
  $('.excel').bind('click',function(e){
    //$sql = $('textarea').html().trim();
    var ta = $('textarea');
    $sql = $('textarea')[0].value;
    //alert($sql);
    $url = '<?php echo $lnk_export; ?>' + '&sql=' + $sql;
    //alert($url);
    location.href = $url;
  });
});
//--></script>
<?php echo $footer; ?>