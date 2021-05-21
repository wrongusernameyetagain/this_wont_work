/*
Query designed to show top 10 dashboards in your Metabase instance, with a distribution of users per dashboard.
Includes a time filter to regulate the range.
*/

with viewings as(
select
    date(view_log.timestamp) as date
    ,cu.first_name ||  ' ' || cu.last_name as user_name
    , view_log.model as type
    , rd.name as object_name
from view_log
left join core_user as cu on view_log.user_id = cu.id
left join report_dashboard as rd on rd.id = view_log.model_id and view_log.model = 'dashboard'
where true
and rd.name is not null
[[and {{timestamp}}]]
order by view_log.timestamp desc
), top_10 as
(select object_name, count(*) from viewings group by 1 order by 2 desc limit 10)
select
    top_10.object_name
    ,user_name
    ,count(*) as views
from viewings
left join top_10 on top_10.object_name = viewings.object_name
where top_10.object_name is not null
group by 1,2
order by 3 desc
