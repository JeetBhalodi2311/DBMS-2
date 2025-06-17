select * from Artists
select * from Albums
select * from Songs

--1
select distinct genre from Songs

--2
select top 2 * from Albums
where Release_year<2010

--3
insert into songs values (1245,'Zaroor',2.55,'Fell Good',1005)

--4
update songs
set genre = 'Happy'
where Song_title = 'zaroor'

--5
delete Artists where Artist_name = 'Ed Sheeran'

--6
alter table songs
add  Rating decimal(3,2)

--7
select * from Songs
where Song_title like 's%'

--8
select * from Songs
where Song_title like '%everybody%'

--9
select upper(Artist_name) from Artists

--10
select sqrt(Duration) from Songs
where Song_title = 'Good Luck'

--11
select getdate()

--12
select Artists.Artist_name , count(Albums.Album_id)
from Artists join Albums
on Artists.Artist_id = Albums.Artist_id
group by Artists.Artist_name

--13
select Albums.Album_id 
from Albums join Songs
on Albums.Album_id = songs.Album_id
group by Albums.Album_id
having count(songs.Song_id) > 5

--14
select songs.Song_title 
from songs join Albums
on Albums.Album_id = songs.Album_id
where Albums.Album_title='Album1'

--using subquerry
select song_title
from songs
where Album_id = (select Album_id from Albums where Album_title='album1')

--15
select album_title 
from Albums
where Artist_id = (select Artist_id from Artists where Artist_name='Aparshakti Khurana')

--16
select songs.Song_title, Albums.Album_title
from Albums join Songs
on Albums.Album_id = Songs.Album_id

--17
select songs.Song_title
from Albums join Songs
on Albums.Album_id = Songs.Album_id
where Albums.Release_year = 2020

--18
create view Fav_Songs 
as
select * from Songs
where Song_id in(101,102,103,104,105)

select * from Fav_songs

--19
update Fav_Songs
set Song_title = 'Jannat'
where Song_id = 101

--20
select Artists.Artist_name
from Artists join Albums
on Artists.Artist_id = Albums.Artist_id
where Albums.Release_year = 2020

--21
SELECT SONGS.Song_title,Songs.Duration
from Songs join Albums
on Albums.Album_id = Songs.Album_id
join Artists
on Artists.Artist_id = Albums.Artist_id
where Artists.Artist_name = 'Shreya Ghoshal'
order by Songs.Duration


--PART-B

--22
select Songs.Song_title
from Artists join Albums
on Artists.Artist_id = Albums.Artist_id
join Songs
on Albums.Album_id = Songs.Album_id
where Artists.Artist_id in(select Artists.Artist_id from Albums group by Artist_id having COUNT(Album_id)>1)

--23
select Albums.Album_title , COUNT(songs.Song_id) as SongCount
from Albums join songs
on Albums.Album_id = Songs.Album_id
group  by Songs.Album_id,Albums.Album_title

--24
select songs.Song_title,Albums.Release_year
from Albums join songs
on Albums.Album_id = Songs.Album_id
order by Albums.Release_year

--25
select COUNT(Songs.Song_id),Songs.Genre
from Albums join songs
on Albums.Album_id = Songs.Album_id
group by Songs.Genre
having COUNT(songs.Song_id)>2

--26
select Artists.Artist_name
from Artists join Albums
on Artists.Artist_id = Albums.Artist_id
join Songs
on Albums.Album_id = Songs.Album_id
group by Artists.Artist_name
having count(Songs.Song_id)>3

--PART-c

--27
select Album_title
from Albums
where Release_year = (select Release_year from Albums where Album_title='Album4')

--28
select max(duration) as maxDURATION,Genre
from songs
group by Genre

--29
select Songs.Song_title,Albums.Album_title
from songs join Albums
on Albums.Album_id = Songs.Album_id
where Albums.Album_title like '%album%'

--30
SELECT sum(songs.Duration),Artists.Artist_name
from Artists join Albums
on Artists.Artist_id = Albums.Artist_id
join songs
on Albums.Album_id = Songs.Album_id
group by Artists.Artist_name
having sum(Duration)>15
