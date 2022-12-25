# DELETE Existing Tables

SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS MM_A11_G3_boatClass;
DROP TABLE IF EXISTS MM_A11_G3_manufacturers;
DROP TABLE IF EXISTS MM_A11_G3_boats;
DROP TABLE IF EXISTS MM_A11_G3_dealers;
DROP TABLE IF EXISTS MM_A11_G3_disposal_history;
DROP TABLE IF EXISTS MM_A11_G3_customer;
DROP TABLE IF EXISTS MM_A11_G3_reservation_rentals;
DROP TABLE IF EXISTS MM_A11_G3_sparepart_in_stock;
DROP TABLE IF EXISTS MM_A11_G3_ordered_part;
DROP TABLE IF EXISTS MM_A11_G3_repair_service;
DROP TABLE IF EXISTS MM_A11_G3_maintenance_history;
DROP TABLE IF EXISTS MM_A11_G3_delivered;


SET FOREIGN_KEY_CHECKS = 1;

# CREATE the BOAT CLASS TABLE TO hold boatClass information FOR boats
    
    CREATE TABLE MM_A11_G3_boatClass (
	boatClass_id VARCHAR(25) NOT NULL
	,boat_size VARCHAR(25)
    ,boat_type VARCHAR(25)
    ,halfday_price DECIMAL(5, 2)
    ,fullday_price DECIMAL(5, 2) 
	,CONSTRAINT PRIMARY KEY (boatClass_id)
	);
    
    # CREATE the MANUFACTURERS TABLE TO hold manufacturer information FOR boats

CREATE TABLE MM_A11_G3_manufacturers (
	manufacturer_id INT(3) AUTO_INCREMENT
	,manufacturer_name VARCHAR(40)
	,phone_number VARCHAR(20)
	,address VARCHAR(70)
  	,email VARCHAR(30)UNIQUE
	,CONSTRAINT PRIMARY KEY (manufacturer_id)
	);
    
        # CREATE the BOAT TABLE TO hold FOR boats
    
    CREATE TABLE MM_A11_G3_boats (
	boat_id INT (4) AUTO_INCREMENT
	,boatClass_id VARCHAR(25)
	,boatModel VARCHAR(30)
	,manufacturer_id INT(3)
	,purchase_Date DATE NOT NULL
	,boatPrice DECIMAL(9, 2)
    ,lastService_date DATE NOT NULL
	,CONSTRAINT PRIMARY KEY (boat_id)
	);
    
    ALTER TABLE MM_A11_G3_boats 
    ADD CONSTRAINT boat_class_fk FOREIGN KEY (boatClass_id) REFERENCES MM_A11_G3_boatClass (boatClass_id)
	,ADD CONSTRAINT boat_man_fk FOREIGN KEY (manufacturer_id) REFERENCES MM_A11_G3_manufacturers (manufacturer_id);
    
    # CREATE the DEALER TABLE TO hold dealer information FOR dealers

CREATE TABLE MM_A11_G3_dealers (
	dealer_id INT(3) AUTO_INCREMENT
	,dealer_name VARCHAR(40)
	,mobile_number VARCHAR(20)
	,address VARCHAR(70)
  	,email VARCHAR(30)UNIQUE
	,CONSTRAINT PRIMARY KEY (dealer_id)
	);
    
        # CREATE the DISPOSAL_HISTORY TABLE TO hold historys infromation OF disposal 

CREATE TABLE MM_A11_G3_disposal_history (
	boat_id INT (4) NOT NULL
	,sell_price DECIMAL(9, 2) 
	,sell_date DATE NOT NULL
	,dealer_id INT (4) 
	);

ALTER TABLE MM_A11_G3_disposal_history ADD CONSTRAINT PRIMARY KEY (
	dealer_id
	,sell_date
	)
	,ADD CONSTRAINT dihis_dea_fk FOREIGN KEY (dealer_id) REFERENCES MM_A11_G3_dealers (dealer_id)
	,ADD CONSTRAINT dihis_bot_fk FOREIGN KEY (boat_id) REFERENCES MM_A11_G3_boats (boat_id);
    
		# CREATE the CUSTOMER TABLE TO hold the customer information OF customers
    
CREATE TABLE MM_A11_G3_customer (
	customer_id INT (4) AUTO_INCREMENT
    ,first_name VARCHAR(25)
    ,last_name VARCHAR (25)
    ,mobile_number VARCHAR(20)
    ,address VARCHAR(70)
    ,email VARCHAR(25) UNIQUE
    ,CONSTRAINT PRIMARY KEY (customer_id)
    );
    
    	# CREATE the RESERVATION_RENTAL TABLE TO hold infromation FOR reservation and rentals 
        
CREATE TABLE MM_A11_G3_reservation_rentals (
	reservation_no INT (4) NOT NULL
    ,boatClass_id VARCHAR (25) 
    ,reservation_date DATE NOT NULL
    ,customer_id INT(4)
    ,hire_date DATE
    ,hire_period VARCHAR(25)
    ,boat_id INT (4) 
    ,hire_price DECIMAL (6, 2)
    ,hire_dueDate DATE 
    ,payment_status VARCHAR (10)
    ,CONSTRAINT jhist_date_interval CHECK (hire_date != 0)
    );
    
    ALTER TABLE MM_A11_G3_reservation_rentals ADD CONSTRAINT PRIMARY KEY (
	reservation_no
    ,customer_id
    ,boatClass_id
	)
	,ADD CONSTRAINT reserent_cust_fk FOREIGN KEY (customer_id) REFERENCES MM_A11_G3_customer (customer_id)
	,ADD CONSTRAINT reserent_boatclass_fk FOREIGN KEY (boatClass_id) REFERENCES MM_A11_G3_boatClass (boatClass_id)
	,ADD CONSTRAINT reserent_boat_fk FOREIGN KEY (boat_id) REFERENCES MM_A11_G3_boats (boat_id);
    
    # CREATE the SPAREPART_IN_STOCK TABLE TO hold information OF parts that are available in stock
        
