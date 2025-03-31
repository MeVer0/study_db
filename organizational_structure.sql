CREATE TABLE Departments (
                             DepartmentID SERIAL PRIMARY KEY,  -- Используем SERIAL для автоматической генерации идентификаторов
                             DepartmentName VARCHAR(100) NOT NULL
);

CREATE TABLE Roles (
                       RoleID SERIAL PRIMARY KEY,  -- Используем SERIAL для автоматической генерации идентификаторов
                       RoleName VARCHAR(100) NOT NULL
);

CREATE TABLE Employees (
                           EmployeeID SERIAL PRIMARY KEY,  -- Используем SERIAL для автоматической генерации идентификаторов
                           Name VARCHAR(100) NOT NULL,
                           Position VARCHAR(100),
                           ManagerID INT,
                           DepartmentID INT,
                           RoleID INT,
                           FOREIGN KEY (ManagerID) REFERENCES Employees(EmployeeID) ON DELETE SET NULL,  -- Устанавливаем поведение при удалении
                           FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID) ON DELETE CASCADE,  -- Устанавливаем поведение при удалении
                           FOREIGN KEY (RoleID) REFERENCES Roles(RoleID) ON DELETE SET NULL  -- Устанавливаем поведение при удалении
);

CREATE TABLE Projects (
                          ProjectID SERIAL PRIMARY KEY,  -- Используем SERIAL для автоматической генерации идентификаторов
                          ProjectName VARCHAR(100) NOT NULL,
                          StartDate DATE,
                          EndDate DATE,
                          DepartmentID INT,
                          FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID) ON DELETE CASCADE  -- Устанавливаем поведение при удалении
);

CREATE TABLE Tasks (
                       TaskID SERIAL PRIMARY KEY,  -- Используем SERIAL для автоматической генерации идентификаторов
                       TaskName VARCHAR(100) NOT NULL,
                       AssignedTo INT,
                       ProjectID INT,
                       FOREIGN KEY (AssignedTo) REFERENCES Employees(EmployeeID) ON DELETE SET NULL,  -- Устанавливаем поведение при удалении
                       FOREIGN KEY (ProjectID) REFERENCES Projects(ProjectID) ON DELETE CASCADE  -- Устанавливаем поведение при удалении
);

-- Добавление отделов
INSERT INTO Departments (DepartmentID, DepartmentName) VALUES
                                                           (1, 'Отдел продаж'),
                                                           (2, 'Отдел маркетинга'),
                                                           (3, 'IT-отдел'),
                                                           (4, 'Отдел разработки'),
                                                           (5, 'Отдел поддержки');
-- Добавление ролей
INSERT INTO Roles (RoleID, RoleName) VALUES
                                         (1, 'Менеджер'),
                                         (2, 'Директор'),
                                         (3, 'Генеральный директор'),
                                         (4, 'Разработчик'),
                                         (5, 'Специалист по поддержке'),
                                         (6, 'Маркетолог');
-- Добавление сотрудников
INSERT INTO Employees (EmployeeID, Name, Position, ManagerID, DepartmentID, RoleID) VALUES
                                                                                        (1, 'Иван Иванов', 'Генеральный директор', NULL, 1, 3),
                                                                                        (2, 'Петр Петров', 'Директор по продажам', 1, 1, 2),
                                                                                        (3, 'Светлана Светлова', 'Директор по маркетингу', 1, 2, 2),
                                                                                        (4, 'Алексей Алексеев', 'Менеджер по продажам', 2, 1, 1),
                                                                                        (5, 'Мария Мариева', 'Менеджер по маркетингу', 3, 2, 1),
                                                                                        (6, 'Андрей Андреев', 'Разработчик', 1, 4, 4),
                                                                                        (7, 'Елена Еленова', 'Специалист по поддержке', 1, 5, 5),
                                                                                        (8, 'Олег Олегов', 'Менеджер по продукту', 2, 1, 1),
                                                                                        (9, 'Татьяна Татеева', 'Маркетолог', 3, 2, 6),
                                                                                        (10, 'Николай Николаев', 'Разработчик', 6, 4, 4),
                                                                                        (11, 'Ирина Иринина', 'Разработчик', 6, 4, 4),
                                                                                        (12, 'Сергей Сергеев', 'Специалист по поддержке', 7, 5, 5),
                                                                                        (13, 'Кристина Кристинина', 'Менеджер по продажам', 4, 1, 1),
                                                                                        (14, 'Дмитрий Дмитриев', 'Маркетолог', 3, 2, 6),
                                                                                        (15, 'Виктор Викторов', 'Менеджер по продажам', 4, 1, 1),
                                                                                        (16, 'Анастасия Анастасиева', 'Специалист по поддержке', 7, 5, 5),
                                                                                        (17, 'Максим Максимов', 'Разработчик', 6, 4, 4),
                                                                                        (18, 'Людмила Людмилова', 'Специалист по маркетингу', 3, 2, 6),
                                                                                        (19, 'Наталья Натальева', 'Менеджер по продажам', 4, 1, 1),
                                                                                        (20, 'Александр Александров', 'Менеджер по маркетингу', 3, 2, 1),
                                                                                        (21, 'Галина Галина', 'Специалист по поддержке', 7, 5, 5),
                                                                                        (22, 'Павел Павлов', 'Разработчик', 6, 4, 4),
                                                                                        (23, 'Марина Маринина', 'Специалист по маркетингу', 3, 2, 6),
                                                                                        (24, 'Станислав Станиславов', 'Менеджер по продажам', 4, 1, 1),
                                                                                        (25, 'Екатерина Екатеринина', 'Специалист по поддержке', 7, 5, 5),
                                                                                        (26, 'Денис Денисов', 'Разработчик', 6, 4, 4),
                                                                                        (27, 'Ольга Ольгина', 'Маркетолог', 3, 2, 6),
                                                                                        (28, 'Игорь Игорев', 'Менеджер по продукту', 2, 1, 1),
                                                                                        (29, 'Анастасия Анастасиевна', 'Специалист по поддержке', 7, 5, 5),
                                                                                        (30, 'Валентин Валентинов', 'Разработчик', 6, 4, 4);
-- Добавление проектов
INSERT INTO Projects (ProjectID, ProjectName, StartDate, EndDate, DepartmentID) VALUES
                                                                                    (1, 'Проект A', '2025-01-01', '2025-12-31', 1),
                                                                                    (2, 'Проект B', '2025-02-01', '2025-11-30', 2),
                                                                                    (3, 'Проект C', '2025-03-01', '2025-10-31', 4),
                                                                                    (4, 'Проект D', '2025-04-01', '2025-09-30', 5),
                                                                                    (5, 'Проект E', '2025-05-01', '2025-08-31', 3);
-- Добавление задач
INSERT INTO Tasks (TaskID, TaskName, AssignedTo, ProjectID) VALUES
                                                                (1, 'Задача 1: Подготовка отчета по продажам', 4, 1),
                                                                (2, 'Задача 2: Анализ рынка', 9, 2),
                                                                (3, 'Задача 3: Разработка нового функционала', 10, 3),
                                                                (4, 'Задача 4: Поддержка клиентов', 12, 4),
                                                                (5, 'Задача 5: Создание рекламной кампании', 5, 2),
                                                                (6, 'Задача 6: Обновление документации', 6, 3),
                                                                (7, 'Задача 7: Проведение тренинга для сотрудников', 8, 1),
                                                                (8, 'Задача 8: Тестирование нового продукта', 11, 3),
                                                                (9, 'Задача 9: Ответы на запросы клиентов', 12, 4),
                                                                (10, 'Задача 10: Подготовка маркетинговых материалов', 9, 2),
                                                                (11, 'Задача 11: Интеграция с новым API', 10, 3),
                                                                (12, 'Задача 12: Настройка системы поддержки', 7, 5),
                                                                (13, 'Задача 13: Проведение анализа конкурентов', 9, 2),
                                                                (14, 'Задача 14: Создание презентации для клиентов', 4, 1),
                                                                (15, 'Задача 15: Обновление сайта', 6, 3);

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