drop database twitter_db;

CREATE DATABASE twitter_db;

USE twitter_db;

CREATE TABLE users (
	user_id INT NOT NULL AUTO_INCREMENT,
    user_handle VARCHAR(50) NULL UNIQUE, 
    email_address VARCHAR(50) NOT NULL UNIQUE,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    phonenumber CHAR(10) UNIQUE,
    create_at TIMESTAMP NOT NULL DEFAULT (now()),
    PRIMARY KEY(user_id)
);

INSERT INTO users(user_handle, email_address, first_name, last_name, phonenumber)
VALUES
('alexxedev', 'alexxe@example.com', 'alexxe', 'dev', '66666666'),
('nuwa', 'nuwa@example.com', 'nuwa', 'fmax', '77777777'),
('jsmith', 'jsmith@example.com', 'John', 'Smith', '1234567890'),
('mjane', 'mjane@example.com', 'Mary', 'Jane', '9876543210'),
('rwilson', 'rwilson@example.com', 'Robert', 'Wilson', '5555555555'),
('linda', 'linda@example.com', 'Linda', 'Anderson', '4444444444'),
('mikedavis', 'mikedavis@example.com', 'Michael', 'Davis', '7777777777'),
('sarahw', 'sarahw@example.com', 'Sarah', 'Wilson', '6666666666'),
('davidm', 'davidm@example.com', 'David', 'Miller', '8888888888'),
('jennifer', 'jennifer@example.com', 'Jennifer', 'Garcia', '3333333333') ,
('wmartinez', 'wmartinez@example.com', 'William', 'Martinez', '9999999999'),
('kareng', 'kareng@example.com', 'Karen', 'Garcia', '1010101010');

DROP TABLE IF EXISTS followers;

CREATE TABLE followers(
	followers_id INT NOT NULL,
    following_id INT NOT NULL,
    FOREIGN KEY(followers_id) REFERENCES users(user_id),
    FOREIGN KEY(following_id) REFERENCES users(user_id),
    PRIMARY KEY(followers_id, following_id)
);

INSERT INTO followers(followers_id, following_id)
VALUES
(1,2),
(2,3),
(4,2),
(1,6),
(6,2),
(5,1),
(7,6),
(8,3);

-- Restricciones
ALTER TABLE followers
ADD CONSTRAINT check_followers_id
CHECK (followers_id <> following_id);

-- CONSULTAS BASICAS
-- consultas usuarios con mas seguidores

select following_id, COUNT(followers_id) AS followers
from followers
group by following_id
order by followers Desc
limit 3;

-- CONSULTAS CON JOIN
select following_id, users.user_handle, users.first_name, following_id, COUNT(followers_id) AS followers
from followers
JOIN users ON users.user_id = followers.following_id
group by following_id
order by followers Desc
limit 3;

CREATE TABLE tweets(
tweet_id INT NOT NULL auto_increment,
user_id INT NOT NULL,
tweet_text varchar(280) NOT NULL,
num_likes INT default 0,
num_retweets INT DEFAULT 0,
num_comments INT default 0,
created_at timestamp not null default (now()),
foreign key (user_id) references users(user_id),
primary key(tweet_id)
);

INSERT INTO tweets (user_id, tweet_text) VALUES
(1, '¡Hola a todos! Este es mi primer tweet. 😃👋'),
(2, 'Disfrutando de un hermoso día soleado. ☀️😎'),
(3, 'Compartiendo mi receta favorita de pasta. 🍝❤️'),
(4, '¡Segunda vez escribiendo un tweet! 😅📝'),
(2, 'Acabo de ver la última película de ciencia ficción. 🎬👽'),
(5, 'Feliz de compartir noticias emocionantes. 🎉📰'),
(1, 'Cena deliciosa con amigos esta noche. 🍽️👫'),
(6, 'Viajando a un lugar exótico este fin de semana. ✈️🌴'),
(3, 'Mis pensamientos y oraciones están con todos. 🙏❤️'),
(7, 'Nuevo proyecto en marcha. ¡Emocionado! 💼💪'),
(4, 'Celebrando mi cumpleaños hoy. 🎂🥳'),
(8, 'Saliendo de vacaciones pronto. 🌄✈️'),
(1, 'Mi mascota acaba de hacer algo adorable. 🐶😍'),
(9, 'Haciendo ejercicio en el gimnasio. 💪🏋️‍♀️'),
(5, 'Viendo un espectáculo en vivo esta noche. 🎶🎤');

-- ¿Cuantos tweets ha hecho un usuario?
SELECT user_id, COUNT(*) AS tweet_count
FROM tweets 
group by user_id;

-- sub consulta
-- obtener los tweets de los usuarios que tienen mas de 2 seguidores
SELECT tweet_id, tweet_text, user_id
from tweets
where user_id in (
select following_id
from followers
group by following_id
having count(*) > 2
);


-- delete
SET SQL_SAFE_UPDATES = 0;

DELETE FROM tweets where tweet_id = 1;
delete from tweets where user_id = 1;
delete from tweets where tweet_text LIKE '%Hola a todos! Este es mi primer tweet%';

 -- UPDATE
 UPDATE tweets SET num_comments = num_comments + 1 where tweet_id = 2; 
 
 -- REEMPLAZAR TEXTO
 UPDATE tweets SET tweet_text = replace(tweet_text, 'adorable', 'malo')
 where tweet_text LIKE '%adorable%';


-- tabla de likes
CREATE TABLE tweet_likes(
user_id INT NOT NULL,
tweet_id INT NOT NULL,
foreign key (user_id) references users(user_id),
foreign key (tweet_id) references tweets(tweet_id),
primary key (user_id, tweet_id)
);

INSERT INTO tweet_likes (user_id, tweet_id) VALUES
(1, 1),
(2, 3),
(3, 5),
(4, 2),
(5, 7),
(6, 9),
(7, 4),
(8, 6),
(9, 8),
(10, 10);


-- obtener el numero de likes para cada tuit

select tweet_id, COUNT(*) AS like_count
from tweet_likes
group by tweet_id;

  


 
 
