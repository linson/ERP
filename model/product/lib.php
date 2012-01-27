<?php
class ModelProductLib extends Model {
  
/***
  code tuning job
  - SP
  select p.model, pd.name
    from product p, product_description pd
   where p.product_id = pd.product_id
     and substr(p.model,1,2) = 'SP'
     and pd.name like '%Weave%';
+--------+-----------------------------------------------------+
| model  | name                                                |
+--------+-----------------------------------------------------+
| SP8627 | 30 Sec Weave Wonder Wrap Black (2 oz)               |
| SP8629 | 30 Sec Weave Wonder Wrap Black (8 oz)               |
| SP8623 | 30 Sec Weave Wonder Wrap Clear (2 oz)               |
| SP8625 | 30 Sec Weave Wonder Wrap Clear (8 oz)               |
| SP2619 | 30 Sec Lace Glue 1 Step Color Signal Remover (2 oz) |
| SP2618 | 30 Sec Lace Glue 1 Step Color Signal Remover (4 oz) |
| SP2579 | 30 Sec Lace Glue 1 Step Color Signal Remover (8 oz) |
+--------+-----------------------------------------------------+
select model from product where model in
(
select concat('3S',substr(p.model,3,4))
    from product p, product_description pd
   where p.product_id = pd.product_id
     and substr(p.model,1,2) = 'SP'
     and pd.name like '%30%'
);

update product set model = concat('3S',substr(model,3,4))
select model from product
 where model like '%8633';
 
select p.model, pd.name_for_sales
    from product p, product_description pd
   where p.product_id = pd.product_id
     and p.model like 'VN%';

***/

  // retrieve model,name for atc or else 
  public function getModelNamePerCat($cat = ''){
    $cond = ' where p.product_id = pd.product_id ';
    if($cat){
      $cond .= " and substr(p.model,1,2) = '$cat' ";
    }
    $sql = 'select p.model, pd.name_for_sales as name from product p, product_description pd ';
    $sql.= $cond;
    $sql.= ' order by p.model';
    //echo $sql . '<br/>';
    $query = $this->db->query($sql);
    return $query->rows;
  }
  
  // retrieve category - product map for atc batch
  // new product be exception. plz be careful of these manual stuff, , besso-201103 
  public function getCategoryMap(){
    $sql = "select p.model, pc.category_id from product p, product_to_category pc ";
    $sql.= " where p.product_id = pc.product_id and pc.category_id not in ";
    $sql.= " ( select category_id from category where parent_id = 0 and category_id != '38') order by pc.category_id,p.model";
    //echo $sql;
    $query = $this->db->query($sql);
    return $query->rows;
  }
  
  // model is on center of backend process
  public function getProduct($model) {
    $sql = "select distinct p.*, pd.name_for_sales as product_name from product p, product_description pd ";
    $sql.= " where p.product_id = pd.product_id and p.model = '" . $model . "'";
    $sql.= " order by pd.name_for_sales, p.model, p.pc";
		//$this->log->aPrint( $sql );
		$query = $this->db->query($sql);
		return $query->row;
	}

  public function getProducts($model,$txid){
    //$sql = "select product.*,sales.*,product_description.name_for_sales as product_name
    $sql = "select p.product_id, p.model, pd.name_for_sales as product_name,
                   p.ups_weight, p.ws_price, p.rt_price, s.order_quantity as cnt,
                   s.free, s.damage, s.total_price, s.weight_row,
                   p.quantity, p.image, p.pc, s.promotion,
                   IF(s.discount > 0 ,s.discount,p.dc) as dc1,
                   IF(s.discount2 > 0 ,s.discount2,p.dc2) as dc2,
                   s.backorder,s.backfree,s.backdamage,s.backpromotion,s.price1 as rate
              from product p
              left join sales s on
                   p.model = s.model 
                   and s.txid = '$txid'
              join product_description pd on
                   p.product_id = pd.product_id
                   and p.model = '$model'
             order by p.sort_order,p.model";
    //$this->log->aPrint( $sql ); exit;
		$query = $this->db->query($sql);
		return $query->row;
	}

  public function getProductOrdered($txid){
    //$sql = "select product.*,sales.*,product_description.name_for_sales as product_name
    

    if( isset($this->request->get['debug']) ){
      $product_name = 'pd.name as product_name,';
    }else{
      $product_name = 'pd.name_for_sales as product_name,';
    }

    //$product_name = 'pd.name_for_sales as product_name,';
    
    $sql = "select p.product_id, p.model,$product_name
                   p.ups_weight, p.ws_price, p.rt_price, s.order_quantity as cnt,
                   s.free, s.damage, s.total_price, s.weight_row,
                   p.quantity, p.image, p.pc,
                   s.discount as dc1,
                   s.discount2 as dc2,
                   s.backorder,s.backfree,s.backdamage,s.promotion,s.backpromotion
                   ,s.price1 as rate
              from product p
              join sales s on
                   p.model = s.model 
                   and s.txid = '$txid'
              join product_description pd on
                   p.product_id = pd.product_id
             order by p.sort_order,p.model";
    //$this->log->aPrint( $sql );
		$query = $this->db->query($sql);
    
    if( isset($this->request->get['debug']) ){
      $catalog = $this->config->getCatalogMobile();
    }else{
      $catalog = $this->config->getCatalog();
    }

    
    $aRtn = array();
    $aOrdered = $query->rows;
    //$this->log->aPrint( $catalog );
    foreach($catalog as $key => $aModel){
      foreach( $aOrdered as $ordered ){
        //$this->log->aPrint( $ordered );
        //$this->log->aPrint( $aModel );
        if(in_array($ordered['model'],$aModel)){
          $aRtn[$key][] = $ordered;
        }
      }
    }
    //$this->log->aPrint( $aRtn ); exit;
    //$this->log->aPrint( count($aRtn) );
		return $aRtn;
	}	
}
?>