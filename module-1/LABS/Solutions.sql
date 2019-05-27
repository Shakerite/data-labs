SET GLOBAL sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));

create database publications;

use publications;



select *
from jobs
group by max_lvl



select*
from publishers;

select*
from titles;


select p.pub_name, count(t.title_id) as Titles
from publishers p
outer join titles t on t.pub_id=p.pub_id
group by p.pub_name
order by titles desc, pub_name;

#OUTER JOINT = LEFT JOINT UNION RIGHT JOIN
 
select p.pub_name, count(t.title_id) as Titles
from publishers p
left join titles t on t.pub_id = p.pub_id
group by p.pub_name
union
select p.pub_name, count(t.title_id) as Titles
from publishers p
right join titles t on t.pub_id = p.pub_id
group by p.pub_name;


select e.job_id, job_desc, GROUP_CONCAT(hire_date), count(e.job_id)
	from employee e
		inner join jobs j 
		on j.job_id=e.job_id
	group by j.job_desc, e.job_id
	order by e.job_id desc;	
	
select *
from jobs;

select *
from employee;


#Challenge 1

select ta.au_id, a.au_lname, a.au_fname, t.title, p.pub_name
from titleauthor ta
left join authors a on ta.au_id=a.au_id
left join titles t on ta.title_id=t.title_id
inner join publishers p on t.pub_id=p.pub_id;

#Challenge 2


select ta.au_id, a.au_lname, a.au_fname, group_concat(distinct p.pub_name), count(t.title)
	from titleauthor ta
		left join authors a on ta.au_id=a.au_id
		left join titles t on ta.title_id=t.title_id
		inner join publishers p on t.pub_id=p.pub_id
		group by ta.au_id;
		
#Challenge 3

select ta.au_id, a.au_lname, a.au_fname, sum(s.qty)
	from titleauthor ta
		left join authors a on ta.au_id=a.au_id
		inner join sales s on ta.title_id=s.title_id
		group by ta.au_id
		order by sum(s.qty) desc
		limit 3;
		
#Challenge 4

select ta.au_id, a.au_lname, a.au_fname, t.ytd_sales
	from authors a
		left join titleauthor ta on ta.au_id=a.au_id
		left join titles t on t.title_id=ta.title_id;
		
		
		 #LAB ADVANCED MY SQL

#Challenge 1

#Step 1

select ta.title_id, ta.au_id, t.price * s.qty * t.royalty / 100 * ta.royaltyper / 100 as sales_royalty
	from titleauthor ta
		inner join titles t on t.title_id = ta.title_id
		inner join sales s on s.title_id = t.title_id;

#Step 2
;
select ta.title_id, ta.au_id, sum(t.price * s.qty * t.royalty / 100 * ta.royaltyper / 100) as sales_royalty
	from titleauthor ta
		inner join titles t on t.title_id = ta.title_id
		inner join sales s on s.title_id = t.title_id
		group by ta.title_id, ta.au_id
		order by sales_royalty desc;		
		
#Step 3

create temporary table  total_royalty
select ta.title_id, ta.au_id, sum(t.price * s.qty * t.royalty / 100 * ta.royaltyper / 100) as sales_royalty
	from titleauthor ta
		inner join titles t on t.title_id = ta.title_id
		inner join sales s on s.title_id = t.title_id
		group by ta.title_id, ta.au_id;
		
select*
from total_royalty;

create temporary table royalties_advance

select ta.title_id, ta.au_id, sum(tr.sales_royalty + t.advance*ta.royaltyper/100) as total_royalty
	from titleauthor ta
		inner join titles t on t.title_id = ta.title_id
		inner join sales s on s.title_id = t.title_id
		inner join total_royalty tr on ta.au_id = tr.au_id
		group by ta.title_id, ta.au_id
		order by total_royalty desc
		limit 3;
		
select*
from royalties_advance;
		
#CHALLENGE 2 ADDITIONNAL


# step 2 - subqueries
select b.title_id, b.au_id, sum(b.sales_royalty)
from(
select ta.title_id, ta.au_id, t.price * s.qty * t.royalty / 100 * ta.royaltyper / 100 as sales_royalty
	from titleauthor ta
		inner join titles t on t.title_id = ta.title_id
		inner join sales s on s.title_id = t.title_id
		)b
group by title_id, au_id;

#step3- subqueries

select c.au_id, c.profit

from(
select ta.title_id, ta.au_id, t.price * s.qty * t.royalty / 100 * ta.royaltyper / 100 as sales_royalty
	from titleauthor ta
		inner join titles t on t.title_id = ta.title_id
		inner join sales s on s.title_id = t.title_id
		)b
group by title_id, au_id;



#CHALLENGE 3

create table most_profiting_authors (au_id VARCHAR(50), profit INT(50));


INSERT INTO most_profiting_authors (au_id, profit)
	SELECT f.au_id, f.total_royalty
	from royalties_advance f;
	
select*
from most_profiting_authors;

 