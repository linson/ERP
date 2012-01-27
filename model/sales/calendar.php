<?php
class ModelSalesCalendar extends Model {
  public function getEvents($start,$end){
    $sql = "select * , substr(time,7,2) as day from events where time BETWEEN $start AND $end ORDER BY time ASC";
    //echo $sql;
		$query = $this->db->query($sql);
		$aRtn = array();
		$i = 0;

		foreach($query->rows as $row){
  		if($i == 0) $tmpD = $row['day'];
		  $aRtn[$row['day']][$i] = $row;
 		  $i++;
		}
		//$this->log->aPrint( $aRtn );
    return $aRtn;
	}

	public function updateEvent($data){
    /***
    $sql = "select count(*) from events where id = $id";
    $query = $this->db->query($sql);
		if($query->row > 1){
		***/
		//$this->log->aPrint( $data );

		isset($data['id']) ? $id = $data['id'] : $id = '';
		isset($data['start']) ? $start = $data['start'] : $start = '';
		isset($data['end']) ? $end = $data['end'] : $end = '';
		$title = htmlentities($data['title'],ENT_QUOTES);
		$slug = htmlentities($data['slug'],ENT_QUOTES);
		$time = $data['time'];

		# managing period
		$aPeriod = array();
		if($start != ''){
		  if($end == '') $end = $start;
      $start = date('Ymd',strtotime(date("Y-m-d", strtotime($start))));
      $end = date('Ymd',strtotime(date("Y-m-d", strtotime($end))));
      if($end > $start){
        for($i=$start; $i<=$end; $i=date('Ymd',strtotime(date("Ymd", strtotime($i)) . "+1 day")) ){
          $aPeriod[] = $i . '00';
        }
		  }
		}

		if($id != ''){
		  $sql = "update events set title = '$title', slug = '$slug', time = $time where id = $id";
      $query = $this->db->query($sql);
		}else{
      if(count($aPeriod) > 1){
        foreach($aPeriod as $date){
          $sql = "insert into events (title,slug,time) values('$title','$slug',$date)";
          $query = $this->db->query($sql);
        }
      }else{
        $sql = "insert into events (title,slug,time) values('$title','$slug',$time)";
        $query = $this->db->query($sql);
      }
    }
    //echo $sql;
  }

	public function deleteEvent($data){
		//$this->log->aPrint( $data );
		isset($data['id']) ? $id = $data['id'] : $id = '';
		if($id != ''){
		  $sql = "delete from events where id = $id";
      $query = $this->db->query($sql);
		}
  }

}
?>