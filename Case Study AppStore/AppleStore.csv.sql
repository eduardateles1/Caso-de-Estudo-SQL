create table appleStore_description_combined as 

select * from appleStore_description1

union ALL

select * from appleStore_description2

union ALL

select * from appleStore_description3

union ALL

select * from appleStore_description4

--Primeiro passo identificar as partes interessadas 
--verificar o número de aplicativos exclusivos em ambas as tabelasAppStore

select count(DISTINCT id) as uniqueAppIds
FROM AppleStore --7197

SELECT count(DISTINCT id) as UniqueAppIds
from appleStore_description_combined

--verificando se há valores ausentes no campo AppStore
select count(*) as ValoresNulos
from AppleStore
where track_name is null or user_rating is NULL or prime_genre is null --0
 
 select count(*) as ValoresNulos
from appleStore_description_combined
where app_desc is null --0

--Verifique o n° de app por genêro 
select prime_genre, count(*) as numApps
from AppleStore
group by prime_genre
order by numApps desc 

--obter uma visão geral das classificações dos aplicativos 
select min(user_rating) as MinRating,
	   max(user_rating) as MaxRating,
       avg(user_rating) as AvgRating
from AppleStore

--obter a distribuição dos preços dos aplicativos
select 
	(price / 2) * 2 as EntradaDinheiro,
    ((price / 2) *2) as SaidaDinheiro,
    count(*) as NumApps
from AppleStore

group by EntradaDinheiro
order by SaidaDinheiro

--verificar se os apps pagos têm classificações mais altas do que os apps gratuitos
select case 
		when price > 0 then 'Pago'
        else 'Gratuito'
     end as App_Type,
     avg(user_rating) as avg_rating
from AppleStore
group by App_Type

--verifique se apps com mais idiomas suportados têm classificações mais altas
select case 
		when lang_num < 10 then '10 linguas'
        when lang_num BETWEEN 10 and 30 then '10-30 linguas'
        else '+30 linguas'
    end as repositorio_idiomas,
    avg(user_rating) as media_avaliações
 from AppleStore
 group by repositorio_idiomas
 order by media_avaliações desc 
 
 --verificar generos com visualizações baixas 
 select prime_genre ,
 		avg(user_rating) as avg_rating
from AppleStore
group by prime_genre
order by avg_rating
limit 10

--verifique se há correlação entre o comprimento da descrição do aplicativo e a avaliação do usuário
select case 
		when length(b.app_desc) <500 then 'Pequeno'
        when length(a.app_desc) BETWEEN 500 and 1000 then 'Médio'
        else 'Grande'
     end as descrição_Comprimento,
     avg(a.user_rating) as avg_rating
from
	AppleStore as a
join 
	appleStore_description_combined as b 
on 
	a.id = b.id
group by descrição_Comprimento
order by avg_rating desc 
	
--verifique os app mais bem avaliados de cada genero
select 
	prime_genre,
    track_name,
    user_rating
from (
	 select 
     prime_genre,
     track_name,
     user_rating,
     rank() OVER(PARTITION BY prime_genre order by user_rating desc, rating_count_tot desc) as rank
     FROM
     AppleStore
    ) as a 
    where 
    a.rank = 1
    