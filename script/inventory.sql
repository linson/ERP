create table notice(
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  notice varchar(255),
  date datetime,
  uploader varchar(20)
)
;

select substr(txid,1,6) from transaction where
substr(txid,1,6) in (
      'CA9930',
      'FL9400',
      'GA4060',
      'GA7477',
      'IL0995',
      'IL9800',
      'PA4035',
      'PA5885',
      'PA7473',
      'TX1616',
      'TX2835',
      'TX3947',
      'TX4464',
      'TX6500'
);

NY9384 - UBP

select x.txid,
        x.order_price,x.cod,x.lift,
       (x.order_price - x.cod - x.lift) as tx_price,
       round( sum( (s.order_quantity * s.price1) * (100-s.discount) / 100 * (100-s.discount2) / 100 ) ,2) as sale_price
  from transaction x, sales s
 where x.txid = s.txid
   and x.txid in 
       (select txid from transaction  where substr(order_date,1,10) = '2012-01-20')
 group by x.txid;

select model,order_quantity,free,damage,price1,discount,discount2,
       ( order_quantity * price1 ) as price,
       round( (order_quantity * price1) * (100-discount) / 100 * (100-discount2) / 100 ,2) as dced
  from sales 
 where txid = 'IL3030-WH20120118-1';
 
select txid,
       sum( round( order_quantity * price1 * (100-discount) / 100 * (100-discount2) / 100 ,2) ) as price
  from sales 
 where txid = 'IL3030-WH20120118-1';

select txid,model,discount,discount2,
       round( (order_quantity * price1) * (100-discount) / 100 * (100-discount2) / 100 ,2) as price
  from sales 
 where txid = 'IL3030-WH20120118-1';

select order_price,cod,lift from transaction where txid = 'IL3030-WH20120118-1';


# 100 ??? 9.99 ? ?????
# select p.model,pd.name_for_sales,p.ups_weight from product p, product_description pd where p.product_id = pd.product_id and p.ups_weight = 9.99;

# insert product script
insert into product_description 
 set product_id       = 289,
     language_id      = 1,
     name             = 'Dsply 2oz72pc',
     meta_keywords    = 'Dsply 2oz72pc',
     meta_description = 'Dsply 2oz72pc',
     description      = 'Dsply 2oz72pc',
     name_for_sales   = 'Dsply 2oz72pc'
;

select p.product_id,p.model,pd.name_for_sales from product p, product_description pd where p.product_id = pd.product_id;


create table rep_stat(
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  month char(3),
  rep varchar(20),
  target int(11),
  done int(11),
  percent int(11),
  up_date varchar(20)
);

create table product_wt(
  c1 varchar(50),
  c2 decimal(14,2)
);

update product set ups_weight = ( select c2 from product_wt where c1 = substr(product.model,3,4));

select salesrep from storelocator where state in ('PA','DE','DC','VA','MD','WB');
update storelocator set salesrep = 'JU'
 where state in ('PA','DE','DC','VA','MD','WB');

select salesrep from storelocator where state in ('FL');
update storelocator set salesrep = 'YK' where state in ('FL');

drop table t1;
create table t1(
  id varchar(100),
  pkg_type varchar(100),
  name varchar(100),
  count varchar(100),
  thres varchar(100),
  unit varchar(100),
  date varchar(100),
  type_code varchar(100),
  price varchar(100),
  comp varchar(100),
  comment varchar(100)
);


create table package_product(
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  product_id 
);

create table package_history(
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  code int not null,
  price decimal(12,4) not null default 0,
  quantity int not null,
  up_date char(14),
  comment text,
  rep varchar(20) not null
);

