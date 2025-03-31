# 🚀 Проект: Работа с базой данных транспортных средств

Этот проект демонстрирует работу с SQL-запросами для анализа данных о транспортных средствах, бронирования отелей, организационной структуры предприятия.

## 📁 Содержание

- `vehicles.sql` — SQL-запросы для работы с базой "Транспортные средства"
- `car_racing.sql` — SQL-запросы для работы с базой "Автомобильные гонки"
- `organizational_structure.sql` — SQL-запросы для работы с базой "Бронирование отелей"
- `hotel_booking.sql` — SQL-запросы для работы с базой "Структура организации"

## 🧰 Установка и запуск

1. **Создание базы данных**  
   Подключитесь к своей базе данных PostgreSQL (или другой СУБД) и создайте таблицы, используя SQL-запросы из файлов.

2. **Импорт и анализ данных**  
   Выполните запросы в вашей SQL-консоли для получения нужной аналитики.

## 🧾 SQL-запросы

Ниже приведены SQL-запросы, которые было необходимо выполнить в рамках задания. Они разделены по базам данных


### База данных 1. Транспортные средства
```sql
---Найдите производителей (maker) и модели всех мотоциклов,
-- которые имеют мощность более 150 лошадиных сил, стоят менее
-- 20 тысяч долларов и являются спортивными (тип Sport).
-- Также отсортируйте результаты по мощности в порядке убывания.
select v.maker, v.model
from
    motorcycle m
        join vehicle v on m.model = v.model
        and m.type = 'Sport'
        and m.horsepower > 150
        and m.price < 20000;


---Найти информацию о производителях и моделях различных типов
-- транспортных средств (автомобили, мотоциклы и велосипеды),
-- которые соответствуют заданным критериям.
select * from
(select
    v.maker, v.model, c.horsepower, c.engine_capacity, v.type
    from
        vehicle v
join car c on v.model = c.model
            and c.horsepower > 150
            and c.engine_capacity < 3
            and c.price <35000

union

select
    v.maker, v.model, m.horsepower, m.engine_capacity, v.type
from
    vehicle v
join motorcycle m on v.model = m.model
            and m.horsepower > 150
            and m.engine_capacity < 1.5
            and m.price <20000

union

select
    v.maker, v.model, null, null, v.type
from
    vehicle v
join bicycle b on v.model = b.model
            and b.gear_count > 18
            and b.price < 4000
    ) as qs
order by qs.horsepower desc NULLS LAST
```

### База данных 2 . Автомобильные гонки
```sql
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
```

### База данных 3. Бронирование отелей
```sql
--Определить, какие клиенты сделали более двух бронирований в разных отелях, и вывести информацию
-- о каждом таком клиенте, включая его имя, электронную почту, телефон, общее количество бронирований,
-- а также список отелей, в которых они бронировали номера (объединенные в одно поле через запятую с помощью CONCAT).
-- Также подсчитать среднюю длительность их пребывания (в днях) по всем бронированиям.
-- Отсортировать результаты по количеству бронирований в порядке убывания.
SELECT
    c.name,
    c.email,
    c.phone,
    COUNT(b.ID_booking) AS total_bookings,
    STRING_AGG(DISTINCT h.name, ', ') AS hotel_list,
    ROUND(AVG(b.check_out_date - b.check_in_date), 4) AS avg_stay_duration
FROM Booking b
         JOIN Customer c ON b.ID_customer = c.ID_customer
         JOIN Room r ON b.ID_room = r.ID_room
         JOIN Hotel h ON r.ID_hotel = h.ID_hotel
GROUP BY c.ID_customer
HAVING COUNT(DISTINCT h.ID_hotel) > 1  AND COUNT(b.ID_booking) >= 3
ORDER BY total_bookings DESC;


--Необходимо провести анализ клиентов, которые сделали более двух бронирований в разных отелях и потратили
-- более 500 долларов на свои бронирования. Для этого:
-- 1. Определить клиентов, которые сделали более двух бронирований и забронировали номера в более чем одном отеле.
-- Вывести для каждого такого клиента следующие данные: ID_customer, имя, общее количество бронирований,
-- общее количество уникальных отелей, в которых они бронировали номера, и общую сумму, потраченную на бронирования.

-- 2. Также определить клиентов, которые потратили более 500 долларов на бронирования,
-- и вывести для них ID_customer, имя, общую сумму, потраченную на бронирования, и общее количество бронирований.

-- 3. В результате объединить данные из первых двух пунктов, чтобы получить список клиентов,
-- которые соответствуют условиям обоих запросов. Отобразить поля: ID_customer, имя, общее количество бронирований,
-- общую сумму, потраченную на бронирования, и общее количество уникальных отелей.
-- Результаты отсортировать по общей сумме, потраченной клиентами, в порядке возрастания.
WITH ClientBookings AS (
    SELECT
        c.ID_customer,
        c.name,
        COUNT(b.ID_booking) AS total_bookings,
        COUNT(DISTINCT h.ID_hotel) AS unique_hotels,
        SUM(r.price) AS total_spent
    FROM Booking b
             JOIN Customer c ON b.ID_customer = c.ID_customer
             JOIN Room r ON b.ID_room = r.ID_room
             JOIN Hotel h ON r.ID_hotel = h.ID_hotel
    GROUP BY c.ID_customer, c.name
    HAVING COUNT(b.ID_booking) > 2 AND COUNT(DISTINCT h.ID_hotel) > 1
),
     ClientSpentMoreThan500 AS (
         SELECT
             c.ID_customer,
             c.name,
             SUM(r.price) AS total_spent,
             COUNT(b.ID_booking) AS total_bookings
         FROM Booking b
                  JOIN Customer c ON b.ID_customer = c.ID_customer
                  JOIN Room r ON b.ID_room = r.ID_room
         GROUP BY c.ID_customer, c.name
         HAVING SUM(r.price) > 500
     )

SELECT
    cb.ID_customer,
    cb.name,
    cb.total_bookings,
    cb.total_spent,
    cb.unique_hotels
FROM ClientBookings cb
         JOIN ClientSpentMoreThan500 csm ON cb.ID_customer = csm.ID_customer
ORDER BY cb.total_spent;


--Вам необходимо провести анализ данных о бронированиях в отелях и определить предпочтения клиентов по типу отелей. Для этого выполните следующие шаги:

-- Категоризация отелей.
-- Определите категорию каждого отеля на основе средней стоимости номера:
--
-- «Дешевый»: средняя стоимость менее 175 долларов.
-- «Средний»: средняя стоимость от 175 до 300 долларов.
-- «Дорогой»: средняя стоимость более 300 долларов.
-- Анализ предпочтений клиентов.
-- Для каждого клиента определите предпочитаемый тип отеля на основании условия ниже:
--
-- Если у клиента есть хотя бы один «дорогой» отель, присвойте ему категорию «дорогой».
-- Если у клиента нет «дорогих» отелей, но есть хотя бы один «средний», присвойте ему категорию «средний».
-- Если у клиента нет «дорогих» и «средних» отелей, но есть «дешевые», присвойте ему категорию предпочитаемых отелей «дешевый».
-- Вывод информации.
-- Выведите для каждого клиента следующую информацию:
--
-- ID_customer: уникальный идентификатор клиента.
-- name: имя клиента.
-- preferred_hotel_type: предпочитаемый тип отеля.
-- visited_hotels: список уникальных отелей, которые посетил клиент.
-- Сортировка результатов.
-- Отсортируйте клиентов так, чтобы сначала шли клиенты с «дешевыми» отелями, затем со «средними» и в конце — с «дорогими».
WITH HotelCategories AS (
    SELECT
        h.ID_hotel,
        CASE
            WHEN AVG(r.price) < 175 THEN 'Дешевый'
            WHEN AVG(r.price) BETWEEN 175 AND 300 THEN 'Средний'
            WHEN AVG(r.price) > 300 THEN 'Дорогой'
            END AS hotel_category
    FROM Hotel h
             JOIN Room r ON h.ID_hotel = r.ID_hotel
    GROUP BY h.ID_hotel
),
     CustomerPreferences AS (
         SELECT
             b.ID_customer,
             MAX(CASE
                     WHEN hc.hotel_category = 'Дорогой' THEN 'Дорогой'
                     WHEN hc.hotel_category = 'Средний' THEN 'Средний'
                     WHEN hc.hotel_category = 'Дешевый' THEN 'Дешевый'
                     ELSE NULL
                 END) AS preferred_hotel_type,
             STRING_AGG(DISTINCT h.name, ', ') AS visited_hotels
         FROM Booking b
                  JOIN Room r ON b.ID_room = r.ID_room
                  JOIN Hotel h ON r.ID_hotel = h.ID_hotel
                  JOIN HotelCategories hc ON h.ID_hotel = hc.ID_hotel
         GROUP BY b.ID_customer
     )

SELECT
    cp.ID_customer,
    c.name,
    cp.preferred_hotel_type,
    cp.visited_hotels
FROM CustomerPreferences cp
         JOIN Customer c ON cp.ID_customer = c.ID_customer
ORDER BY
    CASE cp.preferred_hotel_type
        WHEN 'Дешевый' THEN 1
        WHEN 'Средний' THEN 2
        WHEN 'Дорогой' THEN 3
        END;
```

