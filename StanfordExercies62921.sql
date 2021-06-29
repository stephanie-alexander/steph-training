SQL Movie-Rating Query Exercises

1)SELECT title
FROM movie
WHERE director='Steven Spielberg'

2)SELECT DISTINCT year
FROM movie m
JOIN rating r ON r.mID=m.mID
WHERE stars > 3
ORDER BY year ASC

3)SELECT title
FROM movie m
WHERE m.mID NOT IN (SELECT r.mID FROM rating r);

4)SELECT name 
FROM reviewer
WHERE rID IN (SELECT rID FROM rating WHERE ratingDate IS NULL)

5)SELECT re.name AS 'Reviewer Name', m.title AS 'Movie Title', r.stars AS 'Stars', ratingDate AS 'Rating Date'
FROM rating r
JOIN reviewer re ON re.rID=r.rID
JOIN movie m ON r.mID=m.mID
ORDER BY re.name, m.title, r.stars

6)SELECT re.name, m.title
FROM (SELECT r1.rID as rID, r1.mid AS mID FROM rating r1, rating r2
WHERE (r1.rID=r2.rID) AND (r1.mid=r2.mID) AND (r1.ratingDate<r2.ratingDate) 
AND (r1.stars<r2.stars)) AS c
LEFT JOIN reviewer re ON c.rid=re.rID
LEFT JOIN movie m ON m.mID=c.mID

7)SELECT m.title, MAX(r.stars) AS 'Max Rating'
FROM rating r
LEFT JOIN movie m ON m.mid=r.mid
GROUP BY m.title

8)SELECT m.title, (MAX(r.stars)-MIN(r.stars)) AS rating_spread
FROM rating r
LEFT JOIN movie m ON r.mID=m.mID
GROUP BY m.title
ORDER BY rating_spread DESC, m.title ASC;

9)SELECT t1.avg_b1980-t2.avg_a1980
FROM (SELECT AVG(r1.avg_movie) as avg_b1980
FROM (SELECT r.mID, AVG(r.stars) AS avg_movie
FROM rating r GROUP BY r.mID) as r1
LEFT JOIN movie m ON r1.mID=m.mID WHERE m.year<1980) as t1,
(SELECT AVG(r1.avg_movie) as avg_a1980
FROM (SELECT r.mID, AVG(r.stars) AS avg_movie
FROM rating r GROUP BY r.mID) as r1
LEFT JOIN movie m ON r1.mID=m.mID WHERE m.year>=1980) as t2

SQL Movie-Rating Query Exercises Extras

1)SELECT DISTINCT re.name
FROM reviewer re
JOIN rating r ON re.rid=r.rid
JOIN movie m ON r.mid=m.mid
WHERE m.mid=101

2)SELECT re.name, m.title, r.stars
FROM reviewer re
JOIN rating r ON re.rid=r.rid
JOIN movie m ON r.mid=m.mid
WHERE re.name=m.director

3)SELECT t.list
FROM (SELECT DISTINCT re.name as list
	  FROM reviewer re
	  UNION ALL
	  SELECT DISTINCT m.title as list
	  FROM movie m) as t
Order By t.list

4)SELECT m.title
FROM movie m
WHERE m.mID NOT IN (SELECT mID 
					FROM rating
					WHERE rID = (SELECT rID
								 FROM reviewer 
								 WHERE name = 'Chris Jackson')
					)
					

5)select distinct rv.name, rv2.name
from rating r1 
join rating r2 on r1.mid = r2.mid 
join reviewer rv on rv.rid = r1.rid 
join reviewer rv2 on rv2.rid = r2.rid and rv.name < rv2.name
ORDER BY rv.name;

6)SELECT re.name, m.title, r.stars
FROM reviewer re
JOIN RATING r ON r.rID=re.rID 
JOIN Movie m ON r.mid=m.mid
WHERE r.stars = (SELECT min(stars) FROM rating)

7)SELECT m.title, t1.avgm
FROM (SELECT mid, AVG(Stars) as AvgM
	  FROM rating
	  GROUP BY mID) t1
JOIN movie m ON m.mid=t1.mID
ORDER BY t1.avgm DESC, m.title

8)SELECT re.name
FROM (SELECT rID, SUM(1) Sum1
	  FROM rating
	  GROUP BY rID) r
JOIN reviewer re ON r.rid=re.rid
WHERE Sum1>=3

9)SELECT title, director 
FROM movie
WHERE director IN (SELECT director 
				   FROM movie
				  GROUP BY director
				  HAVING max(mid)>min(mid))
ORDER BY director, title

10)SELECT m.title, t1.avg_movie
FROM (SELECT mID, AVG(stars) AS avg_movie
FROM rating
GROUP BY mID) t1
LEFT JOIN movie m ON t1.mID=m.mID
WHERE t1.avg_movie = (SELECT AVG(stars) AS avg_movie
FROM rating
GROUP BY mID
ORDER BY avg_movie DESC
LIMIT 1);

11)SELECT m.title, t1.avg_movie
FROM (SELECT mID, AVG(stars) AS avg_movie
FROM rating
GROUP BY mID) t1
LEFT JOIN movie m ON t1.mID=m.mID
WHERE t1.avg_movie = (SELECT AVG(stars) AS avg_movie
FROM rating
GROUP BY mID
ORDER BY avg_movie
LIMIT 1);

12)SELECT m1.director,m1.title,t2.max_stars
FROM movie m1
LEFT JOIN (SELECT mID, MAX(stars) as max_stars FROM rating GROUP BY mID) t2 ON m1.mID=t2.mID
WHERE m1.mID in (SELECT m.mID
FROM movie m
LEFT JOIN (SELECT mID, MAX(stars) as max_stars FROM rating GROUP BY mID) t1 ON m.mID=t1.mID
GROUP BY m.director
HAVING MAX(max_stars)) AND m1.director is not NULL
ORDER BY m1.director;


SQL Social-Network Query Exercises

1)Select hs1.name
From Highschooler hs1,Highschooler hs2,Friend
Where hs1.ID = Friend.ID1
AND hs2.name='Gabriel'
AND hs2.ID = Friend.ID2

2)SELECT hs.name, hs.grade, hs2.name, hs2.grade
FROM likes l
LEFT JOIN highschooler hs ON l.id1=hs.id
LEFT JOIN highschooler hs2 ON l.id2=hs2.id
WHERE hs.grade-hs2.grade>=2;

3)SELECT hs.name, hs.grade, hs2.name, hs2.grade
FROM likes l, likes l1
LEFT JOIN highschooler hs ON l.id1=hs.id
LEFT JOIN highschooler hs2 ON l.id2=hs2.id
WHERE (l.id1=l1.id2) and (l1.id1=l.id2) and (hs.name<hs2.name);

4)SELECT hs.name, hs.grade
FROM highschooler hs
WHERE hs.id not in (SELECT l.id1 FROM likes l) and
hs.id not in (SELECT l.id2 FROM likes l);

5)SELECT hs.name, hs.grade, hs2.name, hs2.grade
FROM likes l
LEFT JOIN highschooler hs ON l.id1=hs.id
LEFT JOIN highschooler hs2 ON l.id2=hs2.id
WHERE l.id2 not in (SELECT id1 from likes);

6)SELECT hs.name, hs.grade
FROM highschooler hs
WHERE hs.id not in (SELECT f.id1
FROM friend f
LEFT JOIN highschooler hs1 ON f.id1=hs1.id
LEFT JOIN highschooler hs2 ON f.id2=hs2.id
WHERE hs1.grade<>hs2.grade)
ORDER BY hs.grade, hs.name;

7)SELECT DISTINCT hs1.name, hs1.grade, hs2.name, hs2.grade, hs3.name, hs3.grade
FROM highschooler hs1, highschooler hs2, highschooler hs3, Likes l, Friend f1, Friend f2
WHERE (hs1.ID = l.ID1 AND hs2.ID = l.ID2) AND hs2.ID NOT IN (
SELECT ID2
FROM friend
WHERE ID1 = hs1.ID
) AND (hs1.ID = f1.ID1 AND hs3.ID = f1.ID2) AND (hs2.ID = f2.ID1 AND hs3.ID = f2.ID2);

8)SELECT COUNT(hs.id)-COUNT(DISTINCT hs.name) as difference
FROM highschooler hs;

9)SELECT hs.name, hs.grade
FROM highschooler hs
WHERE hs.id in (SELECT id2 FROM likes GROUP BY id2 HAVING COUNT(id2)>1);

SQL Social-Network Query Exercises Extras

1)SELECT hs.name, hs.grade, hs2.name, hs2.grade, hs3.name, hs3.grade
FROM likes l1, likes l2
LEFT JOIN highschooler hs ON l1.id1=hs.id
LEFT JOIN highschooler hs2 ON l1.id2=hs2.id
LEFT JOIN highschooler hs3 ON l2.id2=hs3.id
WHERE (l1.id2=l2.id1) and (l1.id1 != l2.id2);

2)SELECT hs.name, hs.grade
FROM highschooler hs
WHERE hs.id not in (SELECT f.id1
FROM friend f
LEFT JOIN highschooler hs1 ON f.id1=hs1.id
LEFT JOIN highschooler hs2 ON f.id2=hs2.id
WHERE hs1.grade = hs2.grade);

3)SELECT AVG(count)
FROM (
SELECT COUNT(*) AS count
FROM Friend
GROUP BY ID1);

4)SELECT count(id2) 
FROM friend 
WHERE id1 IN (SELECT id2 FROM friend 
			  WHERE id1 IN (SELECT id FROM highschooler
							WHERE name='Cassandra')
			 )
and id1 NOT IN (SELECT id FROM highschooler 
				WHERE name='Cassandra');

5)SELECT hs.name, hs.grade
FROM highschooler hs
WHERE hs.id in (SELECT f1.id1
FROM friend f1
GROUP BY f1.id1
HAVING COUNT(f1.id2) = (SELECT MAX(t.count_) 
						FROM (SELECT COUNT(f.id2) as count_ 
							  FROM friend f GROUP BY f.id1) t
					   )
			  );


SQL Movie-Rating Modification Exercises

1)INSERT INTO Reviewer(rID, name)
VALUES (209, 'Roger Ebert')

2)update movie
set year = year+25
where mid in (select mid 
              from rating 
              group by mid 
              having avg(stars) >=4)
			  
3)delete from rating
where mid in (select mid 
              from movie 
              where year<1970 or year>2000) 
      and stars <4			  


SQL Social-Network Modification Exercises

1)delete from Highschooler
where grade =12

2)delete from likes
where id1 in (select likes.id1 
              from friend join likes using (id1) 
              where friend.id2 = likes.id2) 
      and not id2 in (select likes.id1 
                      from friend join likes using (id1) 
                      where friend.id2 = likes.id2)

3)insert into friend
select f1.id1, f2.id2
from friend f1 join friend f2 on f1.id2 = f2.id1
where f1.id1 <> f2.id2
except
select * from friend