drop table package;
CREATE TABLE `package` (
  `id` int(11) NOT NULL auto_increment,
  `code` varchar(20) default NULL,
  `brand` varchar(5) default NULL,
  `name` varchar(200) NOT NULL,
  `cat` varchar(100) NOT NULL,
  `price` decimal(12,4) NOT NULL default '0.0000',
  `quantity` int(11) NOT NULL,
  `thres` int(11) NOT NULL default '0',
  `warehouse` varchar(10) default NULL,
  `company` text,
  `description` text,
  `up_date` char(14) default NULL,
  `status` char(1) default NULL,
  `term` char(10) default NULL,
  `image` varchar(100) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1067 DEFAULT CHARSET=latin1; 

-- inventory trigger it to lessen the count
create table material_history(
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  mid int not null,
  code int not null,
  plus_count int,
  minus_count int,
  user varchar(30),
  update_date char(14)
)

// reserve_stock - important
// reserve_used

create table order_material (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  material_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY, // f-key with material::id
  order_quantity int not null default 0,
  price decimal(12,4),
  material_company varchar(100),
  shipping_cost decimal(12,4),
  other_cost decimal(12,4),
  description text,
  order_user int(11) not null,
  order_date date not null,
  approved_user int(11),
  approved_date date
);

create table material_company(
  id int not null auto_increment primary key,
  name varchar(200) not null,
  address varchar(200),
  country varchar(20),
  contact_user varchar(30),
  tel1 int(20),
  tel2 int(20),
  fax int(20),
  reg_date date
);

create table promotion(
  id int not null auto_increment primary key,
  start_date char(14),
  end_date char(14),
  price int,
  models varchar(100),
  update_date date,
  updator varchar(20)
);

truncate transaction; truncate sales; truncate ship; truncate pay;

select * from transaction;
select * from sales;select * from ship;select * from pay;

drop table sales;
create table sales (
  id int not null auto_increment primary key,
  txid char(20) not null,  -- f-key with transaction::transaction_id
  product_id int not null,  -- f-key with product::product_id
  model varchar(64) not null,
  order_quantity int not null default 0,
  price1 decimal(12,4),  
  price2 decimal(12,4),
  free int,
  damage int,
  discount  decimal(5,2),   -- discount rate
  total_price decimal(12,2),
  master_case_cnt int(3),   -- some Wholesale request it. low importance
  weight_row decimal(5,2),
  order_date char(14) not null
);

drop table transaction;
create table transaction (
  txid char(20) not null primary key, -- semantic : JH20110323-IL0004-01
  store_id int not null,  -- f-key with storelocatior::store_id
  description text,   -- any comment, update column
  order_user varchar(20) not null,
  approved_user int(11),
  approved_date date,  
  saled_ym char(6), -- mm yyyy
  new_store char(1),  -- flag for new store or not
  term int(2),  -- term for transaction, it's differ from history::term
  other_cost decimal(12,4), -- any additional/exceptional cost
  store_grade char(1),
  order_price decimal(12,2),    -- sum of each sales row for transaction
  payed_sum decimal(12,2),    -- sum of each sales row for transaction
  balance decimal(12,2),    -- sum of each sales row for transaction
  shipped_yn char(1), -- 1 true 0 false
  weight_sum decimal(12,2),
  order_date char(14) not null
);

drop table ship_method;
create table ship_method (
  id int not null primary key,
  name varchar(100) not null,
); 
drop table ship;
create table ship(
  id int not null auto_increment primary key,
  txid char(20) not null, -- f-key with transaction::id
  method varchar(20), -- f-key with shipping::id
  ship_date char(14), -- shipping date
  lift decimal(5,2), -- when we need lift facility cost
  cod decimal(5,2),  -- cashe on delivery
  ship_appointment char(10),  -- Y-m-d
  ship_comment varchar(200),  -- brief comment
  ship_user varchar(20) not null
);

drop table pay;
create table pay(
  id int not null auto_increment primary key,
  txid char(20) not null, -- f-key with transaction::id
  pay_method varchar(20),
  pay_date char(14),  -- till when will payed
  pay_num varchar(20),
  pay_user varchar(20) not null,
  pay_price decimal(12,2)
);

create table return_history(
  transaction_id int, -- f-key with transaction::id
  sales_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  why text,
  return_date date,
  sovlve_date date,
  return_price1 decimal(12,4)  
);

create table store_history(
  accountno varchar(7) not null,
  salesrep  varchar(5) not null,
  assign_date char(10) not null,
  description text
);

drop table events;
CREATE TABLE events (
	id INTEGER PRIMARY KEY AUTO_INCREMENT,
	title TEXT,
	slug TEXT,
	time INTEGER
);
INSERT INTO events (title,slug,time) VALUES ('Soccer Game','soccer-game',1250256000);
INSERT INTO events (title,slug,time) VALUES ('Basketball Game','basketball-game',1250361000);
INSERT INTO events (title,slug,time) VALUES ('Hockey Game','hockey-game',1250367840);
INSERT INTO events (title,slug,time) VALUES ('Lacrosse Game','lacrosse-game',1250438700);
INSERT INTO events (title,slug,time) VALUES ('Ping Pong Game','ping-pong-game',1250463600);

#################################################################
# Update Price
#################################################################

mysql> update product set ws_price = 60.20, rt_price = 25.52 where substr(model,3,4) in ('2001');
Query OK, 31 rows affected (0.01 sec)
Rows matched: 31  Changed: 31  Warnings: 0

mysql> update product set ws_price = 60.20, rt_price = 75.26 where substr(model,3,4) in ('2001');
Query OK, 31 rows affected (0.00 sec)
Rows matched: 31  Changed: 31  Warnings: 0

mysql> update product set ws_price = 36.53, rt_price = 45.66 where substr(model,3,4) in ('2002');
Query OK, 21 rows affected (0.00 sec)
Rows matched: 21  Changed: 21  Warnings: 0

mysql> update product set ws_price = 70.26, rt_price = 87.82 where substr(model,3,4) in ('2004');
Query OK, 20 rows affected (0.00 sec)
Rows matched: 20  Changed: 20  Warnings: 0

mysql> update product set ws_price = 33.73, rt_price = 42.16 where substr(model,3,4) in ('2101');
Query OK, 16 rows affected (0.00 sec)
Rows matched: 16  Changed: 16  Warnings: 0

mysql> update product set ws_price = 44.93, rt_price = 56.16 where substr(model,3,4) in ('2416');
Query OK, 1 row affected (0.01 sec)
Rows matched: 1  Changed: 1  Warnings: 0

mysql> update product set ws_price = 27.87, rt_price = 34.84 where substr(model,3,4) in ('2415');
Query OK, 1 row affected (0.00 sec)
Rows matched: 1  Changed: 1  Warnings: 0

mysql> update product set ws_price = 24.60, rt_price = 30.74 where substr(model,3,4) in ('2409');
Query OK, 1 row affected (0.01 sec)
Rows matched: 1  Changed: 1  Warnings: 0

mysql> update product set ws_price = 72.61, rt_price = 90.77 where substr(model,3,4) in ('2404');
Query OK, 1 row affected (0.01 sec)
Rows matched: 1  Changed: 1  Warnings: 0

mysql> update product set ws_price = 19.05, rt_price = 23.82 where substr(model,3,4) in ('2405');
Query OK, 0 rows affected (0.00 sec)
Rows matched: 0  Changed: 0  Warnings: 0

mysql> update product set ws_price = 31.11, rt_price = 38.89 where substr(model,3,4) in ('2408');
Query OK, 1 row affected (0.00 sec)
Rows matched: 1  Changed: 1  Warnings: 0

mysql> update product set ws_price = 95.30, rt_price = 119.13 where substr(model,3,4) in ('2421');
Query OK, 1 row affected (0.01 sec)
Rows matched: 1  Changed: 1  Warnings: 0

mysql> update product set ws_price = 7.27, rt_price = 9.09 where substr(model,3,4) in ('0801','0802','0803','0804','0805','0806','0807','0808','0809','0810','0811','0812','0813','0814','0815','0816','0817','0818','0819','0820','0821','0822','0823','0824');
Query OK, 24 rows affected (0.00 sec)
Rows matched: 24  Changed: 24  Warnings: 0

mysql> update product set ws_price = 174.48, rt_price = 218.10 where substr(model,3,4) in ('0825');                                                                                       Query OK, 1 row affected (0.00 sec)
Rows matched: 1  Changed: 1  Warnings: 0