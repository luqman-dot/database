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
('admin1', 'hashedpassword', 'Tusker Malt', 'tusker@gmail.com', 'admin'),
('admin2', 'hashedpassword', 'Bell Wine', 'bell2@gmail.com', 'admin'),
('admin3', 'hashedpassword', 'Johnson Johnson', 'johnson3@gmail.com', 'admin'),
('admin4', 'hashedpassword', 'Emily Davis', 'davis4@gmail.com', 'admin'),
('admin5', 'hashedpassword', 'Michael Brown', 'michael5@gmail.com', 'admin'),
('admin6', 'hashedpassword', 'Aja Wilson', 'ajawilson@gmail.com', 'admin'),
('admin7', 'hashedpassword', 'DJ Moore', 'davidmoore7@gmail.com', 'admin'),
('admin8', 'hashedpassword', 'Laura Taylor', 'laurataylorwork@gmail.com', 'admin'),
('admin9', 'hashedpassword', 'James Anderson', 'jamesanderson99@gmail.com', 'admin'),
('admin10', 'hashedpassword', 'Olivia Thomas', 'olivia.thomas10@gmail.com', 'admin'),
('admin11', 'hashedpassword', 'William Jackson', 'william.jackson11@gmail.com', 'admin'),
('admin12', 'hashedpassword', 'Sophia Harris', 'sophia.harris12@gmail.com', 'admin'),
('admin13', 'hashedpassword', 'Benjamin Martin', 'benjaminmartin1@gmail.com', 'admin'),
('admin14', 'hashedpassword', 'Isabella White', 'isabellawhitelight@gmail.com', 'admin'),
('admin15', 'hashedpassword', 'Lucas Garcia', 'lucasgarcia155@gmail.com', 'admin'),
('admin16', 'hashedpassword', 'Mia Robinson', 'mia.robinson@gmail.com', 'admin'),
('admin17', 'hashedpassword', 'Daniel Clark Kent', 'clarkkent17@gmail.com', 'admin'),
('admin18', 'hashedpassword', 'Amelia Lewis', 'lewis18@gmail.com', 'admin'),
('admin19', 'hashedpassword', 'Henry Young', 'young19@gmail.com', 'admin'),
('admin20', 'hashedpassword', 'Johnny Walker', 'walker2@gmail.com', 'admin');


-- Insert Specific Lecturer User 
INSERT INTO Users (username, password_hash, full_name, email, role) 
VALUES 
('lecturer_Justine', 'hashedpassword', 'Justine Mukalere', 'justine1of1@gmail.com', 'lecturer'),
('lecturer_Martin', 'hashedpassword', 'Martin Kubanja', 'martin@gmail.com', 'lecturer'),
('lecturer_smith', 'hashedpassword', 'Kenneth Smith', 'smith@gmail.com', 'lecturer'),
('lecturer_johnson', 'hashedpassword', 'Michael Johnson', 'michael.johnson@gmail.com', 'lecturer'),
('lecturer_brown', 'hashedpassword', 'Sarah Brown', 'sarah.brown@gmail.com', 'lecturer'),
('lecturer_williams', 'hashedpassword', 'James Williams', 'james.williams@gmail.com', 'lecturer'),
('lecturer_jones', 'hashedpassword', 'William Jones', 'william.jones@gmail.com', 'lecturer'),
('lecturer_garcia', 'hashedpassword', 'Maria Garcia', 'maria.garcia@gmail.com', 'lecturer'),
('lecturer_linda', 'hashedpassword', 'Linda Martin', 'linda.martin@gmail.com', 'lecturer'),
('lecturer_thompson', 'hashedpassword', 'Robert Thompson', 'robert.thompson@gmail.com', 'lecturer'),
('lecturer_white', 'hashedpassword', 'David White', 'david.white@gmail.com', 'lecturer'),
('lecturer_lee', 'hashedpassword', 'Jessica Lee', 'jessica.lee@gmail.com', 'lecturer'),
('lecturer_harris', 'hashedpassword', 'George Harris', 'george.harris@gmail.com', 'lecturer'),
('lecturer_clark', 'hashedpassword', 'Ashley Clark', 'ashley.clark@gmail.com', 'lecturer'),
('lecturer_allen', 'hashedpassword', 'Patricia Allen', 'patricia.allen@gmail.com', 'lecturer'),
('lecturer_young', 'hashedpassword', 'Joshua Young', 'joshua.young@gmail.com', 'lecturer'),
('lecturer_king', 'hashedpassword', 'Elizabeth King', 'elizabeth.king@gmail.com', 'lecturer'),
('lecturer_scott', 'hashedpassword', 'Daniel Scott', 'daniel.scott@gmail.com', 'lecturer'),
('lecturer_green', 'hashedpassword', 'Anna Green', 'anna.green@gmail.com', 'lecturer'),
('lecturer_adams', 'hashedpassword', 'Joseph Adams', 'joseph.adams@gmail.com', 'lecturer'),
('lecturer_baker', 'hashedpassword', 'Jessica Baker', 'jessica.baker@gmail.com', 'lecturer'),
('lecturer_mitchell', 'hashedpassword', 'Steven Mitchell', 'steven.mitchell@gmail.com', 'lecturer'),
('lecturer_roberts', 'hashedpassword', 'Sophia Roberts', 'sophia.roberts@gmail.com', 'lecturer'),
('lecturer_carter', 'hashedpassword', 'James Carter', 'james.carter@gmail.com', 'lecturer'),
('lecturer_perez', 'hashedpassword', 'Daniel Perez', 'daniel.perez@gmail.com', 'lecturer'),
('lecturer_wilson', 'hashedpassword', 'Rachel Wilson', 'rachel.wilson@gmail.com', 'lecturer'),
('lecturer_russell', 'hashedpassword', 'William Russell', 'william.russell@gmail.com', 'lecturer'),
('lecturer_nelson', 'hashedpassword', 'Olivia Nelson', 'olivia.nelson@gmail.com', 'lecturer'),
('lecturer_morris', 'hashedpassword', 'Benjamin Morris', 'benjamin.morris@gmail.com', 'lecturer'),
('lecturer_rodriguez', 'hashedpassword', 'Sarah Rodriguez', 'sarah.rodriguez@gmail.com', 'lecturer'),
('lecturer_james', 'hashedpassword', 'David James', 'david.james@gmail.com', 'lecturer'),
('lecturer_wright', 'hashedpassword', 'Megan Wright', 'megan.wright@gmail.com', 'lecturer'),
('lecturer_kim', 'hashedpassword', 'Christopher Kim', 'christopher.kim@gmail.com', 'lecturer'),
('lecturer_li', 'hashedpassword', 'Emily Lee', 'emily.lee@gmail.com', 'lecturer'),
('lecturer_hughes', 'hashedpassword', 'Joshua Hughes', 'joshua.hughes@gmail.com', 'lecturer'),
('lecturer_ward', 'hashedpassword', 'Chloe Ward', 'chloe.ward@gmail.com', 'lecturer'),
('lecturer_rice', 'hashedpassword', 'Michael Rice', 'michael.rice@gmail.com', 'lecturer'),
('lecturer_gonzalez', 'hashedpassword', 'Emily Gonzalez', 'emily.gonzalez@gmail.com', 'lecturer'),
('lecturer_kelly', 'hashedpassword', 'Henry Kelly', 'henry.kelly@gmail.com', 'lecturer'),
('lecturer_bryant', 'hashedpassword', 'Ella Bryant', 'ella.bryant@gmail.com', 'lecturer'),
('lecturer_bennett', 'hashedpassword', 'George Bennett', 'george.bennett@gmail.com', 'lecturer'),
('lecturer_cameron', 'hashedpassword', 'Isabel Cameron', 'isabel.cameron@gmail.com', 'lecturer'),
('lecturer_evans', 'hashedpassword', 'Matthew Evans', 'matthew.evans@gmail.com', 'lecturer'),
('lecturer_cooper', 'hashedpassword', 'Alice Cooper', 'alice.cooper@gmail.com', 'lecturer');


-- Insert Students 
INSERT INTO Users (username, password_hash, full_name, email, role) 
VALUES 
('student_luqman', 'hashedpassword', 'Luqman', 'luqman@ucu.ac.ug', 'student'),
('student_muhammad', 'hashedpassword', 'Muhammad', 'muhammad@ucu.ac.ug', 'student'),
('student_joan', 'hashedpassword', 'Joan', 'joan@ucu.ac.ug', 'student'),
('student_stephen', 'hashedpassword', 'Stephen', 'stephen@ucu.ac.ug', 'student'),
('student_josephine', 'hashedpassword', 'Josephine', 'josephine@ucu.ac.ug', 'student'),
('student_isaac', 'hashedpassword', 'Isaac', 'isaac@ucu.ac.ug', 'student'),
('student_nushit', 'hashedpassword', 'Nushit', 'nushit@ucu.ac.ug', 'student'),
('student_rose', 'hashedpassword', 'Rose', 'rose@ucu.ac.ug', 'student'),
('student_ebenezer', 'hashedpassword', 'Ebenezer', 'ebenezer@ucu.ac.ug', 'student'),
('student_owen', 'hashedpassword', 'Owen', 'owen@ucu.ac.ug', 'student'),
('student_hilda', 'hashedpassword', 'Hilda', 'hilda@ucu.ac.ug', 'student'),
('student_peter', 'hashedpassword', 'Peter', 'peter@ucu.ac.ug', 'student'),
('student_liz', 'hashedpassword', 'Liz', 'liz@ucu.ac.ug', 'student'),
('student_sarah', 'hashedpassword', 'Sarah', 'sarah@ucu.ac.ug', 'student'),
('student_john', 'hashedpassword', 'John', 'john@ucu.ac.ug', 'student'),
('student_ashley', 'hashedpassword', 'Ashley', 'ashley@ucu.ac.ug', 'student'),
('student_jose', 'hashedpassword', 'Jose', 'jose@ucu.ac.ug', 'student'),
('student_miriam', 'hashedpassword', 'Miriam', 'miriam@ucu.ac.ug', 'student'),
('student_steven', 'hashedpassword', 'Steven', 'steven@ucu.ac.ug', 'student'),
('student_amanda', 'hashedpassword', 'Amanda', 'amanda@ucu.ac.ug', 'student'),
('student_samuel', 'hashedpassword', 'Samuel', 'samuel@ucu.ac.ug', 'student'),
('student_adele', 'hashedpassword', 'Adele', 'adele@ucu.ac.ug', 'student'),
('student_ronald', 'hashedpassword', 'Ronald', 'ronald@ucu.ac.ug', 'student'),
('student_ella', 'hashedpassword', 'Ella', 'ella@ucu.ac.ug', 'student'),
('student_steve', 'hashedpassword', 'Steve', 'steve@ucu.ac.ug', 'student'),
('student_julie', 'hashedpassword', 'Julie', 'julie@ucu.ac.ug', 'student'),
('student_micheal', 'hashedpassword', 'Micheal', 'micheal@ucu.ac.ug', 'student'),
('student_charles', 'hashedpassword', 'Charles', 'charles@ucu.ac.ug', 'student'),
('student_ruth', 'hashedpassword', 'Ruth', 'ruth@ucu.ac.ug', 'student'),
('student_rachel', 'hashedpassword', 'Rachel', 'rachel@ucu.ac.ug', 'student'),
('student_toby', 'hashedpassword', 'Toby', 'toby@ucu.ac.ug', 'student'),
('student_david', 'hashedpassword', 'David', 'david@ucu.ac.ug', 'student'),
('student_diana', 'hashedpassword', 'Diana', 'diana@ucu.ac.ug', 'student'),
('student_nashit', 'hashedpassword', 'Nashit', 'nashit@ucu.ac.ug', 'student'),
('student_kevin', 'hashedpassword', 'Kevin', 'kevin@ucu.ac.ug', 'student'),
('student_robert', 'hashedpassword', 'Robert', 'robert@ucu.ac.ug', 'student'),
('student_joy', 'hashedpassword', 'Joy', 'joy@ucu.ac.ug', 'student'),
('student_edward', 'hashedpassword', 'Edward', 'edward@ucu.ac.ug', 'student');


-- Insert Students
INSERT INTO Students (user_id, registration_number, program_id, year_of_study, international_status, residency_status, special_needs)
SELECT 
    user_id, 
    CONCAT('M23B', LPAD(user_id, 4, '0')),   
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
SET status = 'Rejected'
WHERE status = 'Pending' AND post_id = 7
ORDER BY RAND()
LIMIT 6;

UPDATE Nominations
SET status = 'Approved'
WHERE student_id = 100;

SELECT * FROM nominations WHERE post_id = 10;
UPDATE Nominations
SET student_id = 145
WHERE nomination_id = 128;

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
    (86, 'Pending', 'Awaiting further review by the vetting committee.'),
    (87, 'Approved', 'Successfully vetted with no issues found.'),
    (88, 'Approved', 'Nomination meets all eligibility criteria.'),
    (89, 'Rejected', 'Nominee failed to meet the minimum GPA requirement.'),
    (90, 'Approved', 'All documents verified; nomination approved.'),
    (91, 'Approved', 'Nominee passed the background check and eligibility test.'),
    (93, 'Approved', 'Nomination successfully passed all review stages.'),
    (94, 'Approved', 'Nominee passed the background check and eligibility test.'),
    (95, 'Approved', NULL),
    (96, 'Approved', 'Nomination successfully passed all review stages.'),
    (97, 'Approved', 'Nomination successfully passed all review stages..'),
    (98, 'Approved', 'Nominee passed the background check and eligibility test.'),
    (99, 'Rejected', 'Did not meet the minimum eligibility criteria.'),
    (100, 'Pending', 'Nominees references still under verification.'),
    (101, 'Approved', 'Successfully vetted with no issues found.'),
    (102, 'Rejected', 'Incomplete submission of required documents.'),
    (103, 'Approved', 'Nomination successfully passed all review stages.');

INSERT INTO Candidates (student_id, post_id, manifesto, nomination_date, status)
VALUES 
(67, 1, 'I will ensure better student representation and work towards improving the student welfare programs.', '2024-11-28', 'Approved'),
(71, 1, 'My focus will be to improve the communication channels between students and administration.', '2024-11-28', 'Approved'),  
(100, 1, 'Moving forward.', '2024-11-28', 'Approved'),
(89, 5, 'Home is where the Heart is.', '2024-11-28', 'Approved'),
(93, 2, 'I plan to create a more inclusive environment for students in the Computing and Design faculty.', '2024-11-28', 'Approved'),
(84, 3, 'I want to ensure better resource allocation for Engineering students.', '2024-11-28', 'Approved'),
(91, 3, 'My mission is to advocate for improved academic resources and opportunities for Engineering students.', '2024-11-28', 'pending'),
(94, 4, 'I aim to represent the students of the Law faculty and address key issues regarding their learning environment.', '2024-11-28', 'Approved'),
(101, 4, 'I believe in making the Law faculty more accessible and offering career guidance for law students.', '2024-11-28', 'Approved');

-- Insert elections
INSERT INTO Elections (position, faculty_id, start_date, end_date, status) 
VALUES
('Guild President', NULL, '2024-12-01', '2024-12-03', 'open'),
('MP Engineering', (SELECT faculty_id FROM Faculties WHERE faculty_name = 'Engineering and Applied Science'), '2024-12-01', '2024-12-03', 'open'),
('MP Law', (SELECT faculty_id FROM Faculties WHERE faculty_name = 'Law'), '2024-12-01', '2024-12-03', 'open'),
('MP Journalism', (SELECT faculty_id FROM Faculties WHERE faculty_name = 'Journalism, Media, and Mass'), '2024-12-01', '2024-12-03', 'open'),
('MP Computing', (SELECT faculty_id FROM Faculties WHERE faculty_name = 'Computing and Design'), '2024-12-01', '2024-12-03', 'open'),
('MP Business', (SELECT faculty_id FROM Faculties WHERE faculty_name = 'Business'), '2024-12-01', '2024-12-03', 'open'),
('MP Medicine', (SELECT faculty_id FROM Faculties WHERE faculty_name = 'Medicine'), '2024-12-01', '2024-12-03', 'open'),
('MP Theology', (SELECT faculty_id FROM Faculties WHERE faculty_name = 'Theology'), '2024-12-01', '2024-12-03', 'open'),
('MP International', (SELECT faculty_id FROM Faculties WHERE faculty_name = 'International'), '2024-12-01', '2024-12-03', 'closed'),
('MP Special Needs', (SELECT faculty_id FROM Faculties WHERE faculty_name = 'Special Needs'), '2024-12-01', '2024-12-03', 'closed')
;










