Select OrderID from Orders where Datediff(day, OrderDate, ShippedDate) > 30;

Select concat_ws(' ',LastName, FirstName) as Employee,
sum(UnitPrice * quantity)
from Employees as e
left join Orders as o
on o.EmployeeID = e.EmployeeID
left join [Order Details] as od
on od.OrderID = o.OrderID
group by LastName, firstname
order by LastName

Select top 3 ProductName, UnitPrice from Products
where UnitPrice > 50 order by UnitPrice asc

Select concat_ws(' ', LastName, FirstName) as Employee
from Employees where Salary > (select top 1 salary from employees
								where Title like '%Manager%'
								Order by Salary desc)

Select o.OrderID, count(ProductID) as NombresArticle
from Orders as o
left join [Order Details] as od
on od.OrderID = o.OrderID
group by o.OrderID
having count(ProductID) > 2 and max(od.UnitPrice) < 15

Select CONCAT_WS(' ', LastName, FirstName)
from Employees as e
where ReportsTo = (Select EmployeeID from Employees where FirstName like '%Andrew%')

