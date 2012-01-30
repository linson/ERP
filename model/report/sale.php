<?php
class ModelReportSale extends Model {
  public function stat($request){
    // todo. GA4060 removed by JP
    // toto. TX1616,TX2835,TX3947,TX6500 removed by AK
    $exclude = " and substr(x.txid,1,6) not in ('CA9930','FL9400','GA7477','IL0995','IL9800','PA4035',
                 'PA5885','PA7473','TX4464')";
    // today
    if(!is_null($request['filter_from']) && !is_null($request['filter_to'])){
      $thismonth = mktime(0, 0, 0, date(substr($request['filter_from'],5,2)), date(substr($request['filter_from'],8,2)), date(substr($request['filter_from'],0,4)));
      $from = date("Y-m-01",$thismonth);
      $to   = date("Y-m-t",$thismonth);
      $month = date("Ym",$thismonth);
		}
    $working = $this->util->getWorkingDays($from,$to);
    //$this->log->aPrint( $working );
    $sql = "
        select x.order_user,substr(x.order_date,1,7) as order_date,
               rs.target,
               round( rs.target / $working ) as day_target,
               sum(x.order_price) as order_price,
               round( (sum(x.order_price) / rs.target * 100 ) , 2 ) as percent,
               round( (sum(x.order_price) / ( rs.target / $working ) * 100 ) , 2 ) as day_percent,
               count(x.txid) as cnt,
               sum(IF(st.storetype = 'R',1,0)) as rcnt,
               sum(IF(st.storetype = 'W',1,0)) as wcnt,
               substr(x.order_date,1,10) as today
          from transaction x, rep_stat rs, storelocator st
         where rs.month = '$month'
           and x.order_user = rs.rep and x.store_id = st.id
           and x.status in ('1','2','3')
           and x.approve_status = 'approve'";
    if(!is_null($request['filter_from']) && !is_null($request['filter_to'])){
      if( $request['filter_from'] == $request['filter_to'] ){
        $from = $to = $request['filter_from'];
      }else{
        $from = $to = date("Y-m-d");
      }
		}
    $sql .= " AND substr(x.order_date,1,10) between '" . $from . "' and '" . $to . "'";    
    // exclude
    if( $request['hidden'] == false ){      $sql .= $exclude;    }
    $sql .= " group by x.order_user,substr(x.order_date,1,7)";

    if( $request['sort'] == '' ){
      $sql.= " order by (sum(x.order_price) / rs.target )";
    }else{
      $sql.= " order by " . $request['sort'];
    }

    $sql.= " " . $request['order'];

    //$this->log->aPrint( $sql );
    $query = $this->db->query($sql);
    $aToday = $query->rows;

    // outer join fail shit
    $aSales = array();
    foreach($query->rows as $row){ array_push($aSales,$row['order_user']); }

    $i = count($aToday);
    if($i>0){
      foreach($this->user->getSales() as $sales){
        if( !in_array($sales,$aSales) ){
          $aToday[$i] = $aToday[$i-1];
          $aToday[$i]['order_user'] = $sales;
          
          $sql = "select target from rep_stat where month = '$month' and rep = '$sales'";
          //$this->log->aPrint( $sql );
          $query = $this->db->query($sql);
          $target = $query->row['target'];
          //$this->log->aPrint( $target );
          $aToday[$i]['target'] = $target;
          $aToday[$i]['day_target'] = round($target/$working);
          $aToday[$i]['order_price'] = 0;
          $aToday[$i]['percent'] = 0;
          $aToday[$i]['day_percent'] = 0;
          $aToday[$i]['cnt'] = 0;
          $aToday[$i]['rcnt'] = 0;
          $aToday[$i]['wcnt'] = 0;
          $i++;
        }
      }
    }
    $rtn['today'] = $aToday;