CREATE TABLE MM_A11_G3_sparepart_in_stock (
sparepart_id INT (4) NOT NULL
,sparepart_name VARCHAR (40)
,manufacturer_id INT (4)
,quantity INT (5) NOT NULL
,CONSTRAINT PRIMARY KEY (sparepart_id)
);

ALTER TABLE MM_A11_G3_sparepart_in_stock ADD CONSTRAINT spar_man_fk FOREIGN KEY (manufacturer_id) REFERENCES MM_A11_G3_manufacturers (manufacturer_id);

# CREATE the ORDERED_PART TABLE TO hold information OF parts that are ordered parts

CREATE TABLE MM_A11_G3_ordered_part (
order_no VARCHAR (25) NOT NULL
,sparepart_id INT (4) 
,quantity INT (5) NOT NULL
,CONSTRAINT PRIMARY KEY (order_no)
);

ALTER TABLE MM_A11_G3_ordered_part ADD CONSTRAINT ord_spar_fk FOREIGN KEY (sparepart_id) REFERENCES MM_A11_G3_sparepart_in_stock (sparepart_id);

	# CREATE the REPAIR_SERVICE TABLE TO hold  repairs and services information OF repair_service
    
CREATE TABLE MM_A11_G3_repair_service (
ref_no INT (4) NOT NULL
,fault_details VARCHAR (40)
,fault_date DATE
,solution_details VARCHAR (40)
,solution_date DATE 
,order_no  VARCHAR (25) 
,CONSTRAINT PRIMARY KEY (ref_no)
);

ALTER TABLE MM_A11_G3_repair_service ADD CONSTRAINT repser_ord_fk FOREIGN KEY (order_no) REFERENCES MM_A11_G3_ordered_part (order_no);

# CREATE the MAINTAINENANCE_HISTORY TABLE TO hold  history information OF maintainance_history

CREATE TABLE MM_A11_G3_maintenance_history (
boat_id INT (4) 
,ref_no INT (4) 
);

ALTER TABLE MM_A11_G3_maintenance_history ADD CONSTRAINT PRIMARY KEY (
	boat_id
	,ref_no
	)
	,ADD CONSTRAINT manhist_boat_fk FOREIGN KEY (boat_id) REFERENCES MM_A11_G3_boats (boat_id)
	,ADD CONSTRAINT manhist_ref_fk FOREIGN KEY (ref_no) REFERENCES MM_A11_G3_repair_service (ref_no);
    
    # CREATE the DELIVERED TABLE TO hold  delivery information OF delivered
    
CREATE TABLE MM_A11_G3_delivered (
delivery_no INT (4) NOT NULL
,order_no  VARCHAR (15) NOT NULL
,delivery_address VARCHAR (50) NOT NULL
,CONSTRAINT PRIMARY KEY (delivery_no)
);

ALTER TABLE MM_A11_G3_delivered ADD CONSTRAINT del_ord_fk FOREIGN KEY (order_no) REFERENCES MM_A11_G3_ordered_part (order_no);

# START BY INSERTING DATA IN TO THE TABLES

# INSERT data INTO the BOAT CLASS TABLE

INSERT INTO MM_A11_G3_boatClass (boatClass_id, boat_size, boat_type, halfday_price, fullday_price)
VALUES ('Sml_SBoat', 'Small', 'Sail_boat', 90,  140)
	,('Sml_MBoat', 'Small', 'Motorboat', 110,  170)
    ,('Sml_RBoat', 'Small', 'Rowing_boat', 70,  90);
    
INSERT INTO MM_A11_G3_boatClass (boatClass_id, boat_size, boat_type, halfday_price, fullday_price)
VALUES ('Std_SBoat', 'Standard', 'Sail_boat', 100,  160)
	,('Std_MBoat', 'Standard', 'Motorboat', 125,  200)
    ,('Std_RBoat', 'Standard', 'Rowing_boat', 80,  120);
    
 INSERT INTO MM_A11_G3_boatClass (boatClass_id, boat_size, boat_type, halfday_price, fullday_price)
VALUES ('Lrg_SBoat', 'Large', 'Sail_boat', 120,  180)
	,('Lrg_MBoat', 'Large', 'Motorboat', 150,  240)
    ,('Lrg_RBoat', 'Large', 'Rowing_boat', 90,  140);
    
INSERT INTO MM_A11_G3_boatClass (boatClass_id, boat_size, boat_type, halfday_price, fullday_price)
VALUES ('VLrg_SBoat', 'Very_Large', 'Sail_boat', 170,  240)
	,('VLrg_MBoat', 'Very_Large', 'Motorboat', 175,  280)
    ,('VLrg_RBoat', 'Very_Large', 'Rowing_boat', 100,  160); 
    
    # INSERT data INTO the MANUFACTURER TABLE

