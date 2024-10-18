USE library;
#BRANCH
CREATE TABLE Branch (
    Branch_no INT PRIMARY KEY,
    Manager_Id INT,
    Branch_address VARCHAR(255),
    Contact_no VARCHAR(15)
);
#EMPLOYEE
CREATE TABLE Employee (
    Emp_Id INT PRIMARY KEY,
    Emp_name VARCHAR(100),
    Position VARCHAR(50),
    Salary DECIMAL(10, 2),
    Branch_no INT,
    FOREIGN KEY (Branch_no) REFERENCES Branch(Branch_no)
);
#BOOKS
CREATE TABLE Books ( 
ISBN VARCHAR(13) PRIMARY KEY, Books_title VARCHAR(255),
Category VARCHAR(100), Rental_Price DECIMAL(8,2),
Status ENUM('yes','no'),
Author VARCHAR(100),
Publisher VARCHAR(100));

#CUSTOMER
CREATE TABLE Customer( Customer_Id INT PRIMARY KEY, Customer_name VARCHAR(100),
Customer_adress VARCHAR(255),
Reg_date DATE );

#ISSUE STATUS
CREATE TABLE IssueStatus (
    Issue_Id INT PRIMARY KEY,
    Issued_cust INT,
    Issued_book_name VARCHAR(255),
    Issue_date DATE,
    Isbn_book VARCHAR(13),
    FOREIGN KEY (Issued_cust) REFERENCES Customer(Customer_Id),
    FOREIGN KEY (Isbn_book) REFERENCES Books(ISBN)
);

#RETURN STATUSemployee
CREATE TABLE ReturnStatus (
    Return_Id INT PRIMARY KEY,
    Return_cust INT,
    Return_book_name VARCHAR(255),
    Return_date DATE,
    Isbn_book2 VARCHAR(13),
    FOREIGN KEY (Return_cust) REFERENCES Customer(Customer_Id),
    FOREIGN KEY (Isbn_book2) REFERENCES Books(ISBN)
);



SHOW TABLES;

#1. Retrieve the book title, category, and rental price of all available books. 
SELECT Books_title, Category, Rental_Price
FROM Books
WHERE Status = 'yes';

#2.List the employee names and their respective salaries in descending order of salary:
SELECT Emp_name, Salary
FROM Employee
ORDER BY Salary DESC;

#3.Retrieve the book titles and the corresponding customers who have issued those books:
SELECT B.Books_title, C.Customer_name
FROM Books B
JOIN IssueStatus I ON B.ISBN = I.Isbn_book
JOIN Customer C ON I.Issued_cust = C.Customer_Id;

#4.Display the total count of books in each category
SELECT Category, COUNT(*) AS Total_Books
FROM Books
GROUP BY Category;

#5.Retrieve the employee names and their positions for the employees whose salaries are above Rs.50,000:
SELECT Emp_name, Position
FROM Employee
WHERE Salary > 50000;

#6.List the customer names who registered before 2022-01-01 and have not issued any books yet:
SELECT C.Customer_name
FROM Customer C
LEFT JOIN IssueStatus I ON C.Customer_Id = I.Issued_cust
WHERE C.Reg_date < '2022-01-01' AND I.Issued_cust IS NULL;

#7Display the branch numbers and the total count of employees in each branch:
SELECT Branch_no, COUNT(*) AS Total_Employees
FROM Employee
GROUP BY Branch_no;

#8.Display the names of customers who have issued books in the month of June 2023:
SELECT C.Customer_name
FROM Customer C
JOIN IssueStatus I ON C.Customer_Id = I.Issued_cust
WHERE I.Issue_date BETWEEN '2023-06-01' AND '2023-06-30';

#9.Retrieve book_title from the Books table containing "history" in the title:
SELECT Books_title
FROM Books
WHERE Books_title LIKE '%history%';

#10.Retrieve the branch numbers along with the count of employees for branches having more than 5 employees:
SELECT Branch_no, COUNT(*) AS Total_Employees
FROM Employee
GROUP BY Branch_no
HAVING COUNT(*) > 5;

#11.Retrieve the names of employees who manage branches and their respective branch addresses:
SELECT E.Emp_name, B.Branch_address
FROM Employee E
JOIN Branch B ON E.Emp_Id = B.Manager_Id;

#12.Display the names of customers who have issued books with a rental price higher than Rs. 25:
SELECT C.Customer_name
FROM Customer C
JOIN IssueStatus I ON C.Customer_Id = I.Issued_cust
JOIN Books B ON I.Isbn_book = B.ISBN
WHERE B.Rental_Price > 25;