### База данных 4. Структура организации
```sql
-- Задача 1
-- Условие
--
-- Найти всех сотрудников, подчиняющихся Ивану Иванову (с EmployeeID = 1), включая их подчиненных и подчиненных подчиненных.
-- Для каждого сотрудника вывести следующую информацию:
--
-- EmployeeID: идентификатор сотрудника.
-- Имя сотрудника.
-- ManagerID: Идентификатор менеджера.
-- Название отдела, к которому он принадлежит.
-- Название роли, которую он занимает.
-- Название проектов, к которым он относится (если есть, конкатенированные в одном столбце через запятую).
-- Название задач, назначенных этому сотруднику (если есть, конкатенированные в одном столбце через запятую).
-- Если у сотрудника нет назначенных проектов или задач, отобразить NULL.
-- Требования:
--
-- Рекурсивно извлечь всех подчиненных сотрудников Ивана Иванова и их подчиненных.
-- Для каждого сотрудника отобразить информацию из всех таблиц.
-- Результаты должны быть отсортированы по имени сотрудника.
-- Решение задачи должно представлять из себя один sql-запрос и задействовать ключевое слово RECURSIVE.

WITH RECURSIVE subordinates AS (
    SELECT
        EmployeeID,
        Name,
        ManagerID,
        DepartmentID,
        RoleID
    FROM
        Employees
    WHERE
        ManagerID = 1
    UNION ALL
    SELECT
        e.EmployeeID,
        e.Name,
        e.ManagerID,
        e.DepartmentID,
        e.RoleID
    FROM
        Employees e
    JOIN subordinates s ON e.ManagerID = s.EmployeeID
)
SELECT
    s.EmployeeID,
    s.Name,
    s.ManagerID,
    d.DepartmentName AS Department,
    r.RoleName AS Role,
    (SELECT
        STRING_AGG(p.ProjectName, ', ')
    FROM projects p
        WHERE p.DepartmentID = s.DepartmentID
    ) projects,
    (
     SELECT STRING_AGG(t.TaskName, ', ')
        FROM Tasks t
     WHERE t.AssignedTo = s.EmployeeID
    ) tasks
FROM
    Subordinates s
        JOIN Departments d ON s.DepartmentID = d.DepartmentID
        JOIN Roles r ON s.RoleID = r.RoleID
ORDER BY s.Name;


-- Задача 2
-- Условие
--
-- Найти всех сотрудников, подчиняющихся Ивану Иванову с EmployeeID = 1, включая их подчиненных и подчиненных подчиненных.
-- Для каждого сотрудника вывести следующую информацию:
--
-- EmployeeID: идентификатор сотрудника.
-- Имя сотрудника.
-- Идентификатор менеджера.
-- Название отдела, к которому он принадлежит.
-- Название роли, которую он занимает.
-- Название проектов, к которым он относится (если есть, конкатенированные в одном столбце).
-- Название задач, назначенных этому сотруднику (если есть, конкатенированные в одном столбце).
-- Общее количество задач, назначенных этому сотруднику.
-- Общее количество подчиненных у каждого сотрудника (не включая подчиненных их подчиненных).
-- Если у сотрудника нет назначенных проектов или задач, отобразить NULL.
WITH RECURSIVE Subordinates AS (
    SELECT EmployeeID, ManagerID, Name, DepartmentID, RoleID
    FROM Employees
    WHERE ManagerID = 1

    UNION ALL

    SELECT e.EmployeeID,
           e.ManagerID,
           e.Name,
           e.DepartmentID,
           e.RoleID
    FROM Employees e
             INNER JOIN Subordinates s ON e.ManagerID = s.EmployeeID
),
               SubordinateCount AS (
                   SELECT ManagerID, COUNT(*) as DirectSubordinates
                   FROM Employees
                   WHERE ManagerID IS NOT NULL
                   GROUP BY ManagerID
               ),
               ProjectAggregation AS (
                   SELECT
                       e.EmployeeID,
                       STRING_AGG(p.ProjectName, ', ') as Projects
                   FROM Subordinates e
                            LEFT JOIN Tasks t ON e.EmployeeID = t.AssignedTo
                            LEFT JOIN Projects p ON t.ProjectID = p.ProjectID
                   GROUP BY e.EmployeeID
               ),
               TaskAggregation AS (
                   SELECT
                       e.EmployeeID,
                       STRING_AGG(t.TaskName, ', ') as Tasks,
                       COUNT(t.TaskID) as TaskCount
                   FROM Subordinates e
                            LEFT JOIN Tasks t ON e.EmployeeID = t.AssignedTo
                   GROUP BY e.EmployeeID
               )
SELECT
    s.EmployeeID,
    s.Name EmployeeName,
    s.ManagerID,
    d.DepartmentName,
    r.RoleName,
    NULLIF(pa.Projects, ''),
    NULLIF(ta.Tasks, ''),
    ta.TaskCount,
    COALESCE(sc.DirectSubordinates, 0)
FROM Subordinates s
         LEFT JOIN Departments d ON s.DepartmentID = d.DepartmentID
         LEFT JOIN Roles r ON s.RoleID = r.RoleID
         LEFT JOIN ProjectAggregation pa ON s.EmployeeID = pa.EmployeeID
         LEFT JOIN TaskAggregation ta ON s.EmployeeID = ta.EmployeeID
         LEFT JOIN SubordinateCount sc ON s.EmployeeID = sc.ManagerID
ORDER BY EmployeeName;


-- Задача 3
-- Условие
--
-- Найти всех сотрудников, которые занимают роль менеджера и имеют подчиненных (то есть число подчиненных больше 0).
-- Для каждого такого сотрудника вывести следующую информацию:
--
-- EmployeeID: идентификатор сотрудника.
-- Имя сотрудника.
-- Идентификатор менеджера.
-- Название отдела, к которому он принадлежит.
-- Название роли, которую он занимает.
-- Название проектов, к которым он относится (если есть, конкатенированные в одном столбце).
-- Название задач, назначенных этому сотруднику (если есть, конкатенированные в одном столбце).
-- Общее количество подчиненных у каждого сотрудника (включая их подчиненных).
-- Если у сотрудника нет назначенных проектов или задач, отобразить NULL.
WITH RECURSIVE Subordinates AS (
    SELECT EmployeeID, ManagerID
    FROM Employees
    WHERE ManagerID IS NOT NULL

    UNION ALL

    SELECT e.EmployeeID, s.ManagerID
    FROM Employees e
             INNER JOIN Subordinates s ON e.ManagerID = s.EmployeeID
),
               SubordinateCount AS (
                   SELECT
                       ManagerID,
                       COUNT(DISTINCT EmployeeID) as TotalSubordinates
                   FROM Subordinates
                   GROUP BY ManagerID
               ),
               ProjectAggregation AS (
                   SELECT
                       e.EmployeeID,
                       STRING_AGG(p.ProjectName, ', ') as Projects
                   FROM Employees e
                            LEFT JOIN Tasks t ON e.EmployeeID = t.AssignedTo
                            LEFT JOIN Projects p ON t.ProjectID = p.ProjectID
                   GROUP BY e.EmployeeID
               ),
               TaskAggregation AS (
                   SELECT
                       e.EmployeeID,
                       STRING_AGG(t.TaskName, ', ') as Tasks
                   FROM Employees e
                            LEFT JOIN Tasks t ON e.EmployeeID = t.AssignedTo
                   GROUP BY e.EmployeeID
               )

SELECT
    e.EmployeeID,
    e.Name EmployeeName,
    e.ManagerID,
    d.DepartmentName,
    r.RoleName,
    NULLIF(pa.Projects, ''),
    NULLIF(ta.Tasks, ''),
    sc.TotalSubordinates
FROM Employees e
         JOIN Roles r ON e.RoleID = r.RoleID
         JOIN Departments d ON e.DepartmentID = d.DepartmentID
         JOIN SubordinateCount sc ON e.EmployeeID = sc.ManagerID
         LEFT JOIN ProjectAggregation pa ON e.EmployeeID = pa.EmployeeID
         LEFT JOIN TaskAggregation ta ON e.EmployeeID = ta.EmployeeID
WHERE r.RoleName ILIKE '%менеджер%'
ORDER BY EmployeeName;
```
