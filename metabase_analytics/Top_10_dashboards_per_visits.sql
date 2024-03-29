/*
Query showing top 10 dashboards based on total views, and distribution of total views to show most active dashboards.
Includes a time filter to play with range.
*/
with viewings as(
select
    date(view_log.timestamp) as date
    ,cu.first_name ||  ' ' || cu.last_name as user_name
    , view_log.model as type
--  , case when rc.name is null then rd.name else rc.name end as object_name
    , rd.name as object_name
from view_log
left join core_user as cu on view_log.user_id = cu.id
-- left join report_card as rc on rc.id = view_log.model_id and view_log.model = 'card'
left join report_dashboard as rd on rd.id = view_log.model_id and view_log.model = 'dashboard'
where true
and rd.name is not null
[[and {{timestamp}}]]
order by view_log.timestamp desc
),mid_step as (
select
    object_name
    ,count(*) as views
from viewings
group by 1
order by 2 desc
limit 10
)
select
object_name,
views,
sum(views) over (order by views desc) / sum(views) over () as total_views
from mid_step
order by 2 desc