INSERT INTO MM_A11_G3_manufacturers(manufacturer_id, manufacturer_name, phone_number, address ,email)
VALUES (1, 'SuperBoat', 01772459666, 'Unit 7 Centurion Court, Leyland, LE10 2DJ', 'admin@superboat.co.uk'),
 (2, 'Explorer Boats UK', 01704807654, 'Meadow Lane, Burscough, BU56 8GH', 'admin@explorerboats.co.uk'),
 (3, 'The Northwich Boat Company', 01270160160, 'Unit 1 Kings Lock Boatyard Booth Lane, Middlewich, MW67 7GY', 'admin@northwichboats.co.uk'),
 (4, 'Collingwood Boat Builders', 01513742985, '29 Townsend Street, Collingwood, CL27 2DU', 'admin@collingwoodboats.co.uk'),
 (5, 'Elton Moss Boat Builders', 01270760160, 'Unit 4 Kings Lock Boatyard Booth Lane, Middlewich, MW63 8TY', 'admin@eltonmossboats.co.uk'),
 (6, 'Aintree Boat Company Ltd', 01515239000, 'Brookfield Drive, Liverpool, L1 6GU', 'admin@aintreeboats.co.uk'),
(7, 'Braidbar Boats Ltd', 01625873471, 'Lord Vernons Wharf Lyme Road Higher, Poynton, PY12 9TS', 'admin@braidbarboats.co.uk'), 
(8, 'Bourne Boat Builders Ltd', 01785714692, 'Teddesley Road, Penkridge, PE8 7SU', 'admin@bourneboats.co.uk'), 
(9, 'Stoke on Trent Boat Building Co Ltd', 01782813831, 'Longport Wharf Station Street, Stoke-on-Trent, ST6 9GU', 'admin@stokeboats.co.uk'), 
(10, 'MGM Boats Narrowboat Builders', 01162640009, '27 Mill Lane, Leicester, LE6 9FY', 'admin@mgmboats.co.uk');

 # INSERT EXTRA data INTO the MANUFACTURER TABLE

INSERT INTO MM_A11_G3_manufacturers(manufacturer_id, manufacturer_name, phone_number, address ,email)
VALUES (11, 'Dennis Ltd', 07972643273, '87 Gloddaeth Street, Manchester, WV8 2PL', 'admin@denniseboats.co.uk'),
(12, 'Biggie Boats Ltd', 07980317422, '98 Jubilee Drive, Oldham, CA6 7UA', 'admin@biggieboats.co.uk'), 
(13, 'Good Sea Ltd', 07709256397, '51 Prince Consort Road, Coventry, CW6 1BR', 'admin@goodseaboats.co.uk'), 
(14, 'Backside Co Ltd', 07775229325, '43 Fore St, London, PL25 4YS', 'admin@backsideboats.co.uk'), 
(15, 'Confident Boats Ltd', 07700610745, '19 Vicar Lane, Sandridge, AL4 0UY', 'admin@confidentboats.co.uk');

    # INSERT data INTO the BOAT TABLE

INSERT INTO MM_A11_G3_boats(boat_id, boatClass_id ,boatModel ,manufacturer_id ,purchase_Date ,boatPrice, lastService_date)
VALUES (1, 'Std_MBoat', 'Explorer', 1, STR_TO_DATE('22-Nov-10', '%d-%b-%Y'), 3910, STR_TO_DATE('22-Oct-20', '%d-%b-%Y')),
 (2, 'VLrg_SBoat', 'TurboSail', 2, STR_TO_DATE('12-Oct-09', '%d-%b-%Y'), 3840, STR_TO_DATE('8-Oct-19', '%d-%b-%Y')),
 (3, 'Lrg_SBoat', 'MasterSail', 2, STR_TO_DATE('12-Oct-15', '%d-%b-%Y'), 3240, STR_TO_DATE('12-Oct-20', '%d-%b-%Y')),
 (4, 'Sml_SBoat', 'SmallSailor', 3, STR_TO_DATE('12-Nov-15', '%d-%b-%Y'), 2040, STR_TO_DATE('14-Oct-20', '%d-%b-%Y')),
 (5, 'Sml_SBoat', 'SmallSailor', 3, STR_TO_DATE('12-Nov-15', '%d-%b-%Y'), 2040, STR_TO_DATE('13-Oct-20', '%d-%b-%Y')),
 (6, 'Lrg_MBoat', 'Grande', 5, STR_TO_DATE('14-Jan-15', '%d-%b-%Y'), 5440, STR_TO_DATE('15-Oct-20', '%d-%b-%Y')),
