CREATE DATABASE studentElection;
USE studentElection;
-- 1. Users Table
CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,             
    username VARCHAR(50) NOT NULL UNIQUE,              
    password_hash VARCHAR(255) NOT NULL,               
    full_name VARCHAR(100) NOT NULL,                   
    email VARCHAR(100) NOT NULL UNIQUE,                
    role ENUM('student', 'lecturer', 'admin') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP     
);

-- 2. Faculties Table
CREATE TABLE Faculties (
    faculty_id INT AUTO_INCREMENT PRIMARY KEY,         
    faculty_name VARCHAR(100) NOT NULL UNIQUE          
);

-- 3. Programs Table
CREATE TABLE Programs (
    program_id INT AUTO_INCREMENT PRIMARY KEY,         
    faculty_id INT NOT NULL,                           
    program_name VARCHAR(100) NOT NULL UNIQUE,         
    program_duration INT NOT NULL,                     
    FOREIGN KEY (faculty_id) REFERENCES Faculties(faculty_id) ON DELETE CASCADE
);

-- 4. Students Table
CREATE TABLE Students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,         
    user_id INT NOT NULL,                              
    registration_number VARCHAR(20) NOT NULL UNIQUE,   
    program_id INT NOT NULL,                           
    year_of_study INT NOT NULL,                        
    international_status ENUM('Domestic', 'International') NOT NULL,
    residency_status ENUM('Resident', 'Non-Resident') NOT NULL,      
    special_needs VARCHAR(255),                       
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (program_id) REFERENCES Programs(program_id) ON DELETE CASCADE
);

ALTER TABLE Students 
MODIFY COLUMN international_status ENUM('Native', 'International') NOT NULL;


-- 5. ElectionPosts Table
CREATE TABLE ElectionPosts (
    post_id INT AUTO_INCREMENT PRIMARY KEY,           
    post_name VARCHAR(100) NOT NULL,                  
    eligibility_criteria TEXT,                        
    faculty_id INT,                                   
    residency_status ENUM('Resident', 'Non-Resident') DEFAULT NULL,
    special_needs BOOLEAN DEFAULT NULL,               
    international_status BOOLEAN DEFAULT NULL,        
    min_cgpa DECIMAL(3, 2) DEFAULT NULL,              
    gender ENUM('Male', 'Female', 'Any') DEFAULT 'Any',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,   
    FOREIGN KEY (faculty_id) REFERENCES Faculties(faculty_id) ON DELETE CASCADE
);

-- 6. Nominations Table
CREATE TABLE Nominations (
    nomination_id INT AUTO_INCREMENT PRIMARY KEY,        
    student_id INT NOT NULL,                            
    post_id INT NOT NULL,                                
    nomination_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 
    status ENUM('Pending', 'Withdrawn', 'Vetted') DEFAULT 'Pending', 
    FOREIGN KEY (student_id) REFERENCES Students(student_id) ON DELETE CASCADE,
    FOREIGN KEY (post_id) REFERENCES ElectionPosts(post_id) ON DELETE CASCADE
);

-- 7. Vetting Table
CREATE TABLE Vetting (
    vetting_id INT AUTO_INCREMENT PRIMARY KEY,             
    nomination_id INT NOT NULL,                            
    vetting_status ENUM('Approved', 'Rejected', 'Pending') DEFAULT 'Pending',
    comments TEXT,                                         
    vetting_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,      
    FOREIGN KEY (nomination_id) REFERENCES Nominations(nomination_id) ON DELETE CASCADE
);

-- 8. Candidates Table
CREATE TABLE Candidates (
    candidate_id INT AUTO_INCREMENT PRIMARY KEY,      
    student_id INT NOT NULL,                          
    post_id INT NOT NULL,                             
    manifesto TEXT,                                   
    nomination_date DATE NOT NULL,                   
    status ENUM('pending', 'approved', 'rejected') DEFAULT 'pending',
    FOREIGN KEY (student_id) REFERENCES Students(student_id) ON DELETE CASCADE,
    FOREIGN KEY (post_id) REFERENCES ElectionPosts(post_id) ON DELETE CASCADE
);

-- 9. Elections Table
CREATE TABLE Elections (
    election_id INT AUTO_INCREMENT PRIMARY KEY,       
    position VARCHAR(50) NOT NULL,                   
    faculty_id INT,                                  
    start_date DATE NOT NULL,                        
    end_date DATE NOT NULL,                          
    status ENUM('open', 'closed') DEFAULT 'open',    
    FOREIGN KEY (faculty_id) REFERENCES Faculties(faculty_id)
);

-- 10. Votes Table
CREATE TABLE Votes (
    vote_id INT AUTO_INCREMENT PRIMARY KEY,           
    election_id INT NOT NULL,                          
    voter_id INT NOT NULL,                             
    candidate_id INT,                                  
    vote_status ENUM('Valid', 'Invalid') DEFAULT 'Valid', 
    invalid_reason VARCHAR(255),                   
    vote_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,     
    FOREIGN KEY (election_id) REFERENCES Elections(election_id) ON DELETE CASCADE,
    FOREIGN KEY (voter_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (candidate_id) REFERENCES Candidates(candidate_id) ON DELETE SET NULL
);

-- 11. Results Table
CREATE TABLE Results (
    result_id INT AUTO_INCREMENT PRIMARY KEY,          
    election_id INT NOT NULL,                          
    candidate_id INT NOT NULL,                         
    votes_received INT NOT NULL DEFAULT 0,            
    invalid_votes INT NOT NULL DEFAULT 0,              
    is_winner BOOLEAN DEFAULT FALSE,                   
    FOREIGN KEY (election_id) REFERENCES Elections(election_id) ON DELETE CASCADE,
    FOREIGN KEY (candidate_id) REFERENCES Candidates(candidate_id) ON DELETE CASCADE
);

INSERT INTO Faculties (faculty_name) VALUES
('Computing and Design'),
('Medicine'),
('Engineering and Applied Science'),
('Law'),
('Journalism, Media, and Mass'),
('Education'),
('Theology'),
('Business'),
('Agriculture');

INSERT INTO Programs (faculty_id, program_name, program_duration) VALUES
(1, 'Computer Science', 3),
(1, 'Information Technology', 3),
(1, 'Software Engineering', 4),
(1, 'Graphic Design', 3),
(2, 'Medical Studies', 5),
(2, 'Pharmacy', 4),
(2, 'Nursing', 3),
(2, 'Public Health', 3),
(3, 'Civil Engineering', 4),
(3, 'Mechanical Engineering', 4),
(3, 'Electrical Engineering', 4),
(3, 'Environmental Engineering', 4)
(4, 'Law Studies', 4),
(4, 'International Law', 4),
(4, 'Corporate Law', 4),
(4, 'Human Rights Law', 4),
(5, 'Mass Communication', 3),
(5, 'Journalism', 3),
(5, 'Public Relations', 3),
(5, 'Digital Media Production', 3),
(6, 'Teacher Education', 3),
(6, 'Early Childhood Education', 3),
(6, 'Special Needs Education', 3),
(6, 'Educational Psychology', 3),
(7, 'Theology Studies', 3),
(7, 'Divinity', 3),
(7, 'Religious Education', 3),
(7, 'Biblical Studies', 3),
(8, 'Business Administration', 3),
(8, 'Finance and Accounting', 3),
(8, 'Marketing', 3),
(8, 'Entrepreneurship', 3),
(9, 'Agriculture Science', 4),
(9, 'Animal Science', 4),
(9, 'Crop Production', 4),
(9, 'Agribusiness Management', 4);

-- Insert Admin User
INSERT INTO Users (username, password_hash, full_name, email, role) 
VALUES 
('admin1', 'admin.ucu', 'Tusker Malt', 'tusker@gmail.com', 'admin'),
('admin2', 'admin.ucu', 'Bell Wine', 'bell2@gmail.com', 'admin'),
('admin3', 'admin.ucu', 'Johnson Johnson', 'johnson3@gmail.com', 'admin'),
('admin4', 'admin.ucu', 'Emily Davis', 'davis4@gmail.com', 'admin'),
('admin5', 'admin.ucu', 'Michael Brown', 'michael5@gmail.com', 'admin'),
('admin6', 'admin.ucu', 'Aja Wilson', 'ajawilson@gmail.com', 'admin'),
('admin7', 'admin.ucu', 'DJ Moore', 'davidmoore7@gmail.com', 'admin'),
('admin8', 'admin.ucu', 'Laura Taylor', 'laurataylorwork@gmail.com', 'admin'),
('admin9', 'admin.ucu', 'James Anderson', 'jamesanderson99@gmail.com', 'admin'),
('admin10', 'admin.ucu', 'Olivia Thomas', 'olivia.thomas10@gmail.com', 'admin'),
('admin11', 'admin.ucu', 'William Jackson', 'william.jackson11@gmail.com', 'admin'),
('admin12', 'admin.ucu', 'Sophia Harris', 'sophia.harris12@gmail.com', 'admin'),
('admin13', 'admin.ucu', 'Benjamin Martin', 'benjaminmartin1@gmail.com', 'admin'),
('admin14', 'admin.ucu', 'Isabella White', 'isabellawhitelight@gmail.com', 'admin'),
('admin15', 'admin.ucu', 'Lucas Garcia', 'lucasgarcia155@gmail.com', 'admin'),
('admin16', 'admin.ucu', 'Mia Robinson', 'mia.robinson@gmail.com', 'admin'),
('admin17', 'admin.ucu', 'Daniel Clark Kent', 'clarkkent17@gmail.com', 'admin'),
('admin18', 'admin.ucu', 'Amelia Lewis', 'lewis18@gmail.com', 'admin'),
('admin19', 'admin.ucu', 'Henry Young', 'young19@gmail.com', 'admin'),
('admin20', 'admin.ucu', 'Johnny Walker', 'walker2@gmail.com', 'admin');



-- Insert Specific Lecturer User 
INSERT INTO Users (username, password_hash, full_name, email, role) 
VALUES 
('lecturer_Justine', 'changemenow', 'Justine Mukalere', 'justine1of1@gmail.com', 'lecturer'),
('lecturer_Martin', 'changemenow', 'Martin Kubanja', 'martin@gmail.com', 'lecturer'),
('lecturer_smith', 'changemenow', 'Kenneth Smith', 'smith@gmail.com', 'lecturer'),
('lecturer_johnson', 'changemenow', 'Michael Johnson', 'michael.johnson@gmail.com', 'lecturer'),
('lecturer_brown', 'changemenow', 'Sarah Brown', 'sarah.brown@gmail.com', 'lecturer'),
('lecturer_williams', 'changemenow', 'James Williams', 'james.williams@gmail.com', 'lecturer'),
('lecturer_jones', 'changemenow', 'William Jones', 'william.jones@gmail.com', 'lecturer'),
('lecturer_garcia', 'changemenow', 'Maria Garcia', 'maria.garcia@gmail.com', 'lecturer'),
('lecturer_linda', 'changemenow', 'Linda Martin', 'linda.martin@gmail.com', 'lecturer'),
('lecturer_thompson', 'changemenow', 'Robert Thompson', 'robert.thompson@gmail.com', 'lecturer'),
('lecturer_white', 'changemenow', 'David White', 'david.white@gmail.com', 'lecturer'),
('lecturer_lee', 'changemenow', 'Jessica Lee', 'jessica.lee@gmail.com', 'lecturer'),
('lecturer_harris', 'changemenow', 'George Harris', 'george.harris@gmail.com', 'lecturer'),
('lecturer_clark', 'changemenow', 'Ashley Clark', 'ashley.clark@gmail.com', 'lecturer'),
('lecturer_allen', 'changemenow', 'Patricia Allen', 'patricia.allen@gmail.com', 'lecturer'),
('lecturer_young', 'changemenow', 'Joshua Young', 'joshua.young@gmail.com', 'lecturer'),
('lecturer_king', 'changemenow', 'Elizabeth King', 'elizabeth.king@gmail.com', 'lecturer'),
('lecturer_scott', 'changemenow', 'Daniel Scott', 'daniel.scott@gmail.com', 'lecturer'),
('lecturer_green', 'changemenow', 'Anna Green', 'anna.green@gmail.com', 'lecturer'),
('lecturer_adams', 'changemenow', 'Joseph Adams', 'joseph.adams@gmail.com', 'lecturer'),
('lecturer_baker', 'changemenow', 'Jessica Baker', 'jessica.baker@gmail.com', 'lecturer'),
('lecturer_mitchell', 'changemenow', 'Steven Mitchell', 'steven.mitchell@gmail.com', 'lecturer'),
('lecturer_roberts', 'changemenow', 'Sophia Roberts', 'sophia.roberts@gmail.com', 'lecturer'),
('lecturer_carter', 'changemenow', 'James Carter', 'james.carter@gmail.com', 'lecturer'),
('lecturer_perez', 'changemenow', 'Daniel Perez', 'daniel.perez@gmail.com', 'lecturer'),
('lecturer_wilson', 'changemenow', 'Rachel Wilson', 'rachel.wilson@gmail.com', 'lecturer'),
('lecturer_russell', 'changemenow', 'William Russell', 'william.russell@gmail.com', 'lecturer'),
('lecturer_nelson', 'changemenow', 'Olivia Nelson', 'olivia.nelson@gmail.com', 'lecturer'),
('lecturer_morris', 'changemenow', 'Benjamin Morris', 'benjamin.morris@gmail.com', 'lecturer'),
('lecturer_rodriguez', 'changemenow', 'Sarah Rodriguez', 'sarah.rodriguez@gmail.com', 'lecturer'),
('lecturer_james', 'changemenow', 'David James', 'david.james@gmail.com', 'lecturer'),
('lecturer_wright', 'changemenow', 'Megan Wright', 'megan.wright@gmail.com', 'lecturer'),
('lecturer_kim', 'changemenow', 'Christopher Kim', 'christopher.kim@gmail.com', 'lecturer'),
('lecturer_li', 'changemenow', 'Emily Lee', 'emily.lee@gmail.com', 'lecturer'),
('lecturer_hughes', 'changemenow', 'Joshua Hughes', 'joshua.hughes@gmail.com', 'lecturer'),
('lecturer_ward', 'changemenow', 'Chloe Ward', 'chloe.ward@gmail.com', 'lecturer'),
('lecturer_rice', 'changemenow', 'Michael Rice', 'michael.rice@gmail.com', 'lecturer'),
('lecturer_gonzalez', 'changemenow', 'Emily Gonzalez', 'emily.gonzalez@gmail.com', 'lecturer'),
('lecturer_kelly', 'changemenow', 'Henry Kelly', 'henry.kelly@gmail.com', 'lecturer'),
('lecturer_bryant', 'changemenow', 'Ella Bryant', 'ella.bryant@gmail.com', 'lecturer'),
('lecturer_bennett', 'changemenow', 'George Bennett', 'george.bennett@gmail.com', 'lecturer'),
('lecturer_cameron', 'changemenow', 'Isabel Cameron', 'isabel.cameron@gmail.com', 'lecturer'),
('lecturer_evans', 'changemenow', 'Matthew Evans', 'matthew.evans@gmail.com', 'lecturer'),
('lecturer_cooper', 'changemenow', 'Alice Cooper', 'alice.cooper@gmail.com', 'lecturer');


DELETE from users;



-- Insert Students 
INSERT INTO Users (username, password_hash, full_name, email, role) 
VALUES 
('student_luqman', 'changemenow', 'Luqman', 'luqman@ucu.ac.ug', 'student'),
('student_muhammad', 'changemenow', 'Muhammad', 'muhammad@ucu.ac.ug', 'student'),
('student_joan', 'changemenow', 'Joan', 'joan@ucu.ac.ug', 'student'),
('student_stephen', 'changemenow', 'Stephen', 'stephen@ucu.ac.ug', 'student'),
('student_josephine', 'changemenow', 'Josephine', 'josephine@ucu.ac.ug', 'student'),
('student_isaac', 'changemenow', 'Isaac', 'isaac@ucu.ac.ug', 'student'),
('student_nushit', 'changemenow', 'Nushit', 'nushit@ucu.ac.ug', 'student'),
('student_rose', 'changemenow', 'Rose', 'rose@ucu.ac.ug', 'student'),
('student_ebenezer', 'changemenow', 'Ebenezer', 'ebenezer@ucu.ac.ug', 'student'),
('student_owen', 'changemenow', 'Owen', 'owen@ucu.ac.ug', 'student'),
('student_hilda', 'changemenow', 'Hilda', 'hilda@ucu.ac.ug', 'student'),
('student_peter', 'changemenow', 'Peter', 'peter@ucu.ac.ug', 'student'),
('student_liz', 'changemenow', 'Liz', 'liz@ucu.ac.ug', 'student'),
('student_sarah', 'changemenow', 'Sarah', 'sarah@ucu.ac.ug', 'student'),
('student_john', 'changemenow', 'John', 'john@ucu.ac.ug', 'student'),
('student_ashley', 'changemenow', 'Ashley', 'ashley@ucu.ac.ug', 'student'),
('student_jose', 'changemenow', 'Jose', 'jose@ucu.ac.ug', 'student'),
('student_miriam', 'changemenow', 'Miriam', 'miriam@ucu.ac.ug', 'student'),
('student_steven', 'changemenow', 'Steven', 'steven@ucu.ac.ug', 'student'),
('student_amanda', 'changemenow', 'Amanda', 'amanda@ucu.ac.ug', 'student'),
('student_samuel', 'changemenow', 'Samuel', 'samuel@ucu.ac.ug', 'student'),
('student_adele', 'changemenow', 'Adele', 'adele@ucu.ac.ug', 'student'),
('student_ronald', 'changemenow', 'Ronald', 'ronald@ucu.ac.ug', 'student'),
('student_ella', 'changemenow', 'Ella', 'ella@ucu.ac.ug', 'student'),
('student_steve', 'changemenow', 'Steve', 'steve@ucu.ac.ug', 'student'),
('student_julie', 'changemenow', 'Julie', 'julie@ucu.ac.ug', 'student'),
('student_micheal', 'changemenow', 'Micheal', 'micheal@ucu.ac.ug', 'student'),
('student_charles', 'changemenow', 'Charles', 'charles@ucu.ac.ug', 'student'),
('student_ruth', 'changemenow', 'Ruth', 'ruth@ucu.ac.ug', 'student'),
('student_rachel', 'changemenow', 'Rachel', 'rachel@ucu.ac.ug', 'student'),
('student_toby', 'changemenow', 'Toby', 'toby@ucu.ac.ug', 'student'),
('student_david', 'changemenow', 'David', 'david@ucu.ac.ug', 'student'),
('student_diana', 'changemenow', 'Diana', 'diana@ucu.ac.ug', 'student'),
('student_nashit', 'changemenow', 'Nashit', 'nashit@ucu.ac.ug', 'student'),
('student_kevin', 'changemenow', 'Kevin', 'kevin@ucu.ac.ug', 'student'),
('student_robert', 'changemenow', 'Robert', 'robert@ucu.ac.ug', 'student'),
('student_joy', 'changemenow', 'Joy', 'joy@ucu.ac.ug', 'student'),
('student_edward', 'changemenow', 'Edward', 'edward@ucu.ac.ug', 'student');

CREATE USER 'admin1'@'localhost' IDENTIFIED BY 'admin1';
GRANT ALL PRIVILEGES ON studentelection.* TO 'admin1'@'localhost';


CREATE USER 'lecturer1'@'localhost' IDENTIFIED BY 'lecturer1';
GRANT SELECT ON studentelection.faculties TO 'lecturer1'@'localhost';
GRANT SELECT ON studentelection.programs TO 'lecturer1'@'localhost';


CREATE USER 'student1'@'localhost' IDENTIFIED BY 'student1';
GRANT SELECT ON studentelection.candidates TO 'student1'@'localhost';
GRANT SELECT ON studentelection.vetting TO 'student1'@'localhost';
GRANT INSERT ON studentelection.votes TO 'student1'@'localhost';
GRANT INSERT ON studentelection.nominations TO 'student1'@'localhost';



-- Insert Students
INSERT INTO Students (user_id, registration_number, program_id, year_of_study, international_status, residency_status, special_needs)
SELECT 
    user_id, 
    CONCAT('B23B', LPAD(user_id, 4, '0')),   
    FLOOR(1 + (RAND() * 9)), 
    FLOOR(1 + (RAND() * 4)), 
    CASE 
        WHEN RAND() <= 0.37 THEN 'International' 
        ELSE 'Native'
    END,
    CASE 
        WHEN RAND() <= 0.37 THEN 'Resident'  
        ELSE 'Non-Resident'
    END,
    CASE 
        WHEN RAND() <= 0.12 THEN 'Special Needs' 
        ELSE NULL
    END
FROM Users 
WHERE role = 'student';

INSERT INTO ElectionPosts (post_name, eligibility_criteria, faculty_id, residency_status, special_needs, international_status, min_cgpa, gender)
VALUES
('Guild President', 'CGPA above 4.0', NULL, NULL, NULL, NULL, 4.0, 'Any'),
('MP Computing and Design', 'Must belong to Faculty of Computing and Design', 1, NULL, NULL, NULL, NULL, 'Any'),
('MP Engineering', 'Must belong to Faculty of Engineering and Applied Science', 3, NULL, NULL, NULL, NULL, 'Any'),
('MP Law', 'Must belong to Faculty of Law', 4, NULL, NULL, NULL, NULL, 'Any'),
('MP Non-Resident (Male)', 'Must be a Non-Resident Male', NULL, 'Non-Resident', NULL, NULL, NULL, 'Male'),
('MP Non-Resident (Female)', 'Must be a Non-Resident Female', NULL, 'Non-Resident', NULL, NULL, NULL, 'Female'),
('MP Resident (Male)', 'Must be a Resident Male', NULL, 'Resident', NULL, NULL, NULL, 'Male'),
('MP Resident (Female)', 'Must be a Resident Female', NULL, 'Resident', NULL, NULL, NULL, 'Female'),
('MP International Student', 'Must be an International Student', NULL, NULL, NULL, TRUE, NULL, 'Any'),
('MP Special Needs', 'Must have a disability or impairment', NULL, NULL, TRUE, NULL, NULL, 'Any');

-- Guild President Nominees
INSERT INTO Nominations (student_id, post_id, status)
SELECT student_id, 1, 'Pending'
FROM Students
ORDER BY RAND()
LIMIT 6;

-- Insert data for other election posts (MP positions)
INSERT INTO Nominations (student_id, post_id, status)
SELECT student_id, 2 + FLOOR(RAND() * 8), 'Pending'
FROM Students
ORDER BY RAND()
LIMIT 30; 

ALTER TABLE Nominations MODIFY COLUMN status VARCHAR(10);

UPDATE Nominations
SET status = 'Approved'
WHERE status = 'Pending' AND post_id = 7
ORDER BY RAND()
LIMIT 6;

UPDATE Nominations
SET status = 'Rejected'
WHERE student_id = 92;

SELECT * FROM nominations WHERE post_id = 10;
UPDATE Nominations
SET student_id = 27
WHERE nomination_id = ;

-- insert into vetting
INSERT INTO Vetting (nomination_id, vetting_status, comments)
SELECT 
    nomination_id, 
    CASE 
        WHEN status = 'Approved' THEN 'Approved'
        WHEN status = 'Rejected' THEN 'Rejected'
        ELSE 'Pending'
    END AS vetting_status,
    NULL AS comments
FROM Nominations;  

INSERT INTO Vetting (nomination_id, vetting_status, comments)
VALUES
    (42, 'Pending', 'Awaiting further review by the vetting committee.'),
    (40, 'Approved', 'Successfully vetted with no issues found.'),
    (44, 'Approved', 'Nomination meets all eligibility criteria.'),
    (46, 'Rejected', 'Nominee failed to meet the minimum GPA requirement.'),
    (47, 'Approved', 'All documents verified; nomination approved.'),
    (50, 'Approved', 'Nominee passed the background check and eligibility test.'),
    (51, 'Approved', 'Nomination successfully passed all review stages.'),
    (52, 'Approved', 'Nominee passed the background check and eligibility test.'),
    (53, 'Approved', NULL),
    (54, 'Approved', 'Nomination successfully passed all review stages.'),
    (55, 'Approved', 'Nomination successfully passed all review stages..'),
    (56, 'Approved', 'Nominee passed the background check and eligibility test.'),
    (57, 'Rejected', 'Did not meet the minimum eligibility criteria.'),
    (58, 'Pending', 'Nominees references still under verification.'),
    (59, 'Approved', 'Successfully vetted with no issues found.'),
    (60, 'Rejected', 'Incomplete submission of required documents.'),
    (64, 'Approved', 'Nomination successfully passed all review stages.');


INSERT INTO Candidates (student_id, post_id, manifesto, nomination_date, status)
VALUES 
(69, 1, 'I will ensure better student representation and work towards improving the student welfare programs.', '2024-11-28', 'Approved'),
(72, 1, 'My focus will be to improve the communication channels between students and administration.', '2024-11-28', 'Approved'),  
(74, 1, 'Moving forward.', '2024-11-28', 'Approved'),
(9, 5, 'Home is where the Heart is.', '2024-11-28', 'Approved'),
(79, 2, 'I plan to create a more inclusive environment for students in the Computing and Design faculty.', '2024-11-28', 'Approved'),
(3, 3, 'I want to ensure better resource allocation for Engineering students.', '2024-11-28', 'Approved'),
(11, 3, 'My mission is to advocate for improved academic resources and opportunities for Engineering students.', '2024-11-28', 'pending'),
(38, 4, 'I aim to represent the students of the Law faculty and address key issues regarding their learning environment.', '2024-11-28', 'Approved'),
(69, 7, 'I believe in making the Law faculty more accessible and offering career guidance for law students.', '2024-11-28', 'Approved');


-- Insert Elections for Guild President and MPs 
INSERT INTO Elections (position, faculty_id, start_date, end_date, status) 
VALUES
('Guild President', NULL, '2024-12-01', '2024-12-03', 'open'),
('MP Engineering', (SELECT faculty_id FROM Faculties WHERE faculty_name = 'Engineering'), '2024-12-01', '2024-12-03', 'open'),
('MP Law', (SELECT faculty_id FROM Faculties WHERE faculty_name = 'Law'), '2024-12-01', '2024-12-03', 'open'),
('MP Journalism', (SELECT faculty_id FROM Faculties WHERE faculty_name = 'Journalism'), '2024-12-01', '2024-12-03', 'open'),
('MP Computing', (SELECT faculty_id FROM Faculties WHERE faculty_name = 'Computing'), '2024-12-01', '2024-12-03', 'open'),
('MP Business', (SELECT faculty_id FROM Faculties WHERE faculty_name = 'Business'), '2024-12-01', '2024-12-03', 'open'),
('MP Medicine', (SELECT faculty_id FROM Faculties WHERE faculty_name = 'Medicine'), '2024-12-01', '2024-12-03', 'open'),
('MP Theology', (SELECT faculty_id FROM Faculties WHERE faculty_name = 'Theology'), '2024-12-01', '2024-12-03', 'open'),
('MP International', (SELECT faculty_id FROM Faculties WHERE faculty_name = 'International'), '2024-12-01', '2024-12-03', 'open'),
('MP Special Needs', (SELECT faculty_id FROM Faculties WHERE faculty_name = 'Special Needs'), '2024-12-01', '2024-12-03', 'open');

UPDATE Elections
SET status = 'closed'
WHERE position IN (
    'Guild President',
    'MP Engineering',
    'MP Law',
    'MP Journalism',
    'MP Computing',
    'MP Business',
    'MP Medicine',
    'MP Theology',
    'MP International',
    'MP Special Needs'
);

INSERT INTO Votes (student_id, election_id, candidate_id, vote_status, invalid_reason)
VALUES 
    (1, 101, 201, 'Valid', NULL),   
    (2, 101, 202, 'Va   

-- Insert results for valid voteslid', NULL),    
    (3, 101, NULL, 'Invalid', 'Incomplete ballot'),
    (4, 102, 203, 'Valid', NULL),    
    (5, 102, 204, 'Valid', NULL); 
INSERT INTO Results (election_id, candidate_id, votes_received, invalid_votes, is_winner)
SELECT
    v.election_id,
    v.candidate_id,
    COUNT(v.student_id) AS votes_received,
    0 AS invalid_votes,
    FALSE AS is_winner
FROM Votes v
WHERE v.vote_status = 'Valid'
GROUP BY v.election_id, v.candidate_id;
UPDATE Results r
SET r.invalid_votes = (
    SELECT COUNT(v.student_id)
    FROM Votes v
    WHERE v.election_id = r.election_id
    AND v.vote_status = 'Invalid'
);

INSERT INTO Results (election_id, candidate_id, votes_received, invalid_votes, is_winner)
SELECT 
    election_id,
    candidate_id,
    COUNT(student_id) AS votes_received,
    0 AS invalid_votes, 
    FALSE AS is_winner  
FROM Votes
WHERE vote_status = 'Valid'
GROUP BY election_id, candidate_id;

UPDATE Results r
SET r.invalid_votes = (
    SELECT COUNT(student_id)
    FROM Votes v
    WHERE v.election_id = r.election_id
    AND v.vote_status = 'Invalid'
);

UPDATE Results r
SET is_winner = TRUE
WHERE (r.election_id, r.votes_received) IN (
    SELECT election_id, MAX(votes_received)
    FROM Results
    GROUP BY election_id
);
DELIMITER $$

CREATE PROCEDURE RegisterUser (
    IN p_user_name VARCHAR(255),
    IN p_email VARCHAR(255),
    IN p_role ENUM('Student', 'Admin')
)
BEGIN
    DECLARE existing_user INT;

    -- Check if the email is already registered
    SELECT COUNT(*)
    INTO existing_user
    FROM Users
    WHERE email = p_email;

    IF existing_user > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Email is already registered.';
    ELSE
        -- Insert the user
        INSERT INTO Users (user_name, email, role)
        VALUES (p_user_name, p_email, p_role);
    END IF;
END$$

DELIMITER ;


DELIMITER //

CREATE PROCEDURE AddVote(
    IN p_student_id INT,
    IN p_election_id INT,
    IN p_candidate_id INT,
    IN p_vote_status ENUM('Valid', 'Invalid'),
    IN p_invalid_reason VARCHAR(255)
)
BEGIN
    IF EXISTS (
        SELECT 1
        FROM Votes
        WHERE student_id = p_student_id
        AND election_id = p_election_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'This student has already voted in this election.';
    ELSE
        INSERT INTO Votes (student_id, election_id, candidate_id, vote_status, invalid_reason)
        VALUES (p_student_id, p_election_id, p_candidate_id, p_vote_status, p_invalid_reason);
    END IF;
END//

DELIMITER ;
CALL AddVote(1, 41, 55, 'Valid', NULL); 
CALL AddVote(9, 42, NULL, 'Invalid', 'Incomplete ballot'); 
CALL AddVote(10, 41, 55, 'Valid', NULL); 



DELIMITER //

CREATE PROCEDURE ShowNumberOfVoters(
    IN p_election_id INT
)
BEGIN
    DECLARE total_voters INT;

    SELECT COUNT(DISTINCT student_id) INTO total_voters
    FROM Votes
    WHERE election_id = p_election_id;
    SELECT CONCAT('Total number of voters in election ', p_election_id, ': ', total_voters) AS VoterCount;
END//

DELIMITER ;
CALL ShowNumberOfVoters(41);




