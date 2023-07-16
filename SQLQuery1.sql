use Northwind;


--1. Affichez le numéro des commandes dont la différence entre la date d'envoi et la date de 
--commande dépasse 30 jours.
Select OrderID from Orders where Datediff(day, OrderDate, ShippedDate) > 30;

--2. Affichez la liste des employés (nom et prénom séparés d'une virgule et d'une espace) avec le 
--total de leurs ventes. Le total des ventes doit tenir compte de l’escompte. Renommez les
--nouvelles colonnes 'Noms des employés' et 'Total des ventes'. Affichez aussi les employés qui 
--n’ont rien vendu. Triez les enregistrements en ordre croissant de nom d'employé.
Select concat_ws(' ',LastName, FirstName) as Employee,
sum(UnitPrice * quantity)
from Employees as e
left join Orders as o
on o.EmployeeID = e.EmployeeID
left join [Order Details] as od
on od.OrderID = o.OrderID
group by LastName, firstname
order by LastName

--3. Affichez les 3 produits les moins chers coûtant plus de 50 $.
Select top 3 ProductName, UnitPrice from Products
where UnitPrice > 50 order by UnitPrice asc

--4. Affichez la liste des employés dont le salaire dépasse celui d'un chef (manager).

Select concat_ws(' ', LastName, FirstName) as Employee
from Employees where Salary > (select top 1 salary from employees
				where Title like '%Manager%'
				Order by Salary desc)

--5. Affichez le numéro de la commande et le nombre de produits différents d’une commande
--pour les commandes qui ont plus de 2 produits différents coûtant moins de 15$ chacun. 
Select o.OrderID, count(ProductID) as NombresArticle
from Orders as o
left join [Order Details] as od
on od.OrderID = o.OrderID
group by o.OrderID
having count(ProductID) > 2 and max(od.UnitPrice) < 15

--6. Affichez les employés travaillant sous la supervision directe de Andrew Fuller.
Select CONCAT_WS(' ', LastName, FirstName)
from Employees as e
where ReportsTo = (Select EmployeeID from Employees where FirstName like '%Andrew%')

--7. Affichez le numéro de commande et le total pour les commandes dont le total est plus petit 
--que la moyenne des totaux pour les commandes dont la commande est livrée à Sao Paulo, 
--mais plus grande que la moyenne des totaux pour les commandes dont la commande est 
--livrée à Paris. Ne vous préoccupez pas de l’escompte.

--7.1 Affichez le numéro de commande et le total pour les commandes dont le total est plus petit 
--que la moyenne des totaux pour les commandes 

Select o.OrderID, Sum(od.UnitPrice) as Total
from Orders as o
left join [Order Details] as od
on od.OrderID = o.OrderID
group by o.OrderID;


--7.2 la commande est livrée à Sao Paulo,
Select o.OrderID, Sum(od.UnitPrice) as Total
from Orders as o
left join [Order Details] as od
on od.OrderID = o.OrderID
group by o.OrderID
having Sum(od.UnitPrice) Between (Select AVG(od2.UnitPrice) as Total
				from Orders as o2
				left join [Order Details] as od2
				on od2.OrderID = o2.OrderID
				where o2.ShipCity like 'Sao Paulo')


--7.3 mais plus grande que la moyenne des totaux pour les commandes dont la commande est 
--livrée à Paris.

Select o.OrderID, Sum(od.UnitPrice) as Total
from Orders as o
left join [Order Details] as od
on od.OrderID = o.OrderID
group by o.OrderID
having Sum(od.UnitPrice) Between (Select AVG(od2.UnitPrice) as Total
							from Orders as o2
							left join [Order Details] as od2
							on od2.OrderID = o2.OrderID
							where o2.ShipCity like 'Sao Paulo') and  (Select AVG(od3.UnitPrice) as Total
												  from Orders as o3
												  left join [Order Details] as od3
												  on od3.OrderID = o3.OrderID
												  where o3.ShipCity like 'Paris');

--8. Affichez la somme des ventes par année.

Select Year(OrderDate), Sum(UnitPrice)
from Orders as o
left join [Order Details] as od
on od.OrderID = o.OrderID
group by Year(OrderDate);


--9. Affichez le nom et le salaire des employés dont le salaire est supérieur à la moyenne des 
--salaires dans leur département.

Select LastName, Salary from Employees as e
where Salary > (Select AVG(Salary) 
		from Employees as e2
		where e2.DeptID = e.DeptID
		group by DeptID)
