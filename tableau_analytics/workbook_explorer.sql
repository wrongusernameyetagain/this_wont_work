-- Query for seeing all dashboards available within your Tableau server, broken down by data freshness, with tags / description.
select 
	 w.name as workbook_name
	,case when length(w.description) < 1  or w.description is null then 'No description'
		  else w.description 
		  end as workbook_description
	,string_agg(distinct t.tag_name,', ') as tag_name
	,'http://tableau.<YOURCOMPANYNAME>.com/#/workbooks/' || w.id as workbook_urls
	,case when extract(epoch from (current_timestamp - updated_at)/3600) < 24 then 'fresh' 
	 when extract(days from (current_timestamp - updated_at)) = 1 then '1 day since last update'
	else extract(days from (current_timestamp - updated_at)) || ' days since last update' end as update_timer
from public.workbooks as w
left join public."_views" as v 
	on v.workbook_id = w.id
left join public."_tags" as t
	on t.object_id = v.id
group by 1,2,4,5
order by 4 asc