    /////////////// this month ////////////////////////
    $sql = "
        select x.order_user,substr(x.order_date,1,7) as order_date,rs.target,
               sum(x.order_price) as order_price,
               round( (sum(x.order_price) / rs.target * 100 ) , 2 ) as percent,
               count(x.txid) as cnt,
               sum(IF(st.storetype = 'R',1,0)) as rcnt,
               sum(IF(st.storetype = 'W',1,0)) as wcnt
          from transaction x, rep_stat rs, storelocator st
         where concat(substr(x.order_date,1,4),substr(x.order_date,6,2)) = rs.month
           and x.order_user = rs.rep and x.store_id = st.id
           and x.status in ('1','2','3')
           and x.approve_status = 'approve'";
    if(!is_null($request['filter_from']) && !is_null($request['filter_to'])){
      $thismonth = mktime(0, 0, 0, date(substr($request['filter_from'],5,2)), date(substr($request['filter_from'],8,2)), date(substr($request['filter_from'],0,4)));
      $from = date("Y-m-01",$thismonth);
      $to   = date("Y-m-t",$thismonth);
		}
 		$sql .= " AND substr(x.order_date,1,10) between '" . $from . "' and '" . $to . "'";    
    if( $request['hidden'] == false ){      $sql .= $exclude;    }
    $sql .= " group by x.order_user,substr(x.order_date,1,7)";
    
    if( $request['sort'] == '' ){
      $sql.= "order by (sum(x.order_price) / rs.target )";
    }else{
      $sql.= "order by " . $request['sort'];
    }

    $sql.= " " . $request['order'];

//    $this->log->aPrint( $sql );
    $query = $this->db->query($sql);
    $rtn['this_month'] = $query->rows;

    /////////////// past month ////////////////////////
    $sql = "
        select x.order_user,substr(x.order_date,1,7) as order_date,rs.target,
               sum(x.order_price) as order_price,
               round( (sum(x.order_price) / rs.target * 100 ) , 2 ) as percent,
               count(x.txid) as cnt,
               sum(IF(st.storetype = 'R',1,0)) as rcnt,
               sum(IF(st.storetype = 'W',1,0)) as wcnt
          from transaction x, rep_stat rs, storelocator st
         where concat(substr(x.order_date,1,4),substr(x.order_date,6,2)) = rs.month
           and x.order_user = rs.rep and x.store_id = st.id
           and x.status in ('1','2','3')
           and x.approve_status = 'approve'";

    if(!is_null($request['filter_from']) && !is_null($request['filter_to'])){
      $lastmonth = mktime(0, 0, 0, date(substr($request['filter_from'],5,2))-1, date(substr($request['filter_from'],8,2)), date(substr($request['filter_from'],0,4)));
      $from = date("Y-m-d",$lastmonth);
      $to   = date("Y-m-t",$lastmonth);
		}
 		$sql .= " AND substr(x.order_date,1,10) between '" . $from . "' and '" . $to . "'";    
    if( $request['hidden'] == false ){      $sql .= $exclude;    }
    $sql .= " group by x.order_user,substr(x.order_date,1,7)";

    if( $request['sort'] == '' ){
      $sql.= "order by (sum(x.order_price) / rs.target )";
    }else{
      $sql.= "order by " . $request['sort'];
    }