(7, 'Lrg_MBoat', 'Grande', 5, STR_TO_DATE('14-Jan-15', '%d-%b-%Y'), 5440, STR_TO_DATE('13-Sep-20', '%d-%b-%Y')),
 (8, 'Std_MBoat', 'Turbo Mid', 2, STR_TO_DATE('14-Jan-15', '%d-%b-%Y'), 5440, STR_TO_DATE('13-Sep-20', '%d-%b-%Y')), 
 (9, 'Lrg_RBoat', 'RowStream', 3, STR_TO_DATE('12-Jan-15', '%d-%b-%Y'), 440, STR_TO_DATE('10-Aug-20', '%d-%b-%Y')),
 (10, 'Std_RBoat', 'RowerX', 4, STR_TO_DATE('12-Jan-15', '%d-%b-%Y'), 320, STR_TO_DATE('22-Sep-20', '%d-%b-%Y')),
 (11, 'Lrg_SBoat', 'Explorer', 1, STR_TO_DATE('10-Jan-16', '%d-%b-%Y'), 3320, STR_TO_DATE('3-Mar-20', '%d-%b-%Y')),
 (12, 'Std_SBoat', 'Navigator', 1, STR_TO_DATE('10-Jan-16', '%d-%b-%Y'), 3320, STR_TO_DATE('3-Apr-20', '%d-%b-%Y')),
 (13, 'Std_MBoat', 'Turbo Mid', 2, STR_TO_DATE('14-Feb-18', '%d-%b-%Y'), 4440, STR_TO_DATE('14-Sep-20', '%d-%b-%Y')),
 (14, 'Std_MBoat', 'Turbo Mid', 2, STR_TO_DATE('14-Feb-18', '%d-%b-%Y'), 4440, STR_TO_DATE('13-Sep-20', '%d-%b-%Y')),
 (15, 'Lrg_MBoat', 'MasterBlaster', 7, STR_TO_DATE('14-Jan-18', '%d-%b-%Y'), 5440, STR_TO_DATE('14-Oct-19', '%d-%b-%Y')),
 (16, 'Lrg_RBoat', 'HappyRower', 8, STR_TO_DATE('10-Jan-18', '%d-%b-%Y'), 340, STR_TO_DATE('2-Oct-20', '%d-%b-%Y')),
 (17, 'Sml_RBoat', 'HappyRower', 8, STR_TO_DATE('10-Jan-18', '%d-%b-%Y'), 340, STR_TO_DATE('2-Oct-20', '%d-%b-%Y')),
 (18, 'VLrg_RBoat', 'Streamer', 3, STR_TO_DATE('9-Jan-17', '%d-%b-%Y'), 640, STR_TO_DATE('7-Oct-20', '%d-%b-%Y')),
 (19, 'VLrg_RBoat', 'Great Row', 4, STR_TO_DATE('19-Jan-19', '%d-%b-%Y'), 650, STR_TO_DATE('12-Sep-20', '%d-%b-%Y')), 
 (20, 'VLrg_MBoat', 'SuperBlaster', 7, STR_TO_DATE('14-Jan-18', '%d-%b-%Y'), 7440, STR_TO_DATE('7-Aug-20', '%d-%b-%Y')), 
 (21, 'Std_RBoat', 'Lizard', 6,STR_TO_DATE('9-Jan-17', '%d-%b-%Y'), 340, STR_TO_DATE('4-Oct-20', '%d-%b-%Y')), 
 (22, 'Lrg_MBoat', 'Grande', 5, STR_TO_DATE('14-Feb-18', '%d-%b-%Y'), 5440, STR_TO_DATE('13-Sep-20', '%d-%b-%Y')),
 (23, 'Lrg_SBoat', 'MasterSail', 2, STR_TO_DATE('12-Oct-15', '%d-%b-%Y'), 3240, STR_TO_DATE('27-Jan-20', '%d-%b-%Y'));
 
  # INSERT EXTRA data INTO the BOAT TABLE
 
 INSERT INTO MM_A11_G3_boats(boat_id, boatClass_id ,boatModel ,manufacturer_id ,purchase_Date ,boatPrice, lastService_date)
VALUES (24, 'Std_MBoat', 'MasterBlaster', 15, STR_TO_DATE('22-Nov-10', '%d-%b-%Y'), 3910, STR_TO_DATE('22-Oct-20', '%d-%b-%Y')),
 (25, 'VLrg_SBoat', 'TurboSail', 7, STR_TO_DATE('01-Oct-21', '%d-%b-%Y'), 7440, STR_TO_DATE('08-Jan-22', '%d-%b-%Y')),
 (26, 'Lrg_SBoat', 'HappyRower', 13, STR_TO_DATE('27-Oct-19', '%d-%b-%Y'), 4430, STR_TO_DATE('12-Jun-20', '%d-%b-%Y')),
 (27, 'Std_SBoat', 'Lizard', 3, STR_TO_DATE('26-Aug-20', '%d-%b-%Y'), 3340, STR_TO_DATE('14-Oct-21', '%d-%b-%Y')),
 (28, 'Sml_SBoat', 'SmallSailor', 9, STR_TO_DATE('12-Jul-18', '%d-%b-%Y'), 2040, STR_TO_DATE('04-Feb-22', '%d-%b-%Y'));
 
 # INSERT data INTO the DEALER TABLE
 
INSERT INTO MM_A11_G3_dealers(dealer_id, dealer_name, mobile_number, address, email)
VALUES (1, 'Dalis Vannoort', 07574137463, '77 A828, Appin, AP7 6GU', 'dvannoort0@salon.com'), 
(2, 'Joe"s Junk', 07365534221, '15 Back Lane, Buxton, BX7 5FY', 'JoesJunk@zdnet.com'),
(3, 'Hoebart Kubera', 07874051869, '4 Finedon House, Marine Parade, Littlestone, LS4 6GU', 'hkubera2@who.int'), 
(4, 'Eva Iacomettii', 07880072148, '9 Hartlands, Onslow Road, Newent, NW5 8TU', 'eiacomettii3@admin.ch'), 
(5, 'Alley Pate', 07822040557, '07610 Arizona Alley, A67 8GU', 'apate4@gnu.org'), 
(6, 'Korrie Legge', 07380018233, '1076 Evesham Road, Astwood Bank, DT5 8JO', 'klegge5@reference.com'), 
(7, 'Minne Hinkens', 07978390430, '53 Balby Road, Balby, B7 8HK', 'mhinkens6@smh.com.au'), 
(8, 'Inigo MacAllaster', 07893419552, '1910 Farwell Plaza, G56 9FT', 'imacallaster7@blogspot.com'), 
(9, 'Linell Skeeles', 07532931207, '57 Great Russell Street, London, NW1 8TU', 'lskeeles8@goo.gl'), 
(10, 'Sioux Drogan', 07417098738, '75 Thomas Parsons Square, Ely, EL6 9GU', 'sdrogan9@dropbox.com');

  # INSERT EXTRA data INTO the DEALERS TABLE
  
