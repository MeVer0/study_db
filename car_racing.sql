
-- Создание таблицы Classes
CREATE TABLE Classes (
                         class VARCHAR(100) NOT NULL,
                         type VARCHAR(20) NOT NULL CHECK (type IN ('Racing', 'Street')), -- тип класса
                         country VARCHAR(100) NOT NULL,
                         numDoors INT NOT NULL,
                         engineSize DECIMAL(3, 1) NOT NULL, -- размер двигателя в литрах
                         weight INT NOT NULL,            	-- вес автомобиля в килограммах
                         PRIMARY KEY (class)
);

-- Создание таблицы Cars
CREATE TABLE Cars (
                      name VARCHAR(100) NOT NULL,
                      class VARCHAR(100) NOT NULL,
                      year INT NOT NULL,
                      PRIMARY KEY (name),
                      FOREIGN KEY (class) REFERENCES Classes(class)
);

-- Создание таблицы Races
CREATE TABLE Races (
                       name VARCHAR(100) NOT NULL,
                       date DATE NOT NULL,
                       PRIMARY KEY (name)
);

-- Создание таблицы Results
CREATE TABLE Results (
                         car VARCHAR(100) NOT NULL,
                         race VARCHAR(100) NOT NULL,
                         position INT NOT NULL,
                         PRIMARY KEY (car, race),
                         FOREIGN KEY (car) REFERENCES Cars(name),
                         FOREIGN KEY (race) REFERENCES Races(name)
);

-- Вставка данных в таблицу Classes
INSERT INTO Classes (class, type, country, numDoors, engineSize, weight) VALUES
                                                                             ('SportsCar', 'Racing', 'USA', 2, 3.5, 1500),
                                                                             ('Sedan', 'Street', 'Germany', 4, 2.0, 1200),
                                                                             ('SUV', 'Street', 'Japan', 4, 2.5, 1800),
                                                                             ('Hatchback', 'Street', 'France', 5, 1.6, 1100),
                                                                             ('Convertible', 'Racing', 'Italy', 2, 3.0, 1300),
                                                                             ('Coupe', 'Street', 'USA', 2, 2.5, 1400),
                                                                             ('Luxury Sedan', 'Street', 'Germany', 4, 3.0, 1600),
                                                                             ('Pickup', 'Street', 'USA', 2, 2.8, 2000);
-- Вставка данных в таблицу Cars
INSERT INTO Cars (name, class, year) VALUES
                                         ('Ford Mustang', 'SportsCar', 2020),
                                         ('BMW 3 Series', 'Sedan', 2019),
                                         ('Toyota RAV4', 'SUV', 2021),
                                         ('Renault Clio', 'Hatchback', 2020),
                                         ('Ferrari 488', 'Convertible', 2019),
                                         ('Chevrolet Camaro', 'Coupe', 2021),
                                         ('Mercedes-Benz S-Class', 'Luxury Sedan', 2022),
                                         ('Ford F-150', 'Pickup', 2021),
                                         ('Audi A4', 'Sedan', 2018),
                                         ('Nissan Rogue', 'SUV', 2020);
-- Вставка данных в таблицу Races
INSERT INTO Races (name, date) VALUES
                                   ('Indy 500', '2023-05-28'),
                                   ('Le Mans', '2023-06-10'),
                                   ('Monaco Grand Prix', '2023-05-28'),
                                   ('Daytona 500', '2023-02-19'),
                                   ('Spa 24 Hours', '2023-07-29'),
                                   ('Bathurst 1000', '2023-10-08'),
                                   ('Nürburgring 24 Hours', '2023-06-17'),
                                   ('Pikes Peak International Hill Climb', '2023-06-25');
-- Вставка данных в таблицу Results
INSERT INTO Results (car, race, position) VALUES
                                              ('Ford Mustang', 'Indy 500', 1),
                                              ('BMW 3 Series', 'Le Mans', 3),
                                              ('Toyota RAV4', 'Monaco Grand Prix', 2),
                                              ('Renault Clio', 'Daytona 500', 5),
                                              ('Ferrari 488', 'Le Mans', 1),
                                              ('Chevrolet Camaro', 'Monaco Grand Prix', 4),
                                              ('Mercedes-Benz S-Class', 'Spa 24 Hours', 2),
                                              ('Ford F-150', 'Bathurst 1000', 6),
                                              ('Audi A4', 'Nürburgring 24 Hours', 8),
                                              ('Nissan Rogue', 'Pikes Peak International Hill Climb', 3);



--Определить, какие автомобили из каждого класса имеют наименьшую среднюю позицию в гонках, и
-- вывести информацию о каждом таком автомобиле для данного класса, включая его класс,
-- среднюю позицию и количество гонок, в которых он участвовал.
-- Также отсортировать результаты по средней позиции.
select c.name car_name, c.class car_class, avg(r.position) average_position, count(c.name) race_count
    from
        cars c
join results r on c.name = r.car
group by c.name, c.class
order by average_position, car_class;


--Определить автомобиль, который имеет наименьшую среднюю позицию в гонках среди всех автомобилей,
-- и вывести информацию об этом автомобиле, включая его класс, среднюю позицию, количество гонок,
-- в которых он участвовал, и страну производства класса автомобиля. Если несколько автомобилей
-- имеют одинаковую наименьшую среднюю позицию, выбрать один из них по алфавиту (по имени автомобиля).
select c.name car_name, c.class car_class, avg(r.position) average_position, count(c.name) race_count, c_inf.country
from
    cars c
        join results r on c.name = r.car
join classes c_inf on c.class = c_inf.class
group by c.name, c.class, c_inf.country
order by average_position, car_class
limit 1;


--Определить классы автомобилей, которые имеют наименьшую среднюю позицию в гонках, и вывести информацию
-- о каждом автомобиле из этих классов, включая его имя, среднюю позицию, количество гонок, в которых он
-- участвовал, страну производства класса автомобиля, а также общее количество гонок, в которых участвовали
-- автомобили этих классов. Если несколько классов имеют одинаковую среднюю позицию, выбрать все из них.
with RankedClasses as (
    select c_int.class,
           avg(r.position) avg_pos,
           count(r.car) races_count,
           rank() over (order by avg(r.position)) rank
    from classes c_int
             join cars c on c_int.class = c.class
             join results r on c.name = r.car
    group by c_int.class
),
     ClassTotalRaces as (
         select count(*) total_races,
                rc.class
         from
             cars
                 join results on cars.name = results.car
                 join races on results.race = races.name
                 join RankedClasses rc on cars.class = rc.class
         group by rc.class
     )
select
    c.name,
    rc.class,
    rc.avg_pos,
    rc.races_count,
    c_inf.country,
    ctr.total_races
from
    RankedClasses rc
        join ClassTotalRaces ctr on ctr.class = rc.class
        join cars c on rc.class = c.class
        join classes c_inf on c.class = c_inf.class
where rc.rank = 1;


--Определить, какие автомобили имеют среднюю позицию лучше (меньше) средней позиции
-- всех автомобилей в своем классе (то есть автомобилей в классе должно быть минимум два,
-- чтобы выбрать один из них). Вывести информацию об этих автомобилях, включая их имя,
-- класс, среднюю позицию, количество гонок, в которых они участвовали, и страну производства
-- класса автомобиля. Также отсортировать результаты по классу и затем по средней позиции
-- в порядке возрастания.
select qs.name cars_name,
       qs.class car_class,
       qs.average_position,
       qs.race_count,
       c.country
    from (
             select cars.name,
                    classes.class,
                    avg(results.position) average_position,
                    count(results.*) race_count,
                    rank() over (partition by cars.class order by avg(results.position)) rank,
                    count(cars.name) over (partition by cars.class)                      cars_into_class
             from classes
                      join cars on classes.class = cars.class
                      join results on cars.name = results.car
             group by cars.name, classes.class
         ) qs
    join classes c on qs.class = c.class
where qs.rank = 1 and qs.cars_into_class > 1;



---Определить, какие классы автомобилей имеют наибольшее количество автомобилей с низкой средней
-- позицией (больше 3.0) и вывести информацию о каждом автомобиле из этих классов, включая его имя,
-- класс, среднюю позицию, количество гонок, в которых он участвовал, страну производства класса
-- автомобиля, а также общее количество гонок для каждого класса. Отсортировать результаты по количеству
-- автомобилей с низкой средней позицией.
with carsAvgResult as (select cars.name car_name,
                              cars.class car_class,
                              avg(results.position) average_position,
                              count(results.*) race_count
                       from classes
                                join cars on classes.class = cars.class
                                join results on cars.name = results.car
                       group by cars.name, cars.class
                       having avg(results.position) > 3),
totalClassRacesCount as (
    select
        carsAvgResult.car_class,
        count(races.*) total_races
    from races
        join results on races.name = results.race
    join cars on results.car = cars.name
    join carsAvgResult on carsAvgResult.car_class = cars.class
    group by carsAvgResult.car_class
)
    select
        carsAvgResult.car_name,
        carsAvgResult.car_class,
        carsAvgResult.average_position,
        carsAvgResult.race_count,
        classes.country,
        totalClassRacesCount.total_races

from
classes
join carsAvgResult on carsAvgResult.car_class = classes.class
join totalClassRacesCount on totalClassRacesCount.car_class = carsAvgResult.car_class;
