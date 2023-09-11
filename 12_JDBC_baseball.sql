CREATE TABLE team (
	num INT AUTO_INCREMENT PRIMARY KEY,
	NAME VARCHAR(100) NOT NULL,
	LOCAL VARCHAR(100)
);

CREATE TABLE player (
	num INT AUTO_INCREMENT PRIMARY KEY,
	NAME VARCHAR(100) NOT NULL,
	backnum INT,
	teamnum INT REFERENCES team(num)
);

SELECT * FROM team;


INSERT INTO team (NAME, LOCAL) VALUES ("SSG랜더스", "인천");
INSERT INTO player (NAME, backnum, teamnum) VALUES ("김광현", 10, 1);

SELECT p.num, p.name, p.backnum, p.teamnum, t.name
from player p join team t on p.teamnum=t.num
where t.name='SSG랜더스';


DELETE FROM player WHERE num = 10;