INSERT INTO MM_A11_G3_dealers(dealer_id, dealer_name, mobile_number, address, email)
VALUES (11, 'Mile Stone', 07865066320, '51 Long Street, Milstead, ME9 5WX', 'miles@boats.com'), 
(12, 'Failed Metals', 07920315432, '50 Nenthead Road, High Garrett, CM7 5XW', 'failedmetals@uniform.com.au'), 
(13, 'New Wave', 07826365765, '160 Brynglas Road, Glenochar, ML12 8HD', 'newwave@blogbait.com'), 
(14, 'Energy Move ', 07750882419, '41 Ross Road, Marsett, DL8 2SN', 'energy@move.gl.uk'), 
(15, 'Commander Junks', 07935544660, '22 Ponteland Rd, Hugglescote, LE67 2XA', 'commander@hotbox.com');

 # INSERT data INTO the DISPOSAL HISTORY TABLE

INSERT INTO MM_A11_G3_disposal_history(boat_id, sell_date, sell_price, dealer_id )
VALUES (9, STR_TO_DATE('10-Jan-22', '%d-%b-%Y'), 200,10),
(2, STR_TO_DATE('10-Oct-20', '%d-%b-%Y'), 1600,2),
(7, STR_TO_DATE('1-Mar-22', '%d-%b-%Y'), 1200,4), 
(10, STR_TO_DATE('05-Dec-21', '%d-%b-%Y'), 100,1),
(23, STR_TO_DATE('06-Dec-20', '%d-%b-%Y'), 1700,1),
(1, STR_TO_DATE('02-Jan-20', '%d-%b-%Y'), 1500,2),
(20, STR_TO_DATE('27-Feb-22', '%d-%b-%Y'), 2100.67,10),
(15, STR_TO_DATE('24-Sep-21', '%d-%b-%Y'), 1700,7);

 # INSERT data INTO the CUSTOMER TABLE

INSERT INTO MM_A11_G3_customer(customer_id, first_name, last_name, mobile_number, address, email )
VALUES (1, 'Dion', 'Brodnecke', 07174826351, '9 Oak Street, Liverpool, L34 8DY', 'dbroes1d@who.int'), 
(2, 'Scarlett', 'Galley', 03260476982, '886 Northport Parkway, Liverpool, L3 6DF', 'scargr1c@imgur.com'), 
(3, 'Sissy', 'Gadson', 04924556740, '95 Putney Road, Liverpool, L2 7YG', 'sgadson1b@ucoz.com'),
(4, 'Tabby', 'Minichi', 07795213673, '6 Amoth Court, Warrington, WT6 8UY', 'minitabc@imgur.com'),
(5, 'Nellie', 'Greenmon', 03816078215, '40 Graceland Crossing, Liverpool, L23 8FY', 'nelliegreen12@patch.com'), 
(6, 'Hanny', 'Marsters', 07075576685, '2 Almo Trail, Liverpool, L21 9FY', 'hmarsters@netlog.com'),
(7, 'Oswell', 'Aspinell', 09931348133, '64 Jackson Road, Liverpool, L5 6FH', 'OsAspinell@digg.com'),
(8, 'Florance', 'Baston', 07315082134, '40 Magdeline Lane, Warrington, WT5 8WK', 'FloBar@dirtg.com'),
(9, 'Candice', 'Tumilson', 01639824657, '1 Farragut Parkway, Liverpool, L75 8GJ', 'canditum15@bloomberg.com'), 
(10, 'Clair', 'Bavin', 06245985897, '87 Toban Drive, Liverpool, L26 8GH', 'clairBav@sprog.it');

# INSERT EXTRA data INTO the CUSTOMER TABLE

INSERT INTO MM_A11_G3_customer(customer_id, first_name, last_name, mobile_number, address, email )
VALUES (11, 'JOhn', 'Walker', 07803616136, '44 Dunmow Road, Grittenham, SN15 2JD', 'walkerjo@see.ac.uk'), 
(12, 'Zoey', 'Vivian', 07884502743, '53 Asfordby Rd,Alcester, B49 9UZ', 'zvivian@hulu.com'), 
(13, 'Mike', 'Gary', 07034818670, ' 97 Bath Rd, Wolferlow, WR15 1EX', 'mikegary46@woke.com'),
(14, 'Stephon', 'Gordon', 07018380630, '8 Overton Circle, Little Thurrock, RM17 9LE', 'stephendon@hotmail.com'),
(15, 'Anthony', 'Wood', 07781259940, '28 Cunnery Rd, Mains Of Fedderate, AB42 8RS', 'woodthony@drink.uk');


 # INSERT data INTO the RESERVATION AND RENTAL TABLE
 # IF SELECT MM_A11_G3_reservation_rentals WHERE 'PAID' is null is reservation if null not null is rental
 
INSERT INTO MM_A11_G3_reservation_rentals(reservation_no, boatClass_id, reservation_date, customer_id, hire_date, hire_period, boat_id, hire_price, hire_dueDate, payment_status)
VALUES (5344, 'Lrg_RBoat', STR_TO_DATE('20-Oct-20', '%d-%b-%Y'), 1, STR_TO_DATE('22-Oct-20', '%d-%b-%Y'), '1 Day', 9, 280, STR_TO_DATE('22-Oct-20', '%d-%b-%Y'), 'paid'),
(5345, 'Sml_RBoat', STR_TO_DATE('20-Oct-20', '%d-%b-%Y'), 2, STR_TO_DATE('21-Oct-20', '%d-%b-%Y'), '1 Day', 16, 220, STR_TO_DATE('22-Oct-20', '%d-%b-%Y'), 'paid'), 
(5347, 'Lrg_MBoat', STR_TO_DATE('20-Oct-20', '%d-%b-%Y'), 9, STR_TO_DATE('21-Oct-20', '%d-%b-%Y'), '1 Day', 7, 240, STR_TO_DATE('21-Oct-20', '%d-%b-%Y'), 'paid'),
(5346, 'Lrg_MBoat', STR_TO_DATE('20-Oct-20', '%d-%b-%Y'), 4, STR_TO_DATE('20-Oct-20', '%d-%b-%Y'), '1 Day', 6, 240, STR_TO_DATE('21-Oct-20', '%d-%b-%Y'), 'paid'),
(5349, 'Lrg_RBoat', STR_TO_DATE('20-Oct-20', '%d-%b-%Y'), 7, STR_TO_DATE('20-Oct-20', '%d-%b-%Y'), '1 Day', 9, 140, STR_TO_DATE('21-Oct-20', '%d-%b-%Y'), 'paid'), 
(5348, 'Lrg_MBoat', STR_TO_DATE('20-Oct-20', '%d-%b-%Y'), 6, STR_TO_DATE('20-Oct-20', '%d-%b-%Y'), '1 Day', 15, 240, STR_TO_DATE('21-Oct-20', '%d-%b-%Y'), 'paid'),
(5350, 'Lrg_SBoat', STR_TO_DATE('20-Oct-20', '%d-%b-%Y'), 2, STR_TO_DATE('20-Oct-20', '%d-%b-%Y'), '1 Day', 9, 180, STR_TO_DATE('21-Oct-20', '%d-%b-%Y'), 'paid'),
(5352, 'Sml_RBoat', STR_TO_DATE('20-Oct-20', '%d-%b-%Y'), 5, STR_TO_DATE('20-Oct-20', '%d-%b-%Y'), '1 Day', 16, 110, STR_TO_DATE('21-Oct-20', '%d-%b-%Y'), 'paid'),
(5353, 'Sml_RBoat', STR_TO_DATE('20-Oct-20', '%d-%b-%Y'), 5, STR_TO_DATE('20-Oct-20', '%d-%b-%Y'), '1 Day', 17, 110, STR_TO_DATE('21-Oct-20', '%d-%b-%Y'), 'paid'),
(5354, 'Std_MBoat', STR_TO_DATE('20-Oct-20', '%d-%b-%Y'), 9, STR_TO_DATE('20-Oct-20', '%d-%b-%Y'), '2 Days', 14, 400, STR_TO_DATE('22-Oct-20', '%d-%b-%Y'), 'paid'),
(5351, 'Lrg_SBoat', STR_TO_DATE('20-Oct-20', '%d-%b-%Y'), 2, STR_TO_DATE('20-Oct-20', '%d-%b-%Y'), '1 Day', 11, 180, STR_TO_DATE('21-Oct-20', '%d-%b-%Y'), 'paid'),
(5364, 'Sml_SBoat', STR_TO_DATE('20-Oct-20', '%d-%b-%Y'), 8, STR_TO_DATE('20-Oct-20', '%d-%b-%Y'), '1 Day', 4, 110, STR_TO_DATE('21-Oct-20', '%d-%b-%Y'), 'paid'),
(5355, 'Std_MBoat', STR_TO_DATE('20-Oct-20', '%d-%b-%Y'), 9, STR_TO_DATE('20-Oct-20', '%d-%b-%Y'), '2 Days', 13, 400, STR_TO_DATE('22-Oct-20', '%d-%b-%Y'), 'paid'),
(5356, 'Std_MBoat', STR_TO_DATE('20-Oct-20', '%d-%b-%Y'), 1, STR_TO_DATE('20-Oct-20', '%d-%b-%Y'), '1 Day', 8, 200, STR_TO_DATE('21-Oct-20', '%d-%b-%Y'), 'paid'),
(5357, 'Std_MBoat', STR_TO_DATE('20-Oct-20', '%d-%b-%Y'), 6, STR_TO_DATE('20-Oct-20', '%d-%b-%Y'), '1 Day', 1, 200, STR_TO_DATE('21-Oct-20', '%d-%b-%Y'), 'paid'),
(5358, 'Std_RBoat', STR_TO_DATE('20-Oct-20', '%d-%b-%Y'), 7, STR_TO_DATE('20-Oct-20', '%d-%b-%Y'), '1 Day', 10, 120, STR_TO_DATE('21-Oct-20', '%d-%b-%Y'), 'paid'),
(5366, 'Std_RBoat', STR_TO_DATE('20-Oct-20', '%d-%b-%Y'), 10, STR_TO_DATE('20-Oct-20', '%d-%b-%Y'), '1/2 Day', 21, 80, STR_TO_DATE('20-Oct-20', '%d-%b-%Y'), 'paid'),
(5360, 'VLrg_MBoat', STR_TO_DATE('20-Oct-20', '%d-%b-%Y'), 4, STR_TO_DATE('20-Oct-20', '%d-%b-%Y'), '1 Day', 20, 280, STR_TO_DATE('21-Oct-20', '%d-%b-%Y'), 'paid'),
(5361, 'VLrg_SBoat', STR_TO_DATE('20-Oct-20', '%d-%b-%Y'), 8, STR_TO_DATE('20-Oct-20', '%d-%b-%Y'), '1 Day', 2, 240, STR_TO_DATE('20-Oct-20', '%d-%b-%Y'), 'paid'),
(5359, 'Std_SBoat', STR_TO_DATE('20-Oct-20', '%d-%b-%Y'), 10, STR_TO_DATE(null, '%d-%b-%Y'), '1 Day', null, 160, STR_TO_DATE(null, '%d-%b-%Y'), null),
(5362, 'VLrg_RBoat', STR_TO_DATE('20-Oct-20', '%d-%b-%Y'), 3, STR_TO_DATE(null, '%d-%b-%Y'), '1 Day', null, 100, STR_TO_DATE(null, '%d-%b-%Y'), null),
(5365, 'Std_RBoat', STR_TO_DATE('20-Oct-20', '%d-%b-%Y'), 3, STR_TO_DATE(null, '%d-%b-%Y'), '1 Day', null, 120, STR_TO_DATE(null, '%d-%b-%Y'), null),
(5363, 'VLrg_RBoat', STR_TO_DATE('20-Oct-20', '%d-%b-%Y'), 3, STR_TO_DATE(null, '%d-%b-%Y'), '1 Day', null, 100, STR_TO_DATE(null, '%d-%b-%Y'), null),
(5342, 'Lrg_SBoat', STR_TO_DATE('27-Oct-20', '%d-%b-%Y'), 1, STR_TO_DATE('27-Oct-20', '%d-%b-%Y'), '1 Day', 16, 180, STR_TO_DATE('28-Oct-20', '%d-%b-%Y'), 'paid'),
(5363, 'Lrg_MBoat', STR_TO_DATE('20-Oct-19', '%d-%b-%Y'), 4, STR_TO_DATE(null, '%d-%b-%Y'), '1 Day', 6, 100, STR_TO_DATE(null, '%d-%b-%Y'), null),
(5343, 'Lrg_MBoat', STR_TO_DATE('09-Dec-19', '%d-%b-%Y'), 2, STR_TO_DATE('09-Dec-19', '%d-%b-%Y'), '1 Day', 6, 180, STR_TO_DATE('10-Dec-19', '%d-%b-%Y'), 'paid');

INSERT INTO MM_A11_G3_reservation_rentals(reservation_no, boatClass_id, reservation_date, customer_id, hire_date, hire_period, boat_id, hire_price, hire_dueDate, payment_status)
VALUES(5367, 'Lrg_MBoat', STR_TO_DATE('20-Oct-20', '%d-%b-%Y'), 15, STR_TO_DATE(null, '%d-%b-%Y'), '1 Day', null, 150, STR_TO_DATE(null, '%d-%b-%Y'), null),
(5341, 'Sml_MBoat', STR_TO_DATE('20-Oct-20', '%d-%b-%Y'), 9, STR_TO_DATE(null, '%d-%b-%Y'), '2 Days', null, 220, STR_TO_DATE(null, '%d-%b-%Y'), null),
(5368, 'Sml_SBoat', STR_TO_DATE('27-Oct-20', '%d-%b-%Y'), 13, STR_TO_DATE('27-Oct-20', '%d-%b-%Y'), '2 Days', 5, 180, STR_TO_DATE('29-Oct-20', '%d-%b-%Y'), 'paid'),
(5340, 'Std_RBoat', STR_TO_DATE('20-Oct-19', '%d-%b-%Y'), 11, STR_TO_DATE(null, '%d-%b-%Y'), '2 Days', null, 240, STR_TO_DATE(null, '%d-%b-%Y'), null);

 # INSERT data INTO the SPAREPARTS IN STOCK TABLE

INSERT INTO MM_A11_G3_sparepart_in_stock(sparepart_id, sparepart_name, manufacturer_id, quantity)
VALUES (1, 'Mast', 6, 37),
(2, 'Boom', 4, 44),
(3, 'Rudderstock', 9, 50),
(4, 'Forestay', 3, 69),
(5, 'propeller', 6, 44),
(6, 'Bilge pump', 2, 58),
(7, 'Head pump', 1, 34);

 # INSERT EXTRA data INTO the SPAREPARTS IN STOCK TABLE
 
INSERT INTO MM_A11_G3_sparepart_in_stock(sparepart_id, sparepart_name, manufacturer_id, quantity)
VALUES (8, 'Outboard fuel tank', 6, 25),
(9, 'Exhuast riser', 4, 82),
(10, 'Battery isolator', 10, 50),
(11, 'Stuart turner engine', 3, 69),
(12, 'Oli filter cup wrench', 6, 44),
(13, 'Electric outboard propeller', 1, 58);

 # INSERT data INTO the ORDERED PARTS TABLE