    $sql.= " " . $request['order'];
    //$this->log->aPrint( $sql );
    $query = $this->db->query($sql);
    $rtn['last_month'] = $query->rows;
    return $rtn;
  }



  ##############################################################################
  ###### Product
  ##############################################################################
  public function stat_product($request){
    // today
    if(!is_null($request['filter_from']) && !is_null($request['filter_to'])){
      $thismonth = mktime(0, 0, 0, date(substr($request['filter_from'],5,2)), date(substr($request['filter_from'],8,2)), date(substr($request['filter_from'],0,4)));
      $from = date("Y-m-01",$thismonth);
      $to   = date("Y-m-t",$thismonth);
      $month = date("Ym",$thismonth);
		}
    $working = $this->util->getWorkingDays($from,$to);
    //$this->log->aPrint( $working );
    $group = $rep = '';
    if($group == 'rep') $rep = "substr(substring_index(s.txid,'-',-2),1,2),";
    $sql = "
        select $rep s.model as model, pd.name, sum(s.order_quantity) as qty, sum(s.order_quantity * s.price1 ) as total
          from sales as s
          join ( product as p , product_description as pd ) on s.model = p.model and p.product_id = pd.product_id
         where s.order_quantity > 0
        ";
    if(!is_null($request['filter_from']) && !is_null($request['filter_to'])){
      if( $request['filter_from'] == $request['filter_to'] ){
        $from = $to = $request['filter_from'];
      }else{
        $from = $to = date("Y-m-d");
      }
		}
    $sql .= " AND substr(s.order_date,1,10) between '" . $from . "' and '" . $to . "'";    
    $sql .= " group by $rep s.model order by $rep substr(s.model,1,2),sum(s.order_quantity * s.price1 ) desc";

    //$this->log->aPrint( $sql );
    $query = $this->db->query($sql);
    $aProduct = array();
    foreach($query->rows as $row){
      $aProduct[ $row['model'] ] = array($row['name'],$row['qty'],$row['total']);
    }
    //$this->log->aPrint( $aProduct);

    $aCat = $this->config->getCatalog();
    //$this->log->aPrint( $aCat );
    // sort later
    $aCatSum = array();
    foreach($aCat as $k => $group){
      foreach($group as $m){
        if( $m != '' ){
          if( isset($aProduct[$m]) && is_array($aProduct[$m]) ){
            $aCatSum[$k][$m] = $aProduct[$m]; 
          }
        }
      }
    }
    $rtn['today'] = $aCatSum;

    // this month
    if(!is_null($request['filter_from']) && !is_null($request['filter_to'])){
      $thismonth = mktime(0, 0, 0, date(substr($request['filter_from'],5,2)), date(substr($request['filter_from'],8,2)), date(substr($request['filter_from'],0,4)));
      $from = date("Y-m-01",$thismonth);
      $to   = date("Y-m-t",$thismonth);
      $month = date("Ym",$thismonth);
		}
    //$this->log->aPrint( $working );
    $group = $rep = '';
    if($group == 'rep') $rep = "substr(substring_index(txid,'-',-2),1,2),";
    $sql = "
        select $rep s.model as model, pd.name, sum(s.order_quantity) as qty, sum(s.order_quantity * s.price1 ) as total
          from sales as s
          join ( product as p , product_description as pd ) on s.model = p.model and p.product_id = pd.product_id
         where s.order_quantity > 0
        ";
    $sql .= " AND substr(s.order_date,1,10) between '" . $from . "' and '" . $to . "'";    
    $sql .= " group by $rep s.model order by $rep substr(s.model,1,2),sum(s.order_quantity * s.price1 ) desc";

    //$this->log->aPrint( $sql );
    $query = $this->db->query($sql);
    $aProduct = array();
    foreach($query->rows as $row){
      $aProduct[ $row['model'] ] = array($row['name'],$row['qty'],$row['total']);
    }
    //$this->log->aPrint( $aProduct);

    $aCat = $this->config->getCatalog();
    //$this->log->aPrint( $aCat );
    $aCatSum = array();
    foreach($aCat as $k => $group){
      foreach($group as $m){
        if( $m != '' ){
          if( isset($aProduct[$m]) && is_array($aProduct[$m]) ){
            $aCatSum[$k][$m] = $aProduct[$m]; 
          }
        }
      }
    }
    //exit;
    //$this->log->aPrint( $aCatSum ); exit;
    $rtn['this_month'] = $aCatSum;
    return $rtn;
  }

  ##############################################################################
  ###### account
  ##############################################################################
  public function stat_account($request){
    // today
    if(!is_null($request['filter_from']) && !is_null($request['filter_to'])){
      $thismonth = mktime(0, 0, 0, date(substr($request['filter_from'],5,2)), date(substr($request['filter_from'],8,2)), date(substr($request['filter_from'],0,4)));
      $from = date("Y-m-01",strtotime("-1 years"));
      $to   = date("Y-m-t",$thismonth);
      $month = date("Ym",$thismonth);
		}
    $working = $this->util->getWorkingDays($from,$to);
    //$this->log->aPrint( $working );
    $group = $rep = '';
    if($group == 'rep') $rep = "substr(substring_index(s.txid,'-',-2),1,2),";
    $accountno = $request['accountno'];
    $sql = "
        select x.txid,x.order_price,
               s.model,
               pd.name,
               x.order_date,
               sum(s.order_quantity*s.price1) as sum,
               s.order_quantity
          from transaction x, storelocator sl, sales s, product_description pd, product p
         where x.store_id = sl.id
           and p.product_id = pd.product_id
           and s.product_id = pd.product_id
           and s.txid = x.txid
           and lower(sl.accountno) = '$accountno'
           and s.order_quantity > 0
        ";
    /*
    if(!is_null($request['filter_from']) && !is_null($request['filter_to'])){
      if( $request['filter_from'] == $request['filter_to'] ){
        $from = $to = $request['filter_from'];
      }else{
        $from = $to = date("Y-m-d");
      }
		}
		*/
    $sql .= " AND substr(s.order_date,1,10) between '" . $from . "' and '" . $to . "'";    
    $sql .= " group by x.txid,s.model order by x.order_date, p.model desc";

    //$this->log->aPrint( $sql );
    $query = $this->db->query($sql);
    //$this->log->aPrint( $query->rows );
    $aAcctno = array();
    $i = 0;
    $tmpTxid = $txid = '';
    foreach( $query->rows as $row){
      $txid = $row['txid'];
      if( !$txid )  $tmpTxid = $txid;
      if( $txid != $tmpTxid ){
        $tmpTxid = '';
      }
      $aAcctno[$txid][$i] = $row;
      $i++;
    }
    //$this->log->aPrint( $aAcctno ); exit;
    return $aAcctno;
  }



  ##############################################################################
  ###### validate
  ##############################################################################
  public function validate($request){
    $from = $request['filter_from'];
    $to = $request['filter_to'];
    $sql = "
            select x.txid,
                   (x.order_price - x.cod - x.lift) as tx_price,
                   sum( round( s.order_quantity * s.price1 * (100-s.discount) / 100 * (100-s.discount2) / 100 , 2 ) ) as sale_price,
                   x.discount as store_discount
              from transaction x, sales s
             where x.txid = s.txid
               and x.txid in 
                   (select txid from transaction  where substr(order_date,1,10) between '$from' and '$to' )
             group by x.txid;
        ";
    //$this->log->aPrint( $sql ); exit;
    $query = $this->db->query($sql);
    $aResponse = $aDC = array();
    foreach($query->rows as $row){
      if( $row['tx_price'] != $row['sale_price'] ){
        //$this->log->aPrint( $row );
        //$this->log->aPrint( '------' );
        $dc = $row['store_discount'];
        $sale_price = $row['sale_price'];
        if($dc){
          $aDC = json_decode($dc);
          foreach($aDC as $d){
            $aT1 = explode('|',$d);
            //$this->log->aPrint( $aT1 );
            if( $aT1[0] > 0 ){
              $sale_price = round( $sale_price * (100 - $aT1[0]) / 100 ,2);
            }
          }
        }
        /*
        $this->log->aPrint( $sale_price );
        $this->log->aPrint( $row['tx_price'] );
        $this->log->aPrint( substr($sale_price,0,-2) );
        */
        if( substr($sale_price,0,-2) != substr($row['tx_price'],0,-2) ){
          $aResponse[] = $row;
        }
      }
    }
    //$this->log->aPrint( '-------------------' );
    //$this->log->aPrint( $aResponse ); 
    //$this->log->aPrint( '-------------------' );
    //exit;
    return $aResponse;
  }

	public function ordersales($request){
    $from  = $request['filter_from'];
    $to    = $request['filter_to'];
    $group = html_entity_decode($request['group']);
    $aCat = $this->config->getCatalog();
    $comma = implode("','",$aCat[$group]);
//    $this->log->aPrint( $comma );
    $comma = "'" . $comma . "'";

    $sql = "
      select x.order_user as rep, sum( s.order_quantity ) as qty
        from transaction x, sales s
       where x.txid = s.txid
         and substr(s.order_date,1,10) between '$from' and '$to'
         and s.model in ( $comma )
       group by x.order_user
       order by sum( s.order_quantity ) desc
    ";
    $query = $this->db->query($sql);
    return $query->rows;
	}

}
?>
