
--1. Возвращает список клиентов (имя и фамилия) с наибольшей общей суммой заказов.

select distinct c.firstname, c.LastName, sum(o.totalamount) over (partition by o.customerid ) from Customers as c 
left join orders as o on c.customerid = o.customerid
order by sum desc 
limit 1



--2. Для каждого клиента из пункта 1 выводит список его заказов 
--(номер заказа и общая сумма) в порядке убывания общей суммы заказов.

select o.orderid, o.totalamount  from customers c left join orders o on c.customerid = o.customerid
where o.customerid in (select customerid from
(select distinct c.customerid, c.firstname, c.LastName, sum(o.totalamount) over (partition by o.customerid) from Customers as c 
left join orders as o on c.customerid = o.customerid
order by sum desc 
limit 1))
order by o.totalamount desc 


--3 Выводит только тех клиентов, у которых общая сумма заказов 
--превышает среднюю общую сумму заказов всех клиентов.

select c.firstname, c.lastname from customers c left join 
	(select o.customerid, sum(o.totalamount) from orders o 
		group by o.customerid  ) as tmp 
on c.customerid = tmp.customerid 
where sum > (select avg(o.totalamount) from orders o) 