INSERT INTO MM_A11_G3_ordered_part(order_no, sparepart_id, quantity)
VALUES ('2001A', 6, 6),
('2004D',  1, 3),
('2013M', 9, 7),
('2006F', 4, 1),
('2002B', 2, 1),
('2008H', 7, 1),
('2010J', 9, 1),
('2007G', 5, 1),
('2014N', 2, 3),
('2003C', 6, 1),
('2005E', 3, 8),
('2009I', 10, 1),
('2011K', 8, 1),
('2012L', 11, 1);

 # INSERT data INTO the REPAIR OR SERVICES TABLE

INSERT INTO MM_A11_G3_repair_service(ref_no, fault_details, fault_date, solution_details, solution_date, order_no)
VALUES(001, 'Chipped propeller', STR_TO_DATE('15-Feb-15', '%d-%b-%Y'), 'Replaced Propeller', STR_TO_DATE('27-Feb-15', '%d-%b-%Y'), '2007G'),
(002, 'Bilge pumps not found', STR_TO_DATE('10-Jul-15', '%d-%b-%Y'), 'New bilge pumps', STR_TO_DATE('27-Aug-15', '%d-%b-%Y'), '2003C'),
(003, NULL, STR_TO_DATE(NULL, '%d-%b-%Y'), 'New head pump', STR_TO_DATE('15-Aug-15', '%d-%b-%Y'),'2008H'),
(004, NULL, STR_TO_DATE(NULL, '%d-%b-%Y'), 'Normal Service', STR_TO_DATE('20-Mar-16', '%d-%b-%Y'),NULL),
(005, 'Cutless bearing worn through', STR_TO_DATE('02-Dec-15', '%d-%b-%Y'), 'Fit new bearing', STR_TO_DATE('27-Jan-17', '%d-%b-%Y'), NULL),
(006, 'Damaged mast', STR_TO_DATE('17-Apr-16', '%d-%b-%Y'), 'Repair Mast', STR_TO_DATE('27-Apr-16', '%d-%b-%Y'), NULL),
(007, 'Bent Forestay', STR_TO_DATE('10-Jul-17', '%d-%b-%Y'), 'Repair foresaty', STR_TO_DATE('22-Aug-17', '%d-%b-%Y'),'2006F'),
(008, 'Shot Boom', STR_TO_DATE('07-May-18', '%d-%b-%Y'), 'Replace Boom', STR_TO_DATE('06-Jun-18', '%d-%b-%Y'), '2002B'),
(009, 'Rudderstock Chipped', STR_TO_DATE('07-Jul-19', '%d-%b-%Y'), 'Repair Rudderstock', STR_TO_DATE('08-Jul-19', '%d-%b-%Y'), NULL),
(010, NULL, STR_TO_DATE(NULL, '%d-%b-%Y'), 'Normal Service', STR_TO_DATE('27-Jan-20', '%d-%b-%Y'),NULL),
(011, 'Rudderblade busted', STR_TO_DATE('19-Oct-20', '%d-%b-%Y'), NULL , STR_TO_DATE(NULL, '%d-%b-%Y'),NULL);

# INSERT  EXTRA data INTO the REPAIR OR SERVICES TABLE

INSERT INTO MM_A11_G3_repair_service(ref_no, fault_details, fault_date, solution_details, solution_date, order_no)
VALUES(012, 'Damaged exhaust riser', STR_TO_DATE('02-Dec-20', '%d-%b-%Y'), 'Replace exhuast riser', STR_TO_DATE('02-Jan-21', '%d-%b-%Y'), '2010J'),
(013, 'Burnt battery isolator', STR_TO_DATE('03-Apr-21', '%d-%b-%Y'), 'Replace battery isolator', STR_TO_DATE('04-May-21', '%d-%b-%Y'),'2009I'),
(014, 'Oli filter cup wrench', STR_TO_DATE('21-Jul-21', '%d-%b-%Y'), 'Repair oli filter cup wrench', STR_TO_DATE('22-Aug-21', '%d-%b-%Y'), NULL),
(015, 'Stuart turner engine', STR_TO_DATE('15-May-21', '%d-%b-%Y'), 'Replace stuart turner engine', STR_TO_DATE('22-Jun-21', '%d-%b-%Y'), '2012L'),
(016, 'Outboard fuel tank', STR_TO_DATE('07-Jul-21', '%d-%b-%Y'), 'Replace fuel tank', STR_TO_DATE('08-Sep-21', '%d-%b-%Y'), '2011K');

# INSERT data INTO the MAINTENANCE HISTORY TABLE

INSERT INTO MM_A11_G3_maintenance_history(boat_id, ref_no)
VALUES (1, 001),
(1, 002),
(1, 003),
(1, 004),
(1, 005),
(2, 006),
(2, 007),
(2, 008),
(2, 009),
(2, 010),
(2, 011),
(18, 012),
(5, 013),
(10, 014),
(23, 015),
(7, 016);

# INSERT data INTO the DELIVERED PART TABLE

INSERT INTO MM_A11_G3_delivered(delivery_no, order_no, delivery_address)
VALUES(1001, '2001A', '32 Wenlock Terrace, Pettaugh, IP14 0QA'),
(1004, '2013M', '1 Simone Weil Avenue, Weedon Lois, NN12 2QS'),
(1003, '2004D', '72 Union Terrace, London, E10 4PE'),
(1005, '2005E', '60 Abbey Row, Nyadd, FK9 0DY'),
(1002, '2014N', ' 62 Kent Street, Crosby, IM4 6TU');

COMMIT;