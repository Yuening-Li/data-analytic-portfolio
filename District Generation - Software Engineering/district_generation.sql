DROP DATABASE IF EXISTS district_generation;
CREATE DATABASE district_generation;
USE district_generation;

DROP TABLE IF EXISTS RegisteredUser;
CREATE TABLE RegisteredUser (
  id         INTEGER      NOT NULL AUTO_INCREMENT,
  username  VARCHAR(50)  NOT NULL,
  firstname VARCHAR(50)  NOT NULL,
  lastname  VARCHAR(50)  NOT NULL,
  email      VARCHAR(100) NOT NULL,
  pass_word  VARCHAR(100) NOT NULL,
  PRIMARY KEY (id),
  CHECK (id > 0)
);


DROP TABLE IF EXISTS Admin;
CREATE TABLE Admin (
  id         INTEGER      NOT NULL AUTO_INCREMENT,
  username  VARCHAR(50)  NOT NULL,
  pass_word  VARCHAR(100) NOT NULL,
  PRIMARY KEY (id),
  CHECK (id > 0)
);


DROP TABLE IF EXISTS State;
CREATE TABLE State (
  state_Id     INT(2)     NOT NULL,
  state_name   VARCHAR(20) NOT NULL,
  short_cut    VARCHAR(2)  NOT NULL,
  num_district integer     NOT NULL,
  population   INTEGER     NOT NULL,
  PRIMARY KEY (state_Id)
);


DROP TABLE IF EXISTS District;
CREATE TABLE District (
  district_id        	 INT         NOT NULL,
  state  				 INTEGER     NOT NULL,
  population         	 INTEGER     NOT NULL,
  republican			 INTEGER     NOT NULL,
  democratic			 INTEGER     NOT NULL,
  boundary				 mediumtext  NOT NULL,			  

  PRIMARY KEY (district_id),
  FOREIGN KEY (state) REFERENCES State (state_Id)
    ON UPDATE NO ACTION
    ON DELETE NO ACTION,

  CHECK (population > 0)

);


DROP TABLE IF EXISTS Precinct;
CREATE TABLE Precinct (
  precinct_id        	 VARCHAR(12)     NOT NULL,
  district           	 INTEGER     NOT NULL,
  precinct_name      	 VARCHAR(200) NOT NULL,
  population         	 INTEGER     NOT NULL,
  republican			 INTEGER     NOT NULL,
  democratic			 INTEGER     NOT NULL,

  PRIMARY KEY (precinct_id),
  FOREIGN KEY (district) REFERENCES District (district_id)
    ON UPDATE NO ACTION
    ON DELETE CASCADE,

  CHECK (population > 0)
);


DROP TABLE IF EXISTS PrecinctBoundry;
CREATE TABLE PrecinctBoundry (
  precinct_id            VARCHAR(12)   NOT NULL,
  boundry          	     mediumtext,

  PRIMARY KEY (precinct_id),
  FOREIGN KEY (precinct_id) REFERENCES Precinct (precinct_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

DROP TABLE IF EXISTS NeighborDistricts;
CREATE TABLE NeighborDistricts (
  district1           	 INT   NOT NULL,
  district2          	 INT   NOT NULL,

  PRIMARY KEY (district1,district2),
  FOREIGN KEY (district1) REFERENCES District (district_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  FOREIGN KEY (district2) REFERENCES District (district_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);


DROP TABLE IF EXISTS BorderPrecincts;
CREATE TABLE BorderPrecincts (
  district           	 INT(2)        NOT NULL,
  precinct           	 VARCHAR(12)        NOT NULL,
  
  PRIMARY KEY (precinct,district),
  FOREIGN KEY (precinct) REFERENCES Precinct (precinct_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  FOREIGN KEY (district) REFERENCES District (district_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

DROP TABLE IF EXISTS NeighborPrecincts;
CREATE TABLE NeighborPrecincts (
  precinct1           	 VARCHAR(12)     NOT NULL,
  precinct2           	 VARCHAR(12)     NOT NULL,

  PRIMARY KEY (precinct1,precinct2),
   FOREIGN KEY (precinct1) REFERENCES Precinct (precinct_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
      FOREIGN KEY (precinct2) REFERENCES Precinct (precinct_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);






