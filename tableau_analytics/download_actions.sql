select 
u.friendly_name
,currentsheet
,case 	when http_request_uri ilike '%crosstab%' then 'excel'
		when http_request_uri ilike '%pdf%' then 'pdf'
		when http_request_uri ilike '%png%' then 'png'
		else 'other'
		end as download_method
,count(*) as cases
from public.http_requests hr 
left join public."_users" u on hr.user_id = u.id
where true 
and http_request_uri ilike '%commands/tabsrv/export%'
--and hr.created_at >= '2021-06-01'. #use this for restricting the time-range
group by 1,2,3
order by 4 desc